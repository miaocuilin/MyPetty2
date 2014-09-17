//
//  PetNewsModel.h
//  MyPetty
//
//  Created by miaocuilin on 14-9-16.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PetNewsModel : NSObject

@property(nonatomic,copy)NSString * aid;
@property(nonatomic,copy)NSString * create_time;
@property(nonatomic,copy)NSString * nid;
@property(nonatomic,copy)NSString * type;

@property(nonatomic,retain)NSDictionary * content;
@end
