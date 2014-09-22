//
//  UserActivityListModel.m
//  MyPetty
//
//  Created by miaocuilin on 14-9-22.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "UserActivityListModel.h"

@implementation UserActivityListModel

-(void)dealloc
{
    [_create_time release];
    [_img_id release];
    [_topic_name release];
    [_url release];
    [super dealloc];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"key:%@未赋值", key);
}
@end
