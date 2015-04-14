//
//  ControllerManager.h
//  MyPetty
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControllerManager : NSObject

+(id)shareManagerRandom;
+(id)shareUserDefault;
+(void)setIsSuccess:(int)a;
+(int)getIsSuccess;
+(void)setSID:(NSString *)str;
+(id)getSID;

+(void)startLoading:(NSString *)string;
+(void)loadingSuccess:(NSString *)string;
+(void)loadingFailed:(NSString *)string;


+(id)shareTabBar;
+(id)shareLoading;
+(id)sharePopView;


+ (UIColor *)colorWithHexString: (NSString *) stringToConvert;
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label;

+ (void)HUDText:(NSString *)string showView:(UIView *)inView yOffset:(float) offset;
+ (void)HUDImageIcon:(NSString *)iconImageString showView:(UIView *)inView yOffset:(float)offset Number:(int)num;
//+ (void)loginHUDAlertView:(UIView *)showInView;
/***********************************************/
//传入宠物类型，返回宠物类型名称
+(NSString *)returnCateNameWithType:(NSString *)type;
//传入宠物类型，返回宠物类型名称
+(NSString *)returnCateTypeWithName:(NSString *)name;
//传入城市代号，返回城市及区名
+(NSString *)returnProvinceAndCityWithCityNum:(NSString *)cityNum;

//传入item_id，返回所有礼物的信息的数组
+(NSArray *)returnAllGiftsArray;
//传入item_id，返回该礼物的信息字典dict
+(NSDictionary *)returnGiftDictWithItemId:(NSString *)itemId;

//传入rank值，返回官职名称
+(NSString *)returnPositionWithRank:(NSString *)rank;
//传入礼物item_id，返回对应的动态文字
+(NSString *)returnActionStringWithItemId:(NSString *)item_id;

//传入贡献值，返回对应下一级所需贡献值
+(int)returnContributionOfNeedWithContribution:(NSString *)con;
//传入当前等级，返回升到下一级需要的总经验
+(int)returnExpOfNeedWithLv:(NSString *)lv;
/***********************************************/
//计算升级和官职弹窗
//+(BOOL)levelPOP:(NSString *)exp addExp:(NSInteger)add;
//+(BOOL)rankPOP:(NSString *)contribution addContribution:(NSInteger)add planet:(NSString *)dogOrcat;

//+ (NSMutableArray *)getGift:(BOOL)isBad;

+(void)clearTalkData;

/**添加viewController到TabBar*/
+ (void)addTabBarViewController:(UIViewController *)vc;
/**从tabBar上删除viewController*/
+ (void)deleTabBarViewController:(UIViewController *)vc;
+ (void)addViewController:(UIViewController *)vc To:(UIViewController *)root;

+(void)loadPetList;

+(void)addAlertWith:(UIViewController *)vc Cost:(int)cost SubType:(int)subType;

<<<<<<< HEAD
=======
//创建单例队列
+(NSOperationQueue *)createOperationQueue;
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> dev-miao
=======
=======
>>>>>>> dev-miao

//检查强制更新用
+(NSInteger)getCheckUpdate;
+(void)setCheckUpdate;
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> dev-miao
=======
>>>>>>> dev-miao
=======

//tabBar的隐藏和显示
+(void)hideTabBar;
+(void)showTabBar;
>>>>>>> dev-miao
@end
