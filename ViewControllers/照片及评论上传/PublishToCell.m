//
//  PublishToCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/8.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PublishToCell.h"

@implementation PublishToCell

- (void)awakeFromNib {
    // Initialization code
    [self modifyUI];
}
-(void)modifyUI
{
    self.headImage.layer.cornerRadius = 25;
    self.headImage.layer.masksToBounds = YES;
    
    self.name.textColor = ORANGE;
    self.cateAndAge.textColor = [UIColor grayColor];
    
    self.selectBtn = [MyControl createButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-15-20, 25, 20, 20) ImageName:@"atUsers_unSelected.png" Target:self Action:@selector(selectBtnClick:) Title:nil];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"atUsers_selected.png"] forState:UIControlStateSelected];
    [self addSubview:self.selectBtn];
    
    UIView * line = [MyControl createViewWithFrame:CGRectMake(0, 69, [UIScreen mainScreen].bounds.size.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
}
-(void)configUI:(UserPetListModel *)model Index:(int)index BtnSelected:(BOOL)select
{
    [self.headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PETTXURL, model.tx]] placeholderImage:[UIImage imageNamed:@"defaultPetHead.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            [self.headImage setImage:[MyControl returnSquareImageWithImage:image]];
        }
    }];
    if ([model.gender intValue] == 1) {
        self.sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        self.sex.image = [UIImage imageNamed:@"woman.png"];
    }
    self.name.text = model.name;
    self.cateAndAge.text = [NSString stringWithFormat:@"%@ | %@", [ControllerManager returnCateNameWithType:model.type], [MyControl returnAgeStringWithCountOfMonth:model.age]];
    if ([[USER objectForKey:@"aid"] isEqualToString:model.aid]) {
        self.crown.hidden = NO;
    }else{
        self.crown.hidden = YES;
    }
    
    a = index;
    
    if (select) {
        self.selectBtn.selected = YES;
    }else{
        self.selectBtn.selected = NO;
    }
}
- (void)selectBtnClick:(UIButton *)sender {
//    sender.selected = !sender.selected;
    if (!sender.selected) {
        sender.selected = !sender.selected;
        self.selectBlock(a);
    }
//    else{
//        self.unSelectBlock(a);
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headImage release];
    [_crown release];
    [_sex release];
    [_name release];
    [_cateAndAge release];
    [_selectBtn release];
    [super dealloc];
}
@end
