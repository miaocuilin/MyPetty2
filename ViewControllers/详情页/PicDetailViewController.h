//
//  PicDetailViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-22.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "BottomMenuRootViewController.h"
#import "ClickImage.h"
#import "ASIFormDataRequest.h"

@interface PicDetailViewController : BottomMenuRootViewController <UITextViewDelegate>
{
    UIView * navView;
    UIImageView * fish;
    UILabel * zanLabel;
    ClickImage * bigImageView;
    UITextView * commentTextView;
    UIView * commentBgView;
    UIButton * bgButton;
    
    UIView * commentsBgView;
    int prepareCreateUINum;
    UILabel * topicUser;
    UIView * usersBgView;
    
    UILabel * giftNum;
    UILabel * shareNum;
    UILabel * commentNum;
    
    BOOL isLike;
    BOOL isMoreCreated;
    UIButton * menuBgBtn;
    UIView * moreView;
    int txCount;
    //判断改宠物是猫还是狗
    BOOL isMi;
    
    //判断是否在当前控制器，来限制键盘变化通知
    BOOL isInThisController;
    
    BOOL isReply;
    int replyRow;
    
    BOOL isCommentActive;
}
@property (retain, nonatomic) UIImageView * bgImageView;
@property (retain, nonatomic) IBOutlet UIScrollView *sv;
@property (retain, nonatomic) IBOutlet UIView *headerBgView;

@property (retain, nonatomic) IBOutlet UIButton *headBtn;
@property (retain, nonatomic) IBOutlet UIImageView *sex;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *cate;
@property (retain, nonatomic) IBOutlet UIButton *attentionBtn;

//评论解析数组
@property (nonatomic,retain)NSMutableArray * usrIdArray;
@property (nonatomic,retain)NSMutableArray * nameArray;
@property (nonatomic,retain)NSMutableArray * bodyArray;
@property (nonatomic,retain)NSMutableArray * createTimeArray;
//
@property (nonatomic,retain)NSArray * likersArray;
@property (nonatomic,retain)NSMutableArray * likerTxArray;
@property (nonatomic,retain)NSMutableArray * senderTxArray;
//
@property (nonatomic,retain)NSMutableArray * txTotalArray;
@property (nonatomic,retain)NSMutableArray * txTypeTotalArray;

@property (nonatomic,copy)NSString * createTime;
//上一个界面传过来的img_id,usr_id
@property (nonatomic,copy)NSString * img_id;
@property (nonatomic,copy)NSString * usr_id;

//头像
@property (nonatomic,copy)NSString * headImageURL;
//照片
@property (nonatomic,copy)NSString * imageURL;
//名称
@property (nonatomic,copy)NSString * petName;
//种族
@property (nonatomic,copy)NSString * cateName;
//点赞数
@property (nonatomic,copy)NSString * num;
//描述
@property (nonatomic,copy)NSString * cmt;
//点赞者
@property (nonatomic,copy)NSString * likers;
//@用户
@property (nonatomic,copy)NSString * relates;
//评论
@property (nonatomic,copy)NSString * comments;
@property (nonatomic,copy)NSString * aid;
//礼物数
@property (nonatomic,copy)NSString * gifts;
@property (nonatomic,copy)NSString * shares;
@property (nonatomic,copy)NSString * topic_name;
@property (nonatomic,copy)NSString * topic_id;
//送礼物的人的usr_id,用逗号隔开
@property (nonatomic,copy)NSString * senders;

@property (nonatomic)BOOL is_follow;

//@property (nonatomic,retain)NSMutableArray * petInfoArray;
@property (nonatomic,copy)NSString * replyPlaceHolder;
@end
