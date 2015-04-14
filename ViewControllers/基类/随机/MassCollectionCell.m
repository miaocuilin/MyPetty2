//
//  MassCollectionCell.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/26.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "MassCollectionCell.h"

@implementation MassCollectionCell

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
    CGFloat spe = 0.0;
    UILabel *label = [MyControl createLabelWithFrame:CGRectMake(spe, spe, self.frame.size.width-spe*2, self.frame.size.height-spe*2) Font:15 Text:nil];
    label.backgroundColor = [UIColor grayColor];
    [self addSubview:label];
    
    CGFloat w = self.frame.size.width;
    
    //
    UIView *bgView = [MyControl createViewWithFrame:CGRectMake(0, w-25, w, 25)];
    bgView.userInteractionEnabled = NO;
//    bgView.backgroundColor = [UIColor redColor];
    [self addSubview:bgView];
    
    //半透明底图
    UIView *alphaView = [MyControl createViewWithFrame:CGRectMake(w-45, 0, 43, 20)];
    alphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    alphaView.layer.cornerRadius = 5;
    alphaView.layer.masksToBounds = YES;
    [bgView addSubview:alphaView];
    
    UIImageView *heart = [MyControl createImageViewWithFrame:CGRectMake(alphaView.frame.origin.x+2, 2, 16, 16) ImageName:@"icon_heart.png"];
    [bgView addSubview:heart];
    
    UILabel *numLabel = [MyControl createLabelWithFrame:CGRectMake(heart.frame.origin.x+20, 0, alphaView.frame.size.width+alphaView.frame.origin.x-heart.frame.origin.x-20-2, 20) Font:13 Text:nil];
    numLabel.text = [NSString stringWithFormat:@"%d", arc4random()%10000];
    numLabel.textColor = [UIColor blackColor];
//    numLabel.minimumScaleFactor = 0.1;
    numLabel.numberOfLines = 1;
//    numLabel.adjustsFontSizeToFitWidth = NO;
    numLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    numLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:numLabel];
}
@end
