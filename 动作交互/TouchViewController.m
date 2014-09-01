//
//  TouchViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-8-26.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "TouchViewController.h"
#import "HYScratchCardView.h"
#define GRAYBLUECOLOR [UIColor colorWithRed:127/255.0 green:151/255.0 blue:179/255.0 alpha:1]
#define LIGHTORANGECOLOR [UIColor colorWithRed:252/255.0 green:123/255.0 blue:81/255.0 alpha:1]

@interface TouchViewController ()
{
    UIView *bodyView;
}
@property (nonatomic, strong) HYScratchCardView *scratchCardView;
@end

@implementation TouchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backgroundView];
    // Do any additional setup after loading the view.
//    [self createButton];
    _recordedFile = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]]retain];
}



- (void)viewDidAppear:(BOOL)animated
{
    NSString *touchState =  [USER objectForKey:@"touch"];
    if ([touchState intValue]==1) {
        [self createTouchEndView];
    }else{
        [self createAlertView];
    }
}
- (void)backgroundView
{
    UIView *bgView = [MyControl createViewWithFrame:self.view.frame];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
}
#pragma mark - 摸一摸界面
- (void)createAlertView
{
    [self shopGiftTitle];
    
    UILabel *descLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, bodyView.frame.size.width, 40) Font:16 Text:@"摸摸萌照，听美妙叫叫"];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = GRAYBLUECOLOR;
    [bodyView addSubview:descLabel];
    
    UIImageView *touchImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2-130, 40, 260, 180) ImageName:@"cat2.jpg"];
    touchImageView.layer.cornerRadius = 10;
    touchImageView.layer.masksToBounds = YES;
    [bodyView addSubview:touchImageView];
    UIImage *imageDemo = [touchImageView.image applyBlurWithRadius:60.0 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    
    self.scratchCardView = [[HYScratchCardView alloc]initWithFrame:touchImageView.frame];
    self.scratchCardView.layer.cornerRadius = 10;
    self.scratchCardView.layer.masksToBounds = YES;
    self.scratchCardView.surfaceImage = imageDemo;
    [imageDemo release];
    self.scratchCardView.image = touchImageView.image;
    [bodyView addSubview:self.scratchCardView];
    
    self.scratchCardView.completion = ^(id userInfo) {
        NSLog(@"%d",self.scratchCardView.isOpen);
        [ControllerManager HUDImageIcon:@"gold.png" showView:bodyView yOffset:-50.0 Number:100];
        [self shareViewCreate];
        [self audioPlayerCreate];

        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        [userdef setObject:@"1" forKey:@"touch"];
    };
    [self addDownView];
}

- (void)addDownView
{
    UIView *downView = [MyControl createViewWithFrame:CGRectMake(0, bodyView.frame.size.height-70, bodyView.frame.size.width, 70)];
    [bodyView addSubview:downView];
    
    UIImageView *headImageView = [MyControl createImageViewWithFrame:CGRectMake(10, 0, 56, 56) ImageName:@"cat2.jpg"];
    headImageView.layer.cornerRadius = 28;
    headImageView.layer.masksToBounds = YES;
    [downView addSubview:headImageView];
    
    UIImageView *cricleHeadImageView = [MyControl createImageViewWithFrame:headImageView.frame ImageName:@"head_cricle.png"];
    [downView addSubview:cricleHeadImageView];
    UILabel *helpPetLabel = [MyControl createLabelWithFrame:CGRectMake(70, 15, 200, 20) Font:12 Text:nil];
    
    NSAttributedString *helpPetString = [self firstString:@"摸摸~" formatString:@" 猫君 " insertAtIndex:2];
    helpPetLabel.attributedText = helpPetString;
    [helpPetString release];
    [downView addSubview:helpPetLabel];
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

- (void)shareViewCreate
{
    UIView *playAndPauseView = [MyControl createViewWithFrame:CGRectMake(10, 10, 30, 30)];
    playAndPauseView.layer.cornerRadius = 15;
    playAndPauseView.layer.masksToBounds = YES;
    playAndPauseView.backgroundColor = LIGHTORANGECOLOR;
    [self.scratchCardView addSubview:playAndPauseView];
    playAndPauseImageView = [MyControl createImageViewWithFrame:CGRectMake(8, 8, 15, 15) ImageName:@"record_play.png"];
    [playAndPauseView addSubview:playAndPauseImageView];
    UIButton *playAndPauseButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) ImageName:nil Target:self Action:@selector(playAction) Title:nil];
    [playAndPauseView addSubview:playAndPauseButton];
    
    UIView *shareView = [MyControl createViewWithFrame:CGRectMake(bodyView.frame.size.width/2-195/2.0, 250, 195, 50)];
    [bodyView addSubview:shareView];
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
    [bodyView addSubview:shareTextLabel];
}
//分享
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
- (void)audioPlayerCreate
{
    NSError *playerError;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recordedFile error:&playerError];
    _player.meteringEnabled = YES;
    if (_player == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }
    _player.delegate = self;
    playAndPauseImageView.image = [UIImage imageNamed:@"record_pause.png"];
    [_player play];
}
//播放叫一叫
- (void)playAction
{
    if (isplaying) {
        [_player pause];
        isplaying = NO;
        playAndPauseImageView.image = [UIImage imageNamed:@"record_play.png"];
        
    }else{
        if (_player == nil)
        {
            [self audioPlayerCreate];
            isplaying = YES;
        }else{
            playAndPauseImageView.image = [UIImage imageNamed:@"record_pause.png"];
            [_player play];
            isplaying = YES;
            
        }
    }
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    playAndPauseImageView.image = [UIImage imageNamed:@"record_play.png"];
}
- (UIView *)shopGiftTitle
{
    UIView *totalView = [MyControl createViewWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-425/2.0, 300, 425)];
    totalView.layer.cornerRadius = 10;
    totalView.layer.masksToBounds = YES;
    [self.view addSubview:totalView];
    UIImageView *titleView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 300, 40) ImageName:@"title_bg.png"];
    [totalView addSubview:titleView];
    UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:17 Text:@"摸一摸"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:titleLabel];
    UIImageView *closeImageView = [MyControl createImageViewWithFrame:CGRectMake(260, 10, 20, 20) ImageName:@"30-1.png"];
    [totalView addSubview:closeImageView];
    UIButton *closeButton = [MyControl createButtonWithFrame:CGRectMake(252.5, 2.5, 35, 35) ImageName:nil Target:self Action:@selector(colseGiftAction) Title:nil];
    closeButton.showsTouchWhenHighlighted = YES;
    [totalView addSubview:closeButton];
    
    
    bodyView = [MyControl createViewWithFrame:CGRectMake(0, 40, 300, 385)];
    bodyView.backgroundColor = [UIColor whiteColor];
//    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 385)];
//    alphaView.backgroundColor = [UIColor whiteColor];
//    alphaView.alpha = 0.8;
//    [bodyView addSubview:alphaView];
    [totalView addSubview:bodyView];
    return bodyView;
}
#pragma mark - 摸完界面
- (void)createTouchEndView
{
    UIView *totalView = [MyControl createViewWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-425/2.0, 300, 425)];
    totalView.layer.cornerRadius = 10;
    totalView.layer.masksToBounds = YES;
    totalView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:totalView];
    UIImageView *titleView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 300, 40) ImageName:@"title_bg.png"];
    [totalView addSubview:titleView];
    UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:17 Text:@"摸一摸"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:titleLabel];
    UIButton *closeButton = [MyControl createButtonWithFrame:CGRectMake(260, 10, 20, 20) ImageName:@"30-1.png" Target:self Action:@selector(colseGiftAction) Title:nil];
    [totalView addSubview:closeButton];
    
    
    UIView *endbodyView = [MyControl createViewWithFrame:CGRectMake(0, 40, 300, 385)];
    [totalView addSubview:endbodyView];
    
    UILabel *descLabel = [MyControl createLabelWithFrame:CGRectMake(totalView.frame.size.width/2-85,100,170,60) Font:16 Text:@"今天已经摸过 猫君 啦 期待明天的萌照摸摸吧~"];
//    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = GRAYBLUECOLOR;
    [totalView addSubview:descLabel];
    //
    UIImageView *recordedEndImageView = [MyControl createImageViewWithFrame:CGRectMake(endbodyView.frame.size.width/2 - 96/2,120,96, 110) ImageName:@"nochance.png"];
    [endbodyView addSubview:recordedEndImageView];
    //
    UIView *downView = [MyControl createViewWithFrame:CGRectMake(0, endbodyView.frame.size.height-70, endbodyView.frame.size.width, 70)];
    [endbodyView addSubview:downView];
    
    UIImageView *headImageView = [MyControl createImageViewWithFrame:CGRectMake(10, 0, 56, 56) ImageName:@"cat2.jpg"];
    headImageView.layer.cornerRadius = 28;
    headImageView.layer.masksToBounds = YES;
    [downView addSubview:headImageView];
    
    UIImageView *cricleHeadImageView = [MyControl createImageViewWithFrame:headImageView.frame ImageName:@"head_cricle.png"];
    [downView addSubview:cricleHeadImageView];
    UILabel *helpPetLabel = [MyControl createLabelWithFrame:CGRectMake(70, 15, 200, 20) Font:12 Text:nil];
    
    NSAttributedString *helpPetString = [self firstString:@"摸摸~" formatString:@" 猫君 " insertAtIndex:2];
    helpPetLabel.attributedText = helpPetString;
    [helpPetString release];
    [downView addSubview:helpPetLabel];
    [USER setObject:@"0" forKey:@"touch"];
    
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
- (void)buttonAction:(UIButton *)sender
{
    [self createAlertView];
}

- (void)colseGiftAction
{
    [_player stop];
    [_player release],_player=nil;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
