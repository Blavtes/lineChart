//
//  NSObject+Extension.h
//  HX_GJS
//
//  Created by litao on 15/9/28.
//  Copyright © 2015年 ZXH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)
/**
 *  函数交换
 *
 *  @param origSelector
 *  @param newIMP
 *
 *  @return didAddMethod
 */
+ (BOOL)swizzleSelector:(SEL)originalSEL withSwizzledSelector:(SEL)swizzledSEL;
    
/**
 *  判断一个对象是否为nil
 */
- (BOOL)isNilObj;
@end
