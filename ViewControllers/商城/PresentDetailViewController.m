//
//  PresentDetailViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-8-24.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PresentDetailViewController.h"
#import "SAStepperControl.h"

@interface PresentDetailViewController ()

@end

@implementation PresentDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    presentTitle = @"维嘉 宠物猫粮 幼猫 海洋鱼味1.2kg";
    presentPrice = @"2000";
    presentPopular = @"人气+1000";
    presentLimits = @"1-12月幼猫以及怀孕和哺乳期母猫";
    presentWeight = @"1.2kg";
    presentLife = @"12个月";
    presentPost = @"自取";
    isFromStart= YES;
    
    NSArray *array = @[@"cat1.jpg",@"cat2.jpg",@"cat1.jpg",@"cat2.jpg"];
    imagesArray = [NSMutableArray arrayWithArray:array];
    [self createBg];
    bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    bgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 568);
    [self.view addSubview:bgScrollView];
    [self createScrollViewAndPageControl];
    [self createPresentSimpleDesc];
    [self createPresentDesc];
//    [self createBuyNumber];
    [self createNavgation];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self createBuyNumber];

}

- (void)createBuyNumber
{
    UIView *buyView = [[UIView alloc] initWithFrame:CGRectMake(0, 518, self.view.bounds.size.width, 50)];
    buyView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:buyView];

    sasStepper = [[SAStepperControl alloc] initWithFrame:CGRectMake(90, 10, 80, 20)];
    [buyView addSubview:sasStepper];
    sasStepper.tintColor = [UIColor grayColor];
    UILabel *label1 = [MyControl createLabelWithFrame:CGRectMake(10, 15, 80, 20) Font:15 Text:@"购买数量"];
    label1.textColor = [UIColor grayColor];
    [buyView addSubview:label1];
    
    UILabel *buttonBGLabel = [MyControl createLabelWithFrame:CGRectMake(220, 10, 90, 30) Font:15 Text:@"立即购买"];
    buttonBGLabel.textAlignment = NSTextAlignmentCenter;
    buttonBGLabel.layer.cornerRadius = 5;
    buttonBGLabel.layer.masksToBounds = YES;
    buttonBGLabel.backgroundColor = BGCOLOR;
    [buyView addSubview:buttonBGLabel];
    
    UIButton *buyButton = [MyControl createButtonWithFrame:buttonBGLabel.frame ImageName:nil Target:self Action:@selector(buyAction) Title:nil];
    buyButton.showsTouchWhenHighlighted = YES;
    [buyView addSubview:buyButton];
    
}
- (void)buyAction
{
    NSLog(@"跳转到商城 %d",(int)sasStepper.value);
    [self HUDText:@"你得到了一个魔法棒" showView:self.view yOffset:110];
    [self HUDImageIcon:[UIImage imageNamed:@"gold.png"] showView:self.view yOffset:-40 Number:10];
    [self HUDImageIcon:[UIImage imageNamed:@"gold.png"] showView:self.view yOffset:50 Number:100];
}

- (void)createPresentDesc
{
    NSArray *arrayLeft = @[@"产品名称:",@"适用范围:",@"产品规格:",@"保质期:",@"邮寄方式:"];
    NSArray *arrayRight = @[presentTitle,presentLimits,presentWeight,presentLife,presentPost];
    for (int i = 0 ; i < arrayLeft.count; i++) {
        UILabel *leftLabel = [MyControl createLabelWithFrame:CGRectMake(10, 325 + (i * 35), 80, 20) Font:15 Text:arrayLeft[i]];
        leftLabel.textColor = [UIColor blackColor];
        leftLabel.alpha = 0.6;
        [bgScrollView addSubview:leftLabel];
        
        UILabel *rightLabel = [MyControl createLabelWithFrame:CGRectMake(90, 325 + (i * 35), 220, 20) Font:13 Text:arrayRight[i]];
        rightLabel.textColor = [UIColor blackColor];
        rightLabel.alpha = 0.6;
        [bgScrollView addSubview:rightLabel];
    }
}

- (void)createPresentSimpleDesc
{
    
    UIView *PresentSimpleDescBody = [MyControl createViewWithFrame:CGRectMake(0, 175+64, CGRectGetWidth(self.view.bounds), 65)];
    UIView *alphaView =[MyControl createViewWithFrame:CGRectMake(0, 0, PresentSimpleDescBody.bounds.size.width, PresentSimpleDescBody.bounds.size.height)];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.layer.opacity = 0.2;
    [PresentSimpleDescBody addSubview:alphaView];
    
    UILabel *titleLabel = [MyControl createLabelWithFrame:CGRectMake(10, 15, 250, 18) Font:15 Text:presentTitle];
    titleLabel.textColor = [UIColor blackColor];
    [PresentSimpleDescBody addSubview:titleLabel];
    
    UIImageView *moneyView = [MyControl createImageViewWithFrame:CGRectMake(10, 40, 20, 20) ImageName:@"gold.png"];
    UILabel *priceLabel = [MyControl createLabelWithFrame:CGRectMake(35, 40, 40, 20) Font:15 Text:presentPrice];
    priceLabel.textColor = BGCOLOR;
    [PresentSimpleDescBody addSubview:priceLabel];
    [PresentSimpleDescBody addSubview:moneyView];
    
    UILabel *popularLabel = [MyControl createLabelWithFrame:CGRectMake(260, 40, 60, 15) Font:11 Text:presentPopular];
    popularLabel.textColor = [UIColor grayColor];
    [PresentSimpleDescBody addSubview:popularLabel];
    
    [bgScrollView addSubview:PresentSimpleDescBody];
}

- (void)createScrollViewAndPageControl
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 175)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    
    CGSize scrollViewSize = CGSizeMake(self.view.frame.size.width * imagesArray.count, 175);
    [_scrollView setContentSize:scrollViewSize];
    
    for (int i = 0; i < imagesArray.count; i++)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + 320*i, 0, self.view.frame.size.width, 175)];
        imageView.image = [UIImage imageNamed:imagesArray[i]];
        [_scrollView addSubview:imageView];
        [imageView release];
        
    }
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 220, self.view.frame.size.width, 20)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = imagesArray.count;
    
    [bgScrollView addSubview:_scrollView];
    [bgScrollView addSubview:_pageControl];
    [_scrollView release];
    [_pageControl release];
    
    NSTimer *_timer;
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollPages) userInfo:nil repeats:YES];

}

- (void)createNavgation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
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
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"礼物详情"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];

}
- (void)backBtnClick
{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}
//轮播效果
-(void)scrollPages{
    ++_pageControl.currentPage;
    CGFloat pageWidth = CGRectGetWidth(_scrollView.frame);
    if (isFromStart) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        _pageControl.currentPage = 0;
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            [_scrollView setContentOffset:CGPointMake(pageWidth*_pageControl.currentPage, _scrollView.bounds.origin.y)];
        }];
        
    }
    if (_pageControl.currentPage == _pageControl.numberOfPages - 1) {
        isFromStart = YES;
    }
    else
    {
        isFromStart = NO;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(_scrollView.contentOffset.x) / _scrollView.frame.size.width;
    _pageControl.currentPage = index;
}
-(void)createBg
{
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:self.bgImageView];
//    NSString * docDir = DOCDIR;
    NSString * filePath = BLURBG;
    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    UIImage * image = [UIImage imageWithData:data];
    self.bgImageView.image = image;
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:tempView];
}

#pragma mark - 金币、星星、红心弹窗
- (void)HUDText:(NSString *)string showView:(UIView *)inView yOffset:(float) offset
{
    HUD = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    [inView addSubview:HUD];
    HUD.minSize = CGSizeMake(string.length * 5, 30);
    HUD.margin = 10;
    HUD.labelText = string;
    
    HUD.mode =MBProgressHUDModeText;
    [HUD show:YES];
    HUD.yOffset = offset;
    HUD.color = [UIColor colorWithRed:247/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    [HUD hide:YES afterDelay:2.0];
}

- (void)HUDImageIcon:(UIImage *)iconImage showView:(UIView *)inView yOffset:(float)offset Number:(int)num
{
    HUD = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    [inView addSubview:HUD];
    HUD.minSize = CGSizeMake(130, 60);
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.yOffset = offset;
    HUD.margin = 0;
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 60)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 42, 42)];
    [totalView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 70, 30)];
    label.text = [NSString stringWithFormat:@"+ %d",num];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentLeft;
    [totalView addSubview:label];
    HUD.customView = totalView;
    HUD.color = [UIColor colorWithRed:247/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    imageView.image = iconImage;
    [HUD hide:YES afterDelay:2.0];
    
}
@end
