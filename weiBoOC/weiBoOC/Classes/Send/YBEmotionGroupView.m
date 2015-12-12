//
//  YBEmotionGroup.m
//  weiBoOC
//
//  Created by MAC on 15/12/10.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBEmotionGroupView.h"
#import "YBEmotionGroupCell.h"
#import "YBEmoticonsModel.h"

@interface YBEmotionGroupView () <UICollectionViewDataSource, UICollectionViewDelegate>

/// 布局方式
@property(nonatomic, weak) UICollectionViewFlowLayout *layout;

@end

@implementation YBEmotionGroupView

#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.layout = layout;
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
        // 注册cell
        [self registerClass:[YBEmotionGroupCell class] forCellWithReuseIdentifier:@"YBEmotionGroupViewCell"];
        // 设置布局
        [self setterLayout];
        // 允许滚动
        self.alwaysBounceHorizontal = YES;
        // 设置背景颜色
        self.backgroundColor = [UIColor whiteColor];
     }
    return self;
}

#pragma mark - 设置布局
- (void)setterLayout {
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

#pragma mark - setter
/// 数据
- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    // 设置cell
    self.layout.itemSize = CGSizeMake([UIScreen width] / dataArr.count, 44);
    // 更新数据
    [self reloadData];
}

#pragma mark - 数据源代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBEmotionGroupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBEmotionGroupViewCell" forIndexPath:indexPath];
    YBEmoticonsModel *model = self.dataArr[indexPath.item];
    cell.text = model.group_name_cn;

    if (indexPath.item == 2) {
        self.selecterIndex = 1;
        [self collectionView:self didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
    }
    
    return cell;
}

#pragma mark - 代理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 如果当前选中的与上一个相等直接返回
    if (self.selecterIndex == indexPath.item) {
        return;
    }
    // 代理选中的位置
    if([self.ybDelegate respondsToSelector:@selector(emotionGroupView:andSelectIndex:)]) {
        [self.ybDelegate emotionGroupView:self andSelectIndex:indexPath.item];
    }
    // 选中指定的行
    self.selecterIndex = indexPath.item;
}

// 显示调用
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 2) {
        NSArray *cells = [self visibleCells];
        for (YBEmotionGroupCell *cell in cells) {
            cell.isSelecter = NO;
        }
    }
}

#pragma mark - setter
- (void)setSelecterIndex:(NSInteger)selecterIndex {
    // 取消选中上一行
    YBEmotionGroupCell *cell1 = (YBEmotionGroupCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selecterIndex inSection:0]];
    cell1.isSelecter = NO;
    // 选中当前行
    YBEmotionGroupCell *cell2 = (YBEmotionGroupCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:selecterIndex inSection:0]];
    cell2.isSelecter = YES;
    // 赋值
    _selecterIndex = selecterIndex;
}

#pragma mark - 懒加载

#pragma mark - 对象销毁
- (void)dealloc {
}

@end
