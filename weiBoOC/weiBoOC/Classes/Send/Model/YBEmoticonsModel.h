//
//  YBEmoticonsModel.h
//  weiBoOC
//
//  Created by MAC on 15/12/10.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBEmoticonsModel : NSObject

/// id(文件夹)
@property(nonatomic, copy) NSString *id;
/// 组名
@property(nonatomic, copy) NSString *group_name_cn;
/// emotions
@property(nonatomic, strong) NSMutableArray *emotions;
/// 总页数
@property(nonatomic, assign) NSInteger pageNum;

+ (NSArray *)emoticonsModels;

@end
