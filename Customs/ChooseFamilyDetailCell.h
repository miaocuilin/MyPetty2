//
//  ChooseFamilyDetailCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-7.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseFamilyDetailCell : UITableViewCell
{
    CGRect oriRect;
    UIScrollView * sv;
    BOOL isAdded;
    int height[4];
    
    UIImageView * sex;
    UILabel * name;
    UILabel * location;
    UIImageView * headImageView;
}
@property (nonatomic,retain)NSArray * imagesArray;

-(void)configUI:(NSDictionary *)dic;
@end
