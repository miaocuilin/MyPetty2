//
//  PetNewsModel.m
//  MyPetty
//
//  Created by miaocuilin on 14-9-16.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetNewsModel.h"

@implementation PetNewsModel

-(void)dealloc
{
    [_aid release];
    [_create_time release];
    [_nid release];
    [_type release];
    [_content release];
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"key:%@未赋值", key);
}
@end
