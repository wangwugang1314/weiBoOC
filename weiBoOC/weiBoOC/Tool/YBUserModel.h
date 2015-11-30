//access_token	string	用于调用access_token，接口获取授权后的access token。
//expires_in	string	access_token的生命周期，单位是秒数。
//remind_in	string	access_token的生命周期（该参数即将废弃，开发者请使用expires_in）。
//uid	string	当前授权用户的UID。

#import <Foundation/Foundation.h>

// 数据加载是否成功
typedef void (^loadUserDataFinish)(BOOL isSuccess);

@interface YBUserModel : NSObject

/// 接口获取授权后的access token
@property(nonatomic, copy) NSString *access_token;
/// 当前授权用户的UID
@property(nonatomic, copy) NSString *uid;
/// 是否登录
@property(nonatomic, assign) BOOL isLogin;
/// 用户昵称
@property(nonatomic, copy) NSString *screen_name;
/// 头像地址
@property(nonatomic, copy) NSString *avatar_large;

/// 加载网络数据
+ (void)loadUserLoginData:(NSString *)code isLoadSuccess:(loadUserDataFinish)isSuccess;
// 获取数据
+ (instancetype)userModel;
/// 退出登录
+ (void)exitLogin;

@end
