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
#import "YBNetworking.h"
#import "UIImage+Category.h"
#import "YBSendImageView.h"

@interface YBSendViewController () <YBSendToolBarDelegate, YBEmotionKeyBoardDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/// textView
@property(nonatomic, weak) YBSendTextView *textView;
/// toolBar
@property(nonatomic, weak) YBSendToolBar *toolBar;
/// 当前点击图片索引
@property(nonatomic, strong) NSNumber *index;

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
    // 通知展现相册
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendImageViewPresentPickerViewNotification:) name:@"YBSendImageViewPresentPickerViewNotification" object:nil];
}

/// 通知文字内容改变
- (void)textViewTextDidChangeNotification {
    self.navigationItem.rightBarButtonItem.enabled = self.textView.text.length;
}

/// 展现相册
- (void)sendImageViewPresentPickerViewNotification:(NSNotification *)notification {
    self.index = notification.userInfo[@"index"];
    // 判断相册是否可用
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        // 不可用直接返回
        [SVProgressHUD showErrorWithStatus:@"相册不可用"];
        return;
    }
    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
    // 设置来源
    pc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 设置代理
    pc.delegate = self;
    // 展现
    [self presentViewController:pc animated:YES completion:nil];
}

/// 通知键盘frame改变
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
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 导航栏右边按钮点击(发微博)
- (void)rightBarButtonItemClick{
    // 文本
    __block NSString *text = @"";
    // 遍历属性
    __weak typeof(self) weakSelf = self;
    [self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.textView.attributedText.string.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if (attrs[@"NSAttachment"] != nil) { // 有附件
            // 获取附件
            YBTextAttachment *textAttachment = attrs[@"NSAttachment"];
            text = [NSString stringWithFormat:@"%@%@",text, textAttachment.stringName];
        }else{ // 没有附件
            text = [NSString stringWithFormat:@"%@%@",text, [weakSelf.textView.attributedText.string substringWithRange:range]];
        }
    }];
    // 如果有图片就发送有图片的微博
    NSArray *arr = self.textView.imageCollectionView.dataArr;
    UIImage *image = arr.count > 1 ? arr[0] : nil;
    
    [YBNetworking sendWeiBoWithText:text image:image andFinish:^(BOOL success) {
        if (success) { // 成功
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        }else{ // 失败
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }
    }];
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
        case YBSendToolBarButClickStylePictuer:
            // 通知要加载图片
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YBSendToolBarButClickStylePictuerNotification" object:nil];
            break;
        default: break;
    }
}

#pragma mark - 相册图片点击代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo {
    UIImage *minImage = [image minImageWithMaxWith:300 andMaxHeight:300];
    // 通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YBImagePickerControllerDidFinishNotification" object:nil userInfo:@{@"index":self.index, @"image": minImage}];
    // 退出
    [picker dismissViewControllerAnimated:YES completion:nil];
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
        [self textViewTextDidChangeNotification];
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
