//
//  YBHomeImageCollectionView.h
//  weiBoOC
//
//  Created by MAC on 15/12/2.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBWeiBoDataModel.h"

/// 点击图片通知
static NSString *YBHomeImageCollectionViewNotification = @"YBHomeImageCollectionViewNotification";

@interface YBHomeImageCollectionView : UICollectionView

/// 数据
@property(nonatomic, strong) YBWeiBoDataModel *dataModel;

@end
