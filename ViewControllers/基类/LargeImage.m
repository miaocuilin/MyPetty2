//
//  LargeImage.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "LargeImage.h"

@implementation LargeImage
-(void)dealloc
{
    [super dealloc];
    [sv release];
    [tap release];
}
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
    self.alpha = 0;
    
    self.backgroundColor = [UIColor blackColor];
    
    sv = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    sv.showsVerticalScrollIndicator = NO;
    [self addSubview:sv];
    
    imageView = [MyControl createImageViewWithFrame:CGRectZero ImageName:@""];
    [self addSubview:imageView];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}
-(void)tap:(UIGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)modifyUIWithImage:(UIImage *)image
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
    imageView.image = image;
    
    float Width = [UIScreen mainScreen].bounds.size.width;
    float Height = Width*image.size.height/image.size.width;
    
    imageView.frame = CGRectMake(0, 0, Width, Height);
    sv.contentSize = CGSizeMake(Width, Height);
    if (Height<=[UIScreen mainScreen].bounds.size.height) {
        imageView.center = self.center;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
