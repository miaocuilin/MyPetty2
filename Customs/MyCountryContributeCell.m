//
//  MyCountryContributeCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-26.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MyCountryContributeCell.h"

@implementation MyCountryContributeCell

- (void)awakeFromNib
{
    // Initialization code
    [self createUI];
}
-(void)createUI
{

    self.headBtn.layer.cornerRadius = self.headBtn.frame.size.height/2;
    self.headBtn.layer.masksToBounds = YES;
    
}
-(void)modifyWithBOOL:(BOOL)isThis lineNum:(int)num
{
    self.circleBg.hidden = YES;
    
    if (isThis) {
        self.circleBg.hidden = NO;
    }
    //
    [self.headBtn setBackgroundImage:[UIImage imageNamed:@"cat2.jpg"] forState:UIControlStateNormal];
    self.headBtn.tag = 10000+num;
    //
    NSString * str = @"祭司 — ";
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(60, 20) lineBreakMode:1];
    self.positionLabel.text = str;
    CGRect rect = self.positionLabel.frame;
    rect.size.width = size.width;
    self.positionLabel.frame = rect;
    //
    CGRect rect2 = self.sex.frame;
    rect2.origin.x = rect.origin.x+size.width;
    self.sex.frame = rect2;
    //
    CGRect rect3 = self.name.frame;
    rect3.origin.x = rect2.origin.x+rect2.size.width;
    self.name.frame = rect3;
    self.name.text = @"Anna";
    self.name.textColor = BGCOLOR;
    //
    self.location.text = @"北京市 | 朝阳区";
    self.location.textColor = [UIColor lightGrayColor];
    //
    self.contribution.text = @"60000";
    self.contribution.textColor = BGCOLOR;
}
- (IBAction)headBtnClick:(id)sender {
    NSLog(@"点击头像--%d", self.headBtn.tag-10000);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headBtn release];
    [_positionLabel release];
    [_location release];
    [_contribution release];
    [_circleBg release];
    [_sex release];
    [_name release];
    [super dealloc];
}
@end
