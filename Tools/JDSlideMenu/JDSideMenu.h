//
//  JDSideMenu.h
//  StatusBarTest
//
//  Created by Markus Emrich on 11/11/13.
//  Copyright (c) 2013 Markus Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDSideMenu : UIViewController

@property (nonatomic, readonly) UIViewController *contentController;
@property (nonatomic, readonly) UIViewController *menuController;

@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, assign) BOOL tapGestureEnabled;
@property (nonatomic, assign) BOOL panGestureEnabled;

/****************************/
@property(nonatomic,retain)NSMutableArray * userPetListArray;
@property(nonatomic,retain)NSMutableArray * newDataArray;
@property(nonatomic)BOOL hasNewMsg;
//下载完宠物列表新数据
@property(nonatomic,copy)void (^refreshData)(void);
//下载完活动数 更新
@property(nonatomic,copy)void (^refreshActNum)(NSString *);
//刷新个人数据
@property(nonatomic,copy)void (^refreshUserData)(void);
//传递新消息数组
@property(nonatomic,copy)void (^refreshNewMsgNum)(NSArray *);
/****************************/
- (id)initWithContentController:(UIViewController*)contentController
                 menuController:(UIViewController*)menuController;

- (void)setContentController:(UIViewController*)contentController
                     animted:(BOOL)animated;

// show / hide manually
- (void)showMenuAnimated:(BOOL)animated;
- (void)hideMenuAnimated:(BOOL)animated;
- (BOOL)isMenuVisible;

// background
- (void)setBackgroundImage:(UIImage*)image;

- (void)click;

-(id)returnContentController;


@end
