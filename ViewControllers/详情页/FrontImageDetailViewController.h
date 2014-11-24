//
//  FrontImageDetailViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/21.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ClickImage.h"
@interface FrontImageDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    UIView * bgView;
    UIScrollView * sv;
    UIScrollView * sv2;
    UIImageView * bottomBgView;
    
    UIView * imageBgView;
    UIView * imageBgView2;
    //
    UIImageView * bigImageView;
    UILabel * desLabel;
    UILabel * topicLabel;
    UILabel * timeLabel;
    
    UIButton * headBtn;
    UIImageView * sex;
    UILabel * petName;
    UILabel * petType;
    UILabel * userName;
    UIImageView * userTx;
    UIImageView * triangle;
    
    UITableView * tv;
    UITableView * desTv;
    
    UISwipeGestureRecognizer * swipeLeft;
    UISwipeGestureRecognizer * swipeRight;
    //是否在第二页
    BOOL isBackSide;
    
    
    BOOL isTest;
    
    //
    BOOL isCommentCreated;
    //评论
    UIButton * bgButton;
    UIView * commentBgView;
    UITextField * commentTextField;
    //判断是否在当前控制器，来限制键盘变化通知
    BOOL isInThisController;
    
    
    //背面点击按钮index
    int triangleIndex;
    
    BOOL isReply;
    int replyRow;
}
@property(nonatomic,retain)NSDictionary * picDict;
@property(nonatomic,retain)NSDictionary * imageDict;

@property(nonatomic,retain)NSDictionary * petDict;

@property(nonatomic,retain)NSString * img_id;

//评论解析数组
@property (nonatomic,retain)NSMutableArray * usrIdArray;
@property (nonatomic,retain)NSMutableArray * nameArray;
@property (nonatomic,retain)NSMutableArray * bodyArray;
@property (nonatomic,retain)NSMutableArray * createTimeArray;
//
@property (nonatomic,retain)NSMutableArray * likerTxArray;
@property (nonatomic,retain)NSMutableArray * senderTxArray;
@property (nonatomic,retain)NSMutableArray * likerIdArray;
@property (nonatomic,retain)NSMutableArray * senderIdArray;
@end
