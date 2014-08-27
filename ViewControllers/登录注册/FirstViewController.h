//
//  FirstViewController.h
//  MyPetty
//
//  Created by Aidi on 14-5-30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController
{
    BOOL hadImage;
    UIImageView * bgImageView;
    
    //是否请求完loginApi
    BOOL isLogined;
    //是否下载完图片并播放
    BOOL isAnimation;
}
@property(nonatomic,retain)UIImage * launchImage;
@property(nonatomic,retain)UIImageView * splashView;
@property(nonatomic,copy)NSString * launchImageName;
@end
