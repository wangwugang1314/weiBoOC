// 如果需要啥数据也是单例的实现下面的方法
//- (instancetype)init {
//    if (self = [super init]) {
//        
//    }
//    return self;
//}
/* ------在需要设置单例的类中写如下--------------------------------

 YBSingleton_h(name)    参数为类名去掉前缀（.h）

 #define YBSingleton_m(name)  参数为类名去掉前缀（.m）
 
*/

// ## :拼接前后两个字符串
#define YBSingleton_h(name)  +(instancetype)shared##name;

#if __has_feature(objc_arc) // arc

    #define YBSingleton_m(name) \
    +(instancetype)shared##name{ \
        return [[self alloc] init]; \
    }\
    \
    - (id)copyWithZone:(NSZone *)zone{\
    return self;\
    }\
    \
    + (instancetype)allocWithZone:(struct _NSZone *)zone {\
    static id instance;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        instance = [super allocWithZone:zone];\
    });\
    return instance;\
    }

#else // 非arc
    #define YBSingleton_m(name) \
    +(instancetype)shared##name{ \
    return [[self alloc] init]; \
    }\
    \
    - (id)copyWithZone:(NSZone *)zone{\
        return self;\
    }\
    \
    + (instancetype)allocWithZone:(struct _NSZone *)zone {\
    static id instance;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
    instance = [super allocWithZone:zone];\
    });\
    return instance;\
    }\
    - (oneway void)release {\
        \
    }\
    \
    - (instancetype)autorelease {\
        return self;\
    }\
    \
    - (instancetype)retain {\
        return self;\
    }
#endif