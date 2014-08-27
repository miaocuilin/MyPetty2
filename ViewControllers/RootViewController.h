//
//  RootViewController.h
//  Waterflow
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 yangjw . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"
@interface RootViewController : UIViewController

{
    UIView * view;
    UIActionSheet * sheet;
    BOOL isMenuCreated;
    
    UILabel * activityNumLabel;
    UILabel * noticeNumLabel;
}
@property(nonatomic,retain)UIImage * oriImage;
//@property(nonatomic)BOOL isLogin;
//1-我的宠物页  2-Favorite页  3-相机页
//@property(nonatomic)int pageNum;
@property(nonatomic,retain)UISegmentedControl * sc;

//-(void)segmentClick:(UISegmentedControl *)segment;
-(void)cameraClick;
-(void)shouquan;
-(void)refreshMenu;
@end
