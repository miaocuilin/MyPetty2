//
//  PetRecommendCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetRecommendCell.h"
#import "UIImage+Reflection.h"

@implementation PetRecommendCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    imageCount = 30;
    
    carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 80, self.contentView.frame.size.width, 130)];
    carousel.delegate = self;
    carousel.dataSource = self;
    carousel.type = iCarouselTypeCoverFlow;
    [self.contentView addSubview:carousel];
    [carousel release];
}

#pragma mark -
-(NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return imageCount;
}
-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, 130, 200)];
    UIImageView * view1 = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 130, 130) ImageName:@"cat2.jpg"];
    [view addSubview:view1];
    
    UIImageView * refView = [MyControl createImageViewWithFrame:CGRectMake(0, 130, 130, 130) ImageName:@"cat2.jpg"];
    [refView setImage:[[UIImage imageNamed:@"cat2.jpg"] reflectionWithAlpha:0.5]];
    [view addSubview:refView];
    
    return view;
}
//-(NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
//{
//    return 0;
//}
//-(NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
//{
//    return 30;
//}
-(CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 200.0f;
}
- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
}
@end
