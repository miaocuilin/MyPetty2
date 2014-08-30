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
    headImageView = [MyControl createImageViewWithFrame:CGRectMake(10, 15, 40, 40) ImageName:@"13-1.png"];
    headImageView.layer.cornerRadius = 20;
    headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:headImageView];
    
    sexImageView = [MyControl createImageViewWithFrame:CGRectMake(55, 12, 25, 25) ImageName:@""];
    [self.contentView addSubview:sexImageView];
    
    nameLabel = [MyControl createLabelWithFrame:CGRectMake(80, 15, 150, 20) Font:17 Text:nil];
    nameLabel.textColor = BGCOLOR;
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:nameLabel];
    
    cateAndNameLabel = [MyControl createLabelWithFrame:CGRectMake(55, 40, 200, 20) Font:15 Text:nil];
    cateAndNameLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:cateAndNameLabel];
     
}

-(void)configUI:(InfoModel *)model
{
    
//    [headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TXURL, model.tx]] placeholderImage:[UIImage imageNamed:@"13-1.png"]];
    NSString * docDir = DOCDIR;
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
            }
        }];
    }
    
    if ([model.gender intValue] == 2) {
        sexImageView.image = [UIImage imageNamed:@"3-4.png"];
    }else{
        sexImageView.image = [UIImage imageNamed:@"3-6.png"];
    }
    nameLabel.text = model.name;
    
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
                cateAndNameLabel.text = [NSString stringWithFormat:@"%@ | %@岁", cateName, model.age];
            }
        }];
        
    }else{
        cateAndNameLabel.text = [NSString stringWithFormat:@"%@ | %@岁", cateName, model.age];
    }
//    cateAndNameLabel.text = [NSString stringWithFormat:@"西伯利亚森林猫 | %@岁", model.age];
//    attentionButton.selected = arc4random()%2;
//    self.usr_id = model.usr_id;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
