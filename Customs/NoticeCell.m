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
    noticeMessage_tx = [MyControl createImageViewWithFrame:CGRectMake(10, 15, 50, 50) ImageName:@"defaultUserHead.png"];
    noticeMessage_tx.layer.cornerRadius = 25;
    noticeMessage_tx.layer.masksToBounds = YES;
    [self.contentView addSubview:noticeMessage_tx];
    
    tips = [MyControl createViewWithFrame:CGRectMake(45, 10, 20, 20)];
    tips.backgroundColor = BGCOLOR;
    tips.layer.cornerRadius = 10;
    tips.layer.masksToBounds = YES;
    
    tipsLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 20, 20) Font:13 Text:@"13"];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [tips addSubview:tipsLabel];
    [self.contentView addSubview:tips];
    
    noticeMessage_name = [MyControl createLabelWithFrame:CGRectMake(70, 15, 100, 20) Font:15 Text:@"111111"];
    noticeMessage_name.textColor = BGCOLOR;
    [self.contentView addSubview:noticeMessage_name];
    
    NSDate * time = [NSDate date];
    noticeMessage_time = [MyControl createLabelWithFrame:CGRectMake(180, 15, 120, 20) Font:12 Text:[NSString stringWithFormat:@"%@",time]];
    noticeMessage_time.textColor = [UIColor grayColor];
    noticeMessage_time.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:noticeMessage_time];
    
    desLabel = [MyControl createLabelWithFrame:CGRectMake(70, 40, self.frame.size.width-70-20, 20) Font:14 Text:@"111111111111111"];
    desLabel.textColor = [UIColor darkGrayColor];
    desLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:desLabel];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 74, self.frame.size.width, 1)];
    horizontalLine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:horizontalLine];
}
-(void)configUIWithTx:(NSString *)tx Name:(NSString *)name Time:(NSString *)time Content:(NSString *)content newMsgNum:(NSString *)newMsgNum img_id:(NSString *)img_id
{
    tips.hidden = YES;
    
    desLabel.text = content;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[time intValue]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    noticeMessage_time.text = [formatter stringFromDate:date];
    [formatter release];
    noticeMessage_name.text = name;
    //下载头像
    /**************************/
    NSLog(@"%@", tx);
    if (!([tx isKindOfClass:[NSNull class]] || tx.length==0)) {
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", tx]];
        //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
        if (image) {
            noticeMessage_tx.image = image;
        }else{
            //下载头像
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", USERTXURL, tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    noticeMessage_tx.image = load.dataImage;
                    NSString * docDir = DOCDIR;
                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", tx]];
                    [load.data writeToFile:txFilePath atomically:YES];
                }else{
                    NSLog(@"头像下载失败");
                }
            }];
            [request release];
        }
    }
    if ([newMsgNum intValue]) {
        tips.hidden = NO;
        tipsLabel.text = newMsgNum;
    }
}

//-(void)configUIWithDict:(NSDictionary *)dic
//{
//    tips.hidden = YES;
//    
//    NSArray * array = [dic objectForKey:@"data"];
//    NSDictionary * dict = array[array.count-1];
//    desLabel.text = [dict objectForKey:@"msg"];
//    //
//    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"time"] intValue]];
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    noticeMessage_time.text = [formatter stringFromDate:date];
//    [formatter release];
//    //名字和头像
//    NSString * code = [NSString stringWithFormat:@"usr_id=%@dog&cat", [dic objectForKey:@"usr_id"]];
//    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERINFOAPI, [dic objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
////    NSLog(@"url--%@", url);
//    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            NSLog(@"usrdataDict:%@", load.dataDict);
//            NSDictionary * dict1 = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
//            noticeMessage_name.text = [dict1 objectForKey:@"name"];
//            //下载头像
//            /**************************/
//            if (!([[dict1 objectForKey:@"tx"] isKindOfClass:[NSNull class]] || [[dict1 objectForKey:@"tx"] length]==0)) {
//                NSString * docDir = DOCDIR;
//                NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [dict1 objectForKey:@"tx"]]];
//                //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
//                UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
//                if (image) {
//                    noticeMessage_tx.image = image;
//                }else{
//                    //下载头像
//                    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", USERTXURL, [dict1 objectForKey:@"tx"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//                        if (isFinish) {
//                            noticeMessage_tx.image = load.dataImage;
//                            NSString * docDir = DOCDIR;
//                            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [dict1 objectForKey:@"tx"]]];
//                            [load.data writeToFile:txFilePath atomically:YES];
//                        }else{
//                            NSLog(@"头像下载失败");
//                        }
//                    }];
//                    [request release];
//                }
//            }
//            /**************************/
//        }else{
//            
//        }
//    }];
//    [request release];
//}
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
