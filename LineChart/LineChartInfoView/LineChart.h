//
//  LineChart.h
//  linechart
//
//  Created by yangyong on 16/3/31.
//  Copyright © 2016年 yangyong. All rights reserved.
//

#import "LCInfoView.h"
#import "LCLineChartView.h"
#import "LCLegendView.h"

typedef LCLegendView LegendView;
typedef LCLineChartView LineChartView;
typedef LCInfoView InfoView;
typedef LCLineChartData LineChartData;
typedef LCLineChartDataItem LineChartDataItem;
typedef LCLineChartDataGetter LineChartDataGetter;
typedef LCLineChartSelectedItem LineChartSelectedItem;
typedef LCLineChartDeselectedItem LineChartDeselectedItem;

//pop 视图背景颜色
#define kPOPBACKVIEW_COLOR              [UIColor colorWithWhite:0.5 alpha:1.0]
#define kPOPBACKVIEW_ALPHA              0.7
//pop 视图lable
#define kPOPLABLEVIEW_COLOR             [UIColor colorWithWhite:0.5 alpha:1.0]
#define kPOPLABLEVIEW_ALPHA             0.2


//y虚线
#define kYSHORT_DASH_LINE_COLOR         [UIColor colorWithWhite:0.9 alpha:1.0]
//x虚线
#define kXSHORT_DASH_LINE_COLOR         [UIColor colorWithWhite:0.9 alpha:1.0]

#define kCOLORRGB(r, g, b)              [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
//折线颜色
#define kLINECHART_COLOR                [UIColor redColor]
//x轴 字体颜色
#define kXAXIS_COLOR                    [UIColor redColor]
//y轴 字体颜色
#define kYAXIS_COLOR                    [UIColor redColor]
//画线节点个数 画7个点 个数为8
#define kTITLELABLE_COUNT                7
//日期格式化
#define kDATE_FORMAT_Str                @"MM.dd"

//数据键
#define kDATAARRAY_KEY                  @"array"
#define KLEGENDVIEW_HIDDEN              YES