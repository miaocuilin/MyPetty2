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
#import "Keychain.h"

#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"

#import "MobClick.h"

#import "NewWaterFlowViewController.h"
#import "PetRecommendViewController.h"

//
#import "FrontImageDetailViewController.h"
//#import "DSImagesViewController.h"
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
//    NSLog(@"%@", [MyControl imageSizeFrom:[NSURL URLWithString:@"http:/pet4upload.oss-cn-beijing.aliyuncs.com/267_1414125022848.jpg"]]);
    
    NSString * const KEY_UDID = @"uuid4Pet";
    NSString * uuid = [Keychain load:KEY_UDID];
    
    NSLog(@"%@", uuid);
    if (uuid == nil || uuid.length == 0) {
        [Keychain save:KEY_UDID data:[OpenUDID value]];
    }
    
    NSLog(@"%@", [Keychain load:KEY_UDID]);
//    NSLog(@"%@", NSTemporaryDirectory());
//    [NSSearchPathForDirectoriesInDomains(NSTemporaryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
    
    [USER setObject:[Keychain load:KEY_UDID] forKey:@"UDID"];
    
    NSLog(@"UDID:%@", [USER objectForKey:@"UDID"]);
    NSLog(@"本机UUID:%@", [OpenUDID value]);

    FirstViewController * info = [[FirstViewController alloc] init];
//    FrontImageDetailViewController * info = [[FrontImageDetailViewController alloc] init];
//    NewWaterFlowViewController * info = [[NewWaterFlowViewController alloc] init];
//    PetRecommendViewController * info = [[PetRecommendViewController alloc] init];
//    DSImagesViewController * info = [[DSImagesViewController alloc] init];
    self.window.rootViewController = info;
    [info release];

    
    [UMSocialData setAppKey:@"538fddca56240b40a105fcfb"];
    //微信
    [UMSocialWechatHandler setWXAppId:@"wxc8c5912cc28194b6" appSecret:@"a5287571075736dc5760aafc1e5ff34e" url:@"http://aidigame.com"];
    //微博
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
//    [UMSocialWechatHandler setWXAppId:@"wxc8c5912cc28194b6" appSecret:@"a5287571075736dc5760aafc1e5ff34e" url:@"http://aidigame.com"];
//    [UMSocialWechatHandler setWXAppId:@"wxc8c5912cc28194b6" url:@"http://aidigame.com"];
//    [UMSocialConfig set];
//    新浪
//    阿猫阿狗
//    App Key：3262547447
//    App Secret：02dac057213bf470aed73f492b39a8aa
//    宠物星球
//    App Key：4013993168
//    App Secret：e3e8a9fde01202ea049095f79ddc904e
    
//    微信
//    AppID：wxc8c5912cc28194b6
//    AppSecret：a5287571075736dc5760aafc1e5ff34e
    
    //渠道，策略
//  channelId为nil或@""时默认AppStore
    [MobClick startWithAppkey:@"538fddca56240b40a105fcfb" reportPolicy:BATCH channelId:nil];
    //版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSLog(@"{\"oid\": \"%@\"}", deviceID);
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

//-(void)segmentClick:(UISegmentedControl *)seg
//{
//    NSLog(@"%d", seg.selectedSegmentIndex);
//    int a = seg.selectedSegmentIndex;
//    tbc.selectedIndex = a;
//    UIViewController * vc = tbc.viewControllers[a];
//    [vc.view addSubview:sc];
//}

#pragma mark -UMeng
-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService applicationDidBecomeActive];
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url];
//    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
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
//    NSLog(@"%@", [USER objectForKey:@"SID"]);
}
- (void)didReceiveMemoryWarning
{
//    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
}
@end
//820174868e10024d4eeb2933e2e355b25505ed2e
//isSuccess:0,SID:j19otbd5ojknvjdu4rodn7kgs2