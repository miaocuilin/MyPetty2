//
//  SearchCell.m
//  MyPetty
//
//  Created by zhangjr on 14-9-13.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "SearchCell.h"
#import "PetInfoModel.h"
@implementation SearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}
- (void)makeUI
{
    UIView * headerBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 70)];
    //    headerBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:headerBgView];
    headImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 10, 50, 50) ImageName:@"defaultPetHead.png"];
    headImageView.layer.cornerRadius = headImageView.frame.size.width/2;
    headImageView.layer.masksToBounds = YES;
    [headerBgView addSubview:headImageView];
    /**************************/
    //    NSLog(@"--%@", model.tx);
        /**************************/
    
    
    sex = [MyControl createImageViewWithFrame:CGRectMake(80, 10, 34/2, 34/2) ImageName:@"man.png"];
    [headerBgView addSubview:sex];
    name = [MyControl createLabelWithFrame:CGRectMake(100, 10, 150, 20) Font:15 Text:@"毛毛"];
    name.textColor = BGCOLOR;
    [headerBgView addSubview:name];
    
    nameAndAgeLabel = [MyControl createLabelWithFrame:CGRectMake(80, 30, 150, 15) Font:13 Text:@"索马利猫 | 3岁"];
    nameAndAgeLabel.textColor = [UIColor blackColor];
    
    [headerBgView addSubview:nameAndAgeLabel];
    
    rq = [MyControl createLabelWithFrame:CGRectMake(80, 52, 70, 15) Font:12 Text:@"总人气 500"];
    rq.textColor = [UIColor lightGrayColor];
    [headerBgView addSubview:rq];
    
    memberNum = [MyControl createLabelWithFrame:CGRectMake(155, 52, 70, 15) Font:12 Text:@"|    成员 188"];
    
    memberNum.textColor = [UIColor lightGrayColor];
    [headerBgView addSubview:memberNum];
    
//    UIView * whiteLine = [MyControl createViewWithFrame:CGRectMake(80, 69, 320-80, 1)];
//    whiteLine.backgroundColor = [UIColor whiteColor];
//    [headerBgView addSubview:whiteLine];
}
- (void)configUI:(PetInfoModel *)model
{
    headImageView.image = [UIImage imageNamed:@"defaultPetHead.png"];
    
    if (!([model.tx isKindOfClass:[NSNull class]] || [model.tx length]==0)) {
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
        //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
        if (image) {
            headImageView.image = image;
        }else{
            //下载头像
            NSLog(@"%@", [NSString stringWithFormat:@"%@%@", PETTXURL, model.tx]);
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, model.tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    headImageView.image = load.dataImage;
                    NSString * docDir = DOCDIR;
                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
                    [load.data writeToFile:txFilePath atomically:YES];
                }else{
                    NSLog(@"头像下载失败");
                }
            }];
            [request release];
        }
    }
    

    if ([model.gender intValue] == 2) {
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    name.text = model.name;
    nameAndAgeLabel.text = [NSString stringWithFormat:@"%@ | %@", [ControllerManager returnCateNameWithType:model.type], [MyControl returnAgeStringWithCountOfMonth:model.age]];
    rq.text = [NSString stringWithFormat:@"总人气 %@", model.t_rq];
    memberNum.text = [NSString stringWithFormat:@"|    成员 %@", model.fans];

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
