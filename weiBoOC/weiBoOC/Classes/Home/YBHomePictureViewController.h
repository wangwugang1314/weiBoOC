//
//  YBHomePictureViewController.h
//  weiBoOC
//
//  Created by MAC on 15/12/5.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBWeiBoDataModel;

@interface YBHomePictureViewController : UICollectionViewController

/// 数据模型
@property(nonatomic, strong) YBWeiBoDataModel *dataModel;

/// 构造方法
- (instancetype)initWithDataModel:(YBWeiBoDataModel *)dataModel;

@end
