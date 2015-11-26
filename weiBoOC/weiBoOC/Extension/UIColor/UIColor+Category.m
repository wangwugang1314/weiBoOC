//
//  UIColor+Category.m
//  画板
//
//  Created by apple on 15/9/5.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

// 返回一个随机颜色
+ (UIColor *)colorRandom
{
    return [UIColor colorWithRed:arc4random_uniform(256)/ 255.0f green:arc4random_uniform(256)/ 255.0f blue:arc4random_uniform(256)/ 255.0f alpha:1.0];
}

@end
