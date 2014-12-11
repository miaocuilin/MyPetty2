//
//  Alert_2ButtonViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/10.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "Alert_2ButtonViewController.h"

@interface Alert_2ButtonViewController ()

@end

@implementation Alert_2ButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeUI];
}
-(void)makeUI
{
    //黑 %60  白 %80
    UIView * alphaView = [MyControl createViewWithFrame:[UIScreen mainScreen].bounds];
    alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.view addSubview:alphaView];
    
    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(18, ([UIScreen mainScreen].bounds.size.height-230)/2.0, [UIScreen mainScreen].bounds.size.width-36, 230)];
    [self.view addSubview:bgView];
    
    UIView * whiteBg = [MyControl createViewWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
    whiteBg.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    whiteBg.layer.cornerRadius = 10;
    whiteBg.layer.masksToBounds = YES;
    [bgView addSubview:whiteBg];
    
    UIButton * closeBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width-36, 0, 36, 36) ImageName:@"various_close.png" Target:self Action:@selector(closeBtnClick) Title:nil];
    [bgView addSubview:closeBtn];
    
    UILabel * label1 = [MyControl createLabelWithFrame:CGRectMake(20, closeBtn.frame.origin.y+closeBtn.frame.size.height+30, bgView.frame.size.width-40, 20) Font:16 Text:nil];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [bgView addSubview:label1];
    
    UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(20, label1.frame.origin.y+label1.frame.size.height+20, bgView.frame.size.width-40, 20) Font:15 Text:nil];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [bgView addSubview:label2];
    
    if (self.isSina) {
        label1.text = @"您当前账号还未绑定微博";
        label2.text = @"使用微博与当前账号绑定";
    }else{
        label1.text = @"您当前账号还未绑定微信";
        label2.text = @"使用微信与当前账号绑定";
    }
    
    UIButton * cancelBtn = [MyControl createButtonWithFrame:CGRectMake(8, 346/2, 276/2*0.9, 93/2.0*0.9) ImageName:@"various_grayBtn.png" Target:self Action:@selector(cancelClick) Title:@"取消"];
    [bgView addSubview:cancelBtn];
    
    UIButton * confirmBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width-276/2*0.9-8, 346/2, 276/2*0.9, 93/2.0*0.9) ImageName:@"various_orangeBtn.png" Target:self Action:@selector(confirmClick) Title:@"去绑定"];
    [bgView addSubview:confirmBtn];
}
-(void)closeBtnClick
{
    [self.view removeFromSuperview];
}
-(void)cancelClick
{
    [self.view removeFromSuperview];
}
-(void)confirmClick
{
    if (self.isSina) {
        //绑定微博
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
            if (response.viewControllerType == UMSViewControllerOauth) {
                NSLog(@"didFinishOauthAndGetAccount response is %@",response);
                if (response.responseCode == 200) {
                    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                        NSLog(@"SnsInformation is %@",response.data);
                        NSDictionary * dic = (NSDictionary *)response.data;
                        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"weibo=%@dog&cat", [dic objectForKey:@"uid"]]];
                        NSString * url = [NSString stringWithFormat:@"%@&weibo=%@&sig=%@&SID=%@", BIND3PARTYAPI, [dic objectForKey:@"uid"], sig, [ControllerManager getSID]];
                        NSLog(@"%@", url);
                        LOADING;
                        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                            if (isFinish) {
                                if([[[load.dataDict objectForKey:@"data"] objectForKey:@"isBinded"] intValue]){
                                    [USER setObject:[NSString stringWithFormat:@"%@", [dic objectForKey:@"uid"]] forKey:@"weibo"];
                                    [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"绑定成功"];
                                }else{
                                    [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"绑定失败"];
                                }
                                ENDLOADING;
                            }else{
                                LOADFAILED;
                            }
                        }];
                        [request release];
                    }];
                }
            }
        });
    }else{
        //绑定微信
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
            if (response.viewControllerType == UMSViewControllerOauth) {
                NSLog(@"didFinishOauthAndGetAccount response is %@",response);
                if (response.responseCode == 200) {
                    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
                        NSLog(@"SnsInformation is %@",response.data);
                        NSDictionary * dic = (NSDictionary *)response.data;
                        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"wechat=%@dog&cat", [dic objectForKey:@"openid"]]];
                        NSString * url = [NSString stringWithFormat:@"%@&wechat=%@&sig=%@&SID=%@", BIND3PARTYAPI, [dic objectForKey:@"openid"], sig, [ControllerManager getSID]];
                        NSLog(@"%@", url);
                        LOADING;
                        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                            if (isFinish) {
                                if([[[load.dataDict objectForKey:@"data"] objectForKey:@"isBinded"] intValue]){
                                    [USER setObject:[dic objectForKey:@"openid"] forKey:@"wechat"];
                                    [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"绑定成功"];
                                }else{
                                    [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"绑定失败"];
                                }
                                ENDLOADING;
                            }else{
                                LOADFAILED;
                            }
                        }];
                        [request release];
                    }];
                }
            }
        });
    }
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
