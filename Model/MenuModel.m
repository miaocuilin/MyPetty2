//
//  MenuModel.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/6.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.animate1 = [aDecoder decodeObjectForKey:@"animate1"];
        self.animate2 = [aDecoder decodeObjectForKey:@"animate2"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.label = [aDecoder decodeObjectForKey:@"label"];
        self.mid = [aDecoder decodeObjectForKey:@"mid"];
        self.pic = [aDecoder decodeObjectForKey:@"pic"];
        self.subject = [aDecoder decodeObjectForKey:@"subject"];
        self.txt = [aDecoder decodeObjectForKey:@"txt"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.animate1 forKey:@"animate1"];
    [aCoder encodeObject:self.animate2 forKey:@"animate2"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.label forKey:@"label"];
    [aCoder encodeObject:self.mid forKey:@"mid"];
    [aCoder encodeObject:self.pic forKey:@"pic"];
    [aCoder encodeObject:self.subject forKey:@"subject"];
    [aCoder encodeObject:self.txt forKey:@"txt"];
}

-(void)dealloc
{
    [_animate1 release];
    [_animate2 release];
    [_icon release];
    [_label release];
    [_mid release];
    [_pic release];
    [_subject release];
    [_txt release];
    
    [super dealloc];
}
@end
