//
//  YBHomePictureViewController.m
//  weiBoOC
//
//  Created by MAC on 15/12/5.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomePictureViewController.h"
#import "YBHomePicturePresentationController.h"
#import "YBHomePictuerPresentAnimatedTransitioning.h"
#import "YBWeiBoDataModel.h"
#import "YBHomePictureCell.h"
#import "YBHomePictuerDismissAnimatedTransitioning.h"

@interface YBHomePictureViewController () <UIViewControllerTransitioningDelegate, YBHomePictureCellDelegate>

/// 布局
@property(nonatomic, strong) UICollectionViewFlowLayout *layout;
/// 索引
@property(nonatomic, weak) UILabel *indexView;
/// 保存
@property(nonatomic, weak) UIButton *saveImageView;
/// 返回
@property(nonatomic, weak) UIButton *breakView;

@end

@implementation YBHomePictureViewController

#pragma mark - 构造方法
- (instancetype)initWithDataModel:(YBWeiBoDataModel *)dataModel {
    self.layout = [UICollectionViewFlowLayout new];
    if (self = [super initWithCollectionViewLayout:self.layout]) {
        // 设置展现代理
        self.dataModel = dataModel;
        self.transitioningDelegate = self;
        // 设置collectionView
        [self setterCollectionView];
        // 准备UI
        [self prepareUI];
        // 设置布局
        [self setterLayle];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataModel.index inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
}

#pragma mark - 准备UI
- (void)prepareUI {
    // 索引
    [self.indexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(60);
    }];
    // 保存
    [self.saveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
        make.bottom.mas_equalTo(self.view.mas_baseline).offset(-40);
    }];
    // 返回
    [self.breakView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.bottom.mas_equalTo(self.view.mas_baseline).offset(-40);
    }];
}

/// 设置布局
- (void)setterLayle{
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    self.layout.itemSize = CGSizeMake([UIScreen width] + 10, [UIScreen height]);
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

/// 设置collectionView
- (void)setterCollectionView {
    // 注册cell
    [self.collectionView registerClass:[YBHomePictureCell class] forCellWithReuseIdentifier:@"YBHomePictureCell"];
    // 设置frame
    self.collectionView.frame = CGRectMake(0, 0, [UIScreen width] + 10, [UIScreen height]);
    // 分页
    self.collectionView.pagingEnabled = YES;
    // 去掉弹簧效果
    self.collectionView.bounces = NO;
}

#pragma mark - 按钮点击事件
/// 保存图片
- (void)saveImageViewClick {
    YBHomePictureCell *cell = (YBHomePictureCell *)[[self.collectionView visibleCells] lastObject];
    
    CGRect imageRect = [cell.imageView convertRect:cell.imageView.frame toView:[UIApplication sharedApplication].keyWindow];
    
    YBLog(@"%@",NSStringFromCGRect(imageRect))
}

/// 返回
- (void)breakViewClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataModel.pic_urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBHomePictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBHomePictureCell" forIndexPath:indexPath];
    cell.imageURL = self.dataModel.bigPictureUrls[indexPath.item];
    cell.ybDelegate = self;
    return cell;
}

#pragma mark - 代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 获取当前显示的索引
    NSIndexPath *indexPath  =[[self.collectionView indexPathsForVisibleItems] lastObject];
    self.indexView.text = [NSString stringWithFormat:@"%zd/%zd", indexPath.item + 1, self.dataModel.pic_urls.count];
    self.dataModel.index = indexPath.item;
}

#pragma mark - cell代理
- (void)homePictureCell:(YBHomePictureCell *)cell {
    [self breakViewClick];
}

#pragma mark - 转场动画代理
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[YBHomePictuerPresentAnimatedTransitioning alloc] init];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[YBHomePictuerDismissAnimatedTransitioning alloc] init];
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    return [[YBHomePicturePresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

#pragma mark - 懒加载
/// 索引
- (UILabel *)indexView {
    if (_indexView == nil) {
        UILabel *view = [UILabel new];
        [self.view addSubview:view];
        view.textColor = [UIColor orangeColor];
        view.text = [NSString stringWithFormat:@"%zd/%zd",self.dataModel.index + 1 ,self.dataModel.pic_urls.count];
        _indexView = view;
    }
    return _indexView;
}

/// 保存
- (UIButton *)saveImageView {
    if (_saveImageView == nil) {
        UIButton *but = [UIButton new];
        but.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [but addTarget:self action:@selector(saveImageViewClick) forControlEvents:UIControlEventTouchUpInside];
        [but setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [but setTitle:@"保存" forState:UIControlStateNormal];
        [self.view addSubview:but];
        _saveImageView = but;
    }
    return _saveImageView;
}

// 返回
- (UIButton *)breakView {
    if (_breakView == nil) {
        UIButton *but = [UIButton new];
        but.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [but addTarget:self action:@selector(breakViewClick) forControlEvents:UIControlEventTouchUpInside];
        [but setTitle:@"返回" forState:UIControlStateNormal];
        [but setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.view addSubview:but];
        _breakView = but;
    }
    return _breakView;
}

/// 对象销毁
- (void)dealloc {
    YBLog(@"图像轮播器销毁")
}

@end
