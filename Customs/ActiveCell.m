//
//  ActiveCell.m
//  MyPetty
//
//  Created by Aidi on 14-6-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ActiveCell.h"

@implementation ActiveCell

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
    imageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, 135) ImageName:@"cat1.jpg"];
    [self.contentView addSubview:imageView];
    
    statusImageView = [MyControl createImageViewWithFrame:CGRectMake(320-20-142/2, 45, 142/2, 96/2) ImageName:@"24-1.png"];
    [imageView addSubview:statusImageView];
    
    titleLabel = [MyControl createLabelWithFrame:CGRectMake(13, 140, 200, 20) Font:17 Text:@"有情狗终成眷属"];
    titleLabel.textColor = BGCOLOR;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:titleLabel];
    
    NSArray * array = @[@"24-3.png", @"24-4.png", @"24-5.png"];
    for(int i=0;i<3;i++){
        UIImageView * imageView2 = [MyControl createImageViewWithFrame:CGRectMake(13, 140+25+i*25, 20, 20) ImageName:array[i]];
        [self.contentView addSubview:imageView2];
        
        UILabel * desLabel = [MyControl createLabelWithFrame:CGRectMake(35, imageView2.frame.origin.y, 280, 20) Font:15 Text:@"1111111111111111111"];
        desLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:desLabel];
        desLabel.tag = 100+i;
    }
}
-(void)configUI:(TopicListModel *)model
{
    UILabel * desLabel1 = (UILabel *)[self.contentView viewWithTag:100];
    UILabel * desLabel2 = (UILabel *)[self.contentView viewWithTag:101];
    UILabel * desLabel3 = (UILabel *)[self.contentView viewWithTag:102];
    
    titleLabel.text = model.topic;
    
    NSDate * startDate = [NSDate dateWithTimeIntervalSince1970:[model.start_time intValue]];
    NSDate * endDate = [NSDate dateWithTimeIntervalSince1970:[model.end_time intValue]];
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * startTime = [dateFormat stringFromDate:startDate];
    NSString * endTime = [dateFormat stringFromDate:endDate];
    [dateFormat release];
    desLabel1.text = [NSString stringWithFormat:@"%@至%@", startTime, endTime];
    desLabel2.text = model.reward;
    desLabel3.text = [NSString stringWithFormat:@"%@人", model.people];
    
    NSTimeInterval  timeInterval = [endDate timeIntervalSinceNow];
    if (timeInterval<=0) {
        statusImageView.image = [UIImage imageNamed:@"24-2.png"];
    }else{
        statusImageView.image = [UIImage imageNamed:@"24-1.png"];
    }
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
