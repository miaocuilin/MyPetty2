
//
//  FirstViewController.m
//  MyPetty
//
//  Created by Aidi on 14-5-30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "FirstViewController.h"
#import "ControllerManager.h"
#import "ASIFormDataRequest.h"
#import <ImageIO/ImageIO.h>
#import "EaseMob.h"
#import "MenuModel.h"
//#import "FoodFirstViewController.h"
//#import "MainTabBarViewController.h"

@interface FirstViewController () <UIAlertViewDelegate>
{
  ASIFormDataRequest * _request;
}
@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self downloadLaunchImageInfo];
    
    tempImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@""];
    if (self.view.frame.size.height == 240) {
        tempImageView.image = [UIImage imageNamed:@"Default.png"];
    }else if(self.view.frame.size.height == 480){
        tempImageView.image = [UIImage imageNamed:@"Default@2x.png"];
    }else{
        tempImageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    }
    [self.view addSubview:tempImageView];
    
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    tempImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@""];
//    if (self.view.frame.size.height == 240) {
//        tempImageView.image = [UIImage imageNamed:@"Default.png"];
//    }else if(self.view.frame.size.height == 480){
//        tempImageView.image = [UIImage imageNamed:@"Default@2x.png"];
//    }else{
//        tempImageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
//    }
//    [self.view addSubview:tempImageView];
//
//}
-(void)downloadLaunchImageInfo
{
    if (![USER objectForKey:@"SID"]) {
        [self tempLogin];
        return;
    }
    
//    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:WELCOMEAPI Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            NSLog(@"%@", load.dataDict);
//        }
//    }];
//    [request release];
    isLoadImage = YES;
    
    NSString * url = [NSString stringWithFormat:@"%@%@", WELCOMEAPI, [USER objectForKey:@"SID"]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        NSLog(@"%@", load.dataDict);
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            self.launchImageName = [[load.dataDict objectForKey:@"data"] objectForKey:@"url"];
            
            self.animalNum = [[load.dataDict objectForKey:@"data"] objectForKey:@"animal"];
            self.foodNum = [[load.dataDict objectForKey:@"data"] objectForKey:@"food"];
//            NSString * docDir = DOCDIR;
//            NSString * FilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.launchImageName]];
//            UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:FilePath]];
//            if (image) {
//                self.launchImage = image;
//                hadImage = YES;
////                [self login];
//                [self createUI];
//            }else{
//                hadImage = NO;
//                [self login];
                //下载图片
                NSString * url2 = [NSString stringWithFormat:@"%@%@", WELCOMEAPI2, self.launchImageName];
            
//            CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL URLWithString:url2], NULL);
//            NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     [NSNumber numberWithBool:NO], (NSString *)kCGImageSourceShouldCache,
//                                     nil];
//            CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (__bridge CFDictionaryRef)options);
//            NSLog(@"%@",imageProperties);
//            NSDictionary * imageInfoDict = (NSDictionary *)imageProperties;
//            NSDictionary * dict = [MyControl imageSizeFrom:[NSURL URLWithString:url2]];
//            NSLog(@"%@", dict);
            NSLog(@"开始下载欢迎图片");

                httpDownloadBlock * request2 = [[httpDownloadBlock alloc] initWithUrlStr:url2 Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    
                    [UIApplication sharedApplication].statusBarHidden = YES;
                    if (isFinish) {
                        [tempImageView removeFromSuperview];
                        
                        self.launchImage = load.dataImage;
//                        NSData * data = UIImageJPEGRepresentation(load.dataImage, 0.1);
//                        BOOL a = [data writeToFile:FilePath atomically:YES];
//                        NSLog(@"存储欢迎图片结果：%d", a);
                        hadImage = YES;
                        [self createUI];
                    }else{
                        hadImage = NO;
                        [self createUI];
                        
//                        PopupView * pop = [[PopupView alloc] init];
//                        [pop modifyUIWithSize:self.view.frame.size msg:@"网络连接异常"];
//                        [self.view addSubview:pop];
//                        [pop release];
//                        
//                        [UIView animateWithDuration:0.2 animations:^{
//                            pop.bgView.alpha = 1;
//                        } completion:^(BOOL finished) {
//                            [UIView animateKeyframesWithDuration:0.2 delay:2 options:0 animations:^{
//                                pop.bgView.alpha = 0;
//                            } completion:^(BOOL finished) {
//                                [pop removeFromSuperview];
//                            }];
//                        }];
                        //            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"网络连接异常"];
//                        [self jumpToMain];
                    }
                }];
//            request2.overDue = ^(){
//                httpDownloadBlock * request3 = [[httpDownloadBlock alloc] initWithUrlStr:url2 Block:^(BOOL isFinish, httpDownloadBlock * load) {
//                    
//                    [UIApplication sharedApplication].statusBarHidden = YES;
//                    if (isFinish) {
//                        [tempImageView removeFromSuperview];
//                        
//                        self.launchImage = load.dataImage;
//                        //                        NSData * data = UIImageJPEGRepresentation(load.dataImage, 0.1);
//                        //                        BOOL a = [data writeToFile:FilePath atomically:YES];
//                        //                        NSLog(@"存储欢迎图片结果：%d", a);
//                        hadImage = YES;
//                        [self createUI];
//                    }else{
//                        hadImage = NO;
//                        [self createUI];
//                    }
//                }];
//                [request3 release];
//            };
                [request2 release];
//            }
            
        }else{
            [UIApplication sharedApplication].statusBarHidden = NO;
//            PopupView * pop = [[PopupView alloc] init];
//            [pop modifyUIWithSize:self.view.frame.size msg:@"网络连接异常"];
//            [self.view addSubview:pop];
//            [pop release];
//            
//            [UIView animateWithDuration:0.2 animations:^{
//                pop.bgView.alpha = 1;
//            } completion:^(BOOL finished) {
//                [UIView animateKeyframesWithDuration:0.2 delay:2 options:0 animations:^{
//                    pop.bgView.alpha = 0;
//                } completion:^(BOOL finished) {
//                    [pop removeFromSuperview];
//                }];
//            }];
//            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"网络连接异常"];
            [self jumpToChoose];
//            [self jumpToMain];
        }
    }];
    [request release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    [USER setObject:@"1" forKey:@"planet"];
    [USER setObject:@"" forKey:@"petInfoDict"];
//    NSLog(@"%f", self.view.frame.size.height);
    //全局变量，存储在本地，用于判断各种条件，以做出相应操作
    [USER setObject:@"0" forKey:@"MyHomeTimes"];
    /*关注是否有变化*/
    [USER setObject:@"0" forKey:@"AttentionOrFansChanged"];
    //设置favorite是否进入过
    [USER setObject:@"0" forKey:@"isFavoriteLoaded"];
    //isFromActivity归零
    [USER setObject:@"0" forKey:@"isFromActivity"];
    //favorite页是否需要刷新归零
    [USER setObject:@"0" forKey:@"favoriteRefresh"];
    //likersList页根据此判断来自哪，该dismiss还是pop
    [USER setObject:@"0" forKey:@"isFromAvtivity"];
    
    //看是否需要dismiss
    [USER setObject:@"0" forKey:@"isChooseInShouldDismiss"];
    
    [USER setObject:@"" forKey:@"weChatUserInfo"];
    [USER setObject:@"" forKey:@"sinaUserInfo"];
    [USER setObject:@"" forKey:@"password"];
    
//    [USER setObject:@"0" forKey:@"shouldLogin"];
    //从本地读取种类数据，然后
//    NSString * path = [DOCDIR stringByAppendingPathComponent:@"CateNameList.plist"];
//    NSLog(@"CateNameList= %@",path);
//    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//    if (data) {
//        [USER setObject:data forKey:@"CateNameList"];
//        NSLog(@"读取CateNameList.plist文件成功！！");
//    }else{
//        NSLog(@"读取失败，本地没有CateNameList.plist文件");
//    }

}

-(void)createUI
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:bgImageView];
    
    if (hadImage) {
        float width = self.launchImage.size.width;
        float height = self.launchImage.size.height;
        if (width>320) {
            float w = 320/width;
            width *= w;
            height *= w;
        }
        if (height>568) {
            float h = 568/height;
            width *= h;
            height *= h;
        }
        bgImageView.image = self.launchImage;
//        bgImageView.frame = CGRectMake(0, 0, width*0.9, height*0.9);
        bgImageView.center = self.view.center;
        [self setAnimation:bgImageView];
//        [self performSelector:@selector(jumpToChoose) withObject:nil afterDelay:2];
    }else{
        [self jumpToChoose];
//        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, self.launchImageName] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//            if (isFinish) {
//                bgImageView.image = load.dataImage;
//                float width = load.dataImage.size.width;
//                float height = load.dataImage.size.height;
//                if (width>320) {
//                    float w = 320/width;
//                    width *= w;
//                    height *= w;
//                }
//                if (height>568) {
//                    float h = 568/height;
//                    width *= h;
//                    height *= h;
//                }
//                bgImageView.frame = CGRectMake(0, 0, width*0.9, height*0.9);
//                bgImageView.center = self.view.center;
//                NSString * docDir = DOCDIR;
//                NSString * FilePath = [docDir stringByAppendingPathComponent:self.launchImageName];
//                [load.data writeToFile:FilePath atomically:YES];
//                [self setAnimation:bgImageView];
////                [self performSelector:@selector(jumpToChoose) withObject:nil afterDelay:2];
//            }else{
//                [self setAnimation:bgImageView];
////                [self performSelector:@selector(jumpToChoose) withObject:nil afterDelay:2];
//                UIAlertView * alert = [MyControl createAlertViewWithTitle:@"网络连接异常"];
//                [self jumpToChoose];
//            }
////            [self performSelector:@selector(jumpToRandom) withObject:nil afterDelay:2];
//        }];
    }
    
//    for(int i=0;i<3;i++){
//        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(40+i*(45+50), self.view.frame.size.height-260/2, 50, 50) ImageName:@"" Target:self Action:@selector(buttonClick:) Title:nil];
//        [bgImageView addSubview:button];
//        button.tag = 100+i;
//        button.layer.cornerRadius = 25;
//        button.layer.masksToBounds = YES;
//        button.showsTouchWhenHighlighted = YES;
//    }
}
//#pragma mark -登录
//-(void)login
//{
//    NSLog(@"loginAPI:%@", LOGINAPI);
//    [[httpDownloadBlock alloc] initWithUrlStr:LOGINAPI Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if(isFinish){
//            NSLog(@"%@", load.dataDict);
//            if ([[load.dataDict objectForKey:@"errorCode"] intValue]) {
//                UIAlertView * alert = [MyControl createAlertViewWithTitle:@"错误" Message:[load.dataDict objectForKey:@"errorMessage"] delegate:nil cancelTitle:nil otherTitles:@"确定"];
//                return;
//            }
//            NSLog(@"%@", load.dataDict);
//            [ControllerManager setIsSuccess:[[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]];
//            [ControllerManager setSID:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"]];
//            
//            //如果没有启动图片，搭建界面，下载图片
//            if (!hadImage) {
//                [self createUI];
//            }
//            
//            NSLog(@"isSuccess:%d,SID:%@", [ControllerManager getIsSuccess], [ControllerManager getSID]);
//            if ([ControllerManager getIsSuccess]) {
//                [self getUserData];
//            }
//            //设为1
//            isLogined = 1;
//            if (isAnimation) {
//                [self jumpToRandom];
//            }
////            [self performSelector:@selector(jumpToRandom) withObject:nil afterDelay:2];
//        }else{
//            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"数据请求失败，是否重新请求？" Message:nil delegate:self cancelTitle:@"取消" otherTitles:@"确定"];
//        }
//    }];
//}
//#pragma mark -alert代理
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex) {
//        [self login];
//    }
//}

-(void)jumpToChoose
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
//    if ([[USER objectForKey:@"planet"] intValue]){
        [self tempLogin];
//    }else{
//        ChoseLoadViewController * vc = [[ChoseLoadViewController alloc] init];
//        [self presentViewController:vc animated:NO completion:nil];
//    }
    
//    vc.modalTransitionStyle = 2;
//    [self presentViewController:vc animated:NO completion:nil];
//    [vc release];
    
//    UINavigationController * nc = [ControllerManager shareManagerRandom];
//    JDSideMenu * sideMenu = [ControllerManager shareJDSideMenu];
////    [sideMenu setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"30-3" ofType:@"png"]]];
//    vc.modalTransitionStyle = 2;
}
-(void)tempLogin
{
    //一进来先看本地有没有SID，本地有直接请求，过期再请求login
    //如果本地没有就去网上去SID，如果网上没有--》login，如果有直接用
    //用着如果过期再去请求SID。
    if ([USER objectForKey:@"SID"] != nil && [[USER objectForKey:@"SID"] length] != 0) {
        NSLog(@"%@", [USER objectForKey:@"SID"]);
        if ([[USER objectForKey:@"isSuccess"] intValue]
            ) {
            [ControllerManager setIsSuccess:[[USER objectForKey:@"isSuccess"] intValue]];
            [ControllerManager setSID:[USER objectForKey:@"SID"]];
            [self getUserData];
        }else{
            [self login];
        }
    }else{
        [self getPreSID];
        //        return;
    }
    NSLog(@"%@--%@", [USER objectForKey:@"isSuccess"], [USER objectForKey:@"SID"]);
}
-(void)getPreSID
{
    reloadType = 3;
    
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"uid=%@dog&cat", UDID]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@", GETPRESID, UDID, sig];
    NSLog(@"%@", url);
    if (shouldLoading) {
        LOADING;
    }
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (shouldLoading) {
            ENDLOADING;
            shouldLoading = NO;
        }
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if (![[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                //网上也米有SID--》login
                [self login];
            }else{
                [USER setObject:[load.dataDict objectForKey:@"confVersion"] forKey:@"confVersion"];
                if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"usr_id"] intValue]
                    ) {
                    [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"usr_id"] forKey:@"usr_id"];
                    [USER setObject:@"1" forKey:@"isSuccess"];
                    [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"sid"] forKey:@"SID"];
                    [ControllerManager setIsSuccess:[[USER objectForKey:@"isSuccess"] intValue]];
                    [ControllerManager setSID:[USER objectForKey:@"SID"]];
                    
                    [self downloadLaunchImageInfo];
//                    [self getUserData];
                }else{
                    [self login];
                }
            }
        }else{
            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"网络异常，请重试" Message:nil delegate:self cancelTitle:nil otherTitles:@"确定"];
            alert.delegate = self;
        }
    }];
    [request release];
}
#pragma mark -登录
-(void)login
{
    reloadType = 2;
    [USER setObject:@"1" forKey:@"notAlertError"];
    if (isLoadImage) {
//        StartLoading;
    }
    
//    NSString * code = [NSString stringWithFormat:@"planet=%@&uid=%@dog&cat", [USER objectForKey:@"planet"], [OpenUDID value]];
    NSString * code = [NSString stringWithFormat:@"uid=%@dog&cat", UDID];
    NSString * url = [NSString stringWithFormat:@"%@&uid=%@&sig=%@", LOGINAPI, UDID, [MyMD5 md5:code]];
    NSLog(@"login-url:%@", url);
    if (shouldLoading) {
        LOADING;
    }
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (shouldLoading) {
            ENDLOADING;
            shouldLoading = NO;
        }
        if(isFinish){
            NSLog(@"%@", load.dataDict);
            [USER setObject:[load.dataDict objectForKey:@"confVersion"] forKey:@"confVersion"];
            
            if ([[load.dataDict objectForKey:@"errorCode"] intValue]) {
                UIAlertView * alert = [MyControl createAlertViewWithTitle:@"错误" Message:[load.dataDict objectForKey:@"errorMessage"] delegate:nil cancelTitle:nil otherTitles:@"确定"];
                return;
            }
            [ControllerManager setIsSuccess:[[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]];
            [ControllerManager setSID:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"]];
            [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] forKey:@"isSuccess"];
            [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"] forKey:@"SID"];
            if (![[[load.dataDict objectForKey:@"data"] objectForKey:@"usr_id"] isKindOfClass:[NSNull class]]) {
                [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"usr_id"] forKey:@"usr_id"];
            }
            
            NSLog(@"isSuccess:%d,SID:%@", [ControllerManager getIsSuccess], [ControllerManager getSID]);
            if (isLoadImage == NO) {
                [self downloadLaunchImageInfo];
                return;
            }
            if ([ControllerManager getIsSuccess]) {
                [self getUserData];
                
            }else{
//                LoadingSuccess;
                //跳转到主页
                [self jumpToMain];
            }
        }else{
            LoadingFailed;
            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"网络异常，请重试" Message:nil delegate:self cancelTitle:nil otherTitles:@"确定"];
            alert.delegate = self;
        }
    }];
    [request release];
}
#pragma mark -获取用户数据
-(void)getUserData
{
    reloadType = 1;
    if ([USER objectForKey:@"usr_id"] == nil || [[USER objectForKey:@"usr_id"] length] == 0) {
        [self login];
        return;
    }
//    [MyControl startLoadingWithStatus:@"登陆中..."];
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERINFOAPI, [USER objectForKey:@"usr_id"], sig,[ControllerManager getSID]];
    NSLog(@"%@", url);
    if (shouldLoading) {
        LOADING;
    }
    
    __block FirstViewController * blockSelf = self;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (shouldLoading) {
            ENDLOADING;
            shouldLoading = NO;
        }
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"state"] intValue] == 2) {
                //SID过期,需要重新登录获取SID
                [self login];
                //                [self getUserData];
                return;
            }else{
                [USER setObject:[load.dataDict objectForKey:@"confVersion"] forKey:@"confVersion"];
                //SID未过期，直接获取用户数据
                NSLog(@"用户数据：%@", load.dataDict);
                NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                
                //判断环信有没有自动登录
                BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
                if (!isAutoLogin) {
                    //登录环信
                    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[USER objectForKey:@"usr_id"] password:[dict objectForKey:@"code"] completion:^(NSDictionary *loginInfo, EMError *error) {
                        if (!error) {
                            NSLog(@"登录成功");
                            
                            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                            //                        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
                            //                        NSLog(@"%@", options.nickname);
                            
                            EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
                            if(![options.nickname isEqualToString:[dict objectForKey:@"name"]]){
                                NSLog(@"更新昵称");
                                [[EaseMob sharedInstance].chatManager setApnsNickname:[dict objectForKey:@"name"]];
                            }
                            
                            if (![[USER objectForKey:@"setMsgDetail"] intValue]) {
                                EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
                                if(options.displayStyle != ePushNotificationDisplayStyle_messageSummary){
                                    options.displayStyle = ePushNotificationDisplayStyle_messageSummary;
                                    [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options completion:^(EMPushNotificationOptions *options, EMError *error) {
                                        if (error) {
                                            NSLog(@"%@", error);
                                        }else{
                                            NSLog(@"消息推送类型更新成功");
                                            [USER setObject:@"1" forKey:@"setMsgDetail"];
                                        }
                                    } onQueue:nil];
                                }
                            }
                            
                        }else{
                            NSLog(@"%@", error);
                        }
                    } onQueue:nil];
                }
                
                [USER setObject:[dict objectForKey:@"a_name"] forKey:@"a_name"];
                if (![[dict objectForKey:@"a_tx"] isKindOfClass:[NSNull class]]) {
                    [USER setObject:[dict objectForKey:@"a_tx"] forKey:@"a_tx"];
                }
                [USER setObject:[dict objectForKey:@"inviter"] forKey:@"inviter"];
                [USER setObject:[dict objectForKey:@"age"] forKey:@"age"];
                [USER setObject:[dict objectForKey:@"gender"] forKey:@"gender"];
                [USER setObject:[dict objectForKey:@"name"] forKey:@"name"];
                [USER setObject:[dict objectForKey:@"city"] forKey:@"city"];
                [USER setObject:[dict objectForKey:@"exp"] forKey:@"oldexp"];
                [USER setObject:[dict objectForKey:@"exp"] forKey:@"exp"];
                [USER setObject:[dict objectForKey:@"lv"] forKey:@"lv"];
                
                [USER setObject:[USER objectForKey:@"gold"] forKey:@"oldgold"];
                [USER setObject:[dict objectForKey:@"gold"] forKey:@"gold"];
                [USER setObject:[NSString stringWithFormat:@"%@", [dict objectForKey:@"food"]] forKey:@"food"];
                [USER setObject:[dict objectForKey:@"usr_id"] forKey:@"usr_id"];
                [USER setObject:[dict objectForKey:@"aid"] forKey:@"aid"];
                [USER setObject:[dict objectForKey:@"con_login"] forKey:@"con_login"];
                [USER setObject:[dict objectForKey:@"next_gold"] forKey:@"next_gold"];
                [USER setObject:[dict objectForKey:@"weibo"] forKey:@"weibo"];
//                NSLog(@"%@", [USER objectForKey:@"weibo"]);
                [USER setObject:[dict objectForKey:@"wechat"] forKey:@"wechat"];
                [USER setObject:[dict objectForKey:@"password"] forKey:@"password"];
                [USER setObject:[dict objectForKey:@"code"] forKey:@"code"];
                
                if (!([[dict objectForKey:@"rank"] isKindOfClass:[NSNull class]] || ![[dict objectForKey:@"rank"] length])) {
                    [USER setObject:[dict objectForKey:@"rank"] forKey:@"rank"];
                }else{
                    [USER setObject:@"1" forKey:@"rank"];
                }
                
                
                if (![[dict objectForKey:@"tx"] isKindOfClass:[NSNull class]]) {
                    [USER setObject:[dict objectForKey:@"tx"] forKey:@"tx"];
                }
                
                
                //获取宠物信息，存储到本地
                [blockSelf loadPetInfo];
                //获取本人所有宠物信息
//                [self loadPetList];
                LOADPETLIST;
                [blockSelf loadMenuData];
            }
        }else{
            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"网络异常，请重试" Message:nil delegate:self cancelTitle:nil otherTitles:@"确定"];
            alert.delegate = self;
        }
    }];
    [request release];
}

-(void)loadPetInfo
{
    reloadType = 4;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", [USER objectForKey:@"aid"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETINFOAPI, [USER objectForKey:@"aid"], sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    if (shouldLoading) {
        LOADING;
    }
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (shouldLoading) {
            ENDLOADING;
            shouldLoading = NO;
        }
        if (isFinish) {
            NSLog(@"petInfo:%@", load.dataDict);
            if(![[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                [self jumpToMain];
                return;
            }
            
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                //记录默认宠物信息
//                [[load.dataDict objectForKey:@"data"] setObject:@"0" forKey:@"gifts"];
                [USER setObject:[load.dataDict objectForKey:@"data"] forKey:@"petInfoDict"];
            }
            
            [self jumpToMain];
        }else{
            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"网络异常，请重试" Message:nil delegate:self cancelTitle:nil otherTitles:@"确定"];
            alert.delegate = self;
        }
    }];
    [request release];
}

-(void)loadMenuData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", MENUAPI, [ControllerManager getSID]];
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSArray * array = [load.dataDict objectForKey:@"data"];
            if ([array isKindOfClass:[NSArray class]]) {
                if ([array[0] isKindOfClass:[NSArray class]]) {
                    NSArray * arr = array[0];
                    if (arr.count == 0) {
                        return;
                    }
                    NSMutableArray * mutableArray = [NSMutableArray arrayWithCapacity:0];
                    for (NSDictionary * dict in arr) {
                        MenuModel * model = [[MenuModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [mutableArray addObject:model];
                        [model release];
                    }
                    NSData * data = [MyControl returnDataWithArray:mutableArray];
                    [USER setObject:data forKey:@"MenuData"];
                }
            }
        }else{
            [USER setObject:@"" forKey:@"MenuData"];
        }
    }];
    [request release];
}

//
//-(void)loadPetList
//{
//    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]]];
//    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], sig, [ControllerManager getSID]];
//    NSLog(@"%@", url);
//    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
////            NSLog(@"%@", load.dataDict);
//            //获取用户所有宠物，将信息存到本地
//            NSArray * array = [load.dataDict objectForKey:@"data"];
//            if([array isKindOfClass:[NSArray class]] && array.count>0){
//                [USER setObject:array forKey:@"myPetsDataArray"];
//            }
////            NSMutableArray * aidArray = [NSMutableArray arrayWithCapacity:0];
////            for (NSDictionary * dict in array) {
////                [aidArray addObject:[dict objectForKey:@"aid"]];
////            }
////            [USER setObject:aidArray forKey:@"petAidArray"];
//            //            NSLog(@"%@", [USER objectForKey:@"petAidArray"]);
//        }else{
//            LOADFAILED;
//        }
//    }];
//    [request release];
//}

-(void)jumpToMain
{
    FirstTabBarViewController * mainTab = [[FirstTabBarViewController alloc] init];
//    MainTabBarViewController * mainTab = [[MainTabBarViewController alloc] init];
//    JDSideMenu * sideMenu = [ControllerManager shareJDSideMenu];
    //                ChooseFamilyViewController * sideMenu = [[ChooseFamilyViewController alloc] init];
    if (hadImage) {
        mainTab.preImage = self.launchImage;
    }
    mainTab.animalNum = self.animalNum;
    mainTab.foodNum = self.foodNum;
    mainTab.modalTransitionStyle = 2;
    
    mainTab.selectedIndex = 1;
//    if ([[USER objectForKey:@"hasRemoteNotification"] intValue]) {
//        mainTab.selectedIndex = 3;
//    }
    
//    [self presentViewController:mainTab animated:YES completion:nil];
    [[UIApplication sharedApplication].delegate window].rootViewController = mainTab;
    [mainTab release];
}
//#pragma mark -获取用户数据
//-(void)getUserData
//{
//    NSString * url = [NSString stringWithFormat:@"%@%@", INFOAPI,[ControllerManager getSID]];
//    NSLog(@"%@", url);
//    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            if ([[load.dataDict objectForKey:@"errorCode"] intValue] == 2) {
//                //SID过期,需要重新登录获取SID
//                [self login];
//                [self getUserData];
//                return;
//            }else{
//                //SID未过期，直接获取用户数据
//                NSLog(@"用户数据：%@", load.dataDict);
//                NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
//                [USER setObject:[dict objectForKey:@"age"] forKey:@"age"];
//                [USER setObject:[dict objectForKey:@"code"] forKey:@"code"];
//                [USER setObject:[dict objectForKey:@"gender"] forKey:@"gender"];
//                [USER setObject:[dict objectForKey:@"name"] forKey:@"name"];
//                [USER setObject:[dict objectForKey:@"type"] forKey:@"type"];
//                if (![[dict objectForKey:@"tx"] isKindOfClass:[NSNull class]]) {
//                    [USER setObject:[dict objectForKey:@"tx"] forKey:@"tx"];
//                }
////                [USER setObject:[dict objectForKey:@"type"] forKey:@"type"];
//                
//                //                [self dismissViewControllerAnimated:YES completion:nil];
//            }
//        }
//    }];
//}

#pragma post
-(void)postImage
{
    //网络上传
    NSString * url = [NSString stringWithFormat:@"%@%@", PETIMAGEAPI, [ControllerManager getSID]];
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 20;
    
//    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/documents/myHeadImage.png"];
//    
//    NSLog(@"path:%@", path);
//    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
//    NSData * data = UIImagePNGRepresentation(image);
////    NSLog(@"data:%@", data);
//    if (data == nil) {
//        image = [UIImage imageNamed:@"1669988_d_wx.jpg"];
//        data = UIImageJPEGRepresentation(image, 1);
////        NSLog(@"data2:%@", data);
//    }
//
//    [_request setPostValue:@"This is a test333333333333!" forKey:@"comment"];
//    [_request setPostValue:data forKey:@"image"];
    UIImage * image = [UIImage imageNamed:@"1669988_d_wx.jpg"];
    NSData * data = UIImagePNGRepresentation(image);
    [_request setData:data withFileName:@"cat.png" andContentType:@"image/jpg" forKey:@"image"];

    _request.delegate = self;
    [_request startAsynchronous];
    
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"success");
    NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
}


-(void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
//        NSLog(@"微信登录");
    }else if(button.tag == 101){
//        NSLog(@"微博登录");
    }else if (button.tag == 102) {
//        UINavigationController * nc = [ControllerManager shareManagerRandom];
//        [self presentViewController:nc animated:YES completion:nil];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
}

-(void)setAnimation:(UIImageView *)nowView
{
//    isAnimation = 1;
//    if (isLogined) {
//        [self performSelector:@selector(jumpToRandom) withObject:nil afterDelay:2];
//    }
//    if(self.view.frame.size.height == 480.0){
//        [bgImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 568.0)];
//    }
    [UIView animateWithDuration:2.0f delay:0.0f options:UIViewAnimationOptionCurveLinear                     animations:^
     {
         // 执行的动画code
//         [bgImageView setFrame:CGRectMake(nowView.frame.origin.x- nowView.frame.size.width*0.1, nowView.frame.origin.y-nowView.frame.size.height*0.1, nowView.frame.size.width*1.2, nowView.frame.size.height*1.2)];
//         if(self.view.frame.size.height == 480.0){
//             [bgImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width+1, 568.0+1)];
//         }else{
             [bgImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width+1, self.view.frame.size.height+1)];
//         }
         
//         bgImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     }completion:^(BOOL finished) {
//         if (isLogined) {
//         if (finished) {
            [self performSelector:@selector(jumpToChoose) withObject:nil];
//         }
         
//         }else{
//             isAnimation = 1;
//         }
     }];
}
#pragma mark -
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d", buttonIndex);
    if (buttonIndex == 0) {
        shouldLoading = 1;
        if (reloadType == 1) {
            [self getUserData];
        }else if (reloadType == 2) {
            [self login];
        }else if (reloadType == 3) {
            [self getPreSID];
        }else if (reloadType == 4) {
            [self loadPetInfo];
        }
    }
}
@end
