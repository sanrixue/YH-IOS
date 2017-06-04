//
//  TableViewAndCollectionPackage.h
//  JinXiaoEr
//
//  Created by cjg on 16/11/22.
//
//

#import <Foundation/Foundation.h>

typedef void(^commonCellOnclick)(UIViewController* vc, id model);
typedef void(^commonCellSubViewOnclick)(UIView* cell, id model);


@interface PackageConfig : NSObject

@property (nonatomic, assign) CGFloat estimateHeight;
@property (nonatomic, assign) CGFloat rowHeight;
/** cell实例 需要block赋值 */
@property (nonatomic, strong) UIView* cell;
/**  row数量或者item数量 */
@property (nonatomic, assign) NSInteger cellNum;
@property (nonatomic, assign) NSInteger sectionNum;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) UIView* header;
@property (nonatomic, strong) UIView* footer;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, assign) BOOL notSelectionStyle;

@end

typedef void(^CellBack)(NSIndexPath* indexPath, PackageConfig* config);
typedef void(^CellNumBack)(NSInteger section, PackageConfig* config);
typedef void(^CellSizeBack)(NSIndexPath* indexPath, PackageConfig* config);

typedef void(^SectionNumBack)(PackageConfig* config);
typedef void(^HeaderBack)(NSInteger section, PackageConfig* config);
typedef void(^FooterBack)(NSInteger section, PackageConfig* config);
typedef void(^HeaderSizeBack)(NSInteger section, PackageConfig* config);
typedef void(^FooterSizeBack)(NSInteger section, PackageConfig* config);

typedef void(^SelectedBack)(NSIndexPath* indexPath);



@protocol TableViewAndCollectionPackageDelegate <NSObject>
@optional
/** 上拉刷新 */
- (void)upRefesh;
/** 下拉刷新 */
- (void)downRefresh;
@end

@interface TableViewAndCollectionPackage : NSObject
/** 刷新的代理, */
@property (nonatomic, weak) id<TableViewAndCollectionPackageDelegate> delegate;
@property (nonatomic, strong) MJRefreshHeader* refresh_header;
@property (nonatomic, strong) MJRefreshFooter* refresh_footer;
@property (nonatomic, strong) UIScrollView* scrollView;


/** 只实现上下拉的方法 */
+ (instancetype)instantWithScrollView:(UIScrollView*)scrollView
                             delegate:(id<TableViewAndCollectionPackageDelegate>)delegate;


/**
 tableView和colletionView简单封装

 @param scrollView     scrollView
 @param delegate       刷新的代理,如果实现该代理就带刷新,不实现就不带刷新
 @param cellback       cell的回调,用户自行设置config.cell来决定返回值
 @param sectionNumBack section数量回调,自行设置config的sectionNum属性,如果是tableView必须在这个block设置config近似高度属性
 @param cellSizeBack   可以在sectionNumBack中设置,如果已设置 可以为nil
 @param cellNumBack    可以在sectionNumBack中设置,如果已设置 可以为nil
 @param selectedBack   点击回调

 @return 封装的实例
 */
+ (instancetype)instanceWithScrollView:(UIScrollView*)scrollView
                            delegate:(id<TableViewAndCollectionPackageDelegate>)delegate
                            cellBack:(CellBack)cellback
                         sectionNumBack:(SectionNumBack)sectionNumBack //如果是tableView近似高度必须在这个block 明确定义
                       cellSizeBack:(CellSizeBack)cellSizeBack
                       cellNumBack:(CellNumBack)cellNumBack
                        selectedBack:(SelectedBack)selectedBack;

/**
 给封装的package对象添加header或footer

 @param headerBack     header回调
 @param headerSizeBack header大小回调
 @param footerBack     footer回调
 @param footerSizeBack footer大小回调
 */
- (void)addHeaderBack:(HeaderBack)headerBack
       headerSizeBack:(HeaderSizeBack)headerSizeBack
         orFooterBack:(FooterBack)footerBack
       footerSizeBack:(FooterSizeBack)footerSizeBack;

/** 结束刷新并且刷新数据 */
- (void)reloadData;
/** 开始下拉刷新 */
- (void)beginRefresh;
/** 无更多数据 */
- (void)setNoMoreData:(BOOL)noMore;
/** 结束刷新 */
- (void)endRefresh;

@end


