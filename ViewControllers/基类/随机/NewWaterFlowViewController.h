//
//  NewWaterFlowViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/10/24.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

//struct size{
//    int width;
//    int height;
//}size;

@interface NewWaterFlowViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UIView * navView;
    UITableView * bgTv;
    
    UITableView * tv;
    UITableView * tv2;
    
    UIButton * camara;
    
//    struct size;
}
@property (nonatomic,retain) UIButton * menuBtn;

@property (nonatomic,retain) NSMutableArray * dataArray;

//@property (nonatomic,retain) NSMutableArray * widthArray;
//@property (nonatomic,retain) NSMutableArray * heightArray;

@property (nonatomic,copy) NSString * lastImg_id;
@end
