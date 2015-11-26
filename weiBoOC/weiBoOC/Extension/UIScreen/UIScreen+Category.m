//
//  UIScreen+Category.m
//  weiBoOC
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "UIScreen+Category.h"

@implementation UIScreen (Category)

/// bounds
+ (CGRect)bounds {
    return [self mainScreen].bounds;
}

/// 大小
+ (CGSize)size {
    return [self bounds].size;
}

/// 宽度
+ (CGFloat)width {
    return [self size].width;
}

/// 高度
+ (CGFloat)height {
    return [self size].height;
}

@end
