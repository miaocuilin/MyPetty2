//
//  CountryInfoCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-12.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "CountryInfoCell.h"

@implementation CountryInfoCell

- (void)awakeFromNib
{
    // Initialization code
    [self createUI];
}
-(void)createUI
{    
    self.headImageView.layer.cornerRadius = 56/2;
    self.headImageView.layer.masksToBounds = YES;
    
    self.expBgImageView.image = [[UIImage imageNamed:@"RQBg.png"] stretchableImageWithLeftCapWidth:37/2 topCapHeight:26/2];
    self.expBgImageView.layer.cornerRadius = 7;
    self.expBgImageView.layer.masksToBounds = YES;
    
    
    int length = arc4random()%160;
    int exp = length/160.0*100;
    
    expImageView = [MyControl createImageViewWithFrame:CGRectMake(1, 1, length, 11) ImageName:@""];
    expImageView.image = [[UIImage imageNamed:@"RQImage.png"] stretchableImageWithLeftCapWidth:26/2 topCapHeight:30/2];
//    expImageView.layer.cornerRadius = 7;
//    expImageView.layer.masksToBounds = YES;
    [self.expBgImageView addSubview:expImageView];
    
    [self.contentView bringSubviewToFront:self.expLabel];
    self.expLabel.text = [NSString stringWithFormat:@"%d/100", exp];
    
    NSArray * array = @[@"今日人气", @"最新动态", @"王国成员"];
    for(int i=0;i<3;i++){
        UILabel * numLabel = [MyControl createLabelWithFrame:CGRectMake(90+i*60, 60, 50, 15) Font:12 Text:@"100"];
        numLabel.textColor = BGCOLOR;
        numLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:numLabel];
        
        UILabel * nameLabel = [MyControl createLabelWithFrame:CGRectMake(90+i*60, 75, 50, 15) Font:11 Text:array[i]];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:nameLabel];
    }
}
-(void)modify:(int)row
{
    if (row == 0) {
        self.switchLabel1.text = @"默 认";
        self.switchLabel2.text = @"宠 物";
    }else{
        self.switchLabel1.text = @"设 为";
        self.switchLabel2.text = @"默 认";
    }
    
}
//手势操作
- (IBAction)show:(id)sender {

    [UIView animateWithDuration:0.2 animations:^{
        CGRect cellFrame = self.frame;
        cellFrame.origin.x = -200;
        cellFrame.size.width = 320+200;
        [self setFrame:cellFrame];
//        cellFrame = self.frame;
        
//        CGRect frame = self.buttonBgView.frame;
//        frame.size.width = 200;
//        self.buttonBgView.frame = frame;
    }];
}
- (IBAction)hide:(id)sender {

    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect cellFrame = self.frame;
        cellFrame.origin.x = 0;
        cellFrame.size.width = 320;
        [self setFrame:cellFrame];
//        cellFrame = self.frame;
        
//        CGRect frame = self.buttonBgView.frame;
//        frame.size.width = 0;
//        self.buttonBgView.frame = frame;
    }];
}

//button
- (IBAction)quitBtnClick:(id)sender {
    NSLog(@"quit");
    if ([self.delegate respondsToSelector:@selector(swipeTableViewCell:didClickButtonWithIndex:)]) {
        [self.delegate swipeTableViewCell:self didClickButtonWithIndex:1];
    }
}
- (IBAction)switchBtnClick:(id)sender {
    NSLog(@"switch");
    if ([self.delegate respondsToSelector:@selector(swipeTableViewCell:didClickButtonWithIndex:)]) {
        [self.delegate swipeTableViewCell:self didClickButtonWithIndex:2];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headImageView release];
    [_nameLabel release];
    [_expBgImageView release];
    [_expLabel release];
    [_buttonBgView release];
    [_qiutBtn release];
    [_switchBtn release];
    [_switchLabel1 release];
    [_switchLabel2 release];
    [super dealloc];
}
@end
