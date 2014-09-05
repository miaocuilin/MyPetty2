//
//  PhotoModel.m
//  MyPetty
//
//  Created by Aidi on 14-6-8.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

-(void)dealloc
{
    [_cmt release];
    [_comments release];
    [_create_time release];
    [_img_id release];
    [_likes release];
    [_likers release];
    [_updata_time release];
    [_url release];
    [_usr_id release];
    
    [_headImage release];
    [_title release];
    [_detail release];
    
    [_name release];
    [_tx release];
    [_aid release];
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"key:%@未赋值", key);
}
@end
