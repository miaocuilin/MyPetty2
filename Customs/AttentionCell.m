//
//  AttentionCell.m
//  MyPetty
//
//  Created by Aidi on 14-5-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "AttentionCell.h"

@implementation AttentionCell 

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
    headImageBtn = [MyControl createButtonWithFrame:CGRectMake(15, 15, 40, 40) ImageName:@"defaultPetHead.png" Target:self Action:@selector(headImageBtnClick) Title:nil];
    headImageBtn.layer.cornerRadius = 20;
    headImageBtn.layer.masksToBounds = YES;
    [self.contentView addSubview:headImageBtn];
    
    sexImageView = [MyControl createImageViewWithFrame:CGRectMake(65, 15, 14, 17) ImageName:@"man.png"];
    [self.contentView addSubview:sexImageView];
    
    nameLabel = [MyControl createLabelWithFrame:CGRectMake(80, 15, 150, 20) Font:16 Text:nil];
    nameLabel.textColor = BGCOLOR;
//    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:nameLabel];
    
    cateAndNameLabel = [MyControl createLabelWithFrame:CGRectMake(65, 35, 200, 20) Font:14 Text:nil];
    cateAndNameLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:cateAndNameLabel];
    
    UIView * line = [MyControl createViewWithFrame:CGRectMake(0, 64, self.contentView.frame.size.width, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:line];
    
    attentionBtn = [MyControl createButtonWithFrame:CGRectMake(510/2, 18, 50, 29) ImageName:@"addAttention.png" Target:self Action:@selector(attentionBtnClick:) Title:nil];
    [attentionBtn setBackgroundImage:[UIImage imageNamed:@"didAttention.png"] forState:UIControlStateSelected];
    [self.contentView addSubview:attentionBtn];
}

-(void)configUI:(PetInfoModel *)model
{
    attentionBtn.selected = NO;
    self.aid = model.aid;
    if ([model.is_follow intValue] == 1) {
        attentionBtn.selected = YES;
    }
    
    if (!([model.tx isKindOfClass:[NSNull class]] || [model.tx length] == 0)) {
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txFilePath]];
        if (image) {
            [headImageBtn setBackgroundImage:image forState:UIControlStateNormal];
        }else{
            [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, model.tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    //本地目录，用于存放favorite下载的原图
                    NSString * docDir = DOCDIR;
                    if (!docDir) {
                        NSLog(@"Documents 目录未找到");
                    }else{
                        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
                        //将下载的图片存放到本地
                        [load.data writeToFile:txFilePath atomically:YES];
                        [headImageBtn setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                    }
                }else{
                }
            }];
        }
    }
    
    
    if ([model.gender intValue] == 2) {
        sexImageView.image = [UIImage imageNamed:@"woman.png"];
    }
    
    nameLabel.text = model.name;
    
    cateAndNameLabel.text = [NSString stringWithFormat:@"%@ | %@", [ControllerManager returnCateNameWithType:model.type], [MyControl returnAgeStringWithCountOfMonth:model.age]];
}

-(void)headImageBtnClick
{
    self.jumpToPetInfo(self.aid);
}
-(void)attentionBtnClick:(UIButton *)btn
{
    if (!btn.selected) {
        NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", self.aid];
        NSString * sig = [MyMD5 md5:code];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", FOLLOWAPI, self.aid, sig, [ControllerManager getSID]];
        NSLog(@"url:%@", url);
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
        [MMProgressHUD showWithStatus:@"关注中..."];
        [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"%@", load.dataDict);
                [MMProgressHUD dismissWithSuccess:@"关注成功" title:nil afterDelay:1];
                btn.selected = YES;
            }else{
                LoadingFailed;
            }
        }];
    }else{
        NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", self.aid];
        NSString * sig = [MyMD5 md5:code];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", UNFOLLOWAPI, self.aid, sig, [ControllerManager getSID]];
        NSLog(@"unfollowApiurl:%@", url);
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
        [MMProgressHUD showWithStatus:@"取消关注中..."];
        [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"%@", load.dataDict);
                [MMProgressHUD dismissWithSuccess:@"取消关注成功" title:nil afterDelay:1];
                btn.selected = NO;
            }else{
                LoadingFailed;
//                [MMProgressHUD dismissWithError:@"取消关注失败" afterDelay:1];
            }
        }];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
