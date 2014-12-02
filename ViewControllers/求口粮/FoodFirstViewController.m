//
//  FoodFirstViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/1.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "FoodFirstViewController.h"

@interface FoodFirstViewController ()

@end

@implementation FoodFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeUI];
    [self modifyUI];
}
-(void)makeUI
{
    UIImageView * bgImageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@""];
    if (self.preImage) {
        bgImageView.image = [self.preImage applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    }else{
        bgImageView.image = [UIImage imageNamed:@"blurBg.png"];
    }
    [self.view addSubview:bgImageView];
    
    UIButton * btn = [MyControl createButtonWithFrame:CGRectMake((self.view.frame.size.width-32)/2.0, self.view.frame.size.height-50, 32, 32) ImageName:@"foodFirst_btn.png" Target:self Action:@selector(btnClick) Title:nil];
    [bgImageView addSubview:btn];
    
    UIImageView * imageView = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-128)/2.0, self.view.frame.size.height-490/2, 128, 103) ImageName:@"foodFirst_image.png"];
    [bgImageView addSubview:imageView];
    
    label1 = [MyControl createLabelWithFrame:CGRectMake(0, imageView.frame.origin.y-174, self.view.frame.size.width, 35) Font:18 Text:nil];
    label1.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:label1];
    
    label2 = [MyControl createLabelWithFrame:CGRectMake(0, label1.frame.origin.y+60, self.view.frame.size.width, 28) Font:18 Text:@"已经挣得"];
    label2.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:label2];
    
    label3 = [MyControl createLabelWithFrame:CGRectMake(0, label2.frame.origin.y+50, self.view.frame.size.width, 35) Font:18 Text:nil];
    label3.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:label3];
}

-(void)modifyUI
{
    NSMutableAttributedString * mutableStr1 = [[NSMutableAttributedString alloc] initWithString:@"2345位萌星"];
    [mutableStr1 addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:28]} range:NSMakeRange(0, 4)];
    label1.attributedText = mutableStr1;
    [mutableStr1 release];
    
    NSMutableAttributedString * mutableStr3 = [[NSMutableAttributedString alloc] initWithString:@"9609份口粮"];
    [mutableStr3 addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:28]} range:NSMakeRange(0, 4)];
    label3.attributedText = mutableStr3;
    [mutableStr3 release];
}

-(void)btnClick
{
    //跳转求口粮
    
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
