//
//  LoadingView.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/23.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    UIView * alphaView = [MyControl createViewWithFrame:[UIScreen mainScreen].bounds];
    alphaView.alpha = 0;
    [self addSubview:alphaView];
    
    float w = (self.frame.size.width-75)/2.0;
    float h = (self.frame.size.height-75)/2.0;
    UIImageView * loadingBg = [MyControl createImageViewWithFrame:CGRectMake(w, h, 75, 75) ImageName:@"loading_back.png"];
    [self addSubview:loadingBg];
    
    float b = (150-118)/2;
    loading_front = [MyControl createImageViewWithFrame:CGRectMake(8, b-7, 59, 59) ImageName:@"loading_front.png"];
    [loadingBg addSubview:loading_front];
    
//    [self startAnimation];
}
-(void)startAnimation
{
    self.isAnimation = YES;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2*M_PI);
    animation.duration = 1.f;
    animation.repeatCount = INT_MAX;
    [loading_front.layer addAnimation:animation forKey:@"keyFrameAnimation"];
}
-(void)stopAnimation
{
    self.isAnimation = NO;
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
