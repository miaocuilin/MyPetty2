//
//  MyHomeViewController.h
//  MyPetty
//
//  Created by Aidi on 14-6-18.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
//#import "AMBlurView.h"
@interface MyHomeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UILabel * numLabel1;
    UIButton * button1;
    UILabel * numLabel2;
    UIButton * button2;
    UILabel * numLabel3;
    UIButton * button3;
    UILabel * photoLabel;
    UILabel * attentionLabel;
    UILabel * fansLabel;
    UILabel * shopLabel;
    
    UITableView * tvPhotos;
    UITableView * tvAttention;
    UITableView * tvFans;
    
    BOOL isFansFriend[100];
    int fansButtonIndex;
    
    
    UIImageView * headImageView;
    ASIFormDataRequest * _request;
    
    BOOL isCamara;
    
    //attention为1 fans为2
    int attentionOrFans;
    
    UIView * amView;
    
    UIImageView * headImage;
    UILabel * sinaName;
    UIButton * sina;
    
    //final_id
    int final_id_attention;
    int final_id_fans;
}
@property(nonatomic,retain)UIButton * buttonLeft;
@property(nonatomic,retain)NSMutableArray * userDataArray;
@property(nonatomic,retain)NSMutableArray * photosDataArray;
@property(nonatomic,retain)NSMutableArray * attentionDataArray;
@property(nonatomic,retain)NSMutableArray * fansDataArray;

@property(nonatomic,copy)NSString * lastImg_id;
//@property(nonatomic,copy)NSString * lastAttention_id;
//@property(nonatomic,copy)NSString * lastFans_id;
@property(nonatomic,copy)NSString * usr_id;

@property(nonatomic,retain)UIImage * tempImage;
@end
