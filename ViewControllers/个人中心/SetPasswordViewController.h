//
//  SetPasswordViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/9.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPasswordViewController : UIViewController<UITextFieldDelegate>
{
    UIScrollView * sv;
    UIView * navView;
    UILabel * oriPwd;
    UILabel * nwPwd;
    UILabel * conPwd;
    UITextField * oriTF;
    UITextField * nwTF;
    UITextField * conTF;
    
    UIButton * confirmBtn;
    UIImageView * bg1;
    UIImageView * bg2;
    UIImageView * bg3;
    //确定是否可点
    BOOL canClick;
}
//是否是修改密码
@property(nonatomic)BOOL isModify;
@end
