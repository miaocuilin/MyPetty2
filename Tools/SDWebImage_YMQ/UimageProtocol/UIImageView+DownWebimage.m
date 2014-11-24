//
//  UIImageView+DownWebimage.m
//  AlumniThrough
//
//  Created by song on 13-11-20.
//  Copyright (c) 2013年 BinSong. All rights reserved.
//

#import "UIImageView+DownWebimage.h"

@implementation UIImageView (DownWebimage)


-(void)setWebImage:(NSURL *)aUrl placeHolder:(UIImage *)placeHolder downloadFlag:(int)flag
    {
         
        NSString *imagefile= [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/%d.jpg",aUrl.description.hash];
        
        NSFileManager *fm=[NSFileManager defaultManager];
        
        if([fm fileExistsAtPath:imagefile])
        {
            self.image  =[UIImage imageWithContentsOfFile:imagefile];
        }
        else
        {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            //没有下载过这张图片的情况
                [self setImage:placeHolder];
            
            //配置下载路径
            NSString *path=[NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/%d.jpg",aUrl.description.hash];
            
            NSData *data=[NSData dataWithContentsOfFile:path];
            if (!data) {
              //  NSLog(@"准备下载到沙盒路径:%@",path);
                data=[NSData dataWithContentsOfURL:aUrl];
                [data writeToFile:path atomically:YES];
            }
                
           
            dispatch_async(dispatch_get_main_queue(), ^{
                //UITableViewCell
                NSString *imagefile= [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/%d.jpg",aUrl.description.hash];
                
                            NSFileManager *fm=[NSFileManager defaultManager];
                
                            if([fm fileExistsAtPath:imagefile])
                            {
                                
                                if (self.tag == flag) {
                                    CATransition *trans=[[CATransition alloc]init];
                                    [trans setType:kCATransitionFromBottom];
                                    [trans setSubtype:kCATransitionFromBottom];
                                    [trans setDuration:0.01];
                                    [self.layer addAnimation:trans forKey:nil];
                                     UIImage *image=[UIImage imageWithData:data];
                                    
                                  /*  if (data.length>100000)//大于100kb缩放
                                    {
                                      //  [self imageByScalingAndCroppingForSize:image.size];
                                        
                                        //[self createThumbImage:image size:image.size percent:0.6 toPath:nil];
                                       // image.size.width = 240;
                                      
                                        UIGraphicsBeginImageContext(image.size);
                                        // Tell the old image to draw in this new context, with the desired
                                        // new size
                                        [image drawInRect:CGRectMake(0,0,image.size.width/2,image.size.height/2)];
                                        // Get the new image from the context
                                        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                                        // End the context
                                        UIGraphicsEndImageContext();
                                        [self setImage:newImage];
                                    }else
                                    {
                                    NSLog(@"date.length%d=hhh====%fwwwww=====%f",data.length,image.size.height,image.size.width);
                                    [self setImage:image];
                                    }
                                    */
                                     [self setImage:image];
                                }
                            }else
                            {
                                [self setImage:placeHolder];
                            }
        
              });

        });
            
    }
}


- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,240,128)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
-(void)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent toPath:(NSString *)thumbPath{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    CGFloat widthFactor = thumbSize.width / width;
    CGFloat heightFactor = thumbSize.height / height;
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    }
    else {
        scaleFactor = heightFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    if (widthFactor > heightFactor)
    {
        thumbPoint.y = (thumbSize.height - scaledHeight) * 0.5;
    }
    else if (widthFactor < heightFactor)
    {
        thumbPoint.x = (thumbSize.width - scaledWidth) * 0.5;
    }
    UIGraphicsBeginImageContext(thumbSize);
    CGRect thumbRect = CGRectZero;
    thumbRect.origin = thumbPoint;
    thumbRect.size.width  = scaledWidth;
    thumbRect.size.height = scaledHeight;
    [image drawInRect:thumbRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, percent);
    [thumbImageData writeToFile:thumbPath atomically:NO];
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self.image;
        UIImage *newImage = nil;
        CGSize imageSize = sourceImage.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        CGFloat targetWidth = targetSize.width;
        CGFloat targetHeight = targetSize.height;
        CGFloat scaleFactor = 0.0;
        CGFloat scaledWidth = targetWidth;
        CGFloat scaledHeight = targetHeight;
        CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
        if (CGSizeEqualToSize(imageSize, targetSize) == NO)
                    {
                        CGFloat widthFactor = targetWidth / width;
                        CGFloat heightFactor = targetHeight / height;
                        if (widthFactor > heightFactor)
                                    scaleFactor = widthFactor; // scale to fit height
                        else
                                    scaleFactor = heightFactor; // scale to fit width
                       scaledWidth  = width * scaleFactor;
                        scaledHeight = height * scaleFactor;
                        // center the image
                        if (widthFactor > heightFactor)
                                    {
                                        thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
                                        }
                        else
                                    if (widthFactor < heightFactor)
                                                {
                                                    thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
                                                    }
                        }
        UIGraphicsBeginImageContext(targetSize); // this will crop
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width  = scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        [sourceImage drawInRect:thumbnailRect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        if(newImage == nil)
                  //  NSLog(@"could not scale image");
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
        return newImage;
        }
@end
