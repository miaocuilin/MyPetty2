//
//  Alert_oneBtnView.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/12.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "Alert_oneBtnView.h"

@implementation Alert_oneBtnView
-(void)dealloc
{
    [super dealloc];
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
    
    
    UILabel * label1 = [MyControl createLabelWithFrame:CGRectMake(20, closeBtn.frame.origin.y+closeBtn.frame.size.height+60, bgView.frame.size.width-40, 20) Font:16 Text:nil];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [bgView addSubview:label1];
    
    UIButton * confirmBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width/2-276/4.0, 346/2, 276/2, 93/2.0) ImageName:@"various_orangeBtn.png" Target:self Action:@selector(confirmClick) Title:@"知道啦"];
    [bgView addSubview:confirmBtn];
    
    if (self.type == 1) {
        label1.text = @"储粮不足呦，快去攒攒吧~";
    }else if(self.type == 2){
        UIImageView * heartAnimation = [MyControl createImageViewWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-64)/2.0, bgView.frame.origin.y-92, 64, 92) ImageName:@""];
        
        heartAnimation.animationImages = @[[UIImage imageNamed:@"pAnimation_1.png"],[UIImage imageNamed:@"pAnimation_2.png"],[UIImage imageNamed:@"pAnimation_3.png"],[UIImage imageNamed:@"pAnimation_4.png"],[UIImage imageNamed:@"pAnimation_5.png"],[UIImage imageNamed:@"pAnimation_6.png"],[UIImage imageNamed:@"pAnimation_7.png"],[UIImage imageNamed:@"pAnimation_8.png"]];
        heartAnimation.animationDuration = 0.8;
        heartAnimation.animationRepeatCount = 0;
        [heartAnimation startAnimating];
        [self addSubview:heartAnimation];
        
        label1.text = @"捧了人家可要对人家负责呀~\n一定要让TA成为宇宙中\n最闪亮的萌星";
        CGSize size = [label1.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(label1.frame.size.width, 100) lineBreakMode:1];
        label1.frame = CGRectMake(20, closeBtn.frame.origin.y+closeBtn.frame.size.height+10, bgView.frame.size.width-40, size.height);
        if (self.petsNum >= 10) {
            int cost = self.petsNum*5;
            if (cost>100) {
                cost = 100;
            }
            NSString * str = [NSString stringWithFormat:@"本次捧星会消耗您%d金币哦~", cost];
            CGSize size2 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(label1.frame.size.width, 100) lineBreakMode:1];
            UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(20, label1.frame.origin.y+label1.frame.size.height+10, label1.frame.size.width, size.height) Font:14 Text:nil];
            label2.textAlignment = NSTextAlignmentCenter;
            label2.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
            
            NSString * str2 = [NSString stringWithFormat:@"%d", self.petsNum*5];
            NSMutableAttributedString * mutableStr = [[NSMutableAttributedString alloc] initWithString:str];
            
            [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8, str2.length)];
            label2.attributedText = mutableStr;
            [bgView addSubview:label2];
            [mutableStr release];
        }else{
            CGRect rect = label1.frame;
            rect.origin.y += 25;
            label1.frame = rect;
        }
    }else if(self.type == 3){
        CGRect rect = label1.frame;
        rect.origin.y -= 30;
        label1.frame = rect;
        if (self.sina) {
            label1.text = @"当前微博账号没有注册过应用呢~";
        }else{
            label1.text = @"当前微信账号没有注册过应用呢~";
        }
        UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(20, label1.frame.origin.y+label1.frame.size.height+30, label1.frame.size.width, 20) Font:14 Text:@"试试昵称登录吧"];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
        [bgView addSubview:label2];
        
        [confirmBtn setTitle:@"哎~好吧" forState:UIControlStateNormal];
    }else if(self.type == 4){
        CGRect rect = label1.frame;
        rect.origin.y -= 20;
        label1.frame = rect;
        
        label1.textColor = [UIColor blackColor];
        NSMutableAttributedString * mutableStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"您的卖萌号：%@", [USER objectForKey:@"code"]]];
        [mutableStr setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19]} range:NSMakeRange(6, 6)];
        [mutableStr setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(6, 6)];
        label1.attributedText = mutableStr;
        [mutableStr release];
        
        UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(0, label1.frame.origin.y+20, bgView.frame.size.width, 20) Font:16 Text:@"已复制到剪贴板!"];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = [UIColor blackColor];
        [bgView addSubview:label2];
        
        UILabel * label3 = [MyControl createLabelWithFrame:CGRectMake(0, label2.frame.origin.y+20, bgView.frame.size.width, 20) Font:16 Text:@"充值时一定要填写哦~"];
        label3.textAlignment = NSTextAlignmentCenter;
        label3.textColor = [UIColor blackColor];
        [bgView addSubview:label3];
        
        [confirmBtn setTitle:@"OK!" forState:UIControlStateNormal];
        
        //复制到剪贴板
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [USER objectForKey:@"code"];
    }
}
-(void)closeBtnClick
{
    if(self.jump)[self.jump release];
    [self removeFromSuperview];
}
-(void)confirmClick
{
    if (self.type == 2) {
        self.jump();
    }else if(self.type == 4){
//        if (![[USER objectForKey:@"confVersion"] isEqualToString:[USER objectForKey:@"versionKey"]]) {
            //非审核版本
            self.jumpTB();
//        }
    }
    if(self.jump) [self.jump release];
    if(self.jumpTB) [self.jump release];
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
