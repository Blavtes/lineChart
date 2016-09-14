//
//  ZCLineChart.m
//  LineChart
//
//  Created by yong on 16/3/31.
//  Copyright © 2016年 yong. All rights reserved.
//

#import "LineChartModel.h"

#import "LineChart.h"
#import "MyFundDetailDataModel.h"

static CGFloat const kCurrentTreTopViewHeight = 98.5f;
static CGFloat const kHorizontalSpaceWidth = 15.0f;
static CGFloat const kMiddleSpaceWidth = 54.5f;
static CGFloat const kChartViewHeight = 213.0f;
static CGFloat const kQiRiViewHeight = 40;
static CGFloat const kSpaceWidth = 20.0f;

static float const kYOffSet = 0.05f;

@implementation LineChartModel
+ (CGRect)drawRect
{
    return CGRectMake(0, kQiRiViewHeight, MAIN_SCREEN_WIDTH, kChartViewHeight + kSpaceWidth  * 2);
}

+ (LCLineChartView *)drawChartViewQuaterData
{
    NSMutableArray* xArray = [[NSMutableArray alloc] initWithCapacity:7];
    

    [xArray addObject:@"09-02"];
    [xArray addObject:@"09-14"];
    [xArray addObject:@"09-28"];
    [xArray addObject:@"10-02"];
    [xArray addObject:@"10-13"];
    [xArray addObject:@"10-22"];
    [xArray addObject:@"10-31"];
    NSMutableArray *yArray = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithObjects:@[@[@"3.7543",@"1.7563",@"2.7543",@"4.7553",@"2.7554",@"1.7545",@"2.7543"],@"年化"] forKeys:@[kDATAARRAY_KEY,@"title"]];
        //    [yArray addObject:dict];
    [yArray addObject:newDict];
    
    
    LineChartView *lineChartView = [LineChartModel drawChartViewBeginTime:@"09-02" EndTime:@"10-31" Rect:[LineChartModel drawRect] XArray:xArray YArray:yArray];
    
    lineChartView.clipsToBounds = NO;
    lineChartView.drawLinePoints = YES;
    
    [lineChartView addSubview:[LineChartModel updateView:@"10-31"]];
    
    return lineChartView;
}

+ (LCLineChartView *)drawChartViewTestData
{
    NSMutableArray* xArray = [[NSMutableArray alloc] initWithCapacity:7];
    
    for (int i = 7; i > 0; i--) {
        NSDate *senddate=[NSDate date];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:kDATE_FORMAT_Str];
        NSTimeInterval timeStart = 24 * 3600 * i;
        
        NSDate *oldData = [senddate dateByAddingTimeInterval:-timeStart];
        NSString *startDate = [dateformatter stringFromDate:oldData];
        [xArray addObject:startDate];
    }
    
    NSMutableArray *yArray = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithObjects:@[@[@"3.7543",@"2.7563",@"2.7543",@"2.7553",@"2.7554",@"2.7545",@"2.7543"],@"年化"] forKeys:@[kDATAARRAY_KEY,@"title"]];
        //    [yArray addObject:dict];
    [yArray addObject:newDict];
    
    NSDate *senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:kDATE_FORMAT_Str];
    
        //    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSTimeInterval timeStart = 24 * 3600 * 7;
    
    NSDate *oldData = [senddate dateByAddingTimeInterval:-timeStart];
    NSString *startDate = [dateformatter stringFromDate:oldData];
        //7个节点
    NSTimeInterval timeEnd = 24 * 3600 * 1;
    
    NSDate *lastData = [senddate dateByAddingTimeInterval:-timeEnd];
    NSString *endDate = [dateformatter stringFromDate:lastData];
    
    
    LineChartView *lineChartView = [LineChartModel drawChartViewBeginTime:startDate EndTime:endDate Rect:[LineChartModel drawRect] XArray:xArray YArray:yArray];
    
    lineChartView.clipsToBounds = NO;
    lineChartView.drawLinePoints = YES;

    [lineChartView addSubview:[LineChartModel updateView:endDate]];
    
    return lineChartView;
}

+ (UIView *)updateView:(NSString *)endDate
{
    UILabel *upDataLb = [[UILabel alloc] initWithFrame:CGRectMake(kSpaceWidth / 2, kChartViewHeight - kSpaceWidth, MAIN_SCREEN_WIDTH - kSpaceWidth, CommonLbHeight)];
    upDataLb.textAlignment = NSTextAlignmentRight;
    
    upDataLb.text = FMT_STR(@"数据日期：%@",endDate);
    
    upDataLb.font = [UIFont systemFontOfSize:kCommonFontSizeSmall];
    upDataLb.textColor = COMMON_LIGHT_GREY_COLOR;
    return upDataLb;
}

+ (LCLineChartView *)drawChartViewWithDetailModel:(MyFundDetailDataModel *)detailModel
{
    NSMutableArray *xArray = [[NSMutableArray alloc] initWithCapacity:7];
    NSMutableArray *valueArray = [[NSMutableArray alloc] initWithCapacity:7];
    NSString *endDateStr = ((MyFundDetailDatasDataModel*)[detailModel.datas objectAtIndex:0]).date;
    
    for (int i = 6; i >= 0 && detailModel.datas.count > 6; i--) {
        NSString *dateStr = ((MyFundDetailDatasDataModel*)[detailModel.datas objectAtIndex:i]).date ;
        NSString *date  = dateStr;
        if (dateStr.length > 6) {
            date = [dateStr substringFromIndex:5];
        }
        [valueArray addObject:((MyFundDetailDatasDataModel*)[detailModel.datas objectAtIndex:i]).growthRate];
        [xArray addObject:date];
    }
    
    NSMutableArray *yArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [newDict setValue:valueArray forKey:kDATAARRAY_KEY];
    [newDict setValue:@"年化" forKey:@"title"];
    [yArray addObject:newDict];
    
    NSString *startDateStr = ((MyFundDetailDatasDataModel*)[detailModel.datas objectAtIndex:6]).date;
    NSString *endDate = endDateStr;
    NSString *startDate = startDateStr;
    if (endDateStr.length > 6 || startDateStr.length > 6) {
            //日期格式截取
        endDate = [endDateStr substringFromIndex:5];
        startDate = [startDateStr substringFromIndex:5];
    }
    
    LineChartView *lineChartView = [LineChartModel drawChartViewBeginTime:startDate EndTime:endDate Rect:[LineChartModel drawRect] XArray:xArray YArray:yArray];
    lineChartView.drawLinePoints = YES;

    if (detailModel.datas.count > 0) {
        [lineChartView addSubview:[LineChartModel updateView:((MyFundDetailDatasDataModel*)[detailModel.datas firstObject]).date]];
    }
    return lineChartView;
}

+ (LCLineChartView *)drawChartViewBeginTime:(NSString *)beginTIme EndTime:(NSString *)endTime Rect:(CGRect)rect XArray:(NSMutableArray *)xArray YArray:(NSMutableArray *)yArray{
    
    NSMutableArray *colorArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        [colorArray addObject:kLINECHART_COLOR];
    }
    
    //最大值 最小值分5份显示y轴 刻度
//    float max = 5.5;
//    float min = 1.5;
    float max = [LineChartModel findMaxValue:yArray];
    float min = [LineChartModel findMinValue:yArray];

    NSMutableArray *numberArray = [[NSMutableArray alloc] init];

    float maxM = max + kYOffSet;
    float minN = min - kYOffSet;

    [LineChartModel initYValueArray:numberArray maxM:maxM minN:minN offSet:kYOffSet];
    
    //时间差
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setDateFormat:kDATE_FORMAT_Str];
  
    NSDate *date1 = [dateFormatter dateFromString:beginTIme];
    NSDate *date2 = [dateFormatter dateFromString:endTime];
    
    //画图
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
    [newDateFormatter setDateFormat:kDATE_FORMAT_Str];
//    [newDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    for (NSInteger i = 0; i < yArray.count; i++) {
        NSArray *newYArray = [yArray[i] objectForKey:kDATAARRAY_KEY];
        LCLineChartData *lineChart = [LCLineChartData new];
        lineChart.xMin = [date1 timeIntervalSinceReferenceDate];
        lineChart.xMax = [date2 timeIntervalSinceReferenceDate];
        lineChart.title = [yArray[i] objectForKey:@"title"];
        lineChart.color = colorArray[i];
        lineChart.itemCount = xArray.count;
        lineChart.getData = ^(NSUInteger item){
            float x = [[newDateFormatter dateFromString:xArray[item]] timeIntervalSinceReferenceDate];
            float y = [newYArray[item] floatValue];
            NSString *label1 = [NSString stringWithFormat:@"%@",xArray[item]];
            NSString *label2 = [NSString stringWithFormat:@"%@",newYArray[item]];

            return [LCLineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
        };
        [array addObject:lineChart];
    }
    
    LCLineChartView *chartView = [[LCLineChartView alloc] initWithFrame:rect];
    chartView.yMin = minN;
    chartView.yMax = maxM;
    chartView.ySteps = numberArray;
    chartView.xStepsCount = kTITLELABLE_COUNT;
    chartView.data = array;
    //单位
 
    [LineChartModel showUnitView:chartView unit:@"%" dateArray:xArray viewRect:rect];
    
    return chartView;

    
}

/**
 *  获取y轴刻度数据
 *
 *  @param numberArray y值分刻度数据
 *  @param maxM        y 值中最大值
 *  @param minN        y 值中最小值
 *  @param offSet      数据偏移
 */
+ (void)initYValueArray:(NSMutableArray*)numberArray maxM:(float)maxM minN:(float)minN offSet:(float)offSet
{
    float a = (maxM - minN) / 4.0f;
    if (maxM <= 0) {
        for (int i = 6 ; i >= 0 ; i--) {
            [numberArray addObject:[NSString stringWithFormat:@"%d.00",i]];
        }
    } else {
        [numberArray addObject:[NSString stringWithFormat:@"%.4f",maxM + offSet]];
        [numberArray addObject:[NSString stringWithFormat:@"%.4f",maxM]];
        [numberArray addObject:[NSString stringWithFormat:@"%.4f",minN + 3 * a ]];
        [numberArray addObject:[NSString stringWithFormat:@"%.4f",minN + 2 * a ]];
        [numberArray addObject:[NSString stringWithFormat:@"%.4f",minN + a ]];
        [numberArray addObject:[NSString stringWithFormat:@"%.4f",minN]];
    //    [numberArray addObject:[NSString stringWithFormat:@"%.4f",1]];
        [numberArray addObject:[NSString stringWithFormat:@"%.4f",0.0f]];
    }
}

/**
 *  折线图 x 轴 日期显示，标题显示
 *
 *  @param chartView 折线图
 *  @param unit      单位
 *  @param dateArray 日期数组
 *  @param rect      视图rect
 */
+ (void)showUnitView:(UIView*)chartView unit:(NSString*)unit dateArray:(NSArray*)dateArray viewRect:(CGRect)rect
{
//    CGFloat labelXStart = ((isRetina || iPhone5) ? 20 : 34);
//    UILabel* unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelXStart, -30, 200, 21)];
//    unitLabel.backgroundColor = [UIColor clearColor];
//    unitLabel.textColor =  kXAXIS_COLOR;
//    unitLabel.font = [UIFont systemFontOfSize:12.0];
//    unitLabel.text = [NSString stringWithFormat:@"七日年化收益率 ( %@ )",unit];
//    [chartView addSubview:unitLabel];
    
    for (int i = 0; i < dateArray.count; i++) {
        CGFloat xStart = 55;
        CGFloat  availableWidth = chartView.frame.size.width - xStart - 20;
        CGFloat widthPerStep = availableWidth / (dateArray.count - 1);
        CGFloat xDateLabelOffSet = xStart - 25;
        CGFloat yDateLabelOffSet = 36;
        
        if (iPhone6Plus) {
            xDateLabelOffSet -= 4;
        }
        UILabel * dateDabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(i * widthPerStep + xDateLabelOffSet , rect.size.height - yDateLabelOffSet - 40, (chartView.frame.size.width / (kTITLELABLE_COUNT +1 )), 21)];
        dateDabel_1.backgroundColor = [UIColor clearColor];
        dateDabel_1.font = [UIFont systemFontOfSize:11];
        dateDabel_1.text = [dateArray objectAtIndex:i];
        dateDabel_1.textAlignment = NSTextAlignmentCenter;
        dateDabel_1.textColor = kXAXIS_COLOR;
        [chartView addSubview:dateDabel_1];
        
    }
}

/**
 *  找出y值中的最大值
 *
 *  @param yArray 数据
 *
 *  @return 最大值
 */
+ (float)findMaxValue:(NSArray*)yArray
{
    NSMutableArray *maxArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i <yArray.count; i++) {
        NSArray *array = [[yArray objectAtIndex:i] objectForKey:kDATAARRAY_KEY];
        float max = [[array valueForKeyPath:@"@max.floatValue"] floatValue];
        [maxArray addObject:[NSString stringWithFormat:@"%.4f",max]];
    }
    
    //最大值
    float yMax = [[maxArray valueForKeyPath:@"@max.floatValue"] floatValue];
    return yMax;
}

/**
 *  找出y值中的最小值
 *
 *  @param yArray 数据
 *
 *  @return 最小值
 */
+ (float)findMinValue:(NSArray*)yArray
{
    NSMutableArray *minArray = [[NSMutableArray alloc] init];
//    DLog(@"findMinValue arr %@",yArray );
    for (NSInteger i = 0; i < yArray.count; i++) {
        NSArray *array = [[yArray objectAtIndex:i] objectForKey:kDATAARRAY_KEY];
        float min = [[array valueForKeyPath:@"@min.floatValue"] floatValue];
        [minArray addObject:[NSString stringWithFormat:@"%.4f",min]];
    }
    
    //最小值
    float yMin = [[minArray valueForKeyPath:@"@min.floatValue"] floatValue];
    return yMin;
}
@end

@interface LineChartShowView ()
@property (nonatomic, weak) UIButton *weekBt;
@property (nonatomic, weak) UIButton *monthBt;
@property (nonatomic, weak) UIButton *quaterBt;
@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation LineChartShowView

- (instancetype)initWithData:(MyFundDetailDataModel *)model
{
    if (self = [super initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, [LineChartModel drawRect].origin.y + [LineChartModel drawRect].size.height)]) {
        _detailModel = model;
        [self addDetailData];
        [self initBaseView];
        
    }
    return self;
}

- (instancetype)initWithTestData
{
    if (self = [super initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, [LineChartModel drawRect].origin.y + [LineChartModel drawRect].size.height)]) {
        [self addTestData];
        [self initBaseView];
        self.backgroundColor = COMMON_RED_COLOR;
    }
    return self;
}

- (void)initBaseView
{
    _titleArr = @[@"7日",@"1个月",@"3个月"];
    CGFloat width = 50;
    UIButton *week = [[UIButton alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH * 0.5 - width * 2 , self.height - 30, width, 20)];
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:[_titleArr objectAtIndex:0] attributes:@{NSForegroundColorAttributeName:COMMON_WHITE_COLOR, NSFontAttributeName:[UIFont systemFontOfSize:kCommonFontSizeSubSubDesc]}];
    [week setAttributedTitle:attributedStr forState:UIControlStateNormal];
    [self addSubview:week];
    [week addTarget:self action:@selector(weekClick:) forControlEvents:UIControlEventTouchUpInside];
    [week setBackgroundImage:[UIImage imageNamed:@"Current_LineChart_select"] forState:UIControlStateNormal];
    _weekBt = week;
    
    UIButton *month = [[UIButton alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH * 0.5 - width * 0.55, self.height - 30, width, 20)];
    NSAttributedString *attributedStr1 = [[NSAttributedString alloc] initWithString:[_titleArr objectAtIndex:1] attributes:@{NSForegroundColorAttributeName:COMMON_GREY_COLOR, NSFontAttributeName:[UIFont systemFontOfSize:kCommonFontSizeSubSubDesc]}];
    [month setAttributedTitle:attributedStr1 forState:UIControlStateNormal];

    [month setBackgroundImage:[UIImage imageNamed:@"Current_LineChart_unselect"] forState:UIControlStateNormal];
    [self addSubview:month];
    [month addTarget:self action:@selector(monthClick:) forControlEvents:UIControlEventTouchUpInside];
    _monthBt = month;
    
    UIButton *quater = [[UIButton alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH * 0.5 + width, self.height - 30, width, 20)];
    
    NSAttributedString *attributedStr2 = [[NSAttributedString alloc] initWithString:[_titleArr objectAtIndex:2] attributes:@{NSForegroundColorAttributeName:COMMON_GREY_COLOR, NSFontAttributeName:[UIFont systemFontOfSize:kCommonFontSizeSubSubDesc]}];
    [quater setAttributedTitle:attributedStr2 forState:UIControlStateNormal];
    [quater setBackgroundImage:[UIImage imageNamed:@"Current_LineChart_unselect"] forState:UIControlStateNormal];

    [self addSubview:quater];
    [quater addTarget:self action:@selector(quaterClick:) forControlEvents:UIControlEventTouchUpInside];
    _quaterBt = quater;
}

- (void)addTestData
{
    if (_lineChartView) {
        [_lineChartView removeFromSuperview];
    }
     LineChartView *lineChartView = [LineChartModel drawChartViewTestData];
    [self insertSubview:lineChartView atIndex:0];
    lineChartView.clickLineChartCallback = ^(void) {
        if (_clickLineChartCallback) {
            _clickLineChartCallback();
        }
    };
    _lineChartView = lineChartView;

}

- (void)addDetailData
{
    if (_lineChartView) {
        [_lineChartView removeFromSuperview];
    }
    if (_detailModel.datas.count < 6) {
        [self addTestData];
        return;
    }
    LineChartView *lineChartView = [LineChartModel drawChartViewWithDetailModel:_detailModel];
    [self insertSubview:lineChartView atIndex:0];
    lineChartView.clickLineChartCallback = ^(void) {
        if (_clickLineChartCallback) {
            _clickLineChartCallback();
        }
    };
    _lineChartView = lineChartView;
}

- (void)addQuaterData
{
    [UIView animateWithDuration:0.25 animations:^{
        if (_lineChartView) {
            [_lineChartView setAlpha:0.2];
        }
    } completion:^(BOOL finished) {
        if (_lineChartView) {
            [_lineChartView removeFromSuperview];
        }
        
        LineChartView *lineChartView = [LineChartModel drawChartViewQuaterData];
        lineChartView.alpha = 0.1;
        [self insertSubview:lineChartView atIndex:0];
        lineChartView.clickLineChartCallback = ^(void) {
            if (_clickLineChartCallback) {
                _clickLineChartCallback();
            }
        };
        _lineChartView = lineChartView;
        [UIView animateWithDuration:0.25 animations:^{
            _lineChartView.alpha = 1;
        } completion:^(BOOL finished) {
            
          
        }];
    }];
}

- (void)resetButtonState:(UIButton *)btn fontColor:(UIColor *)color btnTitle:(NSString *)title
{
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:color, NSFontAttributeName:[UIFont systemFontOfSize:kCommonFontSizeSubSubDesc]}];
    [btn setAttributedTitle:attributedStr forState:UIControlStateNormal];
}

- (void)weekClick:(id)sender
{
    if (self.clilckChartWeekCallBack) {
        self.clilckChartWeekCallBack();
    }
    [self addTestData];
    [_weekBt setBackgroundImage:[UIImage imageNamed:@"Current_LineChart_select"] forState:UIControlStateNormal];
    [_monthBt setBackgroundImage:[UIImage imageNamed:@"Current_LineChart_unselect"] forState:UIControlStateNormal];
    [_quaterBt setBackgroundImage:[UIImage imageNamed:@"Current_LineChart_unselect"] forState:UIControlStateNormal];

    [self resetButtonState:_weekBt fontColor:COMMON_WHITE_COLOR btnTitle:[_titleArr objectAtIndex:0]];
    [self resetButtonState:_monthBt fontColor:COMMON_GREY_COLOR btnTitle:[_titleArr objectAtIndex:1]];
    [self resetButtonState:_quaterBt fontColor:COMMON_GREY_COLOR btnTitle:[_titleArr objectAtIndex:2]];
}

- (void)monthClick:(id)sender
{
    if (self.clilckChartMonthCallBack) {
        self.clilckChartMonthCallBack();
    }
    [self addDetailData];
    [_weekBt setBackgroundImage:[UIImage imageNamed:@"Current_LineChart_unselect"] forState:UIControlStateNormal];
    [_monthBt setBackgroundImage:[UIImage imageNamed:@"Current_LineChart_select"] forState:UIControlStateNormal];
    [_quaterBt setBackgroundImage:[UIImage imageNamed:@"Current_LineChart_unselect"] forState:UIControlStateNormal];
    [self resetButtonState:_weekBt fontColor:COMMON_GREY_COLOR btnTitle:[_titleArr objectAtIndex:0]];
    [self resetButtonState:_monthBt fontColor:COMMON_WHITE_COLOR btnTitle:[_titleArr objectAtIndex:1]];
    [self resetButtonState:_quaterBt fontColor:COMMON_GREY_COLOR btnTitle:[_titleArr objectAtIndex:2]];
}

- (void)quaterClick:(id)sender
{
    if (self.clilckChartQuarterCallBack) {
        self.clilckChartQuarterCallBack();
    }
    [self addQuaterData];
    [_weekBt setBackgroundImage:[UIImage imageNamed:@"Current_LineChart_unselect"] forState:UIControlStateNormal];
    [_monthBt setBackgroundImage:[UIImage imageNamed:@"Current_LineChart_unselect"] forState:UIControlStateNormal];
    [_quaterBt setBackgroundImage:[UIImage imageNamed:@"Current_LineChart_select"] forState:UIControlStateNormal];
    [self resetButtonState:_weekBt fontColor:COMMON_GREY_COLOR btnTitle:[_titleArr objectAtIndex:0]];
    [self resetButtonState:_monthBt fontColor:COMMON_GREY_COLOR btnTitle:[_titleArr objectAtIndex:1]];
    [self resetButtonState:_quaterBt fontColor:COMMON_WHITE_COLOR btnTitle:[_titleArr objectAtIndex:2]];
}

@end