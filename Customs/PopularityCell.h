//
//  PopularityCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopularityCell : UITableViewCell
{
    UIButton * btn;
    int num;
}
@property (retain, nonatomic) IBOutlet UIImageView *headImageView;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *rqNum;
@property (retain, nonatomic) IBOutlet UIImageView *medal;
@property (retain, nonatomic) IBOutlet UILabel *rank;
@property (retain, nonatomic) IBOutlet UIImageView *upDown;
@property(nonatomic,copy)void (^cellClick)(int);
-(void)configUIWithName:(NSString *)Name rq:(NSString *)Rq rank:(int)rank upOrDown:(BOOL)isUp shouldLarge:(BOOL)large;
@end
