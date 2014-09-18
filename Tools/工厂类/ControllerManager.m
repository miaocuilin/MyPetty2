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
//#import "MainTabBarViewController.h"
#import "MainViewController.h"
#import <CoreText/CoreText.h>
#import "LevelRank.h"
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
MBProgressHUD *HUD;
static LevelRank *levelAndRank =nil;


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


#pragma mark - 金币、星星、红心弹窗
+ (void)HUDText:(NSString *)string showView:(UIView *)inView yOffset:(float) offset
{
    HUD = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    [inView addSubview:HUD];
    HUD.minSize = CGSizeMake(string.length * 5, 30);
    HUD.margin = 10;
    HUD.labelText = string;
    
    HUD.mode =MBProgressHUDModeText;
    [HUD show:YES];
    HUD.yOffset = offset;
    HUD.color = [UIColor colorWithRed:247/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    [HUD hide:YES afterDelay:2.0];
}

+ (void)HUDImageIcon:(NSString *)iconImageString showView:(UIView *)inView yOffset:(float)offset Number:(int)num
{
    HUD = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    [inView addSubview:HUD];
    HUD.minSize = CGSizeMake(130, 60);
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.yOffset = offset;
    HUD.margin = 0;
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 60)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 42, 42)];
    [totalView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 70, 30)];
    label.text = [NSString stringWithFormat:@"+ %d",num];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentLeft;
    [totalView addSubview:label];
    HUD.customView = totalView;
    HUD.color = [UIColor colorWithRed:247/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    UIImage *imageBG = [UIImage imageNamed:iconImageString];
    imageView.image = imageBG;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.5];
    
}
+(id)shareLevelAndRank
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        levelAndRank = [[LevelRank alloc]init];
    });
    return levelAndRank;
}
+(BOOL)levelPOP:(NSString *)exp addExp:(NSInteger)add
{
    [self shareLevelAndRank];
    NSString *level = [levelAndRank calculateLevel:exp addExp:add];
    if ([level intValue] >[[USER objectForKey:@"level"] intValue]) {
        [USER setObject:level forKey:@"level"];
        return YES;
    }
    return NO;
}
+(BOOL)rankPOP:(NSString *)contribution addContribution:(NSInteger)add planet:(NSString *)dogOrcat
{
    [self shareLevelAndRank];
    NSString *rank = [levelAndRank calculaterRank:contribution planet:dogOrcat addContribution:add];
    if ([rank intValue] > [[USER objectForKey:@"rank"] intValue]) {
        [USER setObject:@"" forKey:@"rank"];
        return YES;
    }
    return NO;
}

//+ (void)loginHUDAlertView:(UIView *)showInView
//{
//    HUD = [[MBProgressHUD alloc] initWithWindow:showInView.window];
//    [showInView.window addSubview:HUD];
//    HUD.mode = MBProgressHUDModeCustomView;
//    HUD.color = [UIColor clearColor];
//    HUD.dimBackground = YES;
//    HUD.margin = 0 ;
//    HUD.removeFromSuperViewOnHide = YES;
//    
//    
//    UIView *bodyView = [MyControl createViewWithFrame:CGRectMake(0, 0, 290, 215)];
//    bodyView.backgroundColor = [UIColor clearColor];
//    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 215)];
//    alphaView.backgroundColor = [UIColor whiteColor];
//    alphaView.alpha = 0.8;
//    [bodyView addSubview:alphaView];
//    bodyView.layer.cornerRadius = 10;
//    bodyView.layer.masksToBounds = YES;
//    //创建取消和确认button
//    
//    UIImageView *cancelImageView = [MyControl createImageViewWithFrame:CGRectMake(250, 5, 30, 30) ImageName:@"button_close.png"];
//    [bodyView addSubview:cancelImageView];
//    
//    UIButton *cancelButton = [MyControl createButtonWithFrame:CGRectMake(250, 5, 30, 30) ImageName:nil Target:self Action:@selector(cancelAction) Title:nil];
//    cancelButton.showsTouchWhenHighlighted = YES;
//    [bodyView addSubview:cancelButton];
//    
//    UILabel *sureLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2-50, 160, 100, 35) Font:16 Text:@"确认"];
//    
//    sureLabel.backgroundColor = BGCOLOR;
//    sureLabel.layer.cornerRadius = 5;
//    sureLabel.layer.masksToBounds = YES;
//    sureLabel.textAlignment = NSTextAlignmentCenter;
//    [bodyView addSubview:sureLabel];
//    
//    UIButton *sureButton = [MyControl createButtonWithFrame:sureLabel.frame ImageName:nil Target:self Action:@selector(sureAction) Title:nil];
//    sureButton.showsTouchWhenHighlighted = YES;
//    [bodyView addSubview:sureButton];
//    UILabel *askLabel1 = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 -80, 40, 160, 20) Font:16 Text:@"确定加入一个新国家？"];
//    askLabel1.textColor = [UIColor grayColor];
//    [bodyView addSubview:askLabel1];
//    UILabel *askLabel2 = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 - 80, 70, 160, 20) Font:16 Text:@"这将花费您 100"];
//    
//    
//    askLabel2.textColor = [UIColor grayColor];
//    [bodyView addSubview:askLabel2];
//    
//    UIImageView *coinImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2 +35, 63, 30, 30) ImageName:@"gold.png"];
//    [bodyView addSubview:coinImageView];
//    
//    UILabel *descLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 - 120, 130, 230, 20) Font:13 Text:@"星球提示：每个人最多加入10个圈子"];
//    descLabel.textColor = [UIColor grayColor];
//    [bodyView addSubview:descLabel];
//    HUD.customView = bodyView;
//    [HUD show:YES];
//}

+(NSString *)returnCateNameWithType:(NSString *)type
{
    NSString * str = nil;
    int a = [type intValue];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"CateNameList" ofType:@"plist"];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
//    NSLog(@"%@", dict);
    if (a/100 == 1) {
        str = [[dict objectForKey:@"1"] objectForKey:type];
    }else if(a/100 == 2){
        str = [[dict objectForKey:@"2"] objectForKey:type];
    }else if(a/100 == 3){
        str = [[dict objectForKey:@"3"] objectForKey:type];
    }else{
        str = @"苏格兰折耳猫";
    }
    return str;
}

+(NSString *)returnProvinceAndCityWithCityNum:(NSString *)cityNum
{
    NSString * province = nil;
    NSString * city = nil;
    int code = [cityNum intValue];
    int pro = code/100-10;
    int cit = code%100;
    NSString * path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
//    NSLog(@"%@", dict);
    NSDictionary * dictPro = [dict objectForKey:[NSString stringWithFormat:@"%d", pro]];
    province = [[dictPro allKeys] objectAtIndex:0];
    
    NSDictionary * dictCit = [[dictPro objectForKey:province] objectForKey:[NSString stringWithFormat:@"%d", cit]];;
    city = [[dictCit allKeys] objectAtIndex:0];
    if ([province isEqualToString:city]) {
        return province;
    }else{
        return [NSString stringWithFormat:@"%@ | %@", province, city];
    }
}

@end
