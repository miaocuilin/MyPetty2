//
//  SingleTalkModel.h
//  MyPetty
//
//  Created by miaocuilin on 14-10-17.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

@interface SingleTalkModel : NSObject

@property(nonatomic,copy)NSString * usr_id;
@property(nonatomic,copy)NSString * usr_name;
@property(nonatomic,copy)NSString * usr_tx;
@property(nonatomic,copy)NSString * newMsgNum;
@property(nonatomic,retain)MessageModel * model;
@end
