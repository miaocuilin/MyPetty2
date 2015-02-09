//
//  NoCloseAlert.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/19.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "NoCloseAlert.h"

@implementation NoCloseAlert
-(void)dealloc
{
    [super dealloc];
}
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

    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:alphaView];
    //577  678
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake((self.frame.size.width-577/2.0)/2.0, (self.frame.size.height-678/2)/2.0, 577/2.0, 678/2) ImageName:@""];
    if([UIScreen mainScreen].bounds.size.height == 480){
        CGRect rect = self.bgImageView.frame;
        rect.origin.y += 50;
        self.bgImageView.frame = rect;
    }
    [self addSubview:self.bgImageView];
    
    UIView * alphaView2 = [MyControl createViewWithFrame:CGRectMake(0, 0, self.bgImageView.frame.size.width, self.bgImageView.frame.size.height)];
    alphaView2.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    alphaView2.layer.cornerRadius = 10;
    alphaView2.layer.masksToBounds = YES;
    [self.bgImageView addSubview:alphaView2];
    
    //title
    self.titleLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 577/2.0, 37) Font:15 Text:@"成功捧TA"];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:self.titleLabel];
    
    UIButton * closeBtn = [MyControl createButtonWithFrame:CGRectMake(self.bgImageView.frame.size.width-36, 0, 36, 36) ImageName:@"various_close.png" Target:self Action:@selector(confirmClick) Title:nil];
    [self.bgImageView addSubview:closeBtn];
    
    UIImageView * headBg = [MyControl createImageViewWithFrame:CGRectMake((self.bgImageView.frame.size.width-80)/2.0, 92/2, 80, 80) ImageName:@"alert_headBg.png"];
    [self.bgImageView addSubview:headBg];
    
    self.headImage = [MyControl createImageViewWithFrame:CGRectMake(6, 6, 68, 68) ImageName:@"defaultPetHead.png"];
    self.headImage.layer.cornerRadius = 34;
    self.headImage.layer.masksToBounds = YES;
    [headBg addSubview:self.headImage];
    
    self.acceptLabel1 = [MyControl createLabelWithFrame:CGRectMake(0, 135, self.bgImageView.frame.size.width, 20) Font:17 Text:nil];
    self.acceptLabel1.textAlignment = NSTextAlignmentCenter;
    self.acceptLabel1.textColor = ORANGE;
    [self.bgImageView addSubview:self.acceptLabel1];

    self.acceptLabel2 = [MyControl createLabelWithFrame:CGRectMake(0, 155, self.bgImageView.frame.size.width, 20) Font:17 Text:@"凉粉一枚"];
    self.acceptLabel2.textAlignment = NSTextAlignmentCenter;
    self.acceptLabel2.textColor = ORANGE;
    [self.bgImageView addSubview:self.acceptLabel2];
    
    //
    self.percentLabel1 = [MyControl createLabelWithFrame:CGRectMake(0, 193, self.bgImageView.frame.size.width, 16) Font:15 Text:@"TA在过去的历史中"];
    self.percentLabel1.textAlignment = NSTextAlignmentCenter;
    self.percentLabel1.textColor = [ControllerManager colorWithHexString:@"858382"];
    [self.bgImageView addSubview:self.percentLabel1];
    
    self.percentLabel2 = [MyControl createLabelWithFrame:CGRectMake(0, 222, self.bgImageView.frame.size.width, 16) Font:15 Text:nil];
    self.percentLabel2.textAlignment = NSTextAlignmentCenter;
    self.percentLabel2.textColor = [ControllerManager colorWithHexString:@"858382"];
    [self.bgImageView addSubview:self.percentLabel2];
    
    UILabel * label = [MyControl createLabelWithFrame:CGRectMake(0, self.bgImageView.frame.size.height-176/2, self.bgImageView.frame.size.width, 16) Font:15 Text:@"期待您的加入让TA的明天更加辉煌"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [ControllerManager colorWithHexString:@"858382"];
    [self.bgImageView addSubview:label];
    
    //336  68
    UIButton * confirmBtn = [MyControl createButtonWithFrame:CGRectMake(self.bgImageView.frame.size.width/2-276/4.0, self.bgImageView.frame.size.height-93/2.0-14, 276/2, 93/2.0) ImageName:@"various_orangeBtn.png" Target:self Action:@selector(confirmClick) Title:@"知道啦"];
    [self.bgImageView addSubview:confirmBtn];
    
//    self.confirmBtn = [MyControl createButtonWithFrame:CGRectMake((self.bgImageView.frame.size.width-168)/2.0, self.bgImageView.frame.size.height-48, 168, 34) ImageName:@"" Target:self Action:@selector(confirmClick) Title:@"知道啦"];
//    self.confirmBtn.backgroundColor = ORANGE;
//    self.confirmBtn.layer.cornerRadius = 5;
//    self.confirmBtn.layer.masksToBounds = YES;
//    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [self.bgImageView addSubview:self.confirmBtn];
    
    heartAnimation = [MyControl createImageViewWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-64)/2.0, self.bgImageView.frame.origin.y-92, 64, 92) ImageName:@""];
    
    heartAnimation.animationImages = @[[UIImage imageNamed:@"pAnimation_1.png"],[UIImage imageNamed:@"pAnimation_2.png"],[UIImage imageNamed:@"pAnimation_3.png"],[UIImage imageNamed:@"pAnimation_4.png"],[UIImage imageNamed:@"pAnimation_5.png"],[UIImage imageNamed:@"pAnimation_6.png"],[UIImage imageNamed:@"pAnimation_7.png"],[UIImage imageNamed:@"pAnimation_8.png"]];
    heartAnimation.animationDuration = 0.8;
    heartAnimation.animationRepeatCount = 0;
    [heartAnimation startAnimating];
    [self addSubview:heartAnimation];
}

-(void)configUIWithTx:(NSString *)tx Name:(NSString *)name Percent:(NSString *)percent
{
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 接纳你成为", name]];
    [attString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} range:NSMakeRange(0, name.length)];
    self.acceptLabel1.attributedText = attString;
    [attString release];
    
    NSMutableAttributedString * attString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"击败了 %@%@ 的萌星", percent, @"%"]];
    [attString1 setAttributes:@{NSForegroundColorAttributeName:ORANGE, NSFontAttributeName:[UIFont systemFontOfSize:17]} range:NSMakeRange(4, percent.length+1)];
    self.percentLabel2.attributedText = attString1;
    [attString1 release];
    
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

-(void)confirmClick
{
    [heartAnimation stopAnimating];
    self.confirm();
//    [UIView animateWithDuration:0.3 animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
        [self removeFromSuperview];
//    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
