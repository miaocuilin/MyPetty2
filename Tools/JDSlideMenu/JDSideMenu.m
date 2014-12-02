//
//  JDSideMenu.m
//  StatusBarTest
//
//  Created by Markus Emrich on 11/11/13.
//  Copyright (c) 2013 Markus Emrich. All rights reserved.
//

#import "JDSideMenu.h"
#import "MyHomeViewController.h"
#import "UserPetListModel.h"
#import "MessageModel.h"
#import "SingleTalkModel.h"

// constants
const CGFloat JDSideMenuMinimumRelativePanDistanceToOpen = 0.33;
//原值260.0
const CGFloat JDSideMenuDefaultMenuWidth = 225.0;
//阻尼，衰减的衰减，原来是0.5s
const CGFloat JDSideMenuDefaultDamping = 0.5;

// animation times
const CGFloat JDSideMenuDefaultOpenAnimationTime = 1.2;
const CGFloat JDSideMenuDefaultCloseAnimationTime = 0.4;

@interface JDSideMenu ()
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@end

@implementation JDSideMenu

- (id)initWithContentController:(UIViewController*)contentController
                 menuController:(UIViewController*)menuController;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _contentController = contentController;
        _menuController = menuController;
        
        _menuWidth = JDSideMenuDefaultMenuWidth;
        _tapGestureEnabled = YES;
        _panGestureEnabled = YES;
    }
    return self;
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    // add childcontroller
    self.userPetListArray = [NSMutableArray arrayWithCapacity:0];
    self.newDataArray = [NSMutableArray arrayWithCapacity:0];
    /**********************/
    self.talkIDArray = [NSMutableArray arrayWithCapacity:0];
    self.userIDArray = [NSMutableArray arrayWithCapacity:0];
    self.userTxArray = [NSMutableArray arrayWithCapacity:0];
    self.userNameArray = [NSMutableArray arrayWithCapacity:0];
    self.newMsgNumArray = [NSMutableArray arrayWithCapacity:0];
    self.keysArray = [NSMutableArray arrayWithCapacity:0];
    self.valuesArray = [NSMutableArray arrayWithCapacity:0];
    
    self.newMsgDataArray = [NSMutableArray arrayWithCapacity:0];
//    self.totalDataDict = [NSMutableDictionary dictionaryWithCapacity:0];
    /**********************/
    
    [self addChildViewController:self.menuController];
    [self.menuController didMoveToParentViewController:self];
    [self addChildViewController:self.contentController];
    [self.contentController didMoveToParentViewController:self];
    
    // add subviews
    _containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    [self.containerView addSubview:self.contentController.view];
    self.contentController.view.frame = self.containerView.bounds;
    self.contentController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_containerView];
    
    // setup gesture recognizers
//    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
//    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
//    [self.containerView addGestureRecognizer:self.tapRecognizer];
//    [self.containerView addGestureRecognizer:self.panRecognizer];
    
}

-(id)returnContentController
{
    return self.contentController;
}

- (void)setBackgroundImage:(UIImage*)image;
{
    if (!self.backgroundView && image) {
        self.backgroundView = [[UIImageView alloc] initWithImage:image];
        self.backgroundView.frame = self.view.bounds;
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //将backgroundView添加到最底层
        [self.view insertSubview:self.backgroundView atIndex:0];
    } else if (image == nil) {
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;
    } else {
        self.backgroundView.image = image;
    }
}

#pragma mark controller replacement

- (void)setContentController:(UIViewController*)contentController
                     animted:(BOOL)animated;
{
    if (contentController == nil) return;
    
    if (self.contentController == contentController) {
        [self hideMenuAnimated:YES];
        return;
    }
    
    UIViewController *previousController = self.contentController;
    _contentController = contentController;
    
    
    // add childcontroller
    //当
//    NTSlidingViewController * vc = [ControllerManager shareSliding];
//    MyHomeViewController * home = [ControllerManager shareManagerMyHome];
//    if (self.contentController != vc && self.contentController != home) {
//        [self addChildViewController:self.contentController];
//    }
    
//    [self addChildViewController:self.contentController];
    
    // add subview
    self.contentController.view.frame = self.containerView.bounds;
    self.contentController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // animate in
    __weak typeof(self) blockSelf = self;
    
    CGFloat offset = JDSideMenuDefaultMenuWidth + (self.view.frame.size.width-JDSideMenuDefaultMenuWidth)/2.0;
    [UIView animateWithDuration:JDSideMenuDefaultCloseAnimationTime/2.0 animations:^{
        //控制点击侧栏viewController后偏移的长度，当设置成负值时偏移左右互换
        blockSelf.containerView.transform = CGAffineTransformMakeTranslation(offset, 0);
//        [blockSelf statusBarView].transform = blockSelf.containerView.transform;
    } completion:^(BOOL finished) {
        // move to container view
        [blockSelf.containerView addSubview:self.contentController.view];
        [blockSelf.contentController didMoveToParentViewController:blockSelf];
        
        // remove old controller
        [previousController willMoveToParentViewController:nil];
        [previousController removeFromParentViewController];
        [previousController.view removeFromSuperview];
        
        [blockSelf hideMenuAnimated:YES];
    }];
}

#pragma mark Animation
-(void)click
{
    if (![self isMenuVisible]) {
        [self showMenuAnimated:YES];
    } else {
        [self hideMenuAnimated:YES];
    }
}
//- (void)tapRecognized:(UITapGestureRecognizer*)recognizer
//{
//    if (!self.tapGestureEnabled) return;
//    
//    if (![self isMenuVisible]) {
//        [self showMenuAnimated:YES];
//    } else {
//        [self hideMenuAnimated:YES];
//    }
//}

- (void)panRecognized:(UIPanGestureRecognizer*)recognizer
{
    if (!self.panGestureEnabled) return;
    
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGPoint velocity = [recognizer velocityInView:recognizer.view];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self addMenuControllerView];
            [recognizer setTranslation:CGPointMake(recognizer.view.frame.origin.x, 0) inView:recognizer.view];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [recognizer.view setTransform:CGAffineTransformMakeTranslation(MAX(0,translation.x), 0)];
//            [self statusBarView].transform = recognizer.view.transform;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (velocity.x > 5.0 || (velocity.x >= -1.0 && translation.x > JDSideMenuMinimumRelativePanDistanceToOpen*self.menuWidth)) {
                CGFloat transformedVelocity = velocity.x/ABS(self.menuWidth - translation.x);
                CGFloat duration = JDSideMenuDefaultOpenAnimationTime * 0.66;
                [self showMenuAnimated:YES duration:duration initialVelocity:transformedVelocity];
            } else {
                [self hideMenuAnimated:YES];
            }
        }
        default:
            break;
    }
}

- (void)addMenuControllerView;
{
    if (self.menuController.view.superview == nil) {
        CGRect menuFrame, restFrame;
        CGRectDivide(self.view.bounds, &menuFrame, &restFrame, self.menuWidth, CGRectMinXEdge);
        self.menuController.view.frame = menuFrame;
        self.menuController.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        self.view.backgroundColor = self.menuController.view.backgroundColor;
        if (self.backgroundView) [self.view insertSubview:self.menuController.view aboveSubview:self.backgroundView];
        else [self.view insertSubview:self.menuController.view atIndex:0];
    }
}
#pragma mark -
-(void)loadCountryList
{
    NSString * code = [NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"%@", load.dataDict);
            [self.userPetListArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (NSDictionary * dict in array) {
                UserPetListModel * model = [[UserPetListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.userPetListArray addObject:model];
                [model release];
            }
            self.refreshData();
        }else{
            
        }
    }];
    [request release];
}
-(void)getMsgAndActivityNum
{
    NSString * url = [NSString stringWithFormat:@"%@%@", ACTIVITYANDNOTIFYAPI, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                self.refreshActNum([[load.dataDict objectForKey:@"data"] objectForKey:@"topic_count"]);
            }
        }else{
            
        }
    }];
    [request release];
}
-(void)refreshUData
{
    self.refreshUserData();
}
/*
 1.下载新消息数据
 2.将username=null的修复
 3.解析新消息，如果没新消息跳到7.
 4.查看是否有旧消息，有-》合并
 5.增加一个条目：未读数目=未读数目+新消息数目
 6.将总的消息存到本地
 7.遍历整个消息，将未读数目取出相加的的结果返回给侧边栏显示数目。
 */
-(void)getNewMessage
{
    LOADING;
    NSString * url = [NSString stringWithFormat:@"%@%@", GETNEWMSGAPI,[ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"/*=====================*/");
            NSLog(@"newMsg:%@", load.dataDict);
            NSLog(@"/*=====================*/");
            //【注意】这里需要将talkIDArray每次清空
            [self.talkIDArray removeAllObjects];
            [self.newDataArray removeAllObjects];
            [self.newMsgDataArray removeAllObjects];
            
            NSArray * array = [load.dataDict objectForKey:@"data"];
            if (array.count) {
                self.hasNewMsg = YES;

                for (int i=0; i<array.count; i++) {
                    NSDictionary * dict = array[i];
                    NSString * key = [[dict allKeys] objectAtIndex:0];
                    NSDictionary * dict2 = [dict objectForKey:key];
                    if ([[dict2 objectForKey:@"usr_name"] isKindOfClass:[NSNull class]]) {
                        [dict2 setValue:@"" forKey:@"usr_name"];
                    }
                    if ([[dict2 objectForKey:@"usr_tx"] isKindOfClass:[NSNull class]]) {
                        [dict2 setValue:@"" forKey:@"usr_tx"];
                    }
                }

                [self.newDataArray addObjectsFromArray:array];
            }else{
                self.hasNewMsg = NO;
            }
            //如果有除本地外的新消息，存储到本地
//            NSLog(@"%@", [USER objectForKey:@"newMsgArrayDict"]);
//            if ([[[USER objectForKey:@"newMsgArrayDict"] objectForKey:@"msgArray"] isKindOfClass:[NSArray class]] && [[[USER objectForKey:@"newMsgArrayDict"] objectForKey:@"msgArray"] count]) {
//                //
////                if (self.hasNewMsg) {
//                NSArray * userMsgArray = [[USER objectForKey:@"newMsgArrayDict"] objectForKey:@"msgArray"];
//                
//                [self.newDataArray addObjectsFromArray:userMsgArray];
//                NSLog(@"%@", self.newDataArray);
//                
//                NSDictionary * dict = [NSDictionary dictionaryWithObject:self.newDataArray forKey:@"msgArray"];
//                [USER setObject:dict forKey:@"newMsgArrayDict"];
//                [USER synchronize];
////                }
//            }else{
//                if (self.hasNewMsg) {
//                    NSDictionary * dict = [NSDictionary dictionaryWithObject:self.newDataArray forKey:@"msgArray"];
//                    NSLog(@"========%@", dict);
//                    [USER setObject:dict forKey:@"newMsgArrayDict"];
//                    [USER synchronize];
//                }
//            }
            /**********************/
            NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
            NSLog(@"%@", [[MyControl returnDictionaryWithDataPath:path] allKeys]);
            
            if (self.hasNewMsg) {
                //分解数据添加到7个数组中
                [self apartNewMsgToArray];
                //查看是否有旧消息，进行合并
                [self loadHistoryMessageAndSaveToLocal];
                
                //遍历整个本地字典，拿到消息数之和，返回给侧边栏
                self.refreshNewMsgNum([self getNewMessageNum]);
                ENDLOADING;
            }else{
                //遍历本地消息，取出未读数相加返回
                NSFileManager * fileManager = [[NSFileManager alloc] init];
                if ([fileManager fileExistsAtPath:path]) {
                    self.refreshNewMsgNum([self getNewMessageNum]);
                }else{
                    self.refreshNewMsgNum(@"0");
                }
                //返回
//            self.refreshNewMsgNum(self.newDataArray);
                ENDLOADING;
//                [MyControl loadingSuccessWithContent:@"加载完成" afterDelay:0.2f];
            }
            
//            NSLog(@"%@", self.newDataArray);
//            [self.newDataArray removeAllObjects];
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
#pragma mark - 
-(void)loadHistoryMessageAndSaveToLocal
{
    NSFileManager * manager = [[NSFileManager alloc] init];
    NSString * docDir = DOCDIR;
    NSString * path = [docDir stringByAppendingPathComponent:@"talkData.plist"];
    if ([manager fileExistsAtPath:path]) {
        //文件存在
        NSLog(@"文件存在");
        NSMutableDictionary * totalDict = [NSMutableDictionary dictionaryWithDictionary:[MyControl returnDictionaryWithDataPath:path]];
        NSArray * oldTalkIDArray = [totalDict allKeys];
        
//        NSLog(@"/*============================*/");
//        SingleTalkModel * model0 = [totalDict objectForKey:oldTalkIDArray[0]];
//        NSArray * array0 = [model0.msgDict objectForKey:@"msg"];
//        for (int i=0; i<array0.count; i++) {
//            MessageModel * mod = array0[i];
//            NSLog(@"%@", mod.msg);
//        }
//        NSLog(@"/*============================*/");
        //合并
        for (int i=0; i<self.talkIDArray.count; i++) {
            
            for (int j=0; j<oldTalkIDArray.count; j++) {
                NSString * key = self.talkIDArray[i];
                
                if ([key isEqualToString:oldTalkIDArray[j]]) {
                    //找到相同对话，合并
                    SingleTalkModel * model = [totalDict objectForKey:key];
                    NSMutableArray * oldMsgArray = [NSMutableArray arrayWithArray:[model.msgDict objectForKey:@"msg"]];
                    //
                    SingleTalkModel * newModel = self.newMsgDataArray[i];
                    NSArray * newArray = [newModel.msgDict objectForKey:@"msg"];
                    
                    //1.合并消息
//                    NSLog(@"==========oldMsgArray============");
//                    for (int k = 0; k<oldMsgArray.count; k++) {
//                        MessageModel * m1 = oldMsgArray[k];
//                        NSLog(@"%@", m1.msg);
//                    }
//                    NSLog(@"==========newArray============");
//                    for (int k = 0; k<newArray.count; k++) {
//                        MessageModel * m1 = newArray[k];
//                        NSLog(@"%@", m1.msg);
//                    }
//                    NSLog(@"%d--%d", oldMsgArray.count, newArray.count);
//                    NSLog(@"%@--%@", model.unReadMsgNum, newModel.unReadMsgNum);
                    [oldMsgArray addObjectsFromArray:newArray];
                    model.msgDict = [NSDictionary dictionaryWithObject:oldMsgArray forKey:@"msg"];
                    //2.合并未读消息数
                    model.unReadMsgNum = [NSString stringWithFormat:@"%d", [model.unReadMsgNum intValue] + [newModel.unReadMsgNum intValue]];
                    //3.更新usr_tx
                    model.usr_tx = newModel.usr_tx;
                    //4.更新usr_name
                    model.usr_name = newModel.usr_name;
                    
                    //合并完毕
                    break;
                }else if(j == oldTalkIDArray.count-1){
                    //将新的添加
                    [totalDict setObject:self.newMsgDataArray[i] forKey:key];
                }
            }
        }
        //新旧消息全部合并完毕，重新存储到本地
        NSData * data = [MyControl returnDataWithDictionary:totalDict];
        BOOL a = [data writeToFile:path atomically:YES];
        NSLog(@"---存储合并后数据结果:%d", a);
    }else{
        //本地没有文件
        //存到本地
        NSMutableDictionary * newDataDict = [NSMutableDictionary dictionaryWithCapacity:0];
        for (int i=0; i<self.talkIDArray.count; i++) {
            [newDataDict setObject:self.newMsgDataArray[i] forKey:self.talkIDArray[i]];
        }
        NSString * docDir = DOCDIR;
        NSString * path = [docDir stringByAppendingPathComponent:@"talkData.plist"];
        //dict-->NSData
        NSData * data = [MyControl returnDataWithDictionary:newDataDict];
        BOOL a = [data writeToFile:path atomically:YES];
        NSLog(@"---存储新数据结果:%d", a);
    }
}

#pragma mark - getNewMessageNum
-(NSString *)getNewMessageNum
{
    NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
    NSDictionary * dict = [MyControl returnDictionaryWithDataPath:path];
    int num = 0;
    NSArray * array = [dict allKeys];
    for (int i=0; i<array.count; i++) {
        SingleTalkModel * model = [dict objectForKey:array[i]];
        num += [model.unReadMsgNum intValue];
    }
    return [NSString stringWithFormat:@"%d", num];
}
#pragma mark -
-(void)apartNewMsgToArray
{
    for (int i=0; i<self.newDataArray.count; i++) {
        //创建对象
        SingleTalkModel * talkModel = [[SingleTalkModel alloc] init];
        
        
        //分析数据
        //1.获得talk_id,添加到数组
        NSString * talkID = [[self.newDataArray[i] allKeys] objectAtIndex:0];
        [self.talkIDArray addObject:talkID];

        
        NSDictionary * dict = [self.newDataArray[i] objectForKey:talkID];
        //2.usr_id添加到userIDArray
        talkModel.usr_id = [dict objectForKey:@"usr_id"];
//        [self.userIDArray addObject:[dict objectForKey:@"usr_id"]];
        
        
        //3.头像，添加到数组
        if ([[dict objectForKey:@"usr_tx"] isKindOfClass:[NSNull class]]) {
            talkModel.usr_tx = @"";
//            [self.userTxArray addObject:@""];
        }else{
            talkModel.usr_tx = [dict objectForKey:@"usr_tx"];
//            [self.userTxArray addObject:[dict objectForKey:@"usr_tx"]];
        }
        
        //4.姓名，添加到数组
        if ([[dict objectForKey:@"usr_name"] isKindOfClass:[NSNull class]] || [[dict objectForKey:@"usr_name"] length] == 0) {
            if ([[dict objectForKey:@"usr_id"] intValue] == 1) {
                talkModel.usr_name = @"事务官"; //狗
                talkModel.usr_tx = @"1";
//                [self.userNameArray addObject:@"汪汪"];
            }else if([[dict objectForKey:@"usr_id"] intValue] == 2){
                talkModel.usr_name = @"联络官"; //猫
                talkModel.usr_tx = @"2";
//                [self.userNameArray addObject:@"喵喵"];
            }else if([[dict objectForKey:@"usr_id"] intValue] == 3){
                talkModel.usr_name = @"顺风小鸽";
                talkModel.usr_tx = @"3";
//                [self.userNameArray addObject:@"顺风小鸽"];
            }
        }else{
            talkModel.usr_name = [dict objectForKey:@"usr_name"];
//            [self.userNameArray addObject:[dict objectForKey:@"usr_name"]];
        }
        
        //5.新消息数
        NSNumber * number = [dict objectForKey:@"new_msg"];
        talkModel.unReadMsgNum = [NSString stringWithFormat:@"%@", number];
//        [self.newMsgNumArray addObject:[NSString stringWithFormat:@"%@", number]];
        //6.新消息的时间self.keysArray
        //7.新消息的内容self.valuesArray
        [self analysisData:[dict objectForKey:@"msg"] usrId:[dict objectForKey:@"usr_id"] talkModel:talkModel];
        //
        [self.newMsgDataArray addObject:talkModel];
//        [self.lastTalkTimeArray addObject:self.keysArray[self.keysArray.count-1]];
//        [self.lastTalkContentArray addObject:self.valuesArray[self.valuesArray.count-1]];
        //存储newMsgArray
//        NSMutableDictionary * dict1 = [NSMutableDictionary dictionaryWithCapacity:0];
//        
//        [dict1 setObject:[NSArray arrayWithArray:self.keysArray] forKey:@"key"];
//        [dict1 setObject:[NSArray arrayWithArray:self.valuesArray] forKey:@"value"];
//        [self.newMsgArray addObject:dict1];
    }
}
-(void)analysisData:(NSDictionary *)dict usrId:(NSString *)usrID talkModel:(SingleTalkModel *)model
{
    
    NSMutableArray * tempNewMsgArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.keysArray removeAllObjects];
    [self.valuesArray removeAllObjects];
    //keysArray赋值
    for (NSString * key in [dict allKeys]) {
        [self.keysArray addObject:key];
    }
    
    //key值数组冒泡排序
    for (int i=0; i<self.keysArray.count; i++) {
        for (int j=0; j<self.keysArray.count-i-1; j++) {
            if ([self.keysArray[j] intValue] > [self.keysArray[j+1] intValue]) {
                NSString * str = [NSString stringWithFormat:@"%@", self.keysArray[j]];
                NSString * str1 = [NSString stringWithFormat:@"%@", self.keysArray[j+1]];
                self.keysArray[j] = str1;
                self.keysArray[j+1] = str;
            }
        }
    }
    //    NSLog(@"%@", self.keysArray);
    for (int i=0;i<self.keysArray.count;i++) {
        //        NSLog(@"key:%@--value:%@", self.keysArray[i], [dict objectForKey:self.keysArray[i]]);
        MessageModel * msgModel = [[MessageModel alloc] init];
        msgModel.time = self.keysArray[i];
        msgModel.usr_id = usrID;
        
        NSString * msg = [dict objectForKey:self.keysArray[i]];
        NSLog(@"%@", msg);
        if ([msg rangeOfString:@"["].location != NSNotFound && [msg rangeOfString:@"]"].location != NSNotFound) {
            int x = [msg rangeOfString:@"]"].location;

            msgModel.msg = [msg substringFromIndex:x+1];
            msgModel.img_id = [msg substringWithRange:NSMakeRange(1, x)];
        }else{
            msgModel.msg = msg;
            msgModel.img_id = @"0";
        }
        [tempNewMsgArray addObject:msgModel];
        [msgModel release];
//        [self.valuesArray addObject:msg];
    }
    //
    model.msgDict = [NSDictionary dictionaryWithObject:tempNewMsgArray forKey:@"msg"];
}
#pragma mark -
-(void)loadUserData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERINFOAPI, [USER objectForKey:@"usr_id"], sig,[ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"state"] intValue] == 2) {
                //SID过期,需要重新登录获取SID
                [self login];
                //                [self getUserData];
                return;
            }else{
                //SID未过期，直接获取用户数据
                NSLog(@"用户数据：%@", load.dataDict);
                NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                
                [USER setObject:[dict objectForKey:@"a_name"] forKey:@"a_name"];
                if (![[dict objectForKey:@"a_tx"] isKindOfClass:[NSNull class]]) {
                    [USER setObject:[dict objectForKey:@"a_tx"] forKey:@"a_tx"];
                }
                [USER setObject:[dict objectForKey:@"inviter"] forKey:@"inviter"];
                [USER setObject:[dict objectForKey:@"age"] forKey:@"age"];
                [USER setObject:[dict objectForKey:@"gender"] forKey:@"gender"];
                [USER setObject:[dict objectForKey:@"name"] forKey:@"name"];
                [USER setObject:[dict objectForKey:@"city"] forKey:@"city"];
                [USER setObject:[dict objectForKey:@"exp"] forKey:@"oldexp"];
                [USER setObject:[dict objectForKey:@"exp"] forKey:@"exp"];
                [USER setObject:[dict objectForKey:@"lv"] forKey:@"lv"];
                
                [USER setObject:[USER objectForKey:@"gold"] forKey:@"oldgold"];
                [USER setObject:[dict objectForKey:@"gold"] forKey:@"gold"];
                [USER setObject:[dict objectForKey:@"usr_id"] forKey:@"usr_id"];
                [USER setObject:[dict objectForKey:@"aid"] forKey:@"aid"];
                [USER setObject:[dict objectForKey:@"con_login"] forKey:@"con_login"];
                [USER setObject:[dict objectForKey:@"next_gold"] forKey:@"next_gold"];
                if (!([[dict objectForKey:@"rank"] isKindOfClass:[NSNull class]] || ![[dict objectForKey:@"rank"] length])) {
                    [USER setObject:[dict objectForKey:@"rank"] forKey:@"rank"];
                }else{
                    [USER setObject:@"1" forKey:@"rank"];
                }
                
                
                if (![[dict objectForKey:@"tx"] isKindOfClass:[NSNull class]]) {
                    [USER setObject:[dict objectForKey:@"tx"] forKey:@"tx"];
                }
                self.refreshUserData();
                
            }
        }
    }];
    [request release];
}

#pragma mark -
/*==============================================================*/
-(void)refreshJDMenu
{
    if ([[USER objectForKey:@"isSuccess"] intValue]) {
        //请求国家列表API
        [self loadCountryList];
        //请求活动数API
        //        [self getMsgAndActivityNum];
        //刷新个人数据
        if ([[USER objectForKey:@"isSuccess"] intValue]) {
            [self loadUserData];
        }
        
        
//        [self performSelector:@selector(refreshUData) withObject:nil afterDelay:0.1];
        //请求新消息API
        [self getNewMessage];
    }
}
- (void)showMenuAnimated:(BOOL)animated;
{
    
    [self showMenuAnimated:animated duration:JDSideMenuDefaultOpenAnimationTime
           initialVelocity:1.0];
}

- (void)showMenuAnimated:(BOOL)animated duration:(CGFloat)duration
         initialVelocity:(CGFloat)velocity;
{
    // add menu view
    [self addMenuControllerView];
    
    // animate
    __weak typeof(self) blockSelf = self;
    if([MyControl isIOS7]){
        [UIView animateWithDuration:animated ? duration : 0.0 delay:0
             usingSpringWithDamping:JDSideMenuDefaultDamping initialSpringVelocity:velocity options:UIViewAnimationOptionAllowUserInteraction animations:^{
                 //这里-self.menuWidth设置当前层向左偏移
                 blockSelf.containerView.transform = CGAffineTransformMakeTranslation(self.menuWidth, 0);
                 //             [self statusBarView].transform = blockSelf.containerView.transform;
             } completion:nil];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            //这里-self.menuWidth设置当前层向左偏移
            blockSelf.containerView.transform = CGAffineTransformMakeTranslation(self.menuWidth, 0);
            //             [self statusBarView].transform = blockSelf.containerView.transform;
        }];
    }
    
}

- (void)hideMenuAnimated:(BOOL)animated;
{
    __weak typeof(self) blockSelf = self;
    [UIView animateWithDuration:JDSideMenuDefaultCloseAnimationTime animations:^{
        blockSelf.containerView.transform = CGAffineTransformIdentity;
//        [self statusBarView].transform = blockSelf.containerView.transform;
    } completion:^(BOOL finished) {
        [blockSelf.menuController.view removeFromSuperview];
    }];
}

#pragma mark State

- (BOOL)isMenuVisible;
{
    return !CGAffineTransformEqualToTransform(self.containerView.transform,
                                              CGAffineTransformIdentity);
}

#pragma mark Statusbar
//管理状态栏的移动
- (UIView*)statusBarView;
{
    UIView *statusBar = nil;
    NSData *data = [NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9];
    NSString *key = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    id object = [UIApplication sharedApplication];
    if ([object respondsToSelector:NSSelectorFromString(key)]) statusBar = [object valueForKey:key];
    return statusBar;
}

@end
