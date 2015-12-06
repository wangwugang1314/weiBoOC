//
//  YBLoginView.m
//  weiBoOC
//
//  Created by MAC on 15/11/28.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBLoginView.h"
#import "YBNetworking.h"
#import "YBUserModel.h"
#import "YBWelcomeViewController.h"
#import "YBWebView.h"

@interface YBLoginView () <UIWebViewDelegate>

/// 网页
@property(nonatomic, weak) YBWebView *webView;

@end

@implementation YBLoginView

#pragma mark - 初始化
- (void)loadView {
    // 设置网页
    YBWebView *webView = [YBWebView new];
    self.view = webView;
    self.webView = webView;
    self.webView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 准备UI
    [self prepareUI];
}

#pragma mark - 准备UI
- (void)prepareUI {
    // 设置导航栏
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"填充" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    
    // 设置网页
    YBNetworking *networking = [YBNetworking new];
    NSString *path = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",networking.client_id,networking.redirect_uri];

    // 加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
    // 设置提示
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeNone];
}

#pragma mark - 按钮点击
/// 导航栏左边按钮点击
- (void)leftBarButtonItemClick {
    // 退出
    [self dismissViewControllerAnimated:YES completion:nil];
    // 移除提示
    [SVProgressHUD dismiss];
}

/// 导航栏右边按钮点击
- (void)rightBarButtonItemClick {
    // 填充账号密码
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('userId').value='18567680596';document.getElementById('passwd').value='www123456';"];
}

#pragma mark - 代理
/// 网络加载
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 如果前缀是百度网址成功
    if([request.URL.relativeString hasPrefix:[YBNetworking shareduserModel].redirect_uri]) {
        // 获取Code
        NSString *code = [request.URL.relativeString componentsSeparatedByString:@"="].lastObject;
        // 加载数据
        __weak typeof(self) selfVc = self;
        [YBUserModel loadUserLoginData:code isLoadSuccess:^(BOOL isSuccess) {
            if (isSuccess) {// 登录成功
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                // 退出界面
                [selfVc dismissViewControllerAnimated:YES completion:^{
                    [UIApplication sharedApplication].keyWindow.rootViewController = [YBWelcomeViewController new];
                }];
            }else{// 登录失败
                [SVProgressHUD showErrorWithStatus:@"登录失败"];
            }
        }];
        return NO;
    }
    return YES;
}

/// 加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 取消显示的加载
    [SVProgressHUD dismiss];
}

#pragma mark - 懒加载


/// 对象销毁
- (void)dealloc{
    YBLog(@"登录界面销毁")
    self.view = nil;
}


@end
