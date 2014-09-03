//
//  MyCollectionViewCell.m
//  collectionView
//
//  Created by zhangjr on 14-9-2.
//  Copyright (c) 2014年 自学OC. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (id)initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.imageView];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    }
    
    return self;
    
}
@end
