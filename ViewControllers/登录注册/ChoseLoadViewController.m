//
//  ChoseLoadViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-1.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ChoseLoadViewController.h"
#import "ChooseInViewController.h"
#import "ChooseFamilyViewController.h"
//#import "DropitBehavior.h"
@interface ChoseLoadViewController ()
{
//    DropitBehavior * behavior;
//    DropitBehavior * behavior2;
//    UIDynamicAnimator * animator;
}
@end

@implementation ChoseLoadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [self createUI];
//    
//    timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(cloudMove) userInfo:nil repeats:YES];
//}
-(void)viewDidAppear:(BOOL)animated
{
    //
    if (!self.isFromMenu) {
        if ([[USER objectForKey:@"planet"] intValue] == 1) {
            [self miBtnClick];
        }
        if ([[USER objectForKey:@"planet"] intValue] == 2) {
            [self waBtnClick];
        }
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
//    behavior = [[DropitBehavior alloc] init];
//    behavior2 = [[DropitBehavior alloc] init];
//    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
//    [animator addBehavior:behavior];
//    [animator addBehavior:behavior2];
    [self createUI];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(cloudMove) userInfo:nil repeats:YES];
}

-(void)createUI
{
    UIView * statusView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 20)];
    statusView.backgroundColor = BGCOLOR;
    [self.view addSubview:statusView];
    
    UIImageView * earth = [MyControl createImageViewWithFrame:CGRectMake(0, 20, 382/2, 187/2) ImageName:@"1-a.png"];
    [self.view addSubview:earth];
    
    cloud0 = [MyControl createImageViewWithFrame:CGRectMake(-22, self.view.frame.size.height-750/2, 87/2, 60/2) ImageName:@"1-g.png"];
    [self.view addSubview:cloud0];
    /*************喵星**************/
//    UIView * miLine = [MyControl createViewWithFrame:CGRectMake(30, 20, 5, 0)];
//    miLine.backgroundColor = BGCOLOR;
//    [self.view addSubview:miLine];
    
    miBgView = [MyControl createViewWithFrame:CGRectMake(30, self.view.frame.size.height-300, 100, 105+50)];
    [self.view addSubview:miBgView];
//    [behavior addItem:miBgView];
//    [behavior.collider setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-155, 0, 380/2-50, 0)];
    
    UIView * miBg1 = [MyControl createViewWithFrame:CGRectMake(0, 5, 100, 100)];
    miBg1.backgroundColor = BGCOLOR;
    miBg1.layer.cornerRadius = miBg1.frame.size.height/2;
    miBg1.layer.masksToBounds = YES;
    [miBgView addSubview:miBg1];
    
    UIView * miBg2 = [MyControl createViewWithFrame:CGRectMake(0, 0, 100, 100)];
    miBg2.backgroundColor = BGCOLOR3;
    miBg2.layer.cornerRadius = miBg2.frame.size.height/2;
    miBg2.layer.masksToBounds = YES;
    [miBgView addSubview:miBg2];
    
    UIImageView * mi = [MyControl createImageViewWithFrame:CGRectMake(5, 12, 90, 153/2) ImageName:@"1-d.png"];
    [miBg2 addSubview:mi];
    
    UIButton * miBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, miBg2.frame.size.width, miBg2.frame.size.height) ImageName:@"" Target:self Action:@selector(miBtnClick) Title:nil];
    [miBg2 addSubview:miBtn];
    
    UILabel * miDes = [MyControl createLabelWithFrame:CGRectMake(-10, miBg1.frame.origin.y+miBg1.frame.size.height+5, 140, 50) Font:15 Text:@"   MI星球(喵星球)\n距离地球一百亿光年"];
    miDes.textColor = [UIColor colorWithRed:50/255.0 green:138/255.0 blue:197/255.0 alpha:1];
    miDes.font = [UIFont boldSystemFontOfSize:15];
    miDes.alpha = 0;
    [miBgView addSubview:miDes];

    //动画效果
    [UIView animateWithDuration:1 delay:0.7 options:0 animations:^{
//        miLine.frame = CGRectMake(30, 20, 5, self.view.frame.size.height-(380/2+50)-20);
    } completion:^(BOOL finished) {
//        [animator removeBehavior:behavior];
//        [behavior removeItem:miBgView];
        [UIView animateWithDuration:0.5 animations:^{
            miDes.alpha = 1;
        }];
    }];
    
    /*************汪星**************/
    
//    UIView * waLine = [MyControl createViewWithFrame:CGRectMake(180, 20, 5, 0)];
//    waLine.backgroundColor = BGCOLOR;
//    [self.view addSubview:waLine];
    
    waBgView = [MyControl createViewWithFrame:CGRectMake(180, self.view.frame.size.height-870/2, 100, 105+50)];
//    waBgView.frame = CGRectMake(180, -155, 100, 155);
    [self.view addSubview:waBgView];
//    [behavior2 addItem:waBgView];
//    [behavior2.collider setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-155, 0, 650/2-55, 0)];
    
//    UIView * waBg1 = [MyControl createViewWithFrame:CGRectMake(0, 5, 100, 100)];
//    waBg1.backgroundColor = BGCOLOR;
//    waBg1.layer.cornerRadius = waBg1.frame.size.height/2;
//    waBg1.layer.masksToBounds = YES;
//    [waBgView addSubview:waBg1];
    
//    UIView * waBg2 = [MyControl createViewWithFrame:CGRectMake(0, 0, 100, 100)];
//    waBg2.backgroundColor = BGCOLOR3;
//    waBg2.layer.cornerRadius = waBg2.frame.size.height/2;
//    waBg2.layer.masksToBounds = YES;
//    [waBgView addSubview:waBg2];
//    
    UIImageView * wa = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 100, 105) ImageName:@"dogPlanet.png"];
    [waBgView addSubview:wa];
    
    UIButton * waBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, wa.frame.size.width, wa.frame.size.height) ImageName:@"" Target:self Action:@selector(waBtnClick) Title:nil];
//    waBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [waBgView addSubview:waBtn];
    
    UILabel * waDes = [MyControl createLabelWithFrame:CGRectMake(-15, 105, 140, 50) Font:15 Text:@"   WA星球(汪星球)\n距离地球九十亿光年"];
    waDes.textColor = [UIColor colorWithRed:50/255.0 green:138/255.0 blue:197/255.0 alpha:1];
    waDes.font = [UIFont boldSystemFontOfSize:15];
    waDes.alpha = 0;
    [waBgView addSubview:waDes];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        waLine.frame = CGRectMake(180, 20, 5, waBg1.frame.origin.y+50-20);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:1 animations:^{
//            waDes.alpha = 1;
//        }];
//    }];
    [UIView animateWithDuration:0.5 delay:0.7 options:0 animations:^{
//        waLine.frame = CGRectMake(180, 20, 5, self.view.frame.size.height-(860/2-55)-20);
    } completion:^(BOOL finished) {
//        [animator removeBehavior:behavior2];
//        [behavior2 removeItem:waBgView];
        [UIView animateWithDuration:0.5 animations:^{
            waDes.alpha = 1;
        }];
    }];
    /**************************/
    
    cloud = [MyControl createImageViewWithFrame:CGRectMake(470/2, self.view.frame.size.height-280/2, 87/2, 60/2) ImageName:@"1-g.png"];
    [self.view addSubview:cloud];
    
    UIImageView * grass = [MyControl createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height-76/2, 320, 76/2) ImageName:@"1-f.png"];
    [self.view addSubview:grass];
    
    UIImageView * tips = [MyControl createImageViewWithFrame:CGRectMake(230/2, self.view.frame.size.height-215/2, 281/2, 205/2) ImageName:@"1-c.png"];
    [self.view addSubview:tips];
    
    UILabel * line1 = [MyControl createLabelWithFrame:CGRectMake(30, 5, 100, 20) Font:17 Text:@"选 择 您 想"];
    line1.font = [UIFont boldSystemFontOfSize:17];
    line1.textColor = [UIColor colorWithRed:255/255.0 green:250/255.0 blue:180/255.0 alpha:1];
    [tips addSubview:line1];
    
    UILabel * line2 = [MyControl createLabelWithFrame:CGRectMake(20, 30, 180, 20) Font:17 Text:@"登 陆 的 星 球"];
    line2.font = [UIFont boldSystemFontOfSize:17];
    line2.textColor = [UIColor colorWithRed:255/255.0 green:250/255.0 blue:180/255.0 alpha:1];
    [tips addSubview:line2];
    
    
}

-(void)cloudMove
{
    count++;
    if (count/50 == 5) {
        count = 0;
        CABasicAnimation * shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //抖动幅度
        shake.fromValue = [NSNumber numberWithFloat:-0.1];
        shake.toValue = [NSNumber numberWithFloat:0.1];
        shake.duration = 0.1;
        shake.autoreverses = YES; //是否重复
        shake.repeatCount = 2;
        [miBgView.layer addAnimation:shake forKey:@"view"];
        [waBgView.layer addAnimation:shake forKey:@"view"];
    }
    cloud0.frame = CGRectMake(cloud0.frame.origin.x+0.5, cloud0.frame.origin.y, cloud0.frame.size.width, cloud0.frame.size.height);
    cloud.frame = CGRectMake(cloud.frame.origin.x+0.5, cloud.frame.origin.y, cloud.frame.size.width, cloud.frame.size.height);
    if (cloud.frame.origin.x == 320) {
        cloud.frame = CGRectMake(-cloud.frame.size.width, cloud.frame.origin.y, cloud.frame.size.width, cloud.frame.size.height);
    }
    if (cloud0.frame.origin.x == 320) {
        cloud0.frame = CGRectMake(-cloud0.frame.size.width, cloud0.frame.origin.y, cloud0.frame.size.width, cloud0.frame.size.height);
    }
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
    
    /******************************/
    NSLog(@"%@--%@", [USER objectForKey:@"isSuccess"], [USER objectForKey:@"SID"]);
//    [USER setObject:@"" forKey:@"SID"];
//    [USER setObject:@"" forKey:@"isSuccess"];
//    if ([[USER objectForKey:@"isSuccess"] intValue] && [USER objectForKey:@"SID"]) {
//        [ControllerManager setIsSuccess:[[USER objectForKey:@"isSuccess"] intValue]];
//        [ControllerManager setSID:[USER objectForKey:@"SID"]];
//        [self getUserData];
//    }else{
//        [self login];
//    }
}
#pragma mark - 穿越
-(void)throughPlanet
{
    StartLoading;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"planet=%ddog&cat", planet]];
    NSString * url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", THROUGHAPI, planet, sig, [USER objectForKey:@"SID"]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
//            if ([[load.dataDict objectForKey:@"isSuccess"] intValue]) {
//                
//            }
            if (self.isFromMenu) {
                [MMProgressHUD dismissWithSuccess:@"穿越成功" title:nil afterDelay:1];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self jumpToMain];
                LoadingSuccess;
            }
            
        }else{
            LoadingFailed;
        }
    }];
    [request release];
}


-(void)getPreSID
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"uid=%@dog&cat", [OpenUDID value]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@", GETPRESID, [OpenUDID value], sig];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if (![[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                //网上也米有SID--》login
                [self login];
            }else{
                if ([[USER objectForKey:@"isSuccess"] intValue]
                    ) {
                    [ControllerManager setIsSuccess:[[USER objectForKey:@"isSuccess"] intValue]];
                    [ControllerManager setSID:[USER objectForKey:@"SID"]];
                    [self getUserData];
                }else{
                    [self login];
                }
            }
        }else{
            
        }
    }];
    [request release];
}
-(void)miBtnClick
{
    NSLog(@"进入喵星");
//    ChooseInViewController * vc = [[ChooseInViewController alloc] init];
//    vc.isMi = YES;
//    [self presentViewController:vc animated:YES completion:nil];
    planet = 1;
    [USER setObject:[NSString stringWithFormat:@"%d", planet] forKey:@"planet"];
    
    if (self.isFromMenu) {
        [self throughPlanet];
    }else{
        [self tempLogin];
    }
    
    [timer invalidate];
    timer = nil;
//    [vc release];
}
-(void)waBtnClick
{
    NSLog(@"进入汪星");
//    ChooseInViewController * vc = [[ChooseInViewController alloc] init];
//    vc.isMi = NO;
//    [self presentViewController:vc animated:YES completion:nil];
    planet = 2;
    [USER setObject:[NSString stringWithFormat:@"%d", planet] forKey:@"planet"];
    
    if (self.isFromMenu) {
        [self throughPlanet];
    }else{
        [self tempLogin];
    }
    
    [timer invalidate];
    timer = nil;
//    [vc release];
}
-(void)jumpToMain
{
    JDSideMenu * sideMenu = [ControllerManager shareJDSideMenu];
    //                ChooseFamilyViewController * sideMenu = [[ChooseFamilyViewController alloc] init];
    sideMenu.modalTransitionStyle = 1;
    [self presentViewController:sideMenu animated:YES completion:nil];
}

#pragma mark -登录
-(void)login
{
    StartLoading;
    NSString * code = [NSString stringWithFormat:@"planet=%d&uid=%@dog&cat", planet, [OpenUDID value]];
    NSString * url = [NSString stringWithFormat:@"%@%d&uid=%@&sig=%@", LOGINAPI, planet, [OpenUDID value], [MyMD5 md5:code]];
    NSLog(@"login-url:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            NSLog(@"%@", load.dataDict);
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
            if ([ControllerManager getIsSuccess]) {
                [self getUserData];
                
            }else{
                LoadingSuccess;
                //跳转到主页
                [self throughPlanet];
            }
        }else{
            LoadingFailed;
            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"数据请求失败，是否重新请求？" Message:nil delegate:self cancelTitle:@"取消" otherTitles:@"确定"];
        }
    }];
    [request release];
}
#pragma mark -alert代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self tempLogin];
    }
}
#pragma mark -获取用户数据
-(void)getUserData
{
    if ([USER objectForKey:@"usr_id"] == nil || [[USER objectForKey:@"usr_id"] length] == 0) {
        [self login];
        return;
    }
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:@"登陆中..."];
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERINFOAPI, [USER objectForKey:@"usr_id"], sig,[ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"state"] intValue] == 2) {
                //SID过期,需要重新登录获取SID
                [self login];
//                [self getUserData];
                return;
            }else{
                //SID未过期，直接获取用户数据
                NSLog(@"用户数据：%@", load.dataDict);
                NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                
                [USER setObject:[dict objectForKey:@"a_name"] forKey:@"a_name"];
                if (![[dict objectForKey:@"a_tx"] isKindOfClass:[NSNull class]]) {
                    [USER setObject:[dict objectForKey:@"a_tx"] forKey:@"a_tx"];
                }
                [USER setObject:[dict objectForKey:@"age"] forKey:@"age"];
                [USER setObject:[dict objectForKey:@"gender"] forKey:@"gender"];
                [USER setObject:[dict objectForKey:@"name"] forKey:@"name"];
                [USER setObject:[dict objectForKey:@"city"] forKey:@"city"];
                [USER setObject:[dict objectForKey:@"exp"] forKey:@"oldexp"];
                [USER setObject:[dict objectForKey:@"exp"] forKey:@"exp"];
                [USER setObject:[dict objectForKey:@"lv"] forKey:@"lv"];
                
                [USER setObject:[USER objectForKey:@"gold"] forKey:@"oldgold"];
                [USER setObject:[dict objectForKey:@"gold"] forKey:@"gold"];
                [USER setObject:[dict objectForKey:@"usr_id"] forKey:@"usr_id"];
                [USER setObject:[dict objectForKey:@"aid"] forKey:@"aid"];
                [USER setObject:[dict objectForKey:@"con_login"] forKey:@"con_login"];
                [USER setObject:[dict objectForKey:@"next_gold"] forKey:@"next_gold"];
                if (![[dict objectForKey:@"tx"] isKindOfClass:[NSNull class]]) {
                    [USER setObject:[dict objectForKey:@"tx"] forKey:@"tx"];
                }

                
                //获取宠物信息，存储到本地
                [self loadPetInfo];
                
                
            }
        }
    }];
    [request release];
}
-(void)loadPetInfo
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", [USER objectForKey:@"aid"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETINFOAPI, [USER objectForKey:@"aid"], sig, [ControllerManager getSID]];
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"petInfo:%@", load.dataDict);
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                //记录默认宠物信息
                [USER setObject:[load.dataDict objectForKey:@"data"] forKey:@"petInfoDict"];
            }
            
            [self throughPlanet];
        }else{
            
        }
    }];
    [request release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
