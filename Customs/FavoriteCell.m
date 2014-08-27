//
//  FavoriteCell.m
//  MyPetty
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "FavoriteCell.h"
#import "UIImageView+WebCache.h"
@implementation FavoriteCell

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
    headImageView = [MyControl createImageViewWithFrame:CGRectMake(5, 15, 30, 30) ImageName:@""];
    //裁剪位图像大小一半即可裁成圆形
    headImageView.layer.cornerRadius = 15;
    headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:headImageView];
    
    titleLabel = [MyControl createLabelWithFrame:CGRectMake(40, 10, 200, 20) Font:15 Text:nil];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:116/255.0 blue:88/255.0 alpha:1];
    [self.contentView addSubview:titleLabel];
    
    detailLabel = [MyControl createLabelWithFrame:CGRectMake(40, 30, 200, 20) Font:13 Text:nil];
    detailLabel.font = [UIFont boldSystemFontOfSize:13];
    detailLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:detailLabel];
    
    timeLabel = [MyControl createLabelWithFrame:CGRectMake(320-100-10, 15, 100, 20) Font:13 Text:nil];
    timeLabel.font = [UIFont boldSystemFontOfSize:13];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    
    self.bigImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 100, 100) ImageName:nil];
    self.bigImageView.center = CGPointMake(320/2, 150);
    [self.contentView addSubview:self.bigImageView];
    
    numLabel = [MyControl createLabelWithFrame:CGRectMake(10, 210, 65, 30) Font:15 Text:nil];
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.alpha = 0.5;
    numLabel.layer.cornerRadius = 5;
    numLabel.layer.masksToBounds = YES;
    numLabel.userInteractionEnabled = YES;
    numLabel.backgroundColor = [UIColor blackColor];
    numLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:numLabel];
    
    heart = [MyControl createImageViewWithFrame:CGRectMake(5, 5, 20, 20) ImageName:@"11-1.png"];
    heart.image = [UIImage imageNamed:@"11-1.png"];
    [numLabel addSubview:heart];
    
    heartButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 65, 30) ImageName:@"" Target:self Action:@selector(heartButtonClick:) Title:nil];
    

    [numLabel addSubview:heartButton];
    
    desLabel = [MyControl createLabelWithFrame:CGRectMake(5, 250, 310, 50) Font:17 Text:nil];
    desLabel.textColor = [UIColor blackColor];
    desLabel.font = [UIFont boldSystemFontOfSize:17];
    if (iOS7) {
        desLabel.textAlignment = NSTextAlignmentJustified;
    }else{
        desLabel.textAlignment = NSTextAlignmentLeft;
    }
    [self.contentView addSubview:desLabel];
    
}


-(void)configUI:(PhotoModel *)model
{
//    [bigImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]]];
    if (![model.likers isKindOfClass:[NSNull class]]) {
        self.likersArray = [model.likers componentsSeparatedByString:@","];
        for(NSString * str in self.likersArray){
            if ([str isEqualToString:[USER objectForKey:@"usr_id"]]) {
                NSLog(@"%@", model.likers);
//                isLike = YES;
                heartButton.selected = YES;
                heart.image = [UIImage imageNamed:@"11-2.png"];
                break;
            }else{
//                isLike = NO;
                heartButton.selected = NO;
                heart.image = [UIImage imageNamed:@"11-1.png"];
            }
        }
    }else{
        heartButton.selected = NO;
        heart.image = [UIImage imageNamed:@"11-1.png"];
    }
    self.img_id = model.img_id;
    numLabel.text = model.likes;
//    if (model.cmt.length>0) {
        desLabel.text = model.cmt;
//        desLabel.textColor = [UIColor blackColor];
//    }else{
//        desLabel.text = @"这家伙很懒，什么都没有留下 = =。";
//        desLabel.textColor = [UIColor lightGrayColor];
//    }
    
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.create_time intValue]];

    NSTimeInterval  timeInterval = [confromTimesp timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    timeLabel.text = [NSString stringWithFormat:@"%@", result];
//    [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            bigImageView.image = load.dataImage;
//            float width = bigImageView.image.size.width;
//            float height = bigImageView.image.size.height;
//            if (width>320) {
//                float w = 320/width;
//                width *= w;
//                height *= w;
//            }
//            if (height>200) {
//                float h = 200/height;
//                width *= h;
//                height *= h;
//            }
//            bigImageView.frame = CGRectMake(0, 0, width, height);
//            bigImageView.center = CGPointMake(320/2, 300/2);
//        }else{
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//            [alert release];
//        }
//    }];
}

-(void)configUsrInfo:(InfoModel *)model
{
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }else{
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txFilePath]];
        if (image) {
            headImageView.image = image;
        }else{
            [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", TXURL, model.tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    //本地目录，用于存放favorite下载的原图
                    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    //                    NSLog(@"docDir:%@", docDir);
                    if (!docDir) {
                        NSLog(@"Documents 目录未找到");
                    }else{
                        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
                        //将下载的图片存放到本地
                        [load.data writeToFile:txFilePath atomically:YES];
                        headImageView.image = load.dataImage;
                    }
                }else{
                    //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    //            [alert show];
                    //            [alert release];
                }
            }];
        }
    }
    titleLabel.text = model.name;
//    detailLabel.text = @"苏格兰折耳猫";
    int a = [model.type intValue];
    NSLog(@"%@--%d", [USER objectForKey:@"type"], a);
    NSString * cateName = nil;
    
    if (a/100 == 1) {
        cateName = [[[USER objectForKey:@"CateNameList"]objectForKey:@"1"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else if(a/100 == 2){
        cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"2"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else if(a/100 == 3){
        cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"3"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else{
        cateName = @"未知物种";
    }
    if (cateName == nil) {
        //更新本地宠物名单列表
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", TYPEAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                [USER setObject:[load.dataDict objectForKey:@"data"] forKey:@"CateNameList"];
                NSString * path = [DOCDIR stringByAppendingPathComponent:@"CateNameList.plist"];
                NSMutableDictionary * data = [load.dataDict objectForKey:@"data"];
                //本地及内存存储
                [data writeToFile:path atomically:YES];
                [USER setObject:data forKey:@"CateNameList"];
                int a = [[USER objectForKey:@"type"] intValue];
                NSString * cateName = nil;
                
                if (a/100 == 1) {
                    cateName = [[[USER objectForKey:@"CateNameList"]objectForKey:@"1"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else if(a/100 == 2){
                    cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"2"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else if(a/100 == 3){
                    cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"3"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else{
                    cateName = @"未知物种";
                }
                detailLabel.text = [NSString stringWithFormat:@"%@ | %@岁", cateName, model.age];
            }
        }];
        
    }else{
        detailLabel.text = [NSString stringWithFormat:@"%@ | %@岁", cateName, model.age];
    }
    
}
-(void)heartButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
//    button.userInteractionEnabled = NO;
//    self.contentView.userInteractionEnabled = NO;
//    self.superview.userInteractionEnabled = NO;
    
    NSString * code = [NSString stringWithFormat:@"img_id=%@dog&cat", self.img_id];
    NSString * sig = [MyMD5 md5:code];
    if (button.selected) {
        heart.image = [UIImage imageNamed:@"11-2.png"];
        numLabel.text = [NSString stringWithFormat:@"%d", [numLabel.text intValue]+1];
        //赞
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", LIKEAPI, self.img_id, sig, [ControllerManager getSID]];
        NSLog(@"likeURL:%@", url);
        
        [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                if (![[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"点赞失败 = =."];
                    
                    heart.image = [UIImage imageNamed:@"11-1.png"];
                    numLabel.text = [NSString stringWithFormat:@"%d", [numLabel.text intValue]-1];
                }else{
                    [USER setObject:@"1" forKey:@"favoriteRefresh"];
                }
            }else{
                NSLog(@"数据请求失败");
            }
//            button.userInteractionEnabled = YES;
//            self.contentView.userInteractionEnabled = YES;
        }];
        
    }else{
        heart.image = [UIImage imageNamed:@"11-1.png"];
        numLabel.text = [NSString stringWithFormat:@"%d", [numLabel.text intValue]-1];
        //取消赞
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", UNLIKEAPI, self.img_id, sig, [ControllerManager getSID]];
        NSLog(@"likeURL:%@", url);
        
        [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                if (![[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消赞失败 = =."];
                    heart.image = [UIImage imageNamed:@"11-2.png"];
                    numLabel.text = [NSString stringWithFormat:@"%d", [numLabel.text intValue]+1];
                }else{
                    [USER setObject:@"1" forKey:@"favoriteRefresh"];
                }
            }else{
                NSLog(@"数据请求失败");
            }
//            button.userInteractionEnabled = YES;
//            self.contentView.userInteractionEnabled = YES;
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
