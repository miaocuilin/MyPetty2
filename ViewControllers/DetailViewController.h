//
//  DetailViewController.h
//  Waterflow
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 yangjw . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClickImage.h"
//#import "AMBlurView.h"
#import "ASIFormDataRequest.h"
@interface DetailViewController : UIViewController <UIScrollViewDelegate,UITextViewDelegate>
{
    UIScrollView * sv;
    
    //大图
    ClickImage * imageView;
    UIImageView * heart;
    UILabel * numLabel;
    UILabel * label1;
    
    UIView * bgView;
    UIView * view;
    UIView * view1;
    UIView * view2;
    
    BOOL isLike;
    UIView * successView;
    
    BOOL isClicked;
    
//    AMBlurView * shareBgView;
    UIView * shareBgView;
    UIButton * shareBgButton1;
    UIView * bgView1;
    
    UILabel * timeLabel;
    //两条杠中间加头像
    UIView * txsView;
    
//    UILabel * commentLabel;
    //评论总的view，刷新时用于一次清除所有评论
    UIView * commentView;
    
    float commentHeight;
    
    //发表评论相关UI
    UIButton * bgButton;
    UIView * commentBgView;
    UITextView * commentTextView;
    UIButton * sendButton;
    BOOL isCommentCreated;
    
    CGSize textViewSize;
    //为了禁止在用户评论的时候点击分享
    UIButton * buttonRight;
}
//头像
@property (nonatomic,copy)NSString * headImageURL;
//照片
@property (nonatomic,copy)NSString * imageURL;
//名称
@property (nonatomic,copy)NSString * name;
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


@property (nonatomic,retain)NSArray * likersArray;
@property (nonatomic,retain)NSMutableArray * likerTxArray;
@property (nonatomic,copy)NSString * createTime;

//上一个界面传过来的img_id,usr_id
@property (nonatomic,copy)NSString * img_id;
@property (nonatomic,copy)NSString * usr_id;

//评论解析数组
@property (nonatomic,retain)NSMutableArray * usrIdArray;
@property (nonatomic,retain)NSMutableArray * nameArray;
@property (nonatomic,retain)NSMutableArray * bodyArray;
@property (nonatomic,retain)NSMutableArray * createTimeArray;
                                                                                           
@end
