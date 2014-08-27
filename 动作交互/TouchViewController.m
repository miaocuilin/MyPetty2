//
//  TouchViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-8-26.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "TouchViewController.h"
#import "HYScratchCardView.h"

@interface TouchViewController ()
@property (nonatomic, strong) HYScratchCardView *scratchCardView;
@end

@implementation TouchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self createButton];
}

- (void)createAlertView
{
    UIView *bodyView = [self shopGiftTitle];
    UIImageView *touchImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 40, bodyView.frame.size.width, 250) ImageName:@"cat2.jpg"];
    [bodyView addSubview:touchImageView];
    UIImage *imageDemo = [touchImageView.image applyBlurWithRadius:60.0 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    
    self.scratchCardView = [[HYScratchCardView alloc]initWithFrame:touchImageView.frame];
    self.scratchCardView.surfaceImage = imageDemo;
    self.scratchCardView.image = touchImageView.image;
    [bodyView addSubview:self.scratchCardView];
    
    self.scratchCardView.completion = ^(id userInfo) {
        NSLog(@"%d",self.scratchCardView.isOpen);
        [ControllerManager HUDImageIcon:@"gold.png" showView:alertView yOffset:100 Number:100];
    };
    [alertView show:YES];
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

- (UIView *)shopGiftTitle
{
    alertView = [self alertViewInit:CGSizeMake(300, 425)];
    UIView *totalView = [MyControl createViewWithFrame:CGRectMake(0, 0, 300, 425)];
    totalView.layer.cornerRadius = 10;
    totalView.layer.masksToBounds = YES;
    UIImageView *titleView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 300, 40) ImageName:@"title_bg.png"];
    [totalView addSubview:titleView];
    UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:17 Text:@"摸一摸"];
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
    
    alertView.customView = totalView;
    
    return bodyView;
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
- (void)colseGiftAction
{
    [alertView hide:YES];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)buttonAction:(UIButton *)sender
{
    [self createAlertView];
}
@end
