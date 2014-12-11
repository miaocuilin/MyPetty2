//
//  Alert_BegFoodViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "Alert_BegFoodViewController.h"

@interface Alert_BegFoodViewController ()

@end

@implementation Alert_BegFoodViewController

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
    
    bgView = [MyControl createViewWithFrame:CGRectMake(18, ([UIScreen mainScreen].bounds.size.height-230)/2.0, [UIScreen mainScreen].bounds.size.width-36, 230)];
    [self.view addSubview:bgView];
    
    UIView * whiteBg = [MyControl createViewWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
    whiteBg.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    whiteBg.layer.cornerRadius = 10;
    whiteBg.layer.masksToBounds = YES;
    [bgView addSubview:whiteBg];
    
    UIButton * closeBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width-36, 0, 36, 36) ImageName:@"various_close.png" Target:self Action:@selector(closeBtnClick) Title:nil];
    [bgView addSubview:closeBtn];
    
    //
    UILabel * name = [MyControl createLabelWithFrame:CGRectMake(258/2, 30, bgView.frame.size.width-258/2, 20) Font:14 Text:@"猫猫莫按摩按摩"];
    name.textColor = ORANGE;
    [bgView addSubview:name];
    
    NSString * str = @"已收到";
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    UILabel * label1 = [MyControl createLabelWithFrame:CGRectMake(name.frame.origin.x, name.frame.origin.y+name.frame.size.height+15, size.width, 20) Font:17 Text:str];
    label1.textColor = ORANGE;
    [bgView addSubview:label1];
    
    UIImageView * foodImage = [MyControl createImageViewWithFrame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y-6, 32, 32) ImageName:@"exchange_orangeFood"];
    [bgView addSubview:foodImage];
    
    UILabel * foodNum = [MyControl createLabelWithFrame:CGRectMake(foodImage.frame.origin.x+foodImage.frame.size.width+5, foodImage.frame.origin.y, bgView.frame.size.width-foodImage.frame.origin.x-foodImage.frame.size.width-5, foodImage.frame.size.height) Font:17 Text:@"0"];
    foodNum.textColor = ORANGE;
    [bgView addSubview:foodNum];
    
    float width = bgView.frame.size.width-label1.frame.origin.x-20;
    NSString * str2 = @"今天也很努力地为自己挣口粮呢，分享给小伙伴，助TA一臂之力吧！";
    CGSize size2 = [str2 sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(width, 100) lineBreakMode:1];
    UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y+label1.frame.size.height+15, width, size2.height) Font:13 Text:str2];
    label2.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [bgView addSubview:label2];
    
    NSArray * array = @[@"various_weChat.png", @"various_friendCircle", @"various_sina.png"];
    float spe = (bgView.frame.size.width-100-46*3)/2.0;
    for (int i=0; i<3; i++) {
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(50+(46+spe)*i, bgView.frame.size.height-110, 46, 46) ImageName:array[i] Target:self Action:@selector(shareClick:) Title:nil];
        button.tag = 1000+i;
        [bgView addSubview:button];
    }
    
    deadLine = [MyControl createLabelWithFrame:CGRectMake(12, bgView.frame.size.height-50, bgView.frame.size.width-24, 15) Font:13 Text:nil];
    deadLine.textColor = ORANGE;
    [bgView addSubview:deadLine];
    
    UILabel * label3 = [MyControl createLabelWithFrame:CGRectMake(12, bgView.frame.size.height-30, bgView.frame.size.width-12, 15) Font:10 Text:@"每人每天都有免费赏粮机会快喊小伙伴一起打赏吧~"];
    label3.textColor = ORANGE;
    [bgView addSubview:label3];
}
-(void)closeBtnClick
{
    [self.view removeFromSuperview];
}
-(void)shareClick:(UIButton *)sender
{
    return;
//    int a = sender.tag-1000;
    //截图
    UIImage * image = [MyControl imageWithView:bgView];
    
    /**************/
    if(sender.tag == 1000){
        NSLog(@"微信");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
//                [self loadShakeShare];
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
            }
            
        }];
    }else if(sender.tag == 1001){
        NSLog(@"朋友圈");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
//                [self loadShakeShare];
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
            }
            
        }];
    }else if(sender.tag == 1002){
        NSLog(@"微博");
        NSString * str = [NSString stringWithFormat:@"http://home4pet.aidigame.com/（分享自@宠物星球社交应用）"];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
//                [self loadShakeShare];
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
