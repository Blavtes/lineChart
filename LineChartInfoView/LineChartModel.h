//
//  ZCLineChart.h
//  LineChart
//
//  Created by yong on 16/3/31.
//  Copyright © 2016年  yong. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LCLineChartView.h"
#import "LineChart.h"

@class  MyFundDetailDataModel;
@interface LineChartModel : NSObject

/**
 *
 *
 *  @param beginTIme 开始时间
 *  @param endTime   结束时间
 *  @param rect      位置
 *  @param xArray    x轴数据
 *  @param yArray    y轴数据
 *
 *  @return 
 */
+(LCLineChartView*)drawChartViewBeginTime:(NSString*)beginTIme
                                  EndTime:(NSString*)endTime
                                     Rect:(CGRect)rect
                                   XArray:(NSMutableArray*)xArray
                                   YArray:(NSMutableArray*)yArray;

+ (LCLineChartView *)drawChartViewWithDetailModel:(MyFundDetailDataModel *)detailModel;


/**
 *
 *
 *  @param rect      位置
 *  @param unit      单位
 *  @param xArray    x轴数据
 *  @param yArray    y轴数据
 *
 *  @return 返回测试数据
 */
+(LCLineChartView*)drawChartViewTestData;
+ (LCLineChartView *)drawChartViewQuaterData;
+ (CGRect)drawRect;

@end


@interface LineChartShowView : UIView
@property (copy) LCLineChartWeekBtnClick clilckChartWeekCallBack;
@property (copy) LCLineChartMonthBtnClick clilckChartMonthCallBack;
@property (copy) LCLineChartQuarterBtnClick clilckChartQuarterCallBack;
@property (copy) LCLineChartClick clickLineChartCallback;

@property (nonatomic, weak) LineChartView *lineChartView;
@property (nonatomic, strong) MyFundDetailDataModel *detailModel;
- (instancetype)initWithData:(MyFundDetailDataModel *)model;
- (instancetype)initWithTestData;
@end
