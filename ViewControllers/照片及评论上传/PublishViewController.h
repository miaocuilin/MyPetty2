//
//  PublishViewController.h
//  MyPetty
//
//  Created by Aidi on 14-7-1.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"


@interface PublishViewController : UIViewController
{
    ASIFormDataRequest * _request;
    UIImageView * bgImageView;
    UIImageView * bigImageView;
    
    UIView * textBgView;
    UIView * navView;
    UIScrollView * sv;
    UILabel * sinaLabel;
    UILabel * weChatLabel;
    
    UIButton * topic;
    UIButton * users;
}
//@property (nonatomic,retain)UIImageView * bgImageView;
@property (nonatomic,retain)UIImage * oriImage;
//@property (nonatomic,retain)AFPhotoEditorController * af;

@end
