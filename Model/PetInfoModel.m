//
//  PetInfoModel.m
//  MyPetty
//
//  Created by miaocuilin on 14-9-3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetInfoModel.h"

@implementation PetInfoModel

-(void)dealloc
{
    [_age release];
    [_aid release];
    [_fans release];
    [_followers release];
    [_from release];
    [_gender release];
    [_master_id release];
    [_name release];
    [_t_rq release];
    [_tx release];
    [_type release];
    [_u_name release];
    [_u_rank release];
    [_u_tx release];
    [super dealloc];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"未赋值的key:%@", key);
}
@end
