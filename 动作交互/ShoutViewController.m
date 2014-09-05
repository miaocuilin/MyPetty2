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
@interface ShoutViewController ()<ASIHTTPRequestDelegate, ASIProgressDelegate>
{
    UIView *bodyView;
    int count;
    UIImageView *RecordImageView;
    UIView *upView;
    UIView *totalView;
    
    UIScrollView *upScrollView;
    UIView *initView;
    UIImageView *playAndPauseImageView;
    UILabel *timerLabel;
    UILabel *playingTimerLabel;
    
    UIButton *rerecordingButton;
    UIButton *recordUploadingButton;
    UIImageView *uploadingImageView;
    MBBarProgressView *barUpload;
    MBRoundProgressView *recordProgress;
    MBRoundProgressView *playProgress;
}
@end

@implementation ShoutViewController

#pragma mark - 控制器生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backgroundView];
    
    // Do any additional setup after loading the view.
}
- (void)backgroundView
{
    UIView *bgView = [MyControl createViewWithFrame:self.view.frame];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
}
#pragma mark - 上传声音
- (NSString *)aid
{
    if (!_aid) {
        _aid = [USER objectForKey:@"aid"];
    }
    return _aid;
}
- (void)uploadRecordData
{
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",self.aid]];
    NSString *uploadRecordString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",RECORDUPLOADAPI,self.aid,sig,[ControllerManager getSID]];
    //网络上传
    NSLog(@"postUrl:%@", uploadRecordString);
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:uploadRecordString]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 20;
    NSString *string = [NSString stringWithFormat:@"%@",_recordedFile];
//    NSData *data = [NSData dataWithContentsOfURL:_recordedFile];
    NSData *data = [NSData dataWithContentsOfFile:string];
    NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
    [_request setData:data withFileName:[NSString stringWithFormat:@"%f.acc", timeInterval]
 andContentType:@"audio/MPEG4AAC" forKey:@"voice"];
    [_request setUploadProgressDelegate:self];
    _request.queue = self;
    [_request startAsynchronous];
    
}
-(void)setProgress:(float)newProgress
{
    NSLog(@"上传进度:%f",newProgress);
    [UIView animateWithDuration:0.3 animations:^{
        barUpload.progress = newProgress;

    }];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"上传录音结束");
    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"上传成功"];
    NSLog(@"响应：%@", [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
    upScrollView.contentOffset = CGPointMake(upScrollView.frame.size.width*2, 0);

    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"上传录音失败");
    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"上传失败"];
}

#pragma mark - 初始界面
- (void)createRecordOne
{
    [self shopGiftTitle];
    [self.view addSubview:totalView];
    //上方视图
    upScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, bodyView.frame.size.width, bodyView.frame.size.height-70)];
    
    [bodyView addSubview:upScrollView];
    upScrollView.contentSize = CGSizeMake(upScrollView.frame.size.width*4, upScrollView.frame.size.height);
    upScrollView.pagingEnabled = YES;
    upScrollView.scrollEnabled = NO;
    upView = [MyControl createViewWithFrame:CGRectMake(0, 0, bodyView.frame.size.width, bodyView.frame.size.height-70)];
    
    [upScrollView addSubview:upView];
    //播放和暂停界面
    [self palyAndPauseView];
    //上传完成界面
    [self createRecordLoadedEndView];
    //录制完再次点开的页面显示
    [self createRecordedEndView];
    UILabel *shakeDescLabel = [MyControl createLabelWithFrame:CGRectMake(upView.frame.size.width/2 - 115, 10, 230, 20) Font:16 Text:@"为萌萌的TA记录每天的叫声吧~"];
    shakeDescLabel.textAlignment = NSTextAlignmentCenter;
    shakeDescLabel.textColor = GRAYBLUECOLOR;
    [upView addSubview:shakeDescLabel];
    
    RecordImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2 - 82, 65, 164, 164) ImageName:@"recordButton.png"];
    [upView addSubview:RecordImageView];
    UIButton *recordButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, RecordImageView.frame.size.width, RecordImageView.frame.size.height) ImageName:nil Target:self Action:@selector(recordButtonTouchUp:) Title:nil];
    recordButton.highlighted = YES;
    [recordButton addTarget:self action:@selector(recordButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [recordButton addTarget:self action:@selector(recordButtonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    [RecordImageView addSubview:recordButton];
    
    
    
    initView = [MyControl createViewWithFrame:CGRectMake(0, 0, upView.frame.size.width, upView.frame.size.height)];
    [upView addSubview:initView];
    initView.hidden = YES;
    UIImageView *recordBgImageView = [MyControl createImageViewWithFrame:RecordImageView.frame ImageName:@"record_bg.png"];
    
    [initView addSubview:recordBgImageView];
    
    recordProgress = [[MBRoundProgressView alloc] initWithFrame:RecordImageView.frame];
    recordProgress.annular = YES;
    recordProgress.lineWidth = 15.0f;
    recordProgress.progressTintColor = [UIColor colorWithRed:148/255.0 green:209/255.0 blue:242/255.0 alpha:1];
    [initView addSubview:recordProgress];
    
    timerLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2-25, 30, 50, 20) Font:18 Text:nil];
    timerLabel.textAlignment = NSTextAlignmentCenter;
    timerLabel.textColor = LIGHTORANGECOLOR;
    [initView addSubview:timerLabel];
    
    UILabel *bgLabel = [MyControl createLabelWithFrame:CGRectMake(recordBgImageView.frame.size.width/2-50, recordBgImageView.frame.size.height/2-25/2.0, 100, 25) Font:20 Text:@"松开 结束"];
    bgLabel.textAlignment = NSTextAlignmentCenter;
    [recordBgImageView addSubview:bgLabel];
    
    //下方视图
    [self addDownView:[NSString stringWithFormat:@"%d",count]];
}

- (void)recordButtonTouchUp:(UIButton *)sender
{
    NSLog(@"录音结束");
    
    //停止，发送
    if ((int)_recorder.currentTime >=2 ) {
        [_recorder stop];
        upScrollView.contentOffset = CGPointMake(upScrollView.frame.size.width, 0);
        
    }else{
        RecordImageView.hidden = NO;
        initView.hidden = YES;
        recordProgress.progress = 0.00;
    }
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _recording = NO;
    [_recorder stop];
    [_recorder release];
    _recorder = nil;
    
}
//录音代理方法
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"recordFinish");
    //    [_timer invalidate];
    //    _timer = nil;
    //    NSLog(@"%d",recordCount);
    //    if (recordCount >=2) {
    //        upScrollView.contentOffset = CGPointMake(upScrollView.frame.size.width, 0);
    //    }else{
    //        RecordImageView.hidden = NO;
    //        initView.hidden = YES;
    //        recordProgress.progress = 0.0;
    //    }
}
- (void)recordButtonTouchDown:(UIButton *)sender
{
    NSLog(@"录音");
    RecordImageView.hidden = YES;
    
    initView.hidden = NO;
    NSLog(@"%d",initView.hidden);
    //    initView.hidden = NO;
    
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
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    _recordedFile = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@.aac", cfuuidString]]] retain];
//    _recordedFile = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]]retain];

    NSLog(@"_recordedFile :%@",_recordedFile);
    NSError* error;
    _recorder = [[AVAudioRecorder alloc] initWithURL:_recordedFile settings:settings error:&error];
    _recorder.delegate = self;
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
    
    
    [_recorder prepareToRecord];
    _recorder.meteringEnabled = YES;
    [_recorder record];
    _hasCAFFile = YES;
    _recording = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
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
- (void)shopGiftTitle
{
    totalView = [MyControl createViewWithFrame:CGRectMake(self.view.frame.size.width/2-150,self.view.frame.size.height/2-425/2.0, 300, 425)];
    totalView.layer.cornerRadius = 10;
    totalView.layer.masksToBounds = YES;
    UIImageView *titleView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 300, 40) ImageName:@"title_bg.png"];
    [totalView addSubview:titleView];
    UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:17 Text:@"叫一叫"];
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
    [self.view addSubview:totalView];
}
-(void)colseGiftAction
{
    //    [totalView removeFromSuperview];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [_player stop];
    [_player release],_player = nil;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - 播放界面
- (void)palyAndPauseView
{
    UIView *playView = [MyControl createViewWithFrame:CGRectMake(upScrollView.frame.size.width, 0, upScrollView.frame.size.width, upScrollView.frame.size.height)];
    [upScrollView addSubview:playView];
    UILabel *shakeDescLabel = [MyControl createLabelWithFrame:CGRectMake(playView.frame.size.width/2 - 115, 10, 230, 20) Font:16 Text:@"为萌萌的TA记录每天的叫声吧~"];
    shakeDescLabel.textAlignment = NSTextAlignmentCenter;
    shakeDescLabel.textColor = GRAYBLUECOLOR;
    [playView addSubview:shakeDescLabel];
    
    UIImageView *playBGImageView = [MyControl createImageViewWithFrame:CGRectMake(playView.frame.size.width/2 - 82, 65, 160, 160) ImageName:@"record_bg.png.png"];
    [playView addSubview:playBGImageView];
    playProgress = [[MBRoundProgressView alloc] initWithFrame:playBGImageView.frame];
    playProgress.annular = YES;
    playProgress.progressTintColor = [UIColor colorWithRed:148/255.0 green:209/255.0 blue:242/255.0 alpha:1];
    playProgress.lineWidth = 15.0f;
    [playView addSubview:playProgress];
    
    playingTimerLabel = [MyControl createLabelWithFrame:CGRectMake(40, 100, 90, 20) Font:20 Text:nil];
    playAndPauseImageView = [MyControl createImageViewWithFrame:CGRectMake(65, 50, 40, 40) ImageName:@"record_play.png"];
    [playBGImageView addSubview:playAndPauseImageView];
    //播放动作
    UIButton *recordButton = [MyControl createButtonWithFrame:CGRectMake(playView.frame.size.width/2 - 82, 65, 160, 160) ImageName:nil Target:self Action:@selector(playingAction:) Title:nil];
    [recordButton addSubview:playingTimerLabel];
    [playView addSubview:recordButton];
    //重录动作
    rerecordingButton = [MyControl createButtonWithFrame:CGRectMake(35, 240, 40, 40) ImageName:@"rerecording.png" Target:self Action:@selector(RerecordAction) Title:nil];
    [playView addSubview:rerecordingButton];
    //录音上传动作
    recordUploadingButton = [MyControl createButtonWithFrame:CGRectMake(220, 240, 40, 40) ImageName:@"record_uploading.png" Target:self Action:@selector(recordUploadingAction) Title:nil];
    [playView addSubview:recordUploadingButton];
    
    uploadingImageView  = [MyControl createImageViewWithFrame:CGRectMake(50, 240, 200, 40) ImageName:@"record_loading.png"];
    [playView addSubview:uploadingImageView];
    uploadingImageView.hidden = YES;
    //停止上传重录动作
    UIButton *uploadStopButton = [MyControl createButtonWithFrame:CGRectMake(163, 7, 35, 25) ImageName:nil Target:self Action:@selector(RerecordAction) Title:@"停止"];
    uploadStopButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [uploadStopButton setTitleColor:[UIColor colorWithRed:148/255.0 green:209/255.0 blue:242/255.0 alpha:1] forState:UIControlStateNormal];
    
    
    [uploadingImageView addSubview:uploadStopButton];
    barUpload = [[MBBarProgressView alloc ]initWithFrame:CGRectMake(0, 11, 165, 20)];
    //    barUpload.progress = 0.5;
    barUpload.progressColor = [UIColor colorWithRed:148/255.0 green:209/255.0 blue:242/255.0 alpha:1];
    //    barUpload.lineColor = [UIColor whiteColor];
    [uploadingImageView addSubview:barUpload];
}
//重新录制
- (void)RerecordAction
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    upScrollView.contentOffset = CGPointMake(0, 0);
    RecordImageView.hidden = NO;
    initView.hidden = YES;
    _player = nil;
    recordProgress.progress = 0.00;
    
    uploadingImageView.hidden = YES;
    [recordUploadingButton setHidden:NO];
    [rerecordingButton setHidden:NO];
}
//录音上传
- (void)recordUploadingAction
{
    uploadingImageView.hidden = NO;
    [recordUploadingButton setHidden:YES];
    [rerecordingButton setHidden:YES];
    [self barUploadProgress];
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(barUploadProgress) userInfo:nil repeats:YES];
}
//上传进度
- (void)barUploadProgress
{
//    if ((int)barUpload.progress != 1) {
//        barUpload.progress+=0.1;
//    }else{
//        [_timer invalidate];
//        _timer = nil;
//        upScrollView.contentOffset = CGPointMake(upScrollView.frame.size.width*2, 0);
//    }
    [self uploadRecordData];
//    [self upload];
}
//播放录音
- (void)playingAction:(UIButton *)sender
{
    
    if (!_playing) {
        _playing = YES;
        recordUploadingButton.enabled = NO;
        playAndPauseImageView.image = [UIImage imageNamed:@"record_pause.png"];
        if (_hasCAFFile)
        {
            if (_player == nil)
            {
                NSError *playerError;
                _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recordedFile error:&playerError];
                _player.meteringEnabled = YES;
                if (_player == nil)
                {
                    NSLog(@"ERror creating player: %@", [playerError description]);
                }
                _player.delegate = self;
            }
            [_player play];
            _timer = [NSTimer scheduledTimerWithTimeInterval:.1
                                                      target:self
                                                    selector:@selector(timerUpdate)
                                                    userInfo:nil
                                                     repeats:YES];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"Please Record a File First"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];                   }
    }else{
        _playing = NO;
        recordUploadingButton.enabled = YES;
        [_timer invalidate];
        _timer = nil;
        [_player pause];
        [playAndPauseImageView setImage:[UIImage imageNamed:@"record_play.png"]];
        
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"%d", flag);
    playAndPauseImageView.image = [UIImage imageNamed:@"record_play.png"];
    [_timer invalidate];
    _timer = nil;
    _playing = NO;
    playProgress.progress = 0.00;
}
#pragma mark - 录音上传完成界面
- (void)createRecordLoadedEndView
{
    UILabel *shakeDescLabel = [MyControl createLabelWithFrame:CGRectMake(upScrollView.frame.size.width*2+upScrollView.frame.size.width/2-75, 20, 150, 60) Font:16 Text:@"上传成功，期待明天的美妙叫叫"];
    shakeDescLabel.textColor = GRAYBLUECOLOR;
    [upScrollView addSubview:shakeDescLabel];
    
    UIImageView *recordedEndImageView = [MyControl createImageViewWithFrame:CGRectMake(upScrollView.frame.size.width*2+upScrollView.frame.size.width/2 - 96/2, 90,96, 110) ImageName:@"nochance.png"];
    [upScrollView addSubview:recordedEndImageView];
    
    UIView *shareView = [MyControl createViewWithFrame:CGRectMake(upScrollView.frame.size.width*2+upScrollView.frame.size.width/2-195/2.0, 240, 195, 50)];
    [upScrollView addSubview:shareView];
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
    
    UILabel *shareTextLabel = [MyControl createLabelWithFrame:CGRectMake(upScrollView.frame.size.width*2+50, 220, 50, 15) Font:12 Text:@"分享到"];
    shareTextLabel.textColor = [UIColor grayColor];
    [upScrollView addSubview:shareTextLabel];
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
#pragma mark - 每天录完后出现的界面
- (void)createRecordedEndView
{
    UILabel *shakeDescLabel = [MyControl createLabelWithFrame:CGRectMake(upScrollView.frame.size.width*3+upScrollView.frame.size.width/2-75, 20, 150, 60) Font:16 Text:@"今天猫君录过了吆~期待明天的美妙叫叫"];
    
    shakeDescLabel.textAlignment = NSTextAlignmentCenter;
    shakeDescLabel.textColor = GRAYBLUECOLOR;
    [upScrollView addSubview:shakeDescLabel];
    
    UIImageView *recordedEndImageView = [MyControl createImageViewWithFrame:CGRectMake(upScrollView.frame.size.width*3+upScrollView.frame.size.width/2 - 96/2, 90,96, 110) ImageName:@"nochance.png"];
    [upScrollView addSubview:recordedEndImageView];
}

#pragma mark - Record
//更新
- (void) timerUpdate
{
    if ((int)_recorder.currentTime == 30) {
        _recording = NO;
        [_timer invalidate];
        _timer = nil;
        //停止，发送
        [_recorder stop];
        [_recorder release];
        _recorder = nil;
        upScrollView.contentOffset = CGPointMake(upScrollView.frame.size.width, 0);
        return;
    }
    if (_recording)
    {
        int m = _recorder.currentTime / 60;
        int s = ((int) _recorder.currentTime) % 60;
        NSLog(@"录音的当前时间：%f",_recorder.currentTime);
        timerLabel.text = [NSString stringWithFormat:@"%.2d:%.2d", m, s];
        recordProgress.progress = 1/30.0*_recorder.currentTime;
    }
    if (_playing)
    {
//         _player.currentTime=fabsf(_player.currentTime);
        NSLog(@"播放的当前时间：%f",_player.currentTime);
        playProgress.progress = _player.currentTime/_player.duration;
        playingTimerLabel.text =[NSString stringWithFormat:@"0:%0.2d/0:%.2d",(int)_player.currentTime%60, (int)_player.duration];
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
        [self createRecordOne];
        upScrollView.contentOffset = CGPointMake(upScrollView.frame.size.width*3, 0);
    }
    
}



@end
