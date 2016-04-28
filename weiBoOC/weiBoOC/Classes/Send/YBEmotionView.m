//
//  YBEmotionView.m
//  weiBoOC
//
//  Created by MAC on 15/12/10.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBEmotionView.h"
#import "YBEmotionCell.h"
#import "YBEmoticonsModel.h"
#import "YBEmoticon.h"

@interface YBEmotionView () <UICollectionViewDataSource, UICollectionViewDelegate>

/// 布局
@property(nonatomic, weak) UICollectionViewFlowLayout *layout;

@end

@implementation YBEmotionView

#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.layout = layout;
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
        // 注册
        [self registerClass:[YBEmotionCell class] forCellWithReuseIdentifier:@"YBEmotionViewCell"];
        // 准备UI
        [self prepareUI];
        // 设置布局
        [self setterLayout];
        // 设置背景颜色
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

#pragma mark - 准备UI
- (void)prepareUI{
    
}

/// 设置布局
- (void)setterLayout {
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    CGFloat width = [UIScreen width] / 7;
    self.layout.itemSize = CGSizeMake(width, width);
    // 设置水平滑动
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 分页
    self.pagingEnabled = YES;
}

#pragma mark - 数据源代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    YBEmoticonsModel *emotionsModel = self.dataArr[section];
    return emotionsModel.emotions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YBEmotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBEmotionViewCell" forIndexPath:indexPath];
    // 获取指定的数据
    YBEmoticonsModel *emoticonModel = self.dataArr[indexPath.section];
    cell.emotionModel = emoticonModel.emotions[indexPath.item];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        collectionView.contentOffset = CGPointMake(collectionView.width, 0);
    });
    
    return cell;
}

#pragma mark - 代理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取指定的数据
    YBEmoticonsModel *emoticonsModel = self.dataArr[indexPath.section];
    YBEmoticon *emoticon = emoticonsModel.emotions[indexPath.row];
    
    // 点击代理
    if ([self.ybDelegate respondsToSelector:@selector(emotionView:didSelectAndEmotionModel:)]) {
        [self.ybDelegate emotionView:self didSelectAndEmotionModel:emoticon];
    }
    
    // 如果是删除按钮直接返回
    if(emoticon.deletex != nil) {
        return;
    }
    
    // 加1
    emoticon.num++;
    
    // 获取最近
    YBEmoticonsModel *latelyModel = self.dataArr[0];
    
    // 判断是组里面是否有
    BOOL isEq = [latelyModel.emotions containsObject:emoticon];

    YBEmoticon *delModel;
    // 如果相等不添加数据
    if (!isEq) {
        // 移除删除按钮
        delModel = latelyModel.emotions.lastObject;
        [latelyModel.emotions removeLastObject];
        // 添加数据
        [latelyModel.emotions addObject:emoticon];
    }
    
    // 排序
    latelyModel.emotions = [NSMutableArray arrayWithArray:[latelyModel.emotions sortedArrayUsingComparator:^NSComparisonResult(YBEmoticon *_Nonnull obj1, YBEmoticon *_Nonnull obj2) {
        return obj1.num < obj2.num;
    }]];

    // 如果相等不移除
    if (!isEq) {
        // 添加删除按钮
        [latelyModel.emotions insertObject:delModel atIndex:20];
        // 移除最后一个
        [latelyModel.emotions removeLastObject];
    }
    
    // 如果是最近不更新数据
    if(indexPath.section != 0) {
        // 更新数据
        [self reloadData];
    }
}

/// 停止滚动的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    __block NSInteger index = scrollView.contentOffset.x / scrollView.width + 1;
    __block NSInteger section = 0;
    [self.dataArr enumerateObjectsUsingBlock:^(YBEmoticonsModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index - obj.pageNum <= 0) {
            section = idx;
            *stop = YES;
        }else{
            index -= obj.pageNum;
        }
    }];
    // 代理
    if ([self.ybDelegate respondsToSelector:@selector(emotionView:andIndexPath:)]) {
        [self.ybDelegate emotionView:self andIndexPath:[NSIndexPath indexPathForItem:index inSection:section]];
    }
}

#pragma mark - setter
/// 设置数据
- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self reloadData];
}

@end

