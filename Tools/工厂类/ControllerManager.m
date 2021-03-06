//
//  ControllerManager.m
//  MyPetty
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ControllerManager.h"
#import "RandomViewController.h"
#import "FavoriteViewController.h"
#import "DetailViewController.h"
#import "MyPetViewController.h"
#import "MyHomeViewController.h"
#import "SquareViewController.h"
//#import "NTSlidingViewController.h"
#import "RewardViewController.h"
#define DEFAULT_VOID_COLOR [UIColor whiteColor]
#import "JDMenuViewController.h"
#import "MainTabBarViewController.h"
#import "MainViewController.h"
#import <CoreText/CoreText.h>
@implementation ControllerManager

static RandomViewController * rvc = nil;
static FavoriteViewController * fvc = nil;
static UINavigationController * nc1 = nil;
static UINavigationController * nc2 = nil;
static DetailViewController * dvc = nil;
static MyPetViewController * mvc = nil;
static UINavigationController * nc3 = nil;
static MyHomeViewController * hvc = nil;

static NSUserDefaults * user = nil;
static NSString * SID = nil;
static int isSuccess;

static JDSideMenu * sideMenu = nil;
//static NTSlidingViewController * sliding = nil;
static MainViewController * main = nil;

+(id)shareManagerRandom
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rvc = [[RandomViewController alloc]init];
        nc1 = [[UINavigationController alloc] initWithRootViewController:rvc];
    });
    return nc1;
}
+(id)shareManagerFavorite
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fvc = [[FavoriteViewController alloc]init];
        nc2 = [[UINavigationController alloc] initWithRootViewController:fvc];
    });
    return nc2;
}
+(id)shareManagerDetail
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dvc = [[DetailViewController alloc] init];
    });
    return dvc;
}
+(id)shareManagerMyPet
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mvc = [[MyPetViewController alloc] init];
        nc3 = [[UINavigationController alloc] initWithRootViewController:mvc];
    });
    return nc3;
}
+(id)shareManagerMyHome
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hvc = [[MyHomeViewController alloc] init];
    });
    return hvc;
}
+(id)shareUserDefault
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[NSUserDefaults alloc] init];
    });
    return user;
}
+(void)setIsSuccess:(int)a
{
    isSuccess = a;
}
+(int)getIsSuccess
{
    return isSuccess;
}
+(void)setSID:(NSString *)str
{
    SID = str;
}
+(id)getSID
{
    return SID;
}

+(void)startLoading:(NSString *)string
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:string];
}
+(void)loadingSuccess:(NSString *)string
{
    [MMProgressHUD dismissWithSuccess:string];
}
+(void)loadingFailed:(NSString *)string
{
    [MMProgressHUD dismissWithError:string];
}

//+(id)shareMainTabBar
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        main = [[MainTabBarViewController alloc] init];
//    });
//    return main;
//}
+(id)shareMain
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        main = [[MainViewController alloc] init];
    });
    return main;
}
+(id)shareJDSideMenu
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        NTSlidingViewController * slidingVc = [self shareSliding];
        MainViewController * main = [ControllerManager shareMain];
        JDMenuViewController * menu = [[JDMenuViewController alloc] init];

        sideMenu = [[JDSideMenu alloc]initWithContentController:main menuController:menu];
    });
    
    return sideMenu;
}
//+(id)shareSliding
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
////        sliding = [[NTSlidingViewController alloc] init];
//        RandomViewController * rvc = [[RandomViewController alloc] init];
//        FavoriteViewController * fvc = [[FavoriteViewController alloc] init];
//        SquareViewController * svc = [[SquareViewController alloc] init];
////        RewardViewController * vc = [[RewardViewController alloc] init];
////        sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:@"推荐" viewController:rvc];
////        [sliding addControllerWithTitle:@"推荐" viewController:rvc];
////        [sliding addControllerWithTitle:@"关注" viewController:fvc];
////        [sliding addControllerWithTitle:@"广场" viewController:svc];
////        [sliding addControllerWithTitle:@"奖励" viewController:vc];
//    });
////    return sliding;
//}

//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//每一行作为一个元素存到数组中返回
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}
@end
