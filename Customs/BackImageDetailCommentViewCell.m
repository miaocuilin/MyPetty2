//
//  BackImageDetailCommentViewCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/23.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "BackImageDetailCommentViewCell.h"

@implementation BackImageDetailCommentViewCell

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
    
    name = [MyControl createLabelWithFrame:CGRectMake(45, 10, 220, 15) Font:12 Text:nil];
    name.textColor = ORANGE;
    [self addSubview:name];
    
    float Width = [UIScreen mainScreen].bounds.size.width-13*2-10*2;
    
    desLabel = [MyControl createLabelWithFrame:CGRectMake(45, 30, Width-40-10-35, 15) Font:12 Text:nil];
    desLabel.textColor = [ControllerManager colorWithHexString:@"3d3d3d"];
    [self addSubview:desLabel];
    
    
    time = [MyControl createLabelWithFrame:CGRectMake(Width-155, 10, 150, 15) Font:11 Text:nil];
    time.textColor = [ControllerManager colorWithHexString:@"7b7878"];
    time.textAlignment = NSTextAlignmentRight;
    [self addSubview:time];
    
    line = [MyControl createViewWithFrame:CGRectMake(40, 53-1, Width-40, 1)];
    line.backgroundColor = [ControllerManager colorWithHexString:@"dddddd"];
    [self addSubview:line];
    
    reportBtn = [MyControl createButtonWithFrame:CGRectMake(Width-5-25, 28, 18*31/26.0, 18) ImageName:@"grayAlert.png" Target:self Action:@selector(report) Title:nil];
    [self addSubview:reportBtn];
}
-(void)report
{
    NSLog(@"report");
    self.reportBlock();
}
-(void)configUIWithName:(NSString *)nameStr Cmt:(NSString *)cmt Time:(NSString *)timeStr CellHeight:(float)cellHeight textSize:(CGSize)textSize Tx:(NSString *)tx isTest:(BOOL)isTest
{
    if (!isTest) {
        reportBtn.hidden = YES;
    }else{
        reportBtn.hidden = NO;
    }
    
    if (![tx isEqualToString:@"0"]) {
        [headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL, tx]] placeholderImage:[UIImage imageNamed:@"defaultUserHead.png"]];
    }else{
        headImageView.image = [UIImage imageNamed:@"defaultUserHead.png"];
    }
    
    
    CGRect lineRect = line.frame;
    lineRect.origin.y = cellHeight-1;
    line.frame = lineRect;
    
//    NSLog(@"%f", self.frame.size.height);
    //发言者
    NSString * name1 = nil;
    //被回复者
    NSString * name2 = nil;
    NSString * combineStr = nil;
    NSLog(@"%@", nameStr);
    if ([nameStr rangeOfString:@"&"].location == NSNotFound) {
        combineStr = nameStr;
    }else{
        name1 = [[nameStr componentsSeparatedByString:@"&"] objectAtIndex:0];
        name2 = [[nameStr componentsSeparatedByString:@"&"] objectAtIndex:1];
        if ([name2 rangeOfString:@"@"].location != NSNotFound) {
            name2 = [[name2 componentsSeparatedByString:@"@"] objectAtIndex:1];
        }
//        if ([nameStr rangeOfString:@"@"].location == NSNotFound) {
//            name2 = [[nameStr componentsSeparatedByString:@"&"] objectAtIndex:1];
//        }else{
//            //1099&阿汤叔&阿汤叔@1100p  应该是1099p回复阿汤哥
//            name2 = [[[[nameStr componentsSeparatedByString:@"&"] objectAtIndex:1] componentsSeparatedByString:@"@"] objectAtIndex:1];
//        }
        combineStr = [NSString stringWithFormat:@"%@ 回复 %@", name1, name2];
    }
    
    NSMutableAttributedString * mutableStr = [[NSMutableAttributedString alloc] initWithString:combineStr];
    
    [mutableStr addAttribute:NSForegroundColorAttributeName value:ORANGE range:NSMakeRange(0, combineStr.length)];
    if ([nameStr rangeOfString:@"&"].location != NSNotFound) {
        [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(name1.length+1, 2)];
    }
    name.attributedText = mutableStr;
    [mutableStr release];
    
    desLabel.text = cmt;
    if (textSize.height>15) {
        CGRect desRect = desLabel.frame;
        desRect.size.height = textSize.height;
        desLabel.frame = desRect;
    }
    
    time.text = [MyControl timeFromTimeStamp:timeStr];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
