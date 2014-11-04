//
//  ReportAlertView.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ReportAlertView.h"

@implementation ReportAlertView

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
    self.alpha = 0;
    
    self.alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.alphaView.backgroundColor = [UIColor blackColor];
    self.alphaView.alpha = 0.5;
    [self addSubview:self.alphaView];
    
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake((self.frame.size.width-476/2)/2, self.frame.size.height/2-160/2, 476/2, 160) ImageName:@""];
//    self.bgImageView.image = [[UIImage imageNamed:@"report_bg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:50];
//    self.bgImageView.image = [[UIImage imageNamed:@"report_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 51, 51)];
    [self addSubview:self.bgImageView];
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, self.bgImageView.frame.size.width, self.bgImageView.frame.size.height)];
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    [self.bgImageView addSubview:view];
    
    self.closeBtn = [MyControl createButtonWithFrame:CGRectMake(self.bgImageView.frame.origin.x+476/2-30, self.bgImageView.frame.origin.y+5, 25, 25) ImageName:@"report_close.png" Target:self Action:@selector(closeBtnClick) Title:nil];
    [self addSubview:self.closeBtn];
    
    self.label = [MyControl createLabelWithFrame:CGRectMake(0, 45, self.bgImageView.frame.size.width, 20) Font:17 Text:nil];
    self.label.textColor = [UIColor grayColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:self.label];
    
    self.label2 = [MyControl createLabelWithFrame:CGRectMake(0, 154/2, self.bgImageView.frame.size.width, 15) Font:12 Text:nil];
    self.label2.textColor = [UIColor grayColor];
    self.label2.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:self.label2];
    
    if (self.AlertType == 1) {
        self.label.text = @"拉黑TA？";
        self.label2.text = @"拉黑用户可到设置里查看";
    }else if(self.AlertType == 2){
        self.label.text = @"举报此评论？";
        self.label2.text = @"评论内容涉及敏感话题，官方会予以删除";
    }else if(self.AlertType == 3){
        self.label.text = @"举报此用户？";
        self.label2.text = @"此用户涉及敏感内容，官方会予以删除";
    }else if(self.AlertType == 4){
        self.label.text = @"举报此图片？";
        self.label2.text = @"此图片涉及敏感内容，官方会予以删除";
    }
    
    self.confirmBtn = [MyControl createButtonWithFrame:CGRectMake(17+10, 238/2, 164/2, 54/2) ImageName:@"" Target:self Action:@selector(confirmBtnClick) Title:@"确定"];
    self.confirmBtn.backgroundColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1];
    self.confirmBtn.layer.cornerRadius = 7;
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.bgImageView addSubview:self.confirmBtn];
    
    self.cancelBtn = [MyControl createButtonWithFrame:CGRectMake(10+234/2, 238/2, 164/2, 54/2) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:@"取消"];
    self.cancelBtn.backgroundColor = [UIColor colorWithRed:250/255.0 green:123/255.0 blue:87/255.0 alpha:1];
    self.cancelBtn.layer.cornerRadius = 7;
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.bgImageView addSubview:self.cancelBtn];
    //    self.confirmBtn.backgroundColor = BGCOLOR;
    [self.bgImageView addSubview:self.cancelBtn];
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
    self.confirmClick();
    [self closeBtnClick];
}
-(void)cancelBtnClick
{
    [self closeBtnClick];
}
@end
