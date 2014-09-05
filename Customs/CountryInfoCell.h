//
//  CountryInfoCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-12.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPetListModel.h"
@class CountryInfoCell;

@protocol CountryInfoCellDelegate <NSObject>

-(void)swipeTableViewCell:(CountryInfoCell *)cell didClickButtonWithIndex:(NSInteger)index;

@end

@interface CountryInfoCell : UITableViewCell
{
    
}
@property (nonatomic,assign)id <CountryInfoCellDelegate>delegate;

@property (retain, nonatomic) IBOutlet UIImageView *headImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *expBgImageView;
@property (retain, nonatomic) IBOutlet UILabel *expLabel;
@property (retain, nonatomic) IBOutlet UIView *buttonBgView;
@property (retain, nonatomic) IBOutlet UIButton *qiutBtn;
@property (retain, nonatomic) IBOutlet UIButton *switchBtn;
@property (retain, nonatomic) IBOutlet UILabel *switchLabel1;
@property (retain, nonatomic) IBOutlet UILabel *switchLabel2;

@property (retain,nonatomic) UIImageView * expImageView;
-(void)modify:(int)row;
-(void)configUI:(UserPetListModel *)model;
@end
