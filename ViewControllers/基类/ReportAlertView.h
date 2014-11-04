//
//  ReportAlertView.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportAlertView : UIView
@property(nonatomic,retain)UIImageView * bgImageView;
@property(nonatomic,retain)UIButton * closeBtn;
@property(nonatomic,retain)UIButton * confirmBtn;
@property(nonatomic,retain)UIButton * cancelBtn;
@property(nonatomic,retain)UILabel * label;
@property(nonatomic,retain)UILabel * label2;

@property(nonatomic,retain)UIView * alphaView;
@property(nonatomic,copy)void (^jump)(void);

//1.拉黑用户  2.举报评论  3.举报人 4.举报图片
@property(nonatomic)int AlertType;
@property(nonatomic,copy)void (^confirmClick)(void);
-(void)makeUI;
@end
