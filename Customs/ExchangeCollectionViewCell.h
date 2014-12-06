//
//  ExchangeCollectionViewCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/6.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeCollectionViewCell : UICollectionViewCell

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *weightLabel;
@property (retain, nonatomic) IBOutlet UIButton *exChange;
@property (retain, nonatomic) IBOutlet UIImageView *goodImageView;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;

@end
