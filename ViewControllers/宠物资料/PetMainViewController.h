//
//  PetMainViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"


@interface PetMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * tv;
    UIImageView * headBlurImage;
    UIButton * pBtn;
    ClickImage * headImageView;
    UIButton * headBtn;
    UIButton * userHeadBtn;
}
@property(nonatomic,copy)NSString * aid;
@end
