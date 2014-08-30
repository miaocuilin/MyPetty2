//
//  ShakeViewController.m
//  MyPetty
//
//  Created by Aidi on 14-7-25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ShakeViewController.h"
#define GRAYBLUECOLOR [UIColor colorWithRed:127/255.0 green:151/255.0 blue:179/255.0 alpha:1]
#define LIGHTORANGECOLOR [UIColor colorWithRed:252/255.0 green:123/255.0 blue:81/255.0 alpha:1]
@interface ShakeViewController ()
{
    UIView *bodyView;
    BOOL isShaking;
    BOOL isGold;
    BOOL isGoods;
    BOOL isUnfortunately;
    
    int count;
}
@end

@implementation ShakeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self createButton];
    count = 10;
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rocking" ofType:@"wav"];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"rocked" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path2], &soundID2);
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ShakingAction) name:@"shake" object:nil];
}
- (void)ShakingAction
{
    if (!count) {
        [goodsHUD hide:YES];
        [unfortunately hide:YES];
        [goldHUD hide:YES];
        [noChanceHUD hide:YES];
        [self createNoChanceAlertView];
        return;
    }
    if (!isShaking) {
        
        AudioServicesPlaySystemSound (soundID);
        [self performSelector:@selector(soundAction) withObject:nil afterDelay:0.2];
        isShaking = YES;
        [self performSelector:@selector(soundEnd:) withObject:nil afterDelay:3.0];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self resignFirstResponder];
}
- (BOOL)canBecomeFirstResponder
{
    return NO;
}

- (void)soundEnd:(MBProgressHUD *)numHUD
{
    AudioServicesPlaySystemSound(soundID2);
    isShaking = NO;
    if (!count) {
        [self createNoChanceAlertView];
    }else{
        if (isGold) {
            [goldHUD hide:YES];
            isGold = NO;
            [self choosenView];
        }else if (isGoods){
            [goodsHUD hide:YES];
            isGoods = NO;
            [self choosenView];

        }else if(isUnfortunately){
            [unfortunately hide:YES];
            isUnfortunately = NO;
            [self choosenView];
        }else{
            [alertView hide:YES];
            [self choosenView];
        }
    }

}

- (void)choosenView
{
    count--;

    int choosen = arc4random()%3;
    NSLog(@"choosen:%d",choosen);
    if (choosen == 0) {
        isUnfortunately =YES;
        [self createUnfortunatelyAlertView];
    }else if ( choosen == 1){
        isGold = YES;
        [self createGoldAlertView];
    }else if (choosen == 2){
        isGoods = YES;
        [self createGoodsAlertView];
    }
}
- (void)soundAction
{
    AudioServicesPlaySystemSound (soundID);

}

#pragma mark - 摇到礼物界面
- (void)createGoodsAlertView
{
    goodsHUD = [self alertViewInit:CGSizeMake(300, 425)];
    UIView *totalView = [self shopGiftTitle];
    
    [self goldAndGiftUpView:[NSString stringWithFormat:@"宠物香波%d个",1] rewardImage:@"bdog6_2.png"];
    UIImageView *descGoodsImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2-65, 190, 130, 25) ImageName:@"reward_desc.png"];
    [bodyView addSubview:descGoodsImageView];
    UILabel *descGoodsLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, descGoodsImageView.frame.size.width, descGoodsImageView.frame.size.height) Font:14 Text:@"猫君人气 +100"];
    descGoodsLabel.textAlignment = NSTextAlignmentCenter;
    [descGoodsImageView addSubview:descGoodsLabel];
    
    [self addDownView:[NSString stringWithFormat:@"%d",count]];
    goodsHUD.customView = totalView;
    [goodsHUD show:YES];
}

#pragma mark - 摇到金币界面
- (void)createGoldAlertView
{
    goldHUD = [self alertViewInit:CGSizeMake(300, 425)];
    UIView *totalView = [self shopGiftTitle];
    [self goldAndGiftUpView:[NSString stringWithFormat:@"金币%d个",10] rewardImage:@"gold.png"];
    [self addDownView:[NSString stringWithFormat:@"%d",count]];
    goldHUD.customView = totalView;
    [goldHUD show:YES];
}
- (void)goldAndGiftUpView:(NSString *)titleString rewardImage:(NSString *)imageString
{
    UIView *upView = [MyControl createViewWithFrame:CGRectMake(0, 0, bodyView.frame.size.width, bodyView.frame.size.height-70)];
    [bodyView addSubview:upView];
    
    UILabel *shakeDescLabel = [MyControl createLabelWithFrame:CGRectMake(upView.frame.size.width/2 - 115, 10, 230, 20) Font:16 Text:@"哎吆运气不错吆~恭喜摇出"];
    shakeDescLabel.textAlignment = NSTextAlignmentCenter;
    shakeDescLabel.textColor = GRAYBLUECOLOR;
    [upView addSubview:shakeDescLabel];
    
    
    UILabel *titleLabel = [MyControl createLabelWithFrame:CGRectMake(upView.frame.size.width/2-100, 40, 200, 15) Font:16 Text:titleString];
    [upView addSubview:titleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = LIGHTORANGECOLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    UIImageView *rewardBGImageView = [MyControl createImageViewWithFrame:CGRectMake(upView.frame.size.width/2-58, 55, 115, 130) ImageName:@"reward_bg.png"];
    [upView addSubview:rewardBGImageView];
    UIImageView *goldImgeView = [MyControl createImageViewWithFrame:CGRectMake(rewardBGImageView.frame.size.width/2-35, rewardBGImageView.frame.size.height/2-35, 70, 70) ImageName:imageString];
    [rewardBGImageView addSubview:goldImgeView];
    
    
    
    UIView *shareView = [MyControl createViewWithFrame:CGRectMake(upView.frame.size.width/2-195/2.0, 250, 195, 50)];
    [upView addSubview:shareView];
    NSArray *array = @[@"rock_weixin.png",@"rock_pengyou.png",@"rock_xinlang.png"];
    NSArray *arrayDesc = @[@"微信好友",@"朋 友 圈",@"微 博"];
    for (int i = 0; i < 3; i++) {
        UIImageView *shareImageView = [MyControl createImageViewWithFrame:CGRectMake(0+shareView.frame.size.width/3 * i +(i*15), 0, 36, 36) ImageName:array[i]];
        [shareView addSubview:shareImageView];
        UIButton *shareButton = [MyControl createButtonWithFrame:shareImageView.frame ImageName:nil Target:self Action:@selector(shareAction:) Title:nil];
        shareButton.tag = 77+i;
        [shareButton setShowsTouchWhenHighlighted:YES];
        [shareView addSubview:shareButton];
        UILabel *label = [MyControl createLabelWithFrame:CGRectMake(shareImageView.frame.origin.x, 38, 40, 14) Font:10 Text:arrayDesc[i]];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [shareView addSubview:label];
    }
    
    UILabel *shareTextLabel = [MyControl createLabelWithFrame:CGRectMake(55, 230, 50, 15) Font:12 Text:@"分享到"];
    shareTextLabel.textColor = [UIColor grayColor];
    [upView addSubview:shareTextLabel];
}
- (void)shareAction:(UIButton *)sender
{
    if (sender.tag == 77) {
        NSLog(@"微信");
    }else if (sender.tag == 78){
        NSLog(@"朋友");
    }else{
        NSLog(@"新浪");

    }
}
#pragma mark - 次数用完界面
- (void)createNoChanceAlertView
{
    noChanceHUD = [self alertViewInit:CGSizeMake(300, 425)];
    UIView *totalView =[self shopGiftTitle];
    [self unfortunatelyUpView:@"摇一摇，要到外婆桥。猫君今天的摇一摇次数用完啦，换个宠物试试吧~" imageString:@"nochance.png"];
    [self addDownView:[NSString stringWithFormat:@"%d",count]];
    noChanceHUD.customView = totalView;
    [noChanceHUD show:YES];
}
#pragma mark - 一无所获界面
- (void)createUnfortunatelyAlertView
{
    unfortunately = [self alertViewInit:CGSizeMake(300, 425)];
    UIView *totalView =[self shopGiftTitle];
    [self unfortunatelyUpView:@"这次什么都没有摇出......再试一次吧" imageString:@"unfortunately.png"];
    [self addDownView:[NSString stringWithFormat:@"%d",count]];
    unfortunately.customView = totalView;
    [unfortunately show:YES];
}
- (void)unfortunatelyUpView:(NSString *)descString imageString:(NSString *)imageString
{
    UIView *upView = [MyControl createViewWithFrame:CGRectMake(0, 0, bodyView.frame.size.width, bodyView.frame.size.height-70)];
    [bodyView addSubview:upView];
    
    UILabel *shakeDescLabel = [MyControl createLabelWithFrame:CGRectMake(upView.frame.size.width/2 - 115, 10, 230, 60) Font:16 Text:descString];
    shakeDescLabel.textColor = GRAYBLUECOLOR;
    [upView addSubview:shakeDescLabel];
    
    UIImageView *shakeImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2 - 95, 65, 190, 190) ImageName:imageString];
    [upView addSubview:shakeImageView];
}
#pragma mark - 初始界面
- (void)createAlertView
{
    alertView = [self alertViewInit:CGSizeMake(300, 425)];
    UIView *totalView =[self shopGiftTitle];
    //上方视图
    UIView *upView = [MyControl createViewWithFrame:CGRectMake(0, 0, bodyView.frame.size.width, bodyView.frame.size.height-70)];
    [bodyView addSubview:upView];
    
    UILabel *shakeDescLabel = [MyControl createLabelWithFrame:CGRectMake(upView.frame.size.width/2 - 115, 10, 230, 20) Font:16 Text:@"每天摇一摇，精彩礼品大放送~"];
    shakeDescLabel.textAlignment = NSTextAlignmentCenter;
    shakeDescLabel.textColor = GRAYBLUECOLOR;
    [upView addSubview:shakeDescLabel];
    
    UIImageView *shakeImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2 - 95, 65, 190, 190) ImageName:@"rock.png"];
    [upView addSubview:shakeImageView];
   //下方视图
    [self addDownView:[NSString stringWithFormat:@"%d",count]];
    
    alertView.customView = totalView;
    [alertView show:YES];
}


- (void)addDownView:(NSString *)countString
{
    UIView *downView = [MyControl createViewWithFrame:CGRectMake(0, bodyView.frame.size.height-70, bodyView.frame.size.width, 70)];
    [bodyView addSubview:downView];
    
    UIImageView *headImageView = [MyControl createImageViewWithFrame:CGRectMake(10, 0, 56, 56) ImageName:@"cat2.jpg"];
    headImageView.layer.cornerRadius = 28;
    headImageView.layer.masksToBounds = YES;
    [downView addSubview:headImageView];
    
    UIImageView *cricleHeadImageView = [MyControl createImageViewWithFrame:headImageView.frame ImageName:@"head_cricle.png"];
    [downView addSubview:cricleHeadImageView];
    UILabel *helpPetLabel = [MyControl createLabelWithFrame:CGRectMake(70, 5, 200, 20) Font:12 Text:nil];
    
    NSAttributedString *helpPetString = [self firstString:@"帮摇一摇" formatString:@"猫君" insertAtIndex:1];
    helpPetLabel.attributedText = helpPetString;
    [helpPetString release];
    [downView addSubview:helpPetLabel];
    
    UILabel *timesLabel = [MyControl createLabelWithFrame:CGRectMake(70, 27, 200, 20) Font:12 Text:nil];
    NSAttributedString *timesString = [self firstString:@"今天还有次机会哦~" formatString:countString insertAtIndex:3];
    timesLabel.attributedText = timesString;
    [timesString release];
    [downView addSubview:timesLabel];
}
//一句话两种颜色
- (NSAttributedString *)firstString:(NSString *)string1 formatString:(NSString *)string2 insertAtIndex:(NSInteger)number
{
    NSMutableAttributedString *attributeString2 = [[NSMutableAttributedString alloc] initWithString:string2];
    
    [attributeString2 addAttribute:NSForegroundColorAttributeName value:LIGHTORANGECOLOR range:NSMakeRange(0, attributeString2.length)];
    NSMutableAttributedString *attributeString1 = [[NSMutableAttributedString alloc] initWithString:string1];
    [attributeString1 addAttribute:NSForegroundColorAttributeName value:GRAYBLUECOLOR range:NSMakeRange(0, attributeString1.length)];
    [attributeString1 insertAttributedString:attributeString2 atIndex:number];
    [attributeString2 release];
    return attributeString1;
}
- (MBProgressHUD *)alertViewInit:(CGSize)widthAndHeight
{
    MBProgressHUD * alertViewInit = [[MBProgressHUD alloc] initWithWindow:self.view.window];
    [self.view.window addSubview:alertViewInit];
    alertViewInit.mode = MBProgressHUDModeCustomView;
    alertViewInit.color = [UIColor clearColor];
    alertViewInit.dimBackground = YES;
    alertViewInit.margin = 0 ;
    alertViewInit.removeFromSuperViewOnHide = YES;
    //    alertViewInit.minSize = CGSizeMake(235.0f, 340.0f);
    alertViewInit.minSize = widthAndHeight;
    return alertViewInit;
}

- (UIView *)shopGiftTitle
{
    
    UIView *totalView = [MyControl createViewWithFrame:CGRectMake(0, 0, 300, 425)];
    totalView.layer.cornerRadius = 10;
    totalView.layer.masksToBounds = YES;
    UIImageView *titleView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 300, 40) ImageName:@"title_bg.png"];
    [totalView addSubview:titleView];
    UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:17 Text:@"摇一摇"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:titleLabel];
    UIButton *closeButton = [MyControl createButtonWithFrame:CGRectMake(260, 10, 20, 20) ImageName:@"30-1.png" Target:self Action:@selector(colseGiftAction) Title:nil];
    [totalView addSubview:closeButton];
    
    
//    bodyView = nil;
    bodyView = [MyControl createViewWithFrame:CGRectMake(0, 40, 300, 385)];
    bodyView.backgroundColor = [UIColor whiteColor];
//    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 385)];
//    alphaView.backgroundColor = [UIColor whiteColor];
//    alphaView.alpha = 0.9;
//    [bodyView addSubview:alphaView];
    [totalView addSubview:bodyView];
    return totalView;
}
#pragma mark - 临时button
- (void)createButton
{
    NSArray *array1 = @[@"每日登陆",@"升级经验",@"官职升级"];
    for (int i = 0 ; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(50, 100+(i*100), 100, 100);
        [button setTitle:array1[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    NSArray *array2 = @[@"加入国家",@"购买成功",@"送礼物"];
    for (int i = 0; i < array2.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(150, 100+(i*100), 100, 100);
        [button setTitle:array2[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    
}
- (void)colseGiftAction
{
    if (!isShaking) {
        [alertView hide:YES];
        [unfortunately hide:YES];
        [goodsHUD hide:YES];
        [goldHUD hide:YES];
        [noChanceHUD hide:YES];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
    
    
}

- (void)buttonAction:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"每日登陆"]) {
        [self createNoChanceAlertView];
    }else if ([sender.currentTitle isEqualToString:@"升级经验"]){
        [self createUnfortunatelyAlertView];
    }else if ([sender.currentTitle isEqualToString:@"官职升级"]){
        
    }else if ([sender.currentTitle isEqualToString:@"加入国家"]){
        
    }else if ([sender.currentTitle isEqualToString:@"购买成功"]){
        
    }else if ([sender.currentTitle isEqualToString:@"送礼物"]){
        
    }

}


@end
