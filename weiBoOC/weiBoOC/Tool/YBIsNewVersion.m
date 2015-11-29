//
//  YBIsNewVersion.m
//  weiBoOC
//
//  Created by MAC on 15/11/29.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBIsNewVersion.h"

@implementation YBIsNewVersion

/// 判断是否是新版本
+ (BOOL)isNewVersion {
    // 偏好设置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 保存版本号使用的key
    NSString *versionKey = (__bridge NSString *) kCFBundleVersionKey;
    // 获得上一次保存的版本号
    NSString *lastVersion = [defaults objectForKey:versionKey];
    // 获得当前使用的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    // 比较两个版本号是否相同
    if(![lastVersion isEqualToString:currentVersion]) {
        // 是新版本（保存版本号）
        [defaults setObject:currentVersion forKey:versionKey];
        return YES;
    }
    // 不是新版本
    return NO;
}

@end
