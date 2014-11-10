//
//  MyStarModel.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/9.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyStarModel : NSObject

@property(nonatomic,copy)NSString * aid;
@property(nonatomic,copy)NSString * master_id;
@property(nonatomic,copy)NSNumber * gift_count;
@property(nonatomic,copy)NSNumber * is_touched;
@property(nonatomic,copy)NSNumber * is_voiced;
@property(nonatomic,copy)NSString * msg;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSNumber * percent;
@property(nonatomic,copy)NSString * rank;
@property(nonatomic,copy)NSNumber * shake_count;
@property(nonatomic,copy)NSString * t_contri;
@property(nonatomic,copy)NSString * t_rq;
@property(nonatomic,copy)NSString * tx;

@property(nonatomic,retain)NSArray * images;
@property(nonatomic,retain)NSDictionary * dict;
@end
