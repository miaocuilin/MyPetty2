//
//  PetSearchCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetSearchCell.h"

@implementation PetSearchCell

- (void)awakeFromNib {
    // Initialization code
    [self makeUI];
}
-(void)makeUI
{
    self.nameLabel.textColor = BGCOLOR;
//    self.cateAndAgeLabel.textColor = [UIColor blackColor];
    
    self.headImage.layer.cornerRadius = 25;
    self.headImage.layer.masksToBounds = YES;
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(self.cateAndAgeLabel.frame.origin.x, 69, self.frame.size.width-self.cateAndAgeLabel.frame.origin.x-15, 1)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
}
-(void)configUI:(SearchResultModel *)model
{
    if ([model.gender intValue] == 1) {
        self.sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        self.sex.image = [UIImage imageNamed:@"woman.png"];
    }
    
    self.nameLabel.text = model.name;
    self.cateAndAgeLabel.text = [NSString stringWithFormat:@"%@ | %@", [ControllerManager returnCateNameWithType:model.type], [MyControl returnAgeStringWithCountOfMonth:model.age]];
    
    self.headImage.image = [UIImage imageNamed:@"defaultPetHead.png"];
    
    if (!([model.tx isKindOfClass:[NSNull class]] || [model.tx length]==0)) {
        
        [MyControl setImageForImageView:self.headImage Tx:model.tx isPet:YES isRound:YES];
    }
}
-(void)configUI2:(UserInfoModel *)model
{
    if ([model.gender intValue] == 1) {
        self.sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        self.sex.image = [UIImage imageNamed:@"woman.png"];
    }
    
    self.cateAndAgeLabel.text = [ControllerManager returnProvinceAndCityWithCityNum:model.city];
    self.nameLabel.text = model.name;
    self.headImage.image = [UIImage imageNamed:@"defaultUserHead.png"];
    if (!([model.tx isKindOfClass:[NSNull class]] || [model.tx length]==0)) {
        [MyControl setImageForImageView:self.headImage Tx:model.tx isPet:NO isRound:YES];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headImage release];
    [_sex release];
    [_nameLabel release];
    [_cateAndAgeLabel release];
    [super dealloc];
}
@end
