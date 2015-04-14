//
//  DiscoverPictureViewController.h
//  MyPetty
//
//  Created by miaocuilin on 15/4/2.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverPictureViewController : UIViewController

@property(nonatomic)BOOL isFromAttention;
//探索tab已点中时再点回到顶部
-(void)refreshTop;
@end
