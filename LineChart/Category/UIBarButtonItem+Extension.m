//
//  UIBarButtonItem+Extension.m
//
//  Created by 李涛 on 15/4/26.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
/**
 *  返回一个barBtn
 *
 *  @param imageName          normal图片
 *  @param highlightImageName 高亮图片
 *  @param taget              taget
 *  @param action             SEL
 *
 *  @return
 */
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName taget:(id)taget action:(SEL)action
{
    //  设置背景图片
    UIButton *barButtonItem = [[UIButton alloc] init];
//    [barButtonItem setBackgroundImage:[UIImage imageWithName:imageName] forState:UIControlStateNormal];
//    [barButtonItem setBackgroundImage:[UIImage imageWithName:highlightImageName] forState:UIControlStateHighlighted];
//    
//    //  设置大小
//    barButtonItem.size = barButtonItem.currentBackgroundImage.size;
//    
//    //  按钮点击高光
//    barButtonItem.showsTouchWhenHighlighted = YES;
//    
//    //  监听点击事件
//    [barButtonItem addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
    
    //  返回自定义UIBarButtonItem
    return [[UIBarButtonItem alloc] initWithCustomView:barButtonItem];
}

/**
 *  返回一个barBtn
 */
+ (instancetype)itemWithTitleStr:(NSString *)title target:(id)target action:(SEL)action
{
    //  设置背景图片
    UIButton *barButtonItem = [[UIButton alloc] init];
    [barButtonItem setTitle:title forState:UIControlStateNormal];
    
    //  设置大小
    barButtonItem.size = CGSizeMake(44, 44);
    
    //  按钮点击高光
    barButtonItem.showsTouchWhenHighlighted = YES;
    
    //  监听点击事件
    [barButtonItem addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //  返回自定义UIBarButtonItem
    return [[UIBarButtonItem alloc] initWithCustomView:barButtonItem];
}
@end
