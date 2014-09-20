//
//  TouchViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-8-26.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "TouchViewController.h"
#import "HYScratchCardView.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#define GRAYBLUECOLOR [UIColor colorWithRed:127/255.0 green:151/255.0 blue:179/255.0 alpha:1]
#define LIGHTORANGECOLOR [UIColor colorWithRed:252/255.0 green:123/255.0 blue:81/255.0 alpha:1]

@interface TouchViewController ()
{
    UIView *bodyView;
}
@property (nonatomic, strong) HYScratchCardView *scratchCardView;
@end

@implementation TouchViewController

- (BOOL)getRecord
{
    if (!_haveRecord) {
        _haveRecord = NO;
    }
    return _haveRecord;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backgroundView];
    _recordedFile = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]]retain];
//    [self loadRecordStringData];
    [self checkIsTouch];
}
- (void)backgroundView
{
    UIView *bgView = [MyControl createViewWithFrame:self.view.frame];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
}
#pragma mark - 是否已经摸一摸

- (void)checkIsTouch
{
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",[USER objectForKey:@"aid"]]];
    NSString *isTouch = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",ISTOUCHAPI,[USER objectForKey:@"aid"],sig,[ControllerManager getSID]];
    NSLog(@"isTouch:%@",isTouch);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:isTouch Block:^(BOOL isFinish, httpDownloadBlock *load) {
        NSLog(@"是否已经摸过：%@",load.dataDict);
        if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"is_touched"] intValue]) {
            [self createTouchEndView];
        }else{
            [self loadRecordStringData];
        }
    }];
    [request release];
    
}
#pragma mark - 下载声音

- (void)loadRecordStringData
{
    StartLoading;
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",[USER objectForKey:@"aid"]]];
    NSString *downloadRecord = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",RECORDDOWNLOADAPI,[USER objectForKey:@"aid" ],sig,[ControllerManager getSID]];
    NSLog(@"下载API:%@",downloadRecord);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:downloadRecord Block:^(BOOL isFinsh, httpDownloadBlock *load) {
        NSLog(@"isFinsh:%d,load.dataDict:%@",isFinsh,load.dataDict);
        if (isFinsh) {
            self.haveRecord = YES;
            self.recordURL = [NSString stringWithFormat:@"http://54.199.161.210:8001/%@",[[load.dataDict objectForKey:@"data"] objectForKey:@"url"]];
            [self loadRecordData];
        }else{
            [self createAlertView];
            LoadingSuccess;
        }
    }];
    [request release];
}
- (void)loadRecordData
{
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:self.recordURL Block:^(BOOL isFinish, httpDownloadBlock *load) {
//        NSLog(@"load.data音频二进制数据:%@",load.data);
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYYMMdd"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        [load.data writeToFile:[DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.mp3",locationString,[USER objectForKey:@"aid"]]] atomically:YES];
        [dateformatter release];
        _player = [[AVAudioPlayer alloc] initWithData:load.data error:nil];
        [self createAlertView];
        LoadingSuccess;
    }];
    [request release];
}
#pragma mark - 摸一摸api
- (void)touchAPIData
{
    StartLoading;
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",[USER objectForKey:@"aid"]]];
    NSString *touchString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",TOUCHAPI,[USER objectForKey:@"aid"],sig,[ControllerManager getSID]];
    NSLog(@"摸一摸api:%@",touchString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:touchString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        NSLog(@"摸一摸数据：%@",load.dataDict);
        if (isFinish) {
            int tempGold = [[USER objectForKey:@"gold"] intValue];
            [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"gold"] forKey:@"gold"];
            int tempExp = [[USER objectForKey:@"exp"] intValue];
            [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"exp"] forKey:@"exp"];
            int gold = [[USER objectForKey:@"gold"] intValue]-tempGold;
            int exp = [[USER objectForKey:@"exp"] intValue]-tempExp;
            
            [ControllerManager HUDImageIcon:@"gold.png" showView:self.view.window yOffset:-50.0 Number:gold];
            [ControllerManager HUDImageIcon:@"Star.png" showView:self.view.window yOffset:0 Number:exp];
        }
        LoadingSuccess;
    }];
    [request release];
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
    
    if (!([[USER objectForKey:@"a_tx"] length]==0 || [[USER objectForKey:@"a_tx"] isKindOfClass:[NSNull class]])) {
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@_headImage.png.png", DOCDIR, [USER objectForKey:@"aid"]];
        UIImage *animalHeaderImage = [UIImage imageWithContentsOfFile:pngFilePath];
        if (animalHeaderImage) {
            touchImageView.image = animalHeaderImage;
        }else{
            httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@",PETTXURL,[USER objectForKey:@"a_tx"]] Block:^(BOOL isFinish, httpDownloadBlock *load) {
                if (isFinish) {
                    touchImageView.image = load.dataImage;
                    [load.data writeToFile:pngFilePath atomically:YES];
                }
            }];
            [request release];
        }
    }

    
    touchImageView.layer.cornerRadius = 10;
    touchImageView.layer.masksToBounds = YES;
    [bodyView addSubview:touchImageView];
    UIImage *imageDemo = [touchImageView.image applyBlurWithRadius:60.0 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    
    self.scratchCardView = [[HYScratchCardView alloc]initWithFrame:touchImageView.frame];
    self.scratchCardView.layer.cornerRadius = 10;
    self.scratchCardView.layer.masksToBounds = YES;
    self.scratchCardView.surfaceImage = imageDemo;
    self.scratchCardView.image = touchImageView.image;
    [bodyView addSubview:self.scratchCardView];
    
    self.scratchCardView.completion = ^(id userInfo) {
        NSLog(@"%d",self.scratchCardView.isOpen);
        [self touchAPIData];
        [self shareViewCreate];
        if ([self getRecord]) {
            [self audioPlayerCreate];
        }
    };
    [self addDownView];
}

- (void)addDownView
{
    UIView *downView = [MyControl createViewWithFrame:CGRectMake(0, bodyView.frame.size.height-70, bodyView.frame.size.width, 70)];
    [bodyView addSubview:downView];
    
    UIImageView *headImageView = [MyControl createImageViewWithFrame:CGRectMake(10, 0, 56, 56) ImageName:@"defaultPetHead.png"];
    if (!([[USER objectForKey:@"a_tx"] length]==0 || [[USER objectForKey:@"a_tx"] isKindOfClass:[NSNull class]])) {
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@_headImage.png.png", DOCDIR, [USER objectForKey:@"aid"]];
        UIImage *animalHeaderImage = [UIImage imageWithContentsOfFile:pngFilePath];
        if (animalHeaderImage) {
            headImageView.image = animalHeaderImage;
        }else{
            httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@",PETTXURL,[USER objectForKey:@"a_tx"]] Block:^(BOOL isFinish, httpDownloadBlock *load) {
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
    UILabel *helpPetLabel = [MyControl createLabelWithFrame:CGRectMake(70, 15, 200, 20) Font:12 Text:nil];

    NSAttributedString *helpPetString = [self firstString:@"摸摸~" formatString:[NSString stringWithFormat:@" %@ ",[self.animalInfoDict objectForKey:@"name"]] insertAtIndex:2];
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
//    NSError *playerError;
//    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recordedFile error:&playerError];
    _player.meteringEnabled = YES;
    if (_player == nil)
    {
//        NSLog(@"ERror creating player: %@", [playerError description]);
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
    
    UILabel *descLabel = [MyControl createLabelWithFrame:CGRectMake(totalView.frame.size.width/2-85,100,170,60) Font:16 Text:[NSString stringWithFormat:@"今天已经摸过 %@ 啦 期待明天的萌照摸摸吧~",[USER objectForKey:@"a_name"]]];
//    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = GRAYBLUECOLOR;
    [totalView addSubview:descLabel];
    //
    UIImageView *recordedEndImageView = [MyControl createImageViewWithFrame:CGRectMake(endbodyView.frame.size.width/2 - 96/2,120,96, 110) ImageName:@"nochance.png"];
    [endbodyView addSubview:recordedEndImageView];
    //
    UIView *downView = [MyControl createViewWithFrame:CGRectMake(0, endbodyView.frame.size.height-70, endbodyView.frame.size.width, 70)];
    [endbodyView addSubview:downView];
    
    UIImageView *headImageView = [MyControl createImageViewWithFrame:CGRectMake(10, 0, 56, 56) ImageName:@"defaultPetHead.png"];
    
    if (!([[USER objectForKey:@"a_tx"] length]==0 || [[USER objectForKey:@"a_tx"] isKindOfClass:[NSNull class]])) {
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@_headImage.png.png", DOCDIR, [USER objectForKey:@"aid"]];
        UIImage *animalHeaderImage = [UIImage imageWithContentsOfFile:pngFilePath];
        if (animalHeaderImage) {
            headImageView.image = animalHeaderImage;
        }else{
            httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@",PETTXURL,[USER objectForKey:@"a_tx"]] Block:^(BOOL isFinish, httpDownloadBlock *load) {
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
    UILabel *helpPetLabel = [MyControl createLabelWithFrame:CGRectMake(70, 15, 200, 20) Font:12 Text:nil];
    
    NSAttributedString *helpPetString = [self firstString:@"摸摸~" formatString:[NSString stringWithFormat:@" %@ ",[USER objectForKey:@"a_name"]] insertAtIndex:2];
    helpPetLabel.attributedText = helpPetString;
    [helpPetString release];
    [downView addSubview:helpPetLabel];
}

- (void)colseGiftAction
{
    [_player stop];
    [_player release],_player=nil;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
#pragma mark - streamer
- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}
- (void)createStreamer:(NSString *)recordString
{
	if (streamer)
	{
		return;
	}
    
    //	[self destroyStreamer];
//    NSString *demo = @"http://54.199.161.210:8001/assets/voices/ani/voice_14-09-14_2000000241";
    NSLog(@"recordURL:%@",self.recordURL);
    NSString *escapedValue =
    [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                         nil,
                                                         (CFStringRef)self.recordURL,
                                                         NULL,
                                                         NULL,
                                                         kCFStringEncodingUTF8)
     autorelease];
    NSLog(@"escaped:%@",escapedValue);
	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
}
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
        playAndPauseImageView.image = [UIImage imageNamed:@"record_play.png"];
	}
	else if ([streamer isPlaying])
	{
        playAndPauseImageView.image = [UIImage imageNamed:@"record_pause.png"];
        
	}
	else if ([streamer isIdle])
	{
		[self destroyStreamer];
        playAndPauseImageView.image = [UIImage imageNamed:@"record_play.png"];
	}
}

@end
