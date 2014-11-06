//
//  MyStarCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/6.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MyStarCell.h"

@implementation MyStarCell

- (void)awakeFromNib {
    // Initialization code
}
//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//        [self makeUI];
//    }
//    return self;
//}
-(void)makeUIWithWidth:(float)width Height:(float)height
{
//    NSLog(@"%f--%f--%f--%f", width, height, self.contentView.frame.size.width, self.contentView.frame.size.height);
    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(10, 0, width-20, height)];
//    bgView.backgroundColor = [UIColor purpleColor];
    [self addSubview:bgView];
    
    UIView * bgAlphaView = [MyControl createViewWithFrame:CGRectMake(0, 130, bgView.frame.size.width, bgView.frame.size.height-130)];
    bgAlphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [bgView addSubview:bgAlphaView];
    
    UIView * headView = [MyControl createViewWithFrame:CGRectMake(0, 0, bgView.frame.size.width, 130)];
    headView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [bgView addSubview:headView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
