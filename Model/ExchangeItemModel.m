//
//  ExchangeItemModel.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ExchangeItemModel.h"

@implementation ExchangeItemModel

-(void)dealloc
{
    [super dealloc];
    [_create_time release];
    [_des release];
    [_icon release];
    [_img release];
    [_item_id release];
    [_name release];
    [_price release];
    [_spec release];
    [_type release];
    [_update_time release];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"undefinedKey:%@",key);
}
@end
