//
//  JDMenuViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "JDMenuViewController.h"
#import "PetInfoViewController.h"
#define MENUCOLOR [UIColor colorWithRed:125/255.0 green:60/255.0 blue:45/255.0 alpha:1]
//各个国家头像之间的间隔 (176-40*3)/2+40
#define SPACE 68
//偏移量
#define OFFSET 225
#import "ActivityViewController.h"
#import "NoticeViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "SettingViewController.h"
#import "MainTabBarViewController.h"
#import "RandomViewController.h"
#import "MainViewController.h"
#import "ToolTipsViewController.h"
#import "GiftShopViewController.h"
#import "UserInfoViewController.h"
#import "SearchResultModel.h"
#import "PetInfoViewController.h"
#import "ChoseLoadViewController.h"
#import "JDSideMenuCell.h"
@interface JDMenuViewController ()

@end

@implementation JDMenuViewController

-(void)viewWillAppear:(BOOL)animated
{
    //1 代表未注册  2 代表刚注册  3代表已注册
    if ([[USER objectForKey:@"isNotRegister"] intValue] == 2) {
        [USER setObject:@"3" forKey:@"isNotRegister"];
        for (UIView * view in self.view.subviews) {
            [view removeFromSuperview];
        }
        [self createBg];
        [self createUI];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.countryArray = [NSMutableArray arrayWithCapacity:0];
    self.searchArray = [NSMutableArray arrayWithCapacity:0];
    self.receivedNewMsgArray = [NSMutableArray arrayWithCapacity:0];
    self.valueArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createBg];
    [self createUI];
    
    JDSideMenu * sideMenu = [ControllerManager shareJDSideMenu];
    sideMenu.refreshData = ^(){
        [self refreshCountryList];
//        [self createUI];
    };
    
    sideMenu.refreshActNum = ^(NSString * actNum){
        activityNumLabel.text = actNum;
        if ([actNum intValue] != 0) {
            actGreenBall.hidden = NO;
        }
    };
    
    sideMenu.refreshUserData = ^(){
        NSLog(@"====refreshUserData====");
        if ([[USER objectForKey:@"isSuccess"] intValue]) {
            goldLabel.text = [USER objectForKey:@"gold"];
            position.text = [NSString stringWithFormat:@"%@联萌%@", [[USER objectForKey:@"petInfoDict"] objectForKey:@"name"], [ControllerManager returnPositionWithRank:[USER objectForKey:@"rank"]]];;
            exp.text = [NSString stringWithFormat:@"Lv.%@", [USER objectForKey:@"lv"]];
            name.text = [USER objectForKey:@"name"];
            sex.hidden = NO;
            if ([[USER objectForKey:@"gender"] intValue] == 1) {
                sex.image = [UIImage imageNamed:@"man.png"];
            }else{
                sex.image = [UIImage imageNamed:@"woman.png"];
            }
            /**************************/
            if (!([[USER objectForKey:@"tx"] isKindOfClass:[NSNull class]] || [[USER objectForKey:@"tx"] length]==0)) {
                NSString * docDir = DOCDIR;
                NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [USER objectForKey:@"tx"]]];
                //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
                UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
                if (image) {
                    [headImageBtn setBackgroundImage:image forState:UIControlStateNormal];
                    //            headImageView.image = image;
                }else{
                    //下载头像
                    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", USERTXURL, [USER objectForKey:@"tx"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                        if (isFinish) {
                            [headImageBtn setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                            //                    headImageView.image = load.dataImage;
                            NSString * docDir = DOCDIR;
                            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [USER objectForKey:@"tx"]]];
                            [load.data writeToFile:txFilePath atomically:YES];
                        }else{
                            NSLog(@"头像下载失败");
                        }
                    }];
                    [request release];
                }
            }
            /**************************/
        }
    };
    //
    sideMenu.refreshNewMsgNum = ^(NSArray * array){
        NSArray * newMsgArray = [NSArray arrayWithArray:array];
        if (newMsgArray.count) {
            messageNumBg.hidden = NO;
            //解析数目
            int msgCount = 0;
            for (int i=0; i<newMsgArray.count; i++) {
                NSDictionary * dict1 = newMsgArray[i];
                NSString * key = [[dict1 allKeys] objectAtIndex:0];
                NSDictionary * dict2 = [dict1 objectForKey:key];
                msgCount += [[dict2 objectForKey:@"new_msg"] intValue];
            }
            noticeNumLabel.text = [NSString stringWithFormat:@"%d", msgCount];
            self.receivedNewMsgArray = [NSMutableArray arrayWithArray:newMsgArray];
        }else{
            messageNumBg.hidden = YES;
            [self.receivedNewMsgArray removeAllObjects];
        }
    };
    
}
-(void)refreshCountryList
{
    UIView * view = (UIView *)[self.view viewWithTag:99];
    for (UIView * subview in view.subviews) {
        [subview removeFromSuperview];
    }
    JDSideMenu * sideMenu = [ControllerManager shareJDSideMenu];
    countryCount = sideMenu.userPetListArray.count;
    
    //清空数据
    [self.countryArray removeAllObjects];
    changeNum = 0;
    
    for (int i=0; i<sideMenu.userPetListArray.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(3+i*SPACE, 12.5, 40, 40);
        button.layer.cornerRadius = 20;
        button.layer.masksToBounds = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"defaultPetHead.png"] forState:UIControlStateNormal];
        /**************************/
        if (!([[sideMenu.userPetListArray[i] tx] isKindOfClass:[NSNull class]] || [[sideMenu.userPetListArray[i] tx] length]==0)) {
            NSString * docDir = DOCDIR;
            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [sideMenu.userPetListArray[i] tx]]];
            //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
            UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
            if (image) {
                [button setBackgroundImage:image forState:UIControlStateNormal];
                //            headImageView.image = image;
            }else{
                //下载头像
                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, [sideMenu.userPetListArray[i] tx]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
                        [button setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                        //                    headImageView.image = load.dataImage;
                        NSString * docDir = DOCDIR;
                        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [sideMenu.userPetListArray[i] tx]]];
                        [load.data writeToFile:txFilePath atomically:YES];
                    }else{
                        NSLog(@"头像下载失败");
                    }
                }];
                [request release];
            }
        }
        /**************************/
        [button addTarget:self action:@selector(countryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [view addSubview:button];
        
        [self.countryArray addObject:button];
        
        if ([[sideMenu.userPetListArray[i] aid] isEqualToString:[USER objectForKey:@"aid"]]) {
            selectedNum = i+1;
            //王冠
//            UIButton * button = self.countryArray[selectedNum-1];
            crown = [MyControl createImageViewWithFrame:CGRectMake(button.frame.origin.x+25, button.frame.origin.y+27, 18, 18) ImageName:@"crown.png"];
            [view addSubview:crown];
        }
    }
//    NSLog(@"selectedNum:%d", selectedNum);
}
#pragma mark - 界面搭建
-(void)createBg
{
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:self.bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
//    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"%@", data);
    UIImage * image = [UIImage imageWithData:data];
    self.bgImageView.image = image;

//    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
//    [self.view addSubview:tempView];
}

-(void)createUI
{
    //背景
//    UIImageView * menu = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"30-3.png"];
//    [self.view addSubview:menu];
 
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    alphaView.backgroundColor = [ControllerManager colorWithHexString:@"eb7150"];
    alphaView.alpha = 0.6;
    [self.view addSubview:alphaView];
    
    //scrollView
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, 225, self.view.frame.size.height-20)];
    sv.contentSize = CGSizeMake(225*2, 568-20);
    sv.showsVerticalScrollIndicator = NO;
    sv.scrollEnabled = NO;
    [self.view addSubview:sv];
    
    sv3 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 225, self.view.frame.size.height-20)];
    sv3.contentSize = CGSizeMake(225, 568-20);
    sv3.showsVerticalScrollIndicator = NO;
    [sv addSubview:sv3];
    
    //搜索框
    UIView * searchBgView = [MyControl createViewWithFrame:CGRectMake(15, 15+20, 340/2, 25)];
    searchBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    searchBgView.alpha = 0.6;
    searchBgView.layer.cornerRadius = 7;
    searchBgView.layer.masksToBounds = YES;
    [self.view addSubview:searchBgView];

    UIImageView * searchView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 25, 12) ImageName:@""];
    UIImageView * searchImageView = [MyControl createImageViewWithFrame:CGRectMake(3, -1.5, 12, 12) ImageName:@"menu-1.png"];
    [searchView addSubview:searchImageView];
    
    tfSearch = [MyControl createTextFieldWithFrame:CGRectMake(15, 15+20+1, 340/2, 25) placeholder:nil passWord:NO leftImageView:searchView rightImageView:nil Font:11];
    tfSearch.delegate = self;
    tfSearch.returnKeyType = UIReturnKeySearch;
    tfSearch.textColor = [UIColor whiteColor];
    tfSearch.backgroundColor = [UIColor clearColor];
    tfSearch.borderStyle = 0;
    tfSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索萌宠昵称" attributes:@{NSForegroundColorAttributeName:BGCOLOR}];
    [self.view addSubview:tfSearch];
    
    searchBtn = [MyControl createButtonWithFrame:CGRectMake(370/2, 37, 38, 20) ImageName:@"" Target:self Action:@selector(searchBtnClick) Title:@"取消"];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    searchBtn.hidden = YES;
    [self.view addSubview:searchBtn];
    
    //消息
    UIButton * messageBtn = [MyControl createButtonWithFrame:CGRectMake(370/2, 50, 25, 25) ImageName:@"menu_message.png" Target:self Action:@selector(messageBtnClick) Title:nil];
    [sv3 addSubview:messageBtn];
    
    messageNumBg = [MyControl  createImageViewWithFrame:CGRectMake(17, -7., 15, 15) ImageName:@"greenBall.png"];
    messageNumBg.tag = 49;
    messageNumBg.hidden = YES;
    [messageBtn addSubview:messageNumBg];
    
    noticeNumLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 15, 15) Font:14 Text:@"5"];
    noticeNumLabel.textAlignment = NSTextAlignmentCenter;
    [messageNumBg addSubview:noticeNumLabel];
    
//    UIButton * question = [MyControl createButtonWithFrame:CGRectMake(190, 50, 18, 18) ImageName:@"" Target:self Action:@selector(questionClick) Title:@"?"];
//    question.backgroundColor = [ControllerManager colorWithHexString:@"ecc7bb"];
//    [question setTitleColor:BGCOLOR forState:UIControlStateNormal];
//    question.titleLabel.font = [UIFont systemFontOfSize:12];
//    question.layer.cornerRadius = 9;
//    question.layer.masksToBounds = YES;
//    [sv addSubview:question];
    
    //头像
    UIView * headBg1 = [MyControl createViewWithFrame:CGRectMake(150/2, 60, 80, 80)];
    headBg1.layer.cornerRadius = 40;
    headBg1.layer.masksToBounds = YES;
    headBg1.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [sv3 addSubview:headBg1];
    
    UIView * headBg2 = [MyControl createViewWithFrame:CGRectMake(headBg1.frame.origin.x+5, headBg1.frame.origin.y+5, 70, 70)];
    headBg2.layer.cornerRadius = 35;
    headBg2.layer.masksToBounds = YES;
    headBg2.backgroundColor = [UIColor whiteColor];
    [sv3 addSubview:headBg2];
    
    if ([[USER objectForKey:@"isSuccess"] intValue]) {
        headImageBtn = [MyControl createButtonWithFrame:CGRectMake(4, 4, 62, 62) ImageName:@"defaultUserHead.png" Target:self Action:@selector(headImageBtnClick) Title:nil];
        //    headImageView = [[ClickImage alloc] initWithFrame:CGRectMake(4, 4, 62, 62)];
        //    headImageView.canClick = YES;
        //    headImageView.image = [UIImage imageNamed:@"defaultUserHead.png"];
        headImageBtn.layer.cornerRadius = 31;
        headImageBtn.layer.masksToBounds = YES;
        [headBg2 addSubview:headImageBtn];
        /**************************/
        if (!([[USER objectForKey:@"tx"] isKindOfClass:[NSNull class]] || [[USER objectForKey:@"tx"] length]==0)) {
            NSString * docDir = DOCDIR;
            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [USER objectForKey:@"tx"]]];
            //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
            UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
            if (image) {
                [headImageBtn setBackgroundImage:image forState:UIControlStateNormal];
                //            headImageView.image = image;
            }else{
                //下载头像
                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", USERTXURL, [USER objectForKey:@"tx"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
                        [headImageBtn setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                        //                    headImageView.image = load.dataImage;
                        NSString * docDir = DOCDIR;
                        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [USER objectForKey:@"tx"]]];
                        [load.data writeToFile:txFilePath atomically:YES];
                    }else{
                        NSLog(@"头像下载失败");
                    }
                }];
                [request release];
            }
        }
        
        /**************************/
    }else{
        //未注册
        headClickImage = [[ClickImage alloc] initWithFrame:CGRectMake(4, 4, 62, 62)];
        headClickImage.image = [UIImage imageNamed:@"defaultUserHead.png"];
        headClickImage.canClick = YES;
        headClickImage.layer.cornerRadius = 31;
        headClickImage.layer.masksToBounds = YES;
        [headBg2 addSubview:headClickImage];
        
        messageNumBg.hidden = YES;
    }
    
    //等级
    exp = [MyControl createLabelWithFrame:CGRectMake(headBg2.frame.origin.x+4+48, headBg2.frame.origin.y+4+50, 30, 16) Font:10 Text:[NSString stringWithFormat:@"Lv.%@", [USER objectForKey:@"lv"]]];
    exp.textAlignment = NSTextAlignmentCenter;
    exp.backgroundColor = [UIColor colorWithRed:249/255.0 green:135/255.0 blue:88/255.0 alpha:1];
    exp.textColor = [UIColor colorWithRed:229/255.0 green:79/255.0 blue:36/255.0 alpha:1];
    exp.layer.cornerRadius = 3;
    exp.layer.masksToBounds = YES;
    exp.font = [UIFont boldSystemFontOfSize:10];
    [sv3 addSubview:exp];
    
    //性别，姓名，官职
    sex = [MyControl createImageViewWithFrame:CGRectMake(25, 140+5, 34/2, 34/2) ImageName:@"man.png"];
    if ([[USER objectForKey:@"gender"] intValue] == 2) {
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    [sv3 addSubview:sex];
    
    name = [MyControl createLabelWithFrame:CGRectMake(sex.frame.origin.x+14+10, sex.frame.origin.y, 150, 20) Font:15 Text:[USER objectForKey:@"name"]];
    [sv3 addSubview:name];
    
    //官职  225menu总宽
//    UILabel * kingName = [MyControl createLabelWithFrame:CGRectMake(25, sex.frame.origin.y+20, 125, 20) Font:14 Text:[NSString stringWithFormat:@"%@国", [USER objectForKey:@"a_name"]]];
//    [sv3 addSubview:kingName];
    
    position = [MyControl createLabelWithFrame:CGRectMake(25, sex.frame.origin.y+20, 125, 20) Font:13 Text:[NSString stringWithFormat:@"%@国祭司", [USER objectForKey:@"a_name"]]];
    [sv3 addSubview:position];
    if ([[USER objectForKey:@"petInfoDict"] isKindOfClass:[NSDictionary class]] && [USER objectForKey:@"rank"] != nil && [[USER objectForKey:@"rank"] length] != 0) {
        position.text = [NSString stringWithFormat:@"%@联萌%@", [[USER objectForKey:@"petInfoDict"] objectForKey:@"name"], [ControllerManager returnPositionWithRank:[USER objectForKey:@"rank"]]];
    }
    
    
    //金币
    UIImageView * gold = [MyControl createImageViewWithFrame:CGRectMake(170, sex.frame.origin.y-2, 22, 22) ImageName:@"gold.png"];
    [sv3 addSubview:gold];
    
    goldLabel = [MyControl createLabelWithFrame:CGRectMake(151, gold.frame.origin.y+23, 60, 20) Font:14 Text:[USER objectForKey:@"gold"]];
//    goldLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    goldLabel.textAlignment = NSTextAlignmentCenter;
    [sv3 addSubview:goldLabel];
    goldLabel.center = CGPointMake(gold.center.x, gold.center.y+gold.frame.size.height);
    
    /******************************************/
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        exp.hidden = YES;
        sex.hidden = YES;
        name.frame = CGRectMake(25, 145, 150, 20);
        name.text = @"游荡的两脚兽";
        position.text = @"陌生人";
        goldLabel.text = @"500";
    }
    /******************************************/
    
    //金币及商店
//    UIImageView * goldBgImageView = [MyControl createImageViewWithFrame:CGRectMake(10, position.frame.origin.y+30, 205, 35) ImageName:@""];
//    goldBgImageView.image = [[UIImage imageNamed:@"menu-4.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//    [self.view addSubview:goldBgImageView];
//    
//    UIView * vLine = [MyControl createViewWithFrame:CGRectMake(102, 5, 3, 25)];
//    vLine.backgroundColor = [UIColor colorWithRed:252/255.0 green:120/255.0 blue:90/255.0 alpha:1];
//    [goldBgImageView addSubview:vLine];
//    
//    UIImageView * gold = [MyControl createImageViewWithFrame:CGRectMake(10, 7, 22, 20) ImageName:@"menu-5.png"];
//    [goldBgImageView addSubview:gold];
//    
//    UILabel * goldLabel = [MyControl createLabelWithFrame:CGRectMake(40, 7, 60, 20) Font:15 Text:@"20000"];
////    goldLabel.textAlignment = NSTextAlignmentCenter;
//    [goldBgImageView addSubview:goldLabel];
//    
//    UIImageView * shop = [MyControl createImageViewWithFrame:CGRectMake(120, 7, 20, 20) ImageName:@"menu-6.png"];
//    [goldBgImageView addSubview:shop];
//    
//    UILabel * shopLabel = [MyControl createLabelWithFrame:CGRectMake(130, 7, 70, 20) Font:15 Text:@"商城"];
//    shopLabel.textAlignment = NSTextAlignmentCenter;
//    [goldBgImageView addSubview:shopLabel];
//    
//    UIButton * shopBtn = [MyControl createButtonWithFrame:goldBgImageView.frame ImageName:@"" Target:self Action:@selector(shopBtnClick) Title:nil];
//    [self.view addSubview:shopBtn];
    
    //下半段的20%透明黑背景
    UIView * blackView = [MyControl createViewWithFrame:CGRectMake(0, position.frame.origin.y+20+10, OFFSET, sv.contentSize.height-(position.frame.origin.y+20+10))];
    blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [sv3 addSubview:blackView];
    
    //当前国家和其他国家
    
    //一个透明一个不透明
    UIView * countryBg = [MyControl createViewWithFrame:CGRectMake(0, blackView.frame.origin.y, OFFSET, 65)];
    [sv3 addSubview:countryBg];
    
    UIView * countryBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, OFFSET, 65)];
    countryBgView.backgroundColor = [ControllerManager colorWithHexString:@"8e2918"];
    countryBgView.alpha = 0.4;
    [countryBg addSubview:countryBgView];
    
    
    
    //红圆圈
//    UIImageView * currentBgView = [MyControl createImageViewWithFrame:CGRectMake((70-46)/2-3, 9.5-3, 52, 52) ImageName:@"circleBg.png"];
//    [countryBg addSubview:currentBgView];
    
    
//    UILabel * countryLabel = [MyControl createLabelWithFrame:CGRectMake(15, 2, 50, 20) Font:12 Text:@"当前国家"];
//    countryLabel.textAlignment = NSTextAlignmentCenter;
//    [countryBg addSubview:countryLabel];
    
//    UIView * currentBgView = [MyControl createViewWithFrame:CGRectMake(15, 7.5, 50, 50)];
//    currentBgView.backgroundColor = BGCOLOR;
//    currentBgView.layer.cornerRadius = 25;
//    currentBgView.layer.masksToBounds = YES;
//    [countryBg addSubview:currentBgView];
//    
//    UIView * currentBgView2 = [MyControl createViewWithFrame:CGRectMake(2, 2, 46, 46)];
//    currentBgView2.backgroundColor = [UIColor colorWithRed:134/255.0 green:76/255.0 blue:53/255.0 alpha:1];
//    currentBgView2.layer.cornerRadius = 23;
//    currentBgView2.layer.masksToBounds = YES;
//    [currentBgView addSubview:currentBgView2];
    
    /******创建各个国家的图标在一个scrollView上******/
    if ([[USER objectForKey:@"isSuccess"] intValue]) {
        //添加左右两个箭头
        UIImageView * leftArrow = [MyControl createImageViewWithFrame:CGRectMake(8, (65-18)/2, 11, 18) ImageName:@"menu_left.png"];
        [countryBg addSubview:leftArrow];
        
        UIImageView * rightArrow = [MyControl createImageViewWithFrame:CGRectMake(414/2, (65-18)/2, 11, 18) ImageName:@"menu_right.png"];
        [countryBg addSubview:rightArrow];
        
        UIView * gestureView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 65)];
        [countryBg addSubview:gestureView];
        
        countryCount = 3;
        selectedNum = 1;
        
        /*****************国家循环*******************/
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(25-3, 0, 176+6, 65)];
        //    view.backgroundColor = [UIColor lightGrayColor];
        view.clipsToBounds = YES;
        view.tag = 99;
        [countryBg addSubview:view];
        
        for (int i=0; i<countryCount; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(3+i*SPACE, 12.5, 40, 40);
            button.layer.cornerRadius = 20;
            button.layer.masksToBounds = YES;
            [button setBackgroundImage:[UIImage imageNamed:@"defaultPetHead.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(countryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100+i;
            [view addSubview:button];
            
            [self.countryArray addObject:button];
        }
        //王冠
        UIButton * button = self.countryArray[selectedNum-1];
        crown = [MyControl createImageViewWithFrame:CGRectMake(button.frame.origin.x+25, button.frame.origin.y+27, 18, 18) ImageName:@"crown.png"];
        [view addSubview:crown];
        
        UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [view addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [view addGestureRecognizer:swipeRight];
    }else{
        //未注册
        UIImageView * ambassador = [MyControl createImageViewWithFrame:CGRectMake(12, 15, 158/2, 35) ImageName:@"ambassador.png"];
        [countryBg addSubview:ambassador];
        
        UILabel * tip1 = [MyControl createLabelWithFrame:CGRectMake(95, 15, 125, 15) Font:11 Text:@"宠物星球，宠来宠趣"];
        tip1.textAlignment = NSTextAlignmentCenter;
        [countryBg addSubview:tip1];
        
        UILabel * tip2 = [MyControl createLabelWithFrame:CGRectMake(95, 35, 125, 15) Font:11 Text:@"快来创建或者加入王国吧"];
        tip2.textAlignment = NSTextAlignmentCenter;
        [countryBg addSubview:tip2];
        
        UIButton * regBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, OFFSET, 65) ImageName:@"" Target:self Action:@selector(regBtnClick) Title:nil];
        [countryBg addSubview:regBtn];
    }
    
    
    
    /*****************************************/
//    sv2 = [[UIScrollView alloc] initWithFrame:CGRectMake(25, 0, 176, 65)];
//    sv2.pagingEnabled = YES;
////    sv2.backgroundColor = [UIColor redColor];
//    sv2.contentSize = CGSizeMake(countryCount/3*176, 65);
//    sv2.showsHorizontalScrollIndicator = NO;
////    sv2.delegate = self;
//    [countryBg addSubview:sv2];
    
//    for(int i=0;i<countryCount;i++){
////        CGRectMake(15+2+i*(46+2+30), 9.5, 46, 46)
//        UIButton * countryImageBtn = [MyControl createButtonWithFrame:CGRectMake(i/3*176+i%3*(136/2), (65-40)/2, 40, 40) ImageName:@"" Target:self Action:@selector(countryImageBtnClick:) Title:nil];
////        UIImageView * countryImageView = [MyControl createImageViewWithFrame:CGRectMake(i/3*176+i%3*(136/2), (65-40)/2, 40, 40) ImageName:@""];
//        countryImageBtn.layer.cornerRadius = 20;
//        countryImageBtn.layer.masksToBounds = YES;
//        [sv2 addSubview:countryImageBtn];
//        countryImageBtn.tag = 3000+i;
//        if (i%2 == 0) {
//            [countryImageBtn setImage:[UIImage imageNamed:@"cat1.jpg"] forState:UIControlStateNormal];
////            countryImageView.image = [UIImage imageNamed:@"cat1.jpg"];
//        }else{
//            [countryImageBtn setImage:[UIImage imageNamed:@"cat2.jpg"] forState:UIControlStateNormal];
////            countryImageView.image = [UIImage imageNamed:@"cat2.jpg"];
//        }
//    }
    
    
    //添加左右2个手势
//    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
//    [gestureView addGestureRecognizer:swipeRight];
//    UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
//    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
//    [gestureView addGestureRecognizer:swipeLeft];
    //将头像循环
    
    
    /********************************************/
    
//    UIImageView * currentImageView = [MyControl createImageViewWithFrame:CGRectMake(3, 3, 40, 40) ImageName:@"cat2.jpg"];
//    currentImageView.layer.cornerRadius = 40/2;
//    currentImageView.layer.masksToBounds = YES;
//    [currentBgView addSubview:currentImageView];
    
    //首页，商城，消息，活动，设置
    noticeBgView = [MyControl createViewWithFrame:CGRectMake(0, countryBg.frame.origin.y+65+20, 320, 230)];
//    noticeBgView.backgroundColor = [UIColor purpleColor];
    [sv3 addSubview:noticeBgView];
    
    /*******************/
    NSArray * array = @[@"menu-13.png", @"menu-14.png", @"menu-8.png", @"menu-10.png", @"through.png"];
    NSArray * array2 = @[@"首页", @"商城", @"活动", @"设置", @"穿越"];
    for(int i=0;i<array.count;i++){
        UIView * bgView = [MyControl createViewWithFrame:CGRectMake(0, i*45-5, OFFSET, 40)];
        [noticeBgView addSubview:bgView];
        bgView.tag = 2000+i;
        
        UIImageView * imageView = [MyControl createImageViewWithFrame:CGRectMake(25, 5, 30, 30) ImageName:array[i]];
        [bgView addSubview:imageView];
        
        if (i == 2) {
            actGreenBall = [MyControl createImageViewWithFrame:CGRectMake(20, -3, 15, 15) ImageName:@"greenBall.png"];
            actGreenBall.hidden = YES;
            actGreenBall.tag = 50;
            [imageView addSubview:actGreenBall];
            
            activityNumLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 15, 15) Font:14 Text:@"1"];
            activityNumLabel.textAlignment = NSTextAlignmentCenter;
//            activityNumLabel.hidden = YES;
            [actGreenBall addSubview:activityNumLabel];
            
        }
//        if (i == 2) {
//            UIImageView * greenBall = [MyControl createImageViewWithFrame:CGRectMake(20, -3, 15, 15) ImageName:@"29-8.png"];
////            greenBall.hidden = YES;
//            greenBall.tag = 51;
//            [imageView addSubview:greenBall];
//            
//            noticeNumLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 15, 15) Font:14 Text:@"5"];
//            noticeNumLabel.textAlignment = NSTextAlignmentCenter;
////            noticeNumLabel.hidden = YES;
//            [greenBall addSubview:noticeNumLabel];
//        }
        
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(85, 5+5, 100, 20) Font:15 Text:array2[i]];
        label.font = [UIFont systemFontOfSize:17];
        [bgView addSubview:label];
        
        UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(370/2, 7.5+5, 9, 15) ImageName:@"menu-11.png"];
        [bgView addSubview:arrow];
        
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(0, 0, OFFSET, 35) ImageName:nil Target:self Action:@selector(menuButtonClick:) Title:nil];
        [button addTarget:self action:@selector(menuButtonClick2:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(menuButtonClick3) forControlEvents:UIControlEventTouchDragOutside];
        [bgView addSubview:button];
        button.tag = 1000+i;
    }
    /*************************/
    //猫狗切换
//    UIView * switchView = [MyControl createImageViewWithFrame:CGRectMake(350/2, sv.contentSize.height-40, 30, 30) ImageName:@""];
//    switchView.backgroundColor = [ControllerManager colorWithHexString:@"944131"];
//    switchView.layer.cornerRadius = 15;
//    switchView.layer.masksToBounds = YES;
//    [sv addSubview:switchView];
//    
//    UIImageView * switchImageView = [MyControl createImageViewWithFrame:CGRectMake(2.5, 6, 25, 18) ImageName:@"menu-9.png"];
//    [switchView addSubview:switchImageView];
//    
//    UIButton * switchCategory = [MyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) ImageName:@"" Target:self Action:@selector(switchCategoryClick) Title:nil];
//    [switchView addSubview:switchCategory];
    
    /*************创建tableView***************/
    tv = [[UITableView alloc] initWithFrame:CGRectMake(225, 50, 220, self.view.frame.size.height-20-50) style:UITableViewStylePlain];
    tv.dataSource = self;
    tv.delegate = self;
    tv.backgroundColor = [UIColor clearColor];
    tv.separatorStyle = 0;
    [sv addSubview:tv];
}
#pragma mark -
-(void)regBtnClick
{
    ShowAlertView;
}
-(void)headImageBtnClick
{
    UserInfoViewController * vc = [[UserInfoViewController alloc] init];
    vc.usr_id = [USER objectForKey:@"usr_id"];
    vc.modalTransitionStyle = 2;
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)searchBtnClick
{
    if ([searchBtn.titleLabel.text isEqualToString:@"取消"]) {
        NSLog(@"取消~~~");
        [tfSearch resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            sv.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            searchBtn.hidden = YES;
            [self.searchArray removeAllObjects];
            [tv reloadData];
        }];
        [self.searchArray removeAllObjects];
        [tv reloadData];
    }else{
        NSLog(@"搜索用户~~~");
        NSLog(@"搜索%@", tfSearch.text);
        [self loadSearchData:tfSearch.text];
        [tfSearch resignFirstResponder];
//        [self.searchArray addObject:@"11"];
//        [tv reloadData];
    }
    
}
-(void)swipeLeft
{
//    NSLog(@"changeNum:%d", changeNum);
    if (direction) {
        direction = 0;
        changeNum  -= self.countryArray.count-1;
        if (changeNum < 0) {
            changeNum += self.countryArray.count;
        }
    }
//    NSLog(@"changeNum:%d", changeNum);
    NSLog(@"left");
    CGRect rect = CGRectZero;
    for (int i=0;i<self.countryArray.count;i++) {
        UIButton * btn = self.countryArray[i];
        rect = btn.frame;
        rect.origin.x -= SPACE;
        [UIView animateWithDuration:0.3 animations:^{
            btn.frame = rect;
            if (selectedNum-1 == i) {
                crown.frame = CGRectMake(rect.origin.x+25, rect.origin.y+27, 18, 18);
            }
        } completion:^(BOOL finished) {
            if (i == countryCount-1) {
//                for(int j=0;j<self.countryArray.count;j++){
//                    UIButton * bt = self.countryArray[j];
//                    NSLog(@"%f", bt.frame.origin.x);
//                }
//                NSLog(@"==================changeNum:%d", changeNum);
                UIButton * btn2 = (UIButton *)[self.view viewWithTag:100+changeNum];
                btn2.frame = CGRectMake(btn2.frame.origin.x+self.countryArray.count*SPACE, btn2.frame.origin.y, btn2.frame.size.width, btn2.frame.size.height);
                //王冠位置
                if (selectedNum-1 == changeNum) {
                    crown.frame = CGRectMake(btn2.frame.origin.x+25, btn2.frame.origin.y+27, 18, 18);
                }
                
                changeNum += 1;
                if (changeNum == self.countryArray.count) {
                    changeNum = 0;
                }
//                for(int j=0;j<self.countryArray.count;j++){
//                    UIButton * bt = self.countryArray[j];
//                    NSLog(@"%f", bt.frame.origin.x);
//                }
            }
        }];
    }
    
    
}
-(void)swipeRight
{
    if (!direction) {
        changeNum += self.countryArray.count-1;
        changeNum %= self.countryArray.count;
        direction = 1;
    }
    
    //    if (changeNum == -1) {
    //        changeNum += self.array.count;
    //    }
    NSLog(@"right");
    CGRect rect = CGRectZero;
    
    for (int i=0;i<self.countryArray.count;i++) {
        UIButton * btn = self.countryArray[i];
        rect = btn.frame;
        rect.origin.x += SPACE;
        [UIView animateWithDuration:0.3 animations:^{
            btn.frame = rect;
            if (selectedNum-1 == i) {
                crown.frame = CGRectMake(rect.origin.x+25, rect.origin.y+27, 18, 18);
            }
        } completion:^(BOOL finished) {
            if (i == self.countryArray.count-1) {
//                for(int j=0;j<self.countryArray.count;j++){
//                    UIButton * bt = self.countryArray[j];
//                    NSLog(@"%f", bt.frame.origin.x);
//                }
//                NSLog(@"==================changeNum:%d", changeNum);
                UIButton * btn2 = (UIButton *)[self.view viewWithTag:100+changeNum];
                btn2.frame = CGRectMake(btn2.frame.origin.x-self.countryArray.count*SPACE, btn2.frame.origin.y, btn2.frame.size.width, btn2.frame.size.height);
                //王冠位置
                if (selectedNum-1 == changeNum) {
                    crown.frame = CGRectMake(btn2.frame.origin.x+25, btn2.frame.origin.y+27, 18, 18);
                }
                
                changeNum -= 1;
                if (changeNum == -1) {
                    changeNum = self.countryArray.count-1;
                }
//                for(int j=0;j<self.countryArray.count;j++){
//                    UIButton * bt = self.countryArray[j];
//                    NSLog(@"%f", bt.frame.origin.x);
//                }
            }
        }];
    }
}
-(void)countryButtonClick:(UIButton *)btn
{
    JDSideMenu * sideMenu = [ControllerManager shareJDSideMenu];
    NSLog(@"您点击了第%d个国家,名称是:%@", btn.tag-100+1, [sideMenu.userPetListArray[btn.tag-100] name]);
    
    PetInfoViewController * vc = [[PetInfoViewController alloc] init];
    vc.aid = [sideMenu.userPetListArray[btn.tag-100] aid];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
//    selectedNum = btn.tag-100+1;
//    UIButton * button = self.countryArray[btn.tag-100];
//    crown.frame = CGRectMake(button.frame.origin.x+25, button.frame.origin.y+27, 18, 18);
}

//-(void)countryImageBtnClick:(UIButton *)btn
//{
//    NSLog(@"您点击了第%d个国家", btn.tag-3000+1);
//}
//-(void)swipe:(UISwipeGestureRecognizer *)Swipe
//{
//    NSLog(@"Right");
//    [UIView animateWithDuration:0.2 animations:^{
//        sv2.contentOffset = CGPointMake(sv2.contentOffset.x-70, 0);
//    }];
//    
//}
//-(void)swipeLeft:(UISwipeGestureRecognizer *)Swipe
//{
//    NSLog(@"Left");
//    [UIView animateWithDuration:0.2 animations:^{
//        sv2.contentOffset = CGPointMake(sv2.contentOffset.x+70, 0);
//    }];
//}
#pragma mark - 加载数据
//参数name不需要加密
- (void)loadSearchData:(NSString *)nameStr{
    NSString *searchSig = [MyMD5 md5:[NSString stringWithFormat:@"dog&cat"]];
    NSString *searchString = [NSString stringWithFormat:@"%@&name=%@&sig=%@&SID=%@", SEARCHAPI, [nameStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], searchSig,[ControllerManager getSID]];
    NSLog(@"搜索API:%@",searchString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:searchString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            [self.searchArray removeAllObjects];
            
            NSLog(@"搜索结果：%@",load.dataDict);

            NSArray *array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary *dict in array) {
                SearchResultModel *model = [[SearchResultModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.searchArray addObject:model];
                [model release];
            }
            [tv reloadData];
        }
    }];
    [request release];
}
#pragma mark - scrollView代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int f = sv2.contentOffset.x;
    for(int i=0;i<countryCount;i++){
        if (f>=i*80 && f<(i+1)*80) {
            if(f<=i*80+40){
                [UIView animateWithDuration:0.2 animations:^{
                    sv2.contentOffset = CGPointMake(i*80, 0);
                }];
            }else{
                [UIView animateWithDuration:0.2 animations:^{
                    sv2.contentOffset = CGPointMake((i+1)*80, 0);
                }];
            }
            return;
        }
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int f = sv2.contentOffset.x;
    for(int i=0;i<countryCount;i++){
        if (f>=i*80 && f<(i+1)*80) {
            if(f<=i*80+40){
                [UIView animateWithDuration:0.2 animations:^{
                    sv2.contentOffset = CGPointMake(i*80, 0);
                }];
            }else{
                [UIView animateWithDuration:0.2 animations:^{
                    sv2.contentOffset = CGPointMake((i+1)*80, 0);
                }];
            }
            return;
        }
    }
}

#pragma mark - 各种点击事件
-(void)switchCategoryClick
{
    NSLog(@"Switch");
}

-(void)messageBtnClick
{
    NSLog(@"messageBtnClick");
    //消息
    if ([[USER objectForKey:@"isSuccess"] intValue]) {
        NoticeViewController * vc = [[NoticeViewController alloc] init];
        //整理合并数据，合并的消息按时间从旧到新进行排序
//        1413515402 = 11;
//        1413515405 = 22;
//        1413515407 = 33;
        [self combineData];
        
        vc.newDataArray = self.valueArray;
        [self.sideMenuController setContentController:vc animted:YES];
    }else{
        ShowAlertView;
//        UIView * view = [UIApplication sharedApplication].keyWindow;
//        NSLog(@"%f--%f", view.frame.size.width, view.frame.size.height);
//        AlertView * alert = [[AlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        CGRect rect1 = alert.bgImageView.frame;
//        CGRect rect2 = alert.closeBtn.frame;
//        CGRect rect3 = alert.confirmBtn.frame;
//        
//        int add = 45;
//        rect1.origin.x += add;
//        rect2.origin.x += add;
//        rect3.origin.x += add;
//        
//        alert.bgImageView.frame = rect1;
//        alert.closeBtn.frame = rect2;
//        alert.confirmBtn.frame = rect3;
//        
//        [view addSubview:alert];
//        [alert release];
    }
    
//    [vc release];
}
-(void)combineData
{
//    self.receivedNewMsgArray
    //用来存储只出现过的key值
    NSMutableArray * keyArray = [NSMutableArray arrayWithCapacity:0];
    //用来存储合并过的value，将这个数组传到下个界面
    [self.valueArray removeAllObjects];
//    NSLog(@"keyArray:%@", keyArray);
//    NSLog(@"receivedNewMsgArray:%@", self.receivedNewMsgArray);
    
    for (int i=0; i<self.receivedNewMsgArray.count; i++) {
        NSDictionary * dict1 = self.receivedNewMsgArray[i];
        NSString * key = [[dict1 allKeys] objectAtIndex:0];
        if (keyArray.count) {
            //查找
            for (int j=0; j<keyArray.count; j++) {
                if ([keyArray[j] isEqualToString:key]) {
                    //取出原数据
                    NSMutableDictionary * dict2 = [NSMutableDictionary dictionaryWithDictionary:[self.valueArray[j] objectForKey:key]];
                    NSMutableDictionary * dict2_msg = [NSMutableDictionary dictionaryWithDictionary:[dict2 objectForKey:@"msg"]];
                    
                    //取出新数据
                    NSDictionary * dict3 = [dict1 objectForKey:key];
                    NSDictionary * dict3_msg = [dict3 objectForKey:@"msg"];
                    
                    //合并消息，新消息数相加
                    [dict2_msg addEntriesFromDictionary:dict3_msg];
                    NSString * totalMsgCount = [NSString stringWithFormat:@"%d", [[dict2 objectForKey:@"new_msg"] intValue]+[[dict3 objectForKey:@"new_msg"] intValue]];
//                    [dict2 setObject:totalMsgCount forKey:@"new_msg"];
                    [dict2 setValue:totalMsgCount forKey:@"new_msg"];
                    //合并完成，删除重新加入数组
                    [self.valueArray removeObjectAtIndex:j];
                    
                    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObject:dict2 forKey:key];
                    [self.valueArray insertObject:dic atIndex:j];
                    
                    break;
                }else if(j == keyArray.count-1){
                    //没找到，直接存储
                    [self.valueArray addObject:dict1];
                    [keyArray addObject:key];
                }
            }
        }else{
            //直接存储
            [self.valueArray addObject:dict1];
            [keyArray addObject:key];
        }
        
    }
//    NSLog(@"")
}
-(void)shopBtnClick
{
    NSLog(@"shop");
}

/********************/
-(void)menuButtonClick:(UIButton *)button
{
    if (button.tag == 1000) {
        //首页
        MainViewController * vc = [ControllerManager shareMain];
        vc.menuBtn.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            vc.alphaBtn.alpha = 0;
        } completion:^(BOOL finished) {
            vc.alphaBtn.hidden = YES;
        }];
        [self.sideMenuController setContentController:vc animted:YES];
    }else if (button.tag == 1001) {
        //商城
        GiftShopViewController *vc = [[GiftShopViewController alloc] init];
        [self.sideMenuController setContentController:vc animted:YES];
//        [vc release];
    }else if (button.tag == 1002) {
        //活动
        ActivityViewController *vc = [[ActivityViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.sideMenuController setContentController:vc animted:YES];
        [vc release];
    }else if (button.tag == 1003) {
        //设置
        //        SetViewController * vc = [[SetViewController alloc] init];
        SettingViewController * vc = [[SettingViewController alloc] init];
        vc.modalTransitionStyle = 2;
        [self.sideMenuController setContentController:vc animted:YES];
        //        [vc release];
    }else{
        //穿越
        NSLog(@"回到星球选择页面");
        ChoseLoadViewController * vc = [[ChoseLoadViewController alloc] init];
        vc.isFromMenu = YES;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }
    [self performSelector:@selector(resetColor) withObject:nil afterDelay:0.3];

}
-(void)menuButtonClick2:(UIButton *)button
{
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [self resetColor];
    UIView * bgView = (UIView *)[noticeBgView viewWithTag:1000+button.tag];
    bgView.backgroundColor = [UIColor colorWithRed:134/255.0 green:76/255.0 blue:53/255.0 alpha:1];
}
-(void)menuButtonClick3
{
    [self resetColor];
}
-(void)resetColor
{
    for(int i=0;i<6;i++){
        UIView * bgView = (UIView *)[noticeBgView viewWithTag:2000+i];
        bgView.backgroundColor = [UIColor clearColor];
    }
}
#pragma mark - tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    JDSideMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[JDSideMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    SearchResultModel *model = self.searchArray[indexPath.row];
    [cell configUI:model];
    
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
//-(void)btnClick:(UIButton *)btn
//{
//    NSLog(@"点击了第%d个", btn.tag);
//    SearchResultModel *model = self.searchArray[btn.tag];
//    PetInfoViewController *petInfoVC = [[PetInfoViewController alloc] init];
//    petInfoVC.aid = model.aid;
//
//    [self presentViewController:petInfoVC animated:YES completion:^{
//        [petInfoVC release];
//    }];
//    
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%d个", indexPath.row);
    SearchResultModel *model = self.searchArray[indexPath.row];
    PetInfoViewController *petInfoVC = [[PetInfoViewController alloc] init];
    petInfoVC.aid = model.aid;
    
    [self presentViewController:petInfoVC animated:YES completion:^{
        [petInfoVC release];
    }];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

#pragma mark - textField代理
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    searchBtn.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        sv.contentOffset = CGPointMake(225, 0);
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    searchBtn.hidden = YES;
    [textField resignFirstResponder];
    if (self.tfString != nil) {
        [self loadSearchData:textField.text];
//        [self.searchArray addObject:@"11"];
//        [tv reloadData];
    }
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
//    searchBtn.hidden = YES;
    [searchBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.tfString = nil;
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //string是最新输入的文字，textField的长度及字符要落后一个操作。
    if (![string isEqualToString:@""]) {
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    }else if(textField.text.length == 1){
        [searchBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    if ([searchBtn.titleLabel.text isEqualToString:@"搜索"]) {
        if ([string isEqualToString:@""]) {
            self.tfString = [self.tfString substringToIndex:textField.text.length-1];
        }else{
            self.tfString = [NSString stringWithFormat:@"%@%@", textField.text, string];
        }
        
    }else{
        self.tfString = nil;
    }
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
