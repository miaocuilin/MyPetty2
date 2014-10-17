//
//  MessageModel.m
//  MyPetty
//
//  Created by miaocuilin on 14-10-17.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

-(void)dealloc
{
    [_msg release];
    [_time release];
    [_usr_id release];
    [_img_id release];
    [super dealloc];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"undefinedKey:%@",key);
}
@end
