//
//  PhotoModel.h
//  MyPetty
//
//  Created by Aidi on 14-6-8.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

@property(nonatomic,copy)NSString * comments;
@property(nonatomic,copy)NSString * cmt;
@property(nonatomic,copy)NSString * create_time;
@property(nonatomic,copy)NSString * img_id;
@property(nonatomic,copy)NSString * likes;
@property(nonatomic,copy)NSString * likers;
@property(nonatomic,copy)NSString * updata_time;
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)NSString * usr_id;

@property(nonatomic,copy)NSString * headImage;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * detail;

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * tx;
@property(nonatomic,copy)NSString * aid;
@property(nonatomic,copy)NSString * type;

@property(nonatomic)int width;
@property(nonatomic)int height;
@end
