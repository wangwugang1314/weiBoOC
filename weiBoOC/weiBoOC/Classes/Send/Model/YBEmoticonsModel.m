//
//  YBEmoticonsModel.m
//  weiBoOC
//
//  Created by MAC on 15/12/10.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBEmoticonsModel.h"
#import "YBEmoticon.h"

@implementation YBEmoticonsModel

/// 构造方法
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

/// 防止kvc
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

/// setter
- (void)setId:(NSString *)id {
    _id = id;
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Emoticons.bundle/%@/info.plist", id] ofType:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    // 设置组名
    self.group_name_cn = dic[@"group_name_cn"];
    // 获取表情数组
    NSArray *arr = dic[@"emoticons"];
    // 遍历数组
    self.emotions = [YBEmoticon emoticonsWithArr:arr andId:id];
}

/// 表情数组
+ (NSArray *)emoticonsModels {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Emoticons.bundle/emoticons.plist" ofType:nil];
    NSArray *arr = [NSDictionary dictionaryWithContentsOfFile:path][@"packages"];
    NSMutableArray *mArr = [NSMutableArray array];
    // 创建最新组
    YBEmoticonsModel *model = [YBEmoticonsModel new];
    model.pageNum = 1;
    model.group_name_cn = @"最近";
    // 添加空数据跟删除数据
    NSMutableArray *emoticons = [NSMutableArray array];
    for(int i = 0; i < 21; i++) {
        YBEmoticon *em = [YBEmoticon new];
        // 如果是最后一个就是删除按钮
        if (i == 20) {
            em.deletex = @"compose_emotion_delete_highlighted";
        }
        [emoticons addObject:em];
    }
    model.emotions = emoticons;
    [mArr addObject:model];
    // 遍历字典
    for (NSDictionary *dic in arr) {
        YBEmoticonsModel *emoticonsModel = [[YBEmoticonsModel alloc] initWithDic:dic];
        emoticonsModel.pageNum = emoticonsModel.emotions.count / 21;
        [mArr addObject:emoticonsModel];
    }
    return [mArr copy];
}

@end
