//
//  YBEmoticon.h
//  weiBoOC
//
//  Created by MAC on 15/12/10.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBEmoticon : NSObject

/// code (emotion)
@property(nonatomic, copy) NSString *code;
/// chs (普通表情文字)
@property(nonatomic, copy) NSString *chs;
/// png (图片名称)
@property(nonatomic, copy) NSString *png;
/// 删除按钮
@property(nonatomic, copy) NSString *deletex;
/// 使用次数
@property(nonatomic, assign) NSInteger num;

/// 表情数组
+ (NSMutableArray *)emoticonsWithArr:(NSArray *)arr andId:(NSString *)idStr;

@end
