//
//  ArticleCell.h
//  MyPetty
//
//  Created by miaocuilin on 15/3/23.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"

@interface ArticleCell : UITableViewCell

-(void)modifyUI:(ArticleModel *)model;
@end
