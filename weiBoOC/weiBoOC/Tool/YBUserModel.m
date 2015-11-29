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

/// 加载网络数据
+ (void)loadUserData:(NSString *)code isLoadSuccess:(loadUserDataFinish)isSuccess {
    // 加载数据
    [YBNetworking loadUserData:code andFinish:^(id success, NSError *error) {
        // 判断是都加载成功
        if (success != nil && error == nil) {
            // 数据加载成功
            isSuccess(YES);
            YBUserModel *userModel = [YBUserModel shareduserModel];
            // KVC
            [userModel setValuesForKeysWithDictionary:success];
            // 设置登录
            userModel.isLogin = YES;
            // 保存数据
            [userModel saveData];
        }else{
            // 数据加载失败
            isSuccess(NO);
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
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self path]];
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
}

/// 解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.overtime = [aDecoder decodeObjectForKey:@"overtime"];
        self.isLogin = [aDecoder decodeBoolForKey:@"isLogin"];
    }
    return self;
}

#pragma mark - 懒加载
/// 数据保存地址
+ (NSString *)path {
    return [NSString stringWithFormat:@"%@/userData.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
}

@end
