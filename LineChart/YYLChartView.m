//
//  YYLChartView.m
//  LineChart
//
//  Created by yangyong on 16/9/14.
//  Copyright © 2016年 zhangchao. All rights reserved.
//

#import "YYLChartView.h"

#define UIColorFromRGBHex(rgbValue)     [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define X_AXIS_SPACE 15
#define PADDING 10
#define kDesign_xOffSet 55

@implementation YYLChartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setDefaut];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setDefaut];
    }
    return self;
}

- (void)setDefaut
{
    self.backgroundColor  = [UIColor whiteColor];
//    NSArray *heightArray =  @[@(0.5),@(20),@(55),@(90),@(125),@(160),@(178)];
    NSArray *heightArray =  @[@(36),@(53),@(82),@(112),@(142),@(172),@(186)];

    
    [self drawXAxisAndFillRectWithYCoordinate:heightArray];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    [self initYValueArray:arr maxM:3.6544 minN:2.4542 offSet:0];
    [self initYTitle:arr heightArr:heightArray];
    
    NSArray *timeArr = @[@"03-10",@"03-11",@"03-13",@"03-15",@"04-10",@"05-12",@"05-18"];
    [self initXTitle:timeArr heightArr:heightArray];
    
    NSArray *value = @[@"3.57",@"3.57",@"3.57",@"3.57",@"3.57",@"3.57",@"3.57"];
    [self drawLine:value];
}

- (void)drawLine:(NSArray *)value
{
    for (int i = 0; i < value.count; i++) {
        
    }
}

/**
 *  画折线图中的 线段 和最后一个点
 */
- (void)drawPointAndLinesWithYCoordinate:(NSArray*)heightArray
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGFloat yStart = 20 / 2;
    CGFloat xStart = kDesign_xOffSet;
    CGFloat availableWidth = self.bounds.size.width - xStart - 20;
    
    CGFloat availableHeight = self.bounds.size.height - 2 * PADDING - X_AXIS_SPACE;
    
    CGFloat yRangeLen = self.yMax - self.yMin;
    CGFloat yOffSet = self.frame.size.height * 0.05; //视图高度 * 精度
    if(yRangeLen == 0) yRangeLen = 1;
    for(int i = 0 ; i < self.valueArray.count - 1; i++) {
        CGFloat value = [[_valueArray objectAtIndex:i] floatValue];
            double xRangeLen = self.xMax - self.xMin;
            if(xRangeLen == 0) xRangeLen = 1;
            if(self.valueArray.count >= 2) {
                CGFloat y = value;
                
                CGFloat yyOffSet = 0;
                CGFloat x = availableWidth / _valueArray.count;
         
                CGFloat  ys = 0;
                  CGFloat prevX = xStart + round(((x - self.xMin) / xRangeLen) * availableWidth);
                ys = [self getCurrentPositionYWithValue:value heightArray:heightArray yStart:ys  offSet:0 isDrawRect:NO];
                    ////
                    //                CGPathMoveToPoint(path, NULL, prevX, prevY + yyOffSet);
                CGMutablePathRef path = CGPathCreateMutable();

                CGPathMoveToPoint(path, NULL, prevX, ys);
                
                    yyOffSet = 0;
                        // 数据偏移修正
                    
                        //                    NSArray *heightArray =  @[@(0.5),@(20),@(64),@(105),@(150),@(178)];
                    
//                CGFloat x = xStart + round(((dataItem.x - data.xMin) / xRangeLen) * availableWidth);
//                CGFloat y = yStart + round((1 - (dataItem.y - self.yMin) / yRangeLen) * availableHeight) + yyOffSet ;
//                CGFloat yy = [self getCurrentPositionYWithItemData:dataItem heightArray:heightArray yStart:y offSet:0 isDrawRect:NO];
//                
//                CGPathAddLineToPoint(path, NULL, x, yy );
                
                
                CGContextAddPath(c, path);
                CGContextSetStrokeColorWithColor(c, [UIColor brownColor].CGColor);
                CGContextSetLineWidth(c, 2);
                CGContextStrokePath(c);
                
                CGPathRelease(path);
            }
        } // draw actual chart data
        
    
}

/**
 *  计算每个点的 偏移位置
 *
 *  @param dataItem     数据
 *  @param heightArray 刻度数组
 *  @param yStart      yStart 点y开始位置
 *  @param offSet      offSet 最后一个数据提示偏移
 *  @param isRectNoti  是否是最后一个提示显示位置
 *
 *  @return 计算出来的位置
 */
- (CGFloat)getCurrentPositionYWithValue:(CGFloat)yValue
                               heightArray:(NSArray*)heightArray
                                    yStart:(CGFloat)yStart
                                    offSet:(CGFloat)offSet
                                isDrawRect:(BOOL)isRectNoti
{
    CGFloat yy = yStart;
    CGFloat rectHeight = offSet;
        //第6条线，不可能比它更低
    CGFloat endY = [[heightArray objectAtIndex:5] floatValue];
        //第5条线
    CGFloat lastY = [[heightArray objectAtIndex:4] floatValue];
    
        //第4条线
    CGFloat minY  = [[heightArray objectAtIndex:3] floatValue];
        //第3条线 中线 附近
    CGFloat middleY = [[heightArray objectAtIndex:2] floatValue];
        //第2条线 有可能在它的上面
    CGFloat maxY  = [[heightArray objectAtIndex:1] floatValue];
    
        //第一条线
    CGFloat firstY = [[heightArray firstObject] floatValue];
    if (yValue > maxY ){ // 第一区
                             //第1梯度高度
        CGFloat yPerLenth = [[heightArray objectAtIndex:1] floatValue] - [[heightArray objectAtIndex:0] floatValue];
            //比例高度+ 偏移
        yy = -yPerLenth * (yValue - maxY ) / ( firstY - maxY) + [[heightArray objectAtIndex:1] floatValue];
        rectHeight =  10 * (yValue - maxY) / ( firstY - maxY) + [[heightArray objectAtIndex:1] floatValue] - offSet;
        NSLog(@"ys2 %f %f yValue - minY %f %f %f %f",yy ,[[heightArray objectAtIndex:1] floatValue],minY - yValue,minY - lastY, yValue ,maxY);
    } else  if(yValue >= middleY && yValue <= maxY){// 第2区
                                                            //第2梯度高度
        CGFloat yPerLenth = [[heightArray objectAtIndex:2] floatValue] - [[heightArray objectAtIndex:1] floatValue];
        yy =   -yPerLenth * (yValue - middleY) / ( maxY - middleY) + [[heightArray objectAtIndex:2] floatValue];
        NSLog(@"33333  %f %f,%f %f",yy,yValue - middleY,maxY - middleY,yValue);
        rectHeight = yStart - offSet;
    } else if(yValue >= minY && yValue < middleY) {// 第3区
        
            //第2梯度高度
        CGFloat yPerLenth = [[heightArray objectAtIndex:3] floatValue] - [[heightArray objectAtIndex:2] floatValue];
        yy =   -yPerLenth * (yValue - minY) / ( middleY - minY) + [[heightArray objectAtIndex:3] floatValue];
        NSLog(@"33333  %f %f,%f %f",yy,yValue - middleY,maxY - middleY,yValue);
        rectHeight = yStart - offSet;
    }else   if (yValue < minY) {// 第4区
                                    //                        CGFloat lastYY = [heightArray objectAtIndex:heightArray.c]
                                    //第2梯度高度
        CGFloat yPerLenth = [[heightArray objectAtIndex:4] floatValue] - [[heightArray objectAtIndex:3] floatValue];
        yy = -yPerLenth * (yValue - lastY) / (minY - lastY) + [[heightArray objectAtIndex:4] floatValue];
            //                        DLog(@"ys %f %f yValue - minY %f %f %f %f",ys ,[[heightArray objectAtIndex:heightArray.count - 2] floatValue],minY - yValue,minY - lastY, yValue ,minY);
        rectHeight =  yPerLenth * (minY - yValue) / (minY - lastY) + [[heightArray objectAtIndex:heightArray.count - 3] floatValue] - offSet;
        
    } else{ // 第5区
        yy = yStart;
        rectHeight = yStart - offSet;
    }
    if (isRectNoti) {
        return rectHeight;
    }
    
    return yy;
}


/**
 *  画x轴线 和 填充背景矩形
 *
 *  @param heightArray y轴数值
 */
- (void)drawXAxisAndFillRectWithYCoordinate:(NSArray*)heightArray
{
    int xCnt = 7;
    CGFloat xStart = 55;

    CGFloat availableWidth = self.bounds.size.width - xStart - 20;
    if(xCnt > 1) {
        CGFloat widthPerStep = availableWidth / (xCnt - 1);
        
        for(int i = 0; i < xCnt; i++) {
            xStart = 55;
            CGFloat x = xStart + widthPerStep * (xCnt - 1 - i);
            
            /*画矩形*/
                //矩形，并填弃颜色
            
            if (i == 0 || i == (xCnt - 1)) {
                xStart = 0;
                availableWidth = self.bounds.size.width;
            }
            if (i % 2 == 0  && i != 0) {
                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, [[heightArray firstObject] floatValue], widthPerStep, [[heightArray lastObject] floatValue] - [[heightArray firstObject] floatValue])];
                v.backgroundColor = UIColorFromRGBHex(0xf7fdff);
                [self addSubview:v];
            }
        }
        
        for(int i = 0; i < xCnt; i++) {
            xStart = 55;
            CGFloat x = xStart + widthPerStep * (xCnt - 1 - i);
            
            /*画矩形*/
                //矩形，并填弃颜色
           
            if (i == 0 || i == (xCnt - 1)) {
                xStart = 0;
                availableWidth = self.bounds.size.width;
            }
           
            NSLog(@"x %f a %f",xStart,availableWidth);
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(xStart, [[heightArray objectAtIndex:i] floatValue], availableWidth, 1)];
            line.backgroundColor = [UIColor grayColor];
            [self addSubview:line];
            
            UILabel *lineY = [[UILabel alloc] initWithFrame:CGRectMake(x, [[heightArray firstObject] floatValue], 1, [[heightArray lastObject] floatValue] - [[heightArray firstObject] floatValue])];
            lineY.backgroundColor = [UIColor grayColor];
            [self addSubview:lineY];
            
           
        }
        
    }
    
}
/**
 *  Y标题
 *
 *  @param arr
 *  @param height
 */
- (void)initYTitle:(NSMutableArray *)arr heightArr:(NSArray *)height
{
    CGFloat lHeight = 30;
    for (int i = 1; i < arr.count - 1; i ++) {
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, [[height objectAtIndex:i] floatValue] - lHeight / 2, 55, lHeight)];
        la.font = [UIFont systemFontOfSize:10];
        la.text = [arr objectAtIndex:i];
        la.textAlignment = NSTextAlignmentCenter;
        la.textColor = [UIColor grayColor];
        [self addSubview:la];
    }
}

/**
 *  x 标题
 *
 *  @param arr
 *  @param height
 */
- (void)initXTitle:(NSArray *)arr heightArr:(NSArray *)height
{
    for (int i = 0; i < arr.count; i++) {
        CGFloat xStart = 55;
        CGFloat kTITLELABLE_COUNT = 7;
        CGFloat  availableWidth = self.frame.size.width - xStart - 20;
        
        
        CGFloat widthPerStep = availableWidth / (arr.count - 1);
        CGFloat xDateLabelOffSet = xStart - 23;
        CGFloat yDateLabelOffSet = 66;
            //偏移
        
        UILabel * dateDabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(i * widthPerStep + xDateLabelOffSet, self.frame.size.height - yDateLabelOffSet, (self.frame.size.width / (kTITLELABLE_COUNT)), 21)];
        dateDabel_1.backgroundColor = [UIColor clearColor];
        dateDabel_1.font = [UIFont systemFontOfSize:11];
        dateDabel_1.text = [arr objectAtIndex:i];
        dateDabel_1.textAlignment = NSTextAlignmentCenter;
        dateDabel_1.textColor = [UIColor grayColor];
        [self addSubview:dateDabel_1];
        
    }
}
/**
*  获取y轴刻度数据
*
*  @param numberArray y值分刻度数据
*  @param maxM        y 值中最大值
*  @param minN        y 值中最小值
*  @param offSet      数据偏移
*/

- (void)initYValueArray:(NSMutableArray*)numberArray maxM:(float)maxM minN:(float)minN offSet:(float)offSet
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

@end
