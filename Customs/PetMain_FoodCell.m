//
//  PetMain_FoodCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetMain_FoodCell.h"

@implementation PetMain_FoodCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    float width = [UIScreen mainScreen].bounds.size.width;
    
    headImage = [MyControl createImageViewWithFrame:CGRectMake(16, 10, 86, 86) ImageName:@"20-1.png"];
    [self addSubview:headImage];
    
    //距照片20，距右边15
    float originX = headImage.frame.origin.x+headImage.frame.size.width+20;
    foodNum = [MyControl createLabelWithFrame:CGRectMake(originX, 10, [UIScreen mainScreen].bounds.size.width-originX-15, 17) Font:16 Text:@"已挣得口粮：14098 份"];
    foodNum.textColor = ORANGE;
    [self addSubview:foodNum];
    
    desLabel = [MyControl createLabelWithFrame:CGRectMake(originX, headImage.frame.origin.y+15, [UIScreen mainScreen].bounds.size.width-originX-15, headImage.frame.size.height-15) Font:12 Text:@"生生灯火，明暗无辄，看着迂回的伤痕，却不能为你做什么，我恨我，躲在永夜背后找微光的出口"];
    desLabel.textColor = [UIColor blackColor];
    [self addSubview:desLabel];
    
    timeLabel = [MyControl createLabelWithFrame:CGRectMake(width-15-100, 10+headImage.frame.size.height-10, 100, 15) Font:11 Text:@"1小时前"];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [self addSubview:timeLabel];
    
    UIView * line = [MyControl createViewWithFrame:CGRectMake(0, 104, width, 0.8)];
    line.backgroundColor = [ControllerManager colorWithHexString:@"b9b9b9"];
    [self addSubview:line];
    
//    [self createReward];
}
-(void)createReward
{
    float width = [UIScreen mainScreen].bounds.size.width;
    //587  98
    rewardBg = [MyControl createImageViewWithFrame:CGRectMake((width-498/2)/2.0, 106, 498/2, 103/2) ImageName:@"food_rewardBg.png"];
    [self addSubview:rewardBg];
    
    //
    UIImageView * food = [MyControl createImageViewWithFrame:CGRectMake(30, (rewardBg.frame.size.height-25)/2.0, 25, 25) ImageName:@"exchange_whiteFood.png"];
    [rewardBg addSubview:food];
    
    rewardNum = [MyControl createLabelWithFrame:CGRectMake(75, 0, 47, rewardBg.frame.size.height) Font:17 Text:@"1"];
    rewardNum.font = [UIFont boldSystemFontOfSize:17];
    rewardNum.textAlignment = NSTextAlignmentCenter;
    [rewardBg addSubview:rewardNum];
    
    
    UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(125, (rewardBg.frame.size.height-31/2)/2.0, 18/2, 31/2) ImageName:@"rightArrow.png"];
    [rewardBg addSubview:arrow];
    
    
    
    //10 100 1000
    selectView = [MyControl createViewWithFrame:CGRectMake(rewardBg.frame.origin.x+45, rewardBg.frame.origin.y-105, 113, 105)];
    selectView.hidden = YES;
    [self addSubview:selectView];
    
    UIImageView * selectBg = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 113, 100) ImageName:@""];
    selectBg.image = [[UIImage imageNamed:@"food_selectBg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [selectView addSubview:selectBg];
    
    UIImageView * selectTri = [MyControl createImageViewWithFrame:CGRectMake((113-19/2.0)/2.0, 100, 19/2.0, 5) ImageName:@"food_selectBg_tri.png"];
    [selectView addSubview:selectTri];
    
    NSArray * numArray = @[@"1000", @"100", @"10", @"1"];
    for (int i=0; i<numArray.count; i++) {
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(0, 25*i, selectBg.frame.size.width, 25) Font:17 Text:[NSString stringWithFormat:@"   %@", numArray[i]]];
        label.tag = 200+i;
        [selectBg addSubview:label];
        
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(0, 25*i, selectBg.frame.size.width, 25) ImageName:@"" Target:self Action:@selector(numBtnClick:) Title:nil];
        [selectBg addSubview:button];
        button.tag = 100+i;
        if (i == 3) {
            label.backgroundColor = ORANGE;
        }
    }
    
    //
    UIButton * selectBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, rewardBg.frame.size.width/2.0, rewardBg.frame.size.height) ImageName:@"" Target:self Action:@selector(selectBtnClick:) Title:nil];
    selectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [rewardBg addSubview:selectBtn];
    
    //    UIButton * rewardBtn = [MyControl createButtonWithFrame:CGRectMake(rewardBg.frame.size.width/2.0, 0, rewardBg.frame.size.width/2.0, rewardBg.frame.size.height) ImageName:@"" Target:self Action:@selector(rewardBtnClick:) Title:@""];
    //    rewardBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    //    [rewardBg addSubview:rewardBtn];
    
    heartBtn = [MyControl createButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-90, rewardBg.frame.origin.y-2, 126/2, 115/2) ImageName:@"food_heart.png" Target:self Action:@selector(rewardBtnClick:) Title:nil];
    [heartBtn addTarget:self action:@selector(heartTouchDown) forControlEvents:UIControlEventTouchDown];
    [heartBtn addTarget:self action:@selector(heartUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:heartBtn];
//    timer = [NSTimer scheduledTimerWithTimeInterval:1.9 target:self selector:@selector(heartAnimation) userInfo:nil repeats:YES];
}
-(void)heartTouchDown
{
    [timer invalidate];
    timer = nil;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = heartBtn.frame;
        rect.origin.x -= 7;
        rect.origin.y -= 7;
        rect.size.width += 14;
        rect.size.height += 14;
        heartBtn.frame = rect;
    }];
}
-(void)heartUpOutside
{
    [UIView animateWithDuration:0.2 animations:^{
        heartBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-90, rewardBg.frame.origin.y-2, 126/2, 115/2);
    } completion:^(BOOL finished) {
        timer = [NSTimer scheduledTimerWithTimeInterval:2.4 target:self selector:@selector(heartAnimation) userInfo:nil repeats:YES];
    }];
}
-(void)heartAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = heartBtn.frame;
        rect.origin.x -= 7;
        rect.origin.y -= 7;
        rect.size.width += 14;
        rect.size.height += 14;
        heartBtn.frame = rect;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            heartBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-90, rewardBg.frame.origin.y-2, 126/2, 115/2);
        }];
    }];
}

#pragma mark -
-(void)numBtnClick:(UIButton *)btn
{
    [UIView animateWithDuration:0.2 animations:^{
        selectView.alpha = 0;
    } completion:^(BOOL finished) {
        selectView.hidden = YES;
    }];
    NSLog(@"%d", btn.tag);
    for (int i=0; i<4; i++) {
        UILabel * label = (UILabel *)[self viewWithTag:200+i];
        label.backgroundColor = [UIColor clearColor];
    }
    UILabel * label = (UILabel *)[self viewWithTag:100+btn.tag];
    label.backgroundColor = ORANGE;
    
    NSArray * numArray = @[@"1000", @"100", @"10", @"1"];
    rewardNum.text = numArray[btn.tag-100];
}
-(void)selectBtnClick:(UIButton *)btn
{
    if (selectView.hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            selectView.hidden = NO;
            selectView.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            selectView.alpha = 0;
        } completion:^(BOOL finished) {
            selectView.hidden = YES;
        }];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
