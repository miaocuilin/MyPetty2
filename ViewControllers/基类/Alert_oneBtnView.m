//
//  Alert_oneBtnView.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/12.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "Alert_oneBtnView.h"

@implementation Alert_oneBtnView
-(void)makeUI
{
    //黑 %60  白 %80
    UIView * alphaView = [MyControl createViewWithFrame:[UIScreen mainScreen].bounds];
    alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:alphaView];
    
    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(18, ([UIScreen mainScreen].bounds.size.height-230)/2.0, [UIScreen mainScreen].bounds.size.width-36, 230)];
    [self addSubview:bgView];
    
    UIView * whiteBg = [MyControl createViewWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
    whiteBg.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    whiteBg.layer.cornerRadius = 10;
    whiteBg.layer.masksToBounds = YES;
    [bgView addSubview:whiteBg];
    
    UIButton * closeBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width-36, 0, 36, 36) ImageName:@"various_close.png" Target:self Action:@selector(closeBtnClick) Title:nil];
    [bgView addSubview:closeBtn];
    
    UILabel * label1 = [MyControl createLabelWithFrame:CGRectMake(20, closeBtn.frame.origin.y+closeBtn.frame.size.height+60, bgView.frame.size.width-40, 20) Font:16 Text:nil];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [bgView addSubview:label1];
    
    UIButton * confirmBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width/2-276/4.0, 346/2, 276/2, 93/2.0) ImageName:@"various_orangeBtn.png" Target:self Action:@selector(confirmClick) Title:@"知道啦"];
    [bgView addSubview:confirmBtn];
    
    if (self.type == 1) {
        label1.text = @"储粮不足呦，快去攒攒吧~";
    }
}
-(void)closeBtnClick
{
    [self removeFromSuperview];
}
-(void)confirmClick
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
