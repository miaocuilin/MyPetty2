//
//  FAQCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-9-11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "FAQCell.h"

@implementation FAQCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 35)];
    bgView.backgroundColor = [ControllerManager colorWithHexString:@"fefdfd"];
    bgView.alpha = 0.55;
    [self.contentView addSubview:bgView];
    
    UIImageView * queImageView = [MyControl createImageViewWithFrame:CGRectMake(18, 10, 15, 15) ImageName:@"question.png"];
    [self.contentView addSubview:queImageView];
    
    queLabel = [MyControl createLabelWithFrame:CGRectMake(40, 7.5, 200, 20) Font:15 Text:@""];
    queLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:queLabel];
    
    ansLabel = [MyControl createLabelWithFrame:CGRectMake(18, 35+10, 320-36, 200) Font:13 Text:@""];
    ansLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:ansLabel];
}
-(void)configUIWithQue:(NSString *)que Ans:(NSString *)ans
{
    NSLog(@"%@--%@", que, ans);
    queLabel.text = que;
    
    if ([ans rangeOfString:@"\n"].location != NSNotFound) {
        NSArray * array = [ans componentsSeparatedByString:@"\n"];
        if (array.count != 0) {
            ans = [NSString stringWithFormat:@"%@\n%@", array[0], array[1]];
        }
    }
    CGRect rect = ansLabel.frame;
    CGSize size = [ans sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(320-36, 200) lineBreakMode:1];
    rect.size.height = size.height;
    ansLabel.frame = rect;
    ansLabel.text = ans;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
