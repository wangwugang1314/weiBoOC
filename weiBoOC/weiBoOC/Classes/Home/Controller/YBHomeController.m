//
//  YBHomeController.m
//  weiBoOC
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeController.h"

@implementation YBHomeController

#pragma mark - 
- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 准备UI
    [self prepareUI];
}

#pragma mark - 准备UI
- (void)prepareUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_friendsearch"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
}

#pragma mark - 按钮点击事件
/// 导航栏左边按钮点击
- (void)leftBarButtonItemClick{
    YBLog(@"导航栏左边按钮点击%s",__FUNCTION__);
}

#pragma mark - 懒加载

@end
