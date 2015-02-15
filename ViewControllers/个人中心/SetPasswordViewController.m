//
//  SetPasswordViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/9.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "SetPasswordViewController.h"

@interface SetPasswordViewController ()

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createBg];
    [self createUI];
    [self createFakeNavigation];
}
-(void)createBg
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
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
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 22, 60, 40) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"设置密码"];
    if(self.isModify){
        titleLabel.text = @"更改密码";
    }
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}
-(void)backBtnClick
{
    [oriTF resignFirstResponder];
    [nwTF resignFirstResponder];
    [conTF resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
-(void)createUI
{
    sv = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:sv];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [sv addGestureRecognizer:tap];
    

    //528  92
    bg1 = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-528/2)/2, 64+50, 528/2, 92/2) ImageName:@"login_tf_bg.png"];
    [sv addSubview:bg1];
    bg1.hidden = YES;
    
    oriPwd = [MyControl createLabelWithFrame:CGRectMake(bg1.frame.origin.x+16, bg1.frame.origin.y-20, 200, 20) Font:15 Text:@"原密码"];
    oriPwd.textColor = [ControllerManager colorWithHexString:@"999999"];
    [sv addSubview:oriPwd];
    oriPwd.hidden = YES;
    
    oriTF = [MyControl createTextFieldWithFrame:CGRectMake(15, 0, bg1.frame.size.width-15, bg1.frame.size.height) placeholder:@"" passWord:YES leftImageView:nil rightImageView:nil Font:17];
    oriTF.delegate = self;
    oriTF.borderStyle = 0;
    oriTF.returnKeyType = UIReturnKeyDone;
    [bg1 addSubview:oriTF];
    
    /**************/
    bg2 = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-528/2)/2, 64+50, 528/2, 92/2) ImageName:@"login_tf_bg.png"];
    [sv addSubview:bg2];
    
    if (self.isModify) {
        bg1.hidden = NO;
        oriPwd.hidden = NO;
        bg2.frame = CGRectMake((self.view.frame.size.width-528/2)/2, bg1.frame.origin.y+bg1.frame.size.height+50, 528/2, 92/2);
    }
    
    nwPwd = [MyControl createLabelWithFrame:CGRectMake(bg2.frame.origin.x+16, bg2.frame.origin.y-20, 200, 20) Font:15 Text:@"新密码"];
    nwPwd.textColor = [ControllerManager colorWithHexString:@"999999"];
    [sv addSubview:nwPwd];
    
    nwTF = [MyControl createTextFieldWithFrame:CGRectMake(15, 0, bg2.frame.size.width-15, bg2.frame.size.height) placeholder:@"" passWord:YES leftImageView:nil rightImageView:nil Font:17];
    nwTF.delegate = self;
    nwTF.borderStyle = 0;
    nwTF.returnKeyType = UIReturnKeyDone;
    [bg2 addSubview:nwTF];
    
    
    /**************/
    
    bg3 = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-528/2)/2, bg2.frame.origin.y+bg2.frame.size.height+50, 528/2, 92/2) ImageName:@"login_tf_bg.png"];
    [sv addSubview:bg3];
    
    conPwd = [MyControl createLabelWithFrame:CGRectMake(bg3.frame.origin.x+16, bg3.frame.origin.y-20, 200, 20) Font:15 Text:@"确认密码"];
    conPwd.textColor = [ControllerManager colorWithHexString:@"999999"];
    [sv addSubview:conPwd];
    
    conTF = [MyControl createTextFieldWithFrame:CGRectMake(15, 0, bg3.frame.size.width-15, bg3.frame.size.height) placeholder:@"" passWord:YES leftImageView:nil rightImageView:nil Font:17];
    conTF.delegate = self;
    conTF.borderStyle = 0;
    conTF.returnKeyType = UIReturnKeyDone;
    [bg3 addSubview:conTF];
    
    UILabel * tip = [MyControl createLabelWithFrame:CGRectMake(conPwd.frame.origin.x, bg3.frame.origin.y+bg3.frame.size.height+10, bg3.frame.size.width, 20) Font:13 Text:@"提示：在其他设备登录此账号需填写密码"];
    tip.textColor = [UIColor blackColor];
    [sv addSubview:tip];
    
    confirmBtn = [MyControl createButtonWithFrame:CGRectMake(bg3.frame.origin.x, tip.frame.origin.y+40, bg3.frame.size.width, bg3.frame.size.height) ImageName:@"" Target:self Action:@selector(confirmBtnClick) Title:@"确定"];
    confirmBtn.backgroundColor = ORANGE;
//    [ControllerManager colorWithHexString:@"afafaf"]
    confirmBtn.layer.cornerRadius = 22;
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.showsTouchWhenHighlighted = YES;
    [sv addSubview:confirmBtn];
}

-(void)confirmBtnClick
{
    [oriTF resignFirstResponder];
    [nwTF resignFirstResponder];
    [conTF resignFirstResponder];
    
    if(self.isModify){
        if(!nwTF.text.length || !conTF.text.length || !oriTF.text.length){
            [MyControl popAlertWithView:self.view Msg:@"密码不能为空"];
            return;
        }
        if (![oriTF.text isEqualToString:[USER objectForKey:@"password"]]) {
            [MyControl popAlertWithView:self.view Msg:@"原密码不正确"];
            return;
        }
        if(![nwTF.text isEqualToString:conTF.text]){
            [MyControl popAlertWithView:self.view Msg:@"两次密码不一致"];
            return;
        }
        
    }else{
        if(!nwTF.text.length || !conTF.text.length){
            [MyControl popAlertWithView:self.view Msg:@"密码不能为空"];
            return;
        }
        if(![nwTF.text isEqualToString:conTF.text]){
            [MyControl popAlertWithView:self.view Msg:@"两次密码不一致"];
            return;
        }
    }
    //访问API
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"pwd=%@dog&cat", conTF.text]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", SETPWDAPI, conTF.text, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]] && [[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]){
                if (self.isModify) {
                    [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"修改成功"];
                }else{
                    [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"设置成功"];
                }
                [USER setObject:conTF.text forKey:@"password"];
                [self backBtnClick];
            }else{
                if (self.isModify) {
                    [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"修改失败"];
                }else{
                    [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"设置失败"];
                }
            }
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}

#pragma mark -
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    float a = 0;
    if (textField == oriTF) {
        a = bg1.frame.origin.y;
    }else if(textField == nwTF){
        a = bg2.frame.origin.y;
    }else if(textField == conTF){
        a = bg3.frame.origin.y;
    }
    //目标起始位置
    float targetY = self.view.frame.size.height-220-bg1.frame.size.height;
    if (a>targetY) {
        CGRect rect = sv.frame;
//        if (textField == oriTF) {
            rect.origin.y = targetY-a;
//        }else if(textField == nwTF){
//            rect.origin.y = 64-bg2.frame.origin.y;
//        }else if(textField == conTF){
//            rect.origin.y = 64-bg3.frame.origin.y;
//        }
        [UIView animateWithDuration:0.3 animations:^{
            sv.frame = rect;
        }];
        
    }
//    float a = self.view.frame.size.width/self.view.frame.size.height;
//    float b = 320/480.0;
//    if (a == b) {
//        [UIView animateWithDuration:0.3 animations:^{
//            sv.frame = CGRectMake(0, -30, self.view.frame.size.width, self.view.frame.size.height);
//        }];
//    }
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
//    confirmBtn.backgroundColor = [ControllerManager colorWithHexString:@"afafaf"];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (self.isModify) {
//        
//    }else{
//        if ([nwTF.text length] && [conTF.text length]) {
//            confirmBtn.backgroundColor = ORANGE;
//        }else{
//            confirmBtn.backgroundColor = [ControllerManager colorWithHexString:@"afafaf"];
//        }
//        //
//        if (textField == nwTF && [conTF.text length] && [string length]) {
//            confirmBtn.backgroundColor = ORANGE;
//        }
//        if (textField == conTF && [nwTF.text length] && [string length]) {
//            confirmBtn.backgroundColor = ORANGE;
//        }
//        
//        //
//        if (textField == nwTF && nwTF.text.length == 1 && ![string length]) {
//            confirmBtn.backgroundColor = [ControllerManager colorWithHexString:@"afafaf"];
//        }
//        if (textField == conTF && conTF.text.length == 1 && ![string length]) {
//            confirmBtn.backgroundColor = [ControllerManager colorWithHexString:@"afafaf"];
//        }
//    }
    
    
    return YES;
}

#pragma mark - gesture
-(void)tap:(UIGestureRecognizer *)tap
{
    if (self.isModify) {
        [oriTF resignFirstResponder];
    }
    [nwTF resignFirstResponder];
    [conTF resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
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
