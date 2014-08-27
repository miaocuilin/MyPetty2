//
//  MyCountryMessageCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"
@interface MyCountryMessageCell : UITableViewCell
{
    UIView * grayLine;
    UILabel * time;
    UILabel * body;
    UIImageView * typeImageView;
    ClickImage * photoImage;
    
    UIButton * sendOne;
    UIButton * playOne;
    UIButton * touchOne;
}
-(void)modifyWithType:(int)type;
@end
