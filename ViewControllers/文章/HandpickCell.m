//
//  HandpickCell.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/24.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "HandpickCell.h"

@implementation HandpickCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
