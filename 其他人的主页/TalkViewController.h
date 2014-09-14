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

    //判断是否已经从本地读取数据
    BOOL isRead;
    //判断是否是新创建的plist文件
    BOOL isNewCreated;
    
    NSTimer * timer;
}
@property (nonatomic,copy)NSString * friendName;
@property (nonatomic,copy)NSString * usr_id;
@property (nonatomic,copy)NSString * otherTX;

@property (nonatomic,retain)NSMutableArray * dataArray;
@property (nonatomic,retain)NSMutableArray * userDataArray;

@property (nonatomic,copy)NSString * talk_id;

@property (nonatomic,copy)NSString * lastMessage;
//@property (nonatomic,copy)NSString * tempUsrID;
/********************/
//总字典，等同于plist文件
@property (nonatomic,retain)NSMutableDictionary * totalDataDict;
//talk_id为key值的value
@property (nonatomic,retain)NSMutableDictionary * talkDataDict;
//对话每局的数组 包含多个字典
@property (nonatomic,retain)NSMutableArray * talkDataArray;
//每一句话的字典 包含time msg usr_id用来判断是谁说的
//@property (nonatomic,retain)NSMutableDictionary * messageDict;
/********************/

@property (nonatomic,retain)NSMutableArray * keysArray;
@property (nonatomic,retain)NSMutableArray * valuesArray;
@end
