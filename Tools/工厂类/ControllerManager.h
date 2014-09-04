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
+ (void)loginHUDAlertView:(UIView *)showInView;

+(NSString *)returnCateNameWithType:(NSString *)type;
+(NSString *)returnProvinceAndCityWithCityNum:(NSString *)cityNum;

@end
