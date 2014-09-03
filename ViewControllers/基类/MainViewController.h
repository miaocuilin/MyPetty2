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
@end
