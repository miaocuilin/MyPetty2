//
//  MainViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BottomMenuRootViewController.h"
@interface MainViewController : BottomMenuRootViewController <UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UIButton * camara;
    UIView * navView;
    UIScrollView * sv;
    BOOL isCreated[3];
    UISegmentedControl * sc;
    
    BOOL isCamara;
    UIActionSheet * sheet;
    
    int segmentClickIndex;
}
@property(nonatomic,retain)UIButton * alphaBtn;

@property(nonatomic,retain)UIButton * menuBtn;
@property(nonatomic,retain)UIImage * oriImage;

//用来记录当前头像名称，和本地存储的tx对比，如果不等则换头像，等则不换。
//@property(nonatomic,copy)NSString * currentTx;
@end
