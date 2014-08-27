//
//  SystemMessageListModel.m
//  MyPetty
//
//  Created by Aidi on 14-7-9.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "SystemMessageListModel.h"

@implementation SystemMessageListModel

-(void)dealloc
{
    [_body release];
    [_create_time release];
    [_from_id release];
    [_gender release];
    [_is_deleted release];
    [_is_read release];
    [_is_system release];
    [_mail_id release];
    [_name release];
    [_tx release];
    [_update_time release];
    [_usr_id release];
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"key:%@未赋值", key);
}
@end
