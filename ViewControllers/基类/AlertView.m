//
//  AlertView.m
//  MyPetty
//
//  Created by miaocuilin on 14-9-26.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    self.alpha = 0;
    
    self.alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.alphaView.backgroundColor = [UIColor blackColor];
    self.alphaView.alpha = 0.5;
    [self addSubview:self.alphaView];
    
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake((self.frame.size.width-470/2)/2, self.frame.size.height/2-100, 470/2, 150) ImageName:@"alert_bg.png"];
    [self addSubview:self.bgImageView];
    
    self.closeBtn = [MyControl createButtonWithFrame:CGRectMake(self.bgImageView.frame.origin.x+200, self.bgImageView.frame.origin.y-8, 25, 25) ImageName:@"alert_close.png" Target:self Action:@selector(closeBtnClick) Title:nil];
    [self addSubview:self.closeBtn];
    
    self.confirmBtn = [MyControl createButtonWithFrame:CGRectMake((self.frame.size.width-338/2)/2, self.bgImageView.frame.origin.y+self.bgImageView.frame.size.height, 338/2, 67/2) ImageName:@"alert_btn.png" Target:self Action:@selector(comfirmBtnClick) Title:@"走起"];
    [self addSubview:self.confirmBtn];
    
//    NSString * str1 = @"地球人，您还木有注册呢~";
//    NSString * str2 = @"飞船马上起飞";
//    NSString * str3 = @"办理手续走起啊~";
    NSArray * array = @[@"地球人，您还木有注册呢~", @"飞船马上起飞", @"办理手续走起啊~"];
    
    for (int i=0; i<3; i++) {
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(0, 15+20*i, self.bgImageView.frame.size.width, 20) Font:15 Text:array[i]];
        label.textAlignment = NSTextAlignmentCenter;
        [self.bgImageView addSubview:label];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
}

-(void)closeBtnClick
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
-(void)comfirmBtnClick
{
    NSLog(@"跳转注册");
    //本地存储一个值，来记录是否未注册，在注册完之后打开侧边栏的时候判断是否是刚注册完进入侧边栏，然后重新布局侧边栏数据。
    [USER setObject:@"1" forKey:@"isNotRegister"];
    [self closeBtnClick];
    self.jump();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
