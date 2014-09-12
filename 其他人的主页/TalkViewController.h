//
//  TalkViewController.h
//  MyPetty
//
//  Created by Aidi on 14-7-14.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
@interface TalkViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIImageView * bgImageView;
    UIView * navView;
    UITableView * tv;
    UITextField * tf;
    UIButton * sendButton;
    
    UIView * commentBgView2;
    
    ASIFormDataRequest * _request;
    ASIFormDataRequest * _requestSend;
    UIView * navView;

}
@property (nonatomic,copy)NSString * friendName;

@property (nonatomic,retain)NSMutableArray * dataArray;
@property (nonatomic,retain)NSMutableArray * userDataArray;
@end
