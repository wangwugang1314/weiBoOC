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
#import "MJRefresh.h"
#import "YBHomeWebViewController.h"

/// 数据加载类型
typedef NS_ENUM(NSInteger, YBHomeLoadWeiBoDataStyle) {
    YBHomeLoadWeiBoDataStyleNew,    // 下拉
    YBHomeLoadWeiBoDataStyleOld     // 上拉
};

@interface YBHomeController () <UIViewControllerTransitioningDelegate, YBHomeTableViewCellDelegate>

/// 导航栏中间按钮
@property(nonatomic, weak) YBHomeNavTitleView *titleView;
/// 微薄数据
@property(nonatomic, strong) NSMutableArray *dataArr;
/// 标记拖拽
@property(nonatomic, assign) BOOL isDraggingTag;
/// 显示更新微博数
@property(nonatomic, weak) UILabel *showWeiBoNum;
/// 标记是否正在动画
@property(nonatomic, assign) BOOL isAnimation;

@end

@implementation YBHomeController

#pragma mark - viewDidLoad
- (void)viewDidLoad{
    [super viewDidLoad];
    // 如果没有登录就直接返回
    if(![YBUserModel userModel].isLogin) return;
    // 注册Cell
    [self.tableView registerClass:[YBHomeTableViewCell class] forCellReuseIdentifier:@"YBHomeTableViewCell"];
    // 准备UI
    [self prepareUI];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeDismissAnimatedTransitioningNotification) name:YBHomeDismissAnimatedTransitioningNotification object:nil];
    // 点击图片通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeImageCollectionViewNotification:) name:YBHomeImageCollectionViewNotification object:nil];
    
    self.tableView.estimatedRowHeight = 300;
    // 准备刷新控件
    [self setReloadData];
    // 获取数据
    [self.tableView.mj_header beginRefreshing];
    // 取消每行之间的横线
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 获取微薄数据
- (void)getWeiBoData:(YBHomeLoadWeiBoDataStyle)loadWeiBoDataStyle {
    // 如果正在加载数据直接返回
    NSInteger newId = 0;
    NSInteger OldId = 0;
    // 判断当前加载类型
    if (loadWeiBoDataStyle == YBHomeLoadWeiBoDataStyleNew && self.dataArr != nil) {
        YBWeiBoDataModel *daraModel = self.dataArr[0];
        newId = daraModel.id;
    }else if(loadWeiBoDataStyle == YBHomeLoadWeiBoDataStyleOld) {
        YBWeiBoDataModel *daraModel = [self.dataArr lastObject];
        OldId = daraModel.id;
    }
    
    __weak typeof(self) selfVc = self;
    [YBWeiBoDataModel loadWeiBoDataModelWithNewId:newId andOldId:OldId andFinish:^(NSArray *weiMoModels, BOOL isError) {
        // 结束刷新
        // 判断当前加载类型
        if (loadWeiBoDataStyle == YBHomeLoadWeiBoDataStyleNew) {
            [selfVc.tableView.mj_header endRefreshing];
        }else if(loadWeiBoDataStyle == YBHomeLoadWeiBoDataStyleOld) {
            [selfVc.tableView.mj_footer endRefreshing];
        }
        
        // 标记加载完成
        if (!isError) { // 网络加载成功
            if(weiMoModels.count){ // 加载到数据
                if (self.dataArr.count == 0) { // 第一次加载
                    selfVc.dataArr = (NSMutableArray *)weiMoModels;
                }else if (loadWeiBoDataStyle == YBHomeLoadWeiBoDataStyleNew) { // 下拉刷新
                    [selfVc.dataArr insertObjects:weiMoModels atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, weiMoModels.count)]];
                }else if (loadWeiBoDataStyle == YBHomeLoadWeiBoDataStyleOld) { // 上拉加载更多
                    // 移除随后一个数据
                    [self.dataArr removeLastObject];
                    // 添加数据
                    [self.dataArr addObjectsFromArray:weiMoModels];
                }
                [selfVc.tableView reloadData];
                selfVc.showWeiBoNum.text = [NSString stringWithFormat:@"更新了%zd条微薄",weiMoModels.count];
            }else{ // 没有新数据
                selfVc.showWeiBoNum.text = [NSString stringWithFormat:@"没有新微薄"];
            }
            if (!selfVc.isAnimation && loadWeiBoDataStyle == YBHomeLoadWeiBoDataStyleNew) {
                selfVc.isAnimation = YES;
                // 设置加载显示说句
                [UIView animateWithDuration:0.4 animations:^{
                    selfVc.showWeiBoNum.alpha = 0.9;
                    selfVc.showWeiBoNum.transform = CGAffineTransformMakeTranslation(0, 44);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:1 delay:1 options:0 animations:^{
                        selfVc.showWeiBoNum.transform = CGAffineTransformIdentity;
                        selfVc.showWeiBoNum.alpha = 0;
                    } completion:^(BOOL finished) {
                        selfVc.isAnimation = NO;
                    }];
                }];
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

/// 设置刷新
- (void)setReloadData{
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getWeiBoData:YBHomeLoadWeiBoDataStyleNew];
    }];
    // 上拉更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getWeiBoData:YBHomeLoadWeiBoDataStyleOld];
    }];
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

#pragma mark - 数据源代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YBHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBHomeTableViewCell"];
    // 设置数据
    cell.dataModel = self.dataArr[indexPath.row];
    // 设置cell代理
    cell.ybDelegate = self;
    return cell;
}

#pragma mark - cell代理
- (void)homeTableViewCell:(YBHomeTableViewCell *)cell andPathStr:(NSString *)pathStr {
    UINavigationController *naV = [[UINavigationController alloc] initWithRootViewController:[[YBHomeWebViewController alloc] initWithPathName:pathStr]];
    [self presentViewController:naV animated:YES completion:nil];
}

#pragma mark - tableView代理
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
/// 显示更新微博数
- (UILabel *)showWeiBoNum {
    if (_showWeiBoNum == nil) {
        UILabel *view = [UILabel new];
        [self.navigationController.navigationBar addSubview:view];
        [self.navigationController.navigationBar sendSubviewToBack:view];
        view.textAlignment = NSTextAlignmentCenter;
        view.backgroundColor = [UIColor orangeColor];
        view.frame = CGRectMake(0, 0, [UIScreen width], 40);
        view.alpha = 0;
        _showWeiBoNum = view;
    }
    return _showWeiBoNum;
}


@end
