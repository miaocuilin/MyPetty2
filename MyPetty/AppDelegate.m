//
//  AppDelegate.m
//  MyPetty
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "OpenUDID.h"

#import "MyMD5.h"
#import "DetailViewController.h"
#import "MyPetViewController.h"
#import "SettingViewController.h"
#import "OtherHomeViewController.h"
#import "RegisterViewController.h"
#import "PublishViewController.h"
#import "ShakeViewController.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
//#import "JDMenuViewController.h"
#import "JDSideMenu.h"

#import "ChoseLoadViewController.h"
#import "ChooseFamilyViewController.h"
#import "JDMenuViewController.h"
#import "PetInfoViewController.h"
#import "BottomMenuBaseViewController.h"
#import "BottomMenuRootViewController.h"
#import "SettingViewController.h"
#import "RandomViewController.h"
#import "FavoriteViewController.h"
#import "SquareViewController.h"
#import "ChooseFamilyViewController.h"
#import "PicDetailViewController.h"

#import "FeedbackViewController.h"
#import "ToolTipsViewController.h"
#import "UserInfoViewController.h"
#import "AtUsersViewController.h"
#import "TopicViewController.h"
#import "GiftShopViewController.h"
#import "PopularityListViewController.h"
#import "ContributionViewController.h"
#import "CallViewController.h"
#import "AboutViewController.h"
#import "WaterViewController.h"
#import "UserBagViewController.h"

@implementation AppDelegate
-(void)dealloc
{
    [_window release];
    [super dealloc];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    NSLog(@"本机UUID:%@", [OpenUDID value]);
    
//    RandomViewController * rvc = [[RandomViewController alloc] init];
//    FavoriteViewController * fvc = [[FavoriteViewController alloc] init];
//    SquareViewController * svc = [[SquareViewController alloc] init];
//    tbc = [[UITabBarController alloc] init];
//    tbc.viewControllers = @[svc, rvc, fvc];
//    tbc.selectedIndex = 1;
//    tbc.tabBar.hidden = YES;
    
//    scBgView = [MyControl createViewWithFrame:CGRectMake(10, 69, 300, 30)];
//    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, 300, 30)];
//    view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
//    view.layer.cornerRadius = 3;
//    view.layer.masksToBounds = YES;
//    [scBgView addSubview:view];
    
//    NSArray * scArray = @[@"萌宠推荐", @"宇宙广场", @"星球关注"];
//    sc = [[UISegmentedControl alloc] initWithItems:scArray];
//    sc.backgroundColor = [UIColor whiteColor];
//    sc.alpha = 0.7;
//    sc.layer.cornerRadius = 4;
//    sc.layer.masksToBounds = YES;
//    sc.frame = CGRectMake(10, 69, 300, 30);
//    [sc addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
//    //默认选中第二个，宇宙广场
//    sc.selectedSegmentIndex = 1;
//    sc.tintColor = BGCOLOR;
////    [scBgView addSubview:sc];
//    
//    [rvc.view addSubview:sc];
//    self.window.rootViewController = tbc;
    
//    NSLog(@"%@", result);
//    MyHomeViewController * fvc = [[MyHomeViewController alloc] init];
//    OtherHomeViewController * fvc = [[OtherHomeViewController alloc] init];
//    SettingViewController * fvc = [[SettingViewController alloc] init];
//    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:fvc];
//    MyPetViewController * fvc = [[MyPetViewController alloc] init];
//    DetailViewController * fvc = [[DetailViewController alloc] init];
//    PublishViewController * info = [[PublishViewController alloc] init];
//    AtUsersViewController * info = [[AtUsersViewController alloc] init];
//    TopicViewController * info = [[TopicViewController alloc] init];
//    ShakeViewController * fvc = [[ShakeViewController alloc] init];
//    PublishViewController * fvc = [[PublishViewController alloc] init];
//    ShakeViewController * fvc = [[ShakeViewController alloc] init];
//    RecordViewController * fvc = [[RecordViewController alloc] init];
//    ChoseLoadViewController * fvc = [[ChoseLoadViewController alloc] init];
//    JDMenuViewController * info = [[JDMenuViewController alloc] init];
//    JDMenuViewController * fvc = [[JDMenuViewController alloc] init];
    FirstViewController * info = [[FirstViewController alloc] init];
//    AboutViewController * info = [[AboutViewController alloc] init];
//    PopularityListViewController * info = [[PopularityListViewController alloc] init];
//    ContributionViewController * info = [[ContributionViewController alloc] init];
//    MyInfoViewController * info = [[MyInfoViewController alloc] init];
//    PetInfoViewController * info = [[PetInfoViewController alloc] init];
//    BottomMenuBaseViewController * info = [[BottomMenuBaseViewController alloc] init];
//    BottomMenuRootViewController * info = [[BottomMenuRootViewController alloc] init];
    
    //跳到主页
//    JDSideMenu * sideMenu = [ControllerManager shareJDSideMenu];
//    [sideMenu setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"30-3" ofType:@"png"]]];
//    [self presentViewController:sideMenu animated:YES completion:nil];
//    [ControllerManager setIsSuccess:1];
//    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:info];
//    ChooseFamilyViewController * info = [[ChooseFamilyViewController alloc] init];
//    self.window.rootViewController = sideMenu;
//    ToolTipsViewController *toolTips =[[ToolTipsViewController alloc] init];
//    UserInfoViewController * info = [[UserInfoViewController alloc] init];
//    ShoutViewController *shout = [[ShoutViewController alloc] init];
//    GiftShopViewController * info = [[GiftShopViewController alloc] init];
//    RecordViewController * info = [[RecordViewController alloc] init];
//    CallViewController *call = [[CallViewController alloc] init];
//    WaterFlowLayout *layout = [[WaterFlowLayout alloc]init];
//    UserBagViewController *userBag = [[UserBagViewController alloc] init];
    self.window.rootViewController = info;
//    [menu release];
//    [fvc release];
//    [sideMenu release];
//    [info release];
//    [nc release];
    
//    RegisterViewController * vc = [[RegisterViewController alloc] init];
//    ChooseFamilyViewController * vc = [[ChooseFamilyViewController alloc] init];
//    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
//    SettingViewController * vc = [[SettingViewController alloc] init];
//    PicDetailViewController * vc = [[PicDetailViewController alloc] init];
//    self.window.rootViewController = vc;
//    [vc release];
//    [nc release];
    
    [UMSocialData setAppKey:@"538fddca56240b40a105fcfb"];
    [UMSocialConfig setSupportSinaSSO:YES appRedirectUrl:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialWechatHandler setWXAppId:@"wxef59ead737c3c450" url:@"http://aidigame.com"];
//    新浪
//    App Key：3262547447
//    App Secret：02dac057213bf470aed73f492b39a8aa
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)segmentClick:(UISegmentedControl *)seg
{
    NSLog(@"%d", seg.selectedSegmentIndex);
    int a = seg.selectedSegmentIndex;
    tbc.selectedIndex = a;
    UIViewController * vc = tbc.viewControllers[a];
    [vc.view addSubview:sc];
}

#pragma mark -UMeng
-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService applicationDidBecomeActive];
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application
{
//    [USER removeAllObjects];
//    [USER setObject:@"0" forKey:@"isSuccess"];
    NSLog(@"%@", [USER objectForKey:@"SID"]);
}

@end
//820174868e10024d4eeb2933e2e355b25505ed2e
//isSuccess:0,SID:j19otbd5ojknvjdu4rodn7kgs2