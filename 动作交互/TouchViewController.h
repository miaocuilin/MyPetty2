//
//  TouchViewController.h
//  MyPetty
//
//  Created by zhangjr on 14-8-26.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TouchViewController : UIViewController<AVAudioPlayerDelegate>
{
    NSURL*                          _recordedFile;
    AVAudioPlayer*                  _player;
    UIImageView *playAndPauseImageView;
    BOOL isplaying;
}
- (void)createAlertView;
@end
