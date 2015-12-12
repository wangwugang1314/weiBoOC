//
//  YBEmotionKeyBoard.h
//  weiBoOC
//
//  Created by MAC on 15/12/9.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBSingleton.h"
@class YBEmotionKeyBoard;
@class YBEmoticon;

@protocol YBEmotionKeyBoardDelegate <NSObject>

/// 点击调用
- (void)emotionKeyBoard:(YBEmotionKeyBoard *)emotionKeyBoard didSelectAndEmotionModel:(YBEmoticon *)emotionModel;

@end

@interface YBEmotionKeyBoard : UIView

YBSingleton_h(EmotionKeyBoard)

/// 代理
@property(nonatomic, weak) id<YBEmotionKeyBoardDelegate> ybDelegate;

/// 复位
- (void)resect;

@end
