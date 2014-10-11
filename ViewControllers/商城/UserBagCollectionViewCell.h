//
//  UserBagCollectionViewCell.h
//  MyPetty
//
//  Created by zhangjr on 14-9-5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserBagCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView * bgImageView;
@property (nonatomic,strong)UIImageView * presentImageView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * presentNumberLabel;
@property (nonatomic,strong)UILabel * popNumberLabel;

-(void)configUIWithItemId:(NSString *)itemId Num:(NSString *)num;
@end
