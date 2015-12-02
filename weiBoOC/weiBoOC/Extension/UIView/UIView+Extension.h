//
//  UIView+SetRect.h
//  TestPch
//
//  Created by YouXianMing on 14-9-26.
//  Copyright (c) 2014年 YouXianMing. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  Width   [UIScreen mainScreen].bounds.size.width
#define  Height  [UIScreen mainScreen].bounds.size.height

@interface UIView (Extension)

/// 原点
@property (nonatomic) CGPoint orange;
/// size(大小)
@property (nonatomic) CGSize  size;

/// x(orange)
@property (nonatomic) CGFloat x;
/// y(orange)
@property (nonatomic) CGFloat y;

// Frame Size
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

// Frame Borders
@property (nonatomic) CGFloat maxX;
@property (nonatomic) CGFloat maxY;

// Center Point
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

/// 设置圆角半径
@property(nonatomic, assign, readwrite) CGFloat cornerRadius;

@end
