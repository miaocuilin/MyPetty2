//
//  LargeImage.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargeImage : UIView
{
    UIScrollView * sv;
    UIImageView * imageView;
    UITapGestureRecognizer * tap;
}
-(void)modifyUIWithImage:(UIImage *)image;
@end
