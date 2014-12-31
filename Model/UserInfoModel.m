//
//  UserInfoModel.m
//  MyPetty
//
//  Created by miaocuilin on 14-9-5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

-(void)dealloc
{
    [_a_name release];
    [_a_tx release];
    [_age release];
    [_aid release];
    [_city release];
    [_exp release];
    [_gender release];
    [_gold release];
    [_lv release];
    [_name release];
    [_tx release];
    [_usr_id release];
    [_next_gold release];
    [_password release];
    [_rank release];
    [_wechat release];
    [_weibo release];
    [_code release];
    [super dealloc];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"key:%@未赋值", key);
}

@end
