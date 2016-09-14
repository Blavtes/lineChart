//
//  YYLChartView.h
//  LineChart
//
//  Created by yangyong on 16/9/14.
//  Copyright © 2016年 zhangchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYLChartView : UIView
@property (nonatomic, assign) CGFloat xMax;
@property (nonatomic, assign) CGFloat xMin;
@property (nonatomic, assign) CGFloat yMax;
@property (nonatomic, assign) CGFloat yMin;
@property (nonatomic, strong) NSMutableArray *valueArray;
@end
