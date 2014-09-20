//
//  RecordViewController.h
//  MyPetty
//
//  Created by zhangjr on 14-9-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "lame.h"
#import "ASIFormDataRequest.h"

@interface RecordViewController : UIViewController<AVAudioPlayerDelegate,AVAudioRecorderDelegate>
@property (nonatomic,strong)NSDictionary *animalInfoDict;

@end
