//
//  YBEmoticon.m
//  weiBoOC
//
//  Created by MAC on 15/12/10.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBEmoticon.h"
#import "weiBoOC-swift.h"

@implementation YBEmoticon

/// 构造方法
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (void)setCode:(NSString *)code {
    _code = [YBEmoji emoji:code];
}

/// 表情数组
+ (NSMutableArray *)emoticonsWithArr:(NSArray *)arr andId:(NSString *)idStr {
    NSMutableArray *mArr = [NSMutableArray array];
    
    [arr enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        // 判断当前个数等于20的倍数
        if (idx % 20 == 0 && idx != 0) {
            [mArr addObject: [YBEmoticon emoticonDel]];
        }
        YBEmoticon *emoticomModel = [[YBEmoticon alloc] initWithDic:dic];
        if (emoticomModel.png != nil) {
            emoticomModel.png = [NSString stringWithFormat:@"Emoticons.bundle/%@/%@",idStr, emoticomModel.png];
            emoticomModel.png = [emoticomModel.png stringByReplacingOccurrencesOfString:@".png" withString:@"@2x.png"];
            emoticomModel.png = [[NSBundle mainBundle] pathForResource:emoticomModel.png ofType:nil];
        }
        [mArr addObject: emoticomModel];
    }];
    // 查看数组个数
    for (int i = (mArr.count % 21); i < 20; i++) {
        [mArr addObject: [YBEmoticon new]];
    }
    [mArr addObject: [YBEmoticon emoticonDel]];
    return mArr;
}

/// 删除按钮
+ (instancetype)emoticonDel {
    YBEmoticon *emo = [YBEmoticon new];
    emo.deletex = @"compose_emotion_delete_highlighted";
    return emo;
}

@end
