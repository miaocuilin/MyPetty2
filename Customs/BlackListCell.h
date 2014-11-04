//
//  BlackListCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"
@interface BlackListCell : UITableViewCell
{
    UIImageView * headImage;
    UILabel * name;
    UIButton * cancelBtn;
}
@property(nonatomic,copy)NSString * usr_id;
@property(nonatomic,copy)void (^deleteBlack)(void);
-(void)configUIWithModel:(InfoModel *)model;
@end
