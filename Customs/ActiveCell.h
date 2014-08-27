//
//  ActiveCell.h
//  MyPetty
//
//  Created by Aidi on 14-6-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicListModel.h"
@interface ActiveCell : UITableViewCell
{
    UIImageView * imageView;
    UIImageView * statusImageView;
    UILabel * titleLabel;
}
-(void)configUI:(TopicListModel *)model;
@end
