//
//  CenterViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "CenterViewController.h"
#import "SettingViewController.h"
#import "GiftShopViewController.h"
#import "UserBagViewController.h"
#import "SingleTalkModel.h"
#import "ExchangeViewController.h"
#import "AccountViewController.h"
#import "ChargeViewController.h"
#import "WalkAndTeaseViewController.h"
#import "LoginViewController.h"
#import "MsgViewController.h"
#import "ModifyPetOrUserInfoViewController.h"

@interface CenterViewController ()

@end

@implementation CenterViewController

-(void)createGuide
{
    guide = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"guide_center.png"];
    float a = [UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height;
    float b = 320/480.0;
    if(a == b){
        guide.frame = CGRectMake(0, 0, self.view.frame.size.width, 568);
    }
    UITapGestureRecognizer * guideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideTap:)];
    [guide addGestureRecognizer:guideTap];
    
    //    FirstTabBarViewController * tabBar = [ControllerManager shareTabBar];
    [[UIApplication sharedApplication].keyWindow addSubview:guide];
    [guideTap release];
}
-(void)guideTap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.2 animations:^{
        guide.alpha = 0;
    }completion:^(BOOL finished) {
        guide.hidden = YES;
        [guide removeFromSuperview];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isLoaded) {
        if (![[USER objectForKey:@"guide_center"] intValue]) {
            [USER setObject:@"1" forKey:@"guide_center"];
            [self createGuide];
        }
        
    }
    
    //刷新私信数
    if ([[USER objectForKey:@"isSuccess"] intValue]) {
//        [self getNewMessage];
        int a = [MyControl returnUnreadMessageCount];
        if (a) {
            msgNum.text = [NSString stringWithFormat:@"%d", a];
            msgNumBg.hidden = NO;
            
            self.tabBar.msgNum.text = [NSString stringWithFormat:@"%d", a];
            self.tabBar.msgNumBg.hidden = NO;
        }else{
            msgNum.text = @"0";
            msgNumBg.hidden = YES;
            self.tabBar.msgNum.text = @"0";
            self.tabBar.msgNumBg.hidden = YES;
        }
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (isLoaded) {
        [self modifyUI];
    }
    isLoaded = YES;
    //
    
    
}
- (void)refresh
{
//    [self getNewMessage];
    [self modifyUI];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.talkIDArray = [NSMutableArray arrayWithCapacity:0];
    self.nwDataArray = [NSMutableArray arrayWithCapacity:0];
    self.nwMsgDataArray = [NSMutableArray arrayWithCapacity:0];
    self.keysArray = [NSMutableArray arrayWithCapacity:0];
    self.valuesArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createBg];
    [self createUI];
    [self createFakeNavigation];
}
-(void)createBg
{
    UIImageView * blueBg = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:blueBg];
}
-(void)createUI
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-50)];
    [self.view addSubview:sv];
    
    UIImageView * headBg2 = [MyControl createImageViewWithFrame:CGRectMake(10+130, 9+50, self.view.frame.size.width-20-130, 124/2) ImageName:@""];
    headBg2.image = [[UIImage imageNamed:@"center_head2.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    [sv addSubview:headBg2];
    
    UIButton * modifyBtn = [MyControl createButtonWithFrame:CGRectMake(headBg2.frame.origin.x+headBg2.frame.size.width-35, headBg2.frame.origin.y+10, 30, 30) ImageName:@"center_modify_info.png" Target:self Action:@selector(modifyClick) Title:nil];
    modifyBtn.showsTouchWhenHighlighted = YES;
    [sv addSubview:modifyBtn];
    
    UIImageView * headBg = [MyControl createImageViewWithFrame:CGRectMake(10, 10, 130, 222/2) ImageName:@"center_head.png"];
//    headBg.image = [[UIImage imageNamed:@"center_head.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(60, 110, 1, 2) resizingMode:UIImageResizingModeStretch];
    [sv addSubview:headBg];
    
    
    
    float spe = (184/2-70)/2.0;
    headBtn = [MyControl createButtonWithFrame:CGRectMake(spe, spe, 70, 70) ImageName:@"defaultUserHead.png" Target:self Action:@selector(headBtnClick) Title:nil];
    headBtn.layer.cornerRadius = 35;
    headBtn.layer.masksToBounds = YES;
    [headBg addSubview:headBtn];
    
 
    name = [MyControl createLabelWithFrame:CGRectMake(95, 50+10, 200, 20) Font:17 Text:@"游荡的两脚兽"];
    name.font = [UIFont boldSystemFontOfSize:17];
    [headBg addSubview:name];
    
    slogan = [MyControl createLabelWithFrame:CGRectMake(name.frame.origin.x, 50+36, 200, 20) Font:13 Text:@"宠物星球—我是大萌星"];
    [headBg addSubview:slogan];
    
    sex = [MyControl createImageViewWithFrame:CGRectMake(name.frame.origin.x+5, 50+14, 15, 15) ImageName:@"woman.png"];
    sex.hidden = YES;
    [headBg addSubview:sex];

    
    location = [MyControl createLabelWithFrame:CGRectMake(name.frame.origin.x, 50+36, 200, 20) Font:14 Text:nil];
    [headBg addSubview:location];
    
    
    /**********************************************/
    
    UIImageView * centerBg = [MyControl createImageViewWithFrame:CGRectMake(10, headBg.frame.origin.y+headBg.frame.size.height+2, self.view.frame.size.width-20, 180) ImageName:@"center_centerBg.png"];
    [sv addSubview:centerBg];
    
    UIView * lineW = [MyControl createViewWithFrame:CGRectMake(0, 90, centerBg.frame.size.width, 1)];
    lineW.backgroundColor = [ControllerManager colorWithHexString:@"b28f8f"];
    [centerBg addSubview:lineW];
    
    for (int i=0; i<2; i++) {
        UIView * lineH = [MyControl createViewWithFrame:CGRectMake((i+1)*centerBg.frame.size.width/3.0, 0, 1, centerBg.frame.size.height)];
        lineH.backgroundColor = [ControllerManager colorWithHexString:@"b28f8f"];
        [centerBg addSubview:lineH];
    }
    
    NSArray * imageArray = @[@"center_msg.png", @"center_mall.png", @"center_exchange.png", @"center_play.png", @"center_gift.png", @"center_account.png"];
    NSArray * nameArray = @[@"消息", @"商城", @"兑换", @"玩耍", @"礼物", @"账号"];
    float spe2 = (centerBg.frame.size.width/3.0-99/2.0)/2.0;
    for (int i=0; i<6; i++) {
        UIImageView * imageView = [MyControl createImageViewWithFrame:CGRectMake(i%3*(centerBg.frame.size.width/3.0)+spe2, 8+i/3*90, 99/2.0, 103/2.0) ImageName:imageArray[i]];
        [centerBg addSubview:imageView];
        
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(i%3*(centerBg.frame.size.width/3.0), 61+i/3*90, centerBg.frame.size.width/3.0, 20) Font:14 Text:nameArray[i]];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [centerBg addSubview:label];
        //
        if (i == 0) {
            msgNumBg = [MyControl createImageViewWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width-15, imageView.frame.origin.y, 22, 22) ImageName:@"center_msgBg.png"];
            msgNumBg.hidden = YES;
            [centerBg addSubview:msgNumBg];
            
            msgNum = [MyControl createLabelWithFrame:CGRectMake(-10, 0, 42, 22) Font:12 Text:@"50"];
            msgNum.textAlignment = NSTextAlignmentCenter;
            [msgNumBg addSubview:msgNum];
        }
        
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(i%3*centerBg.frame.size.width/3.0, i/3*90, centerBg.frame.size.width/3.0, 90) ImageName:@"" Target:self Action:@selector(btnClick:) Title:nil];
        [centerBg addSubview:button];
        button.tag = 100+i;
    }
    /**********************************************/
    
    UIImageView * bottomBg = [MyControl createImageViewWithFrame:CGRectMake(centerBg.frame.origin.x, centerBg.frame.origin.y+centerBg.frame.size.height+2, centerBg.frame.size.width, 72) ImageName:@""];
    bottomBg.image = [UIImage imageNamed:@"center_bottom.png"];
    [sv addSubview:bottomBg];
    
    gold = [MyControl createImageViewWithFrame:CGRectMake(25, (72-30)/2.0, 30, 30) ImageName:@"gold.png"];
    gold.hidden = YES;
    [bottomBg addSubview:gold];
    
    goldNum = [MyControl createLabelWithFrame:CGRectMake(gold.frame.origin.x+gold.frame.size.width+5, gold.frame.origin.y, 100, gold.frame.size.height) Font:20 Text:@"0"];
    goldNum.hidden = YES;
    goldNum.font = [UIFont boldSystemFontOfSize:20];
    [bottomBg addSubview:goldNum];
    
    
    charge = [MyControl createButtonWithFrame:CGRectMake(337/2.0, (bottomBg.frame.size.height-40)/2.0, 100, 40) ImageName:@"center_chargeBg.png" Target:self Action:@selector(chargeClick) Title:@"充值"];
    charge.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    charge.showsTouchWhenHighlighted = YES;
    charge.hidden = YES;
    [bottomBg addSubview:charge];
    
    //534 110
    float w = bottomBg.frame.size.width-40;
    regOrLoginBtn = [MyControl createButtonWithFrame:CGRectMake(20, charge.frame.origin.y-10, w, w*110/534) ImageName:@"public_longBtnBg.png" Target:self Action:@selector(loginBtnClick) Title:@"注册或登录"];
    [bottomBg addSubview:regOrLoginBtn];
    
    [self modifyUI];
}
#pragma mark -
-(void)shake
{
    [MyControl animateIncorrectPassword:regOrLoginBtn];
}
#pragma mark - 点击登录
-(void)loginBtnClick
{
    VariousAlertViewController * vc = [[VariousAlertViewController alloc] init];
    vc.regClick = ^(){
        ChooseInViewController * choose = [[ChooseInViewController alloc] init];
        [self presentViewController:choose  animated:YES completion:nil];
        [choose release];
//        NSLog(@"%d", [vc retainCount]);
        [vc.view removeFromSuperview];
//        NSLog(@"%d", [vc retainCount]);
//        [vc release];
//        NSLog(@"%d", [vc retainCount]);
    };
    vc.fastClick = ^(){
        LoginViewController * login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
        [login release];
        [vc.view removeFromSuperview];
    };
    
    vc.isFromCenter = YES;
    vc.modifyCenter = ^(){
        [self modifyUI];
    };
    [self.view addSubview:vc.view];
//    NSLog(@"%d", [vc retainCount]);
    [vc release];
    
}
#pragma mark -
-(void)modifyClick
{
    NSLog(@"modify");
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        [self shake];
        return;
    }
    ModifyPetOrUserInfoViewController * vc = [[ModifyPetOrUserInfoViewController alloc] init];
    vc.isModifyUser = YES;
    vc.refreshUserInfo = ^(NSString * Name, int gender, int city, UIImage * image){
        [USER setObject:Name forKey:@"name"];
        [USER setObject:[NSString stringWithFormat:@"%d", gender] forKey:@"gender"];
        [USER setObject:[NSString stringWithFormat:@"%d", city] forKey:@"city"];
        //头像tx已经在上传照片后修改了
        [self modifyUI];
    };
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}

-(void)modifyUI
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        return;
    }
    regOrLoginBtn.hidden = YES;
    gold.hidden = NO;
    goldNum.hidden = NO;
//    charge.hidden = NO;
    slogan.hidden = YES;
    
    [headBtn setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL, [USER objectForKey:@"tx"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultUserHead.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            [headBtn setBackgroundImage:[MyControl returnSquareImageWithImage:image] forState:UIControlStateNormal];
        }
    }];
    
    name.text = [USER objectForKey:@"name"];
    
    CGSize size = [name.text sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:1];
    CGRect rect = name.frame;
    rect.size.width = size.width;
    name.frame = rect;
    
    sex.hidden = NO;
    sex.frame = CGRectMake(name.frame.origin.x+size.width+5, 50+14, 15, 15);
    if ([[USER objectForKey:@"gender"] intValue] == 1) {
        sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    
    location.text = [ControllerManager returnProvinceAndCityWithCityNum:[USER objectForKey:@"city"]];
    
    goldNum.text = [USER objectForKey:@"gold"];
}
-(void)btnClick:(UIButton *)btn
{
    NSLog(@"%d", btn.tag-100);
    int a = btn.tag-100;
    if (a != 1 && ![[USER objectForKey:@"isSuccess"] intValue]) {
//        ShowAlertView;
        [self shake];
        return;
    }
    
    if (a == 0) {
        //私信
        MsgViewController * vc = [[MsgViewController alloc] init];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
        [vc release];
        [nc release];
    }else if (a == 1) {
        //商城
        GiftShopViewController * vc = [[GiftShopViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }else if (a == 2) {
        //兑换
        ExchangeViewController * vc = [[ExchangeViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }else if (a == 3) {
        //充值
        if (![[USER objectForKey:@"isSuccess"] intValue]) {
            ShowAlertView;
            return;
        }
        WalkAndTeaseViewController *vc = [[WalkAndTeaseViewController alloc] init];
        vc.aid = [USER objectForKey:@"aid"];
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
        
        
    }else if (a == 4) {
        //礼物
        UserBagViewController * vc = [[UserBagViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }else if (a == 5) {
        //账号
        AccountViewController * vc = [[AccountViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }
}
-(void)chargeClick
{
    NSLog(@"charge");
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        return;
    }
    ChargeViewController * vc = [[ChargeViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
//    WalkAndTeaseViewController *vc = [[WalkAndTeaseViewController alloc] init];
//    vc.aid = [USER objectForKey:@"aid"];
//    [self presentViewController:vc animated:YES completion:nil];
//    [vc release];
}
-(void)headBtnClick
{
    NSLog(@"head");
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
//        ShowAlertView;
        [self shake];
        return;
    }

    UserCardViewController * vc = [[UserCardViewController alloc] init];
    vc.usr_id = [USER objectForKey:@"usr_id"];
    [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
    vc.close = ^(){
        [vc.view removeFromSuperview];
    };
    [vc release];
//    UserInfoViewController * vc = [[UserInfoViewController alloc] init];
//    vc.usr_id = [USER objectForKey:@"usr_id"];
//    [self presentViewController:vc animated:YES completion:nil];
//    [vc release];
}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake((self.view.frame.size.width-100)/2.0, 32, 100, 20) Font:17 Text:@"个人中心"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIButton * set = [MyControl createButtonWithFrame:CGRectMake(320-25-15, 64-27-7, 25, 25) ImageName:@"center_set.png" Target:self Action:@selector(setClick) Title:nil];
    set.showsTouchWhenHighlighted = YES;
    [navView addSubview:set];
}
-(void)setClick
{
    SettingViewController * vc = [[SettingViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
#pragma mark -
//-(void)getNewMessage
//{
////    LOADING;
//    NSString * url = [NSString stringWithFormat:@"%@%@", GETNEWMSGAPI,[ControllerManager getSID]];
//    NSLog(@"%@", url);
//    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            NSLog(@"/*=====================*/");
//            NSLog(@"newMsg:%@", load.dataDict);
//            NSLog(@"/*=====================*/");
//            //【注意】这里需要将talkIDArray每次清空
//            [self.talkIDArray removeAllObjects];
//            [self.nwDataArray removeAllObjects];
//            [self.nwMsgDataArray removeAllObjects];
//            
//            NSArray * array = [load.dataDict objectForKey:@"data"];
//            if (array.count) {
//                self.hasNewMsg = YES;
//                
//                for (int i=0; i<array.count; i++) {
//                    NSDictionary * dict = array[i];
//                    NSString * key = [[dict allKeys] objectAtIndex:0];
//                    NSDictionary * dict2 = [dict objectForKey:key];
//                    if ([[dict2 objectForKey:@"usr_name"] isKindOfClass:[NSNull class]]) {
//                        [dict2 setValue:@"" forKey:@"usr_name"];
//                    }
//                    if ([[dict2 objectForKey:@"usr_tx"] isKindOfClass:[NSNull class]]) {
//                        [dict2 setValue:@"" forKey:@"usr_tx"];
//                    }
//                }
////                NSLog(@"%@--%@", array, self.nwDataArray);
//                [self.nwDataArray addObjectsFromArray:array];
////                NSLog(@"%@--%@", array, self.nwDataArray);
//            }else{
//                self.hasNewMsg = NO;
//            }
//            //如果有除本地外的新消息，存储到本地
//            
//            /**********************/
//            NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
//            NSLog(@"%@", [[MyControl returnDictionaryWithDataPath:path] allKeys]);
//            
//            if (self.hasNewMsg) {
//                //分解数据添加到7个数组中
//                [self apartNewMsgToArray];
//                //查看是否有旧消息，进行合并
//                [self loadHistoryMessageAndSaveToLocal];
//                
//                //遍历整个本地字典，拿到消息数之和，返回给侧边栏
//                
//                NSString * num = [self getNewMessageNum];
//                if ([num intValue]) {
//                    msgNum.text = num;
//                    msgNumBg.hidden = NO;
//                    
//                    self.tabBar.msgNum.text = num;
//                    self.tabBar.msgNumBg.hidden = NO;
//                }else{
//                    msgNumBg.hidden = YES;
//                    self.tabBar.msgNumBg.hidden = YES;
//                }
////                ENDLOADING;
//            }else{
//                //遍历本地消息，取出未读数相加返回
//                NSFileManager * fileManager = [[NSFileManager alloc] init];
//                if ([fileManager fileExistsAtPath:path]) {
//                    NSString * num = [self getNewMessageNum];
//                    if ([num intValue]) {
//                        msgNum.text = num;
//                        msgNumBg.hidden = NO;
//                        
//                        self.tabBar.msgNum.text = num;
//                        self.tabBar.msgNumBg.hidden = NO;
//                    }else{
//                        msgNumBg.hidden = YES;
//                        
//                        self.tabBar.msgNumBg.hidden = YES;
//                    }
//                    
//                   
//                }else{
//                    msgNum.text = @"0";
//                    msgNumBg.hidden = YES;
//                    
//                    self.tabBar.msgNum.text = @"0";
//                    self.tabBar.msgNumBg.hidden = YES;
//                }
//                //返回
//
////                ENDLOADING;
//
//            }
//            
//
//        }else{
////            LOADFAILED;
//        }
//    }];
//    [request release];
//}
//#pragma mark -
//-(void)loadHistoryMessageAndSaveToLocal
//{
//    NSFileManager * manager = [[NSFileManager alloc] init];
//    NSString * docDir = DOCDIR;
//    NSString * path = [docDir stringByAppendingPathComponent:@"talkData.plist"];
//    if ([manager fileExistsAtPath:path]) {
//        //文件存在
//        NSLog(@"文件存在");
//
//        NSMutableDictionary * totalDict = [NSMutableDictionary dictionaryWithDictionary:[MyControl returnDictionaryWithDataPath:path]];
//
//        NSArray * oldTalkIDArray = [totalDict allKeys];
//        
//
//        //合并
//        for (int i=0; i<self.talkIDArray.count; i++) {
//            NSString * key = self.talkIDArray[i];
//            
//            if (oldTalkIDArray.count) {
//                for (int j=0; j<oldTalkIDArray.count; j++) {
//                    
//                    
//                    if ([key isEqualToString:oldTalkIDArray[j]]) {
//                        //找到相同对话，合并
//                        SingleTalkModel * model = [totalDict objectForKey:key];
//                        NSMutableArray * oldMsgArray = [NSMutableArray arrayWithArray:[model.msgDict objectForKey:@"msg"]];
//                        //
//                        SingleTalkModel * newModel = self.nwMsgDataArray[i];
//                        NSArray * newArray = [newModel.msgDict objectForKey:@"msg"];
//                        
//                        //1.合并消息
//                        
//                        [oldMsgArray addObjectsFromArray:newArray];
//                        model.msgDict = [NSDictionary dictionaryWithObject:oldMsgArray forKey:@"msg"];
//                        //2.合并未读消息数
//                        model.unReadMsgNum = [NSString stringWithFormat:@"%d", [model.unReadMsgNum intValue] + [newModel.unReadMsgNum intValue]];
//                        //3.更新usr_tx
//                        model.usr_tx = newModel.usr_tx;
//                        //4.更新usr_name
//                        model.usr_name = newModel.usr_name;
//                        
//                        //合并完毕
//                        break;
//                    }else if(j == oldTalkIDArray.count-1){
//                        //将新的添加
//                        [totalDict setObject:self.nwMsgDataArray[i] forKey:key];
//                    }
//                }
//            }else{
//                [totalDict setObject:self.nwMsgDataArray[i] forKey:key];
//            }
//            
//        }
//        //新旧消息全部合并完毕，重新存储到本地
////        NSLog(@"%@", totalDict);
//        NSData * data = [MyControl returnDataWithDictionary:totalDict];
//        BOOL a = [data writeToFile:path atomically:YES];
//        NSLog(@"---存储合并后数据结果:%d", a);
//    }else{
//        //本地没有文件
//        //存到本地
//        NSMutableDictionary * newDataDict = [NSMutableDictionary dictionaryWithCapacity:0];
//        for (int i=0; i<self.talkIDArray.count; i++) {
//            [newDataDict setObject:self.nwMsgDataArray[i] forKey:self.talkIDArray[i]];
//        }
//        NSString * docDir = DOCDIR;
//        NSString * path = [docDir stringByAppendingPathComponent:@"talkData.plist"];
//        
////        NSLog(@"%@", newDataDict);
//        //dict-->NSData
//        NSData * data = [MyControl returnDataWithDictionary:newDataDict];
//        BOOL a = [data writeToFile:path atomically:YES];
//        NSLog(@"---存储新数据结果:%d", a);
//    }
//}
//
//#pragma mark - getNewMessageNum
//-(NSString *)getNewMessageNum
//{
//    NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
//    NSDictionary * dict = [MyControl returnDictionaryWithDataPath:path];
////    NSLog(@"%@", dict);
//    int num = 0;
//    NSArray * array = [dict allKeys];
//    for (int i=0; i<array.count; i++) {
//        SingleTalkModel * model = [dict objectForKey:array[i]];
//        num += [model.unReadMsgNum intValue];
//    }
//    return [NSString stringWithFormat:@"%d", num];
//}
//#pragma mark -
//-(void)apartNewMsgToArray
//{
//    for (int i=0; i<self.nwDataArray.count; i++) {
//        //创建对象
//        SingleTalkModel * talkModel = [[SingleTalkModel alloc] init];
//        
//        
//        //分析数据
//        //1.获得talk_id,添加到数组
//        NSString * talkID = [[self.nwDataArray[i] allKeys] objectAtIndex:0];
//        [self.talkIDArray addObject:talkID];
//        
//        
//        NSDictionary * dict = [self.nwDataArray[i] objectForKey:talkID];
//        //2.usr_id添加到userIDArray
//        talkModel.usr_id = [dict objectForKey:@"usr_id"];
//
//        
//        
//        //3.头像，添加到数组
//        if ([[dict objectForKey:@"usr_tx"] isKindOfClass:[NSNull class]]) {
//            talkModel.usr_tx = @"";
//
//        }else{
//            talkModel.usr_tx = [dict objectForKey:@"usr_tx"];
//
//        }
//        
//        //4.姓名，添加到数组
//        if ([[dict objectForKey:@"usr_name"] isKindOfClass:[NSNull class]] || [[dict objectForKey:@"usr_name"] length] == 0) {
//            if ([[dict objectForKey:@"usr_id"] intValue] == 1) {
//                talkModel.usr_name = @"事务官"; //狗
//                talkModel.usr_tx = @"1";
//
//            }else if([[dict objectForKey:@"usr_id"] intValue] == 2){
//                talkModel.usr_name = @"联络官"; //猫
//                talkModel.usr_tx = @"2";
//
//            }else if([[dict objectForKey:@"usr_id"] intValue] == 3){
//                talkModel.usr_name = @"顺风小鸽";
//                talkModel.usr_tx = @"3";
//
//            }
//        }else{
//            talkModel.usr_name = [dict objectForKey:@"usr_name"];
//
//        }
//        
//        //5.新消息数
//        NSNumber * number = [dict objectForKey:@"new_msg"];
//        talkModel.unReadMsgNum = [NSString stringWithFormat:@"%@", number];
//
//        //6.新消息的时间self.keysArray
//        //7.新消息的内容self.valuesArray
//        [self analysisData:[dict objectForKey:@"msg"] usrId:[dict objectForKey:@"usr_id"] talkModel:talkModel];
//        //
//        [self.nwMsgDataArray addObject:talkModel];
//
//    }
//}
//-(void)analysisData:(NSDictionary *)dict usrId:(NSString *)usrID talkModel:(SingleTalkModel *)model
//{
//    
//    NSMutableArray * tempNewMsgArray = [NSMutableArray arrayWithCapacity:0];
//    
//    [self.keysArray removeAllObjects];
//    [self.valuesArray removeAllObjects];
//    //keysArray赋值
//    for (NSString * key in [dict allKeys]) {
//        [self.keysArray addObject:key];
//    }
//    
//    //key值数组冒泡排序
//    for (int i=0; i<self.keysArray.count; i++) {
//        for (int j=0; j<self.keysArray.count-i-1; j++) {
//            if ([self.keysArray[j] intValue] > [self.keysArray[j+1] intValue]) {
//                NSString * str = [NSString stringWithFormat:@"%@", self.keysArray[j]];
//                NSString * str1 = [NSString stringWithFormat:@"%@", self.keysArray[j+1]];
//                self.keysArray[j] = str1;
//                self.keysArray[j+1] = str;
//            }
//        }
//    }
//    //    NSLog(@"%@", self.keysArray);
//    for (int i=0;i<self.keysArray.count;i++) {
//        //        NSLog(@"key:%@--value:%@", self.keysArray[i], [dict objectForKey:self.keysArray[i]]);
//        MessageModel2 * msgModel = [[MessageModel2 alloc] init];
//        msgModel.time = self.keysArray[i];
//        msgModel.usr_id = usrID;
//        
//        NSString * msg = [dict objectForKey:self.keysArray[i]];
//        NSLog(@"%@", msg);
//        if ([msg rangeOfString:@"[address]"].location == NSNotFound && [msg rangeOfString:@"["].location != NSNotFound && [msg rangeOfString:@"]"].location != NSNotFound) {
//            int x = [msg rangeOfString:@"]"].location;
//            
//            msgModel.msg = [msg substringFromIndex:x+1];
//            msgModel.img_id = [msg substringWithRange:NSMakeRange(1, x)];
//        }else{
//            msgModel.msg = msg;
//            msgModel.img_id = @"0";
//        }
//        [tempNewMsgArray addObject:msgModel];
//        [msgModel release];
//        //        [self.valuesArray addObject:msg];
//    }
//    //
//    model.msgDict = [NSDictionary dictionaryWithObject:tempNewMsgArray forKey:@"msg"];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
