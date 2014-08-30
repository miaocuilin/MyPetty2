//
//  DefaultPetCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "DefaultPetCell.h"

@implementation DefaultPetCell

- (void)awakeFromNib
{
    // Initialization code
    [self modifyUI];
}
-(void)modifyUI
{
    //
    self.headImage.layer.cornerRadius = self.headImage.frame.size.width/2.0;
    self.headImage.layer.masksToBounds = YES;
    //
    self.nameLabel.textColor = BGCOLOR;
    //
    self.cateAndAge.textColor = [UIColor lightGrayColor];
}

-(void)configUIWithSex:(int)sex Name:(NSString *)name Cate:(NSString *)cate Age:(NSString *)age Default:(BOOL)isDefault row:(int)row
{
    rowNum = row;
    
    self.crownImage.hidden = YES;
    
    self.headImage.image = [UIImage imageNamed:@"cat2.jpg"];
    if (sex == 2) {
        self.sexImage.image = [UIImage imageNamed:@"woman.png"];
    }else{
        self.sexImage.image = [UIImage imageNamed:@"man.png"];
    }
    self.nameLabel.text = name;
    self.cateAndAge.text = [NSString stringWithFormat:@"%@ | %@岁", cate, age];
    if (isDefault) {
        self.crownImage.hidden = NO;
        [self.defaultBtn setBackgroundImage:[UIImage imageNamed:@"defaultPet.png"] forState:UIControlStateNormal];
    }else{
        [self.defaultBtn setBackgroundImage:[UIImage imageNamed:@"setToDefaultPet.png"] forState:UIControlStateNormal];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)defaultBtnClick:(UIButton *)sender {
    self.defaultBtnClick(rowNum);
}

- (void)dealloc {
    [_headImage release];
    [_crownImage release];
    [_sexImage release];
    [_nameLabel release];
    [_cateAndAge release];
    [_defaultBtn release];
    [super dealloc];
}
@end
