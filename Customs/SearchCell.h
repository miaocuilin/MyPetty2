//
//  SearchCell.h
//  MyPetty
//
//  Created by zhangjr on 14-9-13.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PetInfoModel;
@interface SearchCell : UITableViewCell
{
    UIImageView * headImageView;
    UIImageView * sex;
    UILabel * name;
    UILabel * nameAndAgeLabel;
    UILabel * rq;
    UILabel * memberNum;
}
- (void)configUI:(PetInfoModel *)model;
@end
