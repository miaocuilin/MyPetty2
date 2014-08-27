//
//  MyCountryMessageCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MyCountryMessageCell.h"

@implementation MyCountryMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    grayLine = [MyControl createViewWithFrame:CGRectMake(30, 0, 1, 130)];
    grayLine.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    [self.contentView addSubview:grayLine];
    
    typeImageView = [MyControl createImageViewWithFrame:CGRectMake(30-(35-1)/2, 23, 35, 35) ImageName:@""];
    [self.contentView addSubview:typeImageView];
    
    //time
    time = [MyControl createLabelWithFrame:CGRectMake(60, 15, 200, 15) Font:12 Text:@"2分钟前"];
    time.textColor = [ControllerManager colorWithHexString:@"a1a1a1"];
    [self.contentView addSubview:time];
    
    //body
    body = [MyControl createLabelWithFrame:CGRectMake(60, 30, 240, 20) Font:14 Text:nil];
    body.textColor = [UIColor blackColor];
    [self.contentView addSubview:body];
    
    //clickImage
    photoImage = [[ClickImage alloc] init];
    [self.contentView addSubview:photoImage];
    
    //button
    sendOne = [MyControl createButtonWithFrame:CGRectZero ImageName:@"" Target:self Action:nil Title:nil];
    [self.contentView addSubview:sendOne];
    
    playOne = [MyControl createButtonWithFrame:CGRectZero ImageName:@"" Target:self Action:nil Title:nil];
    [self.contentView addSubview:playOne];
    
    touchOne = [MyControl createButtonWithFrame:CGRectZero ImageName:@"" Target:self Action:nil Title:nil];
    [self.contentView addSubview:touchOne];
}
-(void)modifyWithType:(int)type
{
    //隐藏4个控件
    photoImage.hidden = YES;
    sendOne.hidden = YES;
    playOne.hidden = YES;
    touchOne.hidden = YES;
    
    if (type == 1) {
        //礼物
        typeImageView.image = [UIImage imageNamed:@"myCountry_gift.png"];
        
        //body
        NSString * str1 = @"喵小二";
        NSString * str2 = @"大和尚";
        NSString * str3 = @"猫君";
        NSString * str4 = @"魔法棒";
        NSString * bodyStr = [NSString stringWithFormat:@"%@— %@ 送给了 %@ 一个 %@", str1, str2, str3, str4];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:bodyStr];
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str1.length + 2, str2.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str1.length+2+str2.length+5, str3.length)];
        
        CGSize size = [bodyStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 100) lineBreakMode:1];
        
        body.frame = CGRectMake(60, 30, 240, size.height);
        body.attributedText = str;
        
        sendOne.hidden = NO;
        sendOne.frame = CGRectMake(60, body.frame.origin.y+body.frame.size.height+5, 60, 20);
        [sendOne addTarget:self action:@selector(sendOneClick) forControlEvents:UIControlEventTouchUpInside];
        [sendOne setBackgroundImage:[UIImage imageNamed:@"sendOne.png"] forState:UIControlStateNormal];
//        sendOne = [MyControl createButtonWithFrame:CGRectMake(60, body.frame.origin.y+body.frame.size.height+5, 60, 20) ImageName:@"sendOne.png" Target:self Action:@selector(sendOneClick) Title:nil];
//        [self.contentView addSubview:sendOne];
    }else if (type == 2) {
        //加入
        typeImageView.image = [UIImage imageNamed:@"myCountry_join.png"];
        
        NSString * str1 = @"大和尚";
        NSString * str2 = @"猫君国";
        NSString * bodyStr = [NSString stringWithFormat:@"%@ 加入了 %@ 成为了 %@ 平民", str1, str2, str2];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:bodyStr];
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(0, str1.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str1.length+5, str2.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str1.length+5+str2.length+5, str2.length)];
        CGSize size = [bodyStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 100) lineBreakMode:1];
        
        body.frame = CGRectMake(60, 30, 240, size.height);
        body.attributedText = str;
        
    }else if (type == 3) {
        //发照片
        typeImageView.image = [UIImage imageNamed:@"myCountry_photo.png"];
        
        NSString * str1 = @"Anna";
        NSString * str2 = @"猫君";
        NSString * bodyStr = [NSString stringWithFormat:@"%@ 发布了一张 %@ 的照片", str1, str2];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:bodyStr];
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(0, str1.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str1.length+7, str2.length)];
        CGSize size = [bodyStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 100) lineBreakMode:1];
        
        body.frame = CGRectMake(60, 30, 240, size.height);
        body.attributedText = str;
        
//        photoImage = [[ClickImage alloc] initWithFrame:CGRectMake(60, 30+size.height+5, 190/2, 60)];
        photoImage.hidden = NO;
        photoImage.frame = CGRectMake(60, 30+size.height+5, 190/2, 60);
        photoImage.image = [UIImage imageNamed:@"cat2.jpg"];
        photoImage.canClick = YES;
    }else if (type == 4) {
        //逗一逗
        typeImageView.image = [UIImage imageNamed:@"myCountry_game.png"];
        
        NSString * str1 = @"Anna";
        NSString * str2 = @"逗一逗";
        NSString * str3 = @"99";
        NSString * bodyStr = [NSString stringWithFormat:@"%@ 在 %@ 游戏中获得了 %@ 分的好成绩", str1, str2, str3];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:bodyStr];
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(0, str1.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str1.length+3+str2.length+8, str3.length)];
        
        CGSize size = [bodyStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 100) lineBreakMode:1];
        
        body.frame = CGRectMake(60, 30, 240, size.height);
        body.attributedText = str;
        
        playOne.hidden = NO;
        playOne.frame = CGRectMake(60, body.frame.origin.y+body.frame.size.height+5, 60, 20);
        [playOne addTarget:self action:@selector(playOneClick) forControlEvents:UIControlEventTouchUpInside];
        [playOne setBackgroundImage:[UIImage imageNamed:@"playOne.png"] forState:UIControlStateNormal];
//        playOne = [MyControl createButtonWithFrame:CGRectMake(60, body.frame.origin.y+body.frame.size.height+5, 60, 20) ImageName:@"playOne.png" Target:self Action:@selector(playOneClick) Title:nil];
//        [self.contentView addSubview:playOne];
    }else if (type == 5) {
        //摸一摸
        typeImageView.image = [UIImage imageNamed:@"myCountry_shout.png"];
        NSString * str1 = @"猫君";
        NSString * bodyStr = [NSString stringWithFormat:@"%@ 今天心情很好，开心的叫了叫", str1];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:bodyStr];
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(0, str1.length)];
        CGSize size = [bodyStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 100) lineBreakMode:1];
        
        body.frame = CGRectMake(60, 30, 240, size.height);
        body.attributedText = str;
        
        touchOne.hidden = NO;
        touchOne.frame = CGRectMake(60, body.frame.origin.y+body.frame.size.height+5, 60, 20);
        [touchOne addTarget:self action:@selector(touchOneClick) forControlEvents:UIControlEventTouchUpInside];
        [touchOne setBackgroundImage:[UIImage imageNamed:@"touchOne.png"] forState:UIControlStateNormal];
//        touchOne = [MyControl createButtonWithFrame:CGRectMake(60, body.frame.origin.y+body.frame.size.height+5, 60, 20) ImageName:@"touchOne.png" Target:self Action:@selector(touchOneClick) Title:nil];
//        [self.contentView addSubview:touchOne];
    }else{
        //成为粉丝
        typeImageView.image = [UIImage imageNamed:@"myCountry_heart.png"];
        
        NSString * str1 = @"大和尚";
        NSString * str2 = @"猫君";
        NSString * bodyStr = [NSString stringWithFormat:@"%@ 成为了 %@ 的粉丝", str1, str2];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:bodyStr];
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(0, str1.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str1.length+5, str2.length)];

        CGSize size = [bodyStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 100) lineBreakMode:1];
        
        body.frame = CGRectMake(60, 30, 240, size.height);
        body.attributedText = str;
    }
}
-(void)sendOneClick
{
    NSLog(@"sendOne");
}
-(void)playOneClick
{
    NSLog(@"playOne");
}
-(void)touchOneClick
{
    NSLog(@"touchOne");
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
-(void)dealloc
{
    [grayLine release];
    [time release];
    [body release];
    [typeImageView release];
    [photoImage release];
    [sendOne release];
    [playOne release];
    [touchOne release];
    [super dealloc];
}
@end
