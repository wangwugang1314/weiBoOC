// 底部       44
// 指示条     30

#import "YBEmotionKeyBoard.h"
#import "YBEmotionGroupView.h"
#import "YBEmoticonsModel.h"
#import "YBEmotionView.h"
#import "YBEmoticon.h"

@interface YBEmotionKeyBoard () <YBEmotionGroupViewDelegate, YBEmotionViewDelegate>

/// 数据
@property(nonatomic, strong) NSArray *dataArr;
/// 底部组
@property(nonatomic, weak) YBEmotionGroupView *emotionGroupView;
/// 指示条
@property(nonatomic, weak) UIPageControl *pageControl;
/// 表情
@property(nonatomic, weak) YBEmotionView *emotionView;
/// 当前分组
@property(nonatomic, assign) NSInteger currentSection;

@end

@implementation YBEmotionKeyBoard

/// 单利
YBSingleton_m(EmotionKeyBoard)

#pragma mark - 构造方法
- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen width], [UIScreen width] / 7 * 3 + 74)]) {
        // 当当前索引设置
        self.currentSection = 100;
        // 准备UI
        [self prepareUI];
        // 设置数据
        [self setterData];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 准备UI
- (void)prepareUI{
    // 底部表情组
    [self.emotionGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(44);
    }];
    // pageControl
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.emotionGroupView.mas_top);
        make.height.mas_equalTo(29);
    }];
    // 表情
    [self.emotionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.pageControl.mas_top);
        make.top.mas_equalTo(self.mas_top);
    }];
}

#pragma mark - 设置数据
- (void)setterData {
    // 底部表情数组
    self.emotionGroupView.dataArr = self.dataArr;
    // 表情
    self.emotionView.dataArr = self.dataArr;
}

/// 复位
- (void)resect {
    [self emotionGroupView:nil andSelectIndex:1];
}

#pragma mark - 代理
/// 表情组名代理
- (void)emotionGroupView:(YBEmotionGroupView *)groupView andSelectIndex:(NSInteger)index {
    // 改变表情
    [self.emotionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
    // 改变page
    YBEmoticonsModel *emoticonsModel = self.dataArr[index];
    self.pageControl.numberOfPages = emoticonsModel.pageNum;
    self.pageControl.currentPage = 0;
}

/// 表情代理
- (void)emotionView:(YBEmotionView *)emotionView andIndexPath:(NSIndexPath *)indexPath {
    // 设置底部分组
    if (self.currentSection != indexPath.section) {
        self.currentSection = indexPath.section;
        self.emotionGroupView.selecterIndex = indexPath.section;
        // 设置page个数
        YBEmoticonsModel *emoticonsModel = self.dataArr[indexPath.section];
        self.pageControl.numberOfPages = emoticonsModel.pageNum;
    }
    self.pageControl.currentPage = indexPath.item - 1;
}

/// 点击表情代理
- (void)emotionView:(YBEmotionView *)emotionView didSelectAndEmotionModel:(YBEmoticon *)emotionModel {
    // 如果是空直接返回
    if(emotionModel.png == nil && emotionModel.code == nil && emotionModel.deletex == nil) {
        return;
    }
    if ([self.ybDelegate respondsToSelector:@selector(emotionKeyBoard:didSelectAndEmotionModel:)]) {
        [self.ybDelegate emotionKeyBoard:self didSelectAndEmotionModel:emotionModel];
    }
}

#pragma mark - 懒加载
/// 数据数组
- (NSArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [YBEmoticonsModel emoticonsModels];
    }
    return _dataArr;
}

/// 底部
- (YBEmotionGroupView *)emotionGroupView {
    if (!_emotionGroupView) {
        YBEmotionGroupView *view = [YBEmotionGroupView new];
        [self addSubview:view];
        view.ybDelegate = self;
        _emotionGroupView = view;
    }
    return _emotionGroupView;
}

/// 指示条
- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        UIPageControl *pc = [UIPageControl new];
        pc.pageIndicatorTintColor = [UIColor grayColor];
        pc.currentPageIndicatorTintColor = [UIColor orangeColor];
        YBEmoticonsModel *emoticonsModel = self.dataArr[1];
        pc.numberOfPages = emoticonsModel.pageNum;
        [self addSubview:pc];
        pc.userInteractionEnabled = NO;
        _pageControl = pc;
    }
    return _pageControl;
}

/// 表情
- (YBEmotionView *)emotionView {
    if (_emotionView == nil) {
        YBEmotionView *view = [YBEmotionView new];
        view.ybDelegate = self;
        [self addSubview:view];
        _emotionView = view;
    }
    return _emotionView;
}

@end
