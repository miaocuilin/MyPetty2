//
//  UIWindow+MotionEvent.h
//  MyPetty
//
//  Created by zhangjr on 14-8-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UIEventSubtypeMotionShakeNotification @"UIEventSubtypeMotionShakeNotification"

@interface UIWindow (MotionEvent)
//- (BOOL)canBecomeFirstResponder;
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event;
@end
