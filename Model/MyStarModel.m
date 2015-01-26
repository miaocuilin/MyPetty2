//
//  MyStarModel.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/9.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MyStarModel.h"

@implementation MyStarModel

-(void)dealloc
{
    [super dealloc];
    [_aid release];
    [_master_id release];
    [_gift_count release];
    [_is_touched release];
    [_is_voiced release];
    [_msg release];
    [_name release];
    [_percent release];
    [_rank release];
    [_shake_count release];
    [_t_contri release];
    [_t_rq release];
    [_tx release];
    [_u_tx release];
    [_u_name release];
    [_images release];
    [_invite_code release];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"undefinedKey:%@",key);
}
@end
