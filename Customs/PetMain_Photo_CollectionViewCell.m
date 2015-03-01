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
    imageView.image = nil;
    __block PetMain_Photo_CollectionViewCell * blockSelf = self;
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image.size.width>[UIScreen mainScreen].bounds.size.width || image.size.height>[UIScreen mainScreen].bounds.size.width) {
            imageView.image = nil;
            [MyControl thumbnailWithImage:image ImageView:imageView TargetLength:[UIScreen mainScreen].bounds.size.width];
        }
    }];
}

//-(void)receiveImage:(UIImage *)tempImage
//{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        //        [self modifyImage:tempImage];
//        NSLog(@"********超过屏幕宽度！********");
//        float length = [UIScreen mainScreen].bounds.size.width;
//        
//        float w = tempImage.size.width;
//        float h = tempImage.size.height;
//        float p = 0;
//        if (w>=h && tempImage.size.width>length) {
//            p = length/w;
//        }else if(h>w && tempImage.size.height>length){
//            p = length/h;
//        }
//        w *= p;
//        h *= p;
//        NSLog(@"%f--%f", w, h);
//        //改变图片大小
//        [MyControl thumbnailWithImage:tempImage fitInSize:CGSizeMake(w, h) ImageView:imageView];
////        CGRect rect = CGRectMake(0, 0, w, h);
////        UIGraphicsBeginImageContext(rect.size);
////        //重新绘图
////        [tempImage drawInRect:rect];
////        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
////        UIGraphicsEndImageContext();
////        dispatch_async(dispatch_get_main_queue(), ^{
////            if (image) {
////                imageView.image = image;
////            }else{
////                NSLog(@"***square thumbnail image is nil***");
//////                imageView.image = tempImage;
//////                [self receiveImage:tempImage];
////            }
////        });
//    });
//}
@end
