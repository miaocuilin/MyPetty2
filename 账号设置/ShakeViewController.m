//
//  ShakeViewController.m
//  MyPetty
//
//  Created by Aidi on 14-7-25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ShakeViewController.h"
#import "GiftShopModel.h"

#define GRAYBLUECOLOR [UIColor colorWithRed:127/255.0 green:151/255.0 blue:179/255.0 alpha:1]
#define LIGHTORANGECOLOR [UIColor colorWithRed:252/255.0 green:123/255.0 blue:81/255.0 alpha:1]
@interface ShakeViewController ()
{
    UIView *bodyView;
    BOOL isShaking;
    BOOL isGold;
    BOOL isGoods;
    BOOL isUnfortunately;
    UIView *noChanceView;
    int count;
}
@property (nonatomic,retain)NSMutableArray *goodGiftDataArray;
@property (nonatomic,retain)NSMutableArray *badGiftDataArray;
@end

@implementation ShakeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self createButton];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rocking" ofType:@"wav"];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"rocked" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path2], &soundID2);
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    [self addGiftShopData];

}
- (void)viewWillAppear:(BOOL)animated
{
    [self loadShakeDataInit];

}
- (void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadShakeData) name:@"shake" object:nil];
    [self createNoChanceView];
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

- (void)soundEnd:(int)index
{
    AudioServicesPlaySystemSound(soundID2);
    isShaking = NO;
    if (!count) {
        [self createNoChanceAlertView];
    }else{
        if (isGold) {
            [goldHUD hide:YES];
            isGold = NO;
            [self choosenView:index];
        }else if (isGoods){
            [goodsHUD hide:YES];
            isGoods = NO;
            [self choosenView:index];

        }else if(isUnfortunately){
            [unfortunately hide:YES];
            isUnfortunately = NO;
            [self choosenView:index];
        }else{
            [alertView hide:YES];
            [self choosenView:index];
        }
    }

}

- (void)choosenView:(int)index
{
    count--;
//    int choosen = arc4random()%3;
//    NSLog(@"choosen:%d",choosen);
//    if (choosen == 0) {
//        isUnfortunately =YES;
//        [self createUnfortunatelyAlertView];
//    }else if ( choosen == 1){
//        isGold = YES;
//        [self createGoldAlertView];
//    }else if (choosen == 2){
//        isGoods = YES;
//        [self createGoodsAlertView];
//    }
        isGoods = YES;
        [self createGoodsAlertView];
//    [ControllerManager HUDImageIcon:@"Star.png" showView:self.view.window yOffset:0 Number:index];
}
- (void)soundAction
{
    AudioServicesPlaySystemSound (soundID);

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
            count = index;
            [self createAlertView];

        }
    }];
    [request release];
}
- (void)loadShakeData
{
    //animal/shakeApi&aid=
    NSString *shakeSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",[self.animalInfoDict objectForKey:@"aid"]]];
    NSString *shakeString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",SHAKEAPI,[self.animalInfoDict objectForKey:@"aid"],shakeSig,[ControllerManager getSID]];
    NSLog(@"摇一摇：%@",shakeString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:shakeString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        NSLog(@"摇一摇数据：%@",load.dataDict);
        if (isFinish) {
           int index = [[[load.dataDict objectForKey:@"data"] objectForKey:@"shake_count"] intValue];
            count = index;
            if (!count) {
                [goodsHUD hide:YES];
                [unfortunately hide:YES];
                [goldHUD hide:YES];
                [noChanceHUD hide:YES];
                [alertView hide:YES];
//                [self createNoChanceAlertView];
//                [noChanceHUD show:YES];
                noChanceView.hidden = NO;
                
            }else{
                if (!isShaking) {
                    AudioServicesPlaySystemSound (soundID);
                    isShaking = YES;
                    [self sendGiftData];
                }
            }
            
        }
    }];
    [request release];
}
#pragma mark - 摇出的奖品送礼
- (void)addGiftShopData
{
    self.goodGiftDataArray =[NSMutableArray arrayWithCapacity:0];
    self.badGiftDataArray = [NSMutableArray arrayWithCapacity:0];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"shopGift" ofType:@"plist"];
    NSMutableDictionary *DictData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *level0 = [[DictData objectForKey:@"good"] objectForKey:@"level0"];
    NSArray *level1 =[[DictData objectForKey:@"good"] objectForKey:@"level1"];
    NSArray *level2 =[[DictData objectForKey:@"good"] objectForKey:@"level2"];
    NSArray *level3 =[[DictData objectForKey:@"good"] objectForKey:@"level3"];
    [self addData:level0 isGood:YES];
    [self addData:level1 isGood:YES];
    [self addData:level2 isGood:YES];
    [self addData:level3 isGood:YES];
    
    NSArray *level4 =[[DictData objectForKey:@"bad"] objectForKey:@"level0"];
    NSArray *level5 =[[DictData objectForKey:@"bad"] objectForKey:@"level1"];
    NSArray *level6 =[[DictData objectForKey:@"bad"] objectForKey:@"level2"];
    [self addData:level4 isGood:NO];
    [self addData:level5 isGood:NO];
    [self addData:level6 isGood:NO];
    
    //    NSLog(@"data:%@",DictData);
}
- (void)addData:(NSArray *)array isGood:(BOOL)good
{
    for (NSDictionary *dict in array) {
        GiftShopModel *model = [[GiftShopModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        if (good) {
            [self.goodGiftDataArray addObject:model];
        }else{
            [self.badGiftDataArray addObject:model];
        }
        [model release];
    }
}
- (void)sendGiftData
{
    [self soundAction];
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
            [self soundEnd:index];

        }

        
        
    }];
    [request release];
    
}

#pragma mark - 摇到礼物界面
- (void)createGoodsAlertView
{
    GiftShopModel *model;
    int index ;
    NSString * add_rq;
    if ([self.titleString isEqualToString:@"摇一摇"]) {
        index = arc4random()%(self.goodGiftDataArray.count);
        model = self.goodGiftDataArray[index];
        add_rq = [NSString stringWithFormat:@"+%@",model.add_rq];
    }else{
        index = arc4random()%(self.badGiftDataArray.count);
        model = self.badGiftDataArray[index];
        add_rq = model.add_rq;
    }
    goodsHUD = [self alertViewInit:CGSizeMake(300, 425)];
    UIView *totalView = [self shopGiftTitle];
    
    [self goldAndGiftUpView:[NSString stringWithFormat:@"%@1个",model.name] rewardImage:[NSString stringWithFormat:@"%@.png",model.no] isGold:NO];
    UIImageView *descGoodsImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2-65, 190, 130, 25) ImageName:@"reward_desc.png"];
    [bodyView addSubview:descGoodsImageView];
    UILabel *descGoodsLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, descGoodsImageView.frame.size.width, descGoodsImageView.frame.size.height) Font:14 Text:[NSString stringWithFormat:@"%@人气 %@",[self.animalInfoDict objectForKey:@"name"],add_rq]];
    descGoodsLabel.textAlignment = NSTextAlignmentCenter;
    [descGoodsImageView addSubview:descGoodsLabel];
    
    [self addDownView:[NSString stringWithFormat:@"%d",count]];
    goodsHUD.customView = totalView;
    [goodsHUD show:YES];
    //
    [ControllerManager HUDText:[NSString stringWithFormat:@"%@收到了一个%@，人气%@",[self.animalInfoDict objectForKey:@"name"],model.name,add_rq] showView:self.view.window yOffset:-60.0];
}

#pragma mark - 摇到金币界面
- (void)createGoldAlertView
{
    goldHUD = [self alertViewInit:CGSizeMake(300, 425)];
    UIView *totalView = [self shopGiftTitle];
    [self goldAndGiftUpView:[NSString stringWithFormat:@"金币%d个",10] rewardImage:@"gold.png" isGold:YES];
    [self addDownView:[NSString stringWithFormat:@"%d",count]];
    goldHUD.customView = totalView;
    [goldHUD show:YES];
}
- (void)goldAndGiftUpView:(NSString *)titleString rewardImage:(NSString *)imageString isGold:(BOOL)gold
{
    UIView *upView = [MyControl createViewWithFrame:CGRectMake(0, 0, bodyView.frame.size.width, bodyView.frame.size.height-70)];
    [bodyView addSubview:upView];
    
    UILabel *shakeDescLabel = [MyControl createLabelWithFrame:CGRectMake(upView.frame.size.width/2 - 115, 10, 230, 20) Font:16 Text:@"哎呦~运气不错哦~为萌主摇出"];
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
    UIImageView *goldImgeView = [MyControl createImageViewWithFrame:CGRectZero ImageName:imageString];
    if (gold) {
        goldImgeView.frame = CGRectMake(rewardBGImageView.frame.size.width/2-35, rewardBGImageView.frame.size.height/2-35, 70, 70);
    }else{
        goldImgeView.frame = CGRectMake(rewardBGImageView.frame.size.width/2-45, rewardBGImageView.frame.size.height/2-30, 90, 60);
    }
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
    [self unfortunatelyUpView:[NSString stringWithFormat:@"摇一摇，摇到外婆桥 %@今天的摇一摇次数用完了，换个萌主试试吧~",[self.animalInfoDict objectForKey:@"name"]] imageString:@"nochance.png"];
    [self addDownView:[NSString stringWithFormat:@"%d",count]];
    noChanceHUD.customView = totalView;
    noChanceHUD.removeFromSuperViewOnHide = NO;
//    [noChanceHUD show:YES];
}
- (void)createNoChanceView
{
    UIView *alpaView = [MyControl createViewWithFrame:self.view.frame];
    alpaView.backgroundColor = [UIColor blackColor];
    alpaView.alpha = 0.6;
    [self.view addSubview:alpaView];
    noChanceView = [MyControl createViewWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-212, 300, 425)];
    [self.view addSubview:noChanceView];
    noChanceView.layer.cornerRadius = 10;
    noChanceView.layer.masksToBounds = YES;
    UIImageView *titleView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 300, 40) ImageName:@"title_bg.png"];
    [noChanceView addSubview:titleView];
    UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:17 Text:@"摇一摇"];
    titleLabel.text = self.titleString;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [noChanceView addSubview:titleLabel];
    UIImageView *closeImageView = [MyControl createImageViewWithFrame:CGRectMake(260, 10, 20, 20) ImageName:@"30-1.png"];
    [noChanceView addSubview:closeImageView];
    UIButton *closeButton = [MyControl createButtonWithFrame:CGRectMake(252.5, 2.5, 35, 35) ImageName:nil Target:self Action:@selector(colseGiftAction) Title:nil];
    closeButton.showsTouchWhenHighlighted = YES;
    [noChanceView addSubview:closeButton];
    
    
    //    bodyView = nil;
    UIView *bodyViewChance = [MyControl createViewWithFrame:CGRectMake(0, 40, 300, 385)];
    bodyViewChance.backgroundColor = [UIColor whiteColor];
    [noChanceView addSubview:bodyViewChance];
    
    
    UIView *upView = [MyControl createViewWithFrame:CGRectMake(0, 0, bodyViewChance.frame.size.width, bodyViewChance.frame.size.height-70)];
    [bodyViewChance addSubview:upView];
    
    UILabel *shakeDescLabel = [MyControl createLabelWithFrame:CGRectMake(upView.frame.size.width/2 - 115, 10, 230, 60) Font:16 Text:[NSString stringWithFormat:@"摇一摇，摇到外婆桥 %@今天的摇一摇次数用完了，换个萌主试试吧~",[self.animalInfoDict objectForKey:@"name"]]];
    shakeDescLabel.textColor = GRAYBLUECOLOR;
    [upView addSubview:shakeDescLabel];
    
    UIImageView *shakeImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyViewChance.frame.size.width/2 - 95, 65, 190, 190) ImageName:@"nochance.png"];
    [upView addSubview:shakeImageView];
    
    UIView *downView = [MyControl createViewWithFrame:CGRectMake(0, bodyViewChance.frame.size.height-70, bodyView.frame.size.width, 70)];
    [bodyViewChance addSubview:downView];
    
    
    
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
    
    UIImageView *cricleHeadImageView = [MyControl createImageViewWithFrame:headImageView.frame ImageName:@"head_cricle.png"];
    [downView addSubview:cricleHeadImageView];
    UILabel *helpPetLabel = [MyControl createLabelWithFrame:CGRectMake(70, 5, 200, 20) Font:12 Text:nil];
    
    NSAttributedString *helpPetString = [self firstString:@"帮摇一摇" formatString:[self.animalInfoDict objectForKey:@"name"] insertAtIndex:1];
    helpPetLabel.attributedText = helpPetString;
    [helpPetString release];
    [downView addSubview:helpPetLabel];
    
    UILabel *timesLabel = [MyControl createLabelWithFrame:CGRectMake(70, 27, 200, 20) Font:12 Text:nil];
    NSAttributedString *timesString = [self firstString:@"今天还有次机会哦~" formatString:[NSString stringWithFormat:@"%d",count] insertAtIndex:4];
    timesLabel.attributedText = timesString;
    [timesString release];
    [downView addSubview:timesLabel];
    
    noChanceView.hidden = YES;
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
    
    UILabel *shakeDescLabel = [MyControl createLabelWithFrame:CGRectMake(upView.frame.size.width/2 - 115, 10, 230, 20) Font:16 Text:@"每天摇一摇，精美礼品大放送~"];
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
    UIImageView *headImageView = [MyControl createImageViewWithFrame:CGRectMake(10, 0, 56, 56) ImageName:@"defaultPetHead.png"];
    if (!([[self.animalInfoDict objectForKey:@"tx"] length]==0 || [[self.animalInfoDict objectForKey:@"tx"] isKindOfClass:[NSNull class]])) {
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@_headImage.png.png", DOCDIR, [self.animalInfoDict objectForKey:@"aid"]];
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
    
    UIImageView *cricleHeadImageView = [MyControl createImageViewWithFrame:headImageView.frame ImageName:@"head_cricle.png"];
    [downView addSubview:cricleHeadImageView];
    UILabel *helpPetLabel = [MyControl createLabelWithFrame:CGRectMake(70, 5, 200, 20) Font:12 Text:nil];
    
    NSAttributedString *helpPetString = [self firstString:@"帮摇一摇" formatString:[self.animalInfoDict objectForKey:@"name"] insertAtIndex:1];
    helpPetLabel.attributedText = helpPetString;
    [helpPetString release];
    [downView addSubview:helpPetLabel];
    
    UILabel *timesLabel = [MyControl createLabelWithFrame:CGRectMake(70, 27, 200, 20) Font:12 Text:nil];
    NSAttributedString *timesString = [self firstString:@"今天还有次机会哦~" formatString:countString insertAtIndex:4];
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
    titleLabel.text = self.titleString;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:titleLabel];
    UIImageView *closeImageView = [MyControl createImageViewWithFrame:CGRectMake(260, 10, 20, 20) ImageName:@"30-1.png"];
    [totalView addSubview:closeImageView];
    UIButton *closeButton = [MyControl createButtonWithFrame:CGRectMake(252.5, 2.5, 35, 35) ImageName:nil Target:self Action:@selector(colseGiftAction) Title:nil];
    closeButton.showsTouchWhenHighlighted = YES;
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


@end
