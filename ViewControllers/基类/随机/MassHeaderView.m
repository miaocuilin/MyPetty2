//
//  MassHeaderView.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/26.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "MassHeaderView.h"

@implementation MassHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    UILabel *label = [MyControl createLabelWithFrame:CGRectMake(10, 5, 100, 15) Font:12 Text:@"热门萌星"];
    label.textColor = [UIColor lightGrayColor];
    [self addSubview:label];
    
    //for   头像宽高35  计算起始大小和间距
    NSArray *array = @[@"啦啦啦", @"啦啦啦啦", @"啦啦啦啦啦", @"啦啦啦啦啦", @"啦啦啦啦啦", @"啦啦啦啦"];
    CGFloat w = 35.0;
    CGFloat count = 6;
    CGFloat sideSpe = 20.0;
    CGFloat spe = (WIDTH-sideSpe*2-count*w)/(count-1);
    for (NSInteger i=0; i<count; i++) {
        UIButton *head = [MyControl createButtonWithFrame:CGRectMake(sideSpe+i*(spe+w), label.frame.origin.y+label.frame.size.height+5, w, w) ImageName:@"defaultPetHead.png" Target:self Action:@selector(headClick:) Title:nil];
        head.tag = 100+i;
        [self addSubview:head];
        
        UILabel *nameLabel = [MyControl createLabelWithFrame:CGRectMake(head.frame.origin.x, head.frame.origin.y+w, w, 12) Font:10 Text:array[i]];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        nameLabel.adjustsFontSizeToFitWidth = NO;
        [self addSubview:nameLabel];
    }
    
    UIView *line = [MyControl createViewWithFrame:CGRectMake(0, 80, WIDTH, 1)];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
    
    UILabel *titleLabel = [MyControl createLabelWithFrame:CGRectMake(10, line.frame.origin.y+5, 100, 15) Font:12 Text:@"热门照片"];
    titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:titleLabel];
}
-(void)headClick:(UIButton *)sender
{
    self.headClickBlock(sender.tag-100);
}
@end
