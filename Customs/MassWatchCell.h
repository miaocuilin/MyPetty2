//
//  MassWatchCell.h
//  MyPetty
//
//  Created by zhangjr on 14-8-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@interface MassWatchCell : UITableViewCell
{
    UIButton *talkButton;
}
@property(nonatomic,strong)UIButton *headButton;
@property(nonatomic,strong)UIImageView *giftView;
@property(nonatomic,strong)UIImageView *sexView;
@property(nonatomic,strong)UILabel *watcherName;
@property(nonatomic,strong)UILabel *ProvinceAndCity;
@property(nonatomic,strong)NSString *Province;
@property(nonatomic,strong)NSString *city;

//
@property(nonatomic)BOOL isMi;
@property(nonatomic,copy)NSString * txType;
-(void)configUI:(UserInfoModel *)model;
@end
