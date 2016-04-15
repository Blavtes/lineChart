    //
    //  ZCLineChart.m
    //  LineChart
    //
    //  Created by yong on 16/3/31.
    //  Copyright © 2016年 yong. All rights reserved.
    //

#import "LineChartModel.h"

#import "LineChart.h"

static float const kYOffSet = 0.05f;

@implementation LineChartModel

+(LCLineChartView *)drawChartViewBeginTime:(NSString *)beginTIme EndTime:(NSString *)endTime Rect:(CGRect)rect Unit:(NSString *)unit XArray:(NSMutableArray *)xArray YArray:(NSMutableArray *)yArray{
    
    NSMutableArray *colorArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        [colorArray addObject:kLINECHART_COLOR];
    }
    
        //最大值 最小值分5份显示y轴 刻度
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
    
    if ([date1 isEqualToDate:date2]) {
        date1 = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date1 timeIntervalSinceReferenceDate])];
        date2 = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date2 timeIntervalSinceReferenceDate] + 24 * 3600)];
    }else{
        date2 = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date2 timeIntervalSinceReferenceDate] + 24 * 3600)];
    }
    
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
    int days = ((int)time)/(3600 * 24);
    NSString *dateContent = [[NSString alloc] initWithFormat:@"%i天",days];
    
        //日期数组
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< [dateContent intValue] + 1; i++) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *compontent = nil;
        compontent = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date1];
        NSDateComponents *adCompontent = [[NSDateComponents alloc] init];
        [adCompontent setDay:i];
        NSDate *nextDate = [calendar dateByAddingComponents:adCompontent toDate:date1 options:0];
        NSString *nextDateStr = [dateFormatter stringFromDate:nextDate];
        [dateArray addObject:nextDateStr];
    }
    
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
    
    [LineChartModel showUnitView:chartView unit:unit dateArray:dateArray viewRect:rect];
    
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
    [numberArray addObject:[NSString stringWithFormat:@"%.4f",1]];

    [numberArray addObject:[NSString stringWithFormat:@"%.4f",maxM]];
    [numberArray addObject:[NSString stringWithFormat:@"%.4f",minN + 3 * a ]];
    [numberArray addObject:[NSString stringWithFormat:@"%.4f",minN + 2 * a ]];
    [numberArray addObject:[NSString stringWithFormat:@"%.4f",minN + a ]];
    [numberArray addObject:[NSString stringWithFormat:@"%.4f",minN]];
//    [numberArray addObject:[NSString stringWithFormat:@"%.4f",1]];
    [numberArray addObject:[NSString stringWithFormat:@"%.4f",0]];

    
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
    CGFloat labelXStart = ((isRetina || iPhone5) ? 20 : 34);
    UILabel* unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelXStart, -30, 200, 21)];
    unitLabel.backgroundColor = [UIColor clearColor];
    unitLabel.textColor =  kXAXIS_COLOR;
    unitLabel.font = [UIFont systemFontOfSize:12.0];
    unitLabel.text = [NSString stringWithFormat:@"7日年化收益率 ( %@ )",unit];
    [chartView addSubview:unitLabel];
    
    for (int i = 0; i < dateArray.count; i++) {
        CGFloat xStart = 55;
        CGFloat  availableWidth = chartView.frame.size.width - xStart - 20;
        
        
        CGFloat widthPerStep = availableWidth / (dateArray.count - 1);
        CGFloat xDateLabelOffSet = xStart - 23;
        CGFloat yDateLabelOffSet = 36;
            //偏移
        CGFloat offSet = 20;
        UILabel * dateDabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(i * widthPerStep + xDateLabelOffSet, rect.size.height - yDateLabelOffSet + offSet, (chartView.frame.size.width / (kTITLELABLE_COUNT +1 )), 21)];
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
    NSLog(@"findMinValue arr %@",yArray );
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
