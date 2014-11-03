//
//  PetRecommendCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@interface PetRecommendCell : UITableViewCell <iCarouselDataSource,iCarouselDelegate>
{
    iCarousel * carousel;
    int imageCount;
}
@end
