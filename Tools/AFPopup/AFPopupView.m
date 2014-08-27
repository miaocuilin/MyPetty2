//
//  AFPopupView.m
//  AFPopup
//
//  Created by Alvaro Franco on 3/7/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import "AFPopupView.h"
#import <QuartzCore/QuartzCore.h>

#import <objc/runtime.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
@import Accelerate;
#endif
#import <float.h>

@interface UIImage (ImageBlur)
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
@implementation UIImage (ImageBlur)
// This method is taken from Apple's UIImageEffects category provided in WWDC 2013 sample code
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}
@end
#endif


#define CATransform3DPerspective(t, x, y) (CATransform3DConcat(t, CATransform3DMake(1, 0, 0, x, 0, 1, 0, y, 0, 0, 1, 0, 0, 0, 0, 1)))
#define CATransform3DMakePerspective(x, y) (CATransform3DPerspective(CATransform3DIdentity, x, y))

CG_INLINE CATransform3D
CATransform3DMake(CGFloat m11, CGFloat m12, CGFloat m13, CGFloat m14,
				  CGFloat m21, CGFloat m22, CGFloat m23, CGFloat m24,
				  CGFloat m31, CGFloat m32, CGFloat m33, CGFloat m34,
				  CGFloat m41, CGFloat m42, CGFloat m43, CGFloat m44)
{
	CATransform3D t;
	t.m11 = m11; t.m12 = m12; t.m13 = m13; t.m14 = m14;
	t.m21 = m21; t.m22 = m22; t.m23 = m23; t.m24 = m24;
	t.m31 = m31; t.m32 = m32; t.m33 = m33; t.m34 = m34;
	t.m41 = m41; t.m42 = m42; t.m43 = m43; t.m44 = m44;
	return t;
}

@interface AFPopupView ()

@property (nonatomic, strong) UIView *modalView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *backgroundShadowView;
@property (nonatomic, strong) UIImageView *renderImage;

@end

@implementation AFPopupView

+(AFPopupView *)popupWithView:(UIView *)popupView {
    
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UIView *rootView = keyWindow.rootViewController.view;
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIView * rootView = keyWindow.subviews[0];
    
    CGRect rect = CGRectMake(0, 0, rootView.frame.size.width, rootView.frame.size.height);
    
    if (rootView.transform.b != 0 && rootView.transform.c != 0) {
        rect = CGRectMake(0, 0, rootView.frame.size.height, rootView.frame.size.width);
    }
    
    AFPopupView *view = [[AFPopupView alloc] initWithFrame:rect];
    
    view.modalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    view.modalView.backgroundColor = [UIColor clearColor];
    view.modalView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    view.blackView = [[UIView alloc] initWithFrame:view.frame];
    view.blackView.backgroundColor = [UIColor blackColor];
    view.blackView.autoresizingMask = view.modalView.autoresizingMask;
    
    view.backgroundShadowView = [[UIView alloc] initWithFrame:view.frame];
    view.backgroundShadowView.backgroundColor = [UIColor blackColor];
    view.backgroundShadowView.alpha = 0.0;
    view.backgroundShadowView.autoresizingMask = view.modalView.autoresizingMask;
    
    view.renderImage = [[UIImageView alloc] initWithFrame:view.frame];
    view.renderImage.autoresizingMask = view.modalView.autoresizingMask;
    view.renderImage.contentMode = UIViewContentModeScaleToFill;
    
    [view.modalView addSubview:popupView];
    [view addSubview:view.blackView];
    [view addSubview:view.renderImage];
    [view addSubview:view.backgroundShadowView];
    [view addSubview:view.modalView];
    
    UITapGestureRecognizer *hideGesture = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(hideByTap)];
    [view.backgroundShadowView addGestureRecognizer:hideGesture];
    
    return view;
}

-(void)show {
    
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UIView *rootView = keyWindow.rootViewController.view;
    UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIView * rootView = keyWindow.subviews[0];
    
    CGRect rect = CGRectMake(0, 0, rootView.frame.size.width, rootView.frame.size.height);
    if(rootView.transform.b != 0 && rootView.transform.c != 0)
        rect = CGRectMake(0, 0, rootView.frame.size.height, rootView.frame.size.width);
    self.frame = rect;
    
    UIImage *rootViewRenderImage = [self imageWithView:rootView];
    
    _renderImage.image = rootViewRenderImage;

    _renderImage.image =[_renderImage.image applyBlurWithRadius:10.0 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    _backgroundShadowView.alpha = 0.0;
    [rootView addSubview:self];
    _modalView.center = CGPointMake(self.frame.size.width/2.0, _modalView.frame.size.height * 1.5);
    
    [UIView animateWithDuration:0.0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _backgroundShadowView.alpha = 0.0;
//                         _renderImage.layer.transform = CATransform3DMakePerspective(0, -0.0007);
                     }
     
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                             float newWidht = _renderImage.frame.size.width;
                             float newHeight = _renderImage.frame.size.height;
                             //                             _renderImage.frame = CGRectMake(([[UIScreen mainScreen]bounds].size.width - newWidht) / 2, 22, newWidht, newHeight);
                             _renderImage.frame = CGRectMake(0, 0, newWidht, newHeight);
                             
                             //                             _renderImage.frame = CGRectMake(0, 0, 320, 568);
                             //                             _renderImage.layer.transform = CATransform3DMakePerspective(0, 0);
                         } completion:nil];
//                         [UIView animateWithDuration:0.3 animations:^{
//                             
//                             
//                         } completion:^(BOOL finished) {
//                             [UIView animateWithDuration:0.1 animations:^{
//                             }];
//                         }];
                     }];
    
    [UIView animateWithDuration:0.0 delay:0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         _modalView.center = self.center;
                     }
                     completion:^(BOOL finished) {
                         
                     }];

}

-(void)hide {
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _modalView.center = CGPointMake(self.frame.size.width/2.0, _modalView.frame.size.height * 1.5);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _backgroundShadowView.alpha = 0.0;
//                         _renderImage.layer.transform = CATransform3DMakePerspective(0, -0.0007);
                     }
     
                     completion:^(BOOL finished) {

                         [UIView animateWithDuration:0.2 animations:^{
                             
                             _renderImage.frame = [[UIScreen mainScreen]bounds];
//                             _renderImage.layer.transform = CATransform3DMakePerspective(0, 0);
                         } completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
                     }];
}

-(void)hideByTap {
    if (_hideOnBackgroundTap) {
        [self hide];
    }
}

-(UIImage *)imageWithView:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(_renderImage.frame.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return backgroundImage;
}

@end
