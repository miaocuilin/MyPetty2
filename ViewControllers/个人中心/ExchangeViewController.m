//
//  ExchangeViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ExchangeViewController.h"

@interface ExchangeViewController ()

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBg];
    [self createFakeNavigation];
}
-(void)createBg
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.png"];
    [self.view addSubview:imageView];
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
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"兑换"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    exBtn = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-170/2*0.9-10, backImageView.frame.origin.y-4, 170/2*0.9, 54/2*0.9) ImageName:@"exchange_cateBtn.png" Target:self Action:@selector(exBtnClick:) Title:@"种类"];
    exBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [navView addSubview:exBtn];
}
-(void)exBtnClick:(UIButton *)btn
{
    if (dropDown == nil) {
        CGFloat f = 200;
        navView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64+110);
        dropDown = [[NIDropDown alloc] showDropDown:btn :&f :@[@"所有", @"猫粮", @"狗粮"]];

//        [dropDown setDefaultCellType];
        [dropDown setCellTextColor:[UIColor whiteColor] Font:[UIFont systemFontOfSize:15] BgColor:[UIColor colorWithRed:246/255.0 green:168/255.0 blue:146/255.0 alpha:0.6] lineColor:[UIColor brownColor]];
        dropDown.delegate = self;
    }else{
        [dropDown hideDropDown:btn];
        [self rel];
    }
}

#pragma mark - delegate
-(void)niDropDownDelegateMethod:(NIDropDown *)sender
{
    if (sender == dropDown) {
        [self rel];
    }
}
-(void)didSelected:(NIDropDown *)sender Line:(int)Line Words:(NSString *)Words
{
    NSLog(@"%d--%@", Line, Words);
}
-(void)rel
{
    navView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    [dropDown release];
    dropDown = nil;
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
