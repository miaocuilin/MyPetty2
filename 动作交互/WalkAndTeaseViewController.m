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
//    [self createBottom];
}
- (void)createWebView
{
    protWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:protWebView];
//    protWebView.delegate = self;
    
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.aid]];
    if (!self.isFromBanner) {
        self.URL = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", HAVEFUNAPI, self.aid, sig, [ControllerManager getSID]];
    }
    
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
    if (self.isFromBanner) {
        titleLabel.text = @"宠物星球";
    }
    
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
    if (self.isFromBanner) {
        if (!isMoreCreated) {
            //create more
            isMoreCreated = YES;
            [self createMore];
        }
        //show more
        menuBgBtn.hidden = NO;
        CGRect rect = moreView.frame;
        rect.origin.y -= rect.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            moreView.frame = rect;
            menuBgBtn.alpha = 0.5;
        }];
        return;
    }
    //强制分享图片
//    UIImage * image = nil;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//    if (self.isFromBanner) {
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.URL;
//        image = [UIImage imageNamed:@"oops.png"];
//    }else{
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@", HITBUGS, self.aid];
//        self.content = @"痒痒痒，快给本宫挠挠！";
//        image = [UIImage imageNamed:@"oops.png"];
//    }
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"痒痒痒，快给本宫挠挠！";
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:[UIImage imageNamed:@"oops.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
            [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"分享成功"];
//            StartLoading;
//            [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
        }else{
            [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"分享失败"];
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

#pragma mark - 创建更多视图
-(void)createMore
{
    menuBgBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:nil];
    menuBgBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:menuBgBtn];
    menuBgBtn.alpha = 0;
    menuBgBtn.hidden = YES;
    
    // 318*234
    moreView = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 120)];
    moreView.backgroundColor = [ControllerManager colorWithHexString:@"efefef"];
    [self.view addSubview:moreView];
    
    //orange line
    UIView * orangeLine = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 4)];
    orangeLine.backgroundColor = [ControllerManager colorWithHexString:@"fc7b51"];
    [moreView addSubview:orangeLine];
    //label
    UILabel * shareLabel = [MyControl createLabelWithFrame:CGRectMake(15, 10, 80, 15) Font:13 Text:@"分享到"];
    shareLabel.textColor = [UIColor blackColor];
    [moreView addSubview:shareLabel];
    //3个按钮
    NSArray * arr = @[@"more_weixin.png", @"more_friend.png", @"more_sina.png"];
    NSArray * arr2 = @[@"微信好友", @"朋友圈", @"微博"];
    for(int i=0;i<3;i++){
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(40+i*92, 33, 42, 42) ImageName:arr[i] Target:self Action:@selector(shareClick:) Title:nil];
        button.tag = 200+i;
        [moreView addSubview:button];
        
        CGRect rect = button.frame;
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(rect.origin.x-10, rect.origin.y+rect.size.height+5, rect.size.width+20, 15) Font:12 Text:arr2[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        //        label.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [moreView addSubview:label];
    }
}

#pragma mark - 分享截图
-(void)shareClick:(UIButton *)button
{
    [self cancelBtnClick];
    
    UIImageView * imageView = [MyControl createImageViewWithFrame:CGRectZero ImageName:@""];
    [self.view addSubview:imageView];
//    [MobClick event:@"photo_share"];
    
    if(button.tag == 200){
        NSLog(@"微信");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.URL;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.share_title;
        
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@banner/%@", IMAGEURL, self.icon]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.share_des image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                    
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        //                [self loadShakeShare];
                        [MyControl popAlertWithView:self.view Msg:@"分享成功"];
                    }else{
                        [MyControl popAlertWithView:self.view Msg:@"分享失败"];
                    }
                    
                }];
            }
        }];
    }else if(button.tag == 201){
        NSLog(@"朋友圈");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.URL;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.share_title;
//        NSLog(@"%@", [NSString stringWithFormat:@"%@banner/%@", IMAGEURL, self.icon]);
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@banner/%@", IMAGEURL, self.icon]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"分享成功"];
                        //            StartLoading;
                        //            [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
                    }else{
                        [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"分享失败"];
                    }
                    
                }];
            }
        }];
    }else if(button.tag == 202){
        NSLog(@"微博");
        NSString * str = [NSString stringWithFormat:@"%@%@（分享自@宠物星球社交应用）", self.share_des, self.URL];
        
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@banner/%@", IMAGEURL, self.icon]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                    
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        //                [self loadShakeShare];
                        [MyControl popAlertWithView:self.view Msg:@"分享成功"];
                    }else{
                        NSLog(@"失败原因：%@", response);
                        [MyControl popAlertWithView:self.view Msg:@"分享失败"];
                    }
                    
                }];
            }
        }];
        
    }
}
-(void)cancelBtnClick
{
    NSLog(@"cancel");
    CGRect rect = moreView.frame;
    rect.origin.y += rect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        moreView.frame = rect;
        menuBgBtn.alpha = 0;
    } completion:^(BOOL finished) {
        menuBgBtn.hidden = YES;
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
