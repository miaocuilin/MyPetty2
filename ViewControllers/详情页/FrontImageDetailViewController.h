//
//  FrontImageDetailViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/21.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"
@interface FrontImageDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    UIView * bgView;
    UIScrollView * sv;
    UIScrollView * sv2;
    UIImageView * bottomBgView;
    
    UIView * imageBgView;
    UIView * imageBgView2;
    //
    ClickImage * bigImageView;
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
    
    UISwipeGestureRecognizer * swipeLeft2;
    UISwipeGestureRecognizer * swipeRight2;
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
    
    //评论及回复框的起始Y值
    float originalY;
    
    //4项是否都加载过数据了
    BOOL isLoaded[4];
    
    BOOL isBackLoaded;
    
    BOOL isLoad;
    UIImageView * guide;
}
@property(nonatomic,retain)NSDictionary * picDict;
@property(nonatomic,retain)NSDictionary * imageDict;

@property(nonatomic,retain)NSDictionary * petDict;

@property(nonatomic,retain)NSString * img_id;

//@property (nonatomic)BOOL is_follow;

//评论解析数组
@property (nonatomic,retain)NSMutableArray * usrIdArray;
@property (nonatomic,retain)NSMutableArray * nameArray;
@property (nonatomic,retain)NSMutableArray * bodyArray;
@property (nonatomic,retain)NSMutableArray * createTimeArray;

@property (nonatomic,retain)NSMutableArray * cmtTxArray;
//
@property (nonatomic,retain)NSMutableArray * likerTxArray;
@property (nonatomic,retain)NSMutableArray * senderTxArray;
@property (nonatomic,retain)NSMutableArray * likerIdArray;
@property (nonatomic,retain)NSMutableArray * senderIdArray;

@property (nonatomic,retain)NSMutableArray * likersArray;
@property (nonatomic,retain)NSMutableArray * sendersArray;
@property (nonatomic,retain)NSMutableArray * commentersArray;
@property (nonatomic,retain)NSMutableArray * sharersArray;


@end
