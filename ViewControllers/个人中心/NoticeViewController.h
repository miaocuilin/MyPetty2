//
//  NoticeViewController.h
//  MyPetty
//
//  Created by Aidi on 14-7-3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NoticeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UIView * navView;
    UILabel *messageLabel;
    UILabel *systemLabel;
    
    UIButton * alphaBtn;
    UIButton * backBtn;
    
    BOOL hasNewMsg;
}
@property(nonatomic,retain)UIImageView * bgImageView;

@property(nonatomic,retain)NSMutableArray * systemDataArray;
@property(nonatomic,retain)NSMutableArray * messageDataArray;

//总的历史信息
@property(nonatomic,retain)NSMutableDictionary * totalDataDict;
//@property(nonatomic,retain)NSMutableDictionary * talkDataDict;
/********7个数组************/
//记录每个对话id
@property(nonatomic,retain)NSMutableArray * talkIDArray;
//记录每个id对应的最后一次对话信息的字典,包括解析后的
@property(nonatomic,retain)NSMutableArray * lastTalkTimeArray;
@property(nonatomic,retain)NSMutableArray * lastTalkContentArray;
@property(nonatomic,retain)NSMutableArray * userIDArray;
@property(nonatomic,retain)NSMutableArray * userTxArray;
@property(nonatomic,retain)NSMutableArray * userNameArray;
@property(nonatomic,retain)NSMutableArray * newMsgNumArray;
/**************************/
@property (nonatomic,retain)NSMutableArray * keysArray;
@property (nonatomic,retain)NSMutableArray * valuesArray;
//新消息的数组
@property (nonatomic,retain)NSMutableArray * newDataArray;
/**************************/
//存放每个对话新消息，包含多个字典，每个字典中有两个key
//key:keysArray
//value:valuesArray
@property (nonatomic,retain)NSMutableArray * newMsgArray;
@end
