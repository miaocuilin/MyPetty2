//
//  UserInfoActivityCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-27.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "UserInfoActivityCell.h"

@implementation UserInfoActivityCell

- (void)awakeFromNib
{
    // Initialization code
    [self adjustUI];
}

-(void)adjustUI
{
    
    activityLabel = [MyControl createLabelWithFrame:CGRectMake(5, 10, 150, 20) Font:15 Text:nil];
    activityLabel.textColor = BGCOLOR;
    [self.contentView addSubview:activityLabel];
    
    activityBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 150, 20) ImageName:@"" Target:self Action:@selector(activityBtnClick:) Title:nil];
    [activityLabel addSubview:activityBtn];
    
    self.timeLabel.textColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1];
    
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSString * str = [formatter stringFromDate:date];
    self.timeLabel.text = str;
    [self.imageBtn setBackgroundImage:[UIImage imageNamed:@"20-1.png"] forState:UIControlStateNormal];
    
    
}
-(void)configUI:(UserActivityListModel *)model
{
    self.img_id = model.img_id;
    
    if ([model.topic_name isKindOfClass:[NSNull class]]) {
        activityLabel.text = @"";
    }else if (model.topic_name == nil) {
        activityLabel.text = @"";
    }else if ([model.topic_name isEqualToString:@"null"]){
        activityLabel.text = @"";
    }else{
        activityLabel.text = model.topic_name;
    }
    
    
    //
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[model.create_time intValue]];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.timeLabel.text = [format stringFromDate:date];
    //
    /***********大图***************/
    //本地目录，用于存放下载的原图
    NSString * docDir = DOCDIR;
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }else{
        NSString * filePath2 = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_small.png", model.url]];
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath2]];
        if (image) {
            [self.imageBtn setBackgroundImage:image forState:UIControlStateNormal];
        }else{
            [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    //本地目录，用于存放favorite下载的原图
                    NSString * docDir = DOCDIR;
                    if (!docDir) {
                        NSLog(@"Documents 目录未找到");
                    }else{
                        NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
                        NSString * filePath2 = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_small.png", model.url]];
                        //将下载的图片存放到本地
                        [load.data writeToFile:filePath atomically:YES];
                        
                        UIImage * image2 = [MyControl returnImageWithImage:load.dataImage Width:self.contentView.frame.size.width Height:160.0f];
                        
                        [self.imageBtn setBackgroundImage:image2 forState:UIControlStateNormal];
                        
                        NSData * smallImageData = UIImageJPEGRepresentation(image2, 0.1);
                        [smallImageData writeToFile:filePath2 atomically:YES];
                    }
                }else{
                    
                }
            }];
        }
    }
}
//-(void)modifyWithString:(NSString *)str
//{
//    activityLabel.text = str;
//    
//    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(150, 20) lineBreakMode:1];
//    CGRect rect = activityLabel.frame;
//    rect.size.width = size.width;
//    activityLabel.frame = rect;
//    
//    activityBtn.frame = CGRectMake(0, 0, rect.size.width, 20);
//}
- (void)activityBtnClick:(UIButton *)btn {
    NSLog(@"点击活动");
}

- (IBAction)imageBtnClick:(UIButton *)sender {
    NSLog(@"进入照片详情");
    self.jumpToDetail(self.img_id);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)dealloc {
    [_timeLabel release];
    [_imageBtn release];
    [super dealloc];
}
@end
