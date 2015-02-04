//
//  RockViewController.h
//  MyPetty
//
//  Created by zhangjr on 14-9-19.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface RockViewController : UIViewController
{
    SystemSoundID soundID;
    SystemSoundID soundID2;
    
    UIView * totalView;
    BOOL isLoaded;
    UIImageView * headImageView;
}
@property (nonatomic,strong)NSDictionary *animalInfoDict;
@property (nonatomic,strong)NSString *titleString;
@property (nonatomic)BOOL isTrouble;

@property(nonatomic,copy)NSString * pet_aid;
@property(nonatomic,copy)NSString * pet_name;
@property(nonatomic,copy)NSString * pet_tx;

@property(nonatomic,copy)NSString * giftName;

@property(nonatomic,copy)void (^unShakeNum)(int);

@property(nonatomic,copy)void (^updateContri)(NSString *);
@property(nonatomic)BOOL isFromStar;
@end
