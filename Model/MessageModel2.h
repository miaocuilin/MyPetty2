//
//  MessageModel2.h
//  MyPetty
//
//  Created by miaocuilin on 15/1/9.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel2 : NSObject <NSCoding>

@property(nonatomic,copy)NSString * msg;
@property(nonatomic,copy)NSString * time;
@property(nonatomic,copy)NSString * usr_id;
@property(nonatomic,copy)NSString * img_id;
@end
