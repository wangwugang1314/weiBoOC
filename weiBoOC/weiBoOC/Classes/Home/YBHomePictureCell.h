//
//  YBHomePictureCell.h
//  weiBoOC
//
//  Created by MAC on 15/12/5.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBHomePictureCell;

/// 代理
@protocol YBHomePictureCellDelegate <NSObject>

/// 当先缩小到一定范围就返回
- (void)homePictureCell:(YBHomePictureCell *)cell;

@end

/// 最小缩放比例
#define YBHomePictureCellMinZoomScale 0.6

@interface YBHomePictureCell : UICollectionViewCell

/// imageView
@property(nonatomic, weak) UIImageView *imageView;
/// imageUrl
@property(nonatomic, strong) NSURL *imageURL;
/// 代理
@property(nonatomic, weak) id<YBHomePictureCellDelegate> ybDelegate;

@end
