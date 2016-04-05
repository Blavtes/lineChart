//
//  ViewController.m
//  LineChart
//
//  Created by yong on 16/3/30.
//  Copyright © 2016年 yong. All rights reserved.
//

#import "ViewController.h"
#import "ZCLineChart.h"
#import "LineChart.h"

@interface ViewController ()

@end

@implementation ViewController

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
    
    NSTimeInterval timeEnd = 24 * 3600 ;
    
    NSDate * lastData = [senddate dateByAddingTimeInterval:-timeEnd];
    NSString * endDate = [dateformatter stringFromDate:lastData];
    
    NSLog(@"locationString:%@  start %@  end %@",locationString,startDate,endDate);
    LCLineChartView* chartView = [ZCLineChart drawChartViewBeginTime:startDate EndTime:endDate Rect:CGRectMake(25, 60, self.view.frame.size.width - 50, 200) Unit:@"%" XArray:xArray YArray:yArray];
    
    [self.view addSubview:chartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
