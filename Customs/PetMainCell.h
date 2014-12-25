//
//  PetMainCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PetMainCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *num;

-(void)modifyUIWithIndex:(int)index Num:(NSString *)num;
@end
