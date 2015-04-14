//
//  RecommendModel.h
//  MyPetty
//
//  Created by miaocuilin on 15/4/8.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendModel : NSObject

@property(nonatomic,strong)NSString * aid;
@property(nonatomic,strong)NSString * cmt;
@property(nonatomic,strong)NSString * comments;
@property(nonatomic,strong)NSString * img_id;
@property(nonatomic,strong)NSString * likers;
@property(nonatomic,strong)NSString * likes;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * tx;
@property(nonatomic,strong)NSString * url;
@property(nonatomic,strong)NSString * topic_id;
@property(nonatomic,strong)NSString * topic_name;
@property(nonatomic,strong)NSString * usr_id;
@property(nonatomic,strong)NSString * u_name;
@property(nonatomic,strong)NSString * u_tx;
@property(nonatomic,strong)NSString * create_time;
@property(nonatomic,strong)NSString * is_food;

@property(nonatomic,strong)NSMutableArray *likersTxArray;
@end
