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
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    button.showsTouchWhenHighlighted = YES;
    
    return button;
    

}
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName
{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.image=[UIImage imageNamed:imageName];
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

#pragma mark - 图片大小限制
+ (NSData *)scaleToSize:(UIImage *)sourceImage
{
    CGFloat compression = 1.0f;
    float maxFileSize = 90*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(sourceImage, compression);
    
    compression = maxFileSize / [imageData length];
    
    if (compression < 1) {
        imageData = UIImageJPEGRepresentation(sourceImage, compression);
    }
    
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

#pragma mark -
+(void)popAlertWithView:(UIView *)keyView Msg:(NSString *)msg
{
    PopupView * pop = [ControllerManager sharePopView];
    [pop modifyUIWithSize:keyView.frame.size msg:msg];
    [keyView addSubview:pop];
//    [pop release];
    
    [UIView animateWithDuration:0.2 animations:^{
        pop.bgView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.2 delay:2 options:0 animations:^{
            pop.bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [pop removeFromSuperview];
        }];
    }];
}
@end
