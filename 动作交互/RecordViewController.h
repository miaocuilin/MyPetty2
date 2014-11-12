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
{
    UIView *totalView;
}
@property(nonatomic)BOOL isFromStar;
@property (nonatomic,strong)NSDictionary *animalInfoDict;

@property(nonatomic,copy)NSString * recordURL;

@property(nonatomic,copy)NSString * pet_aid;
@property(nonatomic,copy)NSString * pet_name;
@property(nonatomic,copy)NSString * pet_tx;

@property(nonatomic,copy)void (^recordBack)(void);
@end
