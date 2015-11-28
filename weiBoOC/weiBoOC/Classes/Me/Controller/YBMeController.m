//
//  YBMeController.m
//  weiBoOC
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBMeController.h"
#import "YBTabBarController.h"

@implementation YBMeController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 准备UI
    [self prepareUI];
}

#pragma mark - 准备UI
- (void)prepareUI {
    // 设置右边退出账号
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出账号" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
}

#pragma mark - 按钮点击事件
/// 导航栏右边按钮点击
- (void)rightBarButtonItemClick{
    // 退出登录
    [YBUserModel exitLogin];
    [UIApplication sharedApplication].keyWindow.rootViewController = [YBTabBarController new];
}

@end
