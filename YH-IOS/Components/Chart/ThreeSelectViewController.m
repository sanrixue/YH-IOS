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


-(void)initData{
    
    //----------------------------------中国的省地市关系图3,2,1--------------------------------------------
    Node *country1 = [[Node alloc] initWithParentId:-1 nodeId:0 name:@"中国" depth:0 expand:YES];
    Node *province1 = [[Node alloc] initWithParentId:0 nodeId:1 name:@"江苏" depth:1 expand:NO];
    Node *city1 = [[Node alloc] initWithParentId:1 nodeId:2 name:@"南通" depth:2 expand:NO];
    //Node *subCity1 = [[Node alloc] initWithParentId:2 nodeId:100 name:@"通州" depth:3 expand:NO];
    //Node *subCity2 = [[Node alloc] initWithParentId:2 nodeId:101 name:@"如东" depth:3 expand:NO];
    Node *city2 = [[Node alloc] initWithParentId:1 nodeId:3 name:@"南京" depth:2 expand:NO];
    Node *city3 = [[Node alloc] initWithParentId:1 nodeId:4 name:@"苏州" depth:2 expand:NO];
    Node *province2 = [[Node alloc] initWithParentId:0 nodeId:5 name:@"广东" depth:1 expand:NO];
    Node *city4 = [[Node alloc] initWithParentId:5 nodeId:6 name:@"深圳" depth:2 expand:NO];
    Node *city5 = [[Node alloc] initWithParentId:5 nodeId:7 name:@"广州" depth:2 expand:NO];
    Node *province3 = [[Node alloc] initWithParentId:0 nodeId:8 name:@"浙江" depth:1 expand:NO];
    Node *city6 = [[Node alloc] initWithParentId:8 nodeId:9 name:@"杭州" depth:2 expand:NO];
    //----------------------------------美国的省地市关系图0,1,2--------------------------------------------
    Node *country2 = [[Node alloc] initWithParentId:-1 nodeId:10 name:@"美国" depth:0 expand:YES];
    Node *province4 = [[Node alloc] initWithParentId:10 nodeId:11 name:@"纽约州" depth:1 expand:NO];
    Node *province5 = [[Node alloc] initWithParentId:10 nodeId:12 name:@"德州" depth:1 expand:NO];
    Node *city7 = [[Node alloc] initWithParentId:12 nodeId:13 name:@"休斯顿" depth:2 expand:NO];
    Node *province6 = [[Node alloc] initWithParentId:10 nodeId:14 name:@"加州" depth:1 expand:NO];
    Node *city8 = [[Node alloc] initWithParentId:14 nodeId:15 name:@"洛杉矶" depth:2 expand:NO];
    Node *city9 = [[Node alloc] initWithParentId:14 nodeId:16 name:@"旧金山" depth:2 expand:NO];
    
    //----------------------------------日本的省地市关系图0,1,2--------------------------------------------
    Node *country3 = [[Node alloc] initWithParentId:-1 nodeId:17 name:@"日本" depth:0 expand:YES];
    Node *province7 = [[Node alloc] initWithParentId:17 nodeId:18 name:@"东京" depth:1 expand:NO];
    Node *province8 = [[Node alloc] initWithParentId:17 nodeId:19 name:@"东京1" depth:1 expand:NO];
    Node *province9 = [[Node alloc] initWithParentId:17 nodeId:20 name:@"东京2" depth:1 expand:NO];
    
    
    //NSArray *data = [NSArray arrayWithObjects:country1,country2,country3, nil];
    
    //NSArray *data = [NSArray arrayWithObjects:country1,province1,province2,province3,country2,province4,province5,province6,country3, nil];
    
    NSArray *data = [NSArray arrayWithObjects:country1,province1,city1,city2,city3,province2,city4,city5,province3,city6,country2,province4,province5,city7,province6,city8,city9,country3,province7,province8,province9, nil];
    
    
    TreeTableView *tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) withData:data];
    tableview.treeTableCellDelegate = self;
    [self.view addSubview:tableview];
}


#pragma mark - TreeTableCellDelegate
-(void)cellClick:(Node *)node{
    if (node.depth == 2) {
        NSString *parentName = _allNodeArray[node.parentId].name;
        NSString *fistParentName = _allNodeArray[_allNodeArray[node.parentId].parentId].name;
       /* for (Node *nodeParent in _allNodeArray) {
            if (nodeParent.nodeId == node.parentId) {
                parentName = nodeParent.name;
            }
        }*/
        NSLog(@"%@------>%@ ----> %@",node.name,parentName,fistParentName);
        NSString *ClickItem = [NSString stringWithFormat:@"%@||%@||%@", fistParentName, parentName, node.name];
        NSString *selectedItemPath = [NSString stringWithFormat:@"%@.selected_item", [FileUtils reportJavaScriptDataPath:self.user.groupID templateID:self.templateID reportID:self.reportID]];
        [ClickItem writeToFile:selectedItemPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}


- (NSString *)getdata{
    
    return  @"data:[{\"titles\":\"201612\",\"infos\":[{\"titles\":\"世界村店\",\"infos\":[\"休闲食品\",\"健康有机生活馆\",\"加工\"]},{\"titles\":\"东城万达店\",\"infos\":[\"后勤小店\",\"家用文体家电\",\"干性杂货日配\"]}]}, {\"titles\": \"201701\",\"infos\": [{\"titles\": \"东方伟业广场店\",\"infos\": [ \"后勤小店\",\"家居生活馆\",\"干性杂货日配\"]},{\"titles\": \"东方名城店\",\"infos\": [ \"健康有机生活馆\",\"家用文体家电\",\"干性杂货日配\"]},{\"titles\": \"中南城店\",\"infos\": [ \"电商小店\",\"肉禽水产\",\"干性杂货日配\",\"清洁用品\"]}]}]";
}

-(void)handleData{
    /**
     *  筛选项列表按字母排序，以便于用户查找
     *  self.searchItems 不做任何修改，列表源使用变量 self.dataList
     */
   // [_allarray removeAllObjects];
    _allarray = [MTLJSONAdapter modelsOfClass:SelectDataModel.class fromJSONArray:self.searchItems error:nil];
    NSString *allCount = [NSString stringWithFormat:@"%lu",_allarray.count];
    firstLayerCount = [allCount intValue];
    secondLayerCount = 0;
    for (int i = 0; i < firstLayerCount; i++) {
        for (int j = 0; j<_allarray[i].infos.count; j++) {
            secondLayerCount ++;
        }
    }
    [self getNodeArrayData];
    
    //self.searchItems = [self.searchItems sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
   /* self.keyArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.searchItems.count; i++) {
        NSArray *array= [self.searchItems[i] componentsSeparatedByString:@"||"];
        [_keyArray addObject:array[0]];
       // SelectDataModel *model = [[SelectDataModel alloc]initWithFirst:array[0] withSeconArray:@{array[1]:array[2]}];
        [self.allarray addObject:array];
    }
    
    [self getTwoLayerData];
    */
}


// 多层如何转成一个个 Node
-(void)getNodeArrayData{
    NSString *allCount = [NSString stringWithFormat:@"%lu",_allarray.count];
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

                Node *nodeName = [[Node alloc] initWithParentId:firstLayerID nodeId:NodeId name:model1.titles depth:1 expand:NO];
                secondID = NodeId;
                NodeId ++;
                [_allNodeArray addObject:nodeName];
                for (SelectDataModel * model2 in model1.infos) {
                    Node *nodeName = [[Node alloc] initWithParentId:secondID nodeId:NodeId name:model2.titles depth:2 expand:NO];
                    NodeId ++;
                    [_allNodeArray addObject:nodeName];
                }
            }
        }
    }
    
    TreeTableView *tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) withData:_allNodeArray];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
