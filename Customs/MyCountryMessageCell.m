//
//  MyCountryMessageCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MyCountryMessageCell.h"
#import "PicDetailViewController.h"
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
    photoImage = [MyControl createButtonWithFrame:CGRectMake(0, 0, 0, 0) ImageName:@"20-1.png" Target:self Action:@selector(photoImageClick) Title:nil];
//    photoImage.image = [UIImage imageNamed:@"20-1.png"];
    [self.contentView addSubview:photoImage];
    
    //button
    sendOne = [MyControl createButtonWithFrame:CGRectZero ImageName:@"" Target:self Action:nil Title:nil];
    [self.contentView addSubview:sendOne];
    
    playOne = [MyControl createButtonWithFrame:CGRectZero ImageName:@"" Target:self Action:nil Title:nil];
    [self.contentView addSubview:playOne];
    
    touchOne = [MyControl createButtonWithFrame:CGRectZero ImageName:@"" Target:self Action:nil Title:nil];
    [self.contentView addSubview:touchOne];
}
-(void)modifyWithModel:(PetNewsModel *)model PetName:(NSString *)petName
{
    //隐藏4个控件
    photoImage.hidden = YES;
    sendOne.hidden = YES;
    playOne.hidden = YES;
    touchOne.hidden = YES;
    
    int type = [model.type intValue];
    //1.成粉 2.加入 3.发图 4.送礼 5.叫一叫 6.逗一逗 7.捣乱 8.参加活动
    time.text = [MyControl timeFromTimeStamp:model.create_time];
    if (type == 1) {
        //成为粉丝
        typeImageView.image = [UIImage imageNamed:@"myCountry_heart.png"];
        
        NSString * str1 = [model.content objectForKey:@"u_name"];
        NSString * str2 = petName;
        NSString * bodyStr = [NSString stringWithFormat:@"%@ 成为了 %@ 的粉丝", str1, str2];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:bodyStr];
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(0, str1.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str1.length+5, str2.length)];
        
        CGSize size = [bodyStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 100) lineBreakMode:1];
        
        body.frame = CGRectMake(60, 30, 240, size.height);
        body.attributedText = str;
    }else if (type == 2) {
        //加入
        typeImageView.image = [UIImage imageNamed:@"myCountry_join.png"];
        
        NSString * str1 = [model.content objectForKey:@"u_name"];
        NSString * str2 = petName;
        NSString * bodyStr = [NSString stringWithFormat:@"%@ 被萌星 %@ 的魅力折服，路人转粉啦~", str1, str2];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:bodyStr];
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(0, str1.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str1.length+5, str2.length)];
        
//        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(3+str1.length+5+str2.length+5, str2.length)];
        CGSize size = [bodyStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 100) lineBreakMode:1];
        
        body.frame = CGRectMake(60, 30, 240, size.height);
        body.attributedText = str;
        
    }else if (type == 3) {
        //发照片
        typeImageView.image = [UIImage imageNamed:@"myCountry_photo.png"];
        
        NSString * str1 = [model.content objectForKey:@"u_name"];
        NSString * str2 = petName;
        NSString * str3 = [ControllerManager returnPositionWithRank:[model.content objectForKey:@"rank"]];
        
        NSString * bodyStr = [NSString stringWithFormat:@"%@— %@ 发布了一张萌星 %@ 的照片", str3, str1, str2];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:bodyStr];
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str3.length+2, str1.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str3.length+2+str1.length+9, str2.length)];
        CGSize size = [bodyStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 100) lineBreakMode:1];
        
        body.frame = CGRectMake(60, 30, 240, size.height);
        body.attributedText = str;
        
//        photoImage = [[ClickImage alloc] initWithFrame:CGRectMake(60, 30+size.height+5, 190/2, 60)];
        photoImage.hidden = NO;
        photoImage.frame = CGRectMake(60, 30+size.height+5, 190/2, 60);
//        photoImage.image = [UIImage imageNamed:@"cat2.jpg"];
        /**************************/
        if (!([[model.content objectForKey:@"img_url"] isKindOfClass:[NSNull class]] || [[model.content objectForKey:@"img_url"] length]==0)) {
            NSString * docDir = DOCDIR;
            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [model.content objectForKey:@"img_url"]]];
            UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
            if (image) {
                [photoImage setBackgroundImage:image forState:UIControlStateNormal];
            }else{
                //下载头像
                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, [model.content objectForKey:@"img_url"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
                        [photoImage setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                        NSString * docDir = DOCDIR;
                        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [model.content objectForKey:@"img_url"]]];
                        [load.data writeToFile:txFilePath atomically:YES];
                    }else{
                        NSLog(@"照片下载失败");
                    }
                }];
                [request release];
            }
        }
        /**************************/
    }else if (type == 4) {
        //礼物
        typeImageView.image = [UIImage imageNamed:@"myCountry_gift.png"];
        
        //body
        NSString * str1 = [ControllerManager returnPositionWithRank:[model.content objectForKey:@"rank"]];
        NSString * str2 = [model.content objectForKey:@"u_name"];
        NSString * str3 = petName;
        NSString * str4 = [[ControllerManager returnGiftDictWithItemId:[model.content objectForKey:@"item_id"]] objectForKey:@"name"];
//        NSString * str4 = [model.content objectForKey:@"item_name"];
        NSString * str5 = [NSString stringWithFormat:@"+%@", [model.content objectForKey:@"rq"]];
        NSString * str6 = [ControllerManager returnActionStringWithItemId:[model.content objectForKey:@"item_id"]];
        
        NSString * bodyStr = [NSString stringWithFormat:@"%@— %@ 精心挑选了一个 %@ 送给 %@, %@ %@ 人气 %@", str1, str2, str4, str3, str3, str6, str5];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:bodyStr];
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str1.length + 2, str2.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str1.length+2+str2.length+9, str4.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str1.length+2+str2.length+9+str4.length+4, str3.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str1.length+2+str2.length+9+str4.length+4+str3.length+2, str3.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str1.length+2+str2.length+9+str4.length+4+str3.length+2+str3.length+1+str6.length+4, str5.length)];
        CGSize size = [bodyStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 100) lineBreakMode:1];
        
        body.frame = CGRectMake(60, 30, 240, size.height);
        body.attributedText = str;
        
        sendOne.hidden = NO;
        sendOne.frame = CGRectMake(60, body.frame.origin.y+body.frame.size.height+5, 60, 20);
        [sendOne addTarget:self action:@selector(sendOneClick) forControlEvents:UIControlEventTouchUpInside];
        [sendOne setBackgroundImage:[UIImage imageNamed:@"sendOne.png"] forState:UIControlStateNormal];
        //        sendOne = [MyControl createButtonWithFrame:CGRectMake(60, body.frame.origin.y+body.frame.size.height+5, 60, 20) ImageName:@"sendOne.png" Target:self Action:@selector(sendOneClick) Title:nil];
        //        [self.contentView addSubview:sendOne];
    }else if (type == 5) {
        //摸一摸 叫一叫
        typeImageView.image = [UIImage imageNamed:@"myCountry_shout.png"];
        NSString * str1 = petName;
        NSString * bodyStr = [NSString stringWithFormat:@"萌星 %@ 今天心情nice~乖巧地叫了一声。", str1];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:bodyStr];
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(3, str1.length)];
        CGSize size = [bodyStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 100) lineBreakMode:1];
        
        body.frame = CGRectMake(60, 30, 240, size.height);
        body.attributedText = str;
        
//        touchOne.hidden = YES;
//        touchOne.frame = CGRectMake(60, body.frame.origin.y+body.frame.size.height+5, 60, 20);
//        [touchOne addTarget:self action:@selector(touchOneClick) forControlEvents:UIControlEventTouchUpInside];
//        [touchOne setBackgroundImage:[UIImage imageNamed:@"touchOne.png"] forState:UIControlStateNormal];
        
//        touchOne = [MyControl createButtonWithFrame:CGRectMake(60, body.frame.origin.y+body.frame.size.height+5, 60, 20) ImageName:@"touchOne.png" Target:self Action:@selector(touchOneClick) Title:nil];
//        [self.contentView addSubview:touchOne];
    }else if(type == 6){
        //逗一逗
        typeImageView.image = [UIImage imageNamed:@"myCountry_game.png"];
        
        NSString * str1 = [model.content objectForKey:@"u_name"];
        NSString * str2 = petName;
        NSString * str3 = @"99";
        NSString * str4 = [ControllerManager returnPositionWithRank:[model.content objectForKey:@"rank"]];
        
        NSString * bodyStr = [NSString stringWithFormat:@"%@— %@ 在游乐园中为萌星 %@ 消灭了 %@ 只虫子！", str4, str1, str2, str3];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:bodyStr];
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str4.length+2, str1.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str4.length+2+str1.length+3+str2.length+8, str3.length)];
        
        CGSize size = [bodyStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 100) lineBreakMode:1];
        
        body.frame = CGRectMake(60, 30, 240, size.height);
        body.attributedText = str;
        
        playOne.hidden = NO;
        playOne.frame = CGRectMake(60, body.frame.origin.y+body.frame.size.height+5, 60, 20);
        [playOne addTarget:self action:@selector(playOneClick) forControlEvents:UIControlEventTouchUpInside];
        [playOne setBackgroundImage:[UIImage imageNamed:@"playOne.png"] forState:UIControlStateNormal];
        //        playOne = [MyControl createButtonWithFrame:CGRectMake(60, body.frame.origin.y+body.frame.size.height+5, 60, 20) ImageName:@"playOne.png" Target:self Action:@selector(playOneClick) Title:nil];
        //        [self.contentView addSubview:playOne];
    }else{
        //扔炸弹 -人气
        typeImageView.image = [UIImage imageNamed:@"myCountry_trouble.png"];
        
        NSString * str1 = [model.content objectForKey:@"u_name"];
        NSString * str2 = petName;
        NSString * str3 = [[ControllerManager returnGiftDictWithItemId:[model.content objectForKey:@"item_id"]] objectForKey:@"name"];
        NSString * str4 = [NSString stringWithFormat:@"%@", [model.content objectForKey:@"rq"]];
        NSString * str5 = [ControllerManager returnActionStringWithItemId:[model.content objectForKey:@"item_id"]];
        NSString * str6 = [ControllerManager returnPositionWithRank:[model.content objectForKey:@"rank"]];
        
        NSString * bodyStr = [NSString stringWithFormat:@"%@— %@ 腹黑一笑，对 %@ 扔了一个 %@, %@ %@ 人气 %@", str6, str1, str2, str3, str2, str5, str4];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:bodyStr];
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(0, str6.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str6.length+2, str1.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str6.length+2+str1.length+8, str2.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str6.length+2+str1.length+8+str2.length+6, str3.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str6.length+2+str1.length+8+str2.length+6+str3.length+2, str2.length)];
        
//        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str6.length+2+str1.length+8+str2.length+6+str3.length+2+str2.length+1, str5.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(str6.length+2+str1.length+8+str2.length+6+str3.length+2+str2.length+1+str5.length+4, str4.length)];
        
        CGSize size = [bodyStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240, 105) lineBreakMode:1];
        
        body.frame = CGRectMake(60, 30, 240, size.height);
        body.attributedText = str;
    }
}
-(void)sendOneClick
{
    NSLog(@"sendOne");
    self.sendGift();
}
-(void)playOneClick
{
    NSLog(@"playOne");
}
-(void)touchOneClick
{
    NSLog(@"touchOne");
}
-(void)photoImageClick
{
    self.clickImage();
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
