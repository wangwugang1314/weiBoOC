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
#import "YBHomeImageCollectionView.h"
#import "YBHomePictureViewController.h"
#import "YBHomeRefreshControl.h"

/// 数据加载类型
typedef NS_ENUM(NSInteger, YBHomeLoadWeiBoDataStyle) {
    YBHomeLoadWeiBoDataStyleOne,    // 向下
    YBHomeLoadWeiBoDataStyleNew,    // 向上
    YBHomeLoadWeiBoDataStyleOld     // 动画
};

@interface YBHomeController () <UIViewControllerTransitioningDelegate>

/// 导航栏中间按钮
@property(nonatomic, weak) YBHomeNavTitleView *titleView;
/// 微薄数据
@property(nonatomic, strong) NSMutableArray *dataArr;
/// 刷新控件
@property(nonatomic, weak) YBHomeRefreshControl *refreshC;
/// 标记拖拽
@property(nonatomic, assign) BOOL isDraggingTag;
/// 是否正在加载数据
@property(nonatomic, assign) BOOL isLoadData;

@end

@implementation YBHomeController

#pragma mark - viewDidLoad
- (void)viewDidLoad{
    [super viewDidLoad];
    // 如果没有登录就直接返回
    if(![YBUserModel userModel].isLogin) return;
    // 注册Cell
    [self.tableView registerClass:[YBHomeTableViewCell class] forCellReuseIdentifier:@"YBHomeTableViewCell"];
    // 获取数据
    [self getWeiBoData:YBHomeLoadWeiBoDataStyleOne];
    // 准备UI
    [self prepareUI];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeDismissAnimatedTransitioningNotification) name:YBHomeDismissAnimatedTransitioningNotification object:nil];
    // 点击图片通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeImageCollectionViewNotification:) name:YBHomeImageCollectionViewNotification object:nil];
    
    self.tableView.estimatedRowHeight = 300;
    // 刷新控件
    self.refreshControl = [[YBHomeRefreshControl alloc] init];
    self.refreshC = (YBHomeRefreshControl *)self.refreshControl;
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"888888");
}

#pragma mark - 获取微薄数据
- (void)getWeiBoData:(YBHomeLoadWeiBoDataStyle)loadWeiBoDataStyle {
    if (self.isLoadData) {
        return;
    }
    // 标记正在加载数据
    self.isLoadData = YES;
    NSInteger newId = 0;
//    NSInteger OldId = 0;
    // 判断当前加载类型
    if (loadWeiBoDataStyle == YBHomeLoadWeiBoDataStyleNew) {
        YBWeiBoDataModel *daraModel = self.dataArr[0];
        newId = daraModel.id;
        YBLog(@"%zd",newId)
    }
    
    __weak typeof(self) selfVc = self;
    [YBWeiBoDataModel loadWeiBoDataModelWithNewId:newId :^(NSArray *weiMoModels, BOOL isError){
        selfVc.isLoadData = NO;
        if (!isError) { // 网络加载成功
            if(weiMoModels.count){ // 加载到数据
                if (self.dataArr.count == 0) {
                    selfVc.dataArr = (NSMutableArray *)weiMoModels;
                }else if (loadWeiBoDataStyle == YBHomeLoadWeiBoDataStyleNew) {
                    [selfVc.dataArr insertObjects:weiMoModels atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, weiMoModels.count)]];
                }
                [selfVc.tableView reloadData];
            }else{ // 没有新数据
                
            }
            NSLog(@"加载了 %zd 条微博",weiMoModels.count);
            // 标记加载完成
            [selfVc.refreshC endRefreshing];
            
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
    [self.refreshC endRefreshing];
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

#pragma mark - 自定义代理事件
/// 通知代理
- (void)homeDismissAnimatedTransitioningNotification {
    [self titleViewClick:self.titleView];
}

/// 点击图片
- (void)homeImageCollectionViewNotification:(NSNotification *)notification {
    // 展现控制器
    YBHomePictureViewController *vc = [[YBHomePictureViewController alloc] initWithDataModel:notification.userInfo[@"dataModel"]];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - scrollView代理
/// 停止拖拽的时候调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isDraggingTag = NO;
    // 如果停止拖拽的时候小于60 如果开始就关闭
    if (scrollView.contentOffset.y > -123 && self.refreshC.isRefreshing) {
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentOffset = CGPointMake(0, -64);
        } completion:^(BOOL finished) {
            self.refreshC.refreshControlSta = YBHomeRefreshControlStateDown;
            [self.refreshC endRefreshing];
        }];
    }else if (scrollView.contentOffset.y <= -123) {
        self.refreshC.refreshControlSta = YBHomeRefreshControlStateAnimate;
        [self.refreshC beginRefreshing];
        if (!self.isLoadData) {
            YBLog(@"-----")
            [self getWeiBoData:YBHomeLoadWeiBoDataStyleNew];
        }
    }
}

/// 拖拽调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 如果正在高度大于60，并且没有标记
    if (scrollView.contentOffset.y < -123 && !self.isDraggingTag && !self.refreshC.isRefreshing) {
        self.isDraggingTag = !self.isDraggingTag;
        // 向上
        self.refreshC.refreshControlSta = YBHomeRefreshControlStateUp;
    }else if (scrollView.contentOffset.y >= -123 && self.isDraggingTag && !self.refreshC.isRefreshing) {
        self.isDraggingTag = !self.isDraggingTag;
        // 向下
        self.refreshC.refreshControlSta = YBHomeRefreshControlStateDown;
    }
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

/// 点击行不显示高亮
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
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

#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YBWeiBoDataModel *dataModel = self.dataArr[indexPath.row];
    return dataModel.rowHeight;
}

#pragma mark - 懒加载

#pragma mark - 设置数据

@end
