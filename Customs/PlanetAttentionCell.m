//
//  PlanetAttentionCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-9-10.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PlanetAttentionCell.h"
//#import "PicDetailViewController.h"
@implementation PlanetAttentionCell

- (void)awakeFromNib
{
    // Initialization code
    [self modifyUI];
}
-(void)modifyUI
{
    self.headImage.layer.cornerRadius = self.headImage.frame.size.width/2;
    self.headImage.layer.masksToBounds = YES;
    
    self.nameLabel.textColor = BGCOLOR;
    self.cateNameLabel.textColor = [UIColor grayColor];
    self.timeLabel.textColor = [UIColor grayColor];
    [self.bigImageBtn setBackgroundImage:[UIImage imageNamed:@"20-1.png"] forState:UIControlStateNormal];
    
    headBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 150, 50) ImageName:@"" Target:self Action:@selector(headBtnClick) Title:nil];
    [self.contentView addSubview:headBtn];
}
-(void)configUI:(PhotoModel *)model
{
    self.nameLabel.text = model.name;
    img_id = model.img_id;
    
    self.cateNameLabel.text = [ControllerManager returnCateNameWithType:model.type];
    self.timeLabel.text = [MyControl timeFromTimeStamp:model.create_time];
    CGSize size = [model.cmt sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(300, 60) lineBreakMode:1];
    CGRect rect = self.commentLabel.frame;
    rect.size.height = size.height;
    self.commentLabel.frame = rect;

    /***********宠物头像***************/
    if (!([model.tx isKindOfClass:[NSNull class]] || [model.tx length]==0)) {
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
        //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
        if (image) {
            self.headImage.image = image;
        }else{
            //下载头像
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, model.tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    self.headImage.image = load.dataImage;
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
    /***********大图***************/
    //本地目录，用于存放下载的原图
    NSString * docDir = DOCDIR;
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }else{
        NSString * filePath2 = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_small.png", model.url]];
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath2]];
        if (image) {
            [self.bigImageBtn setBackgroundImage:image forState:UIControlStateNormal];
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
                        
                        float width = load.dataImage.size.width;
                        float height = load.dataImage.size.height;

                        if (width<320) {
                            height = (320.0/width)*height;
                            width = 320;
                        }
                        //                                NSLog(@"%f--%f", width, height);
                        if (height<200) {
                            width = (200.0/height)*width;
                            height = 200;
                        }
                        UIImage * image = nil;
                        //                                NSLog(@"%f--%f", width, height);
                        //改变照片大小
                        image = [load.dataImage imageByScalingToSize:CGSizeMake(width, height)];
                        //                                NSLog(@"%f--%f", image.size.width, image.size.height);
                        //                                if (image.size.height>200) {
                        image = [MyControl imageFromImage:image inRect:CGRectMake(width/2-160, height/2-100, 320, 200)];
                        //                                }
                        //                                NSLog(@"%f--%f", image.size.width, image.size.height);
                        
                        [self.bigImageBtn setBackgroundImage:image forState:UIControlStateNormal];
                        
                        NSData * smallImageData = UIImagePNGRepresentation(image);
                        [smallImageData writeToFile:filePath2 atomically:YES];
                    }
                }else{
                    
                }
            }];
        }
    }
}
- (IBAction)bigImageBtnClick:(UIButton *)sender {
    //跳转照片详情页
    NSLog(@"跳转照片详情页");
    self.jumpToDetail(img_id);
}
-(void)headBtnClick
{
    self.jumpToPetInfo(aid);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headImage release];
    [_nameLabel release];
    [_cateNameLabel release];
    [_timeLabel release];
    [_bigImageBtn release];
    [_commentLabel release];
    [super dealloc];
}
@end
