//
//  BackImageDetailViewCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/23.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "BackImageDetailViewCell.h"

@implementation BackImageDetailViewCell

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
    headImageView = [MyControl createImageViewWithFrame:CGRectMake(6, 11.5, 30, 30) ImageName:@"defaultPetHead.png"];
    headImageView.layer.cornerRadius = 15;
    headImageView.layer.masksToBounds = YES;
    [self addSubview:headImageView];
    
    name = [MyControl createLabelWithFrame:CGRectMake(45, 16, 220, 20) Font:15 Text:nil];
    name.textColor = ORANGE;
    [self addSubview:name];
    
    UIView * line = [MyControl createViewWithFrame:CGRectMake(40, self.frame.size.height-1, self.frame.size.width-40, 1)];
    line.backgroundColor = [ControllerManager colorWithHexString:@"dddddd"];
    [self addSubview:line];
}
-(void)configUI:(UserInfoModel *)model
{
    name.text = model.name;
    
//    headImageView.image = [UIImage imageNamed:@"defaultPetHead.png"];
    [headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL, model.tx]] placeholderImage:[UIImage imageNamed:@"defaultUserHead.png"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
