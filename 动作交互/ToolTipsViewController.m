//
//  ToolTipsViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-8-25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ToolTipsViewController.h"
#define PAGENUMBER 5
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
#pragma mark - 提示注册弹框
- (void)createLoginAlertView
{
    alertView = [self alertViewInit:CGSizeMake(290, 215)];
    
    UIView *bodyView =[self JoinAndBuyBody:224 Title:@"注册"];
    UILabel *descLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2-80, 40, 160, 50) Font:16 Text:@"还木有注册呢~\n快来加入我们的宠物星球吧！"];
    descLabel.textAlignment = NSTextAlignmentCenter;
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

    UIImageView *cancelImageView = [MyControl createImageViewWithFrame:CGRectMake(250, 5, 30, 30) ImageName:@"button_close.png"];
    [bodyView addSubview:cancelImageView];
    
    UIButton *cancelButton = [MyControl createButtonWithFrame:CGRectMake(250, 5, 30, 30) ImageName:nil Target:self Action:@selector(cancelAction:) Title:nil];
    cancelButton.showsTouchWhenHighlighted = YES;
    [bodyView addSubview:cancelButton];
    
    UILabel *sureLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2-50, 160, 100, 35) Font:16 Text:titleString];
    
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
    }else if(sender.tag == 223){
        NSLog(@"赠送");
    }else if (sender.tag == 224){
        NSLog(@"注册");
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
        [self createLoginAlertView];
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
#pragma mark - 弹出送礼界面
- (void)createPresentGiftAlertView
{
    /*
     giftHUD = [self alertViewInit:CGSizeMake(300, 425)];
     UIView *totalView = [self createAlertTitleView:@"给猫君送个礼物吧" titleSize:CGSizeMake(300,425)];
     UIView *totalView = [MyControl createViewWithFrame:CGRectMake(0, 0, 300, 425)];
     totalView.layer.cornerRadius = 10;
     totalView.layer.masksToBounds = YES;
     UIImageView *titleView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 300, 40) ImageName:@"title_bg.png"];
     [totalView addSubview:titleView];
     UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:16 Text:@"给猫君送个礼物吧"];
     titleLabel.textAlignment = NSTextAlignmentCenter;
     [totalView addSubview:titleLabel];
     UIButton *closeButton = [MyControl createButtonWithFrame:CGRectMake(260, 10, 20, 20) ImageName:@"30-1.png" Target:self Action:@selector(colseGiftAction) Title:nil];
     [totalView addSubview:closeButton];
     
     
     UIView *bodyView = nil;
     bodyView = [MyControl createViewWithFrame:CGRectMake(0, 40, 300, 385)];
     bodyView.backgroundColor = [UIColor clearColor];
     UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 385)];
     alphaView.backgroundColor = [UIColor whiteColor];
     alphaView.alpha = 0.8;
     [bodyView addSubview:alphaView];
     [totalView addSubview:bodyView];
     
     */
    UIView *bodyView = [self shopGiftTitle];
    giftScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, bodyView.frame.size.width, bodyView.frame.size.height)];
    giftScrollView.delegate = self;
    giftScrollView.pagingEnabled = YES;
    giftScrollView.showsVerticalScrollIndicator = NO;
    giftScrollView.showsHorizontalScrollIndicator = NO;
    giftScrollView.backgroundColor = [UIColor clearColor];
    
    
    CGSize scrollViewSize = CGSizeMake(bodyView.frame.size.width * PAGENUMBER, giftScrollView.frame.size.height);
    [giftScrollView setContentSize:scrollViewSize];
    int HorizontalDistance = 15;//水平间距
    int VerticalDistance = 10;//垂直间距
    int PageNumber = 1;
    while (PageNumber <= PAGENUMBER ) {
        for (int i = 1; i <= 3; i++)
        {
            for (int j = 1; j<=3; j++) {
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*HorizontalDistance+80*(i-1)+bodyView.frame.size.width * (PageNumber-1), VerticalDistance *j+90*(j-1), 80, 90)];
                imageView.image = [UIImage imageNamed:@"product_bg.png"];
                [giftScrollView addSubview:imageView];
                [imageView release];
                
                UIImageView *productImageView = [MyControl createImageViewWithFrame:CGRectMake(imageView.frame.size.width/2-25, imageView.frame.size.height/2-20, 40, 40) ImageName:[NSString stringWithFormat:@"bother%d_2.png",PageNumber+1]];
                [imageView addSubview:productImageView];
                UILabel *productLabel = [MyControl createLabelWithFrame:CGRectMake(20, 10, imageView.frame.size.width-20, 10) Font:10 Text:@"宠物球球"];
                
                UILabel *numberCoinLabel = [MyControl createLabelWithFrame:CGRectMake(32, 75, 50, 10) Font:13 Text:@"200"];
                numberCoinLabel.textColor =BGCOLOR;
                [imageView addSubview:numberCoinLabel];
                UIImageView *coinImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 75, 10, 10) ImageName:@"gold.png"];
                [imageView addSubview:coinImageView];
                
                productLabel.font = [UIFont boldSystemFontOfSize:10];
                productLabel.textColor = [UIColor grayColor];
                [imageView addSubview:productLabel];
                
                UILabel *leftCornerLabel1 =[MyControl createLabelWithFrame:CGRectMake(-3, 4, 20, 8) Font:7 Text:@"人气"];
                leftCornerLabel1.textAlignment = NSTextAlignmentCenter;
                leftCornerLabel1.font = [UIFont boldSystemFontOfSize:8];
                CGAffineTransform transform =  CGAffineTransformMakeRotation(-45.0 *M_PI / 180.0);
                leftCornerLabel1.transform = transform;
                UILabel *leftCornerLabel2 = [MyControl createLabelWithFrame:CGRectMake(3, 10, 20, 8) Font:10 Text:@"+50"];
                leftCornerLabel2.textAlignment = NSTextAlignmentCenter;
                leftCornerLabel2.transform = transform;
                [imageView addSubview:leftCornerLabel1];
                [imageView addSubview:leftCornerLabel2];
                //
                //                UIButton *productButton = [MyControl createButtonWithFrame:CGRectMake(i*HorizontalDistance+80*(i-1)+bodyView.frame.size.width * (PageNumber-1), VerticalDistance *j+90*(j-1), 80, 90) ImageName:nil Target:self Action:@selector(productBuyAction:) Title:nil];
                //                NSString *string = [NSString stringWithFormat:@"%d%d%d",PageNumber,j,i];
                //                NSLog(@"string %@",string);
                //                productButton.tag = [string intValue] *10;
                //
                //                [giftScrollView addSubview:productButton];
                
            }
        }
        PageNumber++;
    }
    
    for(int i=0;i<45;i++){
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(HorizontalDistance+i/9*320+i%3*(HorizontalDistance +80), VerticalDistance+i%9/3*(VerticalDistance + 90), 80, 90) ImageName:nil Target:self Action:@selector(productBuyAction:) Title:nil];
        [giftScrollView addSubview:button];
        button.tag = 1000+i;
    }
    
    giftPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 310, giftScrollView.frame.size.width, 20)];
    giftPageControl.backgroundColor = [UIColor clearColor];
    giftPageControl.userInteractionEnabled = NO;
    giftPageControl.numberOfPages = PAGENUMBER;
    giftPageControl.currentPageIndicatorTintColor = BGCOLOR;
    giftPageControl.pageIndicatorTintColor = [UIColor grayColor];
    [bodyView addSubview:giftScrollView];
    [bodyView addSubview:giftPageControl];
    [giftScrollView release];
    [giftPageControl release];
    UILabel *giftLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 - 110, 335, 215, 40) Font:16 Text:@"去商城"];
    giftLabel.textAlignment = NSTextAlignmentCenter;
    giftLabel.backgroundColor = BGCOLOR;
    giftLabel.layer.cornerRadius = 5;
    giftLabel.layer.masksToBounds = YES;
    [bodyView addSubview:giftLabel];
    
    UIButton *giftButton = [MyControl createButtonWithFrame:giftLabel.frame ImageName:nil Target:self Action:@selector(GoShoppingAction:) Title:nil];
    giftButton.showsTouchWhenHighlighted = YES;
    [bodyView addSubview:giftButton];
    
    
    //    giftHUD.customView = totalView;
    [giftHUD show:YES];
    //    [giftHUD hide:YES afterDelay:2.0];
}
- (void)GoShoppingAction:(UIButton *)sender
{
    NSLog(@"去商城");
    [giftHUD hide:YES];
    [self createRealityNoMoneyAlertView];
}
- (void)colseGiftAction
{
    [giftHUD hide:YES];
    giftHUD.completionBlock = ^{
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    };
    
}

- (void)productBuyAction:(UIButton *)sender
{
    NSLog(@"购买");
    NSLog(@"tag:%d",sender.tag);
    [giftHUD hide:YES];
    [self createStroyNoMoneyAlertView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(giftScrollView.contentOffset.x) / giftScrollView.frame.size.width;
    giftPageControl.currentPage = index;
}

#pragma mark - 虚拟充值界面
- (void)createStroyNoMoneyAlertView
{
    UIView *bodyView = [self shopGiftTitle];
    UIImageView *productBGImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 20, 85, 85) ImageName:@"product_bg.png"];
    [bodyView addSubview:productBGImageView];
    
    UIImageView *productImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 25, 40, 40) ImageName:@"bother1_2.png"];
    [productBGImageView addSubview:productImageView];
    UIImageView *goldCoinImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 65, 13, 13) ImageName:@"gold.png"];
    [productBGImageView addSubview:goldCoinImageView];
    UILabel *goldCoinLabel = [MyControl createLabelWithFrame:CGRectMake(35, 63, 50, 20) Font:12 Text:@"2000"];
    goldCoinLabel.textColor = BGCOLOR;
    [productBGImageView addSubview:goldCoinLabel];
    
    UILabel *titleLabel = [MyControl createLabelWithFrame:CGRectMake(20, 5, 50, 20) Font:10 Text:@"宠物食盆"];
    titleLabel.textColor = [UIColor grayColor];
    [productBGImageView addSubview:titleLabel];
    
    UILabel *leftCornerLabel1 =[MyControl createLabelWithFrame:CGRectMake(-1, 3, 15, 12) Font:7 Text:@"人气"];
    leftCornerLabel1.textAlignment = NSTextAlignmentCenter;
    leftCornerLabel1.font = [UIFont boldSystemFontOfSize:7];
    CGAffineTransform transform =  CGAffineTransformMakeRotation(-45.0 *M_PI / 180.0);
    leftCornerLabel1.transform = transform;
    UILabel *leftCornerLabel2 = [MyControl createLabelWithFrame:CGRectMake(0, 10, 20, 12) Font:10 Text:@"+50"];
    leftCornerLabel2.textAlignment = NSTextAlignmentRight;
    leftCornerLabel2.transform = transform;
    [productBGImageView addSubview:leftCornerLabel1];
    [productBGImageView addSubview:leftCornerLabel2];
    
    
    UILabel *sorryLabel = [MyControl createLabelWithFrame:CGRectMake(110, 50, 150, 20) Font:12 Text:@"对不起，您的金币余额不足"];
    sorryLabel.textColor = [UIColor grayColor];
    [bodyView addSubview:sorryLabel];
    UILabel *recommendLabel = [MyControl createLabelWithFrame:CGRectMake(30, 140, 100, 15) Font:12 Text:@"推荐金币充值套餐"];
    recommendLabel.textColor = [UIColor grayColor];
    [bodyView addSubview:recommendLabel];
    
    UIView *choosenBuyCardView = [MyControl createViewWithFrame:CGRectMake(25, 160, 260, 125)];
    //    choosenBuyCardView.backgroundColor = [UIColor redColor];
    [bodyView addSubview:choosenBuyCardView];
    
    for (int i= 0; i < 3; i++) {
        UIImageView *buyGoldCoinImageView = [MyControl createImageViewWithFrame:CGRectMake(0, i*40+15, 20, 20) ImageName:@"gold.png"];
        [choosenBuyCardView addSubview:buyGoldCoinImageView];
        
        UILabel *buyGoldCoinLabel = [MyControl createLabelWithFrame:CGRectMake(22, i*40+15, 80, 20) Font:13 Text:@"5000"];
        buyGoldCoinLabel.textColor = BGCOLOR;
        [choosenBuyCardView addSubview:buyGoldCoinLabel];
        
        UILabel *RMBLabel = [MyControl createLabelWithFrame:CGRectMake(choosenBuyCardView.frame.size.width/2 -40, i*40+15, 80, 20) Font:13 Text:@"¥ 5"];
        RMBLabel.textColor = BGCOLOR;
        [choosenBuyCardView addSubview:RMBLabel];
        
        UILabel *buyGoldCoinBGLabel = [MyControl createLabelWithFrame:CGRectMake(200, i*40+10, 60, 25) Font:13 Text:@"购买"];
        buyGoldCoinBGLabel.layer.cornerRadius = 5;
        buyGoldCoinBGLabel.layer.masksToBounds = YES;
        buyGoldCoinBGLabel.textAlignment = NSTextAlignmentCenter;
        buyGoldCoinBGLabel.backgroundColor = BGCOLOR;
        [choosenBuyCardView addSubview:buyGoldCoinBGLabel];
        UIButton *buyGoldCoinButton = [MyControl createButtonWithFrame:buyGoldCoinBGLabel.frame ImageName:nil Target:self Action:@selector(buyGoldCoinAction:) Title:nil];
        buyGoldCoinButton.tag = 444+i;
        buyGoldCoinButton.showsTouchWhenHighlighted = YES;
        [choosenBuyCardView addSubview:buyGoldCoinButton];
        UIView *lineView = [MyControl createViewWithFrame:CGRectMake(0, i*40+38, choosenBuyCardView.frame.size.width, 1)];
        lineView.backgroundColor = [UIColor grayColor];
        lineView.alpha = 0.2;
        [choosenBuyCardView addSubview:lineView];
    }
    
    UILabel *giftLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 - 110, 335, 215, 40) Font:16 Text:@"去充值"];
    giftLabel.textAlignment = NSTextAlignmentCenter;
    giftLabel.backgroundColor = BGCOLOR;
    giftLabel.layer.cornerRadius = 5;
    giftLabel.layer.masksToBounds = YES;
    [bodyView addSubview:giftLabel];
    UIButton *giftButton = [MyControl createButtonWithFrame:giftLabel.frame ImageName:nil Target:self Action:@selector(buyCardAction) Title:nil];
    giftButton.showsTouchWhenHighlighted = YES;
    [bodyView addSubview:giftButton];
    [giftHUD show:YES];
}
- (void)buyGoldCoinAction:(UIButton *)sender
{
    NSLog(@"花费RMB");
}
#pragma mark - 真实物品充值界面
- (void)createRealityNoMoneyAlertView
{
    UIView *bodyView = [self shopGiftTitle];
    
    UIImageView *productBGImageView = [MyControl createImageViewWithFrame:CGRectMake(25, 25, 140, 170) ImageName:@"product_bg1.png"];
    [bodyView addSubview:productBGImageView];
    UIImageView *leftCornerBGImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 40, 40) ImageName:@"product_bg2.png"];
    [productBGImageView addSubview:leftCornerBGImageView];
    
    UIImageView *productImageView = [MyControl createImageViewWithFrame:CGRectMake(35, 10, 70, 90) ImageName:@"cat1.jpg"];
    [productBGImageView addSubview:productImageView];
    
    UILabel *productDescLabel = [MyControl createLabelWithFrame:CGRectMake(productBGImageView.frame.size.width/2 - 52, 105, 105, 35) Font:12 Text:@"维嘉 宠物猫粮 幼猫 海洋鱼味1.2kg"];
    [productDescLabel setTextColor:[UIColor grayColor]];
    [productBGImageView addSubview:productDescLabel];
    
    UIImageView *goldCoinImageView = [MyControl createImageViewWithFrame:CGRectMake(45, 145, 15, 15) ImageName:@"gold.png"];
    [productBGImageView addSubview:goldCoinImageView];
    UILabel *numberCoinLabel = [MyControl createLabelWithFrame:CGRectMake(65, 143, 50, 20) Font:13 Text:@"2000"];
    numberCoinLabel.textColor = BGCOLOR;
    [productBGImageView addSubview:numberCoinLabel];
    
    UIImageView *rightCornerImageView = [MyControl createImageViewWithFrame:CGRectMake(145, 20, 30, 25) ImageName:@"right_corner.png"];
    [bodyView addSubview:rightCornerImageView];
    UILabel *rightCornerLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 30, 25) Font:10 Text:@"新品"];
    rightCornerLabel.textAlignment = NSTextAlignmentCenter;
    [rightCornerImageView addSubview:rightCornerLabel];
    
    UILabel *leftCornerLabel1 =[MyControl createLabelWithFrame:CGRectMake(-2, 1, 20, 15) Font:10 Text:@"人气"];
    leftCornerLabel1.textAlignment = NSTextAlignmentCenter;
    leftCornerLabel1.font = [UIFont boldSystemFontOfSize:8];
    CGAffineTransform transform =  CGAffineTransformMakeRotation(-45.0 *M_PI / 180.0);
    leftCornerLabel1.transform = transform;
    UILabel *leftCornerLabel2 = [MyControl createLabelWithFrame:CGRectMake(0, 8, 30, 15) Font:12 Text:@"+50"];
    leftCornerLabel2.textAlignment = NSTextAlignmentCenter;
    leftCornerLabel2.transform = transform;
    [leftCornerBGImageView addSubview:leftCornerLabel1];
    [leftCornerBGImageView addSubview:leftCornerLabel2];
    
    UILabel *giftLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 - 110, 335, 215, 40) Font:16 Text:@"去充值"];
    giftLabel.textAlignment = NSTextAlignmentCenter;
    giftLabel.backgroundColor = BGCOLOR;
    giftLabel.layer.cornerRadius = 5;
    giftLabel.layer.masksToBounds = YES;
    [bodyView addSubview:giftLabel];
    UIButton *giftButton = [MyControl createButtonWithFrame:giftLabel.frame ImageName:nil Target:self Action:@selector(buyCardAction) Title:nil];
    giftButton.showsTouchWhenHighlighted = YES;
    [bodyView addSubview:giftButton];
    [giftHUD show:YES];
}
- (void)buyCardAction
{
    NSLog(@"充值");
}
- (UIView *)shopGiftTitle
{
    giftHUD = [self alertViewInit:CGSizeMake(300, 425)];
    UIView *totalView = [MyControl createViewWithFrame:CGRectMake(0, 0, 300, 425)];
    totalView.layer.cornerRadius = 10;
    totalView.layer.masksToBounds = YES;
    UIImageView *titleView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 300, 40) ImageName:@"title_bg.png"];
    [totalView addSubview:titleView];
    UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:16 Text:@"给猫君送个礼物吧"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:titleLabel];
    UIImageView *closeImageView = [MyControl createImageViewWithFrame:CGRectMake(260, 10, 20, 20) ImageName:@"30-1.png"];
    [totalView addSubview:closeImageView];
    UIButton *closeButton = [MyControl createButtonWithFrame:CGRectMake(252.5, 2.5, 35, 35) ImageName:nil Target:self Action:@selector(colseGiftAction) Title:nil];
    closeButton.showsTouchWhenHighlighted = YES;
    [totalView addSubview:closeButton];
    
    
    UIView *bodyView = nil;
    bodyView = [MyControl createViewWithFrame:CGRectMake(0, 40, 300, 385)];
    bodyView.backgroundColor = [UIColor clearColor];
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 385)];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 1.0;
    [bodyView addSubview:alphaView];
    [totalView addSubview:bodyView];
    
    giftHUD.customView = totalView;
    
    return bodyView;
}
@end
