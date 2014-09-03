//
//  NoticeCell.m
//  MyPetty
//
//  Created by Aidi on 14-7-3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "NoticeCell.h"

@implementation NoticeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self MessageUI];
    }
    return self;
}
- (void)MessageUI
{
    noticeMessage_tx = [MyControl createImageViewWithFrame:CGRectMake(10, 15, 50, 50) ImageName:@"20-1.png"];
    noticeMessage_tx.layer.cornerRadius = 25;
    noticeMessage_tx.layer.masksToBounds = YES;
    [self.contentView addSubview:noticeMessage_tx];
    tips = [[UIView alloc ]initWithFrame:CGRectMake(45, 10, 20, 20)];
    tips.backgroundColor = BGCOLOR;
    tips.layer.cornerRadius = 10;
    tips.layer.masksToBounds = YES;
    self.TipsNum = 3;
    UILabel *tipsLabel = [MyControl createLabelWithFrame:CGRectMake(6, 2, 10, 15) Font:15 Text:[NSString stringWithFormat:@"%d",self.TipsNum]];
    [tips addSubview:tipsLabel];
    [self.contentView addSubview:tips];
    
    noticeMessage_name = [MyControl createLabelWithFrame:CGRectMake(70, 15, 100, 20) Font:15 Text:@"111111"];
    noticeMessage_name.textColor = BGCOLOR;
    [self.contentView addSubview:noticeMessage_name];
    
    NSDate * time = [NSDate date];
    noticeMessage_time = [MyControl createLabelWithFrame:CGRectMake(180, 15, 120, 20) Font:12 Text:[NSString stringWithFormat:@"%@",time]];
    noticeMessage_time.textColor = [UIColor grayColor];
    [self.contentView addSubview:noticeMessage_time];
    
    desLabel = [MyControl createLabelWithFrame:CGRectMake(70, 40, self.frame.size.width-70-20, 20) Font:14 Text:@"111111111111111"];
    desLabel.textColor = [UIColor darkGrayColor];
    desLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:desLabel];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 74, self.frame.size.width, 1)];
    horizontalLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:horizontalLine];
}
-(void)configUI:(SystemMessageListModel *)model
{
    NSString * docDir = DOCDIR;
    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txFilePath]];
    if (image) {
        noticeMessage_tx.image = image;
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
                    noticeMessage_tx.image = load.dataImage;
                }
            }else{
                
            }
        }];
    }
    
    noticeMessage_name.text = model.name;
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[model.create_time intValue]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    noticeMessage_time.text = [formatter stringFromDate:date];
    [formatter release];
    desLabel.text = model.body;
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
