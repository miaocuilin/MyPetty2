//
//  NoticeModel.m
//  MyPetty
//
//  Created by miaocuilin on 14-10-18.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "NoticeModel.h"

@implementation NoticeModel

-(void)dealloc
{
    [_usr_name release];
    [_usr_tx release];
    [_time release];
    [_lastMsg release];
    [_unReadNum release];
    [_img_id release];
    [super dealloc];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"undefinedKey:%@",key);
}
@end
