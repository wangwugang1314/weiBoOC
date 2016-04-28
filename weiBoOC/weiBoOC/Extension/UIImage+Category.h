
#import <UIKit/UIKit.h>

@interface UIImage (Category)

/// 裁剪图片（圆形） 如果图片不是正方形，长的那一边会压缩
+(instancetype)circleScaleWithImage:(UIImage *)image;
/// 裁剪图片（圆形） 如果图片不是正方形，会从正中间裁剪
+(instancetype)circleWithImage:(UIImage *)image;
/// 裁剪图片（圆形,有边框） 如果图片不是正方形，长的那一边会压缩
+(instancetype)circleWithImage:(UIImage *)image borderWith:(CGFloat)borderWidth boderColor:(UIColor *)borderColor;
/// 裁剪图片（圆形,有边框） 如果图片不是正方形，会从正中间裁剪
+(instancetype)circleScaleWithImage:(UIImage *)image borderWith:(CGFloat)borderWidth boderColor:(UIColor *)borderColor;

/// 裁剪图片(在image裁剪裁剪指定的区域)
+(instancetype)circleImageWithImage:(UIImage *)image withSize:(CGRect)rect;

/// 给一个图片，返回一个拉伸的图片，拉伸指定的位置
+ (UIImage *)imageWithStretchImage:(UIImage *)image andTopScale:(CGFloat)topScale andLeftScale:(CGFloat)leftScale andBottonScale:(CGFloat)bottonScale andRightScale:(CGFloat)rightScale;
/// 拉伸图片（当按钮点击不会出现颜色不均匀）
+ (UIImage *)imageWithStretchImage:(UIImage *)image;

/// 给一个图片加上水印图片 b是否打印到桌面
- (UIImage *)image:(UIImage *)image shuiYinImage:(UIImage *)shuiYinImage addPoint:(CGPoint)point isDesktop:(BOOL)b;
/// 给一个图片加上水印字 b是否打印到桌面
- (UIImage *)image:(UIImage *)image addString:(NSString *)string addPoint:(CGPoint)point addFont:(CGFloat)font addColor:(UIColor *)color isDesktop:(BOOL)b;

/// 获得某个像素的颜色（point：指定坐标点）
- (UIColor *)pixelColorAtLocation:(CGPoint)point;

/// 压缩图片
- (UIImage *)minImageWithMaxWith:(CGFloat)maxWidth andMaxHeight:(CGFloat)maxHeight;

@end
