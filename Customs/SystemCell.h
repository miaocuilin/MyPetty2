//
//  SystemCell.h
//  MyPetty
//
//  Created by Aidi on 14-7-3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemMessageListModel.h"
@interface SystemCell : UITableViewCell
{
    UIImageView * noticeSystem_tx;
    UILabel * noticeSystem_name;
    UILabel * noticeSystem_action;
    UILabel * noticeSystem_time;
    UILabel *commentLabel;
}
-(void)configUI:(SystemMessageListModel *)model;
@end
