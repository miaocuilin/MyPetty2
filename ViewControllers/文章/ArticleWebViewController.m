//
//  ArticleWebViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/4/13.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "ArticleWebViewController.h"

@interface ArticleWebViewController () <UMSocialUIDelegate>
{
    BOOL isMoreCreated;
}
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UIButton *menuBgBtn;
@property(nonatomic,strong)UIView *moreView;
@end

@implementation ArticleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createFakeNavigation];
}

-(void)createFakeNavigation
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:imageView];

    [self createWebView];
    
    UIView *navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 22, 60, 40) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    //    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"宠物星球"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIButton * shareBtn = [MyControl createButtonWithFrame:CGRectMake(320-50-10, 33-5, 100/2, 56/2) ImageName:@"inviteBtn.png" Target:self Action:@selector(shareBtnClick) Title:@"分享"];

    shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    shareBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:shareBtn];

}

-(void)shareBtnClick
{
    if (!isMoreCreated) {
        //create more
        isMoreCreated = YES;
        [self createMore];
    }
    //show more
    self.menuBgBtn.hidden = NO;
    CGRect rect = self.moreView.frame;
    rect.origin.y -= rect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.moreView.frame = rect;
        self.menuBgBtn.alpha = 0.5;
    }];
}
- (void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
-(void)createWebView
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.url]]];
}

#pragma mark - 创建更多视图
-(void)createMore
{
    self.menuBgBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:nil];
    self.menuBgBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.menuBgBtn];
    self.menuBgBtn.alpha = 0;
    self.menuBgBtn.hidden = YES;
    
    // 318*234
    self.moreView = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 120)];
    self.moreView.backgroundColor = [ControllerManager colorWithHexString:@"efefef"];
    [self.view addSubview:self.moreView];
    
    //orange line
    UIView * orangeLine = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 4)];
    orangeLine.backgroundColor = [ControllerManager colorWithHexString:@"fc7b51"];
    [self.moreView addSubview:orangeLine];
    //label
    UILabel * shareLabel = [MyControl createLabelWithFrame:CGRectMake(15, 10, 80, 15) Font:13 Text:@"分享到"];
    shareLabel.textColor = [UIColor blackColor];
    [self.moreView addSubview:shareLabel];
    //3个按钮
    NSArray * arr = @[@"more_weixin.png", @"more_friend.png", @"more_sina.png"];
    NSArray * arr2 = @[@"微信好友", @"朋友圈", @"微博"];
    for(int i=0;i<3;i++){
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(40+i*92, 33, 42, 42) ImageName:arr[i] Target:self Action:@selector(shareClick:) Title:nil];
        button.tag = 200+i;
        [self.moreView addSubview:button];
        
        CGRect rect = button.frame;
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(rect.origin.x-10, rect.origin.y+rect.size.height+5, rect.size.width+20, 15) Font:12 Text:arr2[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        //        label.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [self.moreView addSubview:label];
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
        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.model.url;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.model.title;
        
        [imageView setImageWithURL:[NSURL URLWithString:self.model.icon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.model.des image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                    
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
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.model.url;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.model.title;
        //        NSLog(@"%@", [NSString stringWithFormat:@"%@banner/%@", IMAGEURL, self.icon]);
        [imageView setImageWithURL:[NSURL URLWithString:self.model.icon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
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
        NSString * str = [NSString stringWithFormat:@"%@%@（分享自@宠物星球社交应用）", self.model.des, self.model.des];
        
        [imageView setImageWithURL:[NSURL URLWithString:self.model.icon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                BOOL oauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
                NSLog(@"%d", oauth);
                if (oauth) {
                    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                        [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:image socialUIDelegate:self];
                        //设置分享内容和回调对象
                        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
                    }];
                }else{
                    [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:image socialUIDelegate:self];
                    //设置分享内容和回调对象
                    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
                }
                
            }
        }];
        
    }
}
-(void)cancelBtnClick
{
    NSLog(@"cancel");
    CGRect rect = self.moreView.frame;
    rect.origin.y += rect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.moreView.frame = rect;
        self.menuBgBtn.alpha = 0;
    } completion:^(BOOL finished) {
        self.menuBgBtn.hidden = YES;
    }];
}
@end
