//
//  UserBagCollectionViewCell.m
//  MyPetty
//
//  Created by zhangjr on 14-9-5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "UserBagCollectionViewCell.h"

@implementation UserBagCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        [self makeUI];
    }
    return self;
}

- (void)makeUI
{
    self.presentImageView = [MyControl createImageViewWithFrame:CGRectMake(self.frame.size.width/2-25, self.frame.size.height/2-25, 45, 45) ImageName:@"bother5_2.png"];
    [self addSubview:self.presentImageView];
    self.titleLabel = [MyControl createLabelWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 20) Font:11 Text:@"气球气球"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.titleLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    self.titleLabel.textColor = [UIColor grayColor];
    [self addSubview:self.titleLabel];
    UIImageView *giftIcon = [MyControl createImageViewWithFrame:CGRectMake(15, self.frame.size.height/2+27, 15, 15) ImageName:@"giftIcon.png"];
    [self addSubview:giftIcon];
    
    self.presentNumberLabel = [MyControl createLabelWithFrame:CGRectMake(38, self.frame.size.height/2+25, self.frame.size.width-40, 20) Font:15 Text:@"X 100"];
    self.presentNumberLabel.textColor = BGCOLOR;
    [self addSubview:self.presentNumberLabel];
    UIImageView *leftCornerBGImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 30, 30) ImageName:@"product_bg2.png"];
    [self addSubview:leftCornerBGImageView];
    
    UILabel *popLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 15, 12) Font:7 Text:@"人气"];
    popLabel.font = [UIFont boldSystemFontOfSize:7];
    popLabel.textAlignment = NSTextAlignmentCenter;
    popLabel.transform =CGAffineTransformMakeRotation(-45.0*M_PI/180.0);

    [leftCornerBGImageView addSubview:popLabel];
    self.popNumberLabel = [MyControl createLabelWithFrame:CGRectMake(-3, 5, 30, 15) Font:8 Text:@"+100"];
    self.popNumberLabel.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
    self.popNumberLabel.textAlignment =NSTextAlignmentCenter;
    [leftCornerBGImageView addSubview:self.popNumberLabel];
    
}
-(void)configUIWithItemId:(NSString *)itemId Num:(NSString *)num
{
    self.presentNumberLabel.text = [NSString stringWithFormat:@"X %@", num];
    //
    NSDictionary * dict = [ControllerManager returnGiftDictWithItemId:itemId];
    self.titleLabel.text = [dict objectForKey:@"name"];
    if ([[dict objectForKey:@"add_rq"] rangeOfString:@"-"].location == NSNotFound) {
        self.popNumberLabel.text = [NSString stringWithFormat:@"+%@", [dict objectForKey:@"add_rq"]];
    }else{
        self.popNumberLabel.text = [dict objectForKey:@"add_rq"];
    }
    self.presentImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", itemId]];
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
