//
//  YBEmotionCell.h
//  weiBoOC
//
//  Created by MAC on 15/12/10.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBEmoticon;

@interface YBEmotionCell : UICollectionViewCell

/// 数据
@property(nonatomic, weak) YBEmoticon *emotionModel;

@end
