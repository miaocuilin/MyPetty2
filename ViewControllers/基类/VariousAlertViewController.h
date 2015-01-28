//
//  VariousAlertViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/10.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VariousAlertViewController : UIViewController

@property(nonatomic,copy)void (^regClick)(void);
@property(nonatomic,copy)void (^fastClick)(void);

@property(nonatomic,copy)void (^modifyCenter)(void);
@property(nonatomic)BOOL isFromCenter;
@end
