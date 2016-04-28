//
//  YBSendTextView.h
//  weiBoOC
//
//  Created by MAC on 15/12/9.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBSendImageView;

@interface YBSendTextView : UITextView

/// 图片试图
@property(nonatomic, weak) YBSendImageView *imageCollectionView;

// 文本发生改变调用
- (void)textViewDidChange:(UITextView *)textView;

@end
