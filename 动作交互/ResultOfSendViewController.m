//
//  ResultOfSendViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ResultOfSendViewController.h"

@interface ResultOfSendViewController ()

@end

@implementation ResultOfSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    
}
-(void)makeUI
{
    self.view.alpha = 0;
    //600 852
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-304)/2.0, (self.view.frame.size.height-426)/2.0, 304, 426) ImageName:@"shake_sendBg.png"];
    [self.view addSubview:self.bgImageView];
    
    //title
    self.titleLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, self.bgImageView.frame.size.width, 37) Font:17 Text:nil];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:self.titleLabel];
    
    //close
    self.closeBtn = [MyControl createButtonWithFrame:CGRectMake(self.bgImageView.frame.size.width-15-8, 11, 15, 15) ImageName:@"alert_x.png" Target:self Action:@selector(closeClick) Title:nil];
    [self.bgImageView addSubview:self.closeBtn];
    
    //
    label1 = [MyControl createLabelWithFrame:CGRectMake(0, 60, self.bgImageView.frame.size.width, 15) Font:13 Text:nil];
    label1.textColor = BGCOLOR;
    label1.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:label1];
    
    label2 = [MyControl createLabelWithFrame:CGRectMake(0, 60, self.bgImageView.frame.size.width, 15) Font:13 Text:nil];
    label2.textColor = BGCOLOR;
    label2.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:label2];
    
    label3 = [MyControl createLabelWithFrame:CGRectMake(0, 60, self.bgImageView.frame.size.width, 15) Font:13 Text:nil];
    label3.textColor = BGCOLOR;
    label3.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:label3];
    
    
    UIImageView * circle = [MyControl createImageViewWithFrame:CGRectMake((self.bgImageView.frame.size.width-80)/2.0, 143, 80, 80) ImageName:@"head_cricle1.png"];
    [self.bgImageView addSubview:circle];
    
    self.headImageView = [MyControl createImageViewWithFrame:CGRectMake(6, 6, 68, 68) ImageName:@""];
    self.headImageView.layer.cornerRadius = 34;
    self.headImageView.layer.masksToBounds = YES;
    [circle addSubview:self.headImageView];
    
    //
    self.confirmBtn = [MyControl createButtonWithFrame:CGRectMake((self.bgImageView.frame.size.width-100)/2.0, 490/2.0, 100, 35) ImageName:@"alert_greenBg.png" Target:self Action:@selector(confirmClick) Title:@"确定"];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.bgImageView addSubview:self.confirmBtn];
    
    //分享
    UIView * shareBg = [MyControl createViewWithFrame:CGRectMake(0, 300, self.bgImageView.frame.size.width, 53)];
    [self.bgImageView addSubview:shareBg];
    
    UIView * shareAlphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, shareBg.frame.size.width, shareBg.frame.size.height)];
    shareAlphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    [shareBg addSubview:shareAlphaView];
    
    UILabel * shareLabel = [MyControl createLabelWithFrame:CGRectMake(15, 0, 50, shareBg.frame.size.height) Font:12 Text:@"分享"];
    shareLabel.textColor = BGCOLOR;
    [shareBg addSubview:shareLabel];
    
    NSArray * array = @[@"more_weixin.png", @"more_friend.png", @"more_sina.png"];
    float space = (self.bgImageView.frame.size.width-50-50-37*3)/2.0;
    
    for (int i=0; i<3; i++) {
        UIButton * btn = [MyControl createButtonWithFrame:CGRectMake(50+(space+37)*i, 8, 37, 37) ImageName:array[i] Target:self Action:@selector(shareClick:) Title:nil];
        [shareBg addSubview:btn];
        btn.tag = 100+i;
    }
    
    //
    UIImageView * roundBg = [MyControl createImageViewWithFrame:CGRectMake(18, 356, 53, 53) ImageName:@"head_cricle1.png"];
    [self.bgImageView addSubview:roundBg];
    
    //
    self.headImage = [MyControl createImageViewWithFrame:CGRectMake(3.5, 3.5, 46, 46) ImageName:@"defaultPetHead.png"];
    self.headImage.layer.cornerRadius = 23;
    self.headImage.layer.masksToBounds = YES;
    [roundBg addSubview:self.headImage];
    
    //
    self.actLabel = [MyControl createLabelWithFrame:CGRectMake(75, 360, 220, 53-8) Font:12 Text:nil];
    self.actLabel.textColor = BGCOLOR;
    [self.bgImageView addSubview:self.actLabel];
}

-(void)configUIWithName:(NSString *)name ItemId:(NSString *)itemId Tx:(NSString *)tx
{
    self.titleLabel.text = @"摇一摇";
    
    self.actLabel.text = @"每天只能送1个礼物哦~\n每日第一次成功分享后可以多送1个礼物~";
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PETTXURL, tx]] placeholderImage:[UIImage imageNamed:@"defaultPetHead.png"]];
    [self.headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PETTXURL, tx]] placeholderImage:[UIImage imageNamed:@"defaultPetHead.png"]];
    NSDictionary * dict = [ControllerManager returnGiftDictWithItemId:itemId];
    
    label1.text = [NSString stringWithFormat:@"%@收到了您送的%@", name, [dict objectForKey:@"name"]];
    label2.text = [NSString stringWithFormat:@"%@", [ControllerManager returnActionStringWithItemId:itemId]];
    label3.text = [NSString stringWithFormat:@"人气 + %@", [dict objectForKey:@"add_rq"]];
    
    label1.frame = CGRectMake(0, 60, self.bgImageView.frame.size.width, 15);
    
    CGSize size = [label2.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(250, 100) lineBreakMode:1];
    label2.frame = CGRectMake((self.bgImageView.frame.size.width-250)/2.0, 85, 250, size.height);
    
    label3.frame = CGRectMake(0, label2.frame.origin.y+size.height+10, self.bgImageView.frame.size.width, 15);
}
-(void)closeClick
{
    self.closeBlock();
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}
-(void)confirmClick
{
    [self closeClick];
}

//分享
- (void)shareClick:(UIButton *)sender
{
    //截图
    UIImage * image = [MyControl imageWithView:self.bgImageView];
    
    /**************/
    if(sender.tag == 100){
        NSLog(@"微信");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
            }
            
        }];
    }else if(sender.tag == 101){
        NSLog(@"朋友圈");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
            }
            
        }];
    }else if(sender.tag == 102){
        NSLog(@"微博");
        NSString * str = [NSString stringWithFormat:@"随便一摇就摇出了一个%@，好惊喜，你也想试试吗？http://home4pet.aidigame.com/（分享自@宠物星球社交应用）", self.giftName];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
            }else{
                NSLog(@"失败原因：%@", response);
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
            }
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
