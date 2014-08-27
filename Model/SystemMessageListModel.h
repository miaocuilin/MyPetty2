//
//  SystemMessageListModel.h
//  MyPetty
//
//  Created by Aidi on 14-7-9.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMessageListModel : NSObject

@property(nonatomic,copy)NSString * body;
@property(nonatomic,copy)NSString * create_time;
@property(nonatomic,copy)NSString * from_id;
@property(nonatomic,copy)NSString * gender;
@property(nonatomic,copy)NSString * is_deleted;
@property(nonatomic,copy)NSString * is_read;
@property(nonatomic,copy)NSString * is_system;
@property(nonatomic,copy)NSString * mail_id;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * tx;
@property(nonatomic,copy)NSString * update_time;
@property(nonatomic,copy)NSString * usr_id;
@end
