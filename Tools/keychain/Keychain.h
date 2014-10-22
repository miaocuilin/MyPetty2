//
//  Keychain.h
//  MyPetty
//
//  Created by miaocuilin on 14/10/22.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
//+ (void)delete:(NSString *)service;

@end
