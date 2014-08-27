//
//  OtherHomeViewController.h
//  MyPetty
//
//  Created by Aidi on 14-6-10.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AMBlurView.h"
#import "ClickImage.h"
#import "AFPopupView.h"
struct _size2{
    int Width;
    int Height;
};
@interface OtherHomeViewController : UIViewController
{
    UILabel * numLabel1;
    UIButton * button1;

    UILabel * photoLabel;
    UILabel * shopLabel;
    
    UITableView * tv;
    struct _size2 imageSize[100];
    UIButton * addButton;
    BOOL isFriend;
    
    UIImageView * headImageView;
    
    UIView * amView;
    
    //隐藏imageView
    UIImageView * navImageView;
    AFPopupView * afView;
}
@property(nonatomic,retain)NSMutableArray * userDataArray;
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,copy)NSString * usr_id;

@end
