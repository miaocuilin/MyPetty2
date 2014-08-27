//
//  ToolTipsViewController.h
//  MyPetty
//
//  Created by zhangjr on 14-8-25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolTipsViewController : UIViewController<UIScrollViewDelegate>
{
    //加入和购买成功
    MBProgressHUD *alertView;
    
    MBProgressHUD *loginHUD;
    MBProgressHUD *expHUD;
    MBProgressHUD *governmentHUD;
    MBProgressHUD *giftHUD;
    MBProgressHUD *noMoneyHUD;
    
    UIScrollView *giftScrollView;
    UIPageControl *giftPageControl;
}
@property (nonatomic)NSInteger coinNumber;
@property (nonatomic)NSInteger continuousDay;

@property (nonatomic)NSInteger expLevel;
@property (nonatomic,strong)NSString *countryName;
@property (nonatomic,strong)NSString *positionName;
@property (nonatomic,strong)NSString *headImageName;
//@property (nonatomic)NSInteger expCoinNum;
//每日登陆
- (void)createAlertView;
//升级经验
-(void)createExpAlertView;
//官职升级
- (void)createGovernmentAlertView;
- (void)createPresentGiftAlertView;
@end
