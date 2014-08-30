//
//  FavoriteViewController.h
//  MyPetty
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

//#import "RootViewController.h"
#import <UIKit/UIKit.h>
struct _size{
    int Width;
    int Height;
};

//struct _image{
//    UIImage * image;
//};
@interface FavoriteViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    BOOL _reloading;
    
    
    UITableView * tv;
    int uid[200];
    
//    int Width[100];
//    int Height[100];
    struct _size imageSize[200];
//    struct _image imageArray[100];
    int count;
}
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)NSMutableArray * userDataArray;
@property(nonatomic,copy)NSString * usr_id;
//@property(nonatomic,retain)id imageArray[100];

//@property(nonatomic,copy)NSString * name;
//@property(nonatomic,copy)NSString * headImageURL;
@end
