//
//  VariousAlertViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/10.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "VariousAlertViewController.h"
#import "ChooseInViewController.h"

@interface VariousAlertViewController ()

@end

@implementation VariousAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
-(void)createUI
{
    //黑 %60  白 %80
    UIView * alphaView = [MyControl createViewWithFrame:[UIScreen mainScreen].bounds];
    alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.view addSubview:alphaView];
    
    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(18, (self.view.frame.size.height-230)/2.0, self.view.frame.size.width-36, 230)];
    [self.view addSubview:bgView];
    
    UIView * whiteBg = [MyControl createViewWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
    whiteBg.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    whiteBg.layer.cornerRadius = 10;
    whiteBg.layer.masksToBounds = YES;
    [bgView addSubview:whiteBg];
    
    UIButton * closeBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width-36, 0, 36, 36) ImageName:@"various_close.png" Target:self Action:@selector(closeBtnClick) Title:nil];
    [bgView addSubview:closeBtn];
    
    UIButton * regBtn = [MyControl createButtonWithFrame:CGRectMake(32, 48, bgView.frame.size.width-64, 42) ImageName:@"various_regBtn.png" Target:self Action:@selector(regBtnClick) Title:@"注册"];
    [regBtn setTitleColor:ORANGE forState:UIControlStateNormal];
//    [regBtn setBackgroundImage:[[UIImage imageNamed:@"various_regBtn.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:0] forState:UIControlStateNormal];
    [bgView addSubview:regBtn];
    
    NSArray * array = @[@"various_weChat.png", @"various_sina.png", @"various_fastLogin.png"];
    NSArray * array2 = @[@"微信登录", @"微博登录", @"昵称登录"];
    float spe = (bgView.frame.size.width-25*2-52*3)/2.0;
    for (int i=0; i<3; i++) {
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(25+i*(52+spe), 123, 52, 52) ImageName:array[i] Target:self Action:@selector(buttonClick:) Title:nil];
        button.tag = 1000+i;
        [bgView addSubview:button];
        
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(button.frame.origin.x-10, button.frame.origin.y+button.frame.size.height, button.frame.size.width+20, 20) Font:14 Text:array2[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
        [bgView addSubview:label];
    }
}

-(void)closeBtnClick
{
    //close
    [self.view removeFromSuperview];
}
-(void)regBtnClick
{
    self.regClick();
//    [self.view removeFromSuperview];
//    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)buttonClick:(UIButton *)btn
{
    NSLog(@"%d", btn.tag);
    int a = btn.tag-1000;
    if (a ==0) {
        //微信
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
            if (response.viewControllerType == UMSViewControllerOauth) {
                NSLog(@"didFinishOauthAndGetAccount response is %@",response);
                if (response.responseCode == 200) {
                    [self getUserWeChatInfo];
                }
            }
        });
    }else if (a ==1) {
        //微博
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
            if (response.viewControllerType == UMSViewControllerOauth) {
                NSLog(@"didFinishOauthAndGetAccount response is %@",response);
                if (response.responseCode == 200) {
                    [self getUserSinaInfo];
                }
            }
        });
    }else if (a ==2) {
        self.fastClick();
    }
}
-(void)getUserWeChatInfo{
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        NSDictionary * dic = (NSDictionary *)response.data;
        
        [USER setObject:dic forKey:@"weChatUserInfo"];
        [USER setObject:@"" forKey:@"sinaUserInfo"];
        
        LOADING;
        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"wechat=%@dog&cat", [dic objectForKey:@"openid"]]];
        NSString * url = [NSString stringWithFormat:@"%@&wechat=%@&sig=%@&SID=%@", LOGINBY3PARTY, [dic objectForKey:@"openid"], sig, [ControllerManager getSID]];
        NSLog(@"%@", url);
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                if([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                    if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"isBinded"] intValue]) {
                        //绑定过 自动切换 直接用用户id和宠物id获取用户信息
                        [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"usr_id"] forKey:@"usr_id"];
                        [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"aid"] forKey:@"aid"];
                        [self getUserData];
    
                    }else{
                        //未绑定过 没注册过 直接跳选择有宠没宠
                        self.regClick();
//                        ChooseInViewController * vc = [[ChooseInViewController alloc] init];
//                        [self presentViewController:vc animated:YES completion:nil];
//                        [vc release];
                        [self closeBtnClick];
                    }
                ENDLOADING;
                }
            }else{
                LOADFAILED;
            }
        }];
        [request release];
    }];
}
-(void)getUserSinaInfo
{
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        NSDictionary * dic = (NSDictionary *)response.data;
        
        [USER setObject:dic forKey:@"sinaUserInfo"];
        [USER setObject:@"" forKey:@"weChatUserInfo"];
         NSLog(@"%@", [USER objectForKey:@"sinaUserInfo"]);
        
        LOADING;
        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"weibo=%@dog&cat", [dic objectForKey:@"uid"]]];
        NSString * url = [NSString stringWithFormat:@"%@&weibo=%@&sig=%@&SID=%@", LOGINBY3PARTY, [dic objectForKey:@"uid"], sig, [ControllerManager getSID]];
        NSLog(@"%@", url);
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"%@", load.dataDict);
                if([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                    if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"isBinded"] intValue]) {
                        //绑定过 没注册过 获取用户信息及宠物信息
                        
                        
                        [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"usr_id"] forKey:@"usr_id"];
                        [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"aid"] forKey:@"aid"];
                        [self getUserData];
                    }else{
                        //未绑定过 没注册过 直接跳选择有宠没宠
                        self.regClick();
//                        ChooseInViewController * vc = [[ChooseInViewController alloc] init];
//                        [self presentViewController:vc animated:YES completion:nil];
//                        [vc release];
                        [self closeBtnClick];
                    }
                }
                ENDLOADING;
            }else{
                LOADFAILED;
            }
        }];
        [request release];
    }];
}

#pragma mark -
#pragma mark -获取用户数据
-(void)getUserData
{
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERINFOAPI, [USER objectForKey:@"usr_id"], sig,[ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            //SID未过期，直接获取用户数据
            NSLog(@"用户数据：%@", load.dataDict);
            NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            
            [USER setObject:[dict objectForKey:@"a_name"] forKey:@"a_name"];
            [USER setObject:[dict objectForKey:@"a_age"] forKey:@"a_age"];
            if (![[dict objectForKey:@"a_tx"] isKindOfClass:[NSNull class]]) {
                [USER setObject:[dict objectForKey:@"a_tx"] forKey:@"a_tx"];
            }
            [USER setObject:[dict objectForKey:@"age"] forKey:@"age"];
            [USER setObject:[dict objectForKey:@"gender"] forKey:@"gender"];
            [USER setObject:[dict objectForKey:@"name"] forKey:@"name"];
            [USER setObject:[dict objectForKey:@"city"] forKey:@"city"];
            [USER setObject:[dict objectForKey:@"exp"] forKey:@"oldexp"];
            [USER setObject:[dict objectForKey:@"exp"] forKey:@"exp"];
            [USER setObject:[NSString stringWithFormat:@"%@", [dict objectForKey:@"food"]] forKey:@"food"];
            [USER setObject:[dict objectForKey:@"lv"] forKey:@"lv"];
            [USER setObject:[dict objectForKey:@"inviter"] forKey:@"inviter"];
            [USER setObject:[USER objectForKey:@"gold"] forKey:@"oldgold"];
            [USER setObject:[dict objectForKey:@"gold"] forKey:@"gold"];
            [USER setObject:[dict objectForKey:@"usr_id"] forKey:@"usr_id"];
            [USER setObject:[dict objectForKey:@"aid"] forKey:@"aid"];
            [USER setObject:[dict objectForKey:@"con_login"] forKey:@"con_login"];
            [USER setObject:[dict objectForKey:@"next_gold"] forKey:@"next_gold"];
            [USER setObject:[dict objectForKey:@"rank"] forKey:@"rank"];
            [USER setObject:[dict objectForKey:@"password"] forKey:@"password"];
            
            if (![[dict objectForKey:@"tx"] isKindOfClass:[NSNull class]]) {
                [USER setObject:[dict objectForKey:@"tx"] forKey:@"tx"];
            }
            
            
            //获取宠物信息，存储到本地
            [self loadPetInfo];
        }else{
            LOADFAILED;
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
            
            ENDLOADING;
            [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"登录成功"];
            [USER setObject:@"1" forKey:@"isSuccess"];
            [ControllerManager setIsSuccess:1];
            
            [self.view removeFromSuperview];
//            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
