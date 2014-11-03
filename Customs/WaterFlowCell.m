//
//  WaterFlowCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/10/31.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "WaterFlowCell.h"
#import "UIButton+WebCache.h"
#define Margin 4
@implementation WaterFlowCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
//    NSLog(@"%f--%f--%f--%f", self.contentView.frame.size.width, self.frame.size.width, self.contentView.frame.size.height, self.frame.size.height);
//    bgView = [MyControl createViewWithFrame:CGRectMake(Margin, Margin/2, self.contentView.frame.size.width/2-Margin*2, 0)];
//    bgView.layer.borderWidth = 2;
//    bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    bgView.layer.shadowOffset = CGSizeMake(1, 1);
//    bgView.layer.shadowRadius = 5.0;
//    bgView.layer.shadowColor = [UIColor blackColor].CGColor;
//    bgView.layer.shadowOpacity = 0.8;
    bgView = [MyControl createImageViewWithFrame:CGRectMake(Margin, Margin/2, self.contentView.frame.size.width/2-Margin*2, 0) ImageName:@""];
    bgView.image = [[UIImage imageNamed:@"water_cardBg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self.contentView addSubview:bgView];
    
    bigImageBtn = [MyControl createButtonWithFrame:CGRectMake(Margin+2, Margin, bgView.frame.size.width-Margin, 0) ImageName:@"20-1.png" Target:self Action:@selector(bigImageBtnClick) Title:nil];
    [self.contentView addSubview:bigImageBtn];
    
    desLabel = [MyControl createLabelWithFrame:CGRectMake(Margin+2, 0, bgView.frame.size.width-Margin, 0) Font:12 Text:nil];
    desLabel.backgroundColor = [UIColor whiteColor];
    desLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:desLabel];
}
-(void)configUI:(PhotoModel *)model
{
    [bigImageBtn setBackgroundImage:[UIImage imageNamed:@"20-1.png"] forState:UIControlStateNormal];
    
    CGRect rect = bgView.frame;
    rect.size.height = model.height+model.cmtHeight+Margin;
    bgView.frame = rect;
    
    CGRect rect2 = bigImageBtn.frame;
    rect2.size.height = model.height;
    bigImageBtn.frame = rect2;
    
    CGRect rect3 = desLabel.frame;
    rect3.origin.y = rect2.origin.y+rect2.size.height;
    rect3.size.height = model.cmtHeight;
    desLabel.frame = rect3;
//    NSLog(@"%d", model.cmtHeight);
    desLabel.text = model.cmt;
    
//    NSLog(@"%f", self.contentView.frame.size.height);
    
//    [bigImageBtn setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]]];
    NSString * path = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    if (image) {
        [bigImageBtn setBackgroundImage:image forState:UIControlStateNormal];
    }else{
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                [bigImageBtn setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                BOOL a = [load.data writeToFile:path atomically:YES];
                NSLog(@"瀑布流图片存储结果a:%d", a);
            }else{
            
            }
        }];
        [request release];
    }
}
-(void)bigImageBtnClick
{
    NSLog(@"jumpToDetail");
    self.jumpToPicDetail();
}
@end
