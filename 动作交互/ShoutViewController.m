//
//  ShoutViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-8-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ShoutViewController.h"
#define GRAYBLUECOLOR [UIColor colorWithRed:127/255.0 green:151/255.0 blue:179/255.0 alpha:1]
#define LIGHTORANGECOLOR [UIColor colorWithRed:252/255.0 green:123/255.0 blue:81/255.0 alpha:1]
@interface ShoutViewController ()
{
    UIView *bodyView;
    int count;
    UIImageView *RecordImageView;
    UIView *upView;
}
@end

@implementation ShoutViewController
#pragma mark - 初始界面
- (void)createRecordOne
{
    recordHUD = [self alertViewInit:CGSizeMake(300, 425)];
    UIView *totalView =[self shopGiftTitle];
    //上方视图
    upView = [MyControl createViewWithFrame:CGRectMake(0, 0, bodyView.frame.size.width, bodyView.frame.size.height-70)];
    [bodyView addSubview:upView];
    
    UILabel *shakeDescLabel = [MyControl createLabelWithFrame:CGRectMake(upView.frame.size.width/2 - 115, 10, 230, 20) Font:16 Text:@"为萌萌的TA记录每天的叫声吧~"];
    shakeDescLabel.textAlignment = NSTextAlignmentCenter;
    shakeDescLabel.textColor = GRAYBLUECOLOR;
    [upView addSubview:shakeDescLabel];
    
    RecordImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2 - 82, 65, 164, 164) ImageName:@"recordButton.png"];
    [upView addSubview:RecordImageView];
    UIButton *recordButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, RecordImageView.frame.size.width, RecordImageView.frame.size.height) ImageName:nil Target:self Action:@selector(recordAction:) Title:nil];

//    [recordButton addTarget:self action:@selector() forControlEvents:<#(UIControlEvents)#>]
    [RecordImageView addSubview:recordButton];

    //下方视图
    [self addDownView:[NSString stringWithFormat:@"%d",count]];
    recordHUD.customView = totalView;
    [recordHUD show:YES];
}

- (void)recordAction:(UIButton *)sender
{
    NSLog(@"录音");
    RecordImageView.hidden = YES;
    UIImageView *recordBgImageView = [MyControl createImageViewWithFrame:RecordImageView.frame ImageName:@"record_bg.png"];
    [upView addSubview:recordBgImageView];
    UILabel *timerLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2-25, 30, 50, 20) Font:18 Text:@"0:28"];
    timerLabel.textAlignment = NSTextAlignmentCenter;
    timerLabel.textColor = LIGHTORANGECOLOR;
    [upView addSubview:timerLabel];
    
    UILabel *bgLabel = [MyControl createLabelWithFrame:CGRectMake(recordBgImageView.frame.size.width/2-50, recordBgImageView.frame.size.height/2-25/2.0, 100, 25) Font:20 Text:@"松开 结束"];
//    bgLabel.font = [UIFont boldSystemFontOfSize:20];
    bgLabel.textAlignment = NSTextAlignmentCenter;
    [recordBgImageView addSubview:bgLabel];
    
}
//- (UIView *)addUpView
//{
//    UIView *upView = [MyControl createViewWithFrame:CGRectMake(0, 0, bodyView.frame.size.width, bodyView.frame.size.height-70)];
//    [bodyView addSubview:upView];
//    
//    UILabel *shakeDescLabel = [MyControl createLabelWithFrame:CGRectMake(upView.frame.size.width/2 - 115, 10, 230, 20) Font:16 Text:@"为萌萌的TA记录每天的叫声吧~"];
//    shakeDescLabel.textAlignment = NSTextAlignmentCenter;
//    shakeDescLabel.textColor = GRAYBLUECOLOR;
//    [upView addSubview:shakeDescLabel];
//    
//    UIImageView *shakeImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2 - 95, 65, 190, 190) ImageName:@"recordButton.png"];
//    [upView addSubview:shakeImageView];
//    return upView;
//}
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
    
    NSAttributedString *helpPetString = [self firstString:@"让叫一叫" formatString:@"猫君" insertAtIndex:1];
    helpPetLabel.attributedText = helpPetString;
    [helpPetString release];
    [downView addSubview:helpPetLabel];
    
    UILabel *timesLabel = [MyControl createLabelWithFrame:CGRectMake(70, 27, 200, 20) Font:12 Text:nil];
    NSAttributedString *timesString = [self firstString:@"今天还有只爱宠需要叫一叫哦~" formatString:countString insertAtIndex:4];
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
    UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:17 Text:@"叫一叫"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:titleLabel];
    UIButton *closeButton = [MyControl createButtonWithFrame:CGRectMake(260, 10, 20, 20) ImageName:@"30-1.png" Target:self Action:@selector(colseGiftAction) Title:nil];
    [totalView addSubview:closeButton];
    
    bodyView = [MyControl createViewWithFrame:CGRectMake(0, 40, 300, 385)];
    bodyView.backgroundColor = [UIColor whiteColor];
    //    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 385)];
    //    alphaView.backgroundColor = [UIColor whiteColor];
    //    alphaView.alpha = 0.9;
    //    [bodyView addSubview:alphaView];
    [totalView addSubview:bodyView];
    return totalView;
}
-(void)colseGiftAction
{
    [recordHUD hide:YES];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}
#pragma mark - 控制器生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createButton];
    _recording = _playing = _hasCAFFile = NO;

    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100],                  AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatMPEG4AAC],                   AVFormatIDKey,
                              [NSNumber numberWithInt: 2],                              AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityLow],                       AVEncoderAudioQualityKey,
                              nil];
//    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
//    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    _recordedFile = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]]retain];
//    _recordedFile = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@.aac", cfuuidString]]] retain];
    NSLog(@"_recordedFile :%@",_recordedFile);
    NSError* error;
    _recorder = [[AVAudioRecorder alloc] initWithURL:_recordedFile settings:settings error:&error];
    NSLog(@"%@", [error description]);
    if (error)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"your device doesn't support your setting"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
}
//文件大小
- (NSInteger) getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [[[NSFileManager alloc]init] autorelease];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }else{
        return -1;
    }
}
//更新
- (void) timerUpdate
{
    if (_recording)
    {
        int m = _recorder.currentTime / 60;
        int s = ((int) _recorder.currentTime) % 60;
        int ss = (_recorder.currentTime - ((int) _recorder.currentTime)) * 100;
        
        _duration.text = [NSString stringWithFormat:@"%.2d:%.2d %.2d", m, s, ss];
        NSInteger fileSize =  [self getFileSize:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
        _cafFileSize.text = [NSString stringWithFormat:@"%d kb", fileSize/1024];
    }
    if (_playing)
    {
        _progress.progress = _player.currentTime/_player.duration;
    }

}

- (void)recordDemo:(UIButton *)sender
{
    if (!_recording)
    {
        
        _recording = YES;
        [_recorder prepareToRecord];
        _recorder.meteringEnabled = YES;
        [_recorder record];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:.01f
                                                  target:self
                                                selector:@selector(timerUpdate)
                                                userInfo:nil
                                                 repeats:YES];
        [sender setTitle:@"Stop Record" forState:UIControlStateNormal];
    }
    else
    {
        [sender setTitle:@"Start Record" forState:UIControlStateNormal];
        _recording = NO;
        
        [_timer invalidate];
        _timer = nil;
        
        if (_recorder != nil )
        {
            _hasCAFFile = YES;
            _playBtn.enabled = YES;
        }
        [_recorder stop];
        [_recorder release];
        _recorder = nil;
    }

}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"%d", flag);
    [_timer invalidate];
    _timer = nil;
    _playing = NO;
}
#pragma mark - 临时button
- (void)createButton
{
    NSArray *array1 = @[@"录音",@"播放",@"暂停"];
    for (int i = 0 ; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(50, 100+(i*100), 100, 100);
        [button setTitle:array1[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    NSArray *array2 = @[@"停止录音",@"购买成功",@"送礼物"];
    for (int i = 0; i < array2.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(150, 100+(i*100), 100, 100);
        [button setTitle:array2[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    
    _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 50, 100, 10)];
    [self.view addSubview:_progress];
    _progress.progressViewStyle = UIProgressViewStyleBar;
    _progress.trackTintColor = [UIColor blackColor];
    _progress.progressTintColor = [UIColor redColor];
}
- (void)buttonAction:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"录音"]) {
//        [self recordDemo:sender];
        [_recorder prepareToRecord];
        _recorder.meteringEnabled = YES;
        [_recorder record];
        _hasCAFFile = YES;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:.01f target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];

    }else if ([sender.currentTitle isEqualToString:@"播放"]){
        
        NSError *playerError;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recordedFile error:&playerError];
        _player.meteringEnabled = YES;
        if (_player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        _player.delegate = self;
    
    _playing = YES;
    [_player play];
    _timer = [NSTimer scheduledTimerWithTimeInterval:.1
                                              target:self
                                            selector:@selector(timerUpdate)
                                            userInfo:nil
                                             repeats:YES];
    
    }else if ([sender.currentTitle isEqualToString:@"暂停"]){
        
    }else if ([sender.currentTitle isEqualToString:@"停止录音"]){
        
        [_timer invalidate];
        _timer = nil;
        
        //停止，发送
        [_recorder stop];
        [_recorder release];
        _recorder = nil;
    }else if ([sender.currentTitle isEqualToString:@"购买成功"]){
        [self createRecordOne];
        
    }else if ([sender.currentTitle isEqualToString:@"送礼物"]){
        
    }
    
}
@end
