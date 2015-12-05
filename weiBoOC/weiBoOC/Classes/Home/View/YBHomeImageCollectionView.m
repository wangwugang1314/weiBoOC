//
//  YBHomeImageCollectionView.m
//  weiBoOC
//
//  Created by MAC on 15/12/2.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBHomeImageCollectionView.h"
#import "YBHomeCollectionViewCell.h"

@interface YBHomeImageCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate>

/// 布局方法
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation YBHomeImageCollectionView

#pragma mark - 构造方法
- (instancetype)init {
    self.flowLayout = [UICollectionViewFlowLayout new];
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:self.flowLayout]) {
        // 准备UI
        [self prepareUI];
    }
    return self;
}

#pragma mark - 准备UI
- (void)prepareUI{
    // collectionView
    self.dataSource = self;
    self.delegate = self;
    // 设置布局
    self.flowLayout.minimumInteritemSpacing = 5;
    self.flowLayout.minimumLineSpacing = 5;
    // 注册Cell
    [self registerClass:[YBHomeCollectionViewCell class] forCellWithReuseIdentifier:@"YBHomeCollectionViewCell"];
}

#pragma mark - setter
/// 数据
- (void)setDataModel:(YBWeiBoDataModel *)dataModel{
    _dataModel = dataModel;
    
    if (dataModel.pic_urls.count == 1) {
        self.flowLayout.itemSize = dataModel.imageSize;
    }else{
        CGFloat itemWidth = ([UIScreen width] - 30) / 3;
        self.flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    }
    [self reloadData];
}

#pragma mark - 代理
/// 点击调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 设置当前点击的索引
    self.dataModel.index = indexPath.item;
    NSMutableArray *arrFrame = [NSMutableArray array];
    // 获取所有的frame(首先遍历)
    for (int i = 0; i < self.dataModel.pic_urls.count; i++) {
        // 获取cell
        YBHomeCollectionViewCell *cell = (YBHomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        // 获取frame
        CGRect cellRect = [cell.contentView convertRect:cell.contentView.frame toView:[UIApplication sharedApplication].keyWindow];
        [arrFrame addObject:NSStringFromCGRect(cellRect)];
    }
    self.dataModel.imageFrames = [arrFrame copy];
    // 通知控制器
    [[NSNotificationCenter defaultCenter] postNotificationName:YBHomeImageCollectionViewNotification object:nil userInfo:@{@"dataModel": self.dataModel}];
}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataModel.pic_urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBHomeCollectionViewCell" forIndexPath:indexPath];
    cell.imagePath = self.dataModel.pic_urls[indexPath.row];
    return cell;
}

@end
