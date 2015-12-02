//
//  YBWeiBoDataModel.h
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBWeiBoUserModel.h"

/// 加载数据回调
typedef void (^LoadWeiBoDataFiniash)(NSArray *weiMoModels, BOOL isError);

@interface YBWeiBoDataModel : NSObject

// 微薄id
@property(nonatomic, assign) NSInteger id;
/// MARK: 微博创建时间
@property(nonatomic, copy) NSString *weiBoDate;
/// MARK: 微博信息内容
@property(nonatomic, copy) NSString *text;
/// MARK: 微博来源
@property(nonatomic, copy) NSString *weiBoSource;
/// MARK: 微博作者的用户信息字段 详细
@property(nonatomic, strong) id user;
/// MARK: 转发微博
@property(nonatomic, strong) id retweeted_status;
/// MARK: 图片
@property(nonatomic, strong) NSArray *pic_urls;
/// 当为一张图片的时候图片的大小
@property(nonatomic, assign) CGSize imageSize;
///// MARK: 图片数组的Url
//var pictureURLs = [NSURL]()
///// 大图的url
//var bigPictureUrls = [NSURL]()
///// MARK: 行高
//var rowHeight: CGFloat?

/// 加载网络数据
+ (void)loadWeiBoDataModel:(LoadWeiBoDataFiniash)finish;

@end
