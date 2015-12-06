//
//  YBNetworking.h
//  weiBoOC
//
//  Created by MAC on 15/11/27.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^networkFinish)(id success, NSError *error);

@interface YBNetworking : NSObject

YBSingleton_h(userModel)

/// AppKey
@property(nonatomic, copy, readonly) NSString *client_id;
/// App Secret
@property(nonatomic, copy, readonly) NSString *client_secret;
/// 回调地址
@property(nonatomic, copy, readonly) NSString *redirect_uri;

/// 加载用户登录数据
+ (void)loadUserLoginData:(NSString *)code andFinish:(networkFinish)finish;
/// 加载用户数据
+ (void)loadUserDataWithFinish:(networkFinish)finish;
/// 加载微薄数据
+ (void)loadWeiBoDataWithNewId:(NSInteger)since_id andOld:(NSInteger)max_id andFinish:(networkFinish)finish;

@end
