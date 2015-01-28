//
//  MyController.h
//  MyPetty
//
//  Created by miaocuilin on 15/1/28.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyController : NSObject
#pragma mark --创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text;
#pragma mark --创建View
+(UIView*)createViewWithFrame:(CGRect)frame;
#pragma mark --创建imageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName;
#pragma mark --创建button
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title;
#pragma mark --创建UITextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font;
@end
