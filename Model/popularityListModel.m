//
//  popularityListModel.m
//  MyPetty
//
//  Created by zhangjr on 14-9-9.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "popularityListModel.h"

@implementation popularityListModel
- (void)dealloc
{
    [_aid release],_aid = nil;
    [_name release],_name = nil;
    [_tx release],_tx = nil;
    [_d_rq release],_d_rq = nil;
    [_w_rq release],_w_rq = nil;
    [_m_rq release],_m_rq = nil;
    [_t_rq release],_t_rq = nil;

    [_change release],_change = nil;
    [super dealloc];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"key:%@未赋值", key);
}
@end
