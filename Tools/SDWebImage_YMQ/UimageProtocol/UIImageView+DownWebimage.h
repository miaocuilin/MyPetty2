//
//  UIImageView+DownWebimage.h
//  AlumniThrough
//
//  Created by song on 13-11-20.
//  Copyright (c) 2013年 BinSong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DownWebimage)


-(void)setWebImage:(NSURL *)aUrl placeHolder:(UIImage *)placeHolder downloadFlag:(int)flag ;
@end
