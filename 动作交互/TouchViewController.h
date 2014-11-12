//
//  TouchViewController.h
//  MyPetty
//
//  Created by zhangjr on 14-8-26.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class AudioStreamer;

@interface TouchViewController : UIViewController<AVAudioPlayerDelegate>
{
    NSURL*                          _recordedFile;
    AVAudioPlayer*                  _player;
    UIImageView *playAndPauseImageView;
    BOOL isplaying;
    AudioStreamer *streamer;
//    NSString * recordURL;
    
    UIView * totalView;
    
    BOOL notHaveRecord;
    UIButton *playAndPauseButton;
}
@property (nonatomic,strong)NSDictionary *animalInfoDict;
@property (nonatomic,strong)NSString *recordURL;
@property (nonatomic,getter = getRecord)BOOL haveRecord;

@property(nonatomic,copy)NSString * pet_aid;
@property(nonatomic,copy)NSString * pet_name;
@property(nonatomic,copy)NSString * pet_tx;

@property(nonatomic,copy)NSString * voiceName;

@property(nonatomic)BOOL isFromStar;
@property(nonatomic,copy)void (^touchBack)(void);
- (void)createAlertView;
@end
