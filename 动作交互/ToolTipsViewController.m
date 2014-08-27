//
//  ToolTipsViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-8-25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ToolTipsViewController.h"

@interface ToolTipsViewController ()

@end

@implementation ToolTipsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.coinNumber = 10;
    self.continuousDay = 1;
    self.expLevel = 20;
    self.countryName = @"猫国君";
    self.positionName = @"喵骑士";
    self.headImageName = @"cat1.jpg";
//    self.expCoinNum = 100;
    [self createButton];
}
#pragma mark - 每日登陆、官职升级、等级升级弹窗
//经验值升级奖励弹窗
-(void)createExpAlertView
{
    expHUD = [self alertViewInit:CGSizeMake(235.0f, 340.0f)];
    
    UIView *alertTotalView = [self createAlertTitleView:@"经验值升级奖励领取" titleSize:CGSizeMake(235, 340)];
    UIView *bodyView = [self createAlertBodyView:111];
    [alertTotalView addSubview:bodyView];
    
    UIImageView *imageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2 - 85, 5, 170, 100) ImageName:@"expLevel.png"];
    [bodyView addSubview:imageView];
    
    UILabel *expLevelLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 - 50, 30, 100, 20) Font:20 Text:[NSString stringWithFormat:@"%d",self.expLevel]];
    expLevelLabel.textAlignment = NSTextAlignmentCenter;
    [bodyView addSubview:expLevelLabel];
    
    UILabel *expNumberLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2, 150, 100, 30) Font:15 Text:[NSString stringWithFormat:@"+ %d",self.coinNumber]];
    expNumberLabel.textColor = BGCOLOR;
    [bodyView addSubview:expNumberLabel];
    UIImageView *coinImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2-35, 150, 30, 30) ImageName:@"gold.png"];
    [bodyView addSubview:coinImageView];
    UILabel *descLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2-100, 190, 200, 40) Font:13 Text:[NSString stringWithFormat:@"星球大使为了恭喜您的升级，特意准备了%d个金币",self.coinNumber]];
    descLabel.textColor = [UIColor grayColor];
    [bodyView addSubview:descLabel];
    
    expHUD.customView = alertTotalView;
    [expHUD show:YES];
}
//官职升级奖励弹窗

- (void)createGovernmentAlertView
{
    governmentHUD = [self alertViewInit:CGSizeMake(235.0f, 340.0f)];
    UIView *alertTotalView = [self createAlertTitleView:@"官职升级奖励领取" titleSize:CGSizeMake(235, 340)];
    UIView *bodyView = [self createAlertBodyView:112];
    [alertTotalView addSubview:bodyView];
    
    UIImageView *headImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2 - 35, 10, 70, 70) ImageName:self.headImageName];
    headImageView.layer.cornerRadius = 35;
    headImageView.layer.masksToBounds = YES;
    [bodyView addSubview:headImageView];
    
    UIImageView *imageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2 - 85, 5, 170, 100) ImageName:@"governmentLevel.png"];
    [bodyView addSubview:imageView];
    
    UILabel *countryLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 -50, 100, 100, 20) Font:12 Text:[NSString stringWithFormat:@"%@",self.countryName]];
    countryLabel.textAlignment = NSTextAlignmentCenter;
    countryLabel.textColor = [UIColor grayColor];
    [bodyView addSubview:countryLabel];
    
    UILabel *positionLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 - 50, 130, 100, 20) Font:15 Text:[NSString stringWithFormat:@"%@",self.positionName]];
    positionLabel.textColor = BGCOLOR;
    positionLabel.textAlignment = NSTextAlignmentCenter;
    [bodyView addSubview:positionLabel];
    
    
    UILabel *coinNumLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2-5, 167, 100, 20) Font:15 Text:[NSString stringWithFormat:@"+ %d",self.coinNumber]];
    coinNumLabel.textColor = BGCOLOR;
    [bodyView addSubview:coinNumLabel];
    
    UIImageView *coinImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2 - 35, 165, 25, 25) ImageName:@"gold.png"];
    [bodyView addSubview:coinImageView];
    
    UILabel *descLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2-100, 200,  200, 40) Font:13 Text:[NSString stringWithFormat:@"星球大使为了恭喜您的升级，特意准备了%d个金币~",self.coinNumber]];
    descLabel.textColor = [UIColor grayColor];
    [bodyView addSubview:descLabel];
    
    governmentHUD.customView = alertTotalView;
    [governmentHUD show:YES];
}

//每日登陆奖励弹窗
- (void)createAlertView
{
    loginHUD = [self alertViewInit:CGSizeMake(235.0f, 340.0f)];
    UIView *alertTotalView = [self createAlertTitleView:@"每日登陆奖励" titleSize:CGSizeMake(235, 340)];
    UIView *bodyView = [self createAlertBodyView:110];
    
    UIImageView *moneyImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2-30, 55, 60, 60) ImageName:@"gold.png"];
    [bodyView addSubview:moneyImageView];

    UILabel *numberMoney = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2-50, 30, 100, 20) Font:18 Text:[NSString stringWithFormat:@"+ %d",self.coinNumber]];
    numberMoney.textAlignment = NSTextAlignmentCenter;
    numberMoney.textColor = BGCOLOR;
    [bodyView addSubview:numberMoney];
//    (bodyView.frame.size.width/2-100, 200,  200, 40)

    UILabel *desc1Label = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2-100, 150, 200, 40) Font:13 Text:[NSString stringWithFormat:@"星球大使为了欢迎您的到来，特意准备了%d个金币~",self.coinNumber]];
    desc1Label.textColor = [UIColor grayColor];
    [bodyView addSubview:desc1Label];
    
    UILabel *desc2Label = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2-100, 190, 200, 40) Font:13 Text:[NSString stringWithFormat:@"星球提示：已经连续登陆%d天,明日可领取%d",self.continuousDay,(self.coinNumber+100) ]];
    desc2Label.textColor = [UIColor grayColor];
    [bodyView addSubview:desc2Label];
    
    UIImageView *littleCoin = [MyControl createImageViewWithFrame:CGRectMake(80, 209, 15, 15) ImageName:@"gold.png"];
    [bodyView addSubview:littleCoin];
    
    [alertTotalView addSubview:bodyView];
    loginHUD.customView = alertTotalView;
    [loginHUD show:YES];
}

- (MBProgressHUD *)alertViewInit:(CGSize)widthAndHeight
{
    MBProgressHUD * alertViewInit = [[MBProgressHUD alloc] initWithWindow:self.view.window];
    [self.view.window addSubview:alertViewInit];
    alertViewInit.mode = MBProgressHUDModeCustomView;
    alertViewInit.color = [UIColor clearColor];
    alertViewInit.dimBackground = YES;
    alertViewInit.margin = 0 ;
    alertViewInit.removeFromSuperViewOnHide = YES;
//    alertViewInit.minSize = CGSizeMake(235.0f, 340.0f);
    alertViewInit.minSize = widthAndHeight;
    return alertViewInit;
}
//创建提示框的title
- (UIView *)createAlertTitleView:(NSString *)titleContents titleSize:(CGSize)titleSize
{
//    UIView *alertTotalView = [MyControl createViewWithFrame:CGRectMake(0, 0, 235, 340)];
    UIView *alertTotalView = [MyControl createViewWithFrame:CGRectMake(0, 0, titleSize.width, titleSize.height)];
    alertTotalView.layer.cornerRadius = 10;
    alertTotalView.layer.masksToBounds = YES;
    UIImageView *titleView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, titleSize.width, 40) ImageName:@"title_bg.png"];
    [alertTotalView addSubview:titleView];
    UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:16 Text:titleContents];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [alertTotalView addSubview:titleLabel];
    
    return alertTotalView;
}
//创建提示框的body
- (UIView *)createAlertBodyView:(NSInteger)tagNumber
{
    UIView *bodyView = nil;
    bodyView = [MyControl createViewWithFrame:CGRectMake(0, 40, 235, 300)];
    bodyView.backgroundColor = [UIColor clearColor];
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 235, 300)];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 0.8;
    [bodyView addSubview:alphaView];
    
    //创建button
    UILabel *produceLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2-50, 250, 100, 35) Font:15 Text:@"收下啦"];
    produceLabel.font = [UIFont boldSystemFontOfSize:16];
    produceLabel.backgroundColor = BGCOLOR;
    produceLabel.layer.cornerRadius = 5;
    produceLabel.layer.masksToBounds = YES;
    produceLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *produceButton = [MyControl createButtonWithFrame:produceLabel.frame  ImageName:nil Target:self Action:@selector(produceAction:) Title:nil];
    produceButton.tag = tagNumber;
    produceButton.showsTouchWhenHighlighted = YES;
    [bodyView addSubview:produceLabel];
    [bodyView addSubview:produceButton];
    return bodyView;
}
//点击三个弹窗的点击事件
- (void)produceAction:(UIButton *)sender
{
    NSLog(@"收下了");
    if (sender.tag == 110) {
        [loginHUD hide:YES];
    }else if(sender.tag == 111){
        [expHUD hide:YES];
    }else{
        [governmentHUD hide:YES];
    }
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}
#pragma mark - 礼物购买成功弹窗
//  290*215
- (void)createBuyGiftAlertView
{
    alertView = [self alertViewInit:CGSizeMake(290, 215)];
    UIView *bodyView = [self JoinAndBuyBody:223 Title:@"赠送"];
    UIImageView *giftImageView = [MyControl createImageViewWithFrame:CGRectMake(85,30,45, 75) ImageName:@"cat1.jpg"];
    [bodyView addSubview:giftImageView];
    
    UILabel *giftNumberLabel = [MyControl createLabelWithFrame:CGRectMake(150, 60, 80, 30) Font:16 Text:@"x 2"];
    giftNumberLabel.textColor = BGCOLOR;
    [bodyView addSubview:giftNumberLabel];
    
    UILabel *descLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 - 110, 120, 230, 20) Font:16 Text:@"礼物购买成功，是否现在赠送~"];
    descLabel.textColor = [UIColor grayColor];
    [bodyView addSubview:descLabel];
    alertView.customView = bodyView;
    [alertView show:YES];
}
#pragma mark - 加入国家弹窗
- (void)createJoinCountryAlertView
{
    alertView = [self alertViewInit:CGSizeMake(290, 215)];
    
    UIView *bodyView =[self JoinAndBuyBody:222 Title:@"确认"];
    UILabel *askLabel1 = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 -80, 40, 160, 20) Font:16 Text:@"确定加入一个新国家？"];
    askLabel1.textColor = [UIColor grayColor];
    [bodyView addSubview:askLabel1];
    UILabel *askLabel2 = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 - 80, 70, 160, 20) Font:16 Text:@"这将花费您 100"];
    
    
    askLabel2.textColor = [UIColor grayColor];
    [bodyView addSubview:askLabel2];
    
    UIImageView *coinImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2 +35, 63, 30, 30) ImageName:@"gold.png"];
    [bodyView addSubview:coinImageView];
    
    UILabel *descLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 - 120, 130, 230, 20) Font:13 Text:@"星球提示：每个人最多加入10个圈子"];
    descLabel.textColor = [UIColor grayColor];
    [bodyView addSubview:descLabel];
    alertView.customView = bodyView;
    [alertView show:YES];
}

- (UIView *)JoinAndBuyBody:(NSInteger)tagNumber Title:(NSString *)titleString
{
    UIView *bodyView = [MyControl createViewWithFrame:CGRectMake(0, 0, 290, 215)];
    bodyView.backgroundColor = [UIColor clearColor];
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 215)];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 0.8;
    [bodyView addSubview:alphaView];
    bodyView.layer.cornerRadius = 10;
    bodyView.layer.masksToBounds = YES;
    
    //创建取消和确认button
    UILabel *cancelLabel = [MyControl createLabelWithFrame:CGRectMake(20, 160, 100, 35) Font:16 Text:@"取消"];
    cancelLabel.backgroundColor = [UIColor grayColor];
    cancelLabel.layer.cornerRadius = 5;
    cancelLabel.layer.masksToBounds = YES;
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    [bodyView addSubview:cancelLabel];
    
    UIButton *cancelButton = [MyControl createButtonWithFrame:cancelLabel.frame ImageName:nil Target:self Action:@selector(cancelAction:) Title:nil];
    cancelButton.showsTouchWhenHighlighted = YES;
    [bodyView addSubview:cancelButton];
    
    UILabel *sureLabel = [MyControl createLabelWithFrame:CGRectMake(165, 160, 100, 35) Font:16 Text:titleString];
    
    sureLabel.backgroundColor = BGCOLOR;
    sureLabel.layer.cornerRadius = 5;
    sureLabel.layer.masksToBounds = YES;
    sureLabel.textAlignment = NSTextAlignmentCenter;
    [bodyView addSubview:sureLabel];
    
    UIButton *sureButton = [MyControl createButtonWithFrame:sureLabel.frame ImageName:nil Target:self Action:@selector(sureAction:) Title:nil];
    sureButton.showsTouchWhenHighlighted = YES;
    sureButton.tag = tagNumber;
    [bodyView addSubview:sureButton];
    return bodyView;
}

- (void)cancelAction:(UIButton *)sender
{
    NSLog(@"取消");
    [alertView hide:YES];
}

- (void)sureAction:(UIButton *)sender
{
    if (sender.tag == 222) {
        NSLog(@"确认");
    }else{
        NSLog(@"赠送");
    }
}

#pragma mark - 临时button
- (void)createButton
{
    NSArray *array1 = @[@"每日登陆",@"升级经验",@"官职升级"];
    for (int i = 0 ; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(50, 100+(i*100), 100, 100);
        [button setTitle:array1[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    NSArray *array2 = @[@"加入国家",@"购买成功",@"送礼物"];
    for (int i = 0; i < array2.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(150, 100+(i*100), 100, 100);
        [button setTitle:array2[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    
}

- (void)buttonAction:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"每日登陆"]) {
        [self createAlertView];
    }else if ([sender.currentTitle isEqualToString:@"升级经验"]){
        [self createExpAlertView];
    }else if ([sender.currentTitle isEqualToString:@"官职升级"]){
        [self createGovernmentAlertView];
    }else if ([sender.currentTitle isEqualToString:@"加入国家"]){
        NSLog(@"%@",sender.currentTitle);
        [self createJoinCountryAlertView];
    }else if ([sender.currentTitle isEqualToString:@"购买成功"]){
        NSLog(@"%@",sender.currentTitle);
        [self createBuyGiftAlertView];
    }else{
        [self createPresentGiftAlertView];
    }
}
#pragma mark - 
- (void)createPresentGiftAlertView
{
    giftHUD = [self alertViewInit:CGSizeMake(300, 425)];
    UIView *totalView = [self createAlertTitleView:@"给猫君送个礼物吧" titleSize:CGSizeMake(300,425)];
    
    UIView *bodyView = nil;
    bodyView = [MyControl createViewWithFrame:CGRectMake(0, 40, 300, 385)];
    bodyView.backgroundColor = [UIColor clearColor];
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 385)];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 0.8;
    [bodyView addSubview:alphaView];
    [totalView addSubview:bodyView];
    
    giftScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 310)];
    giftScrollView.delegate = self;
    giftScrollView.pagingEnabled = YES;
    giftScrollView.showsVerticalScrollIndicator = YES;
    giftScrollView.showsHorizontalScrollIndicator = YES;
    giftScrollView.backgroundColor = [UIColor clearColor];
    
    CGSize scrollViewSize = CGSizeMake(bodyView.frame.size.width * 4, giftScrollView.frame.size.height);
    [giftScrollView setContentSize:scrollViewSize];
    
    for (int i = 0; i < 4; i++)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + bodyView.frame.size.width*i, 0, bodyView.frame.size.width, 385)];
        imageView.image = [UIImage imageNamed:@"cat1.jpg"];
        [giftScrollView addSubview:imageView];
        [imageView release];
        
    }
    giftPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 310, giftScrollView.frame.size.width, 20)];
    giftPageControl.backgroundColor = [UIColor clearColor];
    giftPageControl.userInteractionEnabled = NO;
    giftPageControl.numberOfPages = 4;
    giftPageControl.currentPageIndicatorTintColor = BGCOLOR;
    giftPageControl.pageIndicatorTintColor = [UIColor grayColor];
    [bodyView addSubview:giftScrollView];
    [bodyView addSubview:giftPageControl];
    [giftScrollView release];
    [giftPageControl release];
    
    
    
    giftHUD.customView = totalView;
    [giftHUD show:YES];
//    [giftHUD hide:YES afterDelay:2.0];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(giftScrollView.contentOffset.x) / giftScrollView.frame.size.width;
    giftPageControl.currentPage = index;
}
@end
