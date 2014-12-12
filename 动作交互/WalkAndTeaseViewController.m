//
//  WalkAndTeaseViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-9-17.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "WalkAndTeaseViewController.h"

@interface WalkAndTeaseViewController ()<UIWebViewDelegate>
{
    UIWebView *protWebView;
}
@end

@implementation WalkAndTeaseViewController

- (void)viewDidLoad

{
    
    NSLog(@"viewDidLoad");
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [MobClick event:@"play"];
    
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.png"];
    [self.view addSubview:imageView];
    
    [self createWebView];
    [self createFakeNavigation];
    
}
- (void)createWebView
{
    protWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:protWebView];
//    protWebView.delegate = self;
    
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.aid]];
    self.URL = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", HAVEFUNAPI, self.aid, sig, [ControllerManager getSID]];
    NSLog(@"%@", self.URL);
    NSURL *url = [[NSURL alloc]initWithString:self.URL];
    [protWebView loadRequest:[NSURLRequest requestWithURL:url]];
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
    //    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"游乐园"];
//    titleLabel.text = self.titleString;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
//    UIImageView * searchImageView = [MyControl createImageViewWithFrame:CGRectMake(320-50-10, 33, 100/2, 56/2) ImageName:@"inviteBtn.png"];
//    [navView addSubview:searchImageView];
    
    UIButton * shareBtn = [MyControl createButtonWithFrame:CGRectMake(320-50-10, 33-5, 100/2, 56/2) ImageName:@"inviteBtn.png" Target:self Action:@selector(shareBtnClick) Title:@"分享"];
    //    searchBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    shareBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:shareBtn];
    
//    UIView * line0 = [MyControl createViewWithFrame:CGRectMake(0, 63, 320, 1)];
//    line0.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.1];
//    [navView addSubview:line0];
}
-(void)shareBtnClick
{
    //强制分享图片
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@", HITBUGS, self.aid];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"痒痒痒，快给本宫挠挠！" image:[UIImage imageNamed:@"oops.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
            StartLoading;
            [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
        }else{
            StartLoading;
            [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
        }
        
    }];
}
- (void)backBtnClick
{
    NSLog(@"dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
}

//几个代理方法

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidStartLoad");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    
    NSLog(@"webViewDidFinishLoad");
    
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    
    NSLog(@"DidFailLoadWithError");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
