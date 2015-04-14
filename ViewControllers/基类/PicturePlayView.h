//
//  PicturePlayView.h
//  MyPetty
//
//  Created by miaocuilin on 15/3/26.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureplayDelegate <NSObject>

-(void)selectedIndex:(NSInteger)index;

@end

@interface PicturePlayView : UIView

@property(nonatomic)BOOL isFromBanner;

@property(nonatomic,assign)id <PictureplayDelegate> delegate;
@property(nonatomic,strong)void (^selectIndex)(NSInteger);

-(instancetype)initWithFrame:(CGRect)frame UrlArray:(NSArray *)array OtherView:(BOOL)otherView isFromBanner:(BOOL)fromBanner;
@end
