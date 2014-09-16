//
//  GiftShopModel.m
//  MyPetty
//
//  Created by zhangjr on 14-9-16.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "GiftShopModel.h"

@implementation GiftShopModel
- (void)dealloc
{
    [_add_rq release],_add_rq = nil;
    [_level release],_level = nil;
    [_name release],_name = nil;
    [_no release],_no = nil;
    [_price release],_price = nil;
    [_ratio release],_ratio = nil;
    [super dealloc];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"key:%@未赋值", key);
}
@end
