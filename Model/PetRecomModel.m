//
//  PetRecomModel.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/7.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetRecomModel.h"

@implementation PetRecomModel

-(void)dealloc
{
    [super dealloc];
    [_aid release];
    [_fans release];
    [_gender release];
    [_in_circle release];
    [_name release];
    [_percent release];
    [_tx release];
    [_u_name release];
    [_u_tx release];
    [_images release];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"undefinedKey:%@",key);
}
@end
