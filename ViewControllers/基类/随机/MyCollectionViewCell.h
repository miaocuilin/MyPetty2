//
//  MyCollectionViewCell.h
//  collectionView
//
//  Created by zhangjr on 14-9-2.
//  Copyright (c) 2014年 自学OC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic)  UIImageView *imageView;


@property (strong, nonatomic)  UIImageView *bottomBar;


//@property (strong, nonatomic) CBAutoScrollLabel *productNameLbl;

@property (strong, nonatomic) UILabel *priceLbl;
@end
