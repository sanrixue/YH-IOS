//
//  YHLinechart1Vc.m
//  SwiftCharts
//
//  Created by CJG on 17/3/31.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "YHLinechart1Vc.h"
#import "ChartHeaderView.h"
#import "IntAxisValueFormatter.h"
#import "YH_IOS-Swift.h"

@interface YHLinechart1Vc () <ChartViewDelegate>
@property (nonatomic, strong) ChartHeaderView* chartHeaderView;
@property (nonatomic, strong) LineChartView* chartView;
@property (nonatomic, strong) NSArray* dataArr;
@property (nonatomic, strong) LineChartDataSet* set1;
@property (nonatomic, strong) NSMutableArray* clearColors;

@end

@implementation YHLinechart1Vc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(f2f2f2);
    self.dataArr = @[
                     @"1月",
                     @"2月",
                     @"3月",
                     @"4月",
                     @"5月",
                     @"6月",
                     @"7月"
                     ];
    [self.view addSubview:self.chartHeaderView];
    [self.view addSubview:self.chartView];
    [self.chartHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(125);
    }];
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.chartHeaderView);
        make.top.mas_equalTo(self.chartHeaderView.mas_bottom);
        make.height.mas_equalTo(480.0/750.0*SCREEN_WIDTH);
    }];
}

- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    count = (int)self.dataArr.count;
    for (int i = 0; i < count; i++)
    {
        double mult = range / 2.0;
        double val = (double) (arc4random_uniform(mult)) + 50;
        ChartDataEntry *enter = [[ChartDataEntry alloc] initWithX:i y:val];
        enter.data = @"哈哈哈哈";
        [yVals1 addObject:enter];
    }
    
    for (int i = 0; i < count - 1; i++)
    {
        double mult = range;
        double val = (double) (arc4random_uniform(mult)) + 450;
        [yVals2 addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }
    
    LineChartDataSet *set1 = nil, *set2 = nil;
    
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set2 = (LineChartDataSet *)_chartView.data.dataSets[1];
        set1.values = yVals1;
        set2.values = yVals2;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:yVals1 label:@"DataSet 1"];
        set1.mode = LineChartModeHorizontalBezier;
        set1.axisDependency = AxisDependencyLeft;
        [set1 setColor:[AppColor oneColor]];
//        [set1 setCircleColor:UIColor.whiteColor];
        set1.fillAlpha = 65/255.0;
        set1.fillColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
        set1.valueTextColor = [UIColor clearColor];
        set1.lineWidth = 2.5;
        set1.circleRadius = 4.0;
        set1.circleHoleRadius = 2.0;
        set1.drawCircleHoleEnabled = NO;
        set1.drawHorizontalHighlightIndicatorEnabled = NO;
        set1.highlightColor = [AppColor oneColor];

        _clearColors = [NSMutableArray new];
        for (int i=0; i<count; i++) {
            [_clearColors addObject:[UIColor clearColor]];
        }
        set1.circleColors = _clearColors;
//        [set1 setCircleColor:[AppColor oneColor]];
        
        set2 = [[LineChartDataSet alloc] initWithValues:yVals2 label:@"DataSet 2"];
        set2.mode = LineChartModeHorizontalBezier;
        set2.valueTextColor = [UIColor clearColor];
        set2.drawHorizontalHighlightIndicatorEnabled = NO;
        set2.axisDependency = AxisDependencyRight;
        [set2 setColor:UIColor.redColor];
        [set2 setCircleColor:UIColor.whiteColor];
        set2.lineWidth = 2.0;
        set2.circleRadius = 3.0;
        set2.fillAlpha = 65/255.0;
        set2.fillColor = UIColor.redColor;
        set2.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
        set2.drawCircleHoleEnabled = NO;
        set2.drawCirclesEnabled = 0;
        set2.valueTextColor = [UIColor clearColor];
    
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        _set1 = set1;
        [dataSets addObject:set2];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueTextColor:UIColor.clearColor];
        [data setValueFont:[UIFont systemFontOfSize:9.f]];
        
        
        

        
        _chartView.data = data;
        [_chartView animateWithXAxisDuration:1 yAxisDuration:1];

    }
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    
//    [self.chartView reloadInputViews];

    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis{
    NSInteger count = [NSNumber numberWithDouble:value].integerValue;
    if (count<self.dataArr.count) {
        return self.dataArr[count];
    }
    return @" ";//self.dataArr[count];
}

- (ChartHeaderView *)chartHeaderView{
    if (!_chartHeaderView) {
        _chartHeaderView = [ChartHeaderView viewWithXibName:nil owner:nil];
    }
    return _chartHeaderView;
}

- (LineChartView *)chartView{
    if (!_chartView) {
        _chartView = [[LineChartView alloc] init];
        _chartView.backgroundColor = [UIColor whiteColor];
        
        
        _chartView.delegate = self;
        _chartView.chartDescription.enabled = NO;
        _chartView.dragEnabled = YES;
        [_chartView setScaleEnabled:YES];
        _chartView.drawGridBackgroundEnabled = NO;
        _chartView.pinchZoomEnabled = YES;
        
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
        xAxis.labelTextColor = [AppColor oneColor];
        xAxis.drawGridLinesEnabled = NO;
        xAxis.drawAxisLineEnabled = YES;
//        xAxis.yOffset = -20;
        xAxis.valueFormatter = self;
        xAxis.axisMaximum = self.dataArr.count;
        xAxis.axisMinimum = 0;
        xAxis.labelPosition = UIRectEdgeTop;
        xAxis.enabled = YES;
//        xAxis.yOffset = 20;

        ChartYAxis *leftAxis = _chartView.leftAxis;
        leftAxis.labelTextColor = UIColorHex(a8a8a8);
        leftAxis.axisMaximum = 400.0;
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
        
        
        
        YHMarkerV *marker = [YHMarkerV viewWithXibName:@"YHMarkerV" owner:nil];
        marker.backgroundColor = [UIColor whiteColor];
        [marker setBorderColor:UIColorHex(51aa38) width:1 cornerRadius:3];
        marker.frame = CGRectMake(0, 0, 120, 100);
        marker.offset = CGPointMake(-60, -105);
        marker.chartView = _chartView;
        _chartView.marker = marker;
        
        
        [self setDataCount:5 range:30];
    }
    return _chartView;
}


@end

@implementation YHLine1Fommater

//- val

@end
