//
//  MyPetViewController.h
//  MyPetty
//
//  Created by Aidi on 14-5-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
struct _size3{
    int Width;
    int Height;
};

@interface MyPetViewController : UIViewController
{
    struct _size3 imageSize[100];
    BOOL isFriend[100];
    BOOL isFansFriend[100];
    int experience;
    int fansButtonIndex;
    UIScrollView * sv;
    //确保刷新后还在粉丝页
    int oriIndex;
}
@property(nonatomic,retain)NSArray * array1;
@property(nonatomic,copy)void(^myBlock)(void);
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSMutableArray * dataArrayPhotos;
@property(nonatomic,retain)NSMutableArray * attentionDataArray;
@property(nonatomic,retain)NSMutableArray * fansDataArray;
@property(nonatomic,copy)NSString * img_id;
@property(nonatomic,copy)NSString * usr_id;
@property(nonatomic,retain)NSArray * expArray;
@end
