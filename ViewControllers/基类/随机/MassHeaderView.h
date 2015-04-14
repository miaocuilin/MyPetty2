//
//  MassHeaderView.h
//  MyPetty
//
//  Created by miaocuilin on 15/3/26.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MassHeaderView : UICollectionReusableView
@property(strong,nonatomic)void (^headClickBlock)(NSInteger);
@end
