//
//  YBWeiBoDataModel.m
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBWeiBoDataModel.h"
#import "YBNetworking.h"
#import "SDWebImageManager.h"

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
            // 加载数据完成（加载一张图片）
            [self loadSignalImage:finish andDataArr:[arrM copy]];
        }else{ // 网络加载失败
            finish(nil, YES);
        }
    }];
}

/// 网络加载单张图片
+ (void)loadSignalImage:(LoadWeiBoDataFiniash)finish andDataArr:(NSArray *)dataArr {
    // 创建GCD队列组
    dispatch_group_t group = dispatch_group_create();
    // 遍历数组
    for (YBWeiBoDataModel *dataModel in dataArr) {
        // 判断是不是转发微博
        if (dataModel.retweeted_status) { // 转发微薄
            [self loadImage:dataModel.retweeted_status GCDGroup:group];
        } else { // 不是转发微薄
            [self loadImage:dataModel GCDGroup:group];
        }
    }
    // 当图片全部加载完成执行
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        finish(dataArr, nil);
    });
}

/// 加载图片
+ (void)loadImage:(YBWeiBoDataModel *)dataModel GCDGroup:(dispatch_group_t)group{
    // 查看是不是一张图品
    if (dataModel.pic_urls.count == 1) {
        // 队列进组
        dispatch_group_enter(group);
        // 加载网络图片
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:dataModel.pic_urls[0]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            // 判断图片加载是否成功
            if(image != nil && error == nil) { // 加载成功
                if (image.size.width < 40) { // 长图
                    dataModel.imageSize = CGSizeMake(80, 90);
                }else{
                    dataModel.imageSize = image.size;
                }
            }
            // 队列出组
            dispatch_group_leave(group);
        }];
    }
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

/// 转发微薄
- (void)setRetweeted_status:(id)retweeted_status {
    _retweeted_status = [[YBWeiBoDataModel alloc] initWithDic:retweeted_status];
}

/// 图片资源
- (void)setPic_urls:(NSArray *)pic_urls {
    NSMutableArray *arrM = [NSMutableArray array];
    NSMutableArray *bigImageURLs = [NSMutableArray array];
    for (NSDictionary *dic in pic_urls) {
        NSString *str = dic[@"thumbnail_pic"];
        [arrM addObject:str];
        // 设置大图
        [bigImageURLs addObject:[NSURL URLWithString:[str stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"]]];
    }
    self.bigPictureUrls = [bigImageURLs copy];
    _pic_urls = [NSArray arrayWithArray:arrM];
}

#pragma mark - 内部方法
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
