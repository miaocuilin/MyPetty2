//
//  LevelRank.h
//  calculater
//
//  Created by zhangjr on 14-9-18.
//  Copyright (c) 2014年 自学OC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelRank : NSObject
- (NSString *)calculateLevel:(NSString *)userExp addExp:(NSInteger)add;
- (NSString *)calculaterRank:(NSString *)contribution planet:(NSString *)dogOrcat addContribution:(NSInteger)add;

@end
