//
//  ExchangeDetailView.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeItemModel.h"

@interface ExchangeDetailView : UIView
{
    UIScrollView * sv;
}
@property(nonatomic,retain)ExchangeItemModel * model;
@property(nonatomic,copy)NSString * aid;
@property(nonatomic,copy)NSString * foodNum;

@property(nonatomic,copy)void (^jumpAddress)();
-(void)makeUI;
@end
