//
//  LoginViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/8.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "LoginViewController.h"
#import "ChooseInViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
-(void)viewDidAppear:(BOOL)animated
{
    if ([[USER objectForKey:@"isLoginShouldDismiss"] intValue]) {
        [USER setObject:@"0" forKey:@"isLoginShouldDismiss"];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void)createUI
{
    UIImageView * bgImage = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.png"];
    [self.view addSubview:bgImage];
    
    sv = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    if ([UIScreen mainScreen].bounds.size.height<568) {
//        sv.contentSize = CGSizeMake(self.view.frame.size.width, 568);
//    }else{
//        sv.contentSize = [UIScreen mainScreen].bounds.size;
//    }
    [self.view addSubview:sv];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [sv addGestureRecognizer:tap];
    
    //
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 18/2, 31/2) ImageName:@"choosein_back2.png"];
    [self.view addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:backBtn];
    
    float w = 159/2.0;
    float h = 97/2.0;
    UIImageView * icon = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-w)/2.0, 60, w, h) ImageName:@"choosein_icon.png"];
    [sv addSubview:icon];
    
    //528  92
    UIImageView * bg1 = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-528/2)/2, icon.frame.origin.y+icon.frame.size.height+30, 528/2, 92/2) ImageName:@"login_tf_bg.png"];
    [sv addSubview:bg1];
    
    nameTF = [MyControl createTextFieldWithFrame:CGRectMake(15, 0, bg1.frame.size.width-15, bg1.frame.size.height) placeholder:@"昵称" passWord:NO leftImageView:nil rightImageView:nil Font:17];
    nameTF.delegate = self;
    nameTF.borderStyle = 0;
    nameTF.returnKeyType = UIReturnKeyDone;
    [bg1 addSubview:nameTF];
    
    UIImageView * bg2 = [MyControl createImageViewWithFrame:CGRectMake(bg1.frame.origin.x, bg1.frame.origin.y+bg1.frame.size.height+15, 528/2, 92/2) ImageName:@"login_tf_bg.png"];
    [sv addSubview:bg2];
    
    codeTF = [MyControl createTextFieldWithFrame:CGRectMake(15, 0, bg2.frame.size.width-15, bg2.frame.size.height) placeholder:@"密码" passWord:YES leftImageView:nil rightImageView:nil Font:17];
    codeTF.delegate = self;
    codeTF.borderStyle = 0;
    codeTF.returnKeyType = UIReturnKeyDone;
    codeTF.backgroundColor = [UIColor clearColor];
    [bg2 addSubview:codeTF];
    
    //afafaf
    logBtn = [MyControl createButtonWithFrame:CGRectMake(bg2.frame.origin.x, bg2.frame.origin.y+bg2.frame.size.height+94/2, bg2.frame.size.width, bg2.frame.size.height) ImageName:@"" Target:self Action:@selector(logBtnClick:) Title:@"登录"];
    logBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    logBtn.backgroundColor = [ControllerManager colorWithHexString:@"afafaf"];
    logBtn.layer.cornerRadius = 22;
    logBtn.layer.masksToBounds = YES;
    logBtn.showsTouchWhenHighlighted = YES;
    [sv addSubview:logBtn];
    
    //
    UIButton * regBtn = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-logBtn.frame.origin.x-80, logBtn.frame.origin.y+logBtn.frame.size.height+15, 80, 20) ImageName:@"" Target:self Action:@selector(regBtnClick) Title:@"新用户注册"];
    regBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [regBtn setTitleColor:ORANGE forState:UIControlStateNormal];
    regBtn.showsTouchWhenHighlighted = YES;
    [sv addSubview:regBtn];
    
    UIView * line1 = [MyControl createViewWithFrame:CGRectMake(self.view.frame.size.width/2.0-174/2-15, logBtn.frame.origin.y+logBtn.frame.size.height+90, 174/2, 0.5)];
    line1.backgroundColor = [UIColor whiteColor];
    [sv addSubview:line1];
    if (self.view.frame.size.height<568) {
        CGRect rect = line1.frame;
        rect.origin.y -= 40;
        line1.frame = rect;
    }
    
    UILabel * orLabel = [MyControl createLabelWithFrame:CGRectMake(self.view.frame.size.width/2-15, line1.frame.origin.y-10, 30, 20) Font:14 Text:@"或"];
    orLabel.textAlignment = NSTextAlignmentCenter;
    [sv addSubview:orLabel];
    
    UIView * line2 = [MyControl createViewWithFrame:CGRectMake(self.view.frame.size.width/2.0+15, line1.frame.origin.y, 174/2, 0.5)];
    line2.backgroundColor = [UIColor whiteColor];
    [sv addSubview:line2];
    
    UIButton * wechat = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width/2-10-52, line2.frame.origin.y+18, 52, 52) ImageName:@"login_wechat.png" Target:self Action:@selector(wechatClick) Title:nil];
    wechat.showsTouchWhenHighlighted = YES;
    [sv addSubview:wechat];
    
    UIButton * sina = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width/2+10, line2.frame.origin.y+18, 52, 52) ImageName:@"login_sina.png" Target:self Action:@selector(sinaClick) Title:nil];
    sina.showsTouchWhenHighlighted = YES;
    [sv addSubview:sina];
}
#pragma mark - delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    float a = self.view.frame.size.width/self.view.frame.size.height;
    float b = 320/480.0;
    if (a == b) {
        [UIView animateWithDuration:0.3 animations:^{
            sv.frame = CGRectMake(0, -30, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        sv.frame = [UIScreen mainScreen].bounds;
    }];
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    logBtn.backgroundColor = [ControllerManager colorWithHexString:@"afafaf"];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([nameTF.text length] && [codeTF.text length]) {
        logBtn.backgroundColor = ORANGE;
    }else{
        logBtn.backgroundColor = [ControllerManager colorWithHexString:@"afafaf"];
    }
    //
    if (textField == nameTF && [codeTF.text length] && [string length]) {
        logBtn.backgroundColor = ORANGE;
    }
    if (textField == codeTF && [nameTF.text length] && [string length]) {
        logBtn.backgroundColor = ORANGE;
    }
    
    //
    if (textField == nameTF && nameTF.text.length == 1 && ![string length]) {
        logBtn.backgroundColor = [ControllerManager colorWithHexString:@"afafaf"];
    }
    if (textField == codeTF && codeTF.text.length == 1 && ![string length]) {
        logBtn.backgroundColor = [ControllerManager colorWithHexString:@"afafaf"];
    }
    
    return YES;
}
-(void)wechatClick
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
//        NSString * profile_image_url = [dic objectForKey:@"profile_image_url"];
        NSString * screen_name = [dic objectForKey:@"screen_name"];
//        [head setImageWithURL:[NSURL URLWithString:profile_image_url]];
        NSString * sex = nil;
        if ([gender intValue] == 1) {
            sex = @"男";
        }else{
            sex = @"女";
        }
        [MyControl createAlertViewWithTitle:@"微信信息" Message:[NSString stringWithFormat:@"用户名：%@\n性别：%@\n地址：%@\nID：%@", screen_name, sex, location, openid] delegate:nil cancelTitle:nil otherTitles:@"确定"];
    }];
}
-(void)sinaClick
{
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
}
-(void)getUserSinaInfo
{
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        NSDictionary * dic = (NSDictionary *)response.data;
        NSString * gender = [dic objectForKey:@"gender"];
        NSString * location = [dic objectForKey:@"location"];
        NSString * uid = [dic objectForKey:@"uid"];
//        NSString * profile_image_url = [dic objectForKey:@"profile_image_url"];
        NSString * screen_name = [dic objectForKey:@"screen_name"];
        //        [head setImageWithURL:[NSURL URLWithString:profile_image_url]];
        NSString * sex = nil;
        if ([gender intValue] == 1) {
            sex = @"男";
        }else{
            sex = @"女";
        }
        [MyControl createAlertViewWithTitle:@"微博信息" Message:[NSString stringWithFormat:@"用户名：%@\n性别：%@\n地址：%@\nID：%@", screen_name, sex, location, uid] delegate:nil cancelTitle:nil otherTitles:@"确定"];
    }];
}
#pragma mark -
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)regBtnClick
{
    ChooseInViewController * vc = [[ChooseInViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)logBtnClick:(UIButton *)btn
{
    
}
#pragma mark - gesture
-(void)tap:(UIGestureRecognizer *)tap
{
//    [UIView animateWithDuration:0.3 animations:^{
//        sv.frame = [UIScreen mainScreen].bounds;
//    }];
    [nameTF resignFirstResponder];
    [codeTF resignFirstResponder];
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
