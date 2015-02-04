//
//  AccountViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIView * navView;
    UIImageView * head;
    UITableView * tv;
    
    BOOL isConfVersion;
    //判断是否有我自己创建的宠物
    BOOL hasMyPet;
}
@property(nonatomic,retain)NSArray * array;
@property(nonatomic,copy)NSString * pet_id;
@end
