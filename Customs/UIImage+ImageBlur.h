//
//  UIImage+ImageBlur.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-22.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <objc/runtime.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
@import Accelerate;
#endif
#import <float.h>

@interface UIImage (ImageBlur)
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end
