    //
    //  ViewController.m
    //
    //
    //  Created by yong on 16/3/30.
    //  Copyright © 2016年 yong. All rights reserved.
    //

#import "CurrentTreasureViewController.h"
//#import "MyAnnualizedViewController.h"
//#import "MyThousandAccrualViewController.h"
//#import "CurrentTreasureViewModel.h"
//#import "PreCommonHeader.h"
//#import "UIView+Extension.h"
#import "LineChartModel.h"
#import "LineChart.h"

static CGFloat const kCurrentTreTopViewHeight = 98.5f;
static CGFloat const kHorizontalSpaceWidth = 15.0f;
static CGFloat const kMiddleSpaceWidth = 54.5f;
static CGFloat const kChartViewHeight = 213.0f;
static CGFloat const kQiRiViewHeight = 39.5f;

@interface CurrentTreasureViewController ()
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UILabel *lastDayEarningsLb;//昨日收益
@property (strong, nonatomic) UILabel *totalMoneyLb;//总金额
@property (strong, nonatomic) UILabel *tenThousandAccrualLb;//万份收益
@property (strong, nonatomic) UILabel *accumulatedEarningsLb; //累计收益
@property (strong, nonatomic) UIButton *detailedIntroductionBtn;//详细按钮
@property (strong, nonatomic) UIButton *expectBtn;//敬请期待
@property (strong, nonatomic) LCLineChartView *lineChartView;
@property (strong, nonatomic) UIView *chartBgView;
@end

    //蓝灰白 #a1d0df
#define COMMON_BLUE_GREY_COLOR         UIColorFromRGBHex(0xa1d0df)

#define COMMON_RGB_9acddd_COLOR        UIColorFromRGBHex(0x9acddd)
    //蓝灰 #92c7d7
#define COMMON_RGB_92c7d7_COLOR        UIColorFromRGBHex(0x92c7d7)

#define COMMON_RGB_33a7c4_COLOR        UIColorFromRGBHex(0x33a7c4)

#define COMMON_RGB_898989_COLOR        UIColorFromRGBHex(0x898989)

@implementation CurrentTreasureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
    self.title = @"前海海盈货币A";
    self.view.backgroundColor = COMMON_GREY_WHITE_COLOR;
    
    
    [self initLineChartView];
    
        //    [self requestData];
}



- (void)initLineChartView
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
        //    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithObjects:@[@[@"176",@"177",@"180",@"190"],@"身高"] forKeys:@[@"array",@"title"]];
    
        //    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithObjects:@[@[@"",@"",@"",@"",@"",@"",@""],@"年化"] forKeys:@[kDATAARRAY_KEY,@"title"]];
        //
    
    
 NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithObjects:@[@[@"2.522",@"2.6522",@"2.8342",@"2.7750",@"2.6815420",@"2.67843",@"2.74314"],@"年化"] forKeys:@[kDATAARRAY_KEY,@"title"]];
    
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
    NSTimeInterval timeEnd = 24 * 3600 * 2;
    
    NSDate *lastData = [senddate dateByAddingTimeInterval:-timeEnd];
    NSString *endDate = [dateformatter stringFromDate:lastData];
    
    CGFloat riqiViewYOffSet = kCurrentTreTopViewHeight + kMiddleSpaceWidth;
    if ((isRetina || iPhone5)) {
        riqiViewYOffSet = (kCurrentTreTopViewHeight * .8f + kMiddleSpaceWidth);
    }
    
    UIView *riqiView = [[UIView alloc] initWithFrame:CGRectMake(0, riqiViewYOffSet, MAIN_SCREEN_WIDTH, kQiRiViewHeight)];
    riqiView.backgroundColor = COMMON_WHITE_COLOR;
    [self.view addSubview:riqiView];
    
    
    CGFloat chartBgViewYOffSet = kCurrentTreTopViewHeight + kMiddleSpaceWidth + kQiRiViewHeight;
    if ((isRetina || iPhone5)) {
        chartBgViewYOffSet = kCurrentTreTopViewHeight * .8f + kMiddleSpaceWidth + kQiRiViewHeight;
    }
    _chartBgView = [[UIView alloc] initWithFrame:CGRectMake(0,chartBgViewYOffSet, MAIN_SCREEN_WIDTH, kChartViewHeight)];
    
    _chartBgView.backgroundColor = COMMON_GREEN_COLOR;
    [self.view addSubview:_chartBgView];
    
    _lineChartView = [LineChartModel drawChartViewBeginTime:startDate EndTime:endDate Rect:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, kChartViewHeight ) Unit:@"%" XArray:xArray YArray:yArray];
    
    
    _lineChartView.clickLineChartCallback = ^(void){
        
            //        UIViewController *curVc = [[NSClassFromString(@"MyAnnualizedViewController") alloc] initWithEarningsType:MyQiRiAnnualizedType];
            //        [weakSelf.navigationController pushViewController:curVc animated:YES];
    };
    _lineChartView.backgroundColor = COMMON_WHITE_COLOR;
    _lineChartView.clipsToBounds = NO;
        //    _lineChartView.drawLinePoints = NO;
    [_chartBgView addSubview:_lineChartView];
}


- (void)initLineChartData
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
        //    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithObjects:@[@[@"176",@"177",@"180",@"190"],@"身高"] forKeys:@[@"array",@"title"]];
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithObjects:@[@[@"2.522",@"2.5322",@"3.5342",@"2.6754240",@"2.6815420",@"2.67843",@"2.7314"],@"年化"] forKeys:@[kDATAARRAY_KEY,@"title"]];
    
    
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
    NSTimeInterval timeEnd = 24 * 3600 * 2;
    
    NSDate *lastData = [senddate dateByAddingTimeInterval:-timeEnd];
    NSString *endDate = [dateformatter stringFromDate:lastData];
    
        //    UIView *riqiView = [[UIView alloc] initWithFrame:CGRectMake(0,((isRetina || iPhone5) ? (kCurrentTreTopViewHeight * .8f + kMiddleSpaceWidth) : ( kCurrentTreTopViewHeight + kMiddleSpaceWidth)), MAIN_SCREEN_WIDTH, kQiRiViewHeight)];
        //    riqiView.backgroundColor = COMMON_WHITE_COLOR;
        //    [self.view addSubview:riqiView];
        //
    
        //    UIView *chartBgView = [[UIView alloc] initWithFrame:CGRectMake(0,((isRetina || iPhone5) ? (kCurrentTreTopViewHeight * .8f + kMiddleSpaceWidth + kQiRiViewHeight) : kCurrentTreTopViewHeight + kMiddleSpaceWidth + kQiRiViewHeight), MAIN_SCREEN_WIDTH, ((isRetina || iPhone5) ? kChartViewHeight: kChartViewHeight))];
        //
        //    chartBgView.backgroundColor = COMMON_GREEN_COLOR;
        //    [self.view addSubview:chartBgView];
//    
//    __weak typeof(self) weakSelf = self;
//    [_lineChartView removeFromSuperview];
//    _lineChartView = [LineChartModel drawChartViewBeginTime:startDate EndTime:endDate Rect:CGRectMake(0, 0, _chartBgView.width, _chartBgView.height ) Unit:@"%" XArray:xArray YArray:yArray];
//    _lineChartView.clickLineChartCallback = ^(void){
//        
//            //        UIViewController *curVc = [[NSClassFromString(@"MyAnnualizedViewController") alloc] initWithEarningsType:MyQiRiAnnualizedType];
//            //        [weakSelf.navigationController pushViewController:curVc animated:YES];
//    };
//    [self.chartBgView addSubview:_lineChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (void)fetchRequestSucceesCallBack {
    
}



@end
