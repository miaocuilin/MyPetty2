//
//  Alert_BegFoodViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "Alert_BegFoodViewController.h"

@interface Alert_BegFoodViewController () <UMSocialUIDelegate>
{
    NSTimer * timer;
}
@end

@implementation Alert_BegFoodViewController

//- (void)dealloc
//{
//    [super dealloc];
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
}
-(void)makeUI
{
    //黑 %60  白 %80
    UIView * alphaView = [MyControl createViewWithFrame:[UIScreen mainScreen].bounds];
    alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.view addSubview:alphaView];
    
    bgView = [MyControl createViewWithFrame:CGRectMake(18, ([UIScreen mainScreen].bounds.size.height-300)/2.0, [UIScreen mainScreen].bounds.size.width-36, 300)];
    [self.view addSubview:bgView];
    
    UIView * whiteBg = [MyControl createViewWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
    whiteBg.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    whiteBg.layer.cornerRadius = 10;
    whiteBg.layer.masksToBounds = YES;
    [bgView addSubview:whiteBg];
    
    UIButton * closeBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width-36, 0, 36, 36) ImageName:@"various_close.png" Target:self Action:@selector(closeBtnClick) Title:nil];
    [bgView addSubview:closeBtn];
    
    //
//    UILabel * name = [MyControl createLabelWithFrame:CGRectMake(258/2, 30, bgView.frame.size.width-258/2, 20) Font:14 Text:self.name];
//    name.textColor = ORANGE;
//    [bgView addSubview:name];
    UILabel * lab1 = [MyControl createLabelWithFrame:CGRectMake(258/2, 45, bgView.frame.size.width-258/2, 20) Font:15 Text:@"不在应用，也能赏粮！"];
    lab1.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [bgView addSubview:lab1];
    
    UILabel * lab2 = [MyControl createLabelWithFrame:CGRectMake(lab1.frame.origin.x, lab1.frame.origin.y+lab1.frame.size.height+5, bgView.frame.size.width-258/2, 20) Font:11 Text:@"每天都有免费打赏的机会哦~"];
    lab2.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [bgView addSubview:lab2];
    
    NSString * str3 = [NSString stringWithFormat:@"快分享给小伙伴，一起为%@助力！", self.name];
    CGSize size3 = [str3 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(lab2.frame.size.width-10, 100) lineBreakMode:1];
    UILabel * lab3 = [MyControl createLabelWithFrame:CGRectMake(lab2.frame.origin.x, lab2.frame.origin.y+lab2.frame.size.height+20, bgView.frame.size.width-258/2-10, size3.height) Font:13 Text:nil];
    lab3.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [bgView addSubview:lab3];
    
    NSMutableAttributedString * mutableStr3 = [[NSMutableAttributedString alloc] initWithString:str3];
    [mutableStr3 addAttribute:NSForegroundColorAttributeName value:ORANGE range:NSMakeRange(11, self.name.length)];
    lab3.attributedText = mutableStr3;
    [mutableStr3 release];
    //
    bigImage = [MyControl createImageViewWithFrame:CGRectMake(8, 10, lab1.frame.origin.x-20, 160) ImageName:@""];
    bigImage.contentMode = UIViewContentModeScaleAspectFit;
    
    NSURL *url = [MyControl returnThumbImageURLwithName:[self.dict objectForKey:@"url"] Width:bigImage.frame.size.width*2 Height:bigImage.frame.size.height*2];
    [bigImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"water_white.png"]];
    
    [bgView addSubview:bigImage];
    
    //
    UIView * bgView1 = [MyControl createViewWithFrame:CGRectZero];
    [bgView addSubview:bgView1];
    
    
    UIImageView * foodImage = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 32, 32) ImageName:@"exchange_orangeFood.png"];
    [bgView1 addSubview:foodImage];
    
//    bgView.frame.size.height-214/2
    NSString * str1 = [self.dict objectForKey:@"food"];
    CGSize size1 = [str1 sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(100, 32) lineBreakMode:1];
    UILabel * foodNum = [MyControl createLabelWithFrame:CGRectMake(foodImage.frame.origin.x+foodImage.frame.size.width+5, 0, size1.width, 32) Font:17 Text:[self.dict objectForKey:@"food"]];
    foodNum.textColor = ORANGE;
    [bgView1 addSubview:foodNum];
    
    UIImageView * clock = [MyControl createImageViewWithFrame:CGRectMake(foodNum.frame.origin.x+foodNum.frame.size.width+20, 5, 22, 22) ImageName:@"clock.png"];
    [bgView1 addSubview:clock];
    
    NSString * str2 = [NSString stringWithFormat:@"%@", [MyControl leftTimeFromStamp:[self.dict objectForKey:@"create_time"]]];
    CGSize size2 = [str2 sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(200, 32) lineBreakMode:1];
    deadLine = [MyControl createLabelWithFrame:CGRectMake(clock.frame.origin.x+clock.frame.size.width+5, 0, size2.width, 32) Font:17 Text:str2];
    deadLine.textColor = ORANGE;
    
    [self time];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(time) userInfo:nil repeats:YES];
    [bgView1 addSubview:deadLine];
    
    float w = 32+5+size1.width+size2.width+clock.frame.size.width+25;
    bgView1.frame = CGRectMake((bgView.frame.size.width-w)/2.0, bgView.frame.size.height-234/2.0, w, 32);
    
//    float width = bgView.frame.size.width-label1.frame.origin.x-20;
//    NSString * str2 = @"今天也很努力地为自己挣口粮呢，分享给小伙伴，助TA一臂之力吧！";
//    CGSize size2 = [str2 sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(width, 100) lineBreakMode:1];
//    UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y+label1.frame.size.height+15, width, size2.height) Font:13 Text:str2];
//    label2.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
//    [bgView addSubview:label2];
    
    NSArray * array = @[@"various_weChat.png", @"various_friendCircle", @"various_sina.png"];
    float spe = (bgView.frame.size.width-100-46*3)/2.0;
    for (int i=0; i<3; i++) {
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(50+(46+spe)*i, bgView.frame.size.height-70, 46, 46) ImageName:array[i] Target:self Action:@selector(shareClick:) Title:nil];
        button.tag = 1000+i;
        [bgView addSubview:button];
    }
    
    
//
//    UILabel * label3 = [MyControl createLabelWithFrame:CGRectMake(12, bgView.frame.size.height-30, bgView.frame.size.width-12, 15) Font:10 Text:@"每人每天都有免费赏粮机会快喊小伙伴一起打赏吧~"];
//    label3.textColor = ORANGE;
//    [bgView addSubview:label3];
}
-(void)time
{
    deadLine.text = [NSString stringWithFormat:@"%@", [MyControl leftTimeFromStamp:[self.dict objectForKey:@"create_time"]]];
    
}
-(void)closeBtnClick
{
    [timer invalidate];
    timer = nil;
    [ControllerManager deleTabBarViewController:self];
}
-(void)shareClick:(UIButton *)sender
{
//    return;
//    int a = sender.tag-1000;
    //截图
//    UIImage * image = [MyControl imageWithView:bgView];
    
    /**************/
    if(sender.tag == 1000){
        NSLog(@"微信");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@", WEBBEGFOODAPI, [self.dict objectForKey:@"img_id"]];
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"轻轻一点，免费赏粮！我的口粮全靠你啦~";
        NSString * str = nil;
        if ([[self.dict objectForKey:@"cmt"] length]) {
            str = [self.dict objectForKey:@"cmt"];
        }else{
            str = @"看在我这么努力卖萌的份上快来宠宠我！免费送我点口粮好不好？";
        }
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:str image:bigImage.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self shareSuccess];
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
            }
            
        }];
    }else if(sender.tag == 1001){
        NSLog(@"朋友圈");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@", WEBBEGFOODAPI, [self.dict objectForKey:@"img_id"]];
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"轻轻一点，免费赏粮！我的口粮全靠你啦~";
        NSString * str = nil;
        if ([[self.dict objectForKey:@"cmt"] length]) {
            str = [self.dict objectForKey:@"cmt"];
        }else{
            str = @"看在我这么努力卖萌的份上快来宠宠我！免费送我点口粮好不好？";
        }
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:str image:bigImage.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self shareSuccess];
                [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"分享成功"];
                //            StartLoading;
                //            [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"分享失败"];
            }
            
        }];
        //
//        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
////                [self loadShakeShare];
//                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
//            }else{
//                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
//            }
//            
//        }];
    }else if(sender.tag == 1002){
        NSLog(@"微博");
        NSString * string = nil;
        if ([[self.dict objectForKey:@"cmt"] length]) {
            string = [self.dict objectForKey:@"cmt"];
        }else{
            string = @"看在我这么努力卖萌的份上快来宠宠我！免费送我点口粮好不好？";
        }
        NSString * str = [NSString stringWithFormat:@"%@#挣口粮#%@（分享自@宠物星球社交应用）", string, [NSString stringWithFormat:@"%@%@", WEBBEGFOODAPI, [self.dict objectForKey:@"img_id"]]];
        
        //
        BOOL oauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
        NSLog(@"%d", oauth);
        if (oauth) {
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:bigImage.image socialUIDelegate:self];
                //设置分享内容和回调对象
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            }];
        }else{
            [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:bigImage.image socialUIDelegate:self];
            //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
//
//        //
        
        //
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:bigImage.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
////                [self loadShakeShare];
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
    //    NSLog(@"%@", response);
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享成功！");
        [self shareSuccess];
        
        [MyControl popAlertWithView:self.view Msg:@"分享成功"];
    }else{
        NSLog(@"失败原因：%@", response);
        
        [MyControl popAlertWithView:self.view Msg:@"分享失败"];
    }
}
-(void)shareSuccess
{
    if (self.is_food == 1) {
        [MobClick event:@"food_share_suc"];
    }else{
        NSArray * menuList = [USER objectForKey:@"MenuList"];
        if (menuList.count <2) {
            [MobClick event:@"food_share_suc"];
        }else{
            //匹配
            for(int i=1;i<menuList.count;i++){
                if ([menuList[i] integerValue] == self.is_food) {
                    if (i == 1) {
                        [MobClick event:@"topic1_share_suc"];
                    }else if(i == 2){
                        [MobClick event:@"topic2_share_suc"];
                    }
                }else if(i == menuList.count-1){
                    [MobClick event:@"food_share_suc"];
                }
            }
        }
    }
    
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
