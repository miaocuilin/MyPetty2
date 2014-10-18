//
//  NoticeCell.h
//  MyPetty
//
//  Created by Aidi on 14-7-3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemMessageListModel.h"
@interface NoticeCell : UITableViewCell
{
    UIImageView *noticeMessage_tx;
    UILabel *noticeMessage_name;
    UILabel * noticeMessage_time;
    UILabel * desLabel;
    UIView * tips;
    UILabel * tipsLabel;
}
//-(void)configUI:(SystemMessageListModel *)model;
//-(void)configUIWithDict:(NSDictionary *)dic;
-(void)configUIWithTx:(NSString *)tx Name:(NSString *)name Time:(NSString *)time Content:(NSString *)content newMsgNum:(NSString *)newMsgNum img_id:(NSString *)img_id;
@end
