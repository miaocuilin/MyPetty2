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
    
    BOOL isLoadImage;
    
    UIImageView * tempImageView;
    
    //加载失败后重新加载的类型
    //1.getUser 2.login  3.getPreSID  4.loadPetInfo
    int reloadType;
    
}
@property(nonatomic,copy)NSString * animalNum;
@property(nonatomic,copy)NSString * foodNum;

@property(nonatomic,retain)UIImage * launchImage;
@property(nonatomic,retain)UIImageView * splashView;
@property(nonatomic,copy)NSString * launchImageName;
@end
