//
//  TipsView.h
//  MyPetty
//
//  Created by zhangjr on 14-9-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum TIPSNAME{
    REGISTER,
    JOINCOUNTRY,
    EXITCOUNTRY,
    ATTENTION,
    EXITATTENTION
}TIPSNAME;
@interface TipsView : UIView
{
    UIImageView *tipsImageView;
}
- (id)initWithFrame:(CGRect)frame tipsName:(TIPSNAME)tipsName;
@end
