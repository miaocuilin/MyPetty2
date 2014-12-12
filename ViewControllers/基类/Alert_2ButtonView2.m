//
//  Alert_2ButtonView2.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "Alert_2ButtonView2.h"

@implementation Alert_2ButtonView2
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
    
    UILabel * label1 = [MyControl createLabelWithFrame:CGRectMake(20, closeBtn.frame.origin.y+closeBtn.frame.size.height+10, bgView.frame.size.width-40, 20) Font:16 Text:nil];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [bgView addSubview:label1];
    
    UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(20, label1.frame.origin.y+label1.frame.size.height+5, bgView.frame.size.width-40, 20) Font:16 Text:nil];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [bgView addSubview:label2];
    
    UIImageView * goldImage = [MyControl createImageViewWithFrame:CGRectMake(bgView.frame.size.width/2-30-5, label2.frame.origin.y+label2.frame.size.height+10, 30, 30) ImageName:@"gold.png"];
    [bgView addSubview:goldImage];
    
    UILabel * costLabel = [MyControl createLabelWithFrame:CGRectMake(bgView.frame.size.width/2+5, goldImage.frame.origin.y+5, bgView.frame.size.width/2, 20) Font:17 Text:[NSString stringWithFormat:@"%d", [self.rewardNum intValue]-[[USER objectForKey:@"food"] intValue]]];
    costLabel.textColor = ORANGE;
    [bgView addSubview:costLabel];
    
    selectImage = [MyControl createImageViewWithFrame:CGRectMake(bgView.frame.size.width/2-70, goldImage.frame.origin.y+goldImage.frame.size.height+15, 15, 15) ImageName:@"atUsers_unSelected.png"];
    [bgView addSubview:selectImage];
    
    UIButton * selectBtn = [MyControl createButtonWithFrame:CGRectMake(selectImage.frame.origin.x-5, selectImage.frame.origin.y-5, 25, 25) ImageName:@"" Target:self Action:@selector(selectBtnClick:) Title:nil];
    [bgView addSubview:selectBtn];
    
    UILabel * selectLabel = [MyControl createLabelWithFrame:CGRectMake(selectImage.frame.origin.x+selectImage.frame.size.width+5, selectImage.frame.origin.y-2.5, bgView.frame.size.width/2+50, 20) Font:15 Text:@"以后不用提醒我了"];
    selectLabel.textColor = ORANGE;
    [bgView addSubview:selectLabel];
    
    UIButton * cancelBtn = [MyControl createButtonWithFrame:CGRectMake(8, 346/2, 276/2*0.9, 93/2.0*0.9) ImageName:@"various_grayBtn.png" Target:self Action:@selector(cancelClick) Title:@"再想想"];
    [bgView addSubview:cancelBtn];
    
    UIButton * confirmBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width-276/2*0.9-8, 346/2, 276/2*0.9, 93/2.0*0.9) ImageName:@"various_orangeBtn.png" Target:self Action:@selector(confirmClick) Title:@"没问题"];
    [bgView addSubview:confirmBtn];
    
    if(self.type == 1){
        label1.text = [NSString stringWithFormat:@"本次打赏%@份口粮", self.rewardNum];
        label2.text = @"需要花费您：";
        
    }else if(self.type == 2){
        label1.text = [NSString stringWithFormat:@"本次打赏%@份口粮", self.rewardNum];
        label2.text = @"需要花费您：";
        
        selectImage.hidden = YES;
        selectBtn.hidden = YES;
        CGRect rect = selectLabel.frame;
        rect.origin.x = 0;
        rect.size.width = bgView.frame.size.width;
        selectLabel.frame = rect;
        selectLabel.text = @"先去充值吧~";
        selectLabel.textAlignment = NSTextAlignmentCenter;
        
        [confirmBtn setTitle:@"去充值" forState:UIControlStateNormal];
    }else if(self.type == 3){
        label1.text = @"确认支付";
        selectImage.hidden = YES;
        selectLabel.hidden = YES;
        
        CGRect rect = goldImage.frame;
        rect.origin.y -= 20;
        goldImage.frame = rect;
        
        CGRect rect2 = costLabel.frame;
        rect2.origin.y -= 20;
        costLabel.frame = rect2;
        
    
        goldImage.image = [UIImage imageNamed:@"exchange_orangeFood.png"];
        costLabel.text = self.foodCost;
        NSString * str = [NSString stringWithFormat:@"兑换%@?", self.productName];
        label2.text = str;
        label2.font = [UIFont systemFontOfSize:15];
        label2.textAlignment = NSTextAlignmentCenter;
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(bgView.frame.size.width-20, 100) lineBreakMode:1];
        label2.frame = CGRectMake(10, goldImage.frame.origin.y+goldImage.frame.size.height+10, size.width, size.height);
    }
//    if ([[USER objectForKey:@"notShowCostAlert"] intValue]) {
//        selectImage.hidden = YES;
//        selectBtn.hidden = YES;
//        selectLabel.hidden = YES;
//    }
}
-(void)closeBtnClick
{
    [self removeFromSuperview];
}
-(void)cancelClick
{
    [self removeFromSuperview];
}
-(void)confirmClick
{
    if(self.type == 1){
        //打赏
        self.reward();
    }else if (self.type == 2){
        //block跳转充值
        self.jumpCharge();
    }else if(self.type == 3){
        //block确认兑换
        self.exchange();
    }
    [self removeFromSuperview];
}
-(void)selectBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        selectImage.image = [UIImage imageNamed:@"atUsers_selected.png"];
        [USER setObject:@"1" forKey:@"notShowCostAlert"];
    }else{
        selectImage.image = [UIImage imageNamed:@"atUsers_unSelected.png"];
        [USER setObject:@"0" forKey:@"notShowCostAlert"];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
