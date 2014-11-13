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
    
    NSString * tx = nil;
    if (self.alertType == 2 || self.alertType == 3) {
        tx = self.codeModel.tx;
    }else if(self.alertType == 4){
        tx = self.model.tx;
    }
//    NSLog(@"%@", tx);
    if (self.alertType != 1) {
        if (!([tx isKindOfClass:[NSNull class]] || [tx length]==0)) {
            NSString * docDir = DOCDIR;
            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", tx]];
            //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
            UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
            if (image) {
//                [headImageBtn setBackgroundImage:image forState:UIControlStateNormal];
                self.headImage.image = image;
            }else{
                //下载头像
                NSString * url = [NSString stringWithFormat:@"%@%@", PETTXURL, tx];
                NSLog(@"%@", url);
                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
//                        [headImageBtn setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                        self.headImage.image = load.dataImage;
                        NSString * docDir = DOCDIR;
                        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", tx]];
                        [load.data writeToFile:txFilePath atomically:YES];
                    }else{
                        NSLog(@"头像下载失败");
                    }
                }];
                [request release];
            }
        }
    }
    
    lab1 = [MyControl createLabelWithFrame:CGRectMake(0, 76, self.bgImageView.frame.size.width, 30) Font:12 Text:nil];
    lab1.font = [UIFont boldSystemFontOfSize:12];
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.textColor = [UIColor grayColor];
    [self.bgImageView addSubview:lab1];
    
    lab2 = [MyControl createLabelWithFrame:CGRectMake(0, 106, self.bgImageView.frame.size.width, 30) Font:12 Text:nil];
    lab2.font = [UIFont boldSystemFontOfSize:12];
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.textColor = [UIColor grayColor];
    [self.bgImageView addSubview:lab2];
    
    //确定按钮
    self.confirmBtn = [MyControl createButtonWithFrame:CGRectMake((self.bgImageView.frame.size.width-120)/2.0, self.bgImageView.frame.size.height-32-10, 120, 32) ImageName:@"" Target:self Action:@selector(confirmBtnClick) Title:@"确定"];
    self.confirmBtn.showsTouchWhenHighlighted = YES;
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.confirmBtn.layer.cornerRadius = 7;
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.backgroundColor = [UIColor colorWithRed:250/255.0 green:140/255.0 blue:107/255.0 alpha:1];
    [self.bgImageView addSubview:self.confirmBtn];
    
    if(self.alertType == 1){
        self.headImage.hidden = YES;
        
        UILabel * code = [MyControl createLabelWithFrame:CGRectMake((self.bgImageView.frame.size.width-190)/2.0, 50, 190, 20) Font:15 Text:@"邀请码："];
        code.textColor = BGCOLOR;
        [self.bgImageView addSubview:code];
        
        CGSize size = [code.text sizeWithFont:code.font constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
        
        UIImageView * pinkBg = [MyControl createImageViewWithFrame:CGRectMake(code.frame.origin.x+size.width+3, code.frame.origin.y, 190-size.width-3, 20) ImageName:@""];
        pinkBg.image = [[UIImage imageNamed:@"invite_pinkBg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        [self.bgImageView addSubview:pinkBg];
        
        tf = [MyControl createTextFieldWithFrame:CGRectMake(code.frame.origin.x+size.width+3, code.frame.origin.y, 190-size.width-3, 20) placeholder:nil passWord:NO leftImageView:nil rightImageView:nil Font:15];
        tf.borderStyle = 0;
        tf.returnKeyType = UIReturnKeyDone;
        tf.delegate = self;
        tf.backgroundColor = [UIColor clearColor];
        [self.bgImageView addSubview:tf];
        
        lab1.text = @"填写邀请码，成为TA的粉丝，获得邀请奖励";
        lab2.text = @"没有邀请码？向宠物星球的小伙伴索要吧";
        
        lab1.frame = CGRectMake(10, 90, self.bgImageView.frame.size.width-20, 40);
        lab1.numberOfLines = 0;
//        lab1.textAlignment = NSTextAlignmentLeft;
        
        lab2.frame = CGRectMake(10, 125, self.bgImageView.frame.size.width-20, 40);
        lab2.numberOfLines = 0;
//        lab2.textAlignment = NSTextAlignmentLeft;
        
    }else if(self.alertType == 2){
        lab1.text = @"捧TA成功，路人转粉~";
        CGRect rect1 = lab1.frame;
        rect1.origin.y += 10;
        lab1.frame = rect1;
        
        lab2.hidden = YES;
        
        UIView * bgView = [MyControl createViewWithFrame:CGRectMake(0, 274/2, self.bgImageView.frame.size.width, 20)];
        [self.bgImageView addSubview:bgView];
        
        UILabel * label1 = [MyControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:15 Text:@"邀请奖励300"];
        label1.textColor = BGCOLOR;
        [bgView addSubview:label1];
        
        CGSize size1 = [label1.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
        
        UIImageView * gold = [MyControl createImageViewWithFrame:CGRectMake(label1.frame.origin.x+size1.width, 0, 20, 20) ImageName:@"gold.png"];
        [bgView addSubview:gold];
        
        UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(gold.frame.origin.x+20, 0, 100, 20) Font:15 Text:@"，不客气~"];
        label2.textColor = BGCOLOR;
        [bgView addSubview:label2];
        
        CGSize size2 = [label2.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
        
        float length = label2.frame.origin.x+size2.width;
        bgView.frame = CGRectMake((self.bgImageView.frame.size.width-length)/2.0, 274/2, length, 20);

    }else if(self.alertType == 3){
        lab1.hidden = YES;
        
        lab2.text = [NSString stringWithFormat:@"您已经接受过%@的邀请啦~", self.codeModel.u_name];
        CGRect rect2 = lab2.frame;
        rect2.origin.y += 5;
        lab2.frame = rect2;
        
    }else if(self.alertType == 4){
        self.confirmBtn.hidden = YES;
        
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
#pragma mark - tfDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf resignFirstResponder];
    return YES;
}
-(void)confirmBtnClick
{
    NSLog(@"confirm");
    self.confirmClick(tf.text);
}
-(void)shareClick:(UIButton *)button
{
    //截图
    UIImage * image = [MyControl imageWithView:self.bgImageView];
    
    self.shareClick(button.tag-100, image, self.model.invite_code);
    
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
