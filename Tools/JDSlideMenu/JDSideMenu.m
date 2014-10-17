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
    StartLoading;
    NSString * url = [NSString stringWithFormat:@"%@%@", GETNEWMSGAPI,[ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"newMsg:%@", load.dataDict);

            [self.newDataArray removeAllObjects];
            
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
            if (self.hasNewMsg) {
                //分解数据添加到7个数组中
                [self apartNewMsgToArray];
                //查看是否有旧消息，进行合并
                
            }else{
                LoadingSuccess;
                //遍历本地消息，取出未读数相加返回
                
                //返回
//            self.refreshNewMsgNum(self.newDataArray);
            }
            
//            NSLog(@"%@", self.newDataArray);
//            [self.newDataArray removeAllObjects];
        }else{
            LoadingFailed;
        }
    }];
    [request release];
}
#pragma mark -
-(void)apartNewMsgToArray
{
    for (int i=0; i<self.newDataArray.count; i++) {
        //分析数据
        //1.获得talk_id,添加到数组
        NSString * talkID = [[self.newDataArray[i] allKeys] objectAtIndex:0];
        [self.talkIDArray addObject:talkID];
        
        NSDictionary * dict = [self.newDataArray[i] objectForKey:talkID];
        //2.usr_id添加到userIDArray
        [self.userIDArray addObject:[dict objectForKey:@"usr_id"]];
        //3.头像，添加到数组
        if ([[dict objectForKey:@"usr_tx"] isKindOfClass:[NSNull class]]) {
            [self.userTxArray addObject:@""];
        }else{
            [self.userTxArray addObject:[dict objectForKey:@"usr_tx"]];
        }
        
        //4.姓名，添加到数组
        if ([[dict objectForKey:@"usr_name"] isKindOfClass:[NSNull class]] || [[dict objectForKey:@"usr_name"] length] == 0) {
            if ([[dict objectForKey:@"usr_id"] intValue] == 1) {
                [self.userNameArray addObject:@"汪汪"];
            }else if([[dict objectForKey:@"usr_id"] intValue] == 2){
                [self.userNameArray addObject:@"喵喵"];
            }else if([[dict objectForKey:@"usr_id"] intValue] == 3){
                [self.userNameArray addObject:@"顺风小鸽"];
            }
        }else{
            [self.userNameArray addObject:[dict objectForKey:@"usr_name"]];
        }
        
        //5.新消息数
        NSNumber * number = [dict objectForKey:@"new_msg"];
        [self.newMsgNumArray addObject:[NSString stringWithFormat:@"%@", number]];
        //6.新消息的时间self.keysArray
        //7.新消息的内容self.valuesArray
        [self analysisData:[dict objectForKey:@"msg"]];

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
-(void)analysisData:(NSDictionary *)dict
{
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
        NSString * msg = [dict objectForKey:self.keysArray[i]];
        if ([msg rangeOfString:@"["].location != NSNotFound && [msg rangeOfString:@"]"].location != NSNotFound) {
            int x = [msg rangeOfString:@"]"].location;
            msg = [msg substringFromIndex:x+1];
        }
        [self.valuesArray addObject:msg];
    }
}
#pragma mark -
/*==============================================================*/
- (void)showMenuAnimated:(BOOL)animated;
{
    if ([[USER objectForKey:@"isSuccess"] intValue]) {
        //请求国家列表API
        [self loadCountryList];
        //请求活动数API
        [self getMsgAndActivityNum];
        //刷新个人数据
        [self performSelector:@selector(refreshUData) withObject:nil afterDelay:0.1];
        //请求新消息API
        [self getNewMessage];
    }
    
    
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
    [UIView animateWithDuration:animated ? duration : 0.0 delay:0
         usingSpringWithDamping:JDSideMenuDefaultDamping initialSpringVelocity:velocity options:UIViewAnimationOptionAllowUserInteraction animations:^{
             //这里-self.menuWidth设置当前层向左偏移
             blockSelf.containerView.transform = CGAffineTransformMakeTranslation(self.menuWidth, 0);
//             [self statusBarView].transform = blockSelf.containerView.transform;
         } completion:nil];
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
