//
//  CodeAlertView.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/12.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "CodeAlertView.h"

@implementation CodeAlertView

-(void)makeUI
{
    self.alpha = 0;
    
    self.alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.alphaView.backgroundColor = [UIColor blackColor];
    self.alphaView.alpha = 0.5;
    [self addSubview:self.alphaView];
    
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake((self.frame.size.width-520/2)/2, self.frame.size.height/2-438/4, 520/2, 438/2) ImageName:@""];
    [self addSubview:self.bgImageView];
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, self.bgImageView.frame.size.width, self.bgImageView.frame.size.height)];
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    [self.bgImageView addSubview:view];
    
    self.closeBtn = [MyControl createButtonWithFrame:CGRectMake(self.bgImageView.frame.origin.x+520/2-30, self.bgImageView.frame.origin.y+5, 25, 25) ImageName:@"report_close.png" Target:self Action:@selector(closeBtnClick) Title:nil];
    [self addSubview:self.closeBtn];
    
    self.headImage = [MyControl createImageViewWithFrame:CGRectMake((self.bgImageView.frame.size.width-50)/2.0, 27, 50, 50) ImageName:@"defaultPetHead.png"];
    self.headImage.layer.cornerRadius = 25;
    self.headImage.layer.masksToBounds = YES;
    [self.bgImageView addSubview:self.headImage];
    
    if (self.alertType == 2 || self.alertType == 4) {
        if (!([self.model.tx isKindOfClass:[NSNull class]] || [self.model.tx length]==0)) {
            NSString * docDir = DOCDIR;
            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.model.tx]];
            //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
            UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
            if (image) {
//                [headImageBtn setBackgroundImage:image forState:UIControlStateNormal];
                self.headImage.image = image;
            }else{
                //下载头像
                NSString * url = [NSString stringWithFormat:@"%@%@", PETTXURL, self.model.tx];
                NSLog(@"%@", url);
                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
//                        [headImageBtn setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                        self.headImage.image = load.dataImage;
                        NSString * docDir = DOCDIR;
                        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.model.tx]];
                        [load.data writeToFile:txFilePath atomically:YES];
                    }else{
                        NSLog(@"头像下载失败");
                    }
                }];
                [request release];
            }
        }
    }
    
    lab1 = [MyControl createLabelWithFrame:CGRectMake(0, 86, self.bgImageView.frame.size.width, 20) Font:13 Text:nil];
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.textColor = [UIColor grayColor];
    [self.bgImageView addSubview:lab1];
    
    lab2 = [MyControl createLabelWithFrame:CGRectMake(0, 106, self.bgImageView.frame.size.width, 20) Font:13 Text:nil];
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.textColor = [UIColor grayColor];
    [self.bgImageView addSubview:lab2];
    
    if(self.alertType == 1){
        
    }else if(self.alertType == 2){
        
    }else if(self.alertType == 3){
        
    }else if(self.alertType == 4){
        
        lab1.text = [NSString stringWithFormat:@"为萌星%@助力！", self.model.name];
        lab2.text = @"邀请小伙伴，输入邀请码，双方得金币";
        
        UILabel * code = [MyControl createLabelWithFrame:CGRectMake(0, 132, self.bgImageView.frame.size.width, 20) Font:15 Text:[NSString stringWithFormat:@"邀请码：%@", self.model.invite_code]];
        code.textAlignment = NSTextAlignmentCenter;
        code.textColor = BGCOLOR;
        [self.bgImageView addSubview:code];
        
        UIImageView * shareBg = [MyControl createImageViewWithFrame:CGRectMake(0, 160, self.bgImageView.frame.size.width, 45) ImageName:@""];
        shareBg.image = [[UIImage imageNamed:@"invite_pinkBg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        [self.bgImageView addSubview:shareBg];
        
        NSArray * imageNameArray = @[@"more_weixin.png", @"more_friend.png", @"more_sina.png"];
        for (int i=0; i<3; i++) {
            UIButton * button = [MyControl createButtonWithFrame:CGRectMake(30+i*83, 5, 35, 35) ImageName:imageNameArray[i] Target:self Action:@selector(shareClick:) Title:nil];
            button.tag = 100+i;
            [shareBg addSubview:button];
        }
    }
}
-(void)shareClick:(UIButton *)button
{
    //截图
    UIImage * image = [MyControl imageWithView:self.bgImageView];
    
    self.shareClick(button.tag-100, image);
    
}
-(void)closeBtnClick
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
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
