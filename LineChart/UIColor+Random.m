//
//  UIColor+Random.m
//  X8General
//
//  Created by yong on 16/4/1.
//  Copyright © 2016年  yong. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
