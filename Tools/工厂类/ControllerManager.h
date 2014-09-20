//
//  ControllerManager.h
//  MyPetty
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDSideMenu.h"

@interface ControllerManager : NSObject

+(id)shareManagerRandom;
+(id)shareManagerFavorite;
+(id)shareManagerDetail;
+(id)shareManagerMyPet;
+(id)shareManagerMyHome;
+(id)shareUserDefault;
+(void)setIsSuccess:(int)a;
+(int)getIsSuccess;
+(void)setSID:(NSString *)str;
+(id)getSID;

+(void)startLoading:(NSString *)string;
+(void)loadingSuccess:(NSString *)string;
+(void)loadingFailed:(NSString *)string;

//+(id)shareMainTabBar;
+(id)shareMain;
+(id)shareJDSideMenu;
//+(id)shareSliding;

+ (UIColor *)colorWithHexString: (NSString *) stringToConvert;
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label;

+ (void)HUDText:(NSString *)string showView:(UIView *)inView yOffset:(float) offset;
+ (void)HUDImageIcon:(NSString *)iconImageString showView:(UIView *)inView yOffset:(float)offset Number:(int)num;
//+ (void)loginHUDAlertView:(UIView *)showInView;
//传入宠物类型，返回宠物类型名称
+(NSString *)returnCateNameWithType:(NSString *)type;
//传入城市代号，返回城市及区名
+(NSString *)returnProvinceAndCityWithCityNum:(NSString *)cityNum;
//传入item_id，返回所有礼物的信息的数组

//传入item_id，返回该礼物的信息字典dict
+(NSDictionary *)returnGiftDictWithItemId:(NSString *)itemId;


//计算升级和官职弹窗
+(BOOL)levelPOP:(NSString *)exp addExp:(NSInteger)add;
+(BOOL)rankPOP:(NSString *)contribution addContribution:(NSInteger)add planet:(NSString *)dogOrcat;

+ (NSMutableArray *)getGift:(BOOL)isBad;
@end
