//
//  YBEmotionGroupCell.h
//  weiBoOC
//
//  Created by MAC on 15/12/10.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBEmotionGroupCell : UICollectionViewCell

/// 数据
@property(nonatomic, copy) NSString *text;
/// 是否选中
@property(nonatomic, assign) BOOL isSelecter;

@end
