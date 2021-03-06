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
    UIView * usersBgView;
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
@property (nonatomic,retain)NSMutableArray * likerTxArray;
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
//评论
@property (nonatomic,copy)NSString * comments;
@end
