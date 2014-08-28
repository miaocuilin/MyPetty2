//
//  ShoutViewController.h
//  MyPetty
//
//  Created by zhangjr on 14-8-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface ShoutViewController : UIViewController<AVAudioPlayerDelegate>
{
    UILabel*                        _duration;
    UILabel*                        _cafFileSize;
    UIButton*                       _recordBtn;
    UIButton*                       _playBtn;

    UIProgressView*                 _progress;
    
    AVAudioRecorder*                _recorder;
    AVAudioPlayer*                  _player;
    NSURL*                          _recordedFile;
    NSTimer*                        _timer;

    BOOL                            _hasCAFFile;
    BOOL                            _recording;
    BOOL                            _playing;
    
    MBProgressHUD *recordHUD;
}
@end
