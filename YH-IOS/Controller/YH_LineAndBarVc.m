//
//  YH_LineAndBarVc.m
//  SwiftCharts
//
//  Created by CJG on 17/4/10.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "YH_LineAndBarVc.h"
#import "YH_IOS-Swift.h"
#import "ChartModel.h"


@interface YH_LineAndBarVc () <ChartViewDelegate, IChartAxisValueFormatter>
{
    NSArray<ChartModel *> *barArray;
}

@property (nonatomic, strong) CombinedChartView* chartView;
@property (nonatomic, strong) BarChartDataSet *set1;
@property (nonatomic, assign) BOOL isSelected;
@end

@implementation YH_LineAndBarVc

- (void)viewDidLoad{
    [super viewDidLoad];
    self.isSelected = NO;
    [self addSubViews];
//    [self setData]; 
}

- (void)setWithLineData:(NSArray*)lineData barData:(NSArray*)barData animation:(BOOL)animation{
    CombinedChartData *data = [[CombinedChartData alloc] init];
    
    data.lineData = [self generateLineData:lineData];
    data.barData = [self generateBarData:barData];
    
    _chartView.xAxis.axisMaximum = data.xMax + 0.25;
    _chartView.data = data;
    if (animation) {
        [_chartView animateWithXAxisDuration:0 yAxisDuration:1];
    }
}

- (LineChartData *)generateLineData:(NSArray*)lineData
{
    LineChartData *d = [[LineChartData alloc] init];
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < lineData.count; index++)
    {
        ChartModel* model = lineData[index];
        [entries addObject:[[ChartDataEntry alloc] initWithX:model.x+1 y:model.y]];
    }
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries label:@"Line DataSet"];
    [set setColors:@[[AppColor app_9color]]];
    //[set setColor:[UIColor redColor]];
    set.lineWidth = 2.5;
    [set setCircleColor:[AppColor twoColor]];
    set.circleRadius = 5.0;
    set.circleHoleRadius = 2.5;
    set.drawCirclesEnabled = NO;
    set.fillColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f];
    set.mode = LineChartModeCubicBezier;
    set.drawValuesEnabled = YES;
    set.valueFont = [UIFont systemFontOfSize:10.f];
    set.valueTextColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f];
    set.drawValuesEnabled = NO;
    set.drawHorizontalHighlightIndicatorEnabled = NO;
    set.drawVerticalHighlightIndicatorEnabled = NO;
    set.axisDependency = AxisDependencyLeft;
    set.highlightEnabled = NO;
    [d addDataSet:set];
    
    return d;
}

- (BarChartData *)generateBarData:(NSArray*)barData
{
    barArray = barData;
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    UIColor* selectColor;
     //= [[BarChartDataSet alloc] initWithValues:entries1 label:@"Bar 1"];
    NSMutableArray *colorArray = [[NSMutableArray alloc]init];
    for (int index = 0; index < barData.count; index++)
    {
//        double mult = (range + 1);
//        double val = (double) (arc4random_uniform(mult));
//        [yVals addObject:[[BarChartDataEntry alloc] initWithX:index y:val]];
        ChartModel* model = barArray[index];
        selectColor = model.selectColor;
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:model.x+1 y:model.y]];
        self.set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@"The year 2017"];
        if (index == (barData.count -1)) {
            _isSelected?[colorArray addObject:[AppColor app_9color]]:[colorArray addObject:selectColor];
        }
        else {
            [colorArray addObject:[AppColor app_9color]];
        }
    }
    [_set1 setColors:colorArray];
    
  /*  BarChartDataSet *set1; //= [[BarChartDataSet alloc] initWithValues:entries1 label:@"Bar 1"];
    set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@"The year 2017"];
    [set1 setColors:@[[AppColor app_9color]]];*/
    
    //[set1 setColor:[UIColor redColor]];
    if (selectColor) {
        [_set1 setHighlightColor:selectColor];
    }
    _set1.drawValuesEnabled = NO;
    _set1.axisDependency = AxisDependencyLeft;

    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:_set1];
    
//    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
//    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    
//    data.barWidth = 0.45f;
//    data.barWidth = 0.5f;

    BarChartData *d = [[BarChartData alloc] initWithDataSets:@[_set1]];
    d.barWidth = 0.5;
    // make this BarData object grouped
//    [d groupBarsFromX:10.0 groupSpace:1 barSpace:1]; // start at x = 0
    
    return d;
}
#pragma mark - UI
- (void)addSubViews{
    [self.view addSubview:self.chartView];
    [self makeConstrains];
}

- (void)makeConstrains{
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 懒加载
- (CombinedChartView *)chartView{
    if (!_chartView) {
        _chartView = [[CombinedChartView alloc] initWithFrame:self.view.bounds];
        _chartView.backgroundColor = [UIColor whiteColor];
        _chartView.delegate = self;
        _chartView.chartDescription.enabled = NO;
        _chartView.dragEnabled = YES;
        [_chartView setScaleEnabled:YES];
        _chartView.drawGridBackgroundEnabled = NO;
        _chartView.pinchZoomEnabled = YES;
        _chartView.drawOrder = @[
                                 @(CombinedChartDrawOrderBar),
                                 @(CombinedChartDrawOrderLine)
                                 ];
        
        
        ChartLegend *l = _chartView.legend;
        l.form = ChartLegendFormLine;
        l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
        l.textColor = UIColor.clearColor;
        l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
        l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
        l.orientation = ChartLegendOrientationHorizontal;
        l.formLineWidth = 3;
        l.enabled = NO;
        l.drawInside = NO;;
        
        ChartXAxis *xAxis = _chartView.xAxis;
        xAxis.labelFont = [UIFont systemFontOfSize:11.f];
        xAxis.labelTextColor = [AppColor app_4color];
        xAxis.drawGridLinesEnabled = NO;
        xAxis.drawAxisLineEnabled = YES;
        //        xAxis.yOffset = -20;
        xAxis.valueFormatter = self;
        xAxis.axisMinimum = 0.5;
        xAxis.labelPosition = UIRectEdgeTop;
        xAxis.enabled = YES;
        xAxis.granularity = 1;
        xAxis.spaceMin = 1;
        xAxis.granularityEnabled = YES;
        //        xAxis.yOffset = 20;
        
        ChartYAxis *leftAxis = _chartView.leftAxis;
        leftAxis.labelTextColor = UIColorHex(a8a8a8);
        leftAxis.axisMinimum = 0.0;
        leftAxis.drawGridLinesEnabled = NO;
        leftAxis.drawZeroLineEnabled = NO;
        leftAxis.granularityEnabled = YES;
        leftAxis.axisLineColor = [UIColor clearColor];
        leftAxis.xOffset = 20;
        //        ChartYAxis *rightAxis = _chartView.rightAxis;
        //        rightAxis.labelTextColor = UIColor.redColor;
        //        rightAxis.axisMaximum = 900.0;
        //        rightAxis.axisMinimum = -200.0;
        //        rightAxis.drawGridLinesEnabled = NO;
        //        rightAxis.granularityEnabled = NO;
        _chartView.rightAxis.enabled = NO;
        
        
//        YHMarkerV *marker = [YHMarkerV viewWithXibName:@"YHMarkerV" owner:nil];
//        marker.backgroundColor = [UIColor whiteColor];
//        [marker setBorderColor:UIColorHex(51aa38) width:1 cornerRadius:3];
//        marker.frame = CGRectMake(0, 0, 120, 100);
//        marker.offset = CGPointMake(-60, -105);
//        marker.chartView = _chartView;
//        _chartView.marker = marker;
        
        
    }
    return _chartView;
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    self.isSelected = true;
    DLog(@"chartValueSelected");
    double value = highlight.x;
    NSInteger index = (int)value;
    if (value>=1) {
        if (self.selectBack) {
            self.selectBack(@(index-1));
        }
    }
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    
    DLog(@"chartValueNothingSelected");
}

#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
//    if (value<1) {
//        return @" ";
//    }
    NSInteger index = (int)value;
    if (value<1) {
        return @" ";
    }
    return barArray[index-1].xString;
//    return barArray[(int)value % barArray.count].xString;
}




@end
