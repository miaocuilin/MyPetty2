//
//  FeedbackViewController.h
//  MyPetty
//
//  Created by Aidi on 14-7-15.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMFeedback.h"
@class ANBlurredImageView;
@interface FeedbackViewController : UIViewController <UITextViewDelegate,UITextFieldDelegate,UMFeedbackDataDelegate>
{
    UITextView * _textView;
    UITextField * tf;
    UIButton * submit;
    BOOL isPhoneNum;
    
    UIView * navView;

}

@property(nonatomic,retain)UMFeedback * umFeedback;
@property(nonatomic,retain)UIImageView * bgImageView;

@end
