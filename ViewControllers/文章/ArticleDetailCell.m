//
//  ArticleDetailCell.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/23.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "ArticleDetailCell.h"

@interface ArticleDetailCell ()
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *cmtLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@end

@implementation ArticleDetailCell

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
    self.headImageView = [MyControl createImageViewWithFrame:CGRectMake(15, 2, 32, 32) ImageName:@"defaultUserHead.png"];
    [self.contentView addSubview:self.headImageView];
    
    self.nameLabel = [MyControl createLabelWithFrame:CGRectMake(self.headImageView.frame.origin.x+self.headImageView.frame.size.width+10, 2, 150, 15) Font:12 Text:@"取名字什么的真难"];
    self.nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.nameLabel];
    
    self.cmtLabel = [MyControl createLabelWithFrame:CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height+5, 200, 15) Font:12 Text:@"取名字什么的真难"];
    self.cmtLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.cmtLabel];
    
    CGFloat width = 100.0;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    NSString *str = [formatter stringFromDate:date];
    
    self.timeLabel = [MyControl createLabelWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-width-10, 2, width, 15) Font:10 Text:str];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(100, 15) options:NSStringDrawingUsesFontLeading attributes:nil context:nil];
//    [str sizeWithFont:<#(UIFont *)#> constrainedToSize:<#(CGSize)#> lineBreakMode:<#(NSLineBreakMode)#>];
    UIImageView *iconTime = [MyControl createImageViewWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-rect.size.width-20, 3, 12, 12) ImageName:@"icon_time.png"];
    [self.contentView addSubview:iconTime];
}

@end
