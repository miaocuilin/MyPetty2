//
//  MyControl.m
//  test_demo
//
//  Created by Apple on 13-3-6.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "MyControl.h"
#import <ImageIO/ImageIO.h>
#define IOS7 [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0
#import "EMConversation.h"
#import "EaseMob.h"
#import "UserPetListModel.h"

@implementation MyControl
//工厂模式   +方法
//label  button  imageView  View
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text
{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    //限制行数
    label.numberOfLines = 0;
    //对齐方式
    label.textAlignment=NSTextAlignmentLeft;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:font];
    //单词折行
    //NSLineBreakByWordWrapping
    label.lineBreakMode= NSLineBreakByCharWrapping;
    //默认字体颜色是黑色
    label.textColor=[UIColor whiteColor];
    //自适应（行数~字体大小按照设置大小进行设置）
    label.adjustsFontSizeToFitWidth=YES;
    label.text=text;
    label.userInteractionEnabled = YES;
    return [label autorelease];
}
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if(imageName != nil && imageName.length){
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
//    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    button.showsTouchWhenHighlighted = YES;
    
    return button;
    

}
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName
{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    if(imageName != nil && imageName.length){
        imageView.image=[UIImage imageNamed:imageName];
    }
    imageView.userInteractionEnabled=YES;
    return [imageView autorelease];
}
+(UIView*)createViewWithFrame:(CGRect)frame
{
    UIView*view=[[UIView alloc]initWithFrame:frame];
    view.userInteractionEnabled = YES;
    return [view autorelease];

}
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font
{
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    //灰色提示框
    textField.placeholder=placeholder;
    //文字对齐方式
    textField.textAlignment=NSTextAlignmentLeft;
    textField.secureTextEntry=YESorNO;
    //边框
    textField.borderStyle=UITextBorderStyleRoundedRect;
    //键盘类型
    textField.keyboardType=UIKeyboardTypeEmailAddress;
    //关闭首字母大写
    textField.autocapitalizationType=NO;
    //清除按钮
    textField.clearButtonMode=YES;
    //左图片
    textField.leftView=imageView;
    textField.leftViewMode=UITextFieldViewModeAlways;
    //右图片
    textField.rightView=rightImageView;
    //编辑状态下一直存在
    textField.rightViewMode=UITextFieldViewModeWhileEditing;
    //自定义键盘
    //textField.inputView
    //字体
    textField.font=[UIFont systemFontOfSize:font];
    //字体颜色
    textField.textColor=[UIColor blackColor];
    //文字顶上
//    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    return [textField autorelease];

}
#pragma  mark 适配器方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName
{
   UITextField*text= [self createTextFieldWithFrame:frame placeholder:placeholder passWord:YESorNO leftImageView:imageView rightImageView:rightImageView Font:font];
    text.background=[UIImage imageNamed:imageName];
    return  text;

}


#pragma -mark 判断导航的高度

+(float)isIOS7{
//[[[UIDevice currentDevice] systemVersion] floatValue]>=7.0
    float height;
    if(IOS7){
        height=64.0;
    }else{
        height=44.0;
    }
    
    return height;
}

+(UIAlertView *)createAlertViewWithTitle:(NSString *)title
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    return [alert autorelease];
}

+(UIAlertView *)createAlertViewWithTitle:(NSString *)title Message:(NSString *)message delegate:(id)delegate cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitles, nil];
    [alert show];
    return [alert autorelease];
}

+(NSString *)timeFromTimeStamp:(NSString *)timeStamp
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStamp intValue]];
    
    NSTimeInterval  timeInterval = [confromTimesp timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return result;
}
#pragma mark - 时间戳转时间2014年11月1日
+(NSString *)timeStringFromStamp:(NSString *)timeStamp
{
    NSDateFormatter * fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日";
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[timeStamp intValue]];
    NSString * time = [fmt stringFromDate:date];
    [fmt release];
    
    return time;
}
+(NSString *)leftTimeFromStamp:(NSString *)timeStamp
{
    NSDate * date = [NSDate date];
    //当前时间戳
    NSString * stamp = [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    //t为时间差
    //24小时为期限
    int t = 0;
    //当前时间戳-时间戳 < 24h 才显示
    if ([stamp intValue]-[timeStamp intValue] < 24*60*60) {
        t = 24*60*60-([stamp intValue]-[timeStamp intValue]);
    }
    int h = t/60/60;
    int m = (t-h*3600)/60;
    int s = t-h*3600-m*60;
    return [NSString stringWithFormat:@"%.2d:%.2d:%.2d", h, m, s];
}

#pragma mark - 屏幕截图
+(UIImage *)imageWithView:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return backgroundImage;
}
+(void)saveScreenshotsWithImage:(UIImage *)image
{
//    UIImage * image = [MyControl imageWithView:view];
    
//    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = BLURBG;
    //将下载的图片存放到本地
    NSData * data = UIImageJPEGRepresentation(image, 0.5);
//    NSData * data = UIImagePNGRepresentation(image);
    [data writeToFile:filePath atomically:YES];
}

#pragma mark -取图片的一部分
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

+(UIImage *)returnImageWithImage:(UIImage *)oldImage Width:(float)widthOfNeed Height:(float)heightOfNeed
{
    UIImage * newImage = nil;
    
    float rateA = widthOfNeed/heightOfNeed;
    float rateB = heightOfNeed/widthOfNeed;
    
    float width = oldImage.size.width;
    float height = oldImage.size.height;
    
    if (width/height>rateA) {
        //偏宽，保证高度
        newImage = [MyControl imageFromImage:oldImage inRect:CGRectMake((width-height*rateA)/2, 0, height*rateA, height)];
    }else{
        //偏高，保证宽度
        newImage = [MyControl imageFromImage:oldImage inRect:CGRectMake(0, (height-width*rateB)/2, width, width*rateB)];
    }
    
    return newImage;
}

+(NSString *)returnAgeStringWithCountOfMonth:(NSString *)countOfMonth
{
    NSString * ageString = nil;
    int a = [countOfMonth intValue];
    if (a<12) {
        ageString = [NSString stringWithFormat:@"%d个月", a];
    }else if(a%12 == 0){
        ageString = [NSString stringWithFormat:@"%d岁", a/12];
    }else{
        ageString = [NSString stringWithFormat:@"%d岁%d个月", a/12, a%12];
    }
    return ageString;
}

//自定义加载文字的loading
+(void)startLoadingWithStatus:(NSString *)status
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showProgressWithStyle:0 title:nil status:status confirmationMessage:@"确认取消?" cancelBlock:^{LoadingFailed;}];
}
+(void)loadingSuccessWithContent:(NSString *)content afterDelay:(float)delay
{
    [MMProgressHUD dismissWithSuccess:content title:nil afterDelay:delay];
}
+(void)loadingFailedWithContent:(NSString *)content afterDelay:(float)delay
{
    [MMProgressHUD dismissWithError:content afterDelay:delay];
}

//字典转data
+(NSData *)returnDataWithDictionary:(NSDictionary *)dict
{
    NSMutableData * data = [[NSMutableData alloc] init];
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:@"talkData"];
    [archiver finishEncoding];

    [data autorelease];
    [archiver autorelease];
    
    return data;
}
//路径文件转dictonary
+(NSDictionary *)returnDictionaryWithDataPath:(NSString *)path
{
    NSData * data = [[NSMutableData alloc] initWithContentsOfFile:path];
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary * myDictionary = [[unarchiver decodeObjectForKey:@"talkData"] retain];
    [unarchiver finishDecoding];
//    NSLog(@"%@", myDictionary);
    [unarchiver autorelease];
    [data autorelease];

    return myDictionary;
}
//NSArray转data
+(NSData *)returnDataWithArray:(NSArray *)array
{
    NSMutableData * data = [[NSMutableData alloc] init];
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:array forKey:@"petsData"];
    [archiver finishEncoding];
    
    [data autorelease];
    [archiver autorelease];
    
    return data;
}
//路径文件转NSArray
+(NSArray *)returnArrayWithData:(NSData *)data
{
    if (data.length == 0) {
        return nil;
    }
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSArray * array = [[unarchiver decodeObjectForKey:@"petsData"] retain];
    [unarchiver finishDecoding];
    //    NSLog(@"%@", myDictionary);
    [unarchiver autorelease];
    
    return [array autorelease];
}


#pragma mark - 传进NSURL返回图片的宽高字典
+(NSDictionary *)imageSizeFrom:(NSURL *)imageUrl
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)imageUrl, NULL);
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:NO], (NSString *)kCGImageSourceShouldCache,
                             nil];
    CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (__bridge CFDictionaryRef)options);
        NSLog(@"%@",imageProperties);
    NSDictionary * imageInfoDict = (NSDictionary *)imageProperties;
    //    NSLog(@"imageInfoDict%@", imageInfoDict);
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[imageInfoDict objectForKey:@"PixelWidth"], @"width", [imageInfoDict objectForKey:@"PixelHeight"], @"height", nil];
    return dict;
}
#pragma mark -
+(UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
#pragma mark - 图片大小限制
+ (NSData *)scaleToSize:(UIImage *)sourceImage
{
    float w = sourceImage.size.width;
    float h = sourceImage.size.height;
    float p = 0;
    if (w>=h && sourceImage.size.width>2000) {
        p = 2000/w;
        sourceImage = [self image:sourceImage fitInSize:CGSizeMake(w*p, h*p)];
//        sourceImage = [self OriginImage:sourceImage scaleToSize:CGSizeMake(w*p, h*p)];
    }else if(h>w && sourceImage.size.height>2000){
        p = 2000/h;
        sourceImage = [self image:sourceImage fitInSize:CGSizeMake(w*p, h*p)];
    }
    NSLog(@"%f--%f", sourceImage.size.width, sourceImage.size.height);
    CGFloat compression = 1.0f;
    float maxFileSize = 128*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(sourceImage, compression);
//    3746443 1748174 56556
//    13278499 4440060 284031
    NSLog(@"%d", imageData.length);
    compression = maxFileSize / [imageData length];
//    int count = 0;
//    while (imageData.length>maxFileSize) {
//        imageData = UIImageJPEGRepresentation(sourceImage, compression);
//        NSLog(@"*******%f--%d*******", compression, imageData.length);
//        sourceImage = [UIImage imageWithData:imageData];
//        
//        compression = maxFileSize / imageData.length;
//        NSLog(@"%d--%f", imageData.length, compression);
//        count++;
////        NSLog(@"======压缩后的图片大小：%d======%d", imageData.length, count);
//    }
    if (compression < 1) {
        imageData = UIImageJPEGRepresentation(sourceImage, compression);
    }
    NSLog(@"======压缩后的图片大小：%d======", imageData.length);
    return imageData;
}

+ (NSData *)scaleImage:(UIImage *)sourceImage WithSize:(CGSize)TargetSize
{
    float w = sourceImage.size.width;
    float h = sourceImage.size.height;
    float p = 0;
    if (w>=h && sourceImage.size.width>TargetSize.width) {
        p = 2000/w;
        sourceImage = [self image:sourceImage fitInSize:CGSizeMake(w*p, h*p)];
        //        sourceImage = [self OriginImage:sourceImage scaleToSize:CGSizeMake(w*p, h*p)];
    }else if(h>w && sourceImage.size.height>TargetSize.height){
        p = 2000/h;
        sourceImage = [self image:sourceImage fitInSize:CGSizeMake(w*p, h*p)];
    }
    NSLog(@"%f--%f", sourceImage.size.width, sourceImage.size.height);
    CGFloat compression = 1.0f;
    float maxFileSize = 128*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(sourceImage, compression);
    //    3746443 1748174 56556
    //    13278499 4440060 284031
    NSLog(@"%d", imageData.length);
    compression = maxFileSize / [imageData length];
        if (compression < 1) {
        imageData = UIImageJPEGRepresentation(sourceImage, compression);
    }
    NSLog(@"======压缩后的图片大小：%d======", imageData.length);
    return imageData;
}

#pragma mark - 图片缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    
    if (nil == image) {
        
        newimage = nil;
        
    }else{
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        }else{
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
}

#pragma mark - 
+ (CGSize) fitSize: (CGSize)thisSize inSize: (CGSize) aSize
{
    CGFloat scale;
    CGSize newsize = thisSize;
    if(newsize.height && (newsize.height<newsize.width))
//    if (newsize.height && (newsize.height > aSize.height))
    {
        scale = aSize.height / newsize.height;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    else
//    if (newsize.width && (newsize.width >= aSize.width))
    {
        scale = aSize.width / newsize.width;
        newsize.width *= scale;
        newsize.height *= scale;
    }
    
    return newsize;
}

//返回调整的缩略图

+ (UIImage *)image: (UIImage *) image fitInSize: (CGSize) viewsize
{
    // calculate the fitted size
    CGSize size = [self fitSize:image.size inSize:viewsize];
    
    UIGraphicsBeginImageContext(viewsize);
    
    float dwidth = (viewsize.width - size.width) / 2.0f;
    float dheight = (viewsize.height - size.height) / 2.0f;
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width, size.height);
    [image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

#pragma mark - 返回正方形的中心裁剪图片
+(UIImage *)returnSquareImageWithImage:(UIImage *)image
{
    float w = image.size.width;
    float h = image.size.height;
    if (w == h) {
        return image;
    }else if(w<h){
        UIImage * img = [MyControl imageFromImage:image inRect:CGRectMake(0, (h-w)/2, w, w)];
        return img;
    }else{
        UIImage * img = [MyControl imageFromImage:image inRect:CGRectMake((w-h)/2, 0, h, h)];
        return img;
    }
}

#pragma mark -
+(void)popAlertWithView:(UIView *)keyView Msg:(NSString *)msg
{
//    PopupView * pop = [ControllerManager sharePopView];
    PopupView * pop = [[PopupView alloc] init];
    [pop modifyUIWithSize:keyView.frame.size msg:msg];
    [keyView addSubview:pop];
    [pop release];
    
    [UIView animateWithDuration:0.2 animations:^{
        pop.bgView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.2 delay:1.5 options:0 animations:^{
            pop.bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [pop removeFromSuperview];
        }];
    }];
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    
    //    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    if(!success){
//        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    
    return success;
}
+(void)animateIncorrectPassword:(UIView *)view {
    // Clear the password field
    
    // Animate the alert to show that the entered string was wrong
    // "Shakes" similar to OS X login screen
    CGAffineTransform moveRight = CGAffineTransformTranslate(CGAffineTransformIdentity, 5, 0);
    CGAffineTransform moveLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -5, 0);
    CGAffineTransform resetTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    
    CGAffineTransform transform = CGAffineTransformIdentity;   //申明旋转量
    transform = CGAffineTransformMakeRotation(-M_PI/2);     //设置旋转量具体值
    
    [UIView animateWithDuration:0.05 animations:^{
        // Translate left
        view.transform = moveLeft;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.05 animations:^{
            
            // Translate right
            view.transform = moveRight;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.05 animations:^{
                
                // Translate left
                view.transform = moveLeft;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.05 animations:^{
                    
                    // Translate to origin
                    view.transform = resetTransform;
                }];
            }];
            
        }];
    }];
    
}

#pragma mark -
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+(void)setImageForBtn:(UIButton *)btn Tx:(NSString *)tx isPet:(BOOL)isPet
{
    if (![tx isKindOfClass:[NSString class]] || tx.length == 0) {
        tx = @"";
    }
    
    NSString * str = nil;
    UIImage * defaultImage = nil;
    if (isPet) {
        str = [NSString stringWithFormat:@"%@%@", PETTXURL, tx];
        defaultImage = [UIImage imageNamed:@"defaultPetHead.png"];
    }else{
        str = [NSString stringWithFormat:@"%@%@", USERTXURL, tx];
        defaultImage = [UIImage imageNamed:@"defaultUserHead.png"];
    }
    [btn setBackgroundImageWithURL:[NSURL URLWithString:str] forState:UIControlStateNormal placeholderImage:defaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image && image.size.width != image.size.height) {
            [btn setBackgroundImage:[MyControl returnSquareImageWithImage:image] forState:UIControlStateNormal];
        }
    }];
}
+(void)setImageForImageView:(UIImageView *)imageView Tx:(NSString *)tx isPet:(BOOL)isPet
{
    if (![tx isKindOfClass:[NSString class]] || tx.length == 0) {
        tx = @"";
    }
    
    NSString * str = nil;
    UIImage * defaultImage = nil;
    if (isPet) {
        str = [NSString stringWithFormat:@"%@%@", PETTXURL, tx];
        defaultImage = [UIImage imageNamed:@"defaultPetHead.png"];
    }else{
        str = [NSString stringWithFormat:@"%@%@", USERTXURL, tx];
        defaultImage = [UIImage imageNamed:@"defaultUserHead.png"];
    }
    [imageView setImageWithURL:[NSURL URLWithString:str] placeholderImage:defaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (!image) {
            if (!isPet) {
                [imageView setImage:[UIImage imageNamed:@"defaultUserHead.png"]];
            }else{
                [imageView setImage:[UIImage imageNamed:@"defaultPetHead.png"]];
            }
            
//            [imageView setImage:[MyControl returnSquareImageWithImage:image]];
        }
    }];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
}

+(void)setImageForBtn:(UIButton *)btn Tx:(NSString *)tx isPet:(BOOL)isPet isRound:(BOOL)isRound
{
    if (isRound) {
        float a = btn.frame.size.width/2.0;
        btn.layer.cornerRadius = a;
        btn.layer.masksToBounds = YES;
    }
    [self setImageForBtn:btn Tx:tx isPet:isPet];
}
+(void)setImageForImageView:(UIImageView *)imageView Tx:(NSString *)tx isPet:(BOOL)isPet isRound:(BOOL)isRound
{
    if (isRound) {
        float a = imageView.frame.size.width/2.0;
        imageView.layer.cornerRadius = a;
        imageView.layer.masksToBounds = YES;
    }
    [self setImageForImageView:imageView Tx:tx isPet:isPet];
}

//图片压缩
+(NSData*)compressImage:(UIImage*)image{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    /**
     *  128kb
     */
    int maxFileSize = 128*1024;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"======压缩后的图片大小：%d======", imageData.length);
    return imageData;
}

+(NSInteger)returnUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    UIApplication *application = [UIApplication sharedApplication];
    if(application.applicationIconBadgeNumber != unreadCount){
        [application setApplicationIconBadgeNumber:unreadCount];
    }
    return unreadCount;
}

+(void)clearMemory
{
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
}

//图片缩略图
+(void)thumbnailWithImage:(UIImage *)OriImage ImageView:(UIImageView *)imageView TargetLength:(float)length
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //        [self modifyImage:tempImage];
//        NSLog(@"********超过设定宽度！********");
//        float length = [UIScreen mainScreen].bounds.size.width;
        
        float w = OriImage.size.width;
        float h = OriImage.size.height;
        float p = 0;
        if (w>=h && OriImage.size.width>length) {
            p = length/w;
        }else if(h>w && OriImage.size.height>length){
            p = length/h;
        }
        w *= p;
        h *= p;
//        NSLog(@"%f--%f", w, h);
        
        CGRect rect = CGRectMake(0, 0, w, h);
        if (!OriImage) {
            NSLog(@"原图为空");
        }else{
            UIGraphicsBeginImageContext(rect.size);
            //重新绘图
            [OriImage drawInRect:rect];
            UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
//            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    imageView.image = image;
                }else{
                    NSLog(@"***square thumbnail image is nil***");
                    //                imageView.image = OriImage;
                }
//            });
        }
    });

}

#pragma mark -
//+(void)updatePetsData
//{
//    LOADING;
//    NSString * code = [NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
//    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
//    //    NSLog(@"%@", url);
//    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            NSMutableArray * petsDataArray = [NSMutableArray arrayWithCapacity:0];
//            
//            NSArray * array = [load.dataDict objectForKey:@"data"];
//            for (NSDictionary * dict in array) {
//                UserPetListModel * model = [[UserPetListModel alloc] init];
//                [model setValuesForKeysWithDictionary:dict];
//                [petsDataArray addObject:model];
//            }
//            
//            NSData * data = [MyControl returnDataWithArray:petsDataArray];
//            [USER setObject:data forKey:@"petsData"];
//            
//            ENDLOADING;
////            [blockSelf showPets];
//        }else{
//            LOADFAILED;
//        }
//    }];
//    [request release];
//}
@end
