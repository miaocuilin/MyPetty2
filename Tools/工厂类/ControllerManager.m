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
    [HUD hide:YES afterDelay:2.0];
    
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
+ (NSMutableArray *)getGift:(BOOL)isBad
{
    [self shareLevelAndRank];
    if (isBad) {
        return [levelAndRank getBadGiftDataArray:YES];
    }else{
        return [levelAndRank getBadGiftDataArray:NO];
    }
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

#pragma mark - 返回方法
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
+(NSString *)returnCateTypeWithName:(NSString *)name
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"CateNameList" ofType:@"plist"];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
//    NSLog(@"%@", dict);
//    NSMutableArray * mutableArray = [NSMutableArray arrayWithCapacity:0];
//    NSDictionary
    NSDictionary * dict1 = [dict objectForKey:@"1"];
    NSDictionary * dict2 = [dict objectForKey:@"2"];
    NSDictionary * dict3 = [dict objectForKey:@"3"];
    for (NSString * key in [dict1 allKeys]) {
//        NSLog(@"%@", dic);
        if ([[dict1 objectForKey:key] isEqualToString:name]) {
            return key;
        }
    }
    for (NSString * key in [dict2 allKeys]) {
        if ([[dict2 objectForKey:key] isEqualToString:name]) {
            return key;
        }
    }
    for (NSString * key in [dict3 allKeys]) {
        if ([[dict3 objectForKey:key] isEqualToString:name]) {
            return key;
        }
    }
    
    return nil;
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
//#pragma mark -
+(NSArray *)returnAllGiftsArray
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"shopGift" ofType:@"plist"];
    NSMutableDictionary *DictData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *level0 = [[DictData objectForKey:@"good"] objectForKey:@"level0"];
    NSArray *level1 =[[DictData objectForKey:@"good"] objectForKey:@"level1"];
    NSArray *level2 =[[DictData objectForKey:@"good"] objectForKey:@"level2"];
    NSArray *level3 =[[DictData objectForKey:@"good"] objectForKey:@"level3"];
    [array addObjectsFromArray:level0];
    [array addObjectsFromArray:level1];
    [array addObjectsFromArray:level2];
    [array addObjectsFromArray:level3];
    
    
    NSArray *level4 =[[DictData objectForKey:@"bad"] objectForKey:@"level0"];
    NSArray *level5 =[[DictData objectForKey:@"bad"] objectForKey:@"level1"];
    NSArray *level6 =[[DictData objectForKey:@"bad"] objectForKey:@"level2"];
    [array addObjectsFromArray:level4];
    [array addObjectsFromArray:level5];
    [array addObjectsFromArray:level6];
    return array;
}
+(NSDictionary *)returnGiftDictWithItemId:(NSString *)itemId
{
    NSArray * array = [self returnAllGiftsArray];
    
    NSDictionary * dict = nil;
    for (int i=0; i<array.count; i++) {
        if ([[array[i] objectForKey:@"no"] isEqualToString:itemId]) {
            dict = array[i];
            break;
        }
    }
    return dict;
}

+(NSString *)returnPositionWithRank:(NSString *)rank
{
    NSString * position = nil;
//    [[USER objectForKey:@"petInfoDict"] isKindOfClass:[NSDictionary class]] && [[[USER objectForKey:@"petInfoDict"] objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]
    if ([rank intValue] == -1) {
        //陌生人
        position = @"路人";
    }else if ([rank intValue] == 0) {
        //主人
        position = @"经纪人";
    }else if([rank intValue] == 1){
        position = @"凉粉";
    }else if([rank intValue] == 2){
        position = @"淡粉";
    }else if([rank intValue] == 3){
        position = @"狠粉";
    }else if([rank intValue] == 4){
        position = @"灰常粉";
    }else if([rank intValue] == 5){
        position = @"超级粉";
    }else if([rank intValue] == 6){
        position = @"铁杆粉";
    }else if([rank intValue] == 7){
        position = @"脑残粉";
    }else if([rank intValue] == 8){
        position = @"骨灰粉";
    }
//    NSString * totalPosition = [NSString stringWithFormat:@"%@联萌%@", [[USER objectForKey:@"petInfoDict"] objectForKey:@"name"], position];
    
    return position;
}

+(NSString *)returnActionStringWithItemId:(NSString *)item_id
{
    int a = [item_id intValue];
    NSString * actionStr = nil;
    switch (a) {
        case 1101:
            actionStr = @"惊喜地伸出小爪子拨弄毛线球";
            break;
        case 1102:
            actionStr = @"纵身一跃，在空中叼住了飞盘，bingo!";
            break;
        case 1103:
            actionStr = @"好奇的拨弄铃铛，叮铃~叮铃~";
            break;
        case 1104:
            actionStr = @"乖巧地戴上了蝴蝶结，神气地走了两步";
            break;
        case 1105:
            actionStr = @"顿时眼前一亮，挥舞着爪子扑了上去";
            break;
        case 1106:
            actionStr = @"立刻精神抖擞地去追棒球了";
            break;
        case 1107:
            actionStr = @"一脸幸福地舔了舔糖果";
            break;
        case 1201:
            actionStr = @"闻了闻猫饼干，满意地喵喵叫~";
            break;
        case 1202:
            actionStr = @"闻闻肉包子，狼吞虎咽地吃了起来";
            break;
        case 1203:
            actionStr = @"悠哉地嚼着宠物小馒头";
            break;
        case 1204:
            actionStr = @"一口咬住了磨牙棒，谁要也不给！";
            break;
        case 1205:
            actionStr = @"发现了新牵引绳，迫不及待地要出门逛逛";
            break;
        case 1206:
            actionStr = @"疑惑地歪头看，咦，为什么是空的？";
            break;
        case 1207:
            actionStr = @"瞪大了圆滴滴眼睛，好奇地伸爪拨弄";
            break;
        case 1301:
            actionStr = @"戴上了新围巾，兴奋异常地到处炫耀";
            break;
        case 1302:
            actionStr = @"戴上新帽子活泼地冲你撒了个娇";
            break;
        case 1303:
            actionStr = @"洗完澡浑身香喷喷的";
            break;
        case 1304:
            actionStr = @"的毛皮更顺滑了，又干净又漂亮~";
            break;
        case 1305:
            actionStr = @"穿上新衣服，调皮地在地上打了个滚";
            break;
        case 1401:
            actionStr = @"懒洋洋地吹着风，还打了个小哈欠";
            break;
        case 1402:
            actionStr = @"惊奇地看着新窝，满意地钻进去睡觉了";
            break;
        case 1403:
            actionStr = @"嗅了嗅新窝，放心地扯着呼噜睡觉~";
            break;
        case 2101:
            actionStr = @"被熏得晕头转向……";
            break;
        case 2102:
            actionStr = @"被砸个正着，异常愤怒的叫了起来";
            break;
        case 2103:
            actionStr = @"被溅了一身的水，成了湿漉漉的可怜虫";
            break;
        case 2104:
            actionStr = @"警觉地瞅了一眼毛毛虫，嫌恶地跑开了";
            break;
        case 2201:
            actionStr = @"惊慌的看着鸡毛掸子，畏惧地缩了缩脑袋";
            break;
        case 2202:
            actionStr = @"被吓了一跳，惊慌地躲进沙发下面了";
            break;
        case 2203:
            actionStr = @"没有注意到便便，竟然一脚踩了上去！";
            break;
        case 2301:
            actionStr = @"竟一头撞上了仙人球，好痛痛……";
            break;
        case 2302:
            actionStr = @"惊慌失措地尖叫，主人快来保护我！！！";
            break;
        default:
            break;
    }
    return actionStr;
}

+(int)returnContributionOfNeedWithContribution:(NSString *)con
{
    int contribution = 0;
    int a = [con intValue];
    NSArray * array = @[@"0", @"480", @"1140", @"2064", @"3252" ,@"4704", @"6420", @"8400"];
    for (int i=0; i<array.count; i++) {
        if (a<[array[i] intValue]) {
            contribution = [array[i] intValue];
            break;
        }
    }
    return contribution;
}
+(int)returnExpOfNeedWithLv:(NSString *)lv
{
    int a = [lv intValue]+1;
    //a为要升到的级别
    int needExp = 110*(a-1)+5*(a+2)*(a-1)/2;
    return needExp;
}
@end
