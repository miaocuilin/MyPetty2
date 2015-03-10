//
//  UserPetListModel.m
//  MyPetty
//
//  Created by miaocuilin on 14-9-5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "UserPetListModel.h"

@implementation UserPetListModel

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.aid = [aDecoder decodeObjectForKey:@"aid"];
        self.d_rq = [aDecoder decodeObjectForKey:@"d_rq"];
        self.fans_count = [aDecoder decodeObjectForKey:@"fans_count"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.news_count = [aDecoder decodeObjectForKey:@"news_count"];
        self.rank = [aDecoder decodeObjectForKey:@"rank"];
        self.t_contri = [aDecoder decodeObjectForKey:@"t_contri"];
        self.tx = [aDecoder decodeObjectForKey:@"tx"];
        self.master_id = [aDecoder decodeObjectForKey:@"master_id"];
        self.food = [aDecoder decodeObjectForKey:@"food"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.age = [aDecoder decodeObjectForKey:@"age"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.aid forKey:@"aid"];
    [aCoder encodeObject:self.d_rq forKey:@"d_rq"];
    [aCoder encodeObject:self.fans_count forKey:@"fans_count"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.news_count forKey:@"news_count"];
    [aCoder encodeObject:self.rank forKey:@"rank"];
    [aCoder encodeObject:self.t_contri forKey:@"t_contri"];
    [aCoder encodeObject:self.tx forKey:@"tx"];
    [aCoder encodeObject:self.master_id forKey:@"master_id"];
    [aCoder encodeObject:self.food forKey:@"food"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.age forKey:@"age"];
}


-(void)dealloc{
    [_aid release];
    [_d_rq release];
    [_fans_count release];
    [_name release];
    [_news_count release];
    [_rank release];
    [_t_contri release];
    [_tx release];
    [_master_id release];
    [_gender release];
    [_type release];
    [_age release];
    [_food release];
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"key:%@未赋值", key);
}
@end
