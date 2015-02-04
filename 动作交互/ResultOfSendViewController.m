//
//  ResultOfSendViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ResultOfSendViewController.h"

@interface ResultOfSendViewController () <UMSocialUIDelegate>

@end

@implementation ResultOfSendViewController
- (void)dealloc
{
    [super dealloc];
    [_bgImageView release];
    [_headImageView release];
    [_titleLabel release];
    [_rqLabel release];
    [_headImage release];
    [_actLabel release];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    
}
-(void)makeUI
{
//    self.view.alpha = 0;
    //596 852  有效宽度596
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-304)/2.0, (self.view.frame.size.height-426)/2.0, 304, 426) ImageName:@"alert_sendGift_good.png"];
    [self.view addSubview:self.bgImageView];
    
    //title
    self.titleLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, self.bgImageView.frame.size.width, 37) Font:17 Text:nil];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:self.titleLabel];
    
    //close
    self.closeBtn = [MyControl createButtonWithFrame:CGRectMake(self.bgImageView.frame.size.width-20-10, 8.5, 20, 20) ImageName:@"" Target:self Action:@selector(closeClick) Title:nil];
    [self.bgImageView addSubview:self.closeBtn];
    
    //转动动画
    UIView * rollView = [MyControl createViewWithFrame:CGRectMake(0, 75/2.0, self.bgImageView.frame.size.width, self.bgImageView.frame.size.height-75/2.0)];
    rollView.layer.cornerRadius = 10;
    rollView.layer.masksToBounds = YES;
    [self.bgImageView addSubview:rollView];
    
    UIImageView * rollImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 500*1.2, 940/2*1.2) ImageName:@"send_shine.png"];
    rollImageView.center = CGPointMake(rollView.center.x, rollView.center.y-75/4.0-60);
    [rollView addSubview:rollImageView];
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 10;
//    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = NSUIntegerMax;
    [rollImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
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
    UIImageView * roundBg = [MyControl createImageViewWithFrame:CGRectMake(9, 352, 60, 60) ImageName:@"head_cricle1.png"];
    [self.bgImageView addSubview:roundBg];
    
    //
    self.headImage = [MyControl createImageViewWithFrame:CGRectMake(3.5, 3.5, 54, 54) ImageName:@"defaultPetHead.png"];
    self.headImage.layer.cornerRadius = 27;
    self.headImage.layer.masksToBounds = YES;
    [roundBg addSubview:self.headImage];
    
    //
    self.actLabel = [MyControl createLabelWithFrame:CGRectMake(75, 360, 220, 53-8) Font:12 Text:nil];
    self.actLabel.textColor = BGCOLOR;
    [self.bgImageView addSubview:self.actLabel];
}

-(void)configUIWithName:(NSString *)name ItemId:(NSString *)itemId Tx:(NSString *)tx
{
    self.pet_tx = tx;
    self.pet_name = name;
    
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
    UIImage * image = nil;
    if([self.pet_tx isKindOfClass:[NSString class]] && self.pet_tx.length && self.headImageView.image != nil){
        image = self.headImageView.image;
    }else{
        image = [UIImage imageNamed:@"record_upload.png"];
    }

    /**************/
    if(sender.tag == 100){
        NSLog(@"微信");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@", PETMAINSHAREAPI, self.pet_aid];
        [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"我是%@，来自宠物星球的大萌星！", self.pet_name];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"人家在宠物星球好开心，快来跟我一起玩嘛~" image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){

            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self loadShakeShare];
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
            }
            
        }];
    }else if(sender.tag == 101){
        NSLog(@"朋友圈");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@", PETMAINSHAREAPI, self.pet_aid];
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"我是%@，来自宠物星球的大萌星！", self.pet_name];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"人家在宠物星球好开心，快来跟我一起玩嘛~" image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){

            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self loadShakeShare];
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
            }
            
        }];
    }else if(sender.tag == 102){
        NSLog(@"微博");
        NSString * str = [NSString stringWithFormat:@"人家在宠物星球好开心，快来跟我一起玩嘛~%@（分享自@宠物星球社交应用）", [NSString stringWithFormat:@"%@%@", PETMAINSHAREAPI, self.pet_aid]];
        
        BOOL oauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
        NSLog(@"%d", oauth);
        if (oauth) {
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:image socialUIDelegate:self];
                //设置分享内容和回调对象
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            }];
        }else{
            [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:image socialUIDelegate:self];
            //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//                [self loadShakeShare];
//                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
//            }else{
//                NSLog(@"失败原因：%@", response);
//                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
//            }
//            
//        }];
    }
}
#pragma mark -
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享成功！");
        [self loadShakeShare];
        [MyControl popAlertWithView:self.view Msg:@"分享成功"];
    }else{
        NSLog(@"失败原因：%@", response);
        [MyControl popAlertWithView:self.view Msg:@"分享失败"];
    }
}

-(void)loadShakeShare
{
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.pet_aid]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", SHAKESHAREAPI, self.pet_aid, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                count = [[[load.dataDict objectForKey:@"data"] objectForKey:@"shake_count"] intValue];
                self.share(count);
            }
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
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
