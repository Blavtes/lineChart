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
#define kYSHORT_DASH_LINE_COLOR         UIColorFromRGBHex(0xf1f1f1)
    //x虚线
#define kXSHORT_DASH_LINE_COLOR         UIColorFromRGBHex(0xf1f1f1)

#define kCOLORRGB(r, g, b)              [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
    //折线颜色
#define kLINECHART_COLOR                UIColorFromRGBHex(0x33a7c4)
    //x轴 字体颜色
#define kXAXIS_COLOR                    UIColorFromRGBHex(0xa3a3a3)
    //y轴 字体颜色
#define kYAXIS_COLOR                    UIColorFromRGBHex(0xa3a3a3)

    //蓝色填充矩形颜色
#define kRECT_BLUE_COLOR                UIColorFromRGBHex(0xf7fdff)
#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

    //圆点颜色
#define kCIRCLE_DOT_COLOR               UIColorFromRGBHex(0x33a7c4)
//画线节点个数 画7个点 个数为8
#define kTITLELABLE_COUNT                7
//日期格式化
#define kDATE_FORMAT_Str                @"MM.dd"
#define FMT_STR(format, ...) [NSString stringWithFormat:format, ##__VA_ARGS__]

    //  导航栏通用字体大小
#define CommonNavigationTitleFont [UIFont systemFontOfSize:20]

#pragma mark - [通用字体]
    //  通用字体
static CGFloat const kCommonFontSizeHighlight = 30.0f;
static CGFloat const kCommonFontSizeBtnTitle = 25.0f;
static CGFloat const kCommonFontSizeTitle = 18.0f;
static CGFloat const kCommonFontSizeDetail = 16.0f;
static CGFloat const kCommonFontSizeSubDesc = 14.0f;
static CGFloat const kCommonFontSizeSubSubDesc = 12.0f;
static CGFloat const kCommonFontSizeSmall = 10.0f;
//数据键
#define kDATAARRAY_KEY                  @"array"
#define KLEGENDVIEW_HIDDEN              YES

    //  随机色
#define RandColor RGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

    //  颜色
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define RGBColorAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

    //  颜色  e.g. UIColorFromRGBHex(0xCECECE);
#define UIColorFromRGBHex(rgbValue)     [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

    //  通用黑色 ok
#define COMMON_BLACK_COLOR RGBColor(94, 98, 99)

    //  通用灰色 ok
#define COMMON_GREY_COLOR RGBColor(163, 163, 163)

    //  浅灰色 ok
#define COMMON_LIGHT_GREY_COLOR RGBColor(206, 206, 206)

    //  灰白色 (已经偏白) ok
#define COMMON_GREY_WHITE_COLOR RGBColor(241, 241, 241)

    //  白色 ok
#define COMMON_WHITE_COLOR RGBColor(255, 255, 255)
#define COMMON_WHITE_COLOR_ALPHA RGBColorAlpha(255, 255, 255, .5f)

    //  通用蓝色
#define COMMON_BLUE_COLOR RGBColor(55, 137, 221)

    //  通用蓝青色[主色调] ok
#define COMMON_BLUE_GREEN_COLOR RGBColor(51, 167, 196)

    //  浅蓝青色 ok
#define COMMON_LIGHT_BLUE_COLOR RGBColorAlpha(51, 167, 196, .6f)

    //  通用橙黄色[文字] ok
#define COMMON_ORANGE_COLOR RGBColor(241, 130, 70)
    //  弹出框 - 页面中部按钮 ok
#define COMMON_ORANGE_COLOR_FOR_ALERT_VIEW RGBColor(240, 103, 40)
    //  通用橙黄色[底部按钮] ok
#define COMMON_ORANGE_COLOR_FOR_BOTTOM_BTN RGBColor(224, 96, 36)

    //  通用红色
#define COMMON_RED_COLOR RGBColor(255, 62, 63)

    //  通用绿色
#define COMMON_GREEN_COLOR RGBColor(129, 194, 74)

    //  半透明颜色
#define TransparentColor [UIColor colorWithRed:238/255.0 green:243/255.0 blue:248/255.0 alpha:1.0f]

#define TransparentColorForHUD [UIColor colorWithRed:.05f green:.05f blue:.05f alpha:.2f]

#define VirsualColor [UIColor colorWithRed:238/255.0 green:243/255.0 blue:248/255.0 alpha:.3f]
#pragma mark - 打印弹出信息
    //  打印日志
#ifdef DEBUG
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...) nil
#endif

#ifdef DEBUG
#else
#define NSLog(...) {}
#endif

    //  提示用户的信息
#define Show_iToast(string) [[[[iToast makeText:string] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];

/**
 *  格式化字符串
 *
 *  @param format 格式符串
 *  @param ...    参数列表
 *
 *  @return 格式化了的字符串
 */
#define FMT_STR(format, ...) [NSString stringWithFormat:format, ##__VA_ARGS__]

/**
 *  打印BOOL变量
 *
 *  @param b BOOL变量
 *
 *  @return BOOL变量对应的字符串
 */
#define PRINT_BOOL(b) DLog(@"%@", b ? @"YES" : @"NO")

    //  断言
#define LT_Assert(condition) NSAssert(condition, ([NSString stringWithFormat:@"file name = %s ---> function name = %s at line: %d", __FILE__, __FUNCTION__, __LINE__]));

#pragma mark -- 数据校验
/**
 *  安全获取字符串
 */
#define NSStringSafety(obj) \
[obj isKindOfClass:[NSObject class]] ? [NSString stringWithFormat:@"%@",obj] : @""

/**
 *  安全获取字典中的Value
 */
#define ObjectForKeySafety(obj,key) \
[obj isKindOfClass:[NSDictionary class]] && ![[obj objectForKey:key] isKindOfClass:[NSNull class]] ? [obj objectForKey:key]:nil

/**
 *  安全获取数组中的Value
 */
#define ObjectIndexSafety(obj,index) \
[obj isKindOfClass:[NSArray class]] && index < [obj count] && ![[obj objectAtIndex:index] isKindOfClass:[NSNull class]] ? [obj objectAtIndex:index] :nil


#pragma mark - 系统版本 - 语言等
/**
 *  获取当前系统版本
 */
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

    //  是否高于ios7
#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

/**
 *  获取当前语言
 */
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#pragma mark - 判断机型

    //  判断是否4inch
#define FourInch ([UIScreen mainScreen].bounds.size.height >= 568.0)

    //  宏定义机型判断
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

    //  判断是否 Retina-4s屏、iphone5、iPad等
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

    //  设备屏宽
#define IS_WIDESCREEN_5                            (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < __DBL_EPSILON__)
#define IS_WIDESCREEN_6                            (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667) < __DBL_EPSILON__)
#define IS_WIDESCREEN_6Plus                        (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736) < __DBL_EPSILON__)

    //  各型号设备
#define IS_IPOD                                    ([[[UIDevice currentDevice] model] isEqualToString: @"iPod touch"])

#define iPhone5                                (IS_IPHONE && IS_WIDESCREEN_5)

#define iPhone6                                (IS_IPHONE && IS_WIDESCREEN_6)

#define iPhone6Plus                            (IS_IPHONE && IS_WIDESCREEN_6Plus)

#pragma mark - 通用按钮转角 - tvCell高度等 - 导航栏高度等 - 获取屏幕宽度
    //  屏幕大小
#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define MAIN_SCREEN_BOUNDS [UIScreen mainScreen].bounds

    //  底部标签栏高度
#define TabbarHeight 49.0f

    //  选项卡标签高度
#define TopSwitchHeight 40.0f

    //  普通按钮的弧度
#define CommonBtnCornerRadius 3.0f

    //  maxSize
#define MAX_SIZE CGSizeMake(MAXFLOAT, MAXFLOAT)

    //  状态栏
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
    //  navi
#define NAVI_HEIGHT self.navigationController.navigationBar.bounds.size.height

#pragma mark - 网络错误提示文字

    //  网络错误和通用hud信息
#define NORMAL_HUD_STATE_STR @"正在拼命加载中.."
#define NORMAL_HUD_ERROR_STR @"网络连接错误,请稍候再试!"
#define COMMON_NO_NETWORK @"当前无网络,请开启后再试!"
#define NET_ERROR_1001 @"请求超时"
#define NET_ERROR_1002 @"不支持的请求"
#define NET_ERROR_1003 @"找不到服务器或主机名"
#define NET_ERROR_1004 @"当前网络不可用"
#define NET_ERROR_1005 @"网络连接已丢失"
#define NET_ERROR_1009 @"当前网络不可用"

#define DEFAULT_NO_NETWORK_TOP_TIP @"世界上最遥远的距离就是没网.请连接网络!"

#pragma mark - 选项卡索引 - 平台
    //  选项卡id
#define HOME_INDEX 0
#define PRODUCT_INDEX 1
#define USERCENTER_INDEX 2
#define MORE_INDEX 3

#pragma mark - 常量
    //  Label高度
static CGFloat const CommonLbHeight = 30.0f;

    //  按钮转角
static CGFloat const kCommonBtnRad = 3.0f;

static CGFloat const kCommonBtnHeight = 40.0f;

    //  table cell头高度
static CGFloat const kTableViewHeaderHeightSmall = 3.0f;
    //  标准footer间隔
static CGFloat const kTableViewFooterHeight = 10.0f;
    //  标准headerer间隔
static CGFloat const kTableViewHeaderHeight = 40.0f;
    //  普通table cell头高度
static CGFloat const kTableViewCellHeightNormal = 50.0f;
    //  产品table cell高度
static CGFloat const kProductTableViewCellHeight = 90.0f;
    //  产品table cell高度 - 业务专区图片专用
static CGFloat const kProductTableViewCellHeightForBusiness = 110.0f;