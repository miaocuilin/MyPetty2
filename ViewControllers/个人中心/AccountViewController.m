//
//  AccountViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "AccountViewController.h"
//#import "UMSocialSnsPlatformManager.h"
//#import "UMSocialWechatHandler.h"
//#import "UMSocialSnsService.h"
//#import "UMSocialControllerService.h"
@interface AccountViewController () <UMSocialUIDelegate>

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBg];
    [self createFakeNavigation];
    
    [self createUI];
}
-(void)createBg
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.png"];
    [self.view addSubview:imageView];
}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"账号"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
-(void)createUI
{
    UIButton * button = [MyControl createButtonWithFrame:CGRectMake(100, 100, 100, 40) ImageName:@"" Target:self Action:@selector(click) Title:@"weChat"];
    button.backgroundColor = ORANGE;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    
    head = [MyControl createImageViewWithFrame:CGRectMake(100, 200, 100, 100) ImageName:@""];
    [self.view addSubview:head];
}
-(void)click
{
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
    //设置回调对象
//    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    
}
-(void)getUserWeChatInfo{
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        NSDictionary * dic = (NSDictionary *)response.data;
        NSString * gender = [dic objectForKey:@"gender"];
        NSString * location = [dic objectForKey:@"location"];
        NSString * openid = [dic objectForKey:@"openid"];
        NSString * profile_image_url = [dic objectForKey:@"profile_image_url"];
        NSString * screen_name = [dic objectForKey:@"screen_name"];
        [head setImageWithURL:[NSURL URLWithString:profile_image_url]];
        NSString * sex = nil;
        if ([gender intValue] == 1) {
            sex = @"男";
        }else{
            sex = @"女";
        }
        [MyControl createAlertViewWithTitle:@"微信信息" Message:[NSString stringWithFormat:@"用户名：%@\n性别：%@\n地址：%@\nID：%@", screen_name, sex, location, openid] delegate:nil cancelTitle:nil otherTitles:@"确定"];
    }];
}
//实现授权回调
//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    if (response.viewControllerType == UMSViewControllerOauth) {
//        
//        NSLog(@"didFinishOauthAndGetAccount response is %@",response);
//    }
//    //得到的数据在回调Block对象形参respone的data属性
//    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
//        NSLog(@"SnsInformation is %@",response.data);
//    }];
//}
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
