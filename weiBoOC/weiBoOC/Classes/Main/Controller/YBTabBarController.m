//
//  YBTabBarController.m
//  weiBoOC
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBTabBarController.h"
#import "YBBaseNavigationController.h"

@interface YBTabBarController ()

/// 数据数组
@property(nonatomic, strong) NSArray *dataArr;

@end

@implementation YBTabBarController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置tabBar背景颜色
    self.tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewDidLoad"]];
    // 设置渲染颜色
    self.tabBar.tintColor = [UIColor orangeColor];
    // 准备UI
    [self prepareUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 中间按钮
    [self addCenterBut];
}

#pragma mark - 准备UI
- (void)prepareUI {
    // 遍历数组
    [self.dataArr enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 创建控制器
        UIViewController *vc = [NSClassFromString(obj[@"className"]) new];
        // 创建导航控制器
        YBBaseNavigationController *nVC = [[YBBaseNavigationController alloc] initWithRootViewController:vc];
        NSString *tit = obj[@"title"];
        if (tit.length) {
            // 设置标题
            nVC.tabBarItem.title = tit;
            // 设置图片
            nVC.tabBarItem.image = [UIImage imageNamed:obj[@"imageName"]];
        }
        // 添加到tabBar
        [self addChildViewController:nVC];
    }];
}

/// 添加中间按钮
- (void)addCenterBut {
    // 创建按钮
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen width] * 0.4, 0, [UIScreen width] * 0.2 + 2, self.tabBar.height)];
    // 设置图片
    [but setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    [but setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [but setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    [but setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    // 添加
    [self.tabBar addSubview:but];
    // 添加点击事件
    [but addTarget:self action:@selector(centerButClick) forControlEvents:UIControlEventTouchUpInside];
}

/// 中间按钮点击
- (void)centerButClick{
    YBLog(@"中间按钮点击");
}

#pragma mark - 懒加载
- (NSArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = @[@{@"title":@"首页", @"imageName": @"tabbar_home", @"className": @"YBHomeController"},
                     @{@"title":@"消息", @"imageName": @"tabbar_message_center", @"className": @"YBMessageController"},
                     @{@"title":@"", @"imageName": @"", @"className": @"UIViewController"},
                     @{@"title":@"发现", @"imageName": @"tabbar_discover", @"className": @"YBDiscoverController"},
                     @{@"title":@"我", @"imageName": @"tabbar_profile", @"className": @"YBMeController"}];
    }
    return _dataArr;
}

/// 对象销毁
- (void)dealloc {
    YBLog(@"%s 销毁",__func__);
}

@end
