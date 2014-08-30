//
//  DefaultPetCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultPetCell : UITableViewCell
{
    int rowNum;
}
@property (retain, nonatomic) IBOutlet UIImageView *headImage;
@property (retain, nonatomic) IBOutlet UIImageView *crownImage;
@property (retain, nonatomic) IBOutlet UIImageView *sexImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *cateAndAge;
@property (retain, nonatomic) IBOutlet UIButton *defaultBtn;
@property (copy, nonatomic)void (^defaultBtnClick)(int);

-(void)configUIWithSex:(int)sex Name:(NSString *)name Cate:(NSString *)cate Age:(NSString *)age Default:(BOOL)isDefault row:(int)row;
@end
