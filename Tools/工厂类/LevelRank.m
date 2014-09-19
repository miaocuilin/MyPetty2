//
//  LevelRank.m
//  calculater
//
//  Created by zhangjr on 14-9-18.
//  Copyright (c) 2014年 自学OC. All rights reserved.
//

#import "LevelRank.h"
#import "GiftShopModel.h"
@interface LevelRank ()
@property (nonatomic,strong)NSMutableDictionary *dict;
@property (nonatomic,retain)NSMutableArray *goodGiftDataArray;
@property (nonatomic,retain)NSMutableArray *badGiftDataArray;

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

- (void)addGiftShopData
{
    self.goodGiftDataArray =[NSMutableArray arrayWithCapacity:0];
    self.badGiftDataArray = [NSMutableArray arrayWithCapacity:0];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"shopGift" ofType:@"plist"];
    NSMutableDictionary *DictData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *level0 = [[DictData objectForKey:@"good"] objectForKey:@"level0"];
    NSArray *level1 =[[DictData objectForKey:@"good"] objectForKey:@"level1"];
    NSArray *level2 =[[DictData objectForKey:@"good"] objectForKey:@"level2"];
    NSArray *level3 =[[DictData objectForKey:@"good"] objectForKey:@"level3"];
    [self addData:level0 isGood:YES];
    [self addData:level1 isGood:YES];
    [self addData:level2 isGood:YES];
    [self addData:level3 isGood:YES];
    
    NSArray *level4 =[[DictData objectForKey:@"bad"] objectForKey:@"level0"];
    NSArray *level5 =[[DictData objectForKey:@"bad"] objectForKey:@"level1"];
    NSArray *level6 =[[DictData objectForKey:@"bad"] objectForKey:@"level2"];
    [self addData:level4 isGood:NO];
    [self addData:level5 isGood:NO];
    [self addData:level6 isGood:NO];
    
    //    NSLog(@"data:%@",DictData);
}
- (void)addData:(NSArray *)array isGood:(BOOL)good
{
    for (NSDictionary *dict in array) {
        GiftShopModel *model = [[GiftShopModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        if (good) {
            [self.goodGiftDataArray addObject:model];
        }else{
            [self.badGiftDataArray addObject:model];
        }
        [model release];
    }
}
- (NSMutableArray *)getBadGiftDataArray:(BOOL)isBad
{
    [self addGiftShopData];
    if (isBad) {
        return self.badGiftDataArray;
    }else{
        return self.goodGiftDataArray;
    }
}

@end
