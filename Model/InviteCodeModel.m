//
//  InviteCodeModel.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/13.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "InviteCodeModel.h"

@implementation InviteCodeModel

-(void)dealloc
{
    [_aid release];
    [_tx release];
    [_u_name release];
    [_inviter release];
    [super dealloc];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"undefinedKey:%@",key);
}
@end
