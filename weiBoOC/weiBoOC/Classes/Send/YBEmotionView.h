//
//  YBEmotionView.h
//  weiBoOC
//
//  Created by MAC on 15/12/10.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBEmotionView;
@class YBEmoticon;

/// 代理
@protocol YBEmotionViewDelegate <NSObject>

/// 当跳转分组的时候调用
- (void)emotionView:(YBEmotionView *)emotionView andIndexPath:(NSIndexPath *)indexPath;
/// 点击的时候调用
- (void)emotionView:(YBEmotionView *)emotionView didSelectAndEmotionModel:(YBEmoticon *)emotionModel;

@end

@interface YBEmotionView : UICollectionView

/// 数据
@property(nonatomic, strong) NSArray *dataArr;
/// 代理
@property(nonatomic, weak) id<YBEmotionViewDelegate> ybDelegate;

@end
