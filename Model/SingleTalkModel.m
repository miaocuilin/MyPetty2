 //
//  SingleTalkModel.m
//  MyPetty
//
//  Created by miaocuilin on 14-10-17.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "SingleTalkModel.h"


@implementation SingleTalkModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.usr_id forKey:@"usr_id"];
    [aCoder encodeObject:self.usr_name forKey:@"usr_name"];
    [aCoder encodeObject:self.usr_tx forKey:@"usr_tx"];
    [aCoder encodeObject:self.unReadMsgNum forKey:@"unReadMsgNum"];
    [aCoder encodeObject:self.msgDict forKey:@"msgDict"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.usr_id = [aDecoder decodeObjectForKey:@"usr_id"];
        self.usr_name = [aDecoder decodeObjectForKey:@"usr_name"];
        self.usr_tx = [aDecoder decodeObjectForKey:@"usr_tx"];
        self.unReadMsgNum = [aDecoder decodeObjectForKey:@"unReadMsgNum"];
        self.msgDict = [aDecoder decodeObjectForKey:@"msgDict"];
    }
    return self;
}


-(void)dealloc
{
    [_usr_id release];
    [_usr_name release];
    [_usr_tx release];
    [_unReadMsgNum release];
    [_msgDict release];
    [super dealloc];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"undefinedKey:%@",key);
}
@end
