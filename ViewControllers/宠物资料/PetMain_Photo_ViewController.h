//
//  PetMain_Photo_ViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PetMain_Photo_ViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIView * navView;
    UICollectionView * collection;
}
@property(nonatomic,retain)NSMutableArray * dataArray;
@property(nonatomic,retain)PetInfoModel * model;
@property(nonatomic,copy)NSString * lastImg_id;
@end
