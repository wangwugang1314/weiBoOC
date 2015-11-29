//
//  YBBaseTableViewController.m
//  weiBoOC
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBBaseTableViewController.h"
#import "YBVisitView.h"
#import "YBLoginView.h"

@interface YBBaseTableViewController () <YBVisitViewDelegate>

/// 是否是访客模式
@property(nonatomic, assign) BOOL isLogin;

@end

#import "YBVisitView.h"

@implementation YBBaseTableViewController

#pragma mark - loadView
- (void)loadView {
    
    if (!self.isLogin) {
        self.view = [YBVisitView new];
        // 设置数据
        [self setVisitAllData];
    }else{
        [super loadView];
    }
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 判断是不是访客模式
    if (!self.isLogin) {
        // 登录按钮
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(loginButClick)];
        // 注册按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerButClick)];
    }else{
        
    }
}

// 设置数据
- (void)setVisitAllData{
    NSString *className = NSStringFromClass(self.class);
    if ([className isEqualToString:@"YBHomeController"]) {
        [self setVisitCenterImageName:@"visitordiscover_feed_image_smallicon" andShowText:@"关注一些人,看看有上面惊喜" andIsVisit:YES];
    }else if ([className isEqualToString:@"YBMessageController"]){
        [self setVisitCenterImageName:@"visitordiscover_image_message" andShowText:@"登录后，别人评论你的微博，发给你的消息，都会在这里收到通知" andIsVisit:NO];
    }else if ([className isEqualToString:@"YBDiscoverController"]){
        [self setVisitCenterImageName:@"visitordiscover_image_message" andShowText:@"登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过" andIsVisit:NO];
    }else if ([className isEqualToString:@"YBMeController"]){
        [self setVisitCenterImageName:@"visitordiscover_image_profile" andShowText:@"登录后，你的微博、相册、个人资料会显示在这里，展示给别人" andIsVisit:NO];
    }
}

- (void)setVisitCenterImageName:(NSString *)centerImageName andShowText:(NSString *)text andIsVisit:(BOOL)isVisit {
    YBVisitView *visitView = (YBVisitView *)self.view;
    // 设置代理
    visitView.ybDelegate = self;
    // 设置中间图片
    visitView.centerImageView.image = [UIImage imageNamed:centerImageName];
    // 设置显示文字
    visitView.showTextLable.text = text;
    // 设置是否是主页
    visitView.isHome = isVisit;
}

#pragma mark - 按钮点击
/// 登录按钮点击
- (void)loginButClick{
    // 跳转到登录界面
    YBLoginView *loginCiew = [YBLoginView new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginCiew];
    [self presentViewController:nav animated:YES completion:nil];
}

/// 注册按钮点击
- (void)registerButClick{
    YBLog(@"注册按钮点击");
}

#pragma mark - 代理
- (void)visitView:(YBVisitView *)visitView andVisitViewBut:(YBVisitViewBut)visitViewBut {
    if (visitViewBut) {
        [self registerButClick];
    }else{
        [self loginButClick];
    }
}

#pragma mark - 懒加载
/// 是否登录
- (BOOL)isLogin {
    return [YBUserModel userModel].isLogin;
}

/// 对象销毁
//- (void)dealloc {
//    YBLog(@"%s 销毁",__func__);
//}

@end
