//
//  PetRecomModel.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/7.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PetRecomModel : NSObject

@property(nonatomic,copy)NSString * aid;
@property(nonatomic,copy)NSString * fans;
@property(nonatomic,copy)NSString * gender;
@property(nonatomic,copy)NSNumber * in_circle;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSNumber * percent;
@property(nonatomic,copy)NSString * tx;
@property(nonatomic,copy)NSString * u_name;
@property(nonatomic,copy)NSString * u_tx;
@property(nonatomic,retain)NSArray * images;
@end
