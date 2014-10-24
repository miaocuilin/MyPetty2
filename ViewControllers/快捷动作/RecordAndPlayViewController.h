//
//  RecordAndPlayViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/10/24.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordAndPlayViewController : UIViewController <AVAudioSessionDelegate>
{
    BOOL recording;
    BOOL playing;
}
@end
