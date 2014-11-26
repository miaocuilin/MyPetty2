//
//  ResultOfBuyView.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/18.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ResultOfBuyView.h"

@implementation ResultOfBuyView

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
//    self.alphaBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
////    self.alphaBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    self.alphaBgView.alpha = 0;
//    [self addSubview:self.alphaBgView];
    
    //600 852
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake((self.frame.size.width-304)/2.0, (self.frame.size.height-426)/2.0, 304, 426) ImageName:@""];
    [self addSubview:self.bgImageView];
    
    //title
    self.titleLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 304, 37) Font:17 Text:nil];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:self.titleLabel];
    
    //close
    self.closeBtn = [MyControl createButtonWithFrame:CGRectMake(304-15-8, 11, 15, 15) ImageName:@"alert_x.png" Target:self Action:@selector(closeClick) Title:nil];
    [self.bgImageView addSubview:self.closeBtn];
    
    self.giftNameLabel = [MyControl createLabelWithFrame:CGRectMake(0, 45, 160, 38) Font:17 Text:nil];
    self.giftNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:self.giftNameLabel];
    
    //196*0.5=98  167*0.5=83.5   130*130
    self.giftImage = [MyControl createImageViewWithFrame:CGRectMake(85+(130-98)/2, 116+15, 98, 83.5) ImageName:@""];
    [self.bgImageView addSubview:self.giftImage];
    
    //rq 165  35
    self.rqLabel = [MyControl createLabelWithFrame:CGRectMake(135/2.0, 434/2, 165, 35) Font:17 Text:@""];
    self.rqLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:self.rqLabel];
    
    //
    self.pickMore = [MyControl createButtonWithFrame:CGRectMake(18, 300, 100, 35) ImageName:@"alert_greenBg.png" Target:self Action:@selector(pickMoreClick) Title:@"再挑一个"];
    self.pickMore.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.bgImageView addSubview:self.pickMore];
    
    self.confirmBtn = [MyControl createButtonWithFrame:CGRectMake(304-18-100, 300, 100, 35) ImageName:@"alert_greenBg.png" Target:self Action:@selector(confirmClick) Title:@"确定"];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.bgImageView addSubview:self.confirmBtn];
    
    //
    UIImageView * roundBg = [MyControl createImageViewWithFrame:CGRectMake(18, 356, 53, 53) ImageName:@"head_cricle1.png"];
    [self.bgImageView addSubview:roundBg];
    
    //
    self.headImage = [MyControl createImageViewWithFrame:CGRectMake(3.5, 3.5, 46, 46) ImageName:@"defaultPetHead.png"];
    self.headImage.layer.cornerRadius = 23;
    self.headImage.layer.masksToBounds = YES;
    [roundBg addSubview:self.headImage];
    
    //
    self.actLabel = [MyControl createLabelWithFrame:CGRectMake(75, 360, 165, 53-8) Font:13 Text:nil];
    self.actLabel.textColor = BGCOLOR;
    [self.bgImageView addSubview:self.actLabel];
}
-(void)configUIWithName:(NSString *)name ItemId:(NSString *)itemId Tx:(NSString *)tx
{
    if (self.isFromShake) {
        [self.pickMore setTitle:@"就送这个" forState:UIControlStateNormal];
        [self.confirmBtn setTitle:@"再摇1次" forState:UIControlStateNormal];
    }
    
    NSDictionary * dict = [ControllerManager returnGiftDictWithItemId:itemId];
    if (self.isFromShake) {
        self.titleLabel.text = @"摇一摇";
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"给%@送个礼物", name];
    }
    
    self.giftNameLabel.text = [NSString stringWithFormat:@"%@ x 1", [dict objectForKey:@"name"]];
    
    if ([itemId intValue]>=2000) {
        self.bgImageView.image = [UIImage imageNamed:@"alertBg_bad.png"];
        self.rqLabel.text = [NSString stringWithFormat:@"人气 %@", [dict objectForKey:@"add_rq"]];
    }else{
        self.bgImageView.image = [UIImage imageNamed:@"alertBg_good.png"];
        self.rqLabel.text = [NSString stringWithFormat:@"人气 +%@", [dict objectForKey:@"add_rq"]];
    }
    self.actLabel.text = [NSString stringWithFormat:@"%@%@", name,  [ControllerManager returnActionStringWithItemId:itemId]];
    if(self.isFromShake){
        self.actLabel.text = [NSString stringWithFormat:@"还有 %d 次机会\n每天只能送 1 个礼物哦~", self.leftShakeTimes];
    }
    
    self.giftImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", itemId]];
    
    [self.headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PETTXURL, tx]] placeholderImage:[UIImage imageNamed:@"defaultPetHead.png"]];
    
//    NSString * path = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", tx]];
//    UIImage * image = [UIImage imageWithContentsOfFile:path];
//    if (image) {
//        self.headImage.image = image;
//    }else{
//        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//            if (isFinish) {
//                self.headImage.image = load.dataImage;
//                [load.data writeToFile:path atomically:YES];
//            }else{
//                //            LoadingFailed;
//            }
//        }];
//        [request release];
//    }
}
-(void)closeClick
{
    if(!isNotTrue && self.isFromShake){
        self.closeBlock();
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)pickMoreClick
{
    if (self.isFromShake) {
        //跳到下个页面
        self.sendThis();
    }
    isNotTrue = YES;
    [self closeClick];
    
}
-(void)confirmClick
{
    if (self.isFromShake) {
        //返回摇动页面
        self.shakeMore();
    }else{
        self.confirm();
    }
    isNotTrue = YES;
    [self closeClick];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
