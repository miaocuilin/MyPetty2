//
//  SystemCell.m
//  MyPetty
//
//  Created by Aidi on 14-7-3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "SystemCell.h"

@implementation SystemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self SystemUI];
    }
    return self;
}
- (void)SystemUI
{
    noticeSystem_tx = [MyControl createImageViewWithFrame:CGRectMake(10, 15, 50, 50) ImageName:@"20-1.png"];
    noticeSystem_tx.layer.cornerRadius = 25;
    noticeSystem_tx.layer.masksToBounds = YES;
    [self.contentView addSubview:noticeSystem_tx];
    
    noticeSystem_name = [MyControl createLabelWithFrame:CGRectMake(70, 15, 100, 20) Font:15 Text:@"仁者神鬼"];
    noticeSystem_name.textColor = BGCOLOR;
    [self.contentView addSubview:noticeSystem_name];
    //回复了我、评论了我
    noticeSystem_action = [MyControl createLabelWithFrame:CGRectMake(150, 15, 120, 20) Font:15 Text:@"回复了我"];
    noticeSystem_action.textColor = [UIColor blackColor];
    [self.contentView addSubview:noticeSystem_action];
    
    noticeSystem_time = [MyControl createLabelWithFrame:CGRectMake(260, 15, 60, 20) Font:12 Text:@"2小时前"];
    noticeSystem_time.textColor = [UIColor grayColor];
    [self.contentView addSubview:noticeSystem_time];
    
    commentLabel = [MyControl createLabelWithFrame:CGRectMake(70, 45, 320-70, 20) Font:15 Text:@"今天天气真好我们快去出去遛狗吧，这么好的天气别浪费了"];
    commentLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:commentLabel];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 74, self.frame.size.width, 1)];
    horizontalLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:horizontalLine];
}

-(void)configUI:(SystemMessageListModel *)model
{

    CGSize size = [model.name sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(100, 20)];
    noticeSystem_name.text = model.name;
    noticeSystem_name.frame =CGRectMake(90, 15, size.width, 20);
    
    NSArray * arr1 = [model.body componentsSeparatedByString:model.name];
    noticeSystem_action.text = arr1[1];
    noticeSystem_action.frame = CGRectMake(noticeSystem_name.frame.origin.x+noticeSystem_name.frame.size.width+10, 15, 80, 20);
    
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
    
    noticeSystem_time.text = result;
    
    NSString * docDir = DOCDIR;
    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txFilePath]];
    if (image) {
        noticeSystem_tx.image = image;
    }else{
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, model.tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                //本地目录，用于存放favorite下载的原图
                NSString * docDir = DOCDIR;
                //NSLog(@"docDir:%@", docDir);
                if (!docDir) {
                    NSLog(@"Documents 目录未找到");
                }else{
                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
                    //将下载的图片存放到本地
                    [load.data writeToFile:txFilePath atomically:YES];
                    noticeSystem_tx.image = load.dataImage;
                }
            }else{
                //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                //            [alert show];
                //            [alert release];
            }
        }];
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
