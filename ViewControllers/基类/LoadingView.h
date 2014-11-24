//
//  LoadingView.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/23.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
{
    UIImageView * loading_front;
}

@property(nonatomic)BOOL isAnimation;

-(void)makeUI;
-(void)startAnimation;
-(void)stopAnimation;
@end
