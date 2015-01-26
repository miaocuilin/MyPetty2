//
//  PetMain_Photo_CollectionViewCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetMain_Photo_CollectionViewCell.h"

@implementation PetMain_Photo_CollectionViewCell
-(void)dealloc
{
    [super dealloc];
    imageView = nil,[imageView release];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    imageView = [MyControl createImageViewWithFrame:CGRectMake(2, 2, self.frame.size.width-4, self.frame.size.height-4) ImageName:@""];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
}
-(void)modifyUIWithUrl:(NSString *)url
{
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        if (image) {
//            [imageView setImage:[MyControl returnSquareImageWithImage:image]];
//        }
    }];
}
@end
