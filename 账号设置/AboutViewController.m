//
//  AboutViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-9-1.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    [self createBg];
    [self createUI];
    [self createFakeNavigation];
}
-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"%@", data);
    UIImage * image = [UIImage imageWithData:data];
    bgImageView.image = image;
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:tempView];
}
#pragma mark - 创建导航
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    //    navView.backgroundColor = [UIColor redColor];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    //    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(100, 64-39, 120, 30) Font:17 Text:@"关于我们"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleBgLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
    [navView addSubview:titleLabel];
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createUI
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    sv.contentSize = CGSizeMake(320, 568);
    [self.view addSubview:sv];
    
    UIImageView * logo = [MyControl createImageViewWithFrame:CGRectMake(118, 89, 85, 85) ImageName:@"about.png"];
    [sv addSubview:logo];
    
    UILabel * title = [MyControl createLabelWithFrame:CGRectMake(100, 190, 120, 20) Font:17 Text:@"宠物星球"];
    title.textColor = [UIColor blackColor];
    title.textAlignment = NSTextAlignmentCenter;
    [sv addSubview:title];
    
    UILabel * version = [MyControl createLabelWithFrame:CGRectMake(100, 220, 120, 20) Font:16 Text:@"V1.0"];
    version.textColor = [UIColor blackColor];
    version.textAlignment = NSTextAlignmentCenter;
    [sv addSubview:version];
    
    UIButton * sina = [MyControl createButtonWithFrame:CGRectMake(0, 268, 320, 47) ImageName:@"" Target:self Action:@selector(sinaClick) Title:@"关注宠物星球新浪微博"];
    sina.titleLabel.font = [UIFont systemFontOfSize:16];
    [sina setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sina.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    sina.showsTouchWhenHighlighted = YES;
    [sv addSubview:sina];
    
    UIButton * wechat = [MyControl createButtonWithFrame:CGRectMake(0, 320, 320, 47) ImageName:@"" Target:self Action:@selector(wechatClick) Title:@"关注宠物星球微信公众平台"];
    wechat.titleLabel.font = [UIFont systemFontOfSize:16];
    [wechat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    wechat.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    wechat.showsTouchWhenHighlighted = YES;
    [sv addSubview:wechat];
    
    UIButton * permit = [MyControl createButtonWithFrame:CGRectMake(70, 394, 180, 20) ImageName:@"" Target:self Action:@selector(permitClick) Title:@"宠物星球软件许可及服务条款"];
    permit.titleLabel.font = [UIFont systemFontOfSize:13];
    [permit setTitleColor:BGCOLOR forState:UIControlStateNormal];
    [sv addSubview:permit];
    
    UILabel * phone = [MyControl createLabelWithFrame:CGRectMake(57, 420, 200, 20) Font:15 Text:@"联系我们：686868"];
    phone.textColor = [UIColor blackColor];
    [sv addSubview:phone];
    
    UILabel * mail = [MyControl createLabelWithFrame:CGRectMake(57, 450, 220, 20) Font:14 Text:@"邮箱：chongwuxingqiu@li.com"];
    mail.textColor = [UIColor blackColor];
    [sv addSubview:mail];
    
    UILabel * fax = [MyControl createLabelWithFrame:CGRectMake(57, 470, 220, 20) Font:14 Text:@"传真：111111111111fafafafa"];
    fax.textColor = [UIColor blackColor];
    [sv addSubview:fax];
    
    UILabel * copyright = [MyControl createLabelWithFrame:CGRectMake(0, 500, 320, 20) Font:12 Text:@"Copyright © 2013-2014 Aidigame.All Rights Reserved."];
    copyright.textAlignment = NSTextAlignmentCenter;
    copyright.textColor = [UIColor blackColor];
    [sv addSubview:copyright];
    
}
-(void)sinaClick
{
    NSLog(@"sina");
}
-(void)wechatClick
{
    NSLog(@"wechat");
}
-(void)permitClick
{
    NSLog(@"permit");
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
