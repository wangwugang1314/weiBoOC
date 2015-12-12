//
//  YBHomeTableViewCell.h
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBWeiBoDataModel;
@class YBHomeTableViewCell;

@protocol YBHomeTableViewCellDelegate <NSObject>

/// 点击链接地址
- (void)homeTableViewCell:(YBHomeTableViewCell *)cell andPathStr:(NSString *)pathStr;

@end

@interface YBHomeTableViewCell : UITableViewCell

/// 代理
@property(nonatomic, weak) id<YBHomeTableViewCellDelegate> ybDelegate;
/// 数据
@property(nonatomic, strong) YBWeiBoDataModel *dataModel;

@end
