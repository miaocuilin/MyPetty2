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
    UIImageView * bgImageView;
    UIView * navView;
    UITableView * bgTv;
    
//    UITableView * tv;
    UITableView * tv2;
    
    UIButton * camara;
    
    float height1,height2;
    
    //记录self.dataArray的数量，加载更多时需要记录循环开始数
    int count;
//    struct size;
    int tempNum;
    int tempCount;
    
    int page;
}
@property (nonatomic,retain) UITableView * tv;

@property (nonatomic,retain) UIButton * menuBtn;

@property (nonatomic,retain) NSMutableArray * dataArray;

@property (nonatomic,retain) NSMutableArray * dataArray1;
@property (nonatomic,retain) NSMutableArray * dataArray2;

@property (nonatomic,retain) NSMutableArray * tempArray;
//@property (nonatomic,retain) NSMutableArray * widthArray;
//@property (nonatomic,retain) NSMutableArray * heightArray;

@property (nonatomic,copy) NSString * lastImg_id;
@end
