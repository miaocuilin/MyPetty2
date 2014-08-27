//
//  TopicDetailModel.m
//  MyPetty
//
//  Created by Aidi on 14-7-1.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "TopicDetailModel.h"

@implementation TopicDetailModel

-(void)dealloc
{
    [_des release];
    [_remark release];
    [_txsArray release];
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"key:%@未赋值", key);
}
@end
