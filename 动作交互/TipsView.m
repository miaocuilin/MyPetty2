//
//  TipsView.m
//  MyPetty
//
//  Created by zhangjr on 14-9-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "TipsView.h"

@implementation TipsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)createUI
{
    UIImageView *catImageView = [MyControl createImageViewWithFrame:CGRectMake(-70, self.bounds.size.height/2-28, 70, 56) ImageName:@"tipscat.png"];
    [self addSubview:catImageView];
    UIImageView *dogImageView = [MyControl createImageViewWithFrame:CGRectMake(self.bounds.size.width/2-64, self.bounds.size.height/2-28, 62, 56) ImageName:@"tipsdog.png"];
    [self addSubview:dogImageView];
    [self animationImageView:dogImageView];
    [self animationImageView:catImageView];
    
}
- (void)animationImageView:(UIImageView *)imageView
{
    [UIView beginAnimations:@"Slide Around" context:nil];
    
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(viewAnimationDone:)];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    CGPoint center = [imageView center];
    center.x += self.bounds.size.width/2-36;
    [imageView setCenter:center];
    [UIView commitAnimations];
}
- (void)viewAnimationDone:(NSString *)name
{
    NSLog(@"111");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
