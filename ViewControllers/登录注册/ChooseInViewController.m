//
//  ChooseInViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-1.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ChooseInViewController.h"
#import "RegisterViewController.h"
#import "ChooseFamilyViewController.h"
@interface ChooseInViewController ()

@end

@implementation ChooseInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BGCOLOR3;
    
    [self createUI];
}

-(void)createUI
{
    UIView * statusView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 20)];
    statusView.backgroundColor = BGCOLOR;
    [self.view addSubview:statusView];
    
    ambassadorMessage = [MyControl createLabelWithFrame:CGRectMake(120, 60, 140, 40) Font:15 Text:nil];
    ambassadorMessage.font = [UIFont boldSystemFontOfSize:15];
    if (_isMi) {
        ambassadorMessage.text = @"我 是 喵 星 大 使，\n欢 迎 来 到 喵 星！";
    }else{
        ambassadorMessage.text = @"我 是 汪 星 大 使，\n欢 迎 来 到 汪 星！";
    }
//    Timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateAmbassadorMessage) userInfo:nil repeats:YES];
    [self.view addSubview:ambassadorMessage];
    
    
    UIImageView * ambassador = [MyControl createImageViewWithFrame:CGRectMake(430/2, 200/2, 170/2, 180/2) ImageName:@""];
    if (_isMi) {
        ambassador.image = [UIImage imageNamed:@"catAmbassador.png"];
    }else{
        ambassador.image = [UIImage imageNamed:@"dogAmbassador.png"];
    }
    [self.view addSubview:ambassador];
    
    UIImageView * cloud = [MyControl createImageViewWithFrame:CGRectMake(17, 400/2, 572/2, 342/2) ImageName:@"2-c.png"];
    [self.view addSubview:cloud];
    
    /************Mi*************/
//    UIImageView * haveBg = [MyControl createImageViewWithFrame:CGRectMake(130/2-10, 15, 373/2+10, 95/2) ImageName:@""];
//    haveBg.image = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2-e" ofType:@"png"]] stretchableImageWithLeftCapWidth:130 topCapHeight:0];
//    [cloud addSubview:haveBg];
//    
//    UILabel * haveLable1 = [MyControl createLabelWithFrame:CGRectMake(10+3, 0, 50, 20) Font:14 Text:@"有喵喵"];
//    if (!_isMi) {
//        haveLable1.text = @"有汪汪";
//    }
//    [haveBg addSubview:haveLable1];
//    
//    UILabel * haveLable2 = [MyControl createLabelWithFrame:CGRectMake(10+5, 22, 170, 20) Font:14 Text:@"立 刻 创 建 喵 喵 的 王 国"];
//    haveLable2.font = [UIFont boldSystemFontOfSize:15];
//    if (!_isMi) {
//        haveLable2.text = @"立 刻 创 建 汪 汪 的 家 族";
//    }
//    [haveBg addSubview:haveLable2];
    
    UIImageView * haveBg = [MyControl createImageViewWithFrame:CGRectMake(55, 175, 434/2, 167/2) ImageName:@""];
    if (_isMi) {
        haveBg.image = [UIImage imageNamed:@"haveCat.png"];
    }else{
        haveBg.image = [UIImage imageNamed:@"haveDog.png"];
    }
    [self.view addSubview:haveBg];
    
    UIButton * haveBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, haveBg.frame.size.width, haveBg.frame.size.height) ImageName:@"" Target:self Action:@selector(haveBtnClick) Title:nil];
    [haveBg addSubview:haveBtn];
    /************Wa*************/
//    UIImageView * notHaveBg = [MyControl createImageViewWithFrame:CGRectMake(130/2-10, 70, 373/2+10, 95/2) ImageName:@""];
//    notHaveBg.image = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2-d" ofType:@"png"]] stretchableImageWithLeftCapWidth:30 topCapHeight:0];
//    [cloud addSubview:notHaveBg];
    
//    UILabel * notHaveLable1 = [MyControl createLabelWithFrame:CGRectMake(250/2+13, 0, 50, 20) Font:14 Text:@"没喵喵"];
//    if (!_isMi) {
//        notHaveLable1.text = @"没汪汪";
//    }
//    [notHaveBg addSubview:notHaveLable1];
//    
//    UILabel * notHaveLable2 = [MyControl createLabelWithFrame:CGRectMake(10-5, 22, 190, 20) Font:14 Text:@"快 来 加 入 萌 猫 们 的 王 国"];
//    notHaveLable2.font = [UIFont boldSystemFontOfSize:15];
//    if (!_isMi) {
//        notHaveLable2.text = @"快 来 加 入 萌 狗 们 的 家 族";
//    }
//    [notHaveBg addSubview:notHaveLable2];
    
    UIImageView * notHaveBg = [MyControl createImageViewWithFrame:CGRectMake(55, 520/2, 434/2, 167/2) ImageName:@""];
    if (_isMi) {
        notHaveBg.image = [UIImage imageNamed:@"noCat.png"];
    }else{
        notHaveBg.image = [UIImage imageNamed:@"noDog.png"];
    }
    [self.view addSubview:notHaveBg];
    
    UIButton * notHaveBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, haveBg.frame.size.width, haveBg.frame.size.height) ImageName:@"" Target:self Action:@selector(notHaveBtnClick) Title:nil];
    [notHaveBg addSubview:notHaveBtn];
    /******************************/
    UIImageView * earth = [MyControl createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height-100, 320, 219/2) ImageName:@"2-b.png"];
    [self.view addSubview:earth];
    
    UIImageView * switchBg = [MyControl createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height-45, 150, 45) ImageName:@""];
    switchBg.image = [[UIImage imageNamed:@"switchBg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [self.view addSubview:switchBg];
    
    UIImageView * head = [MyControl createImageViewWithFrame:CGRectMake(2, 2, 60, 40) ImageName:@"dogHead.png"];
    if (!_isMi) {
        head.frame = CGRectMake(2, 2, 40, 40);
        head.image = [UIImage imageNamed:@"catHead.png"];
    }
    [switchBg addSubview:head];
    
    UILabel * label = [MyControl createLabelWithFrame:CGRectMake(60, 12, 80, 20) Font:15 Text:@"切换到喵星"];
    if (_isMi) {
        label.text = @"切换到汪星";
    }
    label.textColor = [UIColor colorWithRed:250/255.0 green:162/255.0 blue:134/255.0 alpha:1];
    [switchBg addSubview:label];
    
    UIButton * switchBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 150, 45) ImageName:@"" Target:self Action:@selector(switchBtnClick) Title:nil];
    [switchBg addSubview:switchBtn];
}
-(void)switchBtnClick
{
    if (_isMi) {
        _isMi = NO;
        NSLog(@"切换到汪星");
    }else{
        _isMi = YES;
        NSLog(@"切换到喵星");
    }
    for (int i=0; i<8; i++) {
        [self.view.subviews[0] removeFromSuperview];
    }
    [self createUI];
}


//-(void)updateAmbassadorMessage
//{
//    if (num == self.ambString.length+1) {
//        [Timer invalidate];
//        Timer = nil;
//        return;
//    }
//    tempString = [self.ambString substringWithRange:NSMakeRange(0, num++)];
//    ambassadorMessage.text = tempString;
//}
-(void)haveBtnClick
{
//    RegisterViewController * vc = [[RegisterViewController alloc] init];
    ChooseFamilyViewController * vc = [[ChooseFamilyViewController alloc] init];
//    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:vc animated:YES completion:nil];
//    [nc release];
    [vc release];
    
    NSLog(@"创建");
//    JDSideMenu * sideMenu = [ControllerManager shareJDSideMenu];
//    [sideMenu setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"30-3" ofType:@"png"]]];
//    [self presentViewController:sideMenu animated:YES completion:nil];
}
-(void)notHaveBtnClick
{
//    RegisterViewController * vc = [[RegisterViewController alloc] init];
    ChooseFamilyViewController * vc = [[ChooseFamilyViewController alloc] init];
//    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:vc animated:YES completion:nil];
//    [nc release];
    [vc release];
    
    NSLog(@"加入");
//    JDSideMenu * sideMenu = [ControllerManager shareJDSideMenu];
//    [sideMenu setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"30-3" ofType:@"png"]]];
//    [self presentViewController:sideMenu animated:YES completion:nil];
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
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
