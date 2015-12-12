//
//  YBNetworking.m
//  weiBoOC
//
//  Created by MAC on 15/11/27.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBNetworking.h"
#import <AFNetworking.h>

@interface YBNetworking ()

/// 网络加载框架
@property(nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation YBNetworking

YBSingleton_m(userModel)

#pragma mark - 加载微薄数据
/// 加载微薄数据
+ (void)loadWeiBoDataWithNewId:(NSInteger)since_id andOld:(NSInteger)max_id andFinish:(networkFinish)finish {
    // 地址
    NSString *path = @"/2/statuses/home_timeline.json";
    // 参数
    YBUserModel *userModel = [YBUserModel userModel];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:userModel.access_token forKey:@"access_token"];
    // 如果是加载新数据
    if (since_id != 0) {
        [dic setObject:@(since_id) forKey:@"since_id"];
    }else if (max_id != 0) {
        [dic setObject:@(max_id) forKey:@"max_id"];
    }
    // 发送网络请求
    [[YBNetworking shareduserModel] GET:path parameters:[dic copy] andFinish:^(id success, NSError *error) {
        finish(success[@"statuses"], error);
    }];
}

#pragma mark - 加载用户数据
/// 加载用户登录数据
+ (void)loadUserLoginData:(NSString *)code andFinish:(networkFinish)finish{
    // 链接
    NSString *path = @"/oauth2/access_token";
    // 参数
    YBNetworking *networking = [YBNetworking shareduserModel];
    NSDictionary *dic = @{@"client_id": networking.client_id,
                          @"client_secret": networking.client_secret,
                          @"grant_type": @"authorization_code",
                          @"code": code,
                          @"redirect_uri": networking.redirect_uri};
    // 加载数据
    [networking POST:path parameters:dic andFinish:^(id success, NSError *error) {
        finish(success, error);
    }];
}

/// 加载用户数据
+ (void)loadUserDataWithFinish:(networkFinish)finish {
    // 链接
    NSString *path = @"/2/users/show.json";
    // 参数
    YBUserModel *userModel = [YBUserModel userModel];
    NSDictionary *dic = @{@"access_token":userModel.access_token,
                          @"uid": userModel.uid};
    // 加载数据
    [[YBNetworking shareduserModel] GET:path parameters:dic andFinish:^(id success, NSError *error) {
        finish(success, error);
    }];
}


#pragma mark - 封装网络框架
- (void)POST:(NSString *)URLString parameters:(nullable id)parameters andFinish:(networkFinish)finish {
    // 网络加载数据
    [self.manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        finish(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finish(nil, error);
    }];
}

- (void)GET:(NSString *)URLString parameters:(nullable id)parameters andFinish:(networkFinish)finish {
    // 网络加载数据
    [self.manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        finish(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finish(nil, error);
    }];
}

#pragma mark - 懒加载
/// 懒加载网络框架
- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.weibo.com/"]];
        // 添加解析方法
        NSMutableSet *mSet = [NSMutableSet setWithSet:_manager.responseSerializer.acceptableContentTypes];
        [mSet addObject:@"text/plain"];
        _manager.responseSerializer.acceptableContentTypes = [mSet copy];
    }
    return _manager;
}

/// AppKey
- (NSString *)client_id{
    return @"2811696621";
}

/// App Secret
- (NSString *)client_secret{
    return @"283af988db3ec9bbb6fbb8cd41ec9d7c";;
}

/// 回调地址
- (NSString *)redirect_uri{
    return @"https://www.baidu.com/";
}

@end
