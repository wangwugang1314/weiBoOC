//
//  YBEmotionGroup.h
//  weiBoOC
//
//  Created by MAC on 15/12/10.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBEmotionGroupView;

/// 取消通知
#define YBEmotionGroupViewDesselectNotification @"YBEmotionGroupViewDesselectNotification"

// 代理
@protocol YBEmotionGroupViewDelegate <NSObject>

/// 当选择某行通知
- (void)emotionGroupView:(YBEmotionGroupView *)groupView andSelectIndex:(NSInteger)index;

@end

@interface YBEmotionGroupView : UICollectionView

/// 数据模型
@property(nonatomic, strong) NSArray *dataArr;
/// 代理
@property(nonatomic, weak) id<YBEmotionGroupViewDelegate> ybDelegate;
/// 选中的index
@property(nonatomic, assign) NSInteger selecterIndex;

@end
