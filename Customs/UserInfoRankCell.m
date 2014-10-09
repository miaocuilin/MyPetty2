//
//  UserInfoRankCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-27.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "UserInfoRankCell.h"

@implementation UserInfoRankCell

- (void)awakeFromNib
{
    // Initialization code
    [self modifyUI];
}
-(void)modifyUI
{
    self.headBtn.layer.cornerRadius = self.headBtn.frame.size.width/2;
    self.headBtn.layer.masksToBounds = YES;
    //
    self.kingName = [MyControl createLabelWithFrame:CGRectMake(85, 10, 40, 20) Font:15 Text:nil];
    self.kingName.textColor = [UIColor blackColor];
    self.kingName.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:self.kingName];
    //
    self.sex = [MyControl createImageViewWithFrame:CGRectMake(125, 10, 17, 17) ImageName:@"man.png"];
    [self.contentView addSubview:self.sex];
    
    //
    self.position = [MyControl createLabelWithFrame:CGRectMake(85, 45, 40, 20) Font:15 Text:nil];
    self.position.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.position];
    //
    self.userName = [MyControl createLabelWithFrame:CGRectMake(125, 45, 100, 20) Font:15 Text:nil];
    self.userName.textColor = BGCOLOR;
    [self.contentView addSubview:self.userName];
    //
    self.rankNum.textColor = BGCOLOR;
    
    //
    UIView * line = [MyControl createViewWithFrame:CGRectMake(0, self.contentView.frame.size.height-1, self.contentView.frame.size.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    //
    [self.contentView bringSubviewToFront:self.gotoKing];
    [self.contentView bringSubviewToFront:self.gotoOwner];
}
- (IBAction)headBtnClick:(UIButton *)sender {
    NSLog(@"跳转王国页面");
}
- (IBAction)gotoKingClick:(UIButton *)sender {
    NSLog(@"跳转王国页面");
}
- (IBAction)gotoOwnerClick:(UIButton *)sender {
    NSLog(@"跳转主人页面");
}

-(void)configUI:(PetInfoModel *)model
{
    //
    [self.headBtn setBackgroundImage:[UIImage imageNamed:@"defaultPetHead.png"] forState:UIControlStateNormal];
    /**************************/
    if (!([model.tx isKindOfClass:[NSNull class]] || model.tx.length == 0)) {
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
        //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
        if (image) {
            [self.headBtn setBackgroundImage:image forState:UIControlStateNormal];
        }else{
            //下载头像
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, model.tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    [self.headBtn setBackgroundImage:load.dataImage forState:UIControlStateNormal];
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
    
    //
    self.kingName.text = model.name;
    CGSize size = [model.name sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    CGRect rect = self.kingName.frame;
    rect.size.width = size.width;
    self.kingName.frame = rect;
    
    //
    if ([model.gender intValue] == 2) {
        self.sex.image = [UIImage imageNamed:@"woman.png"];
    }
    CGRect rect2 = self.sex.frame;
    rect2.origin.x = rect.origin.x+rect.size.width;
    self.sex.frame = rect2;
    
    //
    self.cateNameAndAge.text = [NSString stringWithFormat:@"%@ | %@岁", [ControllerManager returnCateNameWithType:model.type], model.age];
    
    //
    NSString * str = [NSString stringWithFormat:@"%@ — ", [ControllerManager returnPositionWithRank:model.u_rank]];
    CGSize size2 = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    CGRect rect3 = self.position.frame;
    rect3.size.width = size2.width;
    self.position.frame = rect3;
    self.position.text = str;
    
    //
    CGRect rect4 = self.userName.frame;
    rect4.origin.x = rect3.origin.x+size2.width;
    self.userName.frame = rect4;
    self.userName.text = model.u_name;
    
    //
    self.rankNum.text = model.t_rq;
    
    //
//    if ([model.type intValue]/100 == 1) {
        self.planet.text = @"联萌人气";
//    }else{
//        self.position.text = [NSString stringWithFormat:@"%@ — ", @"族长"];
//        self.planet.text = @"家族人气";
//    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headBtn release];
    [_kingName release];
    [_sex release];
    [_cateNameAndAge release];
    [_position release];
    [_userName release];
    [_rankNum release];
    [_planet release];
    [_gotoKing release];
    [_gotoOwner release];
    [super dealloc];
}
@end
