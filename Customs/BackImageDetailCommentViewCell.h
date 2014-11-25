//
//  BackImageDetailCommentViewCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/23.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
@interface BackImageDetailCommentViewCell : UITableViewCell
{
    UIImageView * headImageView;
    UILabel * name;
    
    UILabel * desLabel;
    UILabel * time;
    
    UIView * line;
}

-(void)configUIWithName:(NSString *)nameStr Cmt:(NSString *)cmt Time:(NSString *)timeStr CellHeight:(float)cellHeight textSize:(CGSize)textSize Tx:(NSString *)tx;
@end
