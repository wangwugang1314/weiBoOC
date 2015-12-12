//
//  YBHomeWebViewController.m
//  weiBoOC
//
//  Created by MAC on 15/12/8.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeWebViewController.h"

@interface YBHomeWebViewController ()

/// 链接地址
@property(nonatomic, copy) NSString *pathName;

@end

@implementation YBHomeWebViewController

#pragma mark - 构造方法
- (instancetype)initWithPathName:(NSString *)pathName {
    if (self = [super init]) {
        self.pathName = pathName;
        // 准备UI
        [self prepareUI];
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen width], [UIScreen height] - 64)];
    self.view = webView;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.pathName]]];
}

#pragma mark - 准备UI
- (void)prepareUI{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
}

- (void)leftBarButtonItemClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
