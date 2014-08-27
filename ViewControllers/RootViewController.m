//
//  RootViewController.m
//  Waterflow
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 yangjw . All rights reserved.
//

#import "RootViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <AviarySDK/AviarySDK.h>

#import "RandomViewController.h"
#import "FavoriteViewController.h"
#import "ControllerManager.h"
#import "MyPetViewController.h"

#import "RegisterViewController.h"
#import "UMSocial.h"
#import "UploadViewController.h"

#import "ASIFormDataRequest.h"
#import "MyHomeViewController.h"
#define MENUCOLOR [UIColor colorWithRed:125/255.0 green:60/255.0 blue:45/255.0 alpha:1]
#import "ActivityViewController.h"
#import "PublishViewController.h"
#import "NoticeViewController.h"

#import "JDSideMenu.h"
#import "UIViewController+JDSideMenu.h"
static NSString * const kAFAviaryAPIKey = @"b681eafd0b581b46";
static NSString * const kAFAviarySecret = @"389160adda815809";

@interface RootViewController () <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,AFPhotoEditorControllerDelegate>
{
    ASIFormDataRequest * _request;
    
    BOOL isCamara;
    UIImageView * headImageView;
    UIImageView * bgImageView;
    
    UIImageView * menu;
    UILabel * nameLabel;
    UIImageView * sex;
    UILabel * cateNameLabel;
}
@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;
@end

@implementation RootViewController
-(void)dealloc
{
//    [self.sc release];
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
//-(void)viewWillAppear:(BOOL)animated
//{
//    
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.view.backgroundColor = BGCOLOR2;
    [self createNavigation];
    [self createLoginAlertView];
//    [self createMenu];
//    NSUserDefaults * user = [ControllerManager shareUserDefault];
//    [user setObject:@"NO" forKey:@"isLogin"];
    
    
}
-(void)refreshMenu
{
    //头像的加载
    NSString * txFilePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [USER objectForKey:@"tx"]]];
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txFilePath]];
    if (image) {
        headImageView.image = image;
    }else{
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", TXURL, [USER objectForKey:@"tx"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                //本地目录，用于存放favorite下载的原图
                NSString * docDir = DOCDIR;
                NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [USER objectForKey:@"tx"]]];
                //将下载的图片存放到本地
                [load.data writeToFile:txFilePath atomically:YES];
                headImageView.image = load.dataImage;
            }else{
                NSLog(@"头像下载失败");
            }
        }];
    }
    CGSize size = [[USER objectForKey:@"name"] sizeWithFont:[UIFont boldSystemFontOfSize:17] forWidth:150 lineBreakMode:1];
    if (size.width<150) {
        nameLabel.frame = CGRectMake(headImageView.frame.origin.x+60+20, headImageView.frame.origin.y+5, size.width, 20);
    }else{
        nameLabel.adjustsFontSizeToFitWidth = YES;
    }
    if ([[USER objectForKey:@"gender"] intValue] == 1) {
        //公
        sex.image = [UIImage imageNamed:@"3-6.png"];
    }else{
        sex.image = [UIImage imageNamed:@"3-4.png"];
    }
    int a = [[USER objectForKey:@"type"] intValue];
    NSLog(@"%@--%d", [USER objectForKey:@"type"], a);
    NSString * cateName = nil;
    
    if (a/100 == 1) {
        cateName = [[[USER objectForKey:@"CateNameList"]objectForKey:@"1"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else if(a/100 == 2){
        cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"2"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else if(a/100 == 3){
        cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"3"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else{
        cateName = @"未知物种";
    }
    if (cateName == nil) {
        //更新本地宠物名单列表
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", TYPEAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                [USER setObject:[load.dataDict objectForKey:@"data"] forKey:@"CateNameList"];
                NSString * path = [DOCDIR stringByAppendingPathComponent:@"CateNameList.plist"];
                NSMutableDictionary * data = [load.dataDict objectForKey:@"data"];
                //本地及内存存储
                [data writeToFile:path atomically:YES];
                [USER setObject:data forKey:@"CateNameList"];
                int a = [[USER objectForKey:@"type"] intValue];
                NSString * cateName = nil;
                
                if (a/100 == 1) {
                    cateName = [[[USER objectForKey:@"CateNameList"]objectForKey:@"1"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else if(a/100 == 2){
                    cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"2"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else if(a/100 == 3){
                    cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"3"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else{
                    cateName = @"未知物种";
                }
                cateNameLabel.text = [NSString stringWithFormat:@"%@ | %@岁", cateName, [USER objectForKey:@"age"]];
            }
        }];
        
    }else{
        cateNameLabel.text = [NSString stringWithFormat:@"%@ | %@岁", cateName, [USER objectForKey:@"age"]];
    }
}

#pragma mark
#pragma mark -createMenu
-(void)createMenu
{
    menu = [MyControl createImageViewWithFrame:CGRectMake(0, -self.view.frame.size.height-[MyControl isIOS7], 320, self.view.frame.size.height+[MyControl isIOS7]) ImageName:@""];
    menu.backgroundColor = [UIColor blackColor];
    [menu retain];
    menu.alpha = 0.85;
    [[UIApplication sharedApplication].keyWindow addSubview:menu];
    
    UIButton * back = [MyControl createButtonWithFrame:CGRectMake(20, 30, 30, 30) ImageName:@"7-7.png" Target:self Action:@selector(backButtonClick) Title:nil];
    back.showsTouchWhenHighlighted = YES;
    [menu addSubview:back];
    
    
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(320, 153/2, 320, 178/2) ImageName:@""];
//    bgImageView.image = [[UIImage imageNamed:@"29-1.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [menu addSubview:bgImageView];
    
    UIImageView * bgImageView2 = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, 178/2) ImageName:@""];
    bgImageView2.image = [[UIImage imageNamed:@"29-1.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [bgImageView addSubview:bgImageView2];
    
    UIView * bgHeadView = [MyControl createViewWithFrame:CGRectMake(50, 10, 60, 60)];
    bgHeadView.alpha = 1;
    [bgImageView addSubview:bgHeadView];
    
    
//    headImageView = [MyControl createImageViewWithFrame:CGRectMake(50, 10, 70, 70) ImageName:@""];
    headImageView = [[ClickImage alloc] initWithFrame:CGRectMake(50, 10, 70, 70)];
    headImageView.layer.cornerRadius = 35;
    headImageView.layer.masksToBounds = YES;
    headImageView.canClick = YES;
    //头像的加载
    NSString * txFilePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [USER objectForKey:@"tx"]]];
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txFilePath]];
    if (image) {
        headImageView.image = image;
    }else{
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", TXURL, [USER objectForKey:@"tx"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                //本地目录，用于存放favorite下载的原图
                NSString * docDir = DOCDIR;
                NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [USER objectForKey:@"tx"]]];
                //将下载的图片存放到本地
                [load.data writeToFile:txFilePath atomically:YES];
                headImageView.image = load.dataImage;
            }else{
                NSLog(@"头像下载失败");
            }
        }];
    }
    [bgImageView addSubview:headImageView];
    
    CGSize size = [[USER objectForKey:@"name"] sizeWithFont:[UIFont boldSystemFontOfSize:17] forWidth:150 lineBreakMode:1];
    nameLabel = [MyControl createLabelWithFrame:CGRectMake(headImageView.frame.origin.x+60+20+20, headImageView.frame.origin.y+5, 150, 20) Font:17 Text:[USER objectForKey:@"name"]];
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    if (size.width<150) {
        nameLabel.frame = CGRectMake(headImageView.frame.origin.x+60+20+20, headImageView.frame.origin.y+5, size.width, 20);
    }else{
        nameLabel.adjustsFontSizeToFitWidth = YES;
    }
    [bgImageView addSubview:nameLabel];
    
    //性别
    sex = [MyControl createImageViewWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+5, nameLabel.frame.origin.y-3, 28*0.75, 34*0.75) ImageName:@""];
    if ([[USER objectForKey:@"gender"] intValue] == 1) {
        //公
        sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    [bgImageView addSubview:sex];
    
    cateNameLabel = [MyControl createLabelWithFrame:CGRectMake(headImageView.frame.origin.x+60+20+20, headImageView.frame.origin.y+20+15+10, 150, 20) Font:16 Text:[NSString stringWithFormat:@"苏格兰折耳猫 | %@岁", [USER objectForKey:@"age"]]];
    cateNameLabel.font = [UIFont boldSystemFontOfSize:16];
    [bgImageView addSubview:cateNameLabel];
    
    int a = [[USER objectForKey:@"type"] intValue];
    NSLog(@"%@--%d", [USER objectForKey:@"type"], a);
    NSString * cateName = nil;
    
    if (a/100 == 1) {
        cateName = [[[USER objectForKey:@"CateNameList"]objectForKey:@"1"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else if(a/100 == 2){
        cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"2"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else if(a/100 == 3){
        cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"3"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else{
        cateName = @"未知物种";
    }
    if (cateName == nil) {
        //更新本地宠物名单列表
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", TYPEAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                [USER setObject:[load.dataDict objectForKey:@"data"] forKey:@"CateNameList"];
                NSString * path = [DOCDIR stringByAppendingPathComponent:@"CateNameList.plist"];
                NSMutableDictionary * data = [load.dataDict objectForKey:@"data"];
                //本地及内存存储
                [data writeToFile:path atomically:YES];
                [USER setObject:data forKey:@"CateNameList"];
                int a = [[USER objectForKey:@"type"] intValue];
                NSString * cateName = nil;
                
                if (a/100 == 1) {
                    cateName = [[[USER objectForKey:@"CateNameList"]objectForKey:@"1"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else if(a/100 == 2){
                    cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"2"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else if(a/100 == 3){
                    cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"3"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else{
                    cateName = @"未知物种";
                }
                cateNameLabel.text = [NSString stringWithFormat:@"%@ | %@岁", cateName, [USER objectForKey:@"age"]];
            }
        }];
        
    }else{
        cateNameLabel.text = [NSString stringWithFormat:@"%@ | %@岁", cateName, [USER objectForKey:@"age"]];
    }
    
    NSArray * array = @[@"29-3.png", @"29-4.png", @"29-5.png", @"29-6.png", @"29-7.png"];
    NSArray * array2 = @[@"个人", @"经验", @"活动", @"设置", @"消息"];
    for(int i=0;i<array.count;i++){
        UIView * bgView = [MyControl createViewWithFrame:CGRectMake(0, bgImageView.frame.origin.y+bgImageView.frame.size.height+15+i*60, 320, 50)];
//        bgView.backgroundColor = MENUCOLOR;
        [menu addSubview:bgView];
        bgView.tag = 2000+i;
        
        UIImageView * imageView = [MyControl createImageViewWithFrame:CGRectMake(50+30-20, 5, 40, 40) ImageName:array[i]];
        [bgView addSubview:imageView];
        
        if (i == 2) {
            UIImageView * greenBall = [MyControl createImageViewWithFrame:CGRectMake(30, -3, 20, 20) ImageName:@"29-8.png"];
            greenBall.hidden = YES;
            greenBall.tag = 50;
            [imageView addSubview:greenBall];
            
            activityNumLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 20, 20) Font:15 Text:nil];
            activityNumLabel.textAlignment = NSTextAlignmentCenter;
            activityNumLabel.hidden = YES;
            [greenBall addSubview:activityNumLabel];
            
        }
        if (i == 4) {
            UIImageView * greenBall = [MyControl createImageViewWithFrame:CGRectMake(30, -3, 20, 20) ImageName:@"29-8.png"];
            greenBall.hidden = YES;
            greenBall.tag = 51;
            [imageView addSubview:greenBall];
            
            noticeNumLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 20, 20) Font:15 Text:@"5"];
            noticeNumLabel.textAlignment = NSTextAlignmentCenter;
            noticeNumLabel.hidden = YES;
            [greenBall addSubview:noticeNumLabel];
        }
        
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(130+20, 15, 100, 20) Font:17 Text:array2[i]];
        label.font = [UIFont systemFontOfSize:17];
        [bgView addSubview:label];
        
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, 50) ImageName:nil Target:self Action:@selector(menuButtonClick:) Title:nil];
        [button addTarget:self action:@selector(menuButtonClick2:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(menuButtonClick3) forControlEvents:UIControlEventTouchDragOutside];
        [bgView addSubview:button];
        button.tag = 1000+i;
    }
}
#pragma mark - menu返回按钮
-(void)backButtonClick
{
    //通过关闭和打开导航左按钮限制用户快速点击，以防弹出2个Menu
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [UIView animateWithDuration:0.3 animations:^{
        menu.frame = CGRectMake(0, -self.view.frame.size.height-[MyControl isIOS7], 320, self.view.frame.size.height);
        bgImageView.frame = CGRectMake(320, 153/2, 320, 178/2);
    }];
}
-(void)menuButtonClick3
{
    [self resetColor];
}
-(void)menuButtonClick2:(UIButton *)button
{
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [self resetColor];
    UIView * bgView = (UIView *)[menu viewWithTag:1000+button.tag];
    bgView.backgroundColor = MENUCOLOR;
}
-(void)menuButtonClick:(UIButton *)button
{
    self.navigationItem.leftBarButtonItem.enabled = YES;
//    UIView * bgView = (UIView *)[menu viewWithTag:1000+button.tag];
//    bgView.backgroundColor = MENUCOLOR;
    if (button.tag == 1000) {
        //个人主页
        MyHomeViewController * nc = [ControllerManager shareManagerMyHome];
        nc.modalTransitionStyle = 2;
        [self presentViewController:nc animated:YES completion:nil];
    }else if (button.tag == 1001) {
        //经验值
//        ExpViewController * vc = [[ExpViewController alloc] init];
//        vc.modalTransitionStyle = 2;
//        [self presentViewController:vc animated:YES completion:nil];
//        [vc release];
    }else if(button.tag == 1002){
        //活动
        ActivityViewController *vc = [[ActivityViewController alloc] init];
        UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
        [self presentViewController:nav animated:YES completion:nil];
        [vc release];
    }else if (button.tag == 1003){
        //设置
//        SetViewController * vc = [[SetViewController alloc] init];
//        vc.modalTransitionStyle = 2;
//        [self presentViewController:vc animated:YES completion:nil];
//        [vc release];
    }else{
        //消息
        NoticeViewController * vc = [[NoticeViewController alloc] init];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
        [nc release];
        [vc release];
    }
    [UIView animateWithDuration:0.3 animations:^{
        menu.frame = CGRectMake(0, -self.view.frame.size.height-[MyControl isIOS7], 320, self.view.frame.size.height);
    }];
    [self performSelector:@selector(resetColor) withObject:nil afterDelay:0.3];
}
-(void)resetColor
{
    for(int i=0;i<5;i++){
        UIView * bgView = (UIView *)[menu viewWithTag:2000+i];
        bgView.backgroundColor = [UIColor clearColor];
    }
}
-(void)createNavigation
{
    // Allocate Asset Library
    ALAssetsLibrary * assetLibrary = [[ALAssetsLibrary alloc] init];
    [self setAssetLibrary:assetLibrary];
    
    // Allocate Sessions Array
    NSMutableArray * sessions = [NSMutableArray new];
    [self setSessions:sessions];
    [sessions release];
    
    // Start the Aviary Editor OpenGL Load
    [AFOpenGLManager beginOpenGLLoad];
    
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.alpha = 0.85;
    if (iOS7) {
        self.navigationController.navigationBar.barTintColor = BGCOLOR;
    }else{
        self.navigationController.navigationBar.tintColor = BGCOLOR;
    }
    
    
    UIButton * button1 = [MyControl createButtonWithFrame:CGRectMake(0, 0, 82/2, 54/2) ImageName:@"menu.png" Target:self Action:@selector(myPetClick:) Title:nil];
    button1.tag = 5;
    button1.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
    
    UIButton * button2 = [MyControl createButtonWithFrame:CGRectMake(0, 0, 82/2, 54/2) ImageName:@"相机图标.png" Target:self Action:@selector(cameraButtonClick) Title:nil];
    button2.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    NSArray * array = @[@"推荐", @"关注"];
    self.sc = [[UISegmentedControl alloc] initWithItems:array];
    [self.sc addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];

    //选中背景颜色
    self.sc.tintColor = [UIColor whiteColor];
    self.sc.frame = CGRectMake(0, 0, 160, 30);
    self.navigationItem.titleView = self.sc;
}

-(void)segmentClick:(UISegmentedControl *)segment
{
    NSLog(@"------%d", segment.selectedSegmentIndex);
    if (segment.selectedSegmentIndex == 0) {

        UINavigationController * rvc = [ControllerManager shareManagerRandom];
        [self.sideMenuController setContentController:rvc animted:YES];
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
        self.sc.userInteractionEnabled = YES;
        //判断isSuccess的值，为假跳到注册页，为真直接跳转。
        
        if(![ControllerManager getIsSuccess]){
            [USER setObject:@"2" forKey:@"pageNum"];
            //跳注册页
            [UIView animateWithDuration:0.3 animations:^{
                view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height+[MyControl isIOS7]);
            }];
        }else{
//            [self getUserData];
            
            //直接跳到喜爱页
            UINavigationController * fvc = [ControllerManager shareManagerFavorite];
            [self.sideMenuController setContentController:fvc animted:YES];
            [self presentViewController:fvc animated:NO completion:nil];
            
        }
    }
}
#pragma mark -获取用户数据
-(void)getUserData
{
    NSString * url = [NSString stringWithFormat:@"http://54.199.161.210/dc/index.php?r=user/infoApi&&sig=beac851bfcd1b0d3dc98b327aa7fbad2&SID=%@", [ControllerManager getSID]];
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"errorCode"] intValue] == 2) {
                //SID过期,需要重新登录获取SID
                [self login];
                [self getUserData];
                return;
            }else{
                //SID未过期，直接获取用户数据
                NSLog(@"用户数据：%@", load.dataDict);
                NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                [USER setObject:[dict objectForKey:@"age"] forKey:@"age"];
                [USER setObject:[dict objectForKey:@"code"] forKey:@"code"];
                [USER setObject:[dict objectForKey:@"gender"] forKey:@"gender"];
                [USER setObject:[dict objectForKey:@"name"] forKey:@"name"];
                [USER setObject:[dict objectForKey:@"type"] forKey:@"type"];
                [USER setObject:[dict objectForKey:@"usr_id"] forKey:@"usr_id"];
                //                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}
#pragma mark -登录
-(void)login
{
    [[httpDownloadBlock alloc] initWithUrlStr:LOGINAPI Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            [ControllerManager setIsSuccess:[[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]];
            [ControllerManager setSID:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"]];
            NSLog(@"isSuccess:%d,SID:%@", [ControllerManager getIsSuccess], [ControllerManager getSID]);
            if ([ControllerManager getIsSuccess]) {
                [self getUserData];
            }
        }
    }];
}
//#pragma mark -获取用户数据
//-(void)getUserData
//{
//    NSString * url = [NSString stringWithFormat:@"%@%@", INFOAPI, [ControllerManager getSID]];
//    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            if ([[load.dataDict objectForKey:@"errorCode"] intValue] == 2) {
//                //SID过期,需要重新登录获取SID
////                [self login];
//                [self getUserData];
//                return;
//            }else{
//                //SID未过期，直接获取用户数据
//                NSLog(@"用户数据：%@", load.dataDict);
//            }
//        }
//    }];
//}
#pragma mark -毛玻璃效果注册页面
- (void)createLoginAlertView
{
    view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height)];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    UILabel * label = [MyControl createLabelWithFrame:CGRectMake(50, 150, 220, 60) Font:18 Text:@"简单快速的资料完善，\n带您畅游无边的宠物世界！"];
    label.textColor = [UIColor orangeColor];
    [view addSubview:label];
    
//    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeView:)];
//    swipe.direction = UISwipeGestureRecognizerDirectionDown;
//    [view addGestureRecognizer:swipe];
//    [swipe release];
    
//    UIButton * weixin = [MyControl createButtonWithFrame:CGRectMake(30, 220, 60, 60) ImageName:@"2-1.png" Target:self Action:@selector(loginButtonClick:) Title:nil];
//    weixin.tag = 100;
//    
//    [view addSubview:weixin];
//    
//    UILabel * label1 = [MyControl createLabelWithFrame:CGRectMake(0, 65, 60, 20) Font:15 Text:@"微信登录"];
//    label1.textAlignment = NSTextAlignmentCenter;
//    label1.textColor = BGCOLOR;
//    [weixin addSubview:label1];
//    
//    UIButton * weibo = [MyControl createButtonWithFrame:CGRectMake(130, 220, 60, 60) ImageName:@"2-2.png" Target:self Action:@selector(loginButtonClick:) Title:nil];
//    weibo.tag = 200;
//    [view addSubview:weibo];
//    
//    UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(0, 65, 60, 20) Font:15 Text:@"微博登录"];
//    label2.textAlignment = NSTextAlignmentCenter;
//    label2.textColor = BGCOLOR;
//    [weibo addSubview:label2];
//    
//    UIButton * none = [MyControl createButtonWithFrame:CGRectMake(230, 220, 60, 60) ImageName:@"2-1.png" Target:self Action:@selector(loginButtonClick:) Title:nil];
//    none.tag = 300;
//    [view addSubview:none];
//    
//    UILabel * label3 = [MyControl createLabelWithFrame:CGRectMake(0, 65, 60, 20) Font:15 Text:@"快速注册"];
//    label3.textAlignment = NSTextAlignmentCenter;
//    label3.textColor = BGCOLOR;
//    [none addSubview:label3];
    
    UIButton * registerButton = [MyControl createButtonWithFrame:CGRectMake(20, 350, 280, 35) ImageName:@"" Target:self Action:@selector(registerButtonClick) Title:@"马上注册"];
    registerButton.showsTouchWhenHighlighted = YES;
    registerButton.backgroundColor = BGCOLOR;
    registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    registerButton.layer.cornerRadius = 5;
    registerButton.layer.masksToBounds = YES;
    [view addSubview:registerButton];
    
    
}
#pragma mark -view下滑手势事件
//-(void)SwipeView:(UISwipeGestureRecognizer *)swipe
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        view.frame = CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height);
//    }];
//}

#pragma mark
#pragma mark -微信微博登录点击事件
-(void)loginButtonClick:(UIButton *)button
{
    if (button.tag == 100) {
        NSLog(@"微信登录");
    }else if(button.tag == 200){
        NSLog(@"微博登录");
        BOOL isOauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
        NSLog(@"isOauth:%d", isOauth);
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
            if ([response.message isEqualToString:@"no error"]) {
                UIAlertView * alert = [MyControl createAlertViewWithTitle:@"授权成功"];
                NSDictionary * dic = (NSDictionary *)response.data;
                NSDictionary * dict = [dic objectForKey:@"sina"];
                //获取微博信息，存储到本地
                [USER setObject:[dict objectForKey:@"username"] forKey:@"sinaUsername"];
                [USER setObject:[dict objectForKey:@"usid"] forKey:@"sinaUsid"];
                NSLog(@"%@", [USER objectForKey:@"sinaUsid"]);
                //判断是否有绑定的用户
//                #define ISBINDEDAPI @"http://54.199.161.210/dc/index.php?r=user/bindApi&wechat=&weibo="
                NSString * str = [NSString stringWithFormat:@"wechat=&weibo=%@dog&cat", [USER objectForKey:@"sinaUsid"]];
                NSString * code = [MyMD5 md5:str];
                NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", ISBINDEDAPI, [USER objectForKey:@"sinaUsid"], code, [ControllerManager getSID]];
                NSLog(@"%@", url);
                [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
                        int isBinded = [[[load.dataDict objectForKey:@"data"] objectForKey:@"isBinded"] intValue];
                        NSLog(@"%d", [[[load.dataDict objectForKey:@"data"] objectForKey:@"isBinded"] intValue]);
                        view.frame = CGRectMake(0, self.view.frame.size.height+[MyControl isIOS7], 320, self.view.frame.size.height+[MyControl isIOS7]);
                        if (isBinded) {
                            
                        }else{
                            //跳转到注册页面
                            RegisterViewController * vc = [[RegisterViewController alloc] init];
                            UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
                            [self presentViewController:nc animated:YES completion:nil];
                            [nc release];
                            [vc release];
                        }
                    }else{
                        NSLog(@"绑定信息请求失败");
                    }
                }];
                
                
            }else{
                UIAlertView * alert = [MyControl createAlertViewWithTitle:@"错误" Message:response.message delegate:nil cancelTitle:nil otherTitles:@"确定"];
            }
        });
    }else{
        view.frame = CGRectMake(0, self.view.frame.size.height+[MyControl isIOS7], 320, self.view.frame.size.height+[MyControl isIOS7]);
        NSLog(@"快速注册");
        RegisterViewController * vc = [[RegisterViewController alloc] init];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
        [nc release];
        [vc release];
    }
}
-(void)shouquan
{
    
}
-(void)registerButtonClick
{
    self.sc.userInteractionEnabled = YES;
    self.sc.selectedSegmentIndex = 0;
    
    view.frame = CGRectMake(0, self.view.frame.size.height+[MyControl isIOS7], 320, self.view.frame.size.height+[MyControl isIOS7]);
    NSLog(@"快速注册");
    RegisterViewController * vc = [[RegisterViewController alloc] init];
    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
    [nc release];
    [vc release];
//    [UIView animateWithDuration:0.3 animations:^{
//        view.frame = CGRectMake(0, self.view.frame.size.height+[MyControl isIOS7], 320, self.view.frame.size.height+[MyControl isIOS7]);
//    }];
}

#pragma mark -导航按钮点击事件
-(void)myPetClick:(UIButton *)button
{
    
    [USER setObject:@"1" forKey:@"pageNum"];
    //跳转到我的宠物页
    NSLog(@"---跳转到我的宠物页---");
//    button.selected = !button.selected;
    
    if(![ControllerManager getIsSuccess]){
        self.sc.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height+[MyControl isIOS7]);
        }];
    }else{
        JDSideMenu * sideMenu = [ControllerManager shareJDSideMenu];
        [sideMenu showMenuAnimated:YES];
        return;
        
        
        self.navigationItem.leftBarButtonItem.enabled = NO;
        //跳转到我的宠物页
//        MyHomeViewController * nc = [ControllerManager shareManagerMyHome];
//        nc.modalTransitionStyle = 2;
//        [self presentViewController:nc animated:YES completion:nil];
        
        //弹出Menu页
        //头像的加载
        NSString * txFilePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_headImage.png.png", [USER objectForKey:@"usr_id"]]];
        NSLog(@"%@", txFilePath);
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txFilePath]];
        if (image) {
            headImageView.image = image;
        }
        if (!isMenuCreated) {
            [self createMenu];
        }
        //获取活动数及消息数
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", ACTIVITYANDNOTIFYAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                int topic = [[[load.dataDict objectForKey:@"data"] objectForKey:@"topic_count"] intValue];
                int mail = [[[load.dataDict objectForKey:@"data"] objectForKey:@"mail_count"] intValue];
                UIImageView * greenBall1 = (UIImageView *)[menu viewWithTag:50];
                UIImageView * greenBall2 = (UIImageView *)[menu viewWithTag:51];
                
                if (topic == 0) {
                    
                    greenBall1.hidden = YES;
                    activityNumLabel.hidden = YES;
                }else{
                    greenBall1.hidden = NO;
                    activityNumLabel.hidden = NO;
                    activityNumLabel.text = [NSString stringWithFormat:@"%d", topic];
                }
                
                if (mail == 0) {
                    greenBall2.hidden = YES;
                    noticeNumLabel.hidden = YES;
                }else{
                    greenBall2.hidden = NO;
                    noticeNumLabel.hidden = NO;
                    noticeNumLabel.text = [NSString stringWithFormat:@"%d", mail];
                }
            }else{
                UIAlertView * alert = [MyControl createAlertViewWithTitle:@"活动数据请求失败"];
            }
        }];
        [UIView animateWithDuration:0.3 animations:^{
            menu.frame = CGRectMake(0, 0, 320, self.view.frame.size.height+[MyControl isIOS7]);
        }];
        [self performSelector:@selector(bgImageShow) withObject:nil afterDelay:0.3];
    }
}
-(void)bgImageShow
{
    [UIView animateWithDuration:0.3 animations:^{
        bgImageView.frame = CGRectMake(0, 153/2, 320, 178/2);
    }];
}

-(void)cameraButtonClick
{
    [USER setObject:@"3" forKey:@"pageNum"];
    
    if(![ControllerManager getIsSuccess]){
        self.sc.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height+[MyControl isIOS7]);
        }];
    }else{
        [self cameraClick];
    }
}

-(void)cameraClick
{
    if (sheet == nil) {
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        }
        else {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        }
        
        sheet.tag = 255;

    }else{
        
    }
    [sheet showInView:self.view];
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        [USER setObject:[NSString stringWithFormat:@"%d", buttonIndex] forKey:@"buttonIndex"];
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                    
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    isCamara = YES;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    isCamara = NO;
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                isCamara = NO;
            } else {
                return;
            }
        }
        //跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.sourceType = sourceType;
        
        if ([self hasValidAPIKey]) {
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }
        
        [imagePickerController release];
    }
}

#pragma mark - UIImagePicker Delegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSURL * assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];

    void(^completion)(void)  = ^(void){
        if (isCamara) {
            [self lauchEditorWithImage:image];
        }else{
        [[self assetLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            if (asset){
                [self launchEditorWithAsset:asset];
            }
        } failureBlock:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable access to your device's photos." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }];
        }};
    
    [self dismissViewControllerAnimated:NO completion:completion];
    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - ALAssets Helper Methods

- (UIImage *)editingResImageForAsset:(ALAsset*)asset
{
    CGImageRef image = [[asset defaultRepresentation] fullScreenImage];
    
    return [UIImage imageWithCGImage:image scale:1.0 orientation:UIImageOrientationUp];
}

- (UIImage *)highResImageForAsset:(ALAsset*)asset
{
    ALAssetRepresentation * representation = [asset defaultRepresentation];
    
    CGImageRef image = [representation fullResolutionImage];
    UIImageOrientation orientation = (UIImageOrientation)[representation orientation];
    CGFloat scale = [representation scale];
    
    return [UIImage imageWithCGImage:image scale:scale orientation:orientation];
}

#pragma mark - Status Bar Style

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private Helper Methods

- (BOOL) hasValidAPIKey
{
    if ([kAFAviaryAPIKey isEqualToString:@"<YOUR-API-KEY>"] || [kAFAviarySecret isEqualToString:@"<YOUR-SECRET>"]) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                    message:@"You forgot to add your API key and secret!"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}

#pragma mark -图片编辑
#pragma mark =================================
#pragma mark - Photo Editor Launch Methods

//********************自己方法******************
-(void)lauchEditorWithImage:(UIImage *)image
{
    UIImage * editingResImage = image;
    UIImage * highResImage = image;
    [self launchPhotoEditorWithImage:editingResImage highResolutionImage:highResImage];
}

//*********************************************
- (void) launchEditorWithAsset:(ALAsset *)asset
{
    UIImage * editingResImage = [self editingResImageForAsset:asset];
    UIImage * highResImage = [self highResImageForAsset:asset];
    
    [self launchPhotoEditorWithImage:editingResImage highResolutionImage:highResImage];
}
#pragma mark - Photo Editor Creation and Presentation
- (void) launchPhotoEditorWithImage:(UIImage *)editingResImage highResolutionImage:(UIImage *)highResImage
{
    // Customize the editor's apperance. The customization options really only need to be set once in this case since they are never changing, so we used dispatch once here.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setPhotoEditorCustomizationOptions];
    });
    
    // Initialize the photo editor and set its delegate
    AFPhotoEditorController * photoEditor = [[AFPhotoEditorController alloc] initWithImage:editingResImage];
    [photoEditor setDelegate:self];
    
    // If a high res image is passed, create the high res context with the image and the photo editor.
    if (highResImage) {
        [self setupHighResContextForPhotoEditor:photoEditor withImage:highResImage];
    }
    
    // Present the photo editor.
    [self presentViewController:photoEditor animated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void) setupHighResContextForPhotoEditor:(AFPhotoEditorController *)photoEditor withImage:(UIImage *)highResImage
{
    // Capture a reference to the editor's session, which internally tracks user actions on a photo.
    __block AFPhotoEditorSession *session = [photoEditor session];
    
    // Add the session to our sessions array. We need to retain the session until all contexts we create from it are finished rendering.
    [[self sessions] addObject:session];
    
    // Create a context from the session with the high res image.
    AFPhotoEditorContext *context = [session createContextWithImage:highResImage];
    
    __block RootViewController * blockSelf = self;
    
    // Call render on the context. The render will asynchronously apply all changes made in the session (and therefore editor)
    // to the context's image. It will not complete until some point after the session closes (i.e. the editor hits done or
    // cancel in the editor). When rendering does complete, the completion block will be called with the result image if changes
    // were made to it, or `nil` if no changes were made. In this case, we write the image to the user's photo album, and release
    // our reference to the session.
    [context render:^(UIImage *result) {
        if (result) {
//            UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
        }
        
        [[blockSelf sessions] removeObject:session];
        
        blockSelf = nil;
        session = nil;
        
    }];
}

#pragma Photo Editor Delegate Methods

// This is called when the user taps "Done" in the photo editor.
- (void) photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    self.oriImage = image;
    //    [[self imagePreviewView] setImage:image];
    //    [[self imagePreviewView] setContentMode:UIViewContentModeScaleAspectFit];
    
    //跳转到UploadViewController
//    UploadViewController * vc = [[UploadViewController alloc] init];
//    vc.oriImage = image;
//    [self presentViewController:vc animated:YES completion:nil];
    
//    NSLog(@"上传图片");
//    [self postData:image];
    
//    UINavigationController * nc = [ControllerManager shareManagerMyPet];
//    MyPetViewController * vc = nc.viewControllers[0];
//    vc.myBlock();
    
    [self dismissViewControllerAnimated:YES completion:^{
//        UploadViewController * vc = [[UploadViewController alloc] init];
        PublishViewController * vc = [[PublishViewController alloc] init];
        vc.oriImage = image;
//        vc.af = editor;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

// This is called when the user taps "Cancel" in the photo editor.
- (void) photoEditorCanceled:(AFPhotoEditorController *)editor
{
    int a = [[USER objectForKey:@"buttonIndex"] intValue];
    [self dismissViewControllerAnimated:YES completion:^{
        [self actionSheet:sheet clickedButtonAtIndex:a];
    }];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - Photo Editor Customization

- (void) setPhotoEditorCustomizationOptions
{
    // Set API Key and Secret
    [AFPhotoEditorController setAPIKey:kAFAviaryAPIKey secret:kAFAviarySecret];
    
    // Set Tool Order
    NSArray * toolOrder = @[kAFEffects, kAFFocus, kAFFrames, kAFStickers, kAFEnhance, kAFOrientation, kAFCrop, kAFAdjustments, kAFSplash, kAFDraw, kAFText, kAFRedeye, kAFWhiten, kAFBlemish, kAFMeme];
    [AFPhotoEditorCustomization setToolOrder:toolOrder];
    
    // Set Custom Crop Sizes
    [AFPhotoEditorCustomization setCropToolOriginalEnabled:NO];
    [AFPhotoEditorCustomization setCropToolCustomEnabled:YES];
    NSDictionary * fourBySix = @{kAFCropPresetHeight : @(4.0f), kAFCropPresetWidth : @(6.0f)};
    NSDictionary * fiveBySeven = @{kAFCropPresetHeight : @(5.0f), kAFCropPresetWidth : @(7.0f)};
    NSDictionary * square = @{kAFCropPresetName: @"Square", kAFCropPresetHeight : @(1.0f), kAFCropPresetWidth : @(1.0f)};
    [AFPhotoEditorCustomization setCropToolPresets:@[fourBySix, fiveBySeven, square]];
    
    // Set Supported Orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray * supportedOrientations = @[@(UIInterfaceOrientationPortrait), @(UIInterfaceOrientationPortraitUpsideDown), @(UIInterfaceOrientationLandscapeLeft), @(UIInterfaceOrientationLandscapeRight)];
        [AFPhotoEditorCustomization setSupportedIpadOrientations:supportedOrientations];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
