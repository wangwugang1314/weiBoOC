//
//  YBHomePopViewController.m
//  weiBoOC
//
//  Created by MAC on 15/12/1.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomePopViewController.h"
#import "YBHomePopView.h"

@interface YBHomePopViewController ()

/// 背景图片
@property(nonatomic, weak) UIImageView *bgView;
/// tableView
@property(nonatomic, weak) YBHomePopView *popTableView;

@end

@implementation YBHomePopViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 准备UI
    [self prepareUI];
}

#pragma mark - 准备UI
- (void)prepareUI{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    YBHomePopView *popView = [YBHomePopView new];
    [self.view addSubview:popView];
    self.popTableView = popView;
    [popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(11, 5, 7, 5));
    }];
}

#pragma mark - 懒加载
/// 背景试图
- (UIImageView *)bgView{
    if (_bgView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popover_background"]];
        [self.view addSubview:imageView];
        _bgView = imageView;
    }
    return _bgView;
}


@end
