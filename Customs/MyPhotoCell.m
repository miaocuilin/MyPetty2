//
//  MyPhotoCell.m
//  MyPetty
//
//  Created by Aidi on 14-6-19.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MyPhotoCell.h"

@implementation MyPhotoCell

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
    self.bigImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, 200) ImageName:nil];
//    self.bigImageView.center = CGPointMake(320/2, 100);
    [self.contentView addSubview:self.bigImageView];
    
    //点赞
    UIImageView * zanBgView = [MyControl createImageViewWithFrame:CGRectMake(10, 170, 50, 20) ImageName:@"zanBg.png"];
    [self.bigImageView addSubview:zanBgView];
    
    zanLabel = [MyControl createLabelWithFrame:CGRectMake(20-3, 0, 30, 20) Font:12 Text:nil];
    zanLabel.textAlignment = NSTextAlignmentRight;
    [zanBgView addSubview:zanLabel];
    
    fish = [MyControl createImageViewWithFrame:CGRectMake(0, 4, 30, 12) ImageName:@"fish.png"];
    [zanBgView addSubview:fish];
    
    UIButton * zanBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 50, 20) ImageName:@"" Target:self Action:@selector(zanBtnClick:) Title:nil];
    [zanBgView addSubview:zanBtn];
//    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(10, 160, 65, 30)];
//    bgView.alpha = 0.5;
//    bgView.layer.cornerRadius = 5;
//    bgView.layer.masksToBounds = YES;
//    bgView.backgroundColor = [UIColor blackColor];
//    [self.contentView addSubview:bgView];
//    
//    numLabel = [MyControl createLabelWithFrame:CGRectMake(20, 0, 40, 30) Font:15 Text:nil];
//    numLabel.textAlignment = NSTextAlignmentCenter;
//    numLabel.font = [UIFont boldSystemFontOfSize:15];
//    [bgView addSubview:numLabel];
//    
//    heart = [MyControl createImageViewWithFrame:CGRectMake(5, 5, 20, 20) ImageName:@"11-1.png"];
//    [bgView addSubview:heart];
//    
//    heartButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 65, 30) ImageName:@"" Target:self Action:@selector(heartButtonClick:) Title:nil];
//    
//    [bgView addSubview:heartButton];
    
    timeLabel = [MyControl createLabelWithFrame:CGRectMake(320-100-10, 200, 100, 30) Font:14 Text:nil];
//    timeLabel.font = [UIFont boldSystemFontOfSize:15];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    
//    UIImageView * line = [MyControl createImageViewWithFrame:CGRectMake(0, 230, 320, 1) ImageName:@"20-灰色线.png"];
//    [self.contentView addSubview:line];
}
-(void)configUI:(PhotoModel *)model
{
    if (![model.likers isKindOfClass:[NSNull class]]) {
        self.likersArray = [model.likers componentsSeparatedByString:@","];
        for(NSString * str in self.likersArray){
            if ([str isEqualToString:[USER objectForKey:@"usr_id"]]) {
                isLike = YES;
                heartButton.selected = YES;
                heart.image = [UIImage imageNamed:@"11-2.png"];
            }
        }
    }
    self.img_id = model.img_id;
//    numLabel.text = [NSString stringWithFormat:@"%@", model.likes];
    zanLabel.text = [NSString stringWithFormat:@"%@", model.likes];
    
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
}
-(void)zanBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSString * code = [NSString stringWithFormat:@"img_id=%@dog&cat", self.img_id];
    NSString * sig = [MyMD5 md5:code];
    if (btn.selected) {
        //赞
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", LIKEAPI, self.img_id, sig, [ControllerManager getSID]];
        NSLog(@"likeURL:%@", url);
        
        [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                if (![[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"点赞失败 = =."];
                    fish.image = [UIImage imageNamed:@"fish1.png"];
                    zanLabel.text = [NSString stringWithFormat:@"%d", [zanLabel.text intValue]+1];
                    [UIView animateWithDuration:0.5 animations:^{
                        fish.frame = CGRectMake(0-15, 4-12, 30*2, 12*2);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 animations:^{
                            fish.frame = CGRectMake(0, 4, 30, 12);
                        }];
                    }];
                }
            }else{
                NSLog(@"数据请求失败");
            }
        }];
        
        
    }else{
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", UNLIKEAPI, self.img_id,sig, [ControllerManager getSID]];
        NSLog(@"UNlikeURL:%@", url);
        
        [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                if (![[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消赞失败 = =."];
                    fish.image = [UIImage imageNamed:@"fish.png"];
                    zanLabel.text = [NSString stringWithFormat:@"%d", [zanLabel.text intValue]-1];
                }
            }else{
                NSLog(@"数据请求失败");
            }
            //            button.userInteractionEnabled = YES;
            //            self.contentView.userInteractionEnabled = YES;
        }];

        
    }
}
-(void)heartButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
//    button.userInteractionEnabled = NO;
//    self.contentView.userInteractionEnabled = NO;
//    self.contentView
    
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
                }
            }else{
                NSLog(@"数据请求失败");
            }
//            button.userInteractionEnabled = YES;
//            self.contentView.userInteractionEnabled = YES;
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
