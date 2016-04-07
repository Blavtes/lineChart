//
//  ViewController.m
//  
//
//  Created by yong on 16/3/30.
//  Copyright © 2016年 yong. All rights reserved.
//

#import "CurrentTreasureViewController.h"
#import "LineChartModel.h"
#import "LineChart.h"

static CGFloat const kAssetInfoViewHeight = 190.0f;

@interface CurrentTreasureViewController ()
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UILabel *lastDayEarnings;//昨日收益
@property (strong, nonatomic) UILabel *totalMoney;//总金额
@property (strong, nonatomic) UILabel *tenThousandAccrual;//万份收益
@property (strong, nonatomic) UILabel *accumulatedEarnings; //累计收益
@property (strong, nonatomic) UIButton *detailedIntroductionBtn;//详细按钮
@property (strong, nonatomic) UIButton *ExpectBtn;//敬请期待
@property (strong, nonatomic) LCLineChartView *lineChartView;

@end

@implementation CurrentTreasureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self initLineChartView];
    
  
    
}

- (void)initLineChartView
{
    NSMutableArray* xArray = [[NSMutableArray alloc] initWithCapacity:7];
    
    for (int i = 7; i > 0; i--) {
        NSDate *  senddate=[NSDate date];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:kDATE_FORMAT_Str];
        NSTimeInterval timeStart = 24 * 3600 * i;
        
        NSDate * oldData = [senddate dateByAddingTimeInterval:-timeStart];
        NSString * startDate = [dateformatter stringFromDate:oldData];
        [xArray addObject:startDate];
    }
    
    NSMutableArray* yArray = [[NSMutableArray alloc]init];
    //    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithObjects:@[@[@"176",@"177",@"180",@"190"],@"身高"] forKeys:@[@"array",@"title"]];
    
    NSMutableDictionary* newDict = [[NSMutableDictionary alloc] initWithObjects:@[@[@"7.4",@"6.6",@"6.22",@"6.2240",@"6.720",@"7.43",@"6.77777"],@"年化"] forKeys:@[kDATAARRAY_KEY,@"title"]];
    
    
    //    [yArray addObject:dict];
    [yArray addObject:newDict];
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:kDATE_FORMAT_Str];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    
    NSTimeInterval timeStart = 24 * 3600 * 7;
    
    NSDate * oldData = [senddate dateByAddingTimeInterval:-timeStart];
    NSString * startDate = [dateformatter stringFromDate:oldData];
    
    NSTimeInterval timeEnd = 24 * 3600 *2;
    
    NSDate * lastData = [senddate dateByAddingTimeInterval:-timeEnd];
    NSString * endDate = [dateformatter stringFromDate:lastData];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 176 , self.view.frame.size.width, 236)];
    
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    NSLog(@"locationString:%@  start %@  end %@ %f",locationString,startDate,endDate,self.view.frame.size.width);
    LCLineChartView* chartView = [LineChartModel drawChartViewBeginTime:startDate EndTime:endDate Rect:CGRectMake(0, 0 , self.view.frame.size.width, view.frame.size.height) Unit:@"%" XArray:xArray YArray:yArray];
    chartView.selectedItemCallback = ^(LCLineChartData * data, NSUInteger item, CGPoint positionInChart){
        NSLog(@".....");
    };
    [view addSubview:chartView];
    chartView.backgroundColor = [UIColor grayColor];
    self.view.backgroundColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
