//
//  ShakeViewController.h
//  MyPetty
//
//  Created by Aidi on 14-7-25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ShakeViewController : UIViewController
{
    MBProgressHUD *alertView;
    SystemSoundID soundID;
    SystemSoundID soundID2;
    MBProgressHUD *unfortunately;
    MBProgressHUD *goldHUD;
    MBProgressHUD *goodsHUD;
    MBProgressHUD *noChanceHUD;
}
@property (nonatomic,strong)NSDictionary *animalInfoDict;
@property (nonatomic,strong)NSString *titleString;
- (void)createAlertView;
@end
