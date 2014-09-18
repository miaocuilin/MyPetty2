//
//  QuickGiftCellectionViewCell.h
//  MyPetty
//
//  Created by zhangjr on 14-9-18.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GiftShopModel;

@interface QuickGiftCellectionViewCell : UICollectionViewCell
{
    UIImageView *productImageView;
    UILabel *productLabel;
    UILabel *numberCoinLabel;
    UILabel *leftCornerLabel2;
    UIImageView *coinImageView;
}
- (void)configUI:(GiftShopModel *)model;
- (void)configUI2:(GiftShopModel *)model itemNum:(NSString *)item;
@end
