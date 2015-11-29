//
//  YBNewFeatureViewController.m
//  weiBoOC
//
//  Created by MAC on 15/11/28.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBNewFeatureViewController.h"
#include "YBNewFeatureCollectionCell.h"

#define YBNewFeatureViewControllerCellCount 4

@interface YBNewFeatureViewController ()

/// 布局方式
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation YBNewFeatureViewController

#pragma mark - 构造方法
- (instancetype)init {
    if (self = [super initWithCollectionViewLayout:self.flowLayout]) {
        // 注册cell
        [self.collectionView registerClass:[YBNewFeatureCollectionCell class] forCellWithReuseIdentifier:@"YBNewFeatureCollectionCell"];
        // 取消弹簧效果
        self.collectionView.bounces = NO;
        // 设置分页
        self.collectionView.pagingEnabled = YES;
    }
    return self;
}

#pragma mark - 数据源代理
/// item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return YBNewFeatureViewControllerCellCount;
}

/// item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 从缓存获取cell
    YBNewFeatureCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBNewFeatureCollectionCell" forIndexPath:indexPath];
    
    cell.index = indexPath.item;
    
    cell.isShowBut = NO;
    
    return cell;
}

#pragma mark - 代理
/// 结束滚动调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == [UIScreen width] * (YBNewFeatureViewControllerCellCount - 1)) {
        YBNewFeatureCollectionCell *cell = (YBNewFeatureCollectionCell *)[[self.collectionView visibleCells] lastObject];
        cell.isShowBut = YES;
    }
}

/// 停止拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self scrollViewDidEndDecelerating:self.collectionView];
}

#pragma mark - 懒加载
/// 布局方式
- (UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置间距
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        // 设置单元格大小
        _flowLayout.itemSize = [UIScreen size];
        // 设置滚动方向
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

@end



















