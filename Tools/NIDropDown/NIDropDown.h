//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender;
@end 

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    UIColor * cellTextColor;
    UIFont * cellTextFont;
    UIColor * cellBgColor;
    UIColor * lineColor;
}
@property (nonatomic, retain) id <NIDropDownDelegate> delegate;

-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b:(CGFloat *)height:(NSArray *)arr;
-(void)setCellTextColor:(UIColor *)color Font:(UIFont *)font BgColor:(UIColor *)bgColor lineColor:(UIColor *)LineColor;
-(void)setDefaultCellType;
@end
