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
    UIButton * publishTo;
    
    UIButton * publishButton;
    
    //用于限制键盘change的通知
    BOOL isInPublish;
}
//@property (nonatomic,retain)UIImageView * bgImageView;
@property (nonatomic,retain)UIImage * oriImage;
//@property (nonatomic,retain)AFPhotoEditorController * af;
@property (nonatomic,copy)NSString * usr_ids;

@end
