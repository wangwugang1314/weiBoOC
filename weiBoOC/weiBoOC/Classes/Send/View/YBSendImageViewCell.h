//
//  YBSendImageViewCell.h
//  weiBoOC
//
//  Created by MAC on 15/12/13.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBSendImageViewCell;

@protocol YBSendImageViewCellDelegate <NSObject>

/// 删除按钮点击
- (void)delButClickWithSendImageViewCell:(YBSendImageViewCell *)cell;

@end

@interface YBSendImageViewCell : UICollectionViewCell

/// 图片数据
@property(nonatomic, strong) UIImage *image;
/// 是否隐藏删除按钮
@property(nonatomic, assign) BOOL isHiddenDelBut;
/// 代理
@property(nonatomic, weak) id<YBSendImageViewCellDelegate> ybDelegate;

@end
