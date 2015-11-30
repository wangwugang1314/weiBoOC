#import "YBUserModel.h"
#import "YBNetworking.h"

@interface YBUserModel ()<NSCoding>

/// access_token的生命周期，单位是秒数。
@property(nonatomic, copy) NSString *expires_in;
/// 超时时间
@property(nonatomic, strong) NSDate *overtime;

@end

@implementation YBUserModel

YBSingleton_m(userModel)

#pragma mark - 加载数据
/// 加载网络数据
+ (void)loadUserLoginData:(NSString *)code isLoadSuccess:(loadUserDataFinish)isSuccess {
    // 加载数据
    [YBNetworking loadUserLoginData:code andFinish:^(id success, NSError *error) {
        // 判断是都加载成功
        if (success != nil && error == nil) {
            // 数据加载成功
            isSuccess(YES);
            YBUserModel *userModel = [YBUserModel shareduserModel];
            // KVC
            [userModel setValuesForKeysWithDictionary:success];
            // 设置登录
            userModel.isLogin = YES;
            // 加载数据
            [YBUserModel loadUserData];
        }else{
            // 数据加载失败
            isSuccess(NO);
        }
    }];
}

/// 加载数据
+ (void)loadUserData {
    [YBNetworking loadUserDataWithFinish:^(id success, NSError *error) {
        if (success != nil && error == nil) {
            // 成功（转模型）
            [[YBUserModel shareduserModel] setValuesForKeysWithDictionary:success];
            // 保存数据
            [[YBUserModel shareduserModel] saveData];
        }else{
            // 失败
            [SVProgressHUD showErrorWithStatus:@"用户数据加载失败"];
        }
    }];
}

/// kvc防止崩掉
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

#pragma mark - 数据
/// 保存数据
- (void)saveData{
    [NSKeyedArchiver archiveRootObject:[YBUserModel shareduserModel] toFile:[YBUserModel path]];
}

// 获取数据
+ (instancetype)userModel{
    // 获取数据
    YBUserModel *userModel = [YBUserModel shareduserModel];
    // 如果没有登录就去本地取数据
    if(!userModel.isLogin){
        userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[self path]];
    }
    // 判断是都超时
    if([userModel.overtime compare:[NSDate date]] == NSOrderedDescending) {
        userModel.isLogin = NO;
    }
    return userModel;
}

/// 退出登录
+ (void)exitLogin{
    [YBUserModel shareduserModel].isLogin = NO;
    [[YBUserModel shareduserModel] saveData];
}

#pragma mark - 归档
/// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.overtime forKey:@"overtime"];
    [aCoder encodeBool:self.isLogin forKey:@"isLogin"];
    // 用户名称
    [aCoder encodeObject:self.screen_name forKey:@"screen_name"];
    // 用户头像
    [aCoder encodeObject:self.avatar_large forKey:@"avatar_large"];
}

/// 解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.overtime = [aDecoder decodeObjectForKey:@"overtime"];
        self.isLogin = [aDecoder decodeBoolForKey:@"isLogin"];
        // 用户名称
        self.screen_name = [aDecoder decodeObjectForKey:@"screen_name"];
        // 用户头像
        self.avatar_large = [aDecoder decodeObjectForKey:@"avatar_large"];
    }
    return self;
}

#pragma mark - 懒加载
/// 数据保存地址
+ (NSString *)path {
    return [NSString stringWithFormat:@"%@/userData.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
}

@end
