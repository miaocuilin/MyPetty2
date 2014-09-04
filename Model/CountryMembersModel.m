//
//  CountryMembersModel.m
//  MyPetty
//
//  Created by zhangjr on 14-9-4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "CountryMembersModel.h"

@implementation CountryMembersModel
- (void)dealloc
{
    [_city release];
    [_gender release];
    [_name release];
    [_rank release];
    [_t_contri release];
    [_tx release];
    [_usr_id release];

    [super dealloc];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"key:%@未赋值", key);
}
@end
