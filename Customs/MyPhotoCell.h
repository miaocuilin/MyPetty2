//
//  MyPhotoCell.h
//  MyPetty
//
//  Created by Aidi on 14-6-19.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"
@interface MyPhotoCell : UITableViewCell
{
    UILabel * timeLabel;
    UILabel * numLabel;
    UIImageView * heart;
    UIButton * heartButton;
    
    BOOL isLike;
    //
    UIImageView * fish;
    UILabel * zanLabel;
    
    BOOL isMi;
}
@property(nonatomic,copy)void (^unRegister)(void);

@property(nonatomic,retain)UIImageView * bigImageView;
@property(nonatomic,retain)NSArray * likersArray;
@property(nonatomic,copy)NSString * img_id;
-(void)configUI:(PhotoModel *)model type:(NSString *)type;
@end
