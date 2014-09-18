//
//  QuickGiftCellectionViewCell.m
//  MyPetty
//
//  Created by zhangjr on 14-9-18.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "QuickGiftCellectionViewCell.h"
#import "GiftShopModel.h"
@implementation QuickGiftCellectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}
- (void)makeUI
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 80, 90) ImageName:nil];
    imageView.image = [UIImage imageNamed:@"product_bg.png"];
    [self.contentView addSubview:imageView];
//    [imageView release];
    
    productImageView = [MyControl createImageViewWithFrame:CGRectMake(imageView.frame.size.width/2-36, imageView.frame.size.height/2-24, 72, 48) ImageName:[NSString stringWithFormat:@"bother%d_2.png",1]];
    [imageView addSubview:productImageView];
    productLabel = [MyControl createLabelWithFrame:CGRectMake(20, 10, imageView.frame.size.width-20, 10) Font:10 Text:@"宠物球球"];
    numberCoinLabel = [MyControl createLabelWithFrame:CGRectMake(32, 75, 50, 10) Font:13 Text:@"200"];
    numberCoinLabel.textColor =BGCOLOR;
    [imageView addSubview:numberCoinLabel];
    coinImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 75, 10, 10) ImageName:@"gold.png"];
    [imageView addSubview:coinImageView];
    
    productLabel.font = [UIFont boldSystemFontOfSize:10];
    productLabel.textColor = [UIColor grayColor];
    [imageView addSubview:productLabel];
    
    UILabel *leftCornerLabel1 =[MyControl createLabelWithFrame:CGRectMake(-3, 4, 20, 8) Font:7 Text:@"人气"];
    leftCornerLabel1.textAlignment = NSTextAlignmentCenter;
    leftCornerLabel1.font = [UIFont boldSystemFontOfSize:8];
    CGAffineTransform transform =  CGAffineTransformMakeRotation(-45.0 *M_PI / 180.0);
    leftCornerLabel1.transform = transform;
    leftCornerLabel2 = [MyControl createLabelWithFrame:CGRectMake(3, 10, 20, 8) Font:10 Text:@"+50"];
    leftCornerLabel2.textAlignment = NSTextAlignmentCenter;
    leftCornerLabel2.transform = transform;
    [imageView addSubview:leftCornerLabel1];
    [imageView addSubview:leftCornerLabel2];
}
- (void)configUI:(GiftShopModel *)model
{
    productImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model.no]];
    productLabel.text = model.name;
    numberCoinLabel.text = model.price;
    if ([model.add_rq intValue] >0) {
        leftCornerLabel2.text = [NSString stringWithFormat:@"+%@",model.add_rq];
    }else{
        leftCornerLabel2.text = model.add_rq; 
    }
    
}
- (void)configUI2:(GiftShopModel *)model itemNum:(NSString *)item
{
    productImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model.no]];
    productLabel.text = model.name;
    if ([model.add_rq intValue] >0) {
        leftCornerLabel2.text = [NSString stringWithFormat:@"+%@",model.add_rq];
    }else{
        leftCornerLabel2.text = model.add_rq;
    }
    coinImageView.image = [UIImage imageNamed:@"giftIcon.png"];
    numberCoinLabel.text = [NSString stringWithFormat:@"X %@",item];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
