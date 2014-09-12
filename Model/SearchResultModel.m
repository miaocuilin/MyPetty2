//
//  SearchResultModel.m
//  MyPetty
//
//  Created by zhangjr on 14-9-12.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "SearchResultModel.h"

@implementation SearchResultModel
- (void)dealloc
{
    [_aid release],_aid = nil;
    [_name release],_name = nil;
    [_tx release],_tx = nil;
    [_gender release],_gender = nil;
    [_from release],_from = nil;
    [_type release],_type = nil;
    [_age release],_age = nil;
    [_t_rq release],_t_rq = nil;
    [_fans release],_fans = nil;
    [super dealloc];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"undefinedKey:%@",key);
}
@end
