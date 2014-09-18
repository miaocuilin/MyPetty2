//
//  LevelRank.m
//  calculater
//
//  Created by zhangjr on 14-9-18.
//  Copyright (c) 2014年 自学OC. All rights reserved.
//

#import "LevelRank.h"
@interface LevelRank ()
@property (nonatomic,strong)NSMutableDictionary *dict;
@end
@implementation LevelRank
//传入经验和贡献值、种类
//返回 等级   和 官职
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self showPlist];
    }
    return self;
}
- (void)showPlist
{
    NSString *string = [[NSBundle mainBundle] pathForResource:@"animalAndPeople" ofType:@"plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:string];
    self.dict = dict;
//    NSLog(@"dict:%@",dict);
}
- (NSString *)calculateLevel:(NSString *)userExp addExp:(NSInteger)add
{
    NSString *level = nil;
    int total = [userExp intValue]+add;
    NSArray *userLevelArray = [self.dict objectForKey:@"userlevel"];
    for (int i =0; i<userLevelArray.count; i++) {
        int exp = [[userLevelArray[i] objectForKey:@"exp"] intValue];
        if (exp > total) {
            level = [userLevelArray[i-1] objectForKey:@"level"];
            break;
        }
    }
    NSLog(@"string:%@",level);
    return level;
}
- (NSString *)calculaterRank:(NSString *)contribution planet:(NSString *)dogOrcat addContribution:(NSInteger)add
{
    NSString *rankString = nil;
    int total = [contribution intValue]+add;
    
    NSArray *usercontribution = [self.dict objectForKey:@"usercontribution"];

    for (int i=0; i<usercontribution.count; i++) {
        int rank = [[usercontribution[i] objectForKey:@"contribution"] intValue];
        if (rank > total) {
            if ([dogOrcat isEqualToString:@"dog"]) {
                rankString = [usercontribution[i-1] objectForKey:@"dog"];
                break;
            }else{
                rankString = [usercontribution[i-1] objectForKey:@"cat"];
                break;
            }
        }
    }
    return rankString;
}
@end
