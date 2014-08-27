//
//  AtUsersCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-27.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AtUsersCell : UITableViewCell
{
    UIImageView * head;
    UILabel * nameLabel;
    UIButton * btn;
}
-(void)modifyWith:(NSString *)name row:(int)row;
@end
