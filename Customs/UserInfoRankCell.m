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
    self.sex = [MyControl createImageViewWithFrame:CGRectMake(125, 10, 14, 17) ImageName:@"man.png"];
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

-(void)modifyWithName:(NSString *)name sex:(int)sex cate:(NSString *)cate age:(NSString *)age position:(NSString *)position userName:(NSString *)userName rank:(NSString *)rank
{
    //
    [self.headBtn setBackgroundImage:[UIImage imageNamed:@"cat2.jpg"] forState:UIControlStateNormal];
    
    //
    self.kingName.text = name;
    CGSize size = [name sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    CGRect rect = self.kingName.frame;
    rect.size.width = size.width;
    self.kingName.frame = rect;
    
    //
    if (sex == 2) {
        self.sex.image = [UIImage imageNamed:@"woman.png"];
    }
    CGRect rect2 = self.sex.frame;
    rect2.origin.x = rect.origin.x+rect.size.width;
    self.sex.frame = rect2;
    
    //
    if ([cate intValue]/100 == 1) {
        cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"1"] objectForKey:cate];
    }else if([cate intValue]/100 == 2){
        cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"2"] objectForKey:cate];
    }else if([cate intValue]/100 == 3){
        cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"3"] objectForKey:cate];
    }else{
        cateName = @"苏格兰折耳猫";
    }
    self.cateNameAndAge.text = [NSString stringWithFormat:@"%@ | %@岁", cateName, age];
    
    //
    NSString * str = [NSString stringWithFormat:@"%@ — ", position];
    CGSize size2 = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    CGRect rect3 = self.position.frame;
    rect3.size.width = size2.width;
    self.position.frame = rect3;
    self.position.text = str;
    
    //
    CGRect rect4 = self.userName.frame;
    rect4.origin.x = rect3.origin.x+size2.width;
    self.userName.frame = rect4;
    self.userName.text = userName;
    
    //
    self.rankNum.text = rank;
    
    //
    self.planet.text = @"喵星排名";
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
