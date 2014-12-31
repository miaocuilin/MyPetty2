//
//  PetMainCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetMainCell.h"

@implementation PetMainCell

- (void)awakeFromNib {
    // Initialization code
    [self makeUI];
}
-(void)makeUI
{
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 54, [UIScreen mainScreen].bounds.size.width, 1)];
    view.backgroundColor = LineGray;
    [self addSubview:view];
}
-(void)modifyUIWithIndex:(int)index Num:(NSString *)num
{
    if (index == 0) {
        self.image.image = [UIImage imageNamed:@"pet_icon_food.png"];
        self.name.text = @"口粮";
    }else if (index == 1) {
        self.image.image = [UIImage imageNamed:@"pet_icon_like.png"];
        self.name.text = @"人气";
    }else if (index == 2) {
        self.image.image = [UIImage imageNamed:@"pet_icon_gift.png"];
        self.name.text = @"礼物";
    }
    
    self.num.text = [NSString stringWithFormat:@"（%@）", num];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_image release];
    [_name release];
    [_num release];
    [super dealloc];
}
@end
