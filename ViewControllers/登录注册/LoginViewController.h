//
//  LoginViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/8.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    UIScrollView * sv;
    UITextField * nameTF;
    UITextField * codeTF;
    UIButton * logBtn;
}
@end
