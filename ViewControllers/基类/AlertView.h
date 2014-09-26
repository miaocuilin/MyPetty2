//
//  AlertView.h
//  MyPetty
//
//  Created by miaocuilin on 14-9-26.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView
{
    
}
@property(nonatomic,retain)UIImageView * bgImageView;
@property(nonatomic,retain)UIButton * closeBtn;
@property(nonatomic,retain)UIButton * confirmBtn;

@property(nonatomic,retain)UIView * alphaView;
@property(nonatomic,copy)void (^jump)(void);
@end
