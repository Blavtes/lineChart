    //
    //  LCLineChartView.m
    //
    //
    //  Created by yong on 16/4/1.
    //  Copyright © 2016年 yong. All rights reserved.
    //

#import "LCLineChartView.h"
#import "LCLegendView.h"
#import "LCInfoView.h"
#import "UIKit+DrawingHelpers.h"
#import "LineChart.h"

@interface LCLineChartDataItem ()

@property (readwrite) double x; // should be within the x range
@property (readwrite) double y; // should be within the y range
@property (readwrite) NSString *xLabel; // label to be shown on the x axis
@property (readwrite) NSString *dataLabel; // label to be shown directly at the data item

- (id)initWithhX:(double)x y:(double)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel;

@end

@implementation LCLineChartDataItem

- (id)initWithhX:(double)x y:(double)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel {
    if((self = [super init])) {
        self.x = x;
        self.y = y;
        self.xLabel = xLabel;
        self.dataLabel = dataLabel;
    }
    return self;
}

+ (LCLineChartDataItem *)dataItemWithX:(double)x y:(double)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel {
    return [[LCLineChartDataItem alloc] initWithhX:x y:y xLabel:xLabel dataLabel:dataLabel];
}

@end



@implementation LCLineChartData

- (id)init {
    self = [super init];
    if(self) {
        self.drawsDataPoints = YES;
    }
    return self;
}

@end



@interface LCLineChartView ()

@property LCLegendView *legendView;
@property LCInfoView *infoView;
@property UIView *currentPosView;
@property UILabel *xAxisLabel;

- (BOOL)drawsAnyData;

@property LCLineChartData *selectedData;
@property NSUInteger selectedIdx;
@property (nonatomic, weak) UIView *weakBt;
@property (nonatomic, weak) UIView *monthBt;
@property (nonatomic, weak) UIView *quaterBt;
@end


#define X_AXIS_SPACE 15
#define PADDING 10
#define kDesign_xOffSet 55   //设计偏移

@implementation LCLineChartView
@synthesize data = _data;

- (void)setDefaultValues {
    self.currentPosView = [[UIView alloc] initWithFrame:CGRectMake(PADDING, PADDING, 1 / self.contentScaleFactor, 50)];
    self.currentPosView.backgroundColor = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
    self.currentPosView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.currentPosView.alpha = 0.0;
    [self addSubview:self.currentPosView];
    
    self.legendView = [[LCLegendView alloc] init];
    self.legendView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin ;
    self.legendView.backgroundColor = [UIColor clearColor];
    self.legendView.hidden = KLEGENDVIEW_HIDDEN;
    [self addSubview:self.legendView];
    
    self.axisLabelColor = kYAXIS_COLOR;
    
    self.xAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    self.xAxisLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.xAxisLabel.font = [UIFont boldSystemFontOfSize:10];
    self.xAxisLabel.textColor = self.axisLabelColor;
    self.xAxisLabel.textAlignment = NSTextAlignmentCenter;
    self.xAxisLabel.alpha = 0.0;
    self.xAxisLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.xAxisLabel];
    
    self.backgroundColor = [UIColor whiteColor];
    self.scaleFont = [UIFont systemFontOfSize:10.0];
    
    self.autoresizesSubviews = YES;
    self.contentMode = UIViewContentModeRedraw;
    
    self.drawsDataPoints = YES;
    self.drawsDataLines  = YES;
    self.drawLinePoints  = YES;
    self.selectedIdx = INT_MAX;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clikView:)];
    [self addGestureRecognizer:tap];

}



- (void)clikView:(UITapGestureRecognizer*)tap
{
    DLog(@"%s tap %@",__FUNCTION__,tap);
    if (self.clickLineChartCallback)
        self.clickLineChartCallback();
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if((self = [super initWithCoder:aDecoder])) {
        [self setDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self setDefaultValues];
    }
    return self;
}

- (void)setAxisLabelColor:(UIColor *)axisLabelColor {
    if(axisLabelColor != _axisLabelColor) {
        [self willChangeValueForKey:@"axisLabelColor"];
        _axisLabelColor = axisLabelColor;
        self.xAxisLabel.textColor = axisLabelColor;
        [self didChangeValueForKey:@"axisLabelColor"];
    }
}

- (void)showLegend:(BOOL)show animated:(BOOL)animated {
    if(! animated) {
        self.legendView.alpha = show ? 1.0 : 0.0;
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.legendView.alpha = show ? 1.0 : 0.0;
    }];
}

- (void)layoutSubviews {
    [self.legendView sizeToFit];
    CGRect r = self.legendView.frame;
    r.origin.x = self.bounds.size.width - self.legendView.frame.size.width - 3 - PADDING;
    r.origin.y = 3 + PADDING;
    self.legendView.frame = r;
    
    r = self.currentPosView.frame;
    CGFloat h = self.bounds.size.height;
    r.size.height = h - 2 * PADDING - X_AXIS_SPACE;
    self.currentPosView.frame = r;
    
    [self.xAxisLabel sizeToFit];
    r = self.xAxisLabel.frame;
    r.origin.y = self.bounds.size.height - X_AXIS_SPACE - PADDING + 2;
    self.xAxisLabel.frame = r;
    
    [self bringSubviewToFront:self.legendView];
}

- (void)setData:(NSArray *)data {
    if(data != _data) {
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[data count]];
        NSMutableDictionary *colors = [NSMutableDictionary dictionaryWithCapacity:[data count]];
        for(LCLineChartData *dat in data) {
            NSString *key = dat.title;
            if(key == nil) key = @"";
            [titles addObject:key];
            [colors setObject:dat.color forKey:key];
        }
        self.legendView.titles = titles;
        self.legendView.colors = colors;
        self.selectedData = nil;
        self.selectedIdx = INT_MAX;
        
        _data = data;
        
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
        //开始位置 为45  最后 少26
        //画线y轴位置
//    NSArray *heightArray =  @[@(0.5),@(20),@(64),@(105),@(150),@(178)];
    NSArray *heightArray =  @[@(0.5),@(20),@(55),@(90),@(125),@(160),@(178)];

        //    NSArray *heightArray =@[@(45),@(65),@(109),@(150),@(195),@(223)];
#pragma mark ==== x 虚线 ===
    
    [self drawXAxisAndFillRectWithYCoordinate:heightArray];
        //--- xy -- background
    [self drawYAxisAndYTitleWithYCoordinate:heightArray];
        //重置画布
    
    
    if (!self.drawsAnyData) {
        DLog(@"You configured LineChartView to draw neither lines nor data points. No data will be visible. This is most likely not what you wanted. (But we aren't judging you, so here's your chart background.)");
    } // warn if no data will be drawn
    
#pragma mark === 画线===
        //检查是否有数据，无数据不划线
    if (!_drawLinePoints) {
        return;
    }
    
    [self drawPointAndLinesWithYCoordinate:heightArray];
}

/**
 *  画x轴线 和 填充背景矩形
 *
 *  @param heightArray y轴数值
 */
- (void)drawXAxisAndFillRectWithYCoordinate:(NSArray*)heightArray
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(c);
    CGContextSetLineWidth(c, 1.0);
    
    NSUInteger xCnt = self.xStepsCount;
    CGFloat xStart = kDesign_xOffSet;
    CGFloat availableWidth = self.bounds.size.width - xStart - 20;
    
    if(xCnt > 1) {
        CGFloat widthPerStep = availableWidth / (xCnt - 1);
        
        [[UIColor grayColor] set];
        for(NSUInteger i = 0; i < xCnt; ++i) {
            CGFloat x = xStart + widthPerStep * (xCnt - 1 - i);
            
            /*画矩形*/
                //矩形，并填弃颜色
            if (i % 2 == 0  && i != 0) {
                    //                DLog(@"i == %d xc %d",i ,xCnt);
                CGContextSetLineWidth(c, 1.0);//线的宽度
                UIColor *aColor = kRECT_BLUE_COLOR;//blue蓝色
                CGContextSetFillColorWithColor(c, aColor.CGColor);//填充颜色
                
                aColor = kXSHORT_DASH_LINE_COLOR;
                CGContextSetStrokeColorWithColor(c, aColor.CGColor);//线框颜色
                CGContextAddRect(c,CGRectMake(round(x) , 0, widthPerStep, [[heightArray lastObject] floatValue]));//画方框
                CGContextDrawPath(c, kCGPathFillStroke);//绘画路径
            }
            
            [kXSHORT_DASH_LINE_COLOR set];
            CGContextMoveToPoint(c, round(x) , 0);
            CGContextAddLineToPoint(c, round(x) , [[heightArray lastObject] floatValue]);
            CGContextStrokePath(c);
            
        }
    }
}


/**
 *  画y轴 y轴标题
 *
 *  @param heightArray heightArray description
 */
- (void)drawYAxisAndYTitleWithYCoordinate:(NSArray*)heightArray
{
    CGContextRef c = UIGraphicsGetCurrentContext();
//    CGFloat yStart = PADDING ;
    
    for(int i = 0; i < self.ySteps.count;i++) {
        
            //        [self.axisLabelColor set];
        [kYAXIS_COLOR set];
        CGFloat h = [self.scaleFont lineHeight];
        CGFloat y = [[heightArray objectAtIndex:i] floatValue];
            // * (yCnt - 1 - i);
            //        CGFloat x = xStart + heightPerStep * (yCnt - 1 - i);
            // TODO: replace with new text APIs in iOS 7 only version
#pragma clang diagnostic push ==== y 轴线====  y title
        
        if ( i != self.ySteps.count - 1  && i != 0) {
            if (i < self.ySteps.count) {
                NSString *step = [self.ySteps objectAtIndex:i];

                step = [NSString stringWithFormat:@"%.4f" ,[step floatValue]];
//                DLog(@"step %@",step);
                if (IOS7) {
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
                    paragraphStyle.alignment = NSTextAlignmentRight;
                    NSDictionary *attributes = @{NSFontAttributeName:self.scaleFont,
                                                 NSParagraphStyleAttributeName:paragraphStyle,
                                                 NSForegroundColorAttributeName:[UIColor lightGrayColor]};
                    
                    [step drawInRect:CGRectMake(0, y - h / 2, self.yAxisLabelsWidth , h)
                      withAttributes:attributes];
                } else {
                    
                    [step drawInRect:CGRectMake(0, y - h / 2, self.yAxisLabelsWidth , h)
                            withFont:self.scaleFont
                       lineBreakMode:NSLineBreakByClipping
                           alignment:NSTextAlignmentRight];
                }
//                DLog(@"%s y %f h %f %@",__FUNCTION__,y , [[heightArray objectAtIndex:i] floatValue],step);
            }
        }
        
        
#pragma clagn diagnostic pop
        
        [kYSHORT_DASH_LINE_COLOR set];
        CGFloat x = 0;
        if (i != 0 && i != self.ySteps.count) {
            x = kDesign_xOffSet; //设计
        }
        CGFloat wPadding = PADDING;
        if (i == 0) {
            wPadding = 0;
        }
            //        CGContextSetLineDash(c, 0, dashedPattern, 2);//虚线
            //        CGContextMoveToPoint(c, xStart, round(y) + 0.5);
            //        CGContextAddLineToPoint(c, self.bounds.size.width - PADDING, round(y) + 0.5);
        CGContextMoveToPoint(c, x, [[heightArray objectAtIndex:i] floatValue]);
        CGContextAddLineToPoint(c, self.bounds.size.width - wPadding, [[heightArray objectAtIndex:i] floatValue]);
        if (i == self.ySteps.count - 2) {
            CGContextMoveToPoint(c, 0, [[heightArray objectAtIndex:i+1] floatValue]);
            CGContextAddLineToPoint(c, self.bounds.size.width , [[heightArray objectAtIndex:i+1] floatValue]);
        }
        CGContextStrokePath(c);
    }
    CGContextRestoreGState(c);
}

/**
 *  画折线图中的 线段 和最后一个点
 */
- (void)drawPointAndLinesWithYCoordinate:(NSArray*)heightArray
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGFloat yStart = PADDING / 2;
    CGFloat xStart = kDesign_xOffSet;
    CGFloat availableWidth = self.bounds.size.width - xStart - 20;
    CGFloat perXwidth = availableWidth / (kTITLELABLE_COUNT - 1);
    
    CGFloat availableHeight = self.bounds.size.height - 2 * PADDING - X_AXIS_SPACE;
    
    CGFloat yRangeLen = self.yMax - self.yMin;
    CGFloat yOffSet = self.frame.size.height * 0.05; //视图高度 * 精度
    if(yRangeLen == 0) yRangeLen = 1;
    
    int i = 0;

    for(LCLineChartData *data in self.data) {
        if (self.drawsDataLines) {
            double xRangeLen = data.xMax - data.xMin;
            if(xRangeLen == 0) xRangeLen = 1;
            if(data.itemCount >= 2) {
                LCLineChartDataItem *dataItem = data.getData(0);
                CGFloat yyOffSet = 0;
                
                CGMutablePathRef path = CGPathCreateMutable();
//                CGFloat prevX = xStart + round(((dataItem.x - data.xMin) / xRangeLen) * availableWidth);
                CGFloat prevX = xStart + perXwidth * i;
                i ++;
                CGFloat prevY = yStart + round((1 - (dataItem.y - self.yMin) / yRangeLen) * availableHeight) ;
                
                
                CGFloat ys = prevY + yyOffSet;
                
                
                ys = [self getCurrentPositionYWithItemData:dataItem heightArray:heightArray yStart:ys  offSet:0 isDrawRect:NO];
                    ////
                    //                CGPathMoveToPoint(path, NULL, prevX, prevY + yyOffSet);
                
                CGPathMoveToPoint(path, NULL, prevX, ys);
                for(NSUInteger i = 1; i < data.itemCount ; i++) {
                    LCLineChartDataItem *dataItem = data.getData(i);
                    yyOffSet = 0;
                    
//                    CGFloat x = xStart + round(((dataItem.x - data.xMin) / xRangeLen) * availableWidth);
                    CGFloat x = xStart + perXwidth * i;

                    CGFloat y = yStart + round((1 - (dataItem.y - self.yMin) / yRangeLen) * availableHeight) + yyOffSet ;
                    CGFloat yy = [self getCurrentPositionYWithItemData:dataItem heightArray:heightArray yStart:y offSet:0 isDrawRect:NO];
                    
                    CGPathAddLineToPoint(path, NULL, x, yy );
                    
                    prevX = x;
                    prevY = yy ;
                }
                
                CGContextAddPath(c, path);
                CGContextSetStrokeColorWithColor(c, kLINECHART_COLOR.CGColor);
                CGContextSetLineWidth(c, 2);
                CGContextStrokePath(c);
                
                CGPathRelease(path);
            }
        } // draw actual chart data
        
#pragma mark === 画点 最后一个数据提示 ====
        
        [self drawLastPonitWithContext:c
                         lineChartData:data
                        availableWidth:availableWidth
                       availableHeight:availableHeight
                           heightArray:heightArray
                                xStart:xStart
                                yStart:yStart
                               yOffSet:yOffSet];
    }
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
- (CGFloat)getCurrentPositionYWithItemData:(LCLineChartDataItem*)dataItem
                               heightArray:(NSArray*)heightArray
                                    yStart:(CGFloat)yStart
                                    offSet:(CGFloat)offSet
                                isDrawRect:(BOOL)isRectNoti
{
    CGFloat yy = yStart;
    CGFloat rectHeight = offSet;
    //第6条线，不可能比它更低
//    CGFloat endY = [[self.ySteps objectAtIndex:5] floatValue];
        //第5条线
    CGFloat lastY = [[self.ySteps objectAtIndex:4] floatValue];
        //第4条线
    CGFloat minY  = [[self.ySteps objectAtIndex:3] floatValue];
        //第2条线 有可能在它的上面
    CGFloat maxY  = [[self.ySteps objectAtIndex:1] floatValue];
        //第3条线 中线 附近
    CGFloat middleY = [[self.ySteps objectAtIndex:2] floatValue];
    
//    DLog(@"%s %s %d middleY %f da %f",__FILE__,__FUNCTION__,__LINE__,middleY ,dataItem.y);
        //第一条线
    CGFloat firstY = [[self.ySteps firstObject] floatValue];
    if (dataItem.y > maxY ) { // 第一区
         //第1梯度高度
        CGFloat yPerLenth = [[heightArray objectAtIndex:1] floatValue] - [[heightArray objectAtIndex:0] floatValue];
        //比例高度+ 偏移
        yy = -yPerLenth * (dataItem.y - maxY ) / ( firstY - maxY) + [[heightArray objectAtIndex:1] floatValue];
        rectHeight =  10 * (dataItem.y - maxY) / ( firstY - maxY) + [[heightArray objectAtIndex:1] floatValue] - offSet;
    } else if (dataItem.y >= middleY && dataItem.y <= maxY) {// 第2区
        //第2梯度高度
        CGFloat yPerLenth = [[heightArray objectAtIndex:2] floatValue] - [[heightArray objectAtIndex:1] floatValue];
        yy = -yPerLenth * (dataItem.y - middleY) / ( maxY - middleY) + [[heightArray objectAtIndex:2] floatValue];
        rectHeight = yStart - offSet;
//        DLog(@"ystart 2 %f rectHeight %f",yStart,rectHeight);

    } else if (dataItem.y >= minY && dataItem.y <= middleY) {// 第3区
        //第3梯度高度
        CGFloat yPerLenth = [[heightArray objectAtIndex:3] floatValue] - [[heightArray objectAtIndex:2] floatValue];
        yy = -yPerLenth * (dataItem.y - minY) / ( middleY - minY) + [[heightArray objectAtIndex:3] floatValue];
        rectHeight = yStart - offSet;
//        DLog(@"ystart 3 %f rectHeight %f",yStart,rectHeight);

    } else if (dataItem.y <= minY) {// 第4区
        
            //第4梯度高度
        CGFloat yPerLenth = [[heightArray objectAtIndex:4] floatValue] - [[heightArray objectAtIndex:3] floatValue];
        yy = -yPerLenth * (dataItem.y - lastY) / (minY - lastY) + [[heightArray objectAtIndex:4] floatValue];
        rectHeight = yy - offSet;
//        DLog(@"ystart 4 %f rectHeight %f",yStart,rectHeight);
    } else { // 第5区
        yy = yStart;
        rectHeight = yStart - offSet;
//        DLog(@"ystart %f rectHeight %f",yStart,rectHeight);
    }
    if (isRectNoti) {
        return rectHeight;
    }
    
    return yy;
}

/**
 *  画最后一个数据提示
 *
 *  @param data            data description
 *  @param c               c description
 *  @param availableWidth  availableWidth description
 *  @param availableHeight availableHeight description
 *  @param xStart          xStart description
 *  @param yStart          yStart description
 *  @param yOffSet         yOffSet description
 */
- (void)drawLastPonitWithContext:(CGContextRef)c
                   lineChartData:(LCLineChartData*)data
                  availableWidth:(CGFloat)availableWidth
                 availableHeight:(CGFloat)availableHeight
                     heightArray:(NSArray*)heightArray
                          xStart:(CGFloat)xStart
                          yStart:(CGFloat)yStart
                         yOffSet:(CGFloat)yOffSet

{
    
    if (self.drawsDataPoints) {
        if (data.drawsDataPoints) {
            double xRangeLen = data.xMax - data.xMin;
            if(xRangeLen == 0) xRangeLen = 1;
                //            for(NSUInteger i = data.itemCount -1; i < data.itemCount; ++i) {
            LCLineChartDataItem *dataItem = data.getData(data.itemCount -1);
            CGFloat xVal = xStart + round((xRangeLen == 0 ? 0.5 : ((dataItem.x - data.xMin) / xRangeLen)) * availableWidth);
            CGFloat yVal = yStart + round((1.0 - (dataItem.y - self.yMin) / [self getYRangeLen]) * availableHeight);
            
            CGFloat rectOffSet = 20.0f;
            
            CGFloat rectY = yVal - rectOffSet;
            
            
            yVal = [self getCurrentPositionYWithItemData:dataItem heightArray:heightArray yStart:yVal offSet:0 isDrawRect:NO];
            rectY = [self getCurrentPositionYWithItemData:dataItem heightArray:heightArray yStart:yVal offSet:rectOffSet isDrawRect:YES];
            [kCIRCLE_DOT_COLOR setFill];
            CGFloat pointWidth = 6.0f;
            CGContextFillEllipseInRect(c, CGRectMake(MAIN_SCREEN_WIDTH - 20  - pointWidth / 2, yVal - pointWidth / 2, pointWidth, pointWidth));
            
            CGContextRef c = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(c, [kLINECHART_COLOR CGColor]);
            CGFloat rectWidth = 46;
                //提示框
            CGContextFillRoundedRect(c, CGRectMake(MAIN_SCREEN_WIDTH - 20 - 2 - rectWidth, rectY - 2, rectWidth, 15), 17);
            
            NSString *titles = [NSString stringWithFormat:@"%.4f",[dataItem.dataLabel floatValue]];
            if (IOS7) {
                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
                paragraphStyle.alignment = NSTextAlignmentCenter;
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:kCommonFontSizeSubSubDesc],
                                             NSParagraphStyleAttributeName:paragraphStyle,
                                             NSForegroundColorAttributeName:[UIColor whiteColor]};
                
                [titles drawAtPoint:CGPointMake(MAIN_SCREEN_WIDTH - 20  + 2 - rectWidth, rectY - 2)
                     withAttributes:attributes];
            } else {
                [[UIColor whiteColor] set];
                
                [titles drawAtPoint:CGPointMake(MAIN_SCREEN_WIDTH - 20  + 2 - rectWidth, rectY - 2)
                           withFont:[UIFont systemFontOfSize:kCommonFontSizeSubSubDesc]];
            }
            
                //            } // for
        } // data - draw data points
    } // draw data points
}

/**
 *  获取 y 值划线范围长度
 *
 *  @return return value description
 */
- (CGFloat)getYRangeLen
{
    CGFloat yRangeLen = self.yMax - self.yMin;
    if(yRangeLen == 0) yRangeLen = 1;
    return yRangeLen;
}

- (void)showIndicatorForTouch:(UITouch *)touch {
    if(! self.infoView) {
        self.infoView = [[LCInfoView alloc] init];
        [self addSubview:self.infoView];
    }
    
    CGPoint pos = [touch locationInView:self];
    CGFloat xStart = PADDING + self.yAxisLabelsWidth;
    CGFloat yStart = PADDING;
    CGFloat yRangeLen = self.yMax - self.yMin;
    if(yRangeLen == 0) yRangeLen = 1;
    CGFloat xPos = pos.x - xStart;
    CGFloat yPos = pos.y - yStart;
    CGFloat availableWidth = self.bounds.size.width - 2 * PADDING - self.yAxisLabelsWidth;
    CGFloat availableHeight = self.bounds.size.height - 2 * PADDING - X_AXIS_SPACE;
    
    LCLineChartDataItem *closest = nil;
    LCLineChartData *closestData = nil;
    NSUInteger closestIdx = INT_MAX;
    double minDist = DBL_MAX;
    double minDistY = DBL_MAX;
    CGPoint closestPos = CGPointZero;
    
    for(LCLineChartData *data in self.data) {
        double xRangeLen = data.xMax - data.xMin;
        
            // note: if necessary, could use binary search here to speed things up
        for(NSUInteger i = 0; i < data.itemCount; ++i) {
            LCLineChartDataItem *dataItem = data.getData(i);
            CGFloat xVal = round((xRangeLen == 0 ? 0.0 : ((dataItem.x - data.xMin) / xRangeLen)) * availableWidth);
            CGFloat yVal = round((1.0 - (dataItem.y - self.yMin) / yRangeLen) * availableHeight);
            
            double dist = fabs(xVal - xPos);
            double distY = fabs(yVal - yPos);
            if(dist < minDist || (dist == minDist && distY < minDistY)) {
                minDist = dist;
                minDistY = distY;
                closest = dataItem;
                closestData = data;
                closestIdx = i;
                closestPos = CGPointMake(xStart + xVal - 3, yStart + yVal - 7);
            }
        }
    }
    
    if(closest == nil || (closestData == self.selectedData && closestIdx == self.selectedIdx))
        return;
    
    self.selectedData = closestData;
    self.selectedIdx = closestIdx;
    
    self.infoView.infoLabel.text = closest.dataLabel;
    self.infoView.tapPoint = closestPos;
    [self.infoView sizeToFit];
    [self.infoView setNeedsLayout];
    [self.infoView setNeedsDisplay];
    
    if(self.currentPosView.alpha == 0.0) {
        CGRect r = self.currentPosView.frame;
        r.origin.x = closestPos.x + 3 - 1;
        self.currentPosView.frame = r;
    }
#pragma mark == 点击虚线动画显示 ====
    
    [UIView animateWithDuration:0.1 animations:^{
        self.infoView.alpha = 1.0;
        self.currentPosView.alpha = 1.0;
            //        self.xAxisLabel.alpha = 1.0;
        
        CGRect r = self.currentPosView.frame;
        r.origin.x = closestPos.x + 3 - 1;
        self.currentPosView.frame = r;
        
        self.xAxisLabel.text = closest.xLabel;
        if(self.xAxisLabel.text != nil) {
            [self.xAxisLabel sizeToFit];
            r = self.xAxisLabel.frame;
            r.origin.x = round(closestPos.x - r.size.width / 2);
            self.xAxisLabel.frame = r;
        }
    }];
    
    if(self.selectedItemCallback != nil) {
        self.selectedItemCallback(closestData, closestIdx, closestPos);
    }
}

- (void)hideIndicator {
    if(self.deselectedItemCallback)
        self.deselectedItemCallback();
    
    self.selectedData = nil;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.infoView.alpha = 0.0;
        self.currentPosView.alpha = 0.0;
        self.xAxisLabel.alpha = 0.0;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
//    if (self.clickLineChartCallback)
//        self.clickLineChartCallback();
//    [self showIndicatorForTouch:[touches anyObject]];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self showIndicatorForTouch:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self hideIndicator];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self hideIndicator];
}


#pragma mark Helper methods

- (BOOL)drawsAnyData {
    return self.drawsDataPoints || self.drawsDataLines;
}

    // TODO: This should really be a cached value. Invalidated iff ySteps changes.
- (CGFloat)yAxisLabelsWidth {
    double maxV = 0;
    for(NSString *label in self.ySteps) {
        CGSize labelSize = [label sizeWithFont:self.scaleFont];
        if(labelSize.width > maxV) maxV = labelSize.width;
    }
    return maxV + PADDING;
}

@end
