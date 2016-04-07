//
//  ZCLineChart.m
//  LineChart
//
//  Created by yong on 16/3/31.
//  Copyright © 2016年 yong. All rights reserved.
//

#import "LineChartModel.h"

#import "LineChart.h"



@implementation LineChartModel

+(LCLineChartView *)drawChartViewBeginTime:(NSString *)beginTIme EndTime:(NSString *)endTime Rect:(CGRect)rect Unit:(NSString *)unit XArray:(NSMutableArray *)xArray YArray:(NSMutableArray *)yArray{
    
//    NSMutableArray* colorArray = [[NSMutableArray alloc] initWithObjects:COLORRGB(169, 204, 72),COLORRGB(168, 137, 255),COLORRGB(255, 171, 120),COLORRGB(194, 194, 194),COLORRGB(81, 198, 211), nil];
    NSMutableArray* colorArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        [colorArray addObject:kLINECHART_COLOR];
    }
    
    NSMutableArray* maxArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i <yArray.count; i++) {
        NSArray* array = [[yArray objectAtIndex:i] objectForKey:kDATAARRAY_KEY];
        float max = [[array valueForKeyPath:@"@max.floatValue"] floatValue];
        [maxArray addObject:[NSString stringWithFormat:@"%f",max]];
    }
    
    //最大值分5份显示y轴
    float max = [[maxArray valueForKeyPath:@"@max.floatValue"] floatValue];
    NSMutableArray* numberArray = [[NSMutableArray alloc] init];
//    float number = ((max/10 + 1)* 10)/5;
//    for (NSInteger i = 0; i < 6; i++) {
//        NSString* str = [NSString stringWithFormat:@"%f",number*i];
//        [numberArray addObject:str];
//    }
    
    //y轴最小值
    NSMutableArray* minArray = [[NSMutableArray alloc] init];
    NSLog(@"yArr %@ %f",yArray,max );
    for (NSInteger i = 0; i < yArray.count; i++) {
        NSArray* array = [[yArray objectAtIndex:i] objectForKey:kDATAARRAY_KEY];
        float min = [[array valueForKeyPath:@"@min.floatValue"] floatValue];
        [minArray addObject:[NSString stringWithFormat:@"%.3f",min]];
    }
    
    float min = [[minArray valueForKeyPath:@"@min.floatValue"] floatValue];

//    NSLog(@"yArr %@ %f %@ %f",yArray,max ,minArray,min);

    float maxM = max + 0.05f;
    float minN = min - 0.05f;
    float a = (maxM - minN) / 4.0f;
    [numberArray addObject:[NSString stringWithFormat:@"%.3f",minN]];
    [numberArray addObject:[NSString stringWithFormat:@"%.3f",minN + a ]];
    [numberArray addObject:[NSString stringWithFormat:@"%.3f",minN + 2 * a ]];
    [numberArray addObject:[NSString stringWithFormat:@"%.3f",minN + 3 * a ]];
    [numberArray addObject:[NSString stringWithFormat:@"%.3f",maxM]];

    [numberArray addObject:[NSString stringWithFormat:@"%.3f",maxM+0.05]];
    
    //时间差
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setDateFormat:kDATE_FORMAT_Str];
  
    NSDate *date1 = [dateFormatter dateFromString:beginTIme];
    NSDate *date2 = [dateFormatter dateFromString:endTime];
    
    if ([date1 isEqualToDate:date2]) {
        date1 = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date1 timeIntervalSinceReferenceDate])];
        date2 = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date2 timeIntervalSinceReferenceDate] + 24*3600)];
    }else{
        date2 = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date2 timeIntervalSinceReferenceDate] + 24* 3600)];
    }
    
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
    int days = ((int)time)/(3600*24);
    NSString* dateContent = [[NSString alloc] initWithFormat:@"%i天",days];
    
    NSMutableArray* dateArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< [dateContent intValue] + 1; i++) {
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents* compontent = nil;
        compontent = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date1];
        NSDateComponents* adCompontent = [[NSDateComponents alloc] init];
        [adCompontent setDay:1*i];
        NSDate* nextDate = [calendar dateByAddingComponents:adCompontent toDate:date1 options:0];
        NSString* nextDateStr = [dateFormatter stringFromDate:nextDate];
        [dateArray addObject:nextDateStr];
    }
    
    //画图
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSDateFormatter* newDateFormatter = [[NSDateFormatter alloc] init];
    [newDateFormatter setDateFormat:kDATE_FORMAT_Str];
//    [newDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    for (NSInteger i = 0; i < yArray.count; i++) {
        NSArray* newYArray = [yArray[i] objectForKey:kDATAARRAY_KEY];
        LCLineChartData* lineChart = [LCLineChartData new];
        lineChart.xMin = [date1 timeIntervalSinceReferenceDate];
        lineChart.xMax = [date2 timeIntervalSinceReferenceDate];
        lineChart.title = [yArray[i] objectForKey:@"title"];
        lineChart.color = colorArray[i];
        lineChart.itemCount = xArray.count;
        lineChart.getData = ^(NSUInteger item){
            float x = [[newDateFormatter dateFromString:xArray[item]] timeIntervalSinceReferenceDate];
            float y = [newYArray[item] floatValue];
            NSString* label1 = [NSString stringWithFormat:@"%@",xArray[item]];
            NSString* label2 = [NSString stringWithFormat:@"%@",newYArray[item]];
//            NSLog(@" x  %@",lineChart.title);
//            sleep(1.5f);
            return [LCLineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
        };
        [array addObject:lineChart];
    }
    
    LCLineChartView* chartView = [[LCLineChartView alloc] initWithFrame:rect];
    chartView.yMin = minN;
    chartView.yMax = maxM;
    chartView.ySteps = numberArray;
    chartView.xStepsCount = kTITLELABLE_COUNT;
    chartView.data = array;
//    NSLog(@"char %ld %f",chartView.yMax,[numberArray[5] floatValue]);
    //单位
    UILabel* unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, -15, 200, 21)];
    unitLabel.backgroundColor = [UIColor clearColor];
    unitLabel.textColor = [UIColor grayColor];
    unitLabel.font = [UIFont systemFontOfSize:12.0];
    unitLabel.text = [NSString stringWithFormat:@"七日年化收益率:(%@)",unit];
    [chartView addSubview:unitLabel];
    
    for (int i = 0; i < dateArray.count; i++) {
        UILabel * dateDabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(i * (chartView.frame.size.width / (dateArray.count + 1) ) + 38 , 185, (chartView.frame.size.width / (kTITLELABLE_COUNT +1 )), 21)];
        dateDabel_1.backgroundColor = [UIColor clearColor];
        dateDabel_1.font = [UIFont systemFontOfSize:9];
        dateDabel_1.text = [dateArray objectAtIndex:i];
        dateDabel_1.textColor = kXAXIS_COLOR;
        [chartView addSubview:dateDabel_1];
    }
    
    return chartView;

    
}

@end
