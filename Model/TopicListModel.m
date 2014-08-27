//
//  TopicListModel.m
//  MyPetty
//
//  Created by Aidi on 14-6-30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "TopicListModel.h"

@implementation TopicListModel

-(void)dealloc
{
    [_end_time release];
    [_img release];
    [_people release];
    [_reward release];
    [_start_time release];
    [_topic release];
    [_topic_id release];
    [super dealloc];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"key:%@未赋值", key);
}
@end
