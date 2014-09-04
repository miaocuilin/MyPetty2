//
//  MyCountryContributeCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-26.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryMembersModel.h"
@interface MyCountryContributeCell : UITableViewCell
{
    UIImageView * sex;
}
@property (retain, nonatomic) IBOutlet UIImageView *circleBg;
@property (retain, nonatomic) IBOutlet UIButton *headBtn;
@property (retain, nonatomic) IBOutlet UILabel *positionLabel;
@property (retain, nonatomic) IBOutlet UILabel *location;
@property (retain, nonatomic) IBOutlet UIImageView *sex;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *contribution;

-(void)modifyWithBOOL:(BOOL)isThis lineNum:(int)num;
-(void)configUI:(CountryMembersModel *)model;

@end
