//
//  MyCollectionViewLayout.h
//  collectionView
//
//  Created by zhangjr on 14-9-2.
//  Copyright (c) 2014年 自学OC. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark WaterF

@protocol WaterFLayoutDelegate <UICollectionViewDelegate>

@required
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section;
@end
@interface MyCollectionViewLayout : UICollectionViewLayout
{
    float x;
    float leftY;
    float rightY;
}
@property float itemWidth;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;
/// The delegate will point to collection view's delegate automatically.
@property (nonatomic, assign) id <WaterFLayoutDelegate> delegate;
/// Array to store attributes for all items includes headers, cells, and footers
@property (nonatomic, strong) NSMutableArray *allItemAttributes;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@end
