//
//  YBWeiBoDataModel.m
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBWeiBoDataModel.h"
#import "YBNetworking.h"

@interface YBWeiBoDataModel ()

/// 微薄创建时间
@property(nonatomic, copy) NSString *created_at;
/// MARK: 微博来源
@property(nonatomic, copy) NSString *source;

@end

@implementation YBWeiBoDataModel

#pragma mark - 构造方法
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

#pragma mark - 加载网络数据
/// 加载网络数据
+ (void)loadWeiBoDataModel:(LoadWeiBoDataFiniash)finish {
    [YBNetworking loadWeiBoDataWithFinish:^(id success, NSError *error) {
        // 判断数据是否加载成功
        if (error == nil) { // 网络加载成功
            NSMutableArray *arrM = [NSMutableArray array];
            for (NSDictionary *dic in success) {
                [arrM addObject:[[YBWeiBoDataModel alloc] initWithDic:dic]];
            }
            finish(arrM, NO);
        }else{ // 网络加载失败
            finish(nil, YES);
        }
    }];
}

#pragma mark - setter
/// 用户数据
- (void)setUser:(id)user {
    _user = [[YBWeiBoUserModel alloc] initWithDic:user];
}

/// 微薄创建时间
- (void)setCreated_at:(NSString *)created_at {
    _created_at = created_at;
    // 日期格式
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss zzz yyyy";
    NSDate *date = [dateFormatter dateFromString:created_at];
    if (!date) {
        return;
    }
    // 时间判断
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 判断是不是今年 0 相同
    if ([calendar compareDate:date toDate:[NSDate date] toUnitGranularity:NSCalendarUnitYear] == 0){// 今年
        if ([calendar isDateInToday:date]) { // 今天
            NSTimeInterval inter = [[NSDate date] timeIntervalSinceDate:date];
            if (inter < 60) { // 一分钟内
                self.weiBoDate = @"刚刚";
                return;
            }else if (inter < 3600) { // 一小时内
                self.weiBoDate = [NSString stringWithFormat:@"%zd分钟前",(NSInteger)(inter / 60)];
                return;
            }else{
                self.weiBoDate = [NSString stringWithFormat:@"%zd小时前",(NSInteger)(inter / 3600)];
                return;
            }
        }else if([calendar isDateInYesterday:date]){ // 昨天
            dateFormatter.dateFormat = @"HH:mm";
        }else{ // 一年内
            dateFormatter.dateFormat = @"MM-dd HH:mm";
        }
    }else{ // 不是今年
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    self.weiBoDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
}

/// 微薄来源
- (void)setSource:(NSString *)source{
    _source = source;
    self.weiBoSource = [self matchString:source];
}

// 基本匹配
// 参数1：需要匹配的字符
// 参数2：正则格式字符
- (NSString *)matchString:(NSString *)dest
{
    // 创建正则表达式
    NSError *error;
    NSString *options = @">(.*?)</a>";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:options options:0 error:&error];
    // 如果创建失败。直接返回
    if (!regularExpression) return nil;
    // 设置匹配
    NSTextCheckingResult *result = [regularExpression firstMatchInString:dest options:0 range:NSMakeRange(0, dest.length)];
    // 查看是否匹配到
    if(result.numberOfRanges){
        return [dest substringWithRange:[result rangeAtIndex:1]];
    }
    return nil;
}

#pragma mark - 获取数据

@end
