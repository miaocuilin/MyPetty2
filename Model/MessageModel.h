//
//  MessageModel.h
//  MyPetty
//
//  Created by miaocuilin on 14-10-17.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject <NSCoding>

@property(nonatomic,copy)NSString * msg;
@property(nonatomic,copy)NSString * time;
@property(nonatomic,copy)NSString * usr_id;
@property(nonatomic,copy)NSString * img_id;
@end
