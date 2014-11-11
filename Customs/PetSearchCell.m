//
//  PetSearchCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetSearchCell.h"

@implementation PetSearchCell

- (void)awakeFromNib {
    // Initialization code
    [self makeUI];
}
-(void)makeUI
{
    self.nameLabel.textColor = BGCOLOR;
    self.cateAndAgeLabel.textColor = [UIColor blackColor];
    
    self.headImage.layer.cornerRadius = 25;
    self.headImage.layer.masksToBounds = YES;
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(self.cateAndAgeLabel.frame.origin.x, 69, self.frame.size.width-self.cateAndAgeLabel.frame.origin.x-15, 1)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
}
-(void)configUI:(SearchResultModel *)model
{
    if ([model.gender intValue] == 1) {
        self.sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        self.sex.image = [UIImage imageNamed:@"woman.png"];
    }
    
    self.nameLabel.text = model.name;
    self.cateAndAgeLabel.text = [NSString stringWithFormat:@"%@ | %@", [ControllerManager returnCateNameWithType:model.type], [MyControl returnAgeStringWithCountOfMonth:model.age]];
    
    self.headImage.image = [UIImage imageNamed:@"defaultPetHead.png"];
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

//                    NSString * docDir = DOCDIR;
//                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
                    [load.data writeToFile:txFilePath atomically:YES];
                }else{
                    NSLog(@"头像下载失败");
                }
            }];
            [request release];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headImage release];
    [_sex release];
    [_nameLabel release];
    [_cateAndAgeLabel release];
    [super dealloc];
}
@end
