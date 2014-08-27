//
//  RecordViewController.h
//  MyPetty
//
//  Created by Aidi on 14-7-25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@interface RecordViewController : UIViewController <AVAudioPlayerDelegate>
{
    UIButton * recordButton;
    UILabel * alertLabel;
    UILabel * timeLabel;
    UIButton * play;
    UIProgressView * _progress;
    
    AVAudioRecorder * _recorder;
    AVAudioPlayer * _player;
    
//    CGFloat _sampleRate;
//    AVAudioQuality _quality;
    NSURL * _recordedFile;
    NSTimer * _timer;
    BOOL _hasCAFFile;
    BOOL _playing;
}
@end
