//
//  Alert_HyperlinkView.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/10.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "Alert_HyperlinkView.h"
#import "HyperlinksButton.h"
@implementation Alert_HyperlinkView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self makeUI];
    }
    return self;
}
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
    
    UILabel * label1 = [MyControl createLabelWithFrame:CGRectMake(20, closeBtn.frame.origin.y+closeBtn.frame.size.height+20, bgView.frame.size.width-40, 20) Font:15 Text:nil];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [bgView addSubview:label1];
    
    UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(20, label1.frame.origin.y+label1.frame.size.height+15, bgView.frame.size.width-40, 20) Font:15 Text:nil];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [bgView addSubview:label2];
    
    UIView * hyperBg = [MyControl createViewWithFrame:CGRectZero];
    [bgView addSubview:hyperBg];
    
    HyperlinksButton * hyper = [HyperlinksButton buttonWithType:UIButtonTypeCustom];
    hyper.titleLabel.font = [UIFont systemFontOfSize:15];
    [hyper setTitleColor:ORANGE forState:UIControlStateNormal];
    [hyper setColor:ORANGE];
    
    
    if(self.type == 1){
        label1.text = @"您尚未设置登录密码，成功切换";
        label1.font = [UIFont systemFontOfSize:15];
        label2.text = @"账号的话，当前账号会丢失哦~";
        [hyper setTitle:@"设置密码" forState:UIControlStateNormal];
        
    }
    CGSize size = [hyper.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(label2.frame.size.width, 20) lineBreakMode:1];
    hyper.frame = CGRectMake(0, 0, size.width, 20);
    [hyperBg addSubview:hyper];
    
    UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(hyper.frame.size.width+5, 2.5, 16, 15) ImageName:@"various_2rightarrow.png"];
    [hyperBg addSubview:arrow];
    
    float w = size.width+arrow.frame.size.width+5;
    hyperBg.frame = CGRectMake((bgView.frame.size.width-w)/2.0, 123, size.width+20, 20);
    
    UIButton * hyperClick = [MyControl createButtonWithFrame:CGRectMake(0, 0, hyperBg.frame.size.width, hyperBg.frame.size.height) ImageName:@"" Target:self Action:@selector(hyperBtnClick) Title:nil];
    [hyperBg addSubview:hyperClick];
    
    
    UIButton * confirmBtn = [MyControl createButtonWithFrame:CGRectMake((bgView.frame.size.width-276/2)/2.0, 346/2, 276/2, 93/2.0) ImageName:@"various_orangeBtn.png" Target:self Action:@selector(confirmClick) Title:@"知道啦"];
    [bgView addSubview:confirmBtn];
}
-(void)closeBtnClick
{
    [self removeFromSuperview];
}
-(void)confirmClick
{
    self.jumpLogin();
    [self removeFromSuperview];
}
-(void)hyperBtnClick
{
    //跳转设置密码
    self.jumpSetPwd();
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
