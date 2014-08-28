//
//  RecordViewController.m
//  MyPetty
//
//  Created by Aidi on 14-7-25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    AVAudioSession * session = [AVAudioSession sharedInstance];
    NSError * sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (session == nil) {
        NSLog(@"Error creating session: %@", [sessionError description]);
    }else{
        [session setActive:YES error:nil];
    }
    
    [self createUI];
    
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    //record
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt: 44100],                  AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatMPEG4AAC],                   AVFormatIDKey,
                              [NSNumber numberWithInt: 2],                              AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityLow],                       AVEncoderAudioQualityKey,
                              nil];
    _recordedFile = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@.aac", cfuuidString]]] retain];
    NSLog(@"%@", _recordedFile);
    
    NSError * error;
    _recorder = [[AVAudioRecorder alloc] initWithURL:_recordedFile settings:settings error:&error];
    
    NSLog(@"error:%@", [error description]);
    if (error) {
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
-(void)createUI
{
    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height-40, 320, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.view addSubview:bgView];
    
    recordButton = [MyControl createButtonWithFrame:CGRectMake(40, 5, 200, 30) ImageName:@"" Target:self Action:nil Title:@"按住 说话"];
    [recordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [recordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    recordButton.layer.borderWidth = 0.5;
    recordButton.layer.borderColor = [[UIColor blackColor] CGColor];
    [recordButton addTarget:self action:@selector(recordButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [recordButton addTarget:self action:@selector(recordButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(recordButtonTouchOut:) forControlEvents:UIControlEventTouchUpOutside];
    [recordButton addTarget:self action:@selector(recordButtonTouchDragOut:) forControlEvents:UIControlEventTouchDragExit];
    [recordButton addTarget:self action:@selector(recordButtonTouchDragIn:) forControlEvents:UIControlEventTouchDragEnter];
//    [recordButton setTitle:@"松开 发送" forState:UIControlStateSelected];
//    [recordButton setTitle:@"松开 发送" forState:UIControlStateHighlighted];
    [bgView addSubview:recordButton];
    
    play = [MyControl createButtonWithFrame:CGRectMake(260, 5, 50, 30) ImageName:@"" Target:self Action:@selector(playClick:) Title:@"播放"];
    play.layer.borderColor = [[UIColor blackColor] CGColor];
    [play setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    play.layer.borderWidth = 0.5;
    [bgView addSubview:play];
    
    alertLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 100, 100) Font:15 Text:nil];
    alertLabel.center = self.view.center;
    alertLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.hidden = YES;
    alertLabel.layer.cornerRadius = 5;
    alertLabel.layer.masksToBounds = YES;
    [self.view addSubview:alertLabel];
    
    timeLabel = [MyControl createLabelWithFrame:CGRectMake(110, self.view.frame.size.height-80, 100, 30) Font:15 Text:@"00:00 00"];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timeLabel];
    
    _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(220, self.view.frame.size.height-60, 90, 10)];
    [self.view addSubview:_progress];
}
-(void)playClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        if (_hasCAFFile) {
            if (_player == nil) {
                NSError * playerError;
                _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recordedFile error:&playerError];
                _player.meteringEnabled = YES;
                if (_player == nil) {
                    NSLog(@"Error creating player:%@", [playerError description]);
                }
                _player.delegate = self;
            }
            
            [_player play];
            [button setTitle:@"停止" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor lightGrayColor];
            _playing = YES;
            _timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
            
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"Please Record a File First"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }else{
        [_player stop];
        _playing = NO;
        [button setTitle:@"播放" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    
}


-(void)recordButtonTouchDown:(UIButton *)button
{
    
    [_recorder prepareToRecord];
    _recorder.meteringEnabled = YES;
    [_recorder record];
    _hasCAFFile = YES;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:.01f target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    
    
    [recordButton setTitle:@"松开 发送" forState:UIControlStateNormal];

    alertLabel.text = @"松开发送";
    alertLabel.hidden = NO;
    NSLog(@"按下，松开发送");
    recordButton.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];

}
-(void)recordButtonTouchUp:(UIButton *)button
{
    [_timer invalidate];
    _timer = nil;
    
    //停止，发送
    [_recorder stop];
    [_recorder release];
    _recorder = nil;
    
    
    alertLabel.hidden = YES;
     NSLog(@"发送");
    [recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    recordButton.backgroundColor = [UIColor whiteColor];
}
-(void)recordButtonTouchOut:(UIButton *)button
{
    timeLabel.text = @"00:00 00";
    [_timer invalidate];
    _timer = nil;
    
    alertLabel.hidden = YES;
     NSLog(@"取消发送");
    [recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    recordButton.backgroundColor = [UIColor whiteColor];
}
-(void)recordButtonTouchDragOut:(UIButton *)button
{
    alertLabel.text = @"松开取消发送";
     NSLog(@"移出，准备取消发送");
    [recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    recordButton.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
}
-(void)recordButtonTouchDragIn:(UIButton *)button
{
    alertLabel.text = @"松开发送";
     NSLog(@"移入，松开发送");
    [recordButton setTitle:@"松开 发送" forState:UIControlStateNormal];
    recordButton.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
}

-(void)timerUpdate
{
    if (_playing) {
        NSLog(@"%f--%f", _player.currentTime, _player.duration);
        _progress.progress = _player.currentTime/_player.duration;
        return;
    }
    NSLog(@"currentTime:%f", _recorder.currentTime);
    int m = _recorder.currentTime / 60;
    int s = ((int) _recorder.currentTime) % 60;
    int ss = (_recorder.currentTime - ((int) _recorder.currentTime)) * 100;
    timeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d %.2d", m, s, ss];
    
//    if (s >= 10) {
//        [self recordButtonTouchUp:recordButton];
//    }
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"%d", flag);
    [_timer invalidate];
    _timer = nil;
    _playing = NO;
    [play setTitle:@"播放" forState:UIControlStateNormal];
    play.backgroundColor = [UIColor whiteColor];
}


@end
