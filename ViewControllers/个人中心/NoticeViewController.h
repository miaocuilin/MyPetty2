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
    
}
@property(nonatomic,retain)UIImageView * bgImageView;

@property(nonatomic,retain)NSMutableArray * systemDataArray;
@property(nonatomic,retain)NSMutableArray * messageDataArray;

//总的历史信息
@property(nonatomic,retain)NSMutableDictionary * totalDataDict;
//记录每个对话id
@property(nonatomic,retain)NSMutableArray * talkIDArray;
//记录每个id对应的最后一次对话信息的字典
@property(nonatomic,retain)NSMutableArray * lastTalkArray;

@property (nonatomic,retain)NSMutableArray * keysArray;
@property (nonatomic,retain)NSMutableArray * valuesArray;
//新消息的数组
@property (nonatomic,retain)NSMutableArray * newDataArray;
@end
