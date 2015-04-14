//
//  DiscoverHandPickedCell.h
//  MyPetty
//
//  Created by miaocuilin on 15/4/3.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendModel.h"

@interface DiscoverHandPickedCell : UITableViewCell
//是否是关注 决定 关注按钮/发布时间按钮
@property(nonatomic)BOOL isAttention;

@property(nonatomic,strong)void (^toolBlock)(NSInteger);
@property(nonatomic,strong)void (^headBlock)();
@property(nonatomic,strong)void (^pBlock)();
@property(nonatomic,strong)void (^bigImageBtnBlock)();
-(void)modifyUI:(RecommendModel *)model;

@property (retain, nonatomic) IBOutlet UIImageView *bigImage;
@end
