//
//  ThreeSelectViewController.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/27.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "ThreeSelectViewController.h"
#import "FileUtils+Report.h"
#import "User.h"
#import "SelectDataModel.h"

@interface ThreeSelectViewController ()<TreeTableCellDelegate>
{
    int firstLayerCount;
    int secondLayerCount;
    int depth;
}
@property (strong, nonatomic) NSArray *searchItems;
@property (strong, nonatomic) NSString *selectedItem;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSArray<SelectDataModel *> *allarray;
@property (strong, nonatomic) NSString *lastTitleString;
@property (strong, nonatomic) NSMutableArray *keyArray;
@property (strong, nonatomic) NSString *firstTitle;
@property (strong, nonatomic) NSString *SecondTitle;
@property (strong, nonatomic) NSMutableArray<Node*> *allNodeArray;

@end


@implementation ThreeSelectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [[User alloc]init];
    _allarray = [NSMutableArray new];
    _allNodeArray = [NSMutableArray new];
    self.searchItems = [FileUtils reportSearchItems:self.user.groupID templateID:self.templateID reportID:self.reportID];
    self.selectedItem = [FileUtils reportSelectedItem:self.user.groupID templateID:self.templateID reportID:self.reportID];
    NSString *reportSelectedItem = [_selectedItem stringByReplacingOccurrencesOfString:@"||" withString:@"•"];
    if((self.selectedItem == NULL || [self.selectedItem length] == 0) && [self.searchItems count] > 0) {
      //  self.selectedItem = [self.searchItems firstObject];
    }
    self.title = reportSelectedItem;
    [self handleData];
   // [self initData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:false];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 40)];
    UIImage *imageback = [[UIImage imageNamed:@"Banner-Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn addSubview:bakImage];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
}


#pragma mark - TreeTableCellDelegate
-(void)cellClick:(Node *)node{
    NSString *ClickItem;
    if (node.depth == depth-1) {
        if (node.depth == 1) {
            NSString *parentName = _allNodeArray[node.parentId].name;
            ClickItem = [NSString stringWithFormat:@"%@||%@", parentName, node.name];
        }
    else if (node.depth == 0){
        ClickItem = [NSString stringWithFormat:@"%@", node.name];
    }
    
    else if (node.depth == 2) {
        NSString *parentName = _allNodeArray[node.parentId].name;
        NSString *fistParentName = _allNodeArray[_allNodeArray[node.parentId].parentId].name;
        ClickItem = [NSString stringWithFormat:@"%@||%@||%@", fistParentName, parentName, node.name];
    }
    NSString *selectedItemPath = [NSString stringWithFormat:@"%@.selected_item", [FileUtils reportJavaScriptDataPath:self.user.groupID templateID:self.templateID reportID:self.reportID]];
    [ClickItem writeToFile:selectedItemPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    }
}


-(void)handleData{
    depth = 0;
    /**
     *  筛选项列表按字母排序，以便于用户查找
     *  self.searchItems 不做任何修改，列表源使用变量 self.dataList
     */
    _allarray = [MTLJSONAdapter modelsOfClass:SelectDataModel.class fromJSONArray:self.searchItems error:nil];
    NSString *allCount = [NSString stringWithFormat:@"%lu",_allarray.count];
    firstLayerCount = [allCount intValue];
    secondLayerCount = 0;
    depth = _allarray[0].deep;
   /* for (int i = 0; i < firstLayerCount; i++) {
        for (int j = 0; j<_allarray[i].infos.count; j++) {
            secondLayerCount ++;
        }
    }*/
    
    [self getNodeArrayData];
}


// 多层如何转成一个个 Node
-(void)getNodeArrayData{
    int secondID = 0;
    int NodeId= 0;
    int firstLayerID = 0;
    if (_allarray.count > 0) {
        for (SelectDataModel * model in _allarray) {
            Node *nodeName = [[Node alloc] initWithParentId:-1 nodeId:NodeId name:model.titles depth:0 expand:YES];
            firstLayerID =NodeId;
            NodeId ++;
            
            [_allNodeArray addObject:nodeName];
            for (SelectDataModel * model1 in model.infos) {
                BOOL isexpand = model.deep >2;
                Node *nodeName = [[Node alloc] initWithParentId:firstLayerID nodeId:NodeId name:model1.titles depth:1 expand:isexpand];
                secondID = NodeId;
                NodeId ++;
                [_allNodeArray addObject:nodeName];
                for (SelectDataModel * model2 in model1.infos) {
                    BOOL isexpand2 = model.deep >3;
                    Node *nodeName = [[Node alloc] initWithParentId:secondID nodeId:NodeId name:model2.titles depth:2 expand:isexpand2];
                    NodeId ++;
                    [_allNodeArray addObject:nodeName];
                }
            }
        }
    }
    
    TreeTableView *tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) withData:_allNodeArray withDeep:depth];
    tableview.treeTableCellDelegate = self;
    [self.view addSubview:tableview];
}


- (void)backAction{
        [super dismissViewControllerAnimated:YES completion:^{
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


@end
