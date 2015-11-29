//
//  YBHomeController.m
//  weiBoOC
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeController.h"
#import "YBHomeNavTitleView.h"

@interface YBHomeController ()

/// 导航栏中间按钮
@property(nonatomic, weak) YBHomeNavTitleView *titleView;

@end

@implementation YBHomeController

#pragma mark - 
- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 准备UI
    [self prepareUI];
}

#pragma mark - 准备UI
- (void)prepareUI{
    // 左边
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_friendsearch"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    // 右边
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_pop"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    // 中间
    YBHomeNavTitleView *titleView = [YBHomeNavTitleView new];
    self.navigationItem.titleView = titleView;
    self.titleView = titleView;
    // 添加点击方法
    [titleView addTarget:self action:@selector(titleViewClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 按钮点击事件
/// 导航栏左边按钮点击
- (void)leftBarButtonItemClick{
    YBLog(@"导航栏左边按钮点击%s",__FUNCTION__);
}

/// 导航栏右边按钮点击
- (void)rightBarButtonItemClick{
    YBLog(@"导航栏右边按钮点击%s",__FUNCTION__);
}

/// 导航栏中间按钮点击
- (void)titleViewClick{
    YBLog(@"导航栏中间按钮点击%s",__FUNCTION__);
}

#pragma mark - 懒加载

@end
