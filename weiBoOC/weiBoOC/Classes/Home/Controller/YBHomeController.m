//
//  YBHomeController.m
//  weiBoOC
//
//  Created by MAC on 15/11/26.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeController.h"
#import "YBHomeNavTitleView.h"
#import "YBNavScanCodeController.h"
#import "YBHomePopViewController.h"
#import "YBHomePopPresentationController.h"
#import "YBHomePresentAnimatedTransitioning.h"
#import "YBHomeDismissAnimatedTransitioning.h"
#import "YBWeiBoDataModel.h"
#import "YBHomeTableViewCell.h"

@interface YBHomeController () <UIViewControllerTransitioningDelegate>

/// 导航栏中间按钮
@property(nonatomic, weak) YBHomeNavTitleView *titleView;
/// 微薄数据
@property(nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation YBHomeController

#pragma mark - 
- (void)viewDidLoad{
    [super viewDidLoad];
    // 如果没有登录就直接返回
    if(![YBUserModel userModel].isLogin) return;
    // 注册Cell
    [self.tableView registerClass:[YBHomeTableViewCell class] forCellReuseIdentifier:@"YBHomeTableViewCell"];
    // 获取数据
    [self getWeiBoData];
    // 准备UI
    [self prepareUI];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeDismissAnimatedTransitioningNotification) name:YBHomeDismissAnimatedTransitioningNotification object:nil];
    
    self.tableView.rowHeight = 100;
}

#pragma mark - 获取微薄数据
- (void)getWeiBoData {
    __weak typeof(self) selfVc = self;
    [YBWeiBoDataModel loadWeiBoDataModel:^(NSArray *weiMoModels, BOOL isError) {
        if (!isError) { // 网络加载成功
            if(weiMoModels.count){ // 加载到数据
                selfVc.dataArr = (NSMutableArray *)weiMoModels;
            }else{ // 没有新数据
            
            }
        }else{ // 网络加载失败
            
        }
    }];
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
    [titleView addTarget:self action:@selector(titleViewClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 按钮点击事件
/// 导航栏左边按钮点击
- (void)leftBarButtonItemClick{
    YBLog(@"导航栏左边按钮点击%s",__FUNCTION__);
}

/// 导航栏右边按钮点击
- (void)rightBarButtonItemClick{
    [self presentViewController:[YBNavScanCodeController new] animated:YES completion:nil];
}

/// 导航栏中间按钮点击
- (void)titleViewClick:(UIButton *)but{
    but.selected = !but.selected;
    if (!but.selected) {
        return;
    }
    YBHomePopViewController *popVC = [YBHomePopViewController new];
    popVC.transitioningDelegate = self;
    popVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:popVC animated:YES completion:nil];
}

/// 通知代理
- (void)homeDismissAnimatedTransitioningNotification {
    [self titleViewClick:self.titleView];
}

#pragma mark - 数据源代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YBHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBHomeTableViewCell"];
    // 设置数据
    cell.dataModel = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - 转场动画代理
/// 展现代理
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [YBHomePresentAnimatedTransitioning new];
}

/// 消失代理
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [YBHomeDismissAnimatedTransitioning new];
}

/// 转场动画代理
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    return [[YBHomePopPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

#pragma mark - 懒加载

#pragma mark - 设置数据
/// 数据数组
- (void)setDataArr:(NSMutableArray *)dataArr {
    _dataArr = dataArr;
    [self.tableView reloadData];
}

@end
