//
//  UIImage+Category.m
//  04-其他的绘图方式
//
//  Created by apple on 15/9/4.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

+(instancetype )circleScaleWithImage:(UIImage *)image
{
    // 获得图片的尺寸
    CGFloat imageW = image.size.width; // 100
    CGFloat imageH = image.size.height; // 200
    
    CGFloat rectW = MIN(imageW, imageH);
    /**
     *  size:上下文的尺寸
     *  opaque: YES:不透明  NO:透明
     *  scale ：缩放系数  0.0 或 1 如果传人0.0，那么最终获得图片的尺寸就是上下文尺寸的宽高 * 2
     */
    // 开启一个位图上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rectW, rectW), NO, 0.0);
    
    // 获得上下文
    // 获得图形上下文就是刚刚开启
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 拼接路径
    // 绘制圆
    
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, rectW, rectW));
    
    // 裁剪
    CGContextClip(ctx);
    // 绘制图片
    [image drawInRect:CGRectMake(0, 0, rectW, rectW)];
    
    // 渲染
    CGContextStrokePath(ctx);
    
    // 从位图上下文中获得图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(instancetype )circleWithImage:(UIImage *)image
{
    // 获得图片的尺寸
    CGFloat imageW = image.size.width; // 100
    CGFloat imageH = image.size.height; // 200
    
    // 获得最小边长
    CGFloat minRectW = MIN(imageW, imageH);
    // 获得最大边长
    CGFloat maxRectW = MAX(imageW, imageH);
    /**
     *  size:上下文的尺寸
     *  opaque: YES:不透明  NO:透明
     *  scale ：缩放系数  0.0 或 1 如果传人0.0，那么最终获得图片的尺寸就是上下文尺寸的宽高 * 2
     */
    // 开启一个位图上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(minRectW, minRectW), NO, 0.0);
    
    // 获得上下文
    // 获得图形上下文就是刚刚开启
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 拼接路径
    // 绘制圆
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, minRectW, minRectW));
    
    // 裁剪
    CGContextClip(ctx);
    
    // 绘制图片
    [image drawInRect:CGRectMake(-(imageW - minRectW) * 0.5, -(imageH - maxRectW) * 0.5, imageW, imageH)];
    
    // 渲染
    CGContextStrokePath(ctx);
    
    // 从位图上下文中获得图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(instancetype )circleWithImage:(UIImage *)image borderWith:(CGFloat)borderWidth boderColor:(UIColor *)borderColor
{
    // 获得图片的尺寸
    CGFloat imageW = image.size.width; // 100
    CGFloat imageH = image.size.height; // 200
    
    CGFloat rectW = MIN(imageW, imageH);
    /**
     *  size:上下文的尺寸
     *  opaque: YES:不透明  NO:透明
     *  scale ：缩放系数  0.0 或 1 如果传人0.0，那么最终获得图片的尺寸就是上下文尺寸的宽高 * 2
     */
    // 开启一个位图上下文
    // 位图上下文的宽
    CGFloat sizeW = rectW + borderWidth * 2;
    // 位图上下文的高
    CGFloat sizeH = sizeW;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sizeW, sizeH), NO, 0.0);
    
    // 获得上下文
    // 获得图形上下文就是刚刚开启
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 设置颜色
    [borderColor set];
    // 绘制大圆
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, sizeW, sizeH));
    CGContextFillPath(ctx);
    
    // 绘制小圆
    CGContextAddEllipseInRect(ctx, CGRectMake(borderWidth, borderWidth, rectW, rectW));
    // 裁剪
    CGContextClip(ctx);
    
    // 绘制图片
    [image drawInRect:CGRectMake(borderWidth, borderWidth, rectW, rectW)];
    // 渲染
    CGContextStrokePath(ctx);
    
    // 从位图上下文中获得图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}

+(instancetype )circleScaleWithImage:(UIImage *)image borderWith:(CGFloat)borderWidth boderColor:(UIColor *)borderColor
{
    // 获得图片的尺寸
    CGFloat imageW = image.size.width; // 100
    CGFloat imageH = image.size.height; // 200
    
    // 获得最小边长
    CGFloat minRectW = MIN(imageW, imageH);
    // 获得最大边长
    CGFloat maxRectW = MAX(imageW, imageH);
    /**
     *  size:上下文的尺寸
     *  opaque: YES:不透明  NO:透明
     *  scale ：缩放系数  0.0 或 1 如果传人0.0，那么最终获得图片的尺寸就是上下文尺寸的宽高 * 2
     */
    // 开启一个位图上下文
    // 位图上下文的宽
    CGFloat sizeW = minRectW + borderWidth * 2;
    // 位图上下文的高
    CGFloat sizeH = sizeW;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sizeW, sizeH), NO, 0.0);
    
    // 获得上下文
    // 获得图形上下文就是刚刚开启
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 设置颜色
    [borderColor set];
    // 绘制大圆
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, sizeW, sizeH));
    CGContextFillPath(ctx);
    
    // 绘制小圆
    CGContextAddEllipseInRect(ctx, CGRectMake(borderWidth, borderWidth, minRectW, minRectW));
    // 裁剪
    CGContextClip(ctx);
    
    // 绘制图片
    [image drawInRect:CGRectMake(-(imageW - minRectW) * 0.5, -(imageH - maxRectW) * 0.5, imageW, imageH)];
    // 渲染
    CGContextStrokePath(ctx);
    
    // 从位图上下文中获得图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithStretchImage:(UIImage *)image andTopScale:(CGFloat)topScale andLeftScale:(CGFloat)leftScale andBottonScale:(CGFloat)bottonScale andRightScale:(CGFloat)rightScale;
{
    // 图片宽高
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    // 四条线的比例
    CGFloat top = height * topScale;
    CGFloat left = width * leftScale;
    CGFloat botton = height * bottonScale;
    CGFloat right = width * rightScale;
    
    UIEdgeInsets esges = {top,left,botton,right};
    return [image resizableImageWithCapInsets:esges];
}

+ (UIImage *)imageWithStretchImage:(UIImage *)image;
{
    CGFloat imageW = image.size.width; // 200
    CGFloat imageH = image.size.height;
    CGFloat top = imageH * 0.5;
    CGFloat left = imageW * 0.5; // 100
    return  [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
}

- (UIImage *)image:(UIImage *)image shuiYinImage:(UIImage *)shuiYinImage addPoint:(CGPoint)point isDesktop:(BOOL)b
{
    // 在内存中开辟一块空间
    UIGraphicsBeginImageContext(image.size);
    // 画图
    [image drawAtPoint:CGPointMake(0, 0)];
    [shuiYinImage drawAtPoint:point];
    // 获取位图
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    if (b) {
        [UIImagePNGRepresentation(bgImage) writeToFile:@"/users/apple/desktop/abc.png" atomically:YES];
        [UIImagePNGRepresentation(bgImage) writeToFile:@"/users/apple/desktop/abc.jpg" atomically:YES];
    }
    return bgImage;
}

- (UIImage *)image:(UIImage *)image addString:(NSString *)string addPoint:(CGPoint)point addFont:(CGFloat)font addColor:(UIColor *)color isDesktop:(BOOL)b
{
    // 在内存中开辟一块空间
    UIGraphicsBeginImageContext(image.size);
    // 画图
    [image drawAtPoint:CGPointMake(0, 0)];
    // 画字
    [string drawAtPoint:point withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font],NSForegroundColorAttributeName:color}];
    // 获取位图
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if (b) {
        [UIImagePNGRepresentation(bgImage) writeToFile:@"/users/apple/desktop/abc.png" atomically:YES];
        [UIImagePNGRepresentation(bgImage) writeToFile:@"/users/apple/desktop/abc.jpg" atomically:YES];
    }
    return bgImage;
}

// 裁剪图片(在image中指定的区域裁剪)
+(instancetype)circleImageWithImage:(UIImage *)image withSize:(CGRect)rect
{
    return [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, rect)];
}

/**
 *  获得某个像素的颜色
 *
 *  @param point 像素点的位置
 */
- (UIColor *)pixelColorAtLocation:(CGPoint)point {
    UIColor *color = nil;
    CGImageRef inImage = self.CGImage;
    CGContextRef contexRef = [self ARGBBitmapContextFromImage:inImage];
    if (contexRef == NULL) return nil;
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(contexRef, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (contexRef);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        //		NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    // When finished, release the context
    CGContextRelease(contexRef);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}

/**
 *  根据CGImageRef来创建一个ARGBBitmapContext
 */
- (CGContextRef)ARGBBitmapContextFromImage:(CGImageRef) inImage {
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    //colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);  //deprecated
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

/// 压缩图片
- (UIImage *)minImageWithMaxWith:(CGFloat)maxWidth andMaxHeight:(CGFloat)maxHeight {
    CGFloat imageWidth = 0;
    CGFloat imageHeight = 0;
    if (self.size.width / self.size.height > maxWidth / maxHeight) { // 计算高度
        imageWidth = maxWidth;
        imageHeight = self.size.height * (imageWidth / self.size.width);
    }else{ // 计算宽度
        imageHeight = maxHeight;
        imageWidth = self.size.width * (imageHeight / self.size.height);
    }
    
    // 上下文
    UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageHeight));
    // 绘图
    [self drawInRect:CGRectMake(0, 0, imageWidth, imageHeight)];
    // 获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

@end
