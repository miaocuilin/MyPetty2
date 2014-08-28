//
//  topicCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface topicCell : UITableViewCell
{
    UIImageView * flag;
    UILabel * topicName;
}
-(void)modifyWithName:(NSString *)name isActivity:(BOOL)yesOrno;
@end
