//
//  ExchangeViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
@interface ExchangeViewController : UIViewController<NIDropDownDelegate>
{
    UIView * navView;
    UIButton * exBtn;
    
    NIDropDown * dropDown;
}
@end
