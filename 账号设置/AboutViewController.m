//
//  AboutViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-9-1.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "AboutViewController.h"
#import "PermitViewController.h"
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
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:imageView];
//    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
//    [self.view addSubview:bgImageView];
//    //    self.bgImageView.backgroundColor = [UIColor redColor];
////    NSString * docDir = DOCDIR;
//    NSString * filePath = BLURBG;
//    NSLog(@"%@", filePath);
//    NSData * data = [NSData dataWithContentsOfFile:filePath];
//    //    NSLog(@"%@", data);
//    UIImage * image = [UIImage imageWithData:data];
//    bgImageView.image = image;
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [self.view addSubview:tempView];
}
#pragma mark - 创建导航
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    //    navView.backgroundColor = [UIColor redColor];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
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
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64)];
    sv.contentSize = CGSizeMake(320, 568);
    sv.showsVerticalScrollIndicator = NO;
    [self.view addSubview:sv];
    
    UIImageView * logo = [MyControl createImageViewWithFrame:CGRectMake(118, 89, 85, 85) ImageName:@"about.png"];
    [sv addSubview:logo];
    
    UILabel * title = [MyControl createLabelWithFrame:CGRectMake(100, 190, 120, 20) Font:17 Text:@"宠物星球"];
    title.textColor = [UIColor blackColor];
    title.textAlignment = NSTextAlignmentCenter;
    [sv addSubview:title];
    
    UILabel * version = [MyControl createLabelWithFrame:CGRectMake(100, 220, 120, 20) Font:16 Text:[NSString stringWithFormat:@"V%@", [USER objectForKey:@"versionKey"]]];
//    if ([[USER objectForKey:@"version"] isEqualToString:@"1.0"]) {
//        version.text = @"V1.0.0";
//    }else{
//        version.text = [NSString stringWithFormat:@"V%@", [USER objectForKey:@"version"]];
//    }
    version.textColor = [UIColor blackColor];
    version.textAlignment = NSTextAlignmentCenter;
    [sv addSubview:version];
    
    UIButton * sina = [MyControl createButtonWithFrame:CGRectMake(0, 268, 320, 47) ImageName:@"" Target:self Action:@selector(sinaClick) Title:@"新浪微博：宠物星球社交应用"];
    sina.titleLabel.font = [UIFont systemFontOfSize:16];
    [sina setTitleColor:BGCOLOR forState:UIControlStateNormal];
    sina.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
//    sina.showsTouchWhenHighlighted = YES;
    [sv addSubview:sina];
    
    UIButton * wechat = [MyControl createButtonWithFrame:CGRectMake(0, 320, 320, 47) ImageName:@"" Target:self Action:@selector(wechatClick) Title:@"微信号：imengstar"];
    wechat.titleLabel.font = [UIFont systemFontOfSize:16];
    [wechat setTitleColor:BGCOLOR forState:UIControlStateNormal];
    wechat.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
//    wechat.showsTouchWhenHighlighted = YES;
    [sv addSubview:wechat];
    
    UIButton * permit = [MyControl createButtonWithFrame:CGRectMake(70, 390, 180, 20) ImageName:@"" Target:self Action:@selector(permitClick) Title:@"宠物星球软件许可及服务条款"];
    permit.titleLabel.font = [UIFont systemFontOfSize:11];
    [permit setTitleColor:BGCOLOR forState:UIControlStateNormal];
    [sv addSubview:permit];
    
    UILabel * phone = [MyControl createLabelWithFrame:CGRectMake(118/2, 856/2, 200, 20) Font:15 Text:@"联系我们："];
    phone.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    [sv addSubview:phone];
    
    UILabel * mail = [MyControl createLabelWithFrame:CGRectMake(118/2, 450, 220, 20) Font:12 Text:@"邮箱：contact@imengstar.com"];
    mail.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    [sv addSubview:mail];
    
//    UILabel * fax = [MyControl createLabelWithFrame:CGRectMake(57, 470, 220, 20) Font:14 Text:@"传真：111111111111fafafafa"];
//    fax.textColor = [UIColor blackColor];
//    [sv addSubview:fax];
    
    UILabel * copyright = [MyControl createLabelWithFrame:CGRectMake(118/2, 470, self.view.frame.size.width-118/2, 20) Font:12 Text:@"版权所有：北京市爱迪通信有限责任公司"];
//    copyright.textAlignment = NSTextAlignmentCenter;
    copyright.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
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
    PermitViewController * vc = [[PermitViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
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
