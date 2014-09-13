//
//  MassWatchCell.m
//  MyPetty
//
//  Created by zhangjr on 14-8-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MassWatchCell.h"

@implementation MassWatchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.selected
//        self.contentView.backgroundColor = [UIColor clearColor];
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    self.headButton = [MyControl createButtonWithFrame:CGRectMake(15, 10, 50, 50) ImageName:@"defaultUserHead.png" Target:self Action:@selector(otherHome:) Title:nil];
    self.headButton.layer.masksToBounds = YES;
    self.headButton.layer.cornerRadius = 25;
    [self.contentView addSubview:self.headButton];
    
    
//    UIView *giftBG = [MyControl createViewWithFrame:CGRectMake(50, 35, 24, 24)];
////    [[UIView alloc] initWithFrame:CGRectMake(50, 35, 24, 24)];
//    giftBG.layer.cornerRadius = 12;
//    giftBG.layer.masksToBounds = YES;
//    giftBG.backgroundColor = BGCOLOR2;
//    [cellBody addSubview:giftBG];
//    [giftBG release];
    
    self.giftView = [MyControl createImageViewWithFrame:CGRectMake(50, 37, 24, 24) ImageName:@"zan_gift.png"];
    [self.contentView addSubview:self.giftView];
    
    self.sexView = [MyControl createImageViewWithFrame:CGRectMake(80, 15, 14, 17) ImageName:@"man.png"];
    [self.contentView addSubview:self.sexView];
    
    self.watcherName = [MyControl createLabelWithFrame:CGRectMake(103, 15, 100, 20) Font:16 Text:@"羊驼"];
    self.watcherName.textColor = BGCOLOR;
    [self.contentView addSubview:self.watcherName];
    
    self.ProvinceAndCity = [MyControl createLabelWithFrame:CGRectMake(80, 40, 120, 20) Font:14 Text:[NSString stringWithFormat:@"%@ | %@",@"北京市",@"朝阳区"]];
    self.ProvinceAndCity.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.ProvinceAndCity];
    
    
    UIImageView * mailBgView = [MyControl createImageViewWithFrame:CGRectMake(523/2, 23, 50, 30) ImageName:@"greenBtnBg.png"];
    [self.contentView addSubview:mailBgView];
    
//    UIView *mailView = [MyControl createViewWithFrame:CGRectMake(250, 23, 50, 30)];
//    mailView.backgroundColor = [UIColor colorWithRed:147/255.0 green:204/255.0 blue:172/255.0 alpha:1];
//    mailView.layer.cornerRadius = 5;
//    mailView.layer.masksToBounds = YES;
//    [self.contentView addSubview:mailView];
    
    UIImageView * mail = [MyControl createImageViewWithFrame:CGRectMake(12, 5, 26, 18) ImageName:@"mail.png"];
    [mailBgView addSubview:mail];
    
    talkButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 50, 30) ImageName:@"" Target:self Action:@selector(TalkAction:) Title:nil];
    talkButton.showsTouchWhenHighlighted = YES;
    [mailBgView addSubview:talkButton];

    UIView * line = [MyControl createViewWithFrame:CGRectMake(0, 69, 320, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:line];
}
-(void)configUI:(UserInfoModel *)model
{
    self.usr_id = model.usr_id;
    
    if ([model.gender intValue] == 2) {
        self.sexView.image = [UIImage imageNamed:@"woman.png"];
    }
    self.watcherName.text = model.name;
    self.ProvinceAndCity.text = [ControllerManager returnProvinceAndCityWithCityNum:model.city];
    if ([self.txType isEqualToString:@"liker"]) {
        if (self.isMi) {
            self.giftView.image = [UIImage imageNamed:@"zan_fish.png"];
        }else{
            self.giftView.image = [UIImage imageNamed:@"zan_bone.png"];
        }
    }
    
    if (!([model.tx isKindOfClass:[NSNull class]] || model.tx.length==0)) {
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
        //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
        if (image) {
            [self.headButton setBackgroundImage:image forState:UIControlStateNormal];
        }else{
            //下载头像
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", USERTXURL, model.tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    [self.headButton setBackgroundImage:load.dataImage forState:UIControlStateNormal];
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
}
- (void)otherHome:(UIButton *)sender
{
    NSLog(@"跳转到其他人的主页");
    self.jumpToUserInfo(self.headButton.currentBackgroundImage, self.usr_id);
}

- (void)TalkAction:(UIButton *)sender
{
    NSLog(@"跳转到聊天");
    if ([self.usr_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
        StartLoading;
        [MMProgressHUD dismissWithError:@"不能给自己发消息- -" afterDelay:1];
        return;
    }
    self.cellClick(self.num);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
- (void)dealloc
{
    [super dealloc];
}

@end
