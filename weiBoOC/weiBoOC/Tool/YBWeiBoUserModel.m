//
//  YBWeiBoUserModel.m
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBWeiBoUserModel.h"

@interface YBWeiBoUserModel ()

/// verified_type 没有认证:-1   认证用户:0  企业认证:2,3,5  达人:220
@property(nonatomic, assign) NSInteger verified_type;
/// 会员等级 1-6
@property(nonatomic, assign) NSInteger mbrank;

@end

@implementation YBWeiBoUserModel

#pragma mark - 构造方法
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

#pragma mark - setter
/// 认证
- (void)setVerified_type:(NSInteger)verified_type {
    _verified_type = verified_type;
    NSString *verifiedStr = @"";
    if (verified_type == 0) { // 认证用户
        verifiedStr = @"avatar_vip";
    }else if (verified_type < 6) { // 企业认证
        verifiedStr = @"avatar_enterprise_vip";
    }else if (verified_type == 220) {// 达人
        verifiedStr = @"avatar_grassroot";
    }
    self.verifiedImage = [UIImage imageNamed:verifiedStr];
}

/// vip
- (void)setMbrank:(NSInteger)mbrank{
    // 如果为0 直接返回
    if (!mbrank) {
        return;
    }
    self.vipImage = [UIImage imageNamed:[NSString stringWithFormat:@"common_icon_membership_level%zd",mbrank]];
}

@end
