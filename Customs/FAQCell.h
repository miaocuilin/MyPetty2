//
//  FAQCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-9-11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQCell : UITableViewCell
{
    UILabel * queLabel;
    UILabel * ansLabel;
}
-(void)configUIWithQue:(NSString *)que Ans:(NSString *)ans;
@end
