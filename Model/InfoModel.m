//
//  InfoModel.m
//  MyPetty
//
//  Created by Aidi on 14-6-6.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "InfoModel.h"

@implementation InfoModel

-(void)dealloc
{
    [_name release];
    [_code release];
    [_type release];
    [_gender release];
    [_age release];
    [_imagesCount release];
    [_lv release];
    [_exp release];
    [_follow release];
    [_follower release];
    [_tx release];
    [_updata_time release];
    [_usr_id release];
    [_inviter release];
    [_weichat release];
    [_weibo release];
    [_aid release];
    [super dealloc];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"key:%@未赋值", key);
}
@end
