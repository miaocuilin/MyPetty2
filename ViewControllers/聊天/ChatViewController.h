//
//  ChatViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
{
    UIView * navView;
    
}
- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup;

@property (nonatomic) BOOL isFromCard;
@property (nonatomic,copy) NSString * nickName;
@property (nonatomic,copy) NSString * other_nickName;
@property (nonatomic,copy) NSString * tx;
@property (nonatomic,copy) NSString * other_tx;
@end
