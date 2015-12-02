//
//  YBWeiBoUserModel.h
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBWeiBoUserModel : NSObject

/// 用户UID
@property(nonatomic, assign) NSInteger id;
/// 友好显示名称
@property(nonatomic, copy) NSString *name;
/// 认证图片
@property(nonatomic, strong) UIImage *verifiedImage;
/// profile_image_url string 用户头像地址（中图），50×50像素
@property(nonatomic, copy) NSString *profile_image_url;
/// vipImage
@property(nonatomic, strong) UIImage *vipImage;
/// 构造方法
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
