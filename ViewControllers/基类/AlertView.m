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
    }
    return self;
}

-(void)makeUI
{
    if (self.AlertType == 0) {
        self.AlertType = 1;
    }
//    self.AlertType = 5;
    
    self.alpha = 0;
    
    self.alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.alphaView.backgroundColor = [UIColor blackColor];
    self.alphaView.alpha = 0.5;
    [self addSubview:self.alphaView];
    
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake((self.frame.size.width-470/2)/2, self.frame.size.height/2-100, 470/2, 150) ImageName:@"alert_bg.png"];
    [self addSubview:self.bgImageView];
    
    self.closeBtn = [MyControl createButtonWithFrame:CGRectMake(self.bgImageView.frame.origin.x+200, self.bgImageView.frame.origin.y-8, 25, 25) ImageName:@"alert_close.png" Target:self Action:@selector(closeBtnClick) Title:nil];
    [self addSubview:self.closeBtn];
    
    self.confirmBtn = [MyControl createButtonWithFrame:CGRectMake((self.frame.size.width-338/2)/2, self.bgImageView.frame.origin.y+self.bgImageView.frame.size.height, 338/2, 67/2) ImageName:@"alert_btn.png" Target:self Action:@selector(confirmBtnClick) Title:nil];
//    self.confirmBtn.backgroundColor = BGCOLOR;
    [self addSubview:self.confirmBtn];
    
//    NSString * str1 = @"地球人，您还木有注册呢~";
//    NSString * str2 = @"飞船马上起飞";
//    NSString * str3 = @"办理手续走起啊~";
    //1.注册
    NSArray * array = @[@"地球人，您还木有注册呢~", @"飞船马上起飞", @"办理手续走起啊~"];
    //2.加入
    NSArray * array2 = @[@"捧了人家可要对人家负责呀~", @"一定要让TA成为宇宙中", @"最闪亮的萌星~"];
    //3.加入满了提示
    NSArray * array3 = @[@"星球法则是最多捧10个萌星~", @"萌星们都那么可爱，", @"专一点嘛~"];
    //4.取消关注
    NSArray * array4 = @[@"亲爱的，真的忍心取消关注我么？", @"这是真的么~", @"是么~"];
    //5.退出国家
    NSArray * array5 = @[@"亲爱的，真的忍心不捧了吗？", @"你舍得放弃陪伴你的TA么？", @"真的要这么无情么？"];
    //6.邀请码时够10个圈子
    NSArray * array6 = @[@"暂不能使用邀请码~", @"萌星们都那么可爱，", @"专一点嘛~"];
    
    NSArray * tempArray = nil;
    
    if (self.AlertType == 1) {
        
        [self.confirmBtn setTitle:@"走起" forState:UIControlStateNormal];
        tempArray = array;
    }else if (self.AlertType == 2) {
        [self.confirmBtn setTitle:@"没问题" forState:UIControlStateNormal];
        tempArray = array2;
        UILabel * tip = [MyControl createLabelWithFrame:CGRectMake(0, self.confirmBtn.frame.origin.y+self.confirmBtn.frame.size.height, self.frame.size.width, 15) Font:10 Text:@"温馨提示：每个人只能捧红10个萌星"];
        tip.textColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
        tip.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tip];
    }else if (self.AlertType == 3 || self.AlertType == 6) {
        [self.confirmBtn setTitle:@"哎~好吧" forState:UIControlStateNormal];
        if (self.AlertType == 3) {
            tempArray = array3;
        }else{
            tempArray = array6;
        }
        
    }else if (self.AlertType == 4) {
//        self.confirmBtn.titleLabel.text = @"额~是的";
        [self.confirmBtn setTitle:@"额~是的" forState:UIControlStateNormal];
        tempArray = array4;
    }else if (self.AlertType == 5) {
        self.closeBtn.hidden = YES;
        
        [self.confirmBtn setTitle:@"额~是的" forState:UIControlStateNormal];
//        self.confirmBtn.titleLabel.text = @"额~是的";
        tempArray = array5;
//        self.confirmBtn.backgroundColor = BGCOLOR5;
        //
        CGRect rect = self.confirmBtn.frame;
        rect.size.height = 82/2;
        self.confirmBtn.frame = rect;
        [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"alert_greenBtn.png"] forState:UIControlStateNormal];
        
        self.confirmBtn2 = [MyControl createButtonWithFrame:CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, 67/2) ImageName:@"alert_btn.png" Target:self Action:@selector(confirmBtnClick2) Title:@"不退了"];
        [self addSubview:self.confirmBtn2];
    }
    
//    if(self.AlertType == 3){
//        for (int i=0; i<2; i++) {
//            UILabel * label = [MyControl createLabelWithFrame:CGRectMake(0, 10+20*i, self.bgImageView.frame.size.width, 20) Font:14 Text:tempArray[i]];
//            label.textAlignment = NSTextAlignmentCenter;
//            [self.bgImageView addSubview:label];
//        }
//    }else{
        for (int i=0; i<3; i++) {
            UILabel * label = [MyControl createLabelWithFrame:CGRectMake(0, 18+20*i, self.bgImageView.frame.size.width, 20) Font:15 Text:tempArray[i]];
            label.textAlignment = NSTextAlignmentCenter;
            [self.bgImageView addSubview:label];
        }
//    }
    
    
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
-(void)confirmBtnClick
{
    
    //本地存储一个值，来记录是否未注册，在注册完之后打开侧边栏的时候判断是否是刚注册完进入侧边栏，然后重新布局侧边栏数据。
    if (self.AlertType == 1) {
        NSLog(@"跳转注册");
        [USER setObject:@"1" forKey:@"isNotRegister"];
    }else if(self.AlertType == 2){
        //加入
    }else if(self.AlertType == 4){
        //取消关注
    }else if(self.AlertType == 5){
        //退出国家
    }
    if (self.AlertType != 3 && self.AlertType != 6) {
        self.jump();
    }
    
    [self closeBtnClick];
    
}
-(void)confirmBtnClick2
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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
