//
//  JDSideMenuCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-10-9.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "JDSideMenuCell.h"

@implementation JDSideMenuCell

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
    headImageView = [MyControl createImageViewWithFrame:CGRectMake(15, 7, 36, 36) ImageName:@"defaultPetHead.png"];
    headImageView.layer.cornerRadius = 18.0;
    headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:headImageView];
    
    nameLabel = [MyControl createLabelWithFrame:CGRectMake(65, 15, 150, 20) Font:15 Text:nil];
    [self.contentView addSubview:nameLabel];
}
-(void)configUI:(SearchResultModel *)model
{
    headImageView.image = [UIImage imageNamed:@"defaultPetHead.png"];
    nameLabel.text = model.name;
    
    if (![model.tx isKindOfClass:[NSNull class]] && model.tx.length != 0) {
        NSString *headPath = [DOCDIR stringByAppendingString:model.tx];
        UIImage *headImage = [UIImage imageWithContentsOfFile:headPath];
        if (headImage) {
            headImageView.image = headImage;
        }else{
            httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@",PETTXURL,model.tx] Block:^(BOOL isFinish, httpDownloadBlock *load) {
                if (isFinish) {
                    [load.data writeToFile:[DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.tx]] atomically:YES];

                    headImageView.image = load.dataImage;
                }
            }];
            [request release];
        }
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
