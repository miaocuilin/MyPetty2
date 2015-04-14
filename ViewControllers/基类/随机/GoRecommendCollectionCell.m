//
//  GoRecommendCollectionCell.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/27.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "GoRecommendCollectionCell.h"

@implementation GoRecommendCollectionCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    UIImageView *imageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) ImageName:@"Default.png"];
    [self addSubview:imageView];
}
@end
