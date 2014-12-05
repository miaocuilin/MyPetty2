//
//  NoticeViewController.m
//  MyPetty
//
//  Created by Aidi on 14-7-3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeCell.h"
#import "SystemMessageListModel.h"
#import "TalkViewController.h"
#import "NoticeModel.h"
#import "SingleTalkModel.h"
#import "MessageModel.h"

#define SelectedColor [UIColor colorWithRed:248/255.0 green:177/255.0 blue:160/255.0 alpha:1]

@interface NoticeViewController ()
{
    UIButton * messageButton;
    UIButton * systemButton;
    UITableView *messageTableView;
    UITableView *systemTableView;
}
@end

@implementation NoticeViewController

-(void)viewWillAppear:(BOOL)animated
{
    if (isLoaded) {
        [self loadLocalData];
        [messageTableView reloadData];
    }
//    if ([[USER objectForKey:@"isBackToTalk"] intValue]) {
//        [USER setObject:@"0" forKey:@"isBackToTalk"];
//        if (self.lastMessage.length) {
//            self.lastTalkContentArray[rowOfTalk] = self.lastMessage;
//            [messageTableView reloadData];
//        }
//    }
}
-(void)viewDidAppear:(BOOL)animated
{
    isLoaded = YES;
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
//    NSData * data = [MyControl returnDataWithDictionary:self.totalDataDict];
//    BOOL save = [data writeToFile:path atomically:YES];
//    NSLog(@"save:%d", save);
//}
//-(void)viewDidAppear:(BOOL)animated
//{
//    //加载完后清除本地新消息记录
//    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [USER setObject:dict forKey:@"newMsgArrayDict"];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.totalDataDict = [NSMutableDictionary dictionaryWithCapacity:0];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    //7个数组
//    self.talkIDArray = [NSMutableArray arrayWithCapacity:0];
//    self.lastTalkTimeArray = [NSMutableArray arrayWithCapacity:0];
//    self.lastTalkContentArray = [NSMutableArray arrayWithCapacity:0];
//    self.userIDArray = [NSMutableArray arrayWithCapacity:0];
//    self.userTxArray = [NSMutableArray arrayWithCapacity:0];
//    self.userNameArray = [NSMutableArray arrayWithCapacity:0];
//    self.newMsgNumArray = [NSMutableArray arrayWithCapacity:0];;
    //
//    self.keysArray = [NSMutableArray arrayWithCapacity:0];
//    self.valuesArray = [NSMutableArray arrayWithCapacity:0];
    //
//    self.newDataArray = [NSMutableArray arrayWithCapacity:0];
    //
//    self.newMsgArray = [NSMutableArray arrayWithCapacity:0];
    //
//    self.systemDataArray = [NSMutableArray arrayWithCapacity:0];
//    self.messageDataArray = [NSMutableArray arrayWithCapacity:0];
//    for (int i =0; i < 30; i++) {
//        NSNumber *num = [NSNumber numberWithInt:i];
//        [self.systemDataArray addObject:num];
//        [self.messageDataArray addObject:num];
//    }
    [self createBg];
    
    [self loadLocalData];
    
    [self createTableView];
    [self createNavgation];
//    [self createDivision];
    
//    [self loadData];
//    [self loadMessageData];
//    [self loadSystemData];
    [self createAlphaBtn];
}
/****************************/
#pragma mark -
-(void)loadLocalData
{
    [self.dataArray removeAllObjects];
    
    NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
    NSFileManager * manager = [[NSFileManager alloc] init];
    if (![manager fileExistsAtPath:path]) {
        return;
    }
    self.totalDataDict = [NSMutableDictionary dictionaryWithDictionary:[MyControl returnDictionaryWithDataPath:path]];
    NSArray * array = [self.totalDataDict allKeys];
    for (int i=0; i<array.count; i++) {
        NSString * key = array[i];
        SingleTalkModel * talkModel = [self.totalDataDict objectForKey:key];
        NoticeModel * model = [[NoticeModel alloc] init];
//        usr_name;
//        usr_tx;
//        time;
//        lastMsg;
//        unReadNum
//        img_id;
        model.talk_id = key;
        
        model.usr_name = talkModel.usr_name;
        model.usr_tx = talkModel.usr_tx;
        model.unReadNum = talkModel.unReadMsgNum;
        
        NSArray * msgArray = [talkModel.msgDict objectForKey:@"msg"];
        NSLog(@"%@--%@--%@", talkModel.usr_name, talkModel.msgDict, msgArray);
        MessageModel * msgModel = msgArray[msgArray.count-1];
        model.time = msgModel.time;
        model.lastMsg = msgModel.msg;
        model.img_id = msgModel.img_id;
        model.usr_id = msgModel.usr_id;
        
        [self.dataArray addObject:model];
        
        [model release];
    }
    //先按时间排序
    for (int i=0; i<self.dataArray.count; i++) {
        for (int j=0; j<self.dataArray.count-i-1; j++) {
            if ([[self.dataArray[j] time] intValue] < [[self.dataArray[j+1] time] intValue]) {
                NoticeModel * model3 = [self.dataArray[j] retain];
                
                self.dataArray[j] = self.dataArray[j+1];
                self.dataArray[j+1] = model3;
                [model3 release];
            }
        }
    }
    
    //按消息数进行排序 未读的在前，读了在后
    for (int i=0; i<self.dataArray.count; i++) {
        for (int j=0; j<self.dataArray.count-i-1; j++) {
            int a = [[self.dataArray[j] unReadNum] intValue];
            int b = [[self.dataArray[j+1] unReadNum] intValue];
            
            if (a<b && !(a!=0&&b!=0)) {
                NoticeModel * model3 = [self.dataArray[j] retain];

                self.dataArray[j] = self.dataArray[j+1];
                self.dataArray[j+1] = model3;
                [model3 release];
            }
        }
    }
    //
    for (int i=0; i<self.dataArray.count; i++) {
        NSLog(@"%@", [self.dataArray[i] unReadNum]);
    }
    
}

#pragma mark -
-(void)createAlphaBtn
{
    alphaBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(hideSideMenu) Title:nil];
    alphaBtn.backgroundColor = [UIColor blackColor];
    alphaBtn.alpha = 0;
    alphaBtn.hidden = YES;
    [self.view addSubview:alphaBtn];
}
-(void)hideSideMenu
{
    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
    [menu hideMenuAnimated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        alphaBtn.alpha = 0;
    } completion:^(BOOL finished) {
        alphaBtn.hidden = YES;
        backBtn.selected = NO;
    }];
}

//加载新消息
/******************************************/
//-(void)loadNewMessageData
//{
    //请求一个API，传usr_id，获取talk_id，根据talk_id去获取本地历史记录以及新的消息存到本地。
    //聊天里10秒刷一次，侧边栏在侧边栏弹出的时候刷新。
//    NSString * url = [NSString stringWithFormat:@"%@%@", GETNEWMSGAPI,[ControllerManager getSID]];
//    NSLog(@"%@", url);
//    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            NSLog(@"newMsg:%@", load.dataDict);
//            if ([load.dataDict objectForKey:@"data"] && [[load.dataDict objectForKey:@"data"] count]) {
//                self.newDataArray = [load.dataDict objectForKey:@"data"];
//                for (int i=0; i<self.newDataArray.count; i++) {
//                    NSLog(@"%@", [self.newDataArray[i] objectForKey:<#(id)#>])
//                }
//            if (self.newDataArray.count) {
//                //有新消息
//                hasNewMsg = YES;
//            }else{
//                LoadingSuccess;
//                [self loadHistoryTalk];
//                return;
//            }
//            //分解数据添加到7个数组
//            for (int i=0; i<self.newDataArray.count; i++) {
//                //分析数据
//                //1.获得talk_id,添加到数组
//                NSString * talkID = [[self.newDataArray[i] allKeys] objectAtIndex:0];
//                [self.talkIDArray addObject:talkID];
//                
//                NSDictionary * dict = [self.newDataArray[i] objectForKey:talkID];
//                //7.usr_id添加到userIDArray
//                [self.userIDArray addObject:[dict objectForKey:@"usr_id"]];
//                //2.头像，添加到数组
//                if ([[dict objectForKey:@"usr_tx"] isKindOfClass:[NSNull class]]) {
//                    [self.userTxArray addObject:@""];
//                }else{
//                    [self.userTxArray addObject:[dict objectForKey:@"usr_tx"]];
//                }
//                
//                //3.姓名，添加到数组
//                if ([[dict objectForKey:@"usr_name"] isKindOfClass:[NSNull class]] || [[dict objectForKey:@"usr_name"] length] == 0) {
//                    if ([[dict objectForKey:@"usr_id"] intValue] == 1) {
//                        [self.userNameArray addObject:@"汪汪"];
//                    }else if([[dict objectForKey:@"usr_id"] intValue] == 2){
//                        [self.userNameArray addObject:@"喵喵"];
//                    }else if([[dict objectForKey:@"usr_id"] intValue] == 3){
//                        [self.userNameArray addObject:@"顺风小鸽"];
//                    }
//                }else{
//                    [self.userNameArray addObject:[dict objectForKey:@"usr_name"]];
//                }
//                
//                //4.新消息数
//                NSNumber * number = [dict objectForKey:@"new_msg"];
//                [self.newMsgNumArray addObject:[NSString stringWithFormat:@"%@", number]];
//                //5.新消息的时间
//                //6.新消息的内容
//                [self analysisData:[dict objectForKey:@"msg"]];
//                //self.keysArray里是新消息的时间
//                //self.valuesArray里是新消息的内容
//                [self.lastTalkTimeArray addObject:self.keysArray[self.keysArray.count-1]];
//                [self.lastTalkContentArray addObject:self.valuesArray[self.valuesArray.count-1]];
//                //存储newMsgArray
//                NSMutableDictionary * dict1 = [NSMutableDictionary dictionaryWithCapacity:0];
//
//                [dict1 setObject:[NSArray arrayWithArray:self.keysArray] forKey:@"key"];
//                [dict1 setObject:[NSArray arrayWithArray:self.valuesArray] forKey:@"value"];
//                [self.newMsgArray addObject:dict1];
//            }
//            if ([load.dataDict objectForKey:@"data"] && [[load.dataDict objectForKey:@"data"] count] && [[[load.dataDict objectForKey:@"data"] objectAtIndex:0] objectForKey:self.talk_id]) {
//                NSLog(@"有新消息");
//                //分析数据
//                NSDictionary * dict = [[[load.dataDict objectForKey:@"data"] objectAtIndex:0] objectForKey:self.talk_id];
//                [self analysisData:[dict objectForKey:@"msg"]];
//                //self.keysArray里是新消息的时间
//                //self.valuesArray里是新消息的内容
//                
//                //存储
//                for (int i=0; i<self.keysArray.count; i++) {
//                    NSLog(@"%@--%@", self.keysArray[i], self.valuesArray[i]);
//                    [self saveTalkDataWithUserID:self.usr_id time:self.keysArray[i] msg:self.valuesArray[i]];
//                }
//            }else{
//                NSLog(@"没有新消息");
//            }
//            LoadingSuccess;
//            [self loadHistoryTalk];
//        }else{
//            LoadingFailed;
//            NSLog(@"fail");
//        }
//    }];
//    [request release];
//}

//-(void)analysisData:(NSDictionary *)dict
//{
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
////    NSLog(@"%@", self.keysArray);
//    for (int i=0;i<self.keysArray.count;i++) {
////        NSLog(@"key:%@--value:%@", self.keysArray[i], [dict objectForKey:self.keysArray[i]]);
//        NSString * msg = [dict objectForKey:self.keysArray[i]];
//        if ([msg rangeOfString:@"["].location != NSNotFound && [msg rangeOfString:@"]"].location != NSNotFound) {
//            int x = [msg rangeOfString:@"]"].location;
//            msg = [msg substringFromIndex:x+1];
//        }
//        [self.valuesArray addObject:msg];
//    }
//}
#pragma mark - 加载历史消息
//-(void)loadHistoryTalk
//{
//    NSFileManager * manager = [[NSFileManager alloc] init];
//    NSString * docDir = DOCDIR;
//    NSString * path = [docDir stringByAppendingPathComponent:@"talkData.plist"];
//    if ([manager fileExistsAtPath:path]) {
//        //文件存在
//        NSLog(@"文件存在");
//        //取出本地文件，解析出来添加到7个数组中
//        self.totalDataDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//        NSMutableArray * historyTalkIDArray = [NSMutableArray arrayWithCapacity:0];
//        for (NSString * key in [self.totalDataDict allKeys]) {
//            [historyTalkIDArray addObject:key];
//        }
//        for (int i=0; i<historyTalkIDArray.count; i++) {
//            if (!hasNewMsg) {
//                //解析并添加到5个数组中
//                //时间，内容，头像，姓名，新消息数
//                NSDictionary * dict1 = [self.totalDataDict objectForKey:historyTalkIDArray[i]];
//                [self.userTxArray addObject:[dict1 objectForKey:@"usr_tx"]];
//                [self.userNameArray addObject:[dict1 objectForKey:@"usr_name"]];
//                [self.newMsgNumArray addObject:@"0"];
//                NSArray * array1 = [dict1 objectForKey:@"data"];
//                [self.lastTalkTimeArray addObject:[array1[array1.count-1] objectForKey:@"time"]];
//                [self.lastTalkContentArray addObject:[array1[array1.count-1] objectForKey:@"msg"]];
//                //添加另外两个数组，talk_id和usr_id
//                [self.userIDArray addObject:[dict1 objectForKey:@"usr_id"]];
//                [self.talkIDArray addObject:historyTalkIDArray[i]];
//                NSLog(@"%@--%@", self.talkIDArray, self.userIDArray);
//            }else{
//                for (int j=0; j<self.talkIDArray.count; j++) {
//                    //当historyTalkIDArray[i]不等于所有talkIDArray中的值即符合条件
//                    if ([self.talkIDArray[j] isEqualToString:historyTalkIDArray[i]]) {
//                        break;
//                    }else if(j == self.talkIDArray.count-1){
//                        //符合情况，解析并添加到5个数组中
//                        //时间，内容，头像，姓名，新消息数
//                        NSDictionary * dict1 = [self.totalDataDict objectForKey:historyTalkIDArray[i]];
//                        [self.userTxArray addObject:[dict1 objectForKey:@"usr_tx"]];
//                        [self.userNameArray addObject:[dict1 objectForKey:@"usr_name"]];
//                        [self.newMsgNumArray addObject:@"0"];
//                        NSArray * array1 = [dict1 objectForKey:@"data"];
//                        [self.lastTalkTimeArray addObject:[array1[array1.count-1] objectForKey:@"time"]];
//                        [self.lastTalkContentArray addObject:[array1[array1.count-1] objectForKey:@"msg"]];
//                        //添加另外两个数组，talk_id和usr_id
//                        [self.userIDArray addObject:[dict1 objectForKey:@"usr_id"]];
//                        [self.talkIDArray addObject:historyTalkIDArray[i]];
//                    }
//                }
//            }
//        }
//        NSLog(@"---talkIDArray:%@", self.talkIDArray);
//        //刷新展示新老对话界面，此页面即显示完毕
//        [messageTableView reloadData];
//        //如果没有新消息直接返回
//        if (!hasNewMsg) {
//            return;
//        }
//        /******************新旧对话比对融合，本地保存*********************/
//        [self.totalDataDict removeAllObjects];
//        //先加载本地的数据
//        self.totalDataDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//        //talkID总数组
//        NSArray * array1 = [self.totalDataDict allKeys];
//        /*******************************/
//        for(int i=0;i<self.newMsgArray.count;i++){
//            for (int j=0; j<array1.count; j++) {
//                if ([self.talkIDArray[i] isEqualToString:array1[j]]) {
//                    //以前对话过，将新消息加到旧的后边
//                    NSMutableArray * tempArray = [[self.totalDataDict objectForKey:self.talkIDArray[i]] objectForKey:@"data"];
//                    for (int k=0; k<[[self.newMsgArray[i] objectForKey:@"key"] count]; k++) {
//                        NSMutableDictionary * messageDict = [NSMutableDictionary dictionaryWithCapacity:0];
//                        NSArray * arr1 = [self.newMsgArray[i] objectForKey:@"key"];
//                        NSArray * arr2 = [self.newMsgArray[i] objectForKey:@"value"];
//                        [messageDict setObject:arr1[k] forKey:@"time"];
//                        [messageDict setObject:arr2[k] forKey:@"msg"];
//                        [messageDict setObject:self.userIDArray[i] forKey:@"usr_id"];
//                        [tempArray addObject:messageDict];
//                    }
//                    break;
//                }else if(j == array1.count-1){
//                    //以前没有对话过，新建一组数据
//                    NSMutableDictionary * talkDataDict = [NSMutableDictionary dictionaryWithCapacity:0];
//                    NSMutableArray * talkDataArray = [NSMutableArray arrayWithCapacity:0];
//                    
//                    //NSLog(@"%@", self.newMsgArray);
//                    NSDictionary * dict1 = self.newMsgArray[i];
//                    NSArray * keyArray = [dict1 objectForKey:@"key"];
//                    NSArray * valueArray = [dict1 objectForKey:@"value"];
//                    for (int k=0; k<keyArray.count; k++) {
//                        NSMutableDictionary * messageDict = [NSMutableDictionary dictionaryWithCapacity:0];
//                        [messageDict setObject:keyArray[k] forKey:@"time"];
//                        [messageDict setObject:valueArray[k] forKey:@"msg"];
//                        [messageDict setObject:self.userIDArray[k] forKey:@"usr_id"];
//                        [talkDataArray addObject:messageDict];
//                    }
//                    
//                    [talkDataDict setObject:talkDataArray forKey:@"data"];
//                    [talkDataDict setObject:self.userIDArray[i] forKey:@"usr_id"];
//                    [talkDataDict setObject:self.userNameArray[i] forKey:@"usr_name"];
//                    [talkDataDict setObject:self.userTxArray[i] forKey:@"usr_tx"];
//                    
//                    [self.totalDataDict setObject:talkDataDict forKey:self.talkIDArray[i]];
//                }
//            }
//            
//        }
//        [self.totalDataDict writeToFile:path atomically:YES];
//        
//        
////        for (int i=0; i<self.talkIDArray.count; i++) {
////            NSDictionary * dict = [self.totalDataDict objectForKey:self.talkIDArray[i]];
////            //            [self.lastTalkArray addObject:dict];
////        }
//        //        if ([self.totalDataDict objectForKey:self.talk_id]) {
//        //
//        //            self.talkDataDict = [self.totalDataDict objectForKey:self.talk_id];
//        //            self.talkDataArray = [NSMutableArray arrayWithArray:[self.talkDataDict objectForKey:@"data"]];
//        //            //取出每条信息添加到数组中
//        //            for (int i=0; i<self.talkDataArray.count; i++) {
//        //                NSDictionary * dict = self.talkDataArray[i];
//        //                if ([[dict objectForKey:@"usr_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
//        //                    [self presentNewMessageWithSend:YES time:[dict objectForKey:@"time"] msg:[dict objectForKey:@"msg"]];
//        //                }else{
//        //                    [self presentNewMessageWithSend:NO time:[dict objectForKey:@"time"] msg:[dict objectForKey:@"msg"]];
//        //                }
//        //                
//        //            }
//        //            
//        //        }
//    }else if(hasNewMsg){
//        [messageTableView reloadData];
//        //新建plist文件，将数据存储到其中
//        //每一次循环是存储一个talk_id的对话
//        for (int i=0; i<self.talkIDArray.count; i++) {
//            NSMutableDictionary * talkDataDict = [NSMutableDictionary dictionaryWithCapacity:0];
//            NSMutableArray * talkDataArray = [NSMutableArray arrayWithCapacity:0];
//            
////            NSLog(@"%@", self.newMsgArray);
//            NSDictionary * dict1 = self.newMsgArray[i];
//            NSArray * keyArray = [dict1 objectForKey:@"key"];
//            NSArray * valueArray = [dict1 objectForKey:@"value"];
//            for (int j=0; j<keyArray.count; j++) {
//                NSMutableDictionary * messageDict = [NSMutableDictionary dictionaryWithCapacity:0];
//                [messageDict setObject:keyArray[j] forKey:@"time"];
//                [messageDict setObject:valueArray[j] forKey:@"msg"];
//                [messageDict setObject:self.userIDArray[i] forKey:@"usr_id"];
//                [talkDataArray addObject:messageDict];
//            }
//            
//            [talkDataDict setObject:talkDataArray forKey:@"data"];
//            [talkDataDict setObject:self.userIDArray[i] forKey:@"usr_id"];
//            [talkDataDict setObject:self.userNameArray[i] forKey:@"usr_name"];
//            [talkDataDict setObject:self.userTxArray[i] forKey:@"usr_tx"];
//            
//            [self.totalDataDict setObject:talkDataDict forKey:self.talkIDArray[i]];
//        }
//        [self.totalDataDict writeToFile:path atomically:YES];
//    }else{
//        //本地没有历史文件，也没有收到新消息，页面为空。
//    }
//    
//}
//#pragma mark - 将消息存储到本地plist文件
//-(void)saveTalkDataWithUserID:(NSString *)usrID  time:(NSString *)timeStamp msg:(NSString *)msg Tx:(NSString *)tx Name:(NSString *)name
//{
//    NSFileManager * manager = [[NSFileManager alloc] init];
//    NSString * docDir = DOCDIR;
//    NSString * path = [docDir stringByAppendingPathComponent:@"talkData.plist"];
//    if ([manager fileExistsAtPath:path]) {
//        //文件存在
//        NSLog(@"文件存在");
////        if (isNewCreated) {
////            //新创建不读取本地数据
////            //直接存储数据
////            [self saveWithUserID:usrID time:timeStamp msg:msg];
////        }else{
////            //非新创建，读取本地数据
////            if (isRead) {
////                //已经读取本地文件
////            }else{
////                //未读取本地文件
////                isRead = YES;
////                self.totalDataDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
////                if ([self.totalDataDict objectForKey:self.talk_id]) {
////                    self.talkDataDict = [self.totalDataDict objectForKey:self.talk_id];
////                    self.talkDataArray = [NSMutableArray arrayWithArray:[self.talkDataDict objectForKey:@"data"]];
////                }
////                //                NSLog(@"%@--%@", self.totalDataDict, self.talkDataDict);
////            }
////            [self saveWithUserID:usrID time:timeStamp msg:msg];
////        }
//    }else{
//        //文件不存在
//        NSLog(@"文件不存在");
////        isNewCreated = YES;
//        
//        NSMutableDictionary * messageDict = [NSMutableDictionary dictionaryWithCapacity:0];
//        [messageDict setObject:timeStamp forKey:@"time"];
//        [messageDict setObject:msg forKey:@"msg"];
//        [messageDict setObject:usrID forKey:@"usr_id"];
////        [self.talkDataArray addObject:messageDict];
////        
////        
////        [self.talkDataDict setObject:self.talkDataArray forKey:@"data"];
////        [self.talkDataDict setObject:self.usr_id forKey:@"usr_id"];
////        
////        [self.totalDataDict setObject:self.talkDataDict forKey:self.talk_id];
////        [self.totalDataDict writeToFile:path atomically:YES];
//        
//        //        [messageDict release];
//    }
//}
//-(void)saveWithUserID:(NSString *)usrID time:(NSString *)timeStamp msg:(NSString *)msg Tx:(NSString *)tx Name:(NSString *)name
//{
//    NSString * docDir = DOCDIR;
//    NSString * path = [docDir stringByAppendingPathComponent:@"talkData.plist"];
//    
//    NSMutableDictionary * messageDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [messageDict setObject:timeStamp forKey:@"time"];
//    [messageDict setObject:msg forKey:@"msg"];
//    [messageDict setObject:usrID forKey:@"usr_id"];
//    [self.talkDataArray addObject:messageDict];
//    
//    [self.talkDataDict setObject:self.talkDataArray forKey:@"data"];
//    [self.talkDataDict setObject:usrID forKey:@"usr_id"];
//    [self.totalDataDict setObject:self.talkDataDict forKey:self.talk_id];
//    [self.totalDataDict writeToFile:path atomically:YES];

    //    [messageDict release];
//}
/******************************************/
//-(void)loadMessageData
//{
//    NSString * code = [NSString stringWithFormat:@"is_system=%ddog&cat", 0];
//    NSString * sig = [MyMD5 md5:code];
//    NSString * url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", NOTIFYAPI, 0, sig, [ControllerManager getSID]];
//    NSLog(@"messageAPI:%@", url);
//    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            [self.messageDataArray removeAllObjects];
//            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
//            for (NSDictionary * dict in array) {
//                SystemMessageListModel * model = [[SystemMessageListModel alloc] init];
//                [model setValuesForKeysWithDictionary:dict];
//                [self.messageDataArray addObject:model];
//                [model release];
//            }
//            [messageTableView headerEndRefreshing];
//            [messageTableView reloadData];
//        }else{
//            NSLog(@"非系统数据读取失败");
//            [messageTableView headerEndRefreshing];
//        }
//    }];
//}
//-(void)loadSystemData
//{
//    NSString * code = [NSString stringWithFormat:@"is_system=%ddog&cat", 1];
//    NSString * sig = [MyMD5 md5:code];
//    NSString * url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", NOTIFYAPI, 1, sig, [ControllerManager getSID]];
//    NSLog(@"systemAPI:%@", url);
//    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            NSLog(@"systemData:%@", load.dataDict);
//            [self.systemDataArray removeAllObjects];
//            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
//            for (NSDictionary * dict in array) {
//                SystemMessageListModel * model = [[SystemMessageListModel alloc] init];
//                [model setValuesForKeysWithDictionary:dict];
//                [self.systemDataArray addObject:model];
//                [model release];
//            }
//            [systemTableView headerEndRefreshing];
//            [systemTableView reloadData];
//        }else{
//            NSLog(@"系统数据读取失败");
//            [systemTableView headerEndRefreshing];
//        }
//    }];
//}
//-(void)loadMoreMessageData
//{
//    if (self.messageDataArray.count == 0) {
//        [messageTableView footerEndRefreshing];
//        return;
//    }
//    NSString * code = [NSString stringWithFormat:@"is_system=%d&mail_id=%@dog&cat", 0, [self.messageDataArray[self.messageDataArray.count-1] mail_id]];
//    NSString * sig = [MyMD5 md5:code];
//    NSString * url = [NSString stringWithFormat:@"%@%d&mail_id=%@&sig=%@&SID=%@", NOTIFYAPI, 0, [self.messageDataArray[self.messageDataArray.count-1] mail_id], sig, [ControllerManager getSID]];
//    NSLog(@"messageMoreAPI:%@", url);
//    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
//            for (NSDictionary * dict in array) {
//                SystemMessageListModel * model = [[SystemMessageListModel alloc] init];
//                [model setValuesForKeysWithDictionary:dict];
//                [self.messageDataArray addObject:model];
//                [model release];
//            }
//            [messageTableView footerEndRefreshing];
//            [messageTableView reloadData];
//        }else{
//            NSLog(@"非系统数据读取失败");
//        }
//    }];
//}
//-(void)loadMoreSystemData
//{
//    if (self.systemDataArray.count == 0) {
//        [systemTableView footerEndRefreshing];
//        return;
//    }
//    NSString * code = [NSString stringWithFormat:@"is_system=%d&mail_id=%@dog&cat", 1, [self.systemDataArray[self.systemDataArray.count-1] mail_id]];
//    NSString * sig = [MyMD5 md5:code];
//    NSString * url = [NSString stringWithFormat:@"%@%d&mail_id=%@&sig=%@&SID=%@", NOTIFYAPI, 1, [self.systemDataArray[self.systemDataArray.count-1] mail_id], sig, [ControllerManager getSID]];
//    NSLog(@"systemMoreAPI:%@", url);
//    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
//            for (NSDictionary * dict in array) {
//                SystemMessageListModel * model = [[SystemMessageListModel alloc] init];
//                [model setValuesForKeysWithDictionary:dict];
//                [self.systemDataArray addObject:model];
//                [model release];
//            }
//            [systemTableView footerEndRefreshing];
//            [systemTableView reloadData];
//        }else{
//            NSLog(@"系统数据读取失败");
//        }
//    }];
//}

- (void)createNavgation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick:) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"消息"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
//    UIImageView * searchImageView = [MyControl createImageViewWithFrame:CGRectMake(320-31, 33, 18, 16) ImageName:@"5-5.png"];
//    [navView addSubview:searchImageView];
//    
//    UIButton * searchBtn = [MyControl createButtonWithFrame:CGRectMake(320-41-5, 25, 35, 30) ImageName:@"" Target:self Action:@selector(searchBtnClick) Title:nil];
//    //    searchBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//    searchBtn.showsTouchWhenHighlighted = YES;
//    [navView addSubview:searchBtn];
    
    UIView * line0 = [MyControl createViewWithFrame:CGRectMake(0, 63, 320, 1)];
    line0.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.1];
    [navView addSubview:line0];
}
- (void)backBtnClick:(UIButton *)button
{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
//    button.selected = !button.selected;
//    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
//    if (button.selected) {
//        [menu showMenuAnimated:YES];
//        alphaBtn.hidden = NO;
//        [UIView animateWithDuration:0.25 animations:^{
//            alphaBtn.alpha = 0.5;
//        }];
//    }else{
//        [menu hideMenuAnimated:YES];
//        [UIView animateWithDuration:0.25 animations:^{
//            alphaBtn.alpha = 0;
//        } completion:^(BOOL finished) {
//            alphaBtn.hidden = YES;
//        }];
//    }
}
//- (void)searchBtnClick
//{
//    NSLog(@"搜索");
//}

//- (void)createDivision
//{
//    UIView *ViewButton = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 35)];
//    [self.view addSubview:ViewButton];
//    
//    UIView * alphaView = [MyControl createViewWithFrame:ViewButton.bounds];
//    alphaView.alpha = 0.85;
//    alphaView.backgroundColor = BGCOLOR;
//    [ViewButton addSubview:alphaView];
//    
//    messageLabel = [MyControl createLabelWithFrame:CGRectMake(32, 5, 100, 26) Font:15 Text:@"私信"];
//    messageLabel.backgroundColor = SelectedColor;
//    messageLabel.textAlignment = NSTextAlignmentCenter;
//    messageLabel.layer.cornerRadius = 5;
//    messageLabel.layer.masksToBounds = YES;
//    [ViewButton addSubview:messageLabel];
//    
//    messageButton = [MyControl createButtonWithFrame:CGRectMake(32, 5, 100, 26) ImageName:nil Target:self Action:@selector(messageClick:) Title:nil];
//    
////    messageButton.selected = YES;
//    [ViewButton addSubview:messageButton];
//    
//    systemLabel = [MyControl createLabelWithFrame:CGRectMake(190, 5, 100, 26) Font:15 Text:@"评论"];
//    systemLabel.textAlignment = NSTextAlignmentCenter;
//    systemLabel.layer.cornerRadius = 5;
//    systemLabel.layer.masksToBounds = YES;
//    [ViewButton addSubview:systemLabel];
//    
//    systemButton = [MyControl createButtonWithFrame:CGRectMake(190, 5, 100, 26) ImageName:nil Target:self Action:@selector(systemClick:) Title:nil];
//    [ViewButton addSubview:systemButton];
//    
////    UIImageView *line = [MyControl createImageViewWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1) ImageName:@"31-2.png"];
////    [self.view addSubview:line];
//}
//
//- (void)changeBackgroundColor
//{
//    UIColor *Temp = messageLabel.backgroundColor;
//    messageLabel.backgroundColor = systemLabel.backgroundColor;
//    systemLabel.backgroundColor = Temp;
//}

- (void)createTableView
{
    messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:messageTableView];
    messageTableView.delegate = self;
    messageTableView.dataSource = self;
    messageTableView.separatorStyle = 0;
//    [messageTableView addHeaderWithTarget:self action:@selector(loadMessageData)];
//    [messageTableView addFooterWithTarget:self action:@selector(loadMoreMessageData)];
    [messageTableView release];
    messageTableView.backgroundColor = [UIColor clearColor];
    messageTableView.tableHeaderView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    
//    systemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
//    [self.view addSubview:systemTableView];
//    systemTableView.hidden = YES;
//    systemTableView.delegate = self;
//    systemTableView.dataSource = self;
//    systemTableView.separatorStyle = 0;
//    [systemTableView setBackgroundColor:[UIColor clearColor]];
//    systemTableView.editing = YES;
//    [systemTableView addHeaderWithTarget:self action:@selector(loadSystemData)];
//    [systemTableView addFooterWithTarget:self action:@selector(loadMoreSystemData)];
//    systemTableView.tableHeaderView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35+64)] autorelease];
//    [systemTableView release];
    
}
#pragma mark - TableView DataSoure and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //此处由self.messageButton改为tableView == messageTableView看是否解决崩溃问题
//    if (tableView == messageTableView) {
//        return self.messageDataArray.count;
//    }else{
//        return self.systemDataArray.count;
//    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellMessage";
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    //传递5个数据，需要5个数组
    NoticeModel * model = self.dataArray[indexPath.row];

    [cell configUIWithTx:model.usr_tx Name:model.usr_name Time:model.time Content:model.lastMsg newMsgNum:model.unReadNum img_id:model.img_id index:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = 0;
    
    cell.deleteClick = ^(int a){
        //删除本地聊天记录
        NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
        [self.totalDataDict removeObjectForKey:[self.dataArray[indexPath.row] talk_id]];
        NSData * data = [MyControl returnDataWithDictionary:self.totalDataDict];
        BOOL isDelete = [data writeToFile:path atomically:YES];
        NSLog(@"isDelete:%d", isDelete);
        //通过获取的索引值删除数组中的值
        [self.dataArray removeObjectAtIndex:indexPath.row];
        //删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    };
    cell.blackClick = ^(int a){
        ReportAlertView * report = [[ReportAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        report.AlertType = 1;
        [report makeUI];
        [self.view addSubview:report];
        [UIView animateWithDuration:0.2 animations:^{
            report.alpha = 1;
        }];
        report.confirmClick = ^(){
            //确定拉黑
            [self black:a];
        };
    };
    return cell;
}
-(void)black:(int)a
{
    StartLoading;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"talk_id=%@dog&cat", [self.dataArray[a] talk_id]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", BOLCKTALKAPI, [self.dataArray[a] talk_id], sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            [MyControl loadingSuccessWithContent:@"拉黑成功" afterDelay:0.5];
        }else{
            LoadingFailed;
        }
    }];
    [request release];
}
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
    /*
    if (tableView == messageTableView) {
        NSString * code = [NSString stringWithFormat:@"mail_id=%@dog&cat", [self.messageDataArray[indexPath.row] mail_id]];
        NSString * sig = [MyMD5 md5:code];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", DELMESSAGEAPI, [self.messageDataArray[indexPath.row] mail_id], sig, [ControllerManager getSID]];
        //    NSLog(@"DelUrl:%@", url);
        [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"delResult:%@", load.dataDict);
                if (![[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"删除失败"];
                }
            }
        }];
        
        [self.messageDataArray removeObjectAtIndex:indexPath.row];
    }else{
        NSString * code = [NSString stringWithFormat:@"mail_id=%@dog&cat", [self.systemDataArray[indexPath.row] mail_id]];
        NSString * sig = [MyMD5 md5:code];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", DELMESSAGEAPI, [self.systemDataArray[indexPath.row] mail_id], sig, [ControllerManager getSID]];
        //    NSLog(@"DelUrl:%@", url);
        [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"delResult:%@", load.dataDict);
                if (![[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"删除失败"];
                }
            }
        }];
        
        [self.systemDataArray removeObjectAtIndex:indexPath.row];
    }
    
    */
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    
//    if (editingStyle==UITableViewCellEditingStyleDelete) {
//        //删除本地聊天记录
//        NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
//        [self.totalDataDict removeObjectForKey:[self.dataArray[indexPath.row] talk_id]];
//        NSData * data = [MyControl returnDataWithDictionary:self.totalDataDict];
//        BOOL isDelete = [data writeToFile:path atomically:YES];
//        NSLog(@"isDelete:%d", isDelete);
//        //通过获取的索引值删除数组中的值
//        [self.dataArray removeObjectAtIndex:indexPath.row];
//        //删除单元格的某一行时，在用动画效果实现删除过程
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击某一行后，判断是否有新消息，如果有清除该talk_id在本地的数据
//    if ([self.newMsgNumArray[indexPath.row] intValue]) {
//        NSMutableArray * msgArray = [NSMutableArray arrayWithArray:[[USER objectForKey:@"newMsgArrayDict"] objectForKey:@"msgArray"]];
//        for (int i=0; i<msgArray.count; i++) {
//            NSString * key = [[msgArray[i] allKeys] objectAtIndex:0];
//            if ([self.talkIDArray[indexPath.row] isEqualToString:key]) {
//                [msgArray removeObjectAtIndex:i];
//                break;
//            }
//        }
//        //重新赋值
//        NSMutableDictionary * localDict = [NSMutableDictionary dictionaryWithDictionary:[USER objectForKey:@"newMsgArrayDict"]];
//        [localDict setObject:msgArray forKey:@"msgArray"];
//        
//        [USER setObject:localDict forKey:@"newMsgArrayDict"];
//        [USER synchronize];
//    }
    NoticeModel * model = self.dataArray[indexPath.row];
    SingleTalkModel * talkModel = [self.totalDataDict objectForKey:model.talk_id];
    talkModel.unReadMsgNum = @"0";
    
    NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
    NSData * data = [MyControl returnDataWithDictionary:self.totalDataDict];
    BOOL save = [data writeToFile:path atomically:YES];
    NSLog(@"---save:%d", save);

    NSLog(@"和:%@聊天", model.usr_name);
    
//    rowOfTalk = indexPath.row;
//    self.newMsgNumArray[indexPath.row] = @"0";
    [messageTableView reloadData];
    
//    self.lastMessage = @"";
    [USER setObject:@"1" forKey:@"isFromNotice"];
    
    TalkViewController * vc = [[TalkViewController alloc] init];
    vc.friendName = model.usr_name;
    vc.usr_id = model.usr_id;
    vc.otherTX = model.usr_tx;
//    vc.noticeVc = self;
    vc.talk_id = model.talk_id;
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}

#pragma mark - Button 点击事件
//-  (void)returnClick:(UIButton *)button
//{
//    button.selected = !button.selected;
//    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
//    if (button.selected) {
//        [menu showMenuAnimated:YES];
//    }else{
//        [menu hideMenuAnimated:YES];
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
- (void)clearClick
{
//    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"您确定要清除消息么？" Message:nil delegate:self cancelTitle:@"取消" otherTitles:@"确定"];
}
#pragma mark - alert代理
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [self.systemDataArray removeAllObjects];
//    [systemTableView reloadData];
//}

//- (void)messageClick:(UIButton *)sender
//{
//    if (!sender.selected) {
//        [self changeBackgroundColor];
//        sender.selected = YES;
//    systemLabel.backgroundColor = [UIColor clearColor];
//    messageLabel.backgroundColor = SelectedColor;
//        systemButton.selected = NO;
//        messageTableView.hidden = NO;
//        systemTableView.hidden = YES;
//    }
    
//    [messageTableView reloadData];
//}
//- (void)systemClick:(UIButton *)sender
//{
//    if (!sender.selected) {
//        [self changeBackgroundColor];
//        sender.selected = YES;
//    messageLabel.backgroundColor = [UIColor clearColor];
//    systemLabel.backgroundColor = SelectedColor;
//        messageButton.selected = NO;
//        systemTableView.hidden = NO;
//        messageTableView.hidden = YES;
//    }
//    [systemTableView reloadData];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 图片毛玻璃化
-(void)createBg
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.png"];
    [self.view addSubview:imageView];
//    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
//    [self.view addSubview:self.bgImageView];
//    //    self.bgImageView.backgroundColor = [UIColor redColor];
////    NSString * docDir = DOCDIR;
//    NSString * filePath = BLURBG;
//    NSLog(@"%@", filePath);
//    NSData * data = [NSData dataWithContentsOfFile:filePath];
//    //    NSLog(@"%@", data);
//    UIImage * image = [UIImage imageWithData:data];
//    self.bgImageView.image = image;
//    //    self.bgImageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
//    
//    //毛玻璃化，需要先设置图片再设置其他
////    [self.bgImageView setFramesCount:20];
////    [self.bgImageView setBlurAmount:1];
//    
//    //这里必须延时执行，否则会变白
//    //注意，由于图片较大，这里需要的时间必须在2秒以上
////    [self performSelector:@selector(blurImage) withObject:nil afterDelay:0.25f];
//    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
//    [self.view addSubview:tempView];
}


@end
