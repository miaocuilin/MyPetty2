//
//  RockViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-9-19.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "RockViewController.h"
#import "GiftShopModel.h"
#define GRAYBLUECOLOR [UIColor colorWithRed:127/255.0 green:151/255.0 blue:179/255.0 alpha:1]
#define LIGHTORANGECOLOR [UIColor colorWithRed:252/255.0 green:123/255.0 blue:81/255.0 alpha:1]
@interface RockViewController ()
{
    UILabel *timesLabel;
    UILabel *rewardLabel;
    UIImageView *rewardImage;
    UILabel *descRewardLabel;

}
@property (nonatomic,retain)NSMutableArray *goodGiftDataArray;
@property (nonatomic,retain)NSMutableArray *badGiftDataArray;

@property (nonatomic,strong)UIScrollView *upView;
@property (nonatomic)NSInteger count;
@property (nonatomic)BOOL isShaking;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic)BOOL isBack1;
@property (nonatomic)BOOL isBack2;
@property (nonatomic)BOOL isBack3;
@end

@implementation RockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self blackBackGround];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rocking" ofType:@"wav"];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"rocked" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path2], &soundID2);
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    if ([self.titleString isEqualToString:@"捣捣乱"]) {
        self.isTrouble = YES;
    }
    self.goodGiftDataArray = [NSMutableArray arrayWithCapacity:0];
    self.badGiftDataArray = [NSMutableArray arrayWithCapacity:0];
    self.goodGiftDataArray = [ControllerManager getGift:NO];
    self.badGiftDataArray = [ControllerManager getGift:YES];
    [self loadShakeDataInit];
    [self createShakeUI];
}
- (void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shakeAction) name:@"shake" object:nil];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shake" object:nil];
}
- (BOOL)canBecomeFirstResponder
{
    return NO;
}
#pragma mark - 加载摇一摇数据
- (void)loadShakeDataInit
{
    NSString *shakeSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",[self.animalInfoDict objectForKey:@"aid"]]];
    NSString *shakeString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",SHAKEAPI,[self.animalInfoDict objectForKey:@"aid"],shakeSig,[ControllerManager getSID]];
    NSLog(@"摇一摇：%@",shakeString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:shakeString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        NSLog(@"摇一摇数据：%@",load.dataDict);
        if (isFinish) {
            int index = [[[load.dataDict objectForKey:@"data"] objectForKey:@"shake_count"] intValue];
            self.count = index;
            timesLabel.attributedText = [self firstString:@"今天还有次机会哦~" formatString:[NSString stringWithFormat:@"%d",self.count] insertAtIndex:3];
        }
    }];
    [request release];
}
#pragma mark - 赠送礼物界面
- (void)sendGiftData
{
    GiftShopModel *model;
    int index ;
    NSString * add_rq;
    if (!self.isTrouble) {
        index = arc4random()%(self.goodGiftDataArray.count);
        model = self.goodGiftDataArray[index];
        add_rq = [NSString stringWithFormat:@"+%@",model.add_rq];
    }else{
        index = arc4random()%(self.badGiftDataArray.count);
        model = self.badGiftDataArray[index];
        add_rq = model.add_rq;
    }
    rewardLabel.text = [NSString stringWithFormat:@"%@ X 1",model.name];
    rewardImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model.no]];
    descRewardLabel.text = [NSString stringWithFormat:@"%@ 人气 %@",[self.animalInfoDict objectForKey:@"name"],model.add_rq];
    AudioServicesPlaySystemSound (soundID);
    //固定礼物1102
    NSString *item = @"1102";
    NSString *sendSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&is_shake=1&item_id=%@dog&cat",[self.animalInfoDict objectForKey:@"aid"],item]];
    NSString *sendString = [NSString stringWithFormat:@"%@%@&is_shake=1&item_id=%@&sig=%@&SID=%@",SENDSHAKEGIFT,[self.animalInfoDict objectForKey:@"aid"],item,sendSig,[ControllerManager getSID]];
    NSLog(@"赠送url:%@",sendString);
    httpDownloadBlock *request  = [[httpDownloadBlock alloc] initWithUrlStr:sendString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        NSLog(@"赠送数据：%@",load.dataDict);
        int newexp = [[[load.dataDict objectForKey:@"data"] objectForKey:@"exp"] intValue];
        int exp = [[USER objectForKey:@"exp"] intValue];
        [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"exp"] forKey:@"exp"];
        if (exp != newexp && (newexp - exp)>0) {
            int index = newexp - exp;
            self.count--;
            AudioServicesPlaySystemSound(soundID2);
            self.isShaking = NO;
            self.upView.contentOffset = CGPointMake(self.upView.frame.size.width, 0);
            timesLabel.attributedText = [self firstString:@"今天还有次机会哦~" formatString:[NSString stringWithFormat:@"%d",self.count] insertAtIndex:3];
            [ControllerManager HUDImageIcon:@"Star.png" showView:self.view.window yOffset:0 Number:index];
        }
    }];
    [request release];
    
}
#pragma mark - 通知触发的方法
- (void)shakeAction
{
    if (self.count >0) {
        if (!self.isShaking) {
            AudioServicesPlaySystemSound (soundID);
            self.isShaking = YES;
            [self sendGiftData];
        }
    }else{
        self.upView.contentOffset = CGPointMake(self.upView.frame.size.width*3, 0);
    }
}
#pragma mark - 创建界面
- (void)createShakeUI
{
    UIView *totalView = [MyControl createViewWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-212, 300, 425)];
    [self.view addSubview:totalView];
    totalView.layer.cornerRadius = 10;
    totalView.layer.masksToBounds = YES;
    UIImageView *titleView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 300, 40) ImageName:@"title_bg.png"];
    [totalView addSubview:titleView];
    UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:17 Text:@"摇一摇"];
    titleLabel.text = self.titleString;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:titleLabel];
    UIImageView *closeImageView = [MyControl createImageViewWithFrame:CGRectMake(260, 10, 20, 20) ImageName:@"30-1.png"];
    [totalView addSubview:closeImageView];
    UIButton *closeButton = [MyControl createButtonWithFrame:CGRectMake(252.5, 2.5, 35, 35) ImageName:nil Target:self Action:@selector(colseGiftAction) Title:nil];
    closeButton.showsTouchWhenHighlighted = YES;
    [totalView addSubview:closeButton];
    
    
    //    bodyView = nil;
    UIView *bodyView = [MyControl createViewWithFrame:CGRectMake(0, 40, 300, 385)];
    bodyView.backgroundColor = [UIColor whiteColor];
    [totalView addSubview:bodyView];
    
    
    //创建滚动视图
    self.upView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, bodyView.frame.size.width, bodyView.frame.size.height-70)];
    self.upView.pagingEnabled = YES;
    self.upView.showsHorizontalScrollIndicator = NO;
    self.upView.showsVerticalScrollIndicator = NO;
    self.upView.contentSize = CGSizeMake(self.upView.frame.size.width*4, self.upView.frame.size.height);
    self.upView.scrollEnabled = NO;
    [bodyView addSubview:self.upView];
#pragma mark - one
    //1
    UIView *view1 = [MyControl createViewWithFrame:CGRectMake(0, 0, self.upView.frame.size.width, self.upView.frame.size.height)];
    [self.upView addSubview:view1];
    
    UIImageView *shakeBg1 = [MyControl createImageViewWithFrame:CGRectMake(0, 110, view1.frame.size.width, 200) ImageName:@"bluecloudbg.png"];
    [view1 addSubview:shakeBg1];
    UIImageView *floating1 = [MyControl createImageViewWithFrame:CGRectMake(230, 40, 70, 25) ImageName:@"yellowcloud.png"];
    floating1.tag = 30;
    [view1 addSubview:floating1];
    
    UIImageView *floating2 = [MyControl createImageViewWithFrame:CGRectMake(23, 90, 70, 25) ImageName:@"yellowcloud.png"];
    floating2.tag = 31;
    [view1 addSubview:floating2];
    
    UIImageView *floating3 = [MyControl createImageViewWithFrame:CGRectMake(180, 180, 70, 25) ImageName:@"yellowcloud.png"];
    floating3.tag = 32;
    [view1 addSubview:floating3];
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(floatingAnimation) userInfo:nil repeats:YES];
    self.timer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(floatingAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
//    [self.timer fire];
    UILabel *shakeDescLabel1 = [MyControl createLabelWithFrame:CGRectMake(view1.frame.size.width/2 - 115, 10, 230, 20) Font:16 Text:@"每天摇一摇，精彩礼品大放送~"];
    shakeDescLabel1.textAlignment = NSTextAlignmentCenter;
    shakeDescLabel1.textColor = GRAYBLUECOLOR;
    [view1 addSubview:shakeDescLabel1];
    UIImageView *shakeImageView1 = [MyControl createImageViewWithFrame:CGRectMake(view1.frame.size.width/2 - 95, 65, 190, 190) ImageName:@"rock1.png"];
    [view1 addSubview:shakeImageView1];
#pragma mark - two
    //2
    UIView *view2 = [MyControl createViewWithFrame:CGRectMake(self.upView.frame.size.width, 0, self.upView.frame.size.width, self.upView.frame.size.height)];
    [self.upView addSubview:view2];
    UILabel *shakeDescLabel2 = [MyControl createLabelWithFrame:CGRectMake(view2.frame.size.width/2 - 115, 10, 230, 20) Font:16 Text:@"哎吆运气不错吆~恭喜摇出"];
    shakeDescLabel2.textAlignment = NSTextAlignmentCenter;
    shakeDescLabel2.textColor = GRAYBLUECOLOR;
    [view2 addSubview:shakeDescLabel2];
    UIImageView *rewardbg = [MyControl createImageViewWithFrame:CGRectMake(view2.frame.size.width/2-80, 50, 160, 185) ImageName:@"rewardbg.png"];
    [view2 addSubview:rewardbg];
    rewardLabel = [MyControl createLabelWithFrame:CGRectMake(view2.frame.size.width/2-100, 70, 200, 15) Font:16 Text:@"糖果 X 1"];
    [view2 addSubview:rewardLabel];
    rewardLabel.font = [UIFont boldSystemFontOfSize:16];
    rewardLabel.textColor = LIGHTORANGECOLOR;
    rewardLabel.textAlignment = NSTextAlignmentCenter;
    
    rewardImage = [MyControl createImageViewWithFrame:CGRectMake(rewardbg.frame.size.width/2-54, rewardbg.frame.size.height/2-36, 108, 72) ImageName:@"1102.png"];
    [rewardbg addSubview:rewardImage];
    
    descRewardLabel = [MyControl createLabelWithFrame:CGRectMake(0, 140, rewardbg.frame.size.width, 30) Font:12 Text:@"猫君 人气 +10"];
    descRewardLabel.textAlignment = NSTextAlignmentCenter;
    [rewardbg addSubview:descRewardLabel];
    
    UIImageView *share = [MyControl createImageViewWithFrame:CGRectMake(0, 265, view2.frame.size.width, 40) ImageName:@"threeshare.png"];
    [view2 addSubview:share];
    UIView *shareView = [MyControl createViewWithFrame:CGRectMake(view2.frame.size.width/2-195/2.0, 250, 195, 50)];
    [view2 addSubview:shareView];
    for (int i = 0; i<3; i++) {
        UIButton *shareButton = [MyControl createButtonWithFrame:CGRectMake(0+shareView.frame.size.width/3 * i +(i*12), 15, 40, 40) ImageName:nil Target:self Action:@selector(shareAction:) Title:nil];
        shareButton.tag = 77+i;
        [shareButton setShowsTouchWhenHighlighted:YES];
        [shareView addSubview:shareButton];
    }
#pragma mark - three
    //3
    UIView *view3 = [MyControl createViewWithFrame:CGRectMake(self.upView.frame.size.width*2, 0, self.upView.frame.size.width, self.upView.frame.size.height)];
    [self.upView addSubview:view3];
    
    UIImageView *shakeBg3 = [MyControl createImageViewWithFrame:CGRectMake(0, 150, view3.frame.size.width, 120) ImageName:@"grassnothing.png"];
    [view3 addSubview:shakeBg3];
    UILabel *descNoGiftLabel = [MyControl createLabelWithFrame:CGRectMake(view3.frame.size.width/2-115,10, 230, 100) Font:16 Text:@"如果上天再给我一次机会\n我会 ... 我一定会 ... \n摇到你"];
    descNoGiftLabel.textAlignment = NSTextAlignmentCenter;
    descNoGiftLabel.textColor = GRAYBLUECOLOR;
    [view3 addSubview:descNoGiftLabel];
#pragma mark - four

    //4
    UIView *view4 = [MyControl createViewWithFrame:CGRectMake(self.upView.frame.size.width*3, 0, self.upView.frame.size.width, self.upView.frame.size.height)];
    [self.upView addSubview:view4];
    UILabel *shakeDescLabel = [MyControl createLabelWithFrame:CGRectMake(view4.frame.size.width/2 - 115, 10, 230, 100) Font:16 Text:[NSString stringWithFormat:@"摇一摇，要到外婆桥。\n%@今天的摇一摇次数用完啦~\n换个宠物试试吧~",[self.animalInfoDict objectForKey:@"name"]]];
    shakeDescLabel.textAlignment = NSTextAlignmentCenter;
    shakeDescLabel.textColor = GRAYBLUECOLOR;
    [view4 addSubview:shakeDescLabel];
    UIImageView *shakeBg4 = [MyControl createImageViewWithFrame:CGRectMake(0, 150, view4.frame.size.width, 120) ImageName:@"grassbg.png"];
    [view4 addSubview:shakeBg4];
    UIImageView *shakeImageView = [MyControl createImageViewWithFrame:CGRectMake(view4.frame.size.width/2 - 50, 0, 100, 110) ImageName:@"nochance.png"];
    [shakeBg4 addSubview:shakeImageView];
    //底部视图
#pragma mark - bottom
    UIView *downView = [MyControl createViewWithFrame:CGRectMake(0, bodyView.frame.size.height-70, bodyView.frame.size.width, 70)];
    [bodyView addSubview:downView];
    
    UIImageView *headImageView = [MyControl createImageViewWithFrame:CGRectMake(10, 0, 56, 56) ImageName:@"defaultPetHead.png"];
    if (!([[self.animalInfoDict objectForKey:@"tx"] length]==0 || [[self.animalInfoDict objectForKey:@"tx"] isKindOfClass:[NSNull class]])) {
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@_headImage.png.png", DOCDIR, [USER objectForKey:@"aid"]];
        UIImage *animalHeaderImage = [UIImage imageWithContentsOfFile:pngFilePath];
        if (animalHeaderImage) {
            headImageView.image = animalHeaderImage;
        }else{
            httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@",PETTXURL,[self.animalInfoDict objectForKey:@"tx"]] Block:^(BOOL isFinish, httpDownloadBlock *load) {
                if (isFinish) {
                    headImageView.image = load.dataImage;
                    [load.data writeToFile:pngFilePath atomically:YES];
                }
            }];
            [request release];
        }
    }
    headImageView.layer.cornerRadius = 28;
    headImageView.layer.masksToBounds = YES;
    [downView addSubview:headImageView];
    
    UIImageView *cricleHeadImageView = [MyControl createImageViewWithFrame:headImageView.frame ImageName:@"head_cricle1.png"];
    [downView addSubview:cricleHeadImageView];
    UILabel *helpPetLabel = [MyControl createLabelWithFrame:CGRectMake(70, 5, 200, 20) Font:12 Text:nil];
    
    NSAttributedString *helpPetString = [self firstString:@"帮摇一摇" formatString:[self.animalInfoDict objectForKey:@"name"] insertAtIndex:1];
    helpPetLabel.attributedText = helpPetString;
    [helpPetString release];
    [downView addSubview:helpPetLabel];
    
    timesLabel = [MyControl createLabelWithFrame:CGRectMake(70, 27, 200, 20) Font:12 Text:nil];
    timesLabel.attributedText = [self firstString:@"今天还有次机会哦~" formatString:[NSString stringWithFormat:@"%d",self.count] insertAtIndex:3];
    [downView addSubview:timesLabel];
#pragma mark - 捣捣乱
    if (self.isTrouble) {
        titleLabel.text = @"捣捣乱";
        shakeBg1.image = [UIImage imageNamed:@"blackcloudbg.png"];
        floating1.image = [UIImage imageNamed:@"blackcloud.png"];
        floating2.image = [UIImage imageNamed:@"blackcloud.png"];
        floating3.image = [UIImage imageNamed:@"blackcloud.png"];
        shakeDescLabel1.text = @"娱乐恶作剧，措手不及减人气";
        shakeImageView1.image = [UIImage imageNamed:@"rock2.png"];
        shakeDescLabel2.text = @"哎呦够坏哟~成功摇出";
        rewardbg.image = [UIImage imageNamed:@"badrewardbg.png"];
        shakeBg3.image = [UIImage imageNamed:@"troublenothing.png"];
        descNoGiftLabel.text = @"哈哈，上天没给你机会\n恶作剧不是每一个人都可以哟~";
        shakeDescLabel.text = @"够了~你真是够了！\n你今天的捣捣乱次数用完啦~\n换个宠物继续捣乱吧~";
        shakeBg4.image = [UIImage imageNamed:@"troublenothing.png"];
        shakeImageView.hidden = YES;
        helpPetLabel.attributedText = [self firstString:@"给  恶作剧" formatString:[self.animalInfoDict objectForKey:@"name"] insertAtIndex:2];
    }
}
#pragma mark - button点击事件
- (void)colseGiftAction
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (void)shareAction:(UIButton *)sender
{
    
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
#pragma mark - 浮云
- (void)floatingAnimation
{
    UIImageView *floating1 = (UIImageView *)[self.view viewWithTag:30];
    if (!self.isBack1) {
        floating1.frame = CGRectMake(floating1.frame.origin.x-2, 40, 70, 25);
        if (floating1.frame.origin.x<=0) {
            self.isBack1 = YES;
        }
    }else{
        floating1.frame = CGRectMake(floating1.frame.origin.x+2, 40, 70, 25);
        if (floating1.frame.origin.x > 230) {
            self.isBack1 = NO;
        }
    }
    UIImageView *floating2 = (UIImageView *)[self.view viewWithTag:31];
    if (self.isBack2) {
        floating2.frame =CGRectMake(floating2.frame.origin.x+1, 90, 70, 25);
        if (floating2.frame.origin.x >240) {
            self.isBack2 = NO;
        }
    }else{
        floating2.frame =CGRectMake(floating2.frame.origin.x-1, 90, 70, 25);
        if (floating2.frame.origin.x <0) {
            self.isBack2 = YES;
        }
    }
    UIImageView *floating3 = (UIImageView *)[self.view viewWithTag:32];
    if (self.isBack3) {
        floating3.frame =CGRectMake(floating3.frame.origin.x-1.5, 180, 70, 25);
        if (floating3.frame.origin.x <0) {
            self.isBack3 = NO;
        }
    }else{
        floating3.frame =CGRectMake(floating3.frame.origin.x+1.5, 180, 70, 25);
        if (floating3.frame.origin.x >240) {
            self.isBack3 = YES;
        }
    }
}
- (void)blackBackGround
{
    UIView *alpaView = [MyControl createViewWithFrame:self.view.frame];
    alpaView.backgroundColor = [UIColor blackColor];
    alpaView.alpha = 0.6;
    [self.view addSubview:alpaView];
}
@end
