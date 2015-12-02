//
//  YBHomeTableViewCell.h
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBWeiBoDataModel;

@interface YBHomeTableViewCell : UITableViewCell

/// 数据
@property(nonatomic, strong) YBWeiBoDataModel *dataModel;

@end
