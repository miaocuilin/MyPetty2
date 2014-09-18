//
//  DetailViewController.m
//  Waterflow
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 yangjw . All rights reserved.
//

#import "DetailViewController.h"
#import "OtherHomeViewController.h"
#import "UMSocial.h"
#import "LikersListViewController.h"
#import "FTAnimation+UIView.h"
#import "MBProgressHUD.h"
@interface DetailViewController () <MONActivityIndicatorViewDelegate,MBProgressHUDDelegate>
{
    MONActivityIndicatorView *indicatorView;
    MBProgressHUD * HUD;
}
@end

@implementation DetailViewController
-(void)dealloc
{
    [self.likersArray release];
    [self.likerTxArray release];
    [self.usrIdArray release];
    [self.nameArray release];
    [self.bodyArray release];
    [self.createTimeArray release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.likerTxArray = [NSMutableArray arrayWithCapacity:0];
    //
    self.usrIdArray = [NSMutableArray arrayWithCapacity:0];
    self.nameArray = [NSMutableArray arrayWithCapacity:0];
    self.bodyArray = [NSMutableArray arrayWithCapacity:0];
    self.createTimeArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createDelayBackButton];
    self.view.backgroundColor = [UIColor whiteColor];
    self.likers = @"111";
    [self loadData];
//    [self loadUserData];
//    [self createNavigation];
    
    
//    [self createImage];
//    [self createTop];
//    [self createBottom];
    
}

//-(UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index
//{
//    return BGCOLOR;
//}

#pragma mark -数据加载
-(void)loadData
{  
    //Loading界面开始启动
    indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 4;
    indicatorView.radius = 10;
    indicatorView.internalSpacing = 3;
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];
    [indicatorView startAnimating];
    
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@dog&cat", self.img_id]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", IMAGEINFOAPI, self.img_id, sig, [ControllerManager getSID]];
    NSLog(@"imageInfoAPI:%@", url);
    
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            
            NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectForKey:@"image"];
            self.cmt = [dict objectForKey:@"cmt"];
            self.num = [dict objectForKey:@"likes"];
            self.imageURL = [dict objectForKey:@"url"];
            self.usr_id = [dict objectForKey:@"usr_id"];
            self.likers = [dict objectForKey:@"likers"];
            self.comments = [dict objectForKey:@"comments"];
            
            self.likerTxArray = [[load.dataDict objectForKey:@"data"] objectForKey:@"liker_tx"];

            self.createTime = [dict objectForKey:@"create_time"];
            [self loadUserData];
            [self createImage];
            [self.view bringSubviewToFront:indicatorView];
            
            //分析评论字符串
            [self analyseComments];
        }else{
            NSLog(@"数据加载失败");
        }
    }];
    [request release];
}
-(void)analyseComments
{
    if (!([self.comments isKindOfClass:[NSNull class]] || self.comments.length == 0)) {
        NSArray * arr1 = [self.comments componentsSeparatedByString:@";usr"];
        
        for(int i=1;i<arr1.count;i++){
            NSString * usrId = [[[[arr1[i] componentsSeparatedByString:@",name"] objectAtIndex:0] componentsSeparatedByString:@"_id:"] objectAtIndex:1];
            [self.usrIdArray addObject:usrId];
//            [usrId release];
            
            NSString * name = [[[[arr1[i] componentsSeparatedByString:@",body"] objectAtIndex:0] componentsSeparatedByString:@"name:"] objectAtIndex:1];
            [self.nameArray addObject:name];
//            [name release];
            
            NSString * body = [[[[arr1[i] componentsSeparatedByString:@",create_time"] objectAtIndex:0] componentsSeparatedByString:@"body:"] objectAtIndex:1];
            [self.bodyArray addObject:body];
//            [body release];
            
            NSString * createTime = [[arr1[i] componentsSeparatedByString:@",create_time:"] objectAtIndex:1];
            [self.createTimeArray addObject:createTime];
//            [createTime release];
        }
//        NSLog(@"%@\n%@\n%@\n%@", self.usrIdArray, self.nameArray, self.bodyArray, self.createTimeArray);
    }
}
-(void)loadUserData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", self.usr_id]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERINFOAPI, self.usr_id, sig, [ControllerManager getSID]];
    NSLog(@"UserInfoAPI:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            [indicatorView stopAnimating];
            
            NSLog(@"用户信息：%@", load.dataDict);
            NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectForKey:@"user"];
            self.name = [dict objectForKey:@"name"];
            if ([[dict objectForKey:@"type"] intValue]/100 == 1) {
                self.cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"1"] objectForKey:[dict objectForKey:@"type"]];
            }else if([[dict objectForKey:@"type"] intValue]/100 == 2){
                self.cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"2"] objectForKey:[dict objectForKey:@"type"]];
            }else if([[dict objectForKey:@"type"] intValue]/100 == 3){
                self.cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"3"] objectForKey:[dict objectForKey:@"type"]];
            }else{
                self.cateName = @"苏格兰折耳猫";
            }
            NSLog(@"%@", [dict objectForKey:@"tx"]);
            self.headImageURL = [dict objectForKey:@"tx"];
            [self createTop];
            [self createBottom];
        }else{
            [indicatorView stopAnimating];
            NSLog(@"用户信息数据加载失败");
        }
    }];
    [request release];
}


-(void)leftButtonClick
{
    if ([[USER objectForKey:@"MyHomeTimes"] intValue] == 2) {
        [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"MyHomeTimes"] intValue]-2] forKey:@"MyHomeTimes"];
//         NSLog(@"离开详情页，times:%@", [USER objectForKey:@"MyHomeTimes"]);
    }
    NSLog(@"离开详情页，times:%@", [USER objectForKey:@"MyHomeTimes"]);
    [self dismissViewControllerAnimated:YES completion:nil];
}
//-(void)rightButtonClick
//{
//    NSLog(@"分享");
//    if (!isClicked) {
//        isClicked = 1;
////        shareBgView = [[AMBlurView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        shareBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
////        shareBgButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(shareBgButtonClick) Title:nil];
//        shareBgView.hidden = YES;
//        [self.view addSubview:shareBgView];
//        
//        shareBgButton1 = [MyControl createButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(shareBgButton1Click) Title:nil];
//        shareBgButton1.alpha = 0.5;
//        shareBgButton1.backgroundColor = [UIColor blackColor];
//        [shareBgView addSubview:shareBgButton1];
//        
//        bgView1 = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 90)];
//        [shareBgView addSubview:bgView1];
//        
//        UIView * bgView2 = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90)];
//        bgView2.backgroundColor = [UIColor blackColor];
//        bgView2.alpha = 0.5;
//        [bgView1 addSubview:bgView2];
//        
//        NSArray * imageArray = @[@"21-2.png", @"wxFriend-1.png", @"weibo-1.png"];
//        NSArray * textArray = @[@"微信联系人", @"微信朋友圈", @"微博"];
//        for (int i=0; i<3; i++) {
//            UIButton * button = [MyControl createButtonWithFrame:CGRectMake(40+i*100, 10, 40, 40) ImageName:imageArray[i] Target:self Action:@selector(shareButtonClick:) Title:nil];
//            [bgView1 addSubview:button];
//            button.tag = 200+i;
//            
//            UILabel * label = [MyControl createLabelWithFrame:CGRectMake(-10, 40, 60, 20) Font:12 Text:textArray[i]];
//            label.textAlignment = NSTextAlignmentCenter;
//            [button addSubview:label];
//            
//        }
//        
////        UIButton * cancelButton = [MyControl createButtonWithFrame:CGRectMake(10, 90, 300, 30) ImageName:nil Target:self Action:@selector(cancelButtonClick) Title:@"取消"];
////        cancelButton.showsTouchWhenHighlighted = YES;
////        cancelButton.layer.cornerRadius = 5;
////        cancelButton.layer.masksToBounds = YES;
////        cancelButton.backgroundColor = BGCOLOR;
////        [bgView1 addSubview:cancelButton];
//    }else{
//        [self.view bringSubviewToFront:shareBgView];
//        [self.view bringSubviewToFront:bgView1];
//    }
//    
//    [UIView animateWithDuration:0.0 animations:^{
////        shareBgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        shareBgView.hidden = NO;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.3 animations:^{
//            bgView1.frame = CGRectMake(0, self.view.frame.size.height-90, self.view.frame.size.width, 140);
//        }];
//    }];
//    
//    
////    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
////    [UMSocialSnsService presentSnsIconSheetView:self
////                                         appKey:@"538fddca56240b40a105fcfb"
////                                      shareText:[NSString stringWithFormat:@"#爱动物，爱生活#%@", self.cmt]
////                                     shareImage:imageView.image
////                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,nil]
////                                       delegate:nil];
//    
////    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"#爱动物，爱生活#%@", self.cmt] image:imageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
////        if (response.responseCode == UMSResponseCodeSuccess) {
////            NSLog(@"分享成功！");
////            
////            if (successView == nil) {
////                successView = [MyControl createViewWithFrame:CGRectMake(100, 20, 120, 30)];
////                successView.backgroundColor = [UIColor blackColor];
////                successView.layer.cornerRadius = 5;
////                successView.layer.masksToBounds = YES;
////                successView.alpha = 0.7;
////                [self.view addSubview:successView];
////                
////                UILabel * successLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 120, 30) Font:17 Text:@"分享成功"];
////                successLabel.textAlignment = NSTextAlignmentCenter;
////                [successView addSubview:successLabel];
////            }
////            
////            [successView fadeIn:0.3 delegate:nil];
////            [self performSelector:@selector(fadeout) withObject:nil afterDelay:2];
////        }
////    }];
//}
//#pragma mark - 透明背景button
//-(void)shareBgButton1Click
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        bgView1.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 90);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.0 animations:^{
//            shareBgView.hidden = YES;
//            //            shareBgView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
//        }];
//    }];
//}

//-(void)fadeout
//{
//    [successView fadeOut:0.3 delegate:nil];
//}
#pragma mark - 好友，朋友圈，新浪微博按钮的点击事件
-(void)shareButtonClick:(UIButton *)button
{
    button.userInteractionEnabled = NO;
    if (button.tag == 200) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.cmt image:imageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            button.userInteractionEnabled = YES;
            if (response.responseCode == UMSResponseCodeSuccess) {
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
                NSLog(@"分享成功！");
//                [self showHUD];
            }
        }];
    }else if(button.tag == 201){
         [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.cmt image:imageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            button.userInteractionEnabled = YES;
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
//                [self showHUD];
            }
        }];
    }else{
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:self.cmt image:imageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            button.userInteractionEnabled = YES;
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self showHUD];
            }else{
                NSLog(@"失败原因：%@", response);
            }
        }];
    }
}
-(void)showHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.delegate = self;
    HUD.labelText = @"分享成功!";
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}
//-(void)cancelButtonClick
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        bgView1.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 90);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.0 animations:^{
//            shareBgView.hidden = YES;
////            shareBgView.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
//        }];
//    }];
//}
#pragma mark - 评论半透明黑背景点击事件
-(void)bgButtonClick
{
//    buttonRight.userInteractionEnabled = YES;
    [commentTextView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        commentBgView.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40);
    }];
    bgButton.hidden = YES;
    
//    button.selected = !button.selected;
//    if (button.selected) {
//        NSLog(@"隐藏所有界面");
//        bgView.hidden = YES;
//        view.hidden = YES;
//        view1.hidden = YES;
//        [UIApplication sharedApplication].statusBarHidden = YES;
//    }else{
//        NSLog(@"显示所有界面");
//        bgView.hidden = NO;
//        view.hidden = NO;
//        view1.hidden = NO;
//        [UIApplication sharedApplication].statusBarHidden = NO;
//    }
}

-(void)createImage

{
    //创建scrollView
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    sv.delegate = self;
    [self.view addSubview:sv];
    
    imageView = [[ClickImage alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    imageView.userInteractionEnabled = YES;
    [sv addSubview:imageView];
    
    NSString * docDir = DOCDIR;
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.imageURL]];
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    if (image) {
        //图片已经存在，直接调整大小
        imageView.image = image;
        float width = imageView.image.size.width;
        float height = imageView.image.size.height;
        NSLog(@"%f--%f", width, height);
        if (width>320) {
            float w = 320/width;
            width *= w;
            height *= w;
        }
        if (height>568) {
            float h = 568/height;
            width *= h;
            height *= h;
        }
        if (width<320) {
            float s = 320/width;
            width *= s;
            height *= s;
        }
        
        if(height<=self.view.frame.size.height){
            imageView.frame = CGRectMake(self.view.center.x-width/2, self.view.center.y-height/2, width, height);
            imageView.center = self.view.center;
        }else{
            imageView.frame = CGRectMake(0, 0, width, height);
            imageView.center = CGPointMake(self.view.frame.size.width/2, height/2);
        }
        
        [self createZanAndComment];
    }else{
        //图片不存在，下载之后调整大小
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, self.imageURL] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                imageView.image = load.dataImage;
                float width = imageView.image.size.width;
                float height = imageView.image.size.height;
                if (width>320) {
                    float w = 320/width;
                    width *= w;
                    height *= w;
                }
                if (height>568) {
                    float h = 568/height;
                    width *= h;
                    height *= h;
                }
                if (width<320) {
                    float s = 320/width;
                    width *= s;
                    height *= s;
                }
                
                if(height<=self.view.frame.size.height){
                    imageView.frame = CGRectMake(self.view.center.x-width/2, self.view.center.y-height/2, width, height);
                    imageView.center = self.view.center;
                }else{
                    imageView.frame = CGRectMake(0, 0, width, height);
                    imageView.center = CGPointMake(self.view.frame.size.width/2, height/2);
                }
                
                [self createZanAndComment];
                [self createTop];
                [self createBottom];
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                [alert release];
            }
        }];
        [request release];
    }
    
//    UIButton * bgButton = [MyControl createButtonWithFrame:imageView.frame ImageName:@"" Target:self Action:@selector(bgButtonClick:) Title:nil];
//    [imageView addSubview:bgButton];
    
    /**********点击图片放大第三方**********/
    imageView.canClick = YES;
    
    
}
#pragma mark - 创建点赞和评论
-(void)createZanAndComment
{
    //点赞背景
    view1 = [MyControl createViewWithFrame:CGRectMake(15, imageView.frame.size.height-30-15, 65, 30)];
    if (imageView.frame.size.height>self.view.frame.size.height) {
        view1.frame = CGRectMake(15, self.view.frame.size.height-30-15, 65, 30);
    }
    view1.backgroundColor = [UIColor grayColor];
    view1.layer.cornerRadius = 5;
    view1.layer.masksToBounds = YES;
    view1.alpha = 0.8;
    [imageView addSubview:view1];
    
    heart = [MyControl createImageViewWithFrame:CGRectMake(5, 5, 20, 20) ImageName:@"11-1.png"];
    [view1 addSubview:heart];
    
    numLabel = [MyControl createLabelWithFrame:CGRectMake(27, 5, 35, 20) Font:15 Text:self.num];
    if (!self.num) {
        numLabel.text = @"0";
    }
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.font = [UIFont boldSystemFontOfSize:15];
    [view1 addSubview:numLabel];
    
    //评论
    view2 = [MyControl createViewWithFrame:CGRectMake(320-65-15, imageView.frame.size.height-30-15, 65, 30)];
    if (imageView.frame.size.height>self.view.frame.size.height) {
        view2.frame = CGRectMake(320-65-15, self.view.frame.size.height-30-15, 65, 30);
    }
    view2.backgroundColor = [UIColor grayColor];
    view2.layer.cornerRadius = 5;
    view2.layer.masksToBounds = YES;
    view2.alpha = 0.8;
    [imageView addSubview:view2];
    
    UIImageView * comment = [MyControl createImageViewWithFrame:CGRectMake(23, 6, 35*0.6, 30*0.6) ImageName:@"comment.png"];
    [view2 addSubview:comment];
    
    UIButton * commentButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 65, 30) ImageName:nil Target:self Action:@selector(commentButtonClick) Title:nil];
    [view2 addSubview:commentButton];
    
    //解析点赞者字符串，与[USER objectForKey:@"usr_id"]对比
    if (![self.likers isKindOfClass:[NSNull class]]) {
        self.likersArray = [self.likers componentsSeparatedByString:@","];
        NSLog(@"%@--", self.likersArray);
        for(NSString * str in self.likersArray){
            if ([str isEqualToString:[USER objectForKey:@"usr_id"]]) {
                isLike = YES;
                break;
            }
        }
    }
    UIButton * button = [MyControl createButtonWithFrame:CGRectMake(0, 0, 65, 30) ImageName:@"" Target:self Action:@selector(heartButtonClick:) Title:nil];
    if (isLike) {
        heart.image = [UIImage imageNamed:@"11-2.png"];
        button.selected = YES;
    }
    [view1 addSubview:button];
    
    [imageView release];
}

#pragma mark - 评论点击事件
-(void)commentButtonClick
{
//    buttonRight.userInteractionEnabled = NO;
    
    NSLog(@"Comment");
    if (!isCommentCreated) {
        [self createComment];
        isCommentCreated = 1;
    }
    bgButton.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        commentBgView.frame = CGRectMake(0, self.view.frame.size.height-216-40, 320, 40);
    }];
    [commentTextView becomeFirstResponder];
}

#pragma mark - 点赞
-(void)heartButtonClick:(UIButton *)button
{
    if ([self.usr_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
        [USER setObject:@"1" forKey:@"needRefresh"];
    }
    button.selected = !button.selected;
    self.view.userInteractionEnabled = NO;
    
    NSString * code = [NSString stringWithFormat:@"img_id=%@dog&cat", self.img_id];
    NSString * sig = [MyMD5 md5:code];
    if (button.selected) {
        heart.image = [UIImage imageNamed:@"11-2.png"];
        numLabel.text = [NSString stringWithFormat:@"%d", [numLabel.text intValue]+1];
        //赞
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", LIKEAPI, self.img_id, sig, [ControllerManager getSID]];
        NSLog(@"likeURL:%@", url);
        
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                if (![[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"点赞失败 = =."];
                    heart.image = [UIImage imageNamed:@"11-1.png"];
                    numLabel.text = [NSString stringWithFormat:@"%d", [numLabel.text intValue]-1];
                }else{
//                    if ([self.likerTxArray isKindOfClass:[NSNull class]]) {
//                        self.likerTxArray = [NSMutableArray arrayWithCapacity:0];
//                    }
                    [view removeFromSuperview];
                    [timeLabel removeFromSuperview];
                    [commentView removeFromSuperview];
                    
                    if (!([self.likerTxArray isKindOfClass:[NSNull class]] || self.likerTxArray.count == 0)) {
                        [txsView removeFromSuperview];
                    }
                    
                    NSLog(@"%@", [USER objectForKey:@"tx"]);
                    if ([self.likerTxArray isKindOfClass:[NSNull class]]) {
                        self.likerTxArray = [NSMutableArray arrayWithCapacity:0];
                        [self.likerTxArray addObject:[USER objectForKey:@"tx"]];
                    }else{
                        [self.likerTxArray insertObject:[USER objectForKey:@"tx"] atIndex:0];
                    }
                    
                    [self createBottom];
                    
//                    [sv removeFromSuperview];
//                    [self loadData];
                }
            }else{
                NSLog(@"数据请求失败");
            }
            self.view.userInteractionEnabled = YES;
        }];
        [request release];
        
    }else{
        heart.image = [UIImage imageNamed:@"11-1.png"];
        numLabel.text = [NSString stringWithFormat:@"%d", [numLabel.text intValue]-1];
        //取消赞
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", UNLIKEAPI, self.img_id, sig, [ControllerManager getSID]];
        NSLog(@"likeURL:%@", url);
        
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                if (![[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消赞失败 = =."];
                    heart.image = [UIImage imageNamed:@"11-2.png"];
                    numLabel.text = [NSString stringWithFormat:@"%d", [numLabel.text intValue]+1];
                }else{
                    [view removeFromSuperview];
                    [timeLabel removeFromSuperview];
                    [txsView removeFromSuperview];
                    [commentView removeFromSuperview];
                    
                    [self.likerTxArray removeObject:[USER objectForKey:@"tx"]];
                    [self createBottom];
                    
//                    [sv removeFromSuperview];
                    isLike = NO;
//                    [self loadData];
                }
            }else{
                NSLog(@"数据请求失败");
            }
            self.view.userInteractionEnabled = YES;
        }];
        [request release];
    }
}

- (void)createDelayBackButton
{
    UIButton *delayBackButton = [MyControl createButtonWithFrame:CGRectMake(17, 30, 50, 30) ImageName:nil Target:self Action:@selector(backPrevPage)  Title:@"返回"];
    delayBackButton.layer.cornerRadius = 5;
    delayBackButton.layer.masksToBounds = YES;
    delayBackButton.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    delayBackButton.tag = 55;
    [self.view addSubview:delayBackButton];
}
- (void)backPrevPage
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createTop
{
    UIButton *delayBackButton = (UIButton *)[self.view viewWithTag:55];
    delayBackButton.hidden= YES;

    bgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 70)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [self.view addSubview:bgView];
    
    UIView * bgView2 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 70)];
//    bgView2.backgroundColor = [UIColor blackColor];
//    bgView2.alpha = 0.5;
    [self.view addSubview:bgView2];
    
    UIButton * buttonLeft = [MyControl createButtonWithFrame:CGRectMake(17, 30, 30, 30) ImageName:@"7-7.png" Target:self Action:@selector(leftButtonClick) Title:nil];
    buttonLeft.showsTouchWhenHighlighted = YES;
    [bgView2 addSubview:buttonLeft];
    
//    buttonRight = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-30-17, 30, 30, 30) ImageName:@"11-3.png" Target:self Action:@selector(rightButtonClick) Title:nil];
//    buttonRight.showsTouchWhenHighlighted = YES;
//    [bgView2 addSubview:buttonRight];
    
    //头像
    UIImageView * headImageView = [MyControl createImageViewWithFrame:CGRectMake(55, 25, 40, 40) ImageName:@""];
    if ([self.headImageURL isKindOfClass:[NSNull class]] || self.headImageURL.length==0) {
        headImageView.image = [UIImage imageNamed:@"20-1.png"];
    }else{
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.headImageURL]];
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
        if (image) {
            headImageView.image = image;
        }else{
            //下载头像
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, self.headImageURL] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    headImageView.image = load.dataImage;
                    NSString * docDir = DOCDIR;
                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.headImageURL]];
                    [load.data writeToFile:txFilePath atomically:YES];
                }else{
                    NSLog(@"头像下载失败");
                }
            }];
            [request release];
        }
    }
    
    headImageView.layer.cornerRadius = 20;
    headImageView.layer.masksToBounds = YES;
    [bgView2 addSubview:headImageView];
    
    
    
    label1 = [MyControl createLabelWithFrame:CGRectMake(100, 25, 150, 20) Font:14 Text:self.name];
    label1.font = [UIFont boldSystemFontOfSize:14];
    [bgView2 addSubview:label1];
    
    UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(100, 45, 150, 20) Font:12 Text:self.cateName];
    label2.font = [UIFont boldSystemFontOfSize:12];
    [bgView2 addSubview:label2];
    
    UIButton * jumpToHomeButton = [MyControl createButtonWithFrame:CGRectMake(55, 25, 100, 40) ImageName:@"" Target:self Action:@selector(jumpToHomeButtonClick) Title:nil];
//    jumpToDetailButton.backgroundColor = [UIColor redColor];
//    jumpToDetailButton.alpha = 0.5;
    [bgView2 addSubview:jumpToHomeButton];
}
-(void)jumpToHomeButtonClick
{
//    buttonRight.userInteractionEnabled = YES;
    [commentTextView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        commentBgView.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40);
    }];
    bgButton.hidden = YES;
    
    if ([self.usr_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
        NSLog(@"由详情页进入我的个人主页，times:%@", [USER objectForKey:@"MyHomeTimes"]);
        //当是由主页近详情页，再进主页时会跳回主页
        if ([[USER objectForKey:@"MyHomeTimes"] intValue] == 2) {
            [USER setObject:@"0" forKey:@"MyHomeTimes"];
            NSLog(@"离开详情页，强制返回个人主页，times:%@", [USER objectForKey:@"MyHomeTimes"]);
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            //进入个人主页
            UINavigationController * nc = [ControllerManager shareManagerMyHome];
            [self presentViewController:nc animated:YES completion:nil];
        }
    }else{
        OtherHomeViewController * other = [[OtherHomeViewController alloc] init];
        other.usr_id = self.usr_id;
        NSLog(@"other.usr_id:%@", other.usr_id);
        [self presentViewController:other animated:YES completion:nil];
        [other release];
    }
}

-(void)createBottom
{
//    NSString * string = @"她渐渐的让我明白了感情的戏，戏总归是戏，再美也是暂时的假象，无论投入多深多真，结局总是如此。";
    //计算文字高度
//    CGSize size = [self.cmt sizeWithFont:[UIFont systemFontOfSize:15] forWidth:310 lineBreakMode:NSLineBreakByCharWrapping];
    CGSize size  = [self.cmt sizeWithFont:[UIFont systemFontOfSize:15]
                     constrainedToSize:CGSizeMake(200.0, 5000)
                         lineBreakMode:NSLineBreakByWordWrapping];
    view = [MyControl createViewWithFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height, 320, size.height+10)];
//    view.backgroundColor = [UIColor lightGrayColor];
    view.alpha = 0.8;
    [sv addSubview:view];
    
    
    
    UILabel * label = [MyControl createLabelWithFrame:CGRectMake(5, 5, 310, size.height) Font:15 Text:self.cmt];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = [UIColor grayColor];
    if (iOS7) {
        label.textAlignment = NSTextAlignmentJustified;
    }else{
        label.textAlignment = NSTextAlignmentLeft;
    }
    label.numberOfLines = 0;//表示label可以多行显示
    label.lineBreakMode = NSLineBreakByCharWrapping;
    [view addSubview:label];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[self.createTime intValue]];
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * time = [dateFormat stringFromDate:date];
    [dateFormat release];
    timeLabel = [MyControl createLabelWithFrame:CGRectMake(320-150-10, view.frame.origin.y+view.frame.size.height, 150, 20) Font:15 Text:time];
    
    
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [UIColor lightGrayColor];
    [sv addSubview:timeLabel];
    
    
    if ([self.likerTxArray isKindOfClass:[NSNull class]] || self.likerTxArray.count == 0) {
        sv.contentSize = CGSizeMake(320, timeLabel.frame.origin.y+timeLabel.frame.size.height-5+50);
    }else{
        txsView = [MyControl createViewWithFrame:CGRectMake(0, timeLabel.frame.origin.y+20, 320, 40+10+2)];
        [sv addSubview:txsView];
        
        UIImageView * line1 = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, 1) ImageName:@"20-灰色线.png"];
        [txsView addSubview:line1];
        NSLog(@"self.likerTxArray:%@", self.likerTxArray);
        for(int i=0;i<self.likerTxArray.count;i++){
            if (i>=6) {
                break;
            }
            UIImageView * txImageView = [MyControl createImageViewWithFrame:CGRectMake(10+i*48, line1.frame.origin.y+1+5, 40, 40) ImageName:@""];
            if ([self.likerTxArray[i] isKindOfClass:[NSString class]] && [self.likerTxArray[i] length]>0) {
                NSString * path = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.likerTxArray[i]]];
                UIImage * image = [UIImage imageWithContentsOfFile:path];
                if (image) {
                    txImageView.image = image;
                }else{
                    //下载头像
                    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, self.likerTxArray[i]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                        if (isFinish) {
                            txImageView.image = load.dataImage;
                            NSString * docDir = DOCDIR;
                            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.likerTxArray[i]]];
                            [load.data writeToFile:txFilePath atomically:YES];
                        }
                    }];
                    [request release];
                }
                
            }else{
                txImageView.image = [UIImage imageNamed:@"20-1.png"];
            }
            txImageView.layer.cornerRadius = 20;
            txImageView.layer.masksToBounds = YES;
            [txsView addSubview:txImageView];
        }
        //14-6-2.png
        UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(320-7-30, line1.frame.origin.y+1+10, 30, 30) ImageName:@"14-6-2.png"];
        [txsView addSubview:arrow];
        
        UIButton * rightArrayButton = [MyControl createButtonWithFrame:CGRectMake(0, line1.frame.origin.y, 320, 52) ImageName:@"" Target:self Action:@selector(rightArrowButtonClick) Title:nil];
        rightArrayButton.showsTouchWhenHighlighted = YES;
        [txsView addSubview:rightArrayButton];
        
        UIImageView * line2 = [MyControl createImageViewWithFrame:CGRectMake(0, line1.frame.origin.y+1+10+40, 320, 1) ImageName:@"20-灰色线.png"];
        [txsView addSubview:line2];
        
        //最终确定sv的长度
        sv.contentSize = CGSizeMake(320, txsView.frame.origin.y+line2.frame.origin.y+1+50);
//        NSLog(@"sv.contentSize.height:%f--%f", sv.contentSize.height, line2.frame.origin.y);
    }
    
    /*****************评论*******************/
    commentView = [MyControl createViewWithFrame:CGRectMake(0, sv.contentSize.height-40, 320, 0)];

    [sv addSubview:commentView];

    //commentHeight归零
    commentHeight = 0;
    
    for(int i=0;i<self.usrIdArray.count;i++){
//        NSLog(@"%@\n%@", self.nameArray[i], self.bodyArray[i]);
        NSString * string = [NSString stringWithFormat:@"%@：%@", self.nameArray[i], self.bodyArray[i]];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:string];
        NSInteger length = str.length;
        [str addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(0, [self.nameArray[i] length])];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, [self.nameArray[i] length])];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange([self.nameArray[i] length], length-[self.nameArray[i] length])];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange([self.nameArray[i] length], length-[self.nameArray[i] length])];
        
        CGSize size2 = [string sizeWithFont:[UIFont systemFontOfSize:15]
                          constrainedToSize:CGSizeMake(250.0, 1000)
                              lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel * commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, commentHeight, 250, size2.height)];
        commentLabel.attributedText = str;
        commentLabel.numberOfLines = 0;
        commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        if (iOS7) {
            commentLabel.textAlignment = NSTextAlignmentJustified;
        }
        [commentView addSubview:commentLabel];
        [commentLabel release];
        [str release];
        
        //改变commentHeight
        commentHeight += (size2.height+5);
        
        //别人发评论的时间
        UILabel * timeLabel2 = [MyControl createLabelWithFrame:CGRectMake(self.view.frame.size.width-5-65, commentLabel.frame.origin.y+commentLabel.frame.size.height-20, 65, 20) Font:13 Text:[MyControl timeFromTimeStamp:self.createTimeArray[i]]];
        timeLabel2.textColor = [UIColor lightGrayColor];
        timeLabel2.textAlignment = NSTextAlignmentRight;
        [commentView addSubview:timeLabel2];
    }
    commentView.frame = CGRectMake(0, sv.contentSize.height-40, 320, commentHeight);
    
    sv.contentSize = CGSizeMake(320, sv.contentSize.height+commentHeight);
    
//    sv.contentSize = CGSizeMake(320, commentView.frame.origin.y+commentView.frame.size.height+50);
    
}
#pragma mark - 创建评论界面
-(void)createComment
{
    bgButton = [MyControl createButtonWithFrame:CGRectMake(0, 70, 320, self.view.frame.size.height-70) ImageName:nil Target:self Action:@selector(bgButtonClick) Title:nil];
    bgButton.backgroundColor = [UIColor blackColor];
    bgButton.alpha = 0.3;
    [self.view addSubview:bgButton];
    
    commentBgView = [MyControl createViewWithFrame:CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40)];
    commentBgView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:commentBgView];
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 250, 30)];
    commentTextView.textColor = [UIColor lightGrayColor];
    commentTextView.text = @"写个评论呗";
    commentTextView.layer.cornerRadius = 5;
    commentTextView.layer.masksToBounds = YES;
    commentTextView.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1].CGColor;
    commentTextView.layer.borderWidth = 1.5;
    commentTextView.delegate = self;
    commentTextView.font = [UIFont systemFontOfSize:15];
    [commentBgView addSubview:commentTextView];
    [commentTextView release];
    
    sendButton = [MyControl createButtonWithFrame:CGRectMake(260, 10, 55, 20) ImageName:@"" Target:self Action:@selector(sendButtonClick) Title:@"发送"];
    [sendButton setTitleColor:BGCOLOR forState:UIControlStateNormal];
    [commentBgView addSubview:sendButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}
#pragma mark -键盘监听
-(void)keyboardWasChange:(NSNotification *)notification
{
    NSLog(@"%@", notification.userInfo);
    float y = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    if (y == self.view.frame.size.height) {
        return;
    }
    float height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSString * str = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([str isEqualToString:@"zh-Hans"]) {
        
        [UIView animateWithDuration:0.25 animations:^{
            commentBgView.frame = CGRectMake(0, self.view.frame.size.height-height-commentBgView.frame.size.height, 320, commentBgView.frame.size.height);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            commentBgView.frame = CGRectMake(0, self.view.frame.size.height-height-commentBgView.frame.size.height, 320, commentBgView.frame.size.height);
        }];
    }
}
#pragma mark - 发表评论
-(void)sendButtonClick
{
    
    
    if ([commentTextView.text isEqualToString:@"写个评论呗"] || commentTextView.text.length == 0) {
//        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"不写评论怎么发 = =。"];
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
        [MMProgressHUD showWithStatus:@"评论中..."];
        [MMProgressHUD dismissWithError:@"不写评论怎么发 = =。" afterDelay:1.5];
        return;
    }
    
    //post数据  参数img_id 和 body
    NSString * url = [NSString stringWithFormat:@"%@%@", COMMENTAPI, [ControllerManager getSID]];
    NSLog(@"postUrl:%@", url);
    ASIFormDataRequest * _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 20;
    
//    if (![commentTextView.text isEqualToString:@"写个评论呗"]) {
        [_request setPostValue:commentTextView.text forKey:@"body"];
//    }else{
//        [_request setPostValue:@"" forKey:@"body"];
//    }
    [_request setPostValue:self.img_id forKey:@"img_id"];
    _request.delegate = self;
    [_request startAsynchronous];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:@"评论中..."];
}
#pragma mark - ASI代理
-(void)requestFinished:(ASIHTTPRequest *)request
{
//    buttonRight.userInteractionEnabled = YES;
    
    NSLog(@"success");
    [commentTextView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        commentBgView.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40);
        //评论清空
        commentTextView.text = @"写个评论呗";
        commentTextView.textColor = [UIColor lightGrayColor];
    }];
    bgButton.hidden = YES;
    [MMProgressHUD dismissWithSuccess:@"评论成功" title:nil afterDelay:1];
    //添加评论

    [self.usrIdArray addObject:[USER objectForKey:@"usr_id"]];
    [self.nameArray addObject:[USER objectForKey:@"name"]];
    [self.bodyArray addObject:commentTextView.text];
    [self.createTimeArray addObject:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]]];
    
    [view removeFromSuperview];
    [timeLabel removeFromSuperview];
    if (!([self.likerTxArray isKindOfClass:[NSNull class]] || self.likerTxArray.count == 0)) {
        [txsView removeFromSuperview];
    }
    
    [commentView removeFromSuperview];
    
    
    [self createBottom];
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
    [MMProgressHUD dismissWithError:@"评论失败" afterDelay:1];
}

#pragma mark - textView代理
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([commentTextView.text isEqualToString:@"写个评论呗"]) {
        commentTextView.text = @"";
    }
//    textViewSize = [textView.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:NSLineBreakByCharWrapping];
//    if (textViewSize.height>=30 && textViewSize.height<=90) {
////        commentBgView = [MyControl createViewWithFrame:CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40)];
////        commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 250, 30)];
//        commentBgView.frame = CGRectMake(0, self.view.frame.size.height-216-10-textViewSize.height, 320, textViewSize.height+10);
//        textView.frame = CGRectMake(5, 5, 250, textViewSize.height);
//    }else if(textViewSize.height<30){
//        commentBgView.frame = CGRectMake(0, self.view.frame.size.height-216-40, 320, 40);
//        textView.frame = CGRectMake(5, 5, 250, 30);
//    }
    commentTextView.textColor = [UIColor blackColor];
    return YES;
}
-(void)rightArrowButtonClick
{
    LikersLIstViewController * vc = [[LikersLIstViewController alloc] init];
    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.modalTransitionStyle = 2;
    vc.usr_ids = self.likers;
    [self presentViewController:nc animated:YES completion:nil];
    [vc release];
    [nc release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#pragma mark -创建导航
//-(void)createNavigation
//{
//    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
//    self.navigationController.navigationBar.translucent = NO;
//    
//    UIButton * buttonLeft = [MyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) ImageName:@"7-7.png" Target:self Action:@selector(leftButtonClick) Title:nil];
//    
//    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
//    self.navigationItem.leftBarButtonItem = leftButton;
//    [leftButton release];
//    
//    UIButton * buttonRight = [MyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) ImageName:@"11-3.png" Target:self Action:@selector(rightButtonClick) Title:nil];
//    
//    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
//    self.navigationItem.rightBarButtonItem = rightButton;
//    [rightButton release];
//    
//    bgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 250, 40)];
//    self.navigationItem.titleView = bgView;
//    
//    UIImageView * headImageView = [MyControl createImageViewWithFrame:CGRectMake(5, 0, 40, 40) ImageName:@"1669988_d_wx.jpg"];
//    headImageView.layer.cornerRadius = 20;
//    headImageView.layer.masksToBounds = YES;
//    [bgView addSubview:headImageView];
//    
//    UILabel * label11 = [MyControl createLabelWithFrame:CGRectMake(50, 0, 150, 20) Font:14 Text:@"小熊维尼维尼"];
//    label11.textAlignment = NSTextAlignmentLeft;
//    label11.font = [UIFont boldSystemFontOfSize:14];
//    [bgView addSubview:label11];
//    [label11 release];
//    
//    UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(50, 20, 150, 20) Font:12 Text:@"小短腿族"];
//    label2.textAlignment = NSTextAlignmentLeft;
//    label2.font = [UIFont boldSystemFontOfSize:12];
//    [bgView addSubview:label2];
//    [label2 release];
//}
@end
