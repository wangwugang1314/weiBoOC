//
//  YBSendViewController.m
//  weiBoOC
//
//  Created by MAC on 15/12/9.
//  Copyright © 2015年 MAC. All rights reserved.
//

#import "YBSendViewController.h"
#import "YBUserModel.h"
#import "YBSendTextView.h"
#import "YBSendToolBar.h"
#import "YBEmotionKeyBoard.h"
#import "YBEmoticon.h"
#import "YBTextAttachment.h"
#import "weiBoOC-swift.h"

@interface YBSendViewController () <YBSendToolBarDelegate, YBEmotionKeyBoardDelegate>

/// textView
@property(nonatomic, weak) YBSendTextView *textView;
/// toolBar
@property(nonatomic, weak) YBSendToolBar *toolBar;

@end

@implementation YBSendViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 准备UI
    [self prepareUI];
    // 通知
    [self setterNotification];
}

#pragma mark - 通知
- (void)setterNotification {
    // 通知（监听textView内容变化）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotification) name:UITextViewTextDidChangeNotification object:nil];
    // 通知（监听键盘frame变化）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

/// 通知
- (void)textViewTextDidChangeNotification {
    self.navigationItem.rightBarButtonItem.enabled = self.textView.text.length;
}

/// 通知
- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    // 获取动画时间
    CGFloat animTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 获取改变后的高度
    CGFloat changeKayBoary = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    // 做动画
    [UIView animateWithDuration:animTime animations:^{
        self.toolBar.transform = CGAffineTransformMakeTranslation(0, -([UIScreen height] - changeKayBoary));
    }];
}

#pragma mark - 准备UI
- (void)prepareUI {
    // 设置导航栏
    [self setNavBar];
    // textView
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    // toolBar
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

/// 设置导航兰纽
- (void)setNavBar{
    // 设置左边
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
    // 右边
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 设置中间
    self.navigationItem.titleView = [self navBarTitleView];
}

#pragma mark - 按钮点击事件
/// 导航栏左边按钮点击
- (void)leftBarButtonItemClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 导航栏右边按钮点击
- (void)rightBarButtonItemClick{
    YBLog(@"rightBarButtonItemClick")
}

#pragma mark - ToolBarDelegate
- (void)sendToolBar:(YBSendToolBar *)toolBar withStyle:(YBSendToolBarButClickStyle)butClickStyle {
    YBEmotionKeyBoard *keyboard = [YBEmotionKeyBoard sharedEmotionKeyBoard];
    switch (butClickStyle) {
        case YBSendToolBarButClickStyleEmotion:
            [self.textView resignFirstResponder];
            [keyboard resect];
            keyboard.ybDelegate = self;
            self.textView.inputView = keyboard;
            [self.textView becomeFirstResponder];
            break;
        case YBSendToolBarButClickStyleKeyboard:
            [self.textView resignFirstResponder];
            self.textView.inputView = nil;
            [self.textView becomeFirstResponder];
            break;
        default: break;
    }
}

#pragma mark - 表情键盘代理
- (void)emotionKeyBoard:(YBEmotionKeyBoard *)emotionKeyBoard didSelectAndEmotionModel:(YBEmoticon *)emotionModel {
    // 判断是不是删除按钮
    if(emotionModel.deletex != nil) {
        [self.textView deleteBackward];
    }else{ // 不是删除按钮
        // 判断是不是emoji表情
        if(emotionModel.code != nil) {
            [self.textView insertText:emotionModel.code];
            return;
        }
        // 创建附件
        YBTextAttachment *textAttachment = [YBTextAttachment new];
        // 添加图片
        textAttachment.image = [UIImage imageWithContentsOfFile:emotionModel.png];
        // 设置名称
        textAttachment.stringName = emotionModel.chs;
        // 设置附件大小
        CGFloat textAttachmentSize = self.textView.font.lineHeight;
        
        YBLog(@"%f", textAttachmentSize)
        
        // 设置附件大小
        textAttachment.bounds = CGRectMake(0, -(textAttachmentSize * 0.2), textAttachmentSize, textAttachmentSize);
        // 创建属性字符串
        NSMutableAttributedString *newAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
        // 设置属字体大小
        [newAttributedString addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, 1)];
        // 获取当前属性字符串
        NSMutableAttributedString *oldAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
        // 获取当前位置
        NSRange currentRange = self.textView.selectedRange;
        // 替换指定位置数据
        [oldAttributedString replaceCharactersInRange:currentRange withAttributedString:newAttributedString];
        // 赋值
        self.textView.attributedText = oldAttributedString;
        // 手动发送代理
        [self.textView textViewDidChange:self.textView];
    }
}

#pragma mark - 懒加载
/// 导航栏中间
- (UILabel *)navBarTitleView {
    UILabel *lable = [UILabel new];
    NSString *str = [NSString stringWithFormat:@"发微博\n%@",[YBUserModel userModel].screen_name];
    NSMutableAttributedString *mAttributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [mAttributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor orangeColor]} range:NSMakeRange(0, 3)];
    [mAttributedString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(3, str.length - 3)];
    lable.attributedText = mAttributedString;
    lable.numberOfLines = 0;
    lable.textAlignment = NSTextAlignmentCenter;
    [lable sizeToFit];
    return lable;
}

/// textView
- (YBSendTextView *)textView {
    if (_textView == nil) {
        YBSendTextView *textView = [YBSendTextView new];
        [self.view addSubview:textView];
        self.textView = textView;
    }
    return _textView;
}

/// toolBar
- (YBSendToolBar *)toolBar {
    if (!_toolBar) {
        YBSendToolBar *toolBar = [YBSendToolBar new];
        [self.view addSubview:toolBar];
        toolBar.ybDelegate = self;
        _toolBar = toolBar;
    }
    return _toolBar;
}

#pragma mark - 对象销毁
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
