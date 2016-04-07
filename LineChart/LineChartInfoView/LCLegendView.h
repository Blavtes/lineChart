//
//  LCLegendView.h
//  ios-linechart
//
//  Created by yong on 16/3/31.
//  Copyright © 2016年 yong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LCLegendView : UIView

@property (nonatomic, strong) UIFont *titlesFont;
@property (strong) NSArray *titles;
@property (strong) NSDictionary *colors; // maps titles to UIColors

@end
