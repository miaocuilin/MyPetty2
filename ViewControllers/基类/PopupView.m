//
//  PopupView.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/17.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PopupView.h"

@implementation PopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    self.bgView = [MyControl createViewWithFrame:CGRectMake(100, 100, 100, 40)];
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.alpha = 0;
    [self addSubview:self.bgView];
    
    self.alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.bgView.frame.size.width, self.bgView.frame.size.height)];
    self.alphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.bgView addSubview:self.alphaView];
    
    self.desLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:15 Text:nil];
    self.desLabel.textColor = [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1];
    [self.bgView addSubview:self.desLabel];
}

-(void)modifyUIWithSize:(CGSize)viewSize msg:(NSString *)msg
{
    float w = 0;
//    float h = 0;
    if (viewSize.width/2.0<200) {
        w = 200;
    }else{
        w = viewSize.width/2.0;
    }
    CGSize size = [msg sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(w-40, 200) lineBreakMode:1];
    
    
    self.bgView.frame = CGRectMake((viewSize.width-(size.width+40))/2.0, (viewSize.height-(size.height+8*2))/2.0, size.width+40, size.height+8*2);
    self.alphaView.frame = CGRectMake(0, 0, self.bgView.frame.size.width, self.bgView.frame.size.height);
    self.desLabel.text = msg;
    self.desLabel.frame = CGRectMake(20, 8, size.width, size.height);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
