//
//  NoticeViewController.h
//  MyPetty
//
//  Created by Aidi on 14-7-3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ANBlurredImageView;
@interface NoticeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UIView * navView;
    UILabel *messageLabel;
    UILabel *systemLabel;
    
    UIButton * alphaBtn;
    UIButton * backBtn;
}
@property(nonatomic,retain)UIImageView * bgImageView;

@property(nonatomic,retain)NSMutableArray * systemDataArray;
@property(nonatomic,retain)NSMutableArray * messageDataArray;
@end
