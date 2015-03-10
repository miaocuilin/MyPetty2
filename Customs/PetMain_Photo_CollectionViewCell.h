//
//  PetMain_Photo_CollectionViewCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PetMain_Photo_CollectionViewCell : UICollectionViewCell
{
    UIImageView * imageView;
    
}
-(void)modifyUIWithUrl:(NSString *)url;
@end
