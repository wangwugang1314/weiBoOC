//
//  YBSendImageView.m
//  weiBoOC
//
//  Created by MAC on 15/12/13.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBSendImageView.h"
#import "YBSendImageViewCell.h"

@interface YBSendImageView () <UICollectionViewDataSource, UICollectionViewDelegate, YBSendImageViewCellDelegate>

/// 布局
@property(nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation YBSendImageView

#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    self.layout = [UICollectionViewFlowLayout new];
    if (self = [super initWithFrame:frame collectionViewLayout:self.layout]) {
        self.dataSource = self;
        self.delegate = self;
        // 注册cell
        [self registerClass:[YBSendImageViewCell class] forCellWithReuseIdentifier:@"YBSendImageViewCell"];
        // 准备UI
        [self prepareUI];
        
        self.backgroundColor = [UIColor orangeColor];
        // 通知
        [self notification];
        self.hidden = YES;
    }
    return self;
}

#pragma mark - 通知
- (void)notification{
    // 工具条图片按钮点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendToolBarButClickStylePictuerNotification) name:@"YBSendToolBarButClickStylePictuerNotification" object:nil];
    // 选择完图片通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagePickerControllerDidFinishNotification:) name:@"YBImagePickerControllerDidFinishNotification" object:nil];
}

/// 相册点击通知
- (void)imagePickerControllerDidFinishNotification:(NSNotification *)notification {
    // 如果不是添加就替换
    NSInteger index = [notification.userInfo[@"index"] integerValue];
    if (index < self.dataArr.count - 1) { // 替换
        self.dataArr[index] = notification.userInfo[@"image"];
    }else{ // 添加
        [self.dataArr insertObject:notification.userInfo[@"image"] atIndex:self.dataArr.count - 1];
    }
    [self reloadData];
    if (self.dataArr.count > 1) {
        self.hidden = NO;
    }
}

/// 通知
- (void)sendToolBarButClickStylePictuerNotification{
    // 如果数组大于6直接返回
    if (self.dataArr.count > 6) {
        [SVProgressHUD showErrorWithStatus:@"图片超出最大数量"];
    }
    [self presentPictuerView:100];
}

/// 通知展现
- (void)presentPictuerView:(NSInteger)index {
    if (index >= self.dataArr.count - 1) { // 添加
        index = 100;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YBSendImageViewPresentPickerViewNotification" object:nil userInfo:@{@"index": @(index)}];
}

#pragma mark - 准备UI
- (void)prepareUI{
    // 设置布局
    self.layout.minimumInteritemSpacing = 10;
    self.layout.minimumLineSpacing = 10;
    CGFloat itemWid = ([UIScreen width] - 40) / 3;
    self.layout.itemSize = CGSizeMake(itemWid, itemWid);
}

#pragma mark - 数据源代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBSendImageViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"YBSendImageViewCell" forIndexPath:indexPath];
    cell.ybDelegate = self;
    cell.image = self.dataArr[indexPath.item];
    cell.isHiddenDelBut = self.dataArr.count - 1 == indexPath.item ? YES : NO;
    return cell;
}

#pragma mark - 代理
/// 点击item调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self presentPictuerView:indexPath.item];
}

#pragma mark - cell代理
- (void)delButClickWithSendImageViewCell:(YBSendImageViewCell *)cell {
    // 根据cell获取索引
    NSInteger index = [self indexPathForCell:cell].item;
    // 删除知道那个数据
    [self.dataArr removeObjectAtIndex:index];
    [self reloadData];
    if (self.dataArr.count == 1) {
        self.hidden = YES;
    }
}

#pragma mark - 懒加载
/// 数据数组
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray arrayWithObject:[UIImage imageNamed:@"compose_pic_add_highlighted"]];
    }
    return _dataArr;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
