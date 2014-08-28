//
//  UIWindow+MotionEvent.m
//  MyPetty
//
//  Created by zhangjr on 14-8-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "UIWindow+MotionEvent.h"
@implementation UIWindow (MotionEvent)

- (BOOL)canBecomeFirstResponder
{
//    [[NSNotificationCenter defaultCenter]postNotificationName:UIEventSubtypeMotionShakeNotification object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(demo) name:UIEventSubtypeMotionShakeNotification object:nil];
    return NO;
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
        NSLog(@"window shake");

    }
}
@end
