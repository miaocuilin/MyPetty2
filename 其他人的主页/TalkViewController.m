//
//  TalkViewController.m
//  MyPetty
//
//  Created by Aidi on 14-7-14.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "TalkViewController.h"
#import "Message.h"
#import "MessageCell.h"
#import "MessageFrame.h"
#import "SingleTalkModel.h"
#import "MessageModel.h"
#import "PicDetailViewController.h"
#import "UserInfoViewController.h"
#import "FrontImageDetailViewController.h"
#import "AddressViewController.h"
//#import "NoticeViewController.h";
#define TimeGap 60

@interface TalkViewController ()
{
    SingleTalkModel * talkModel;
}
@end

@implementation TalkViewController

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
////    [UIApplication sharedApplication].statusBarStyle = 0;
//    NSLog(@"&&&&&&&&&&&&&&&&&&%f--%f", tv.contentSize.height-tv.frame.size.height, tv.contentOffset.y);
//}
-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"&&&&&&&&&&&&&&&&&&%f--%f", tv.contentSize.height-tv.frame.size.height, tv.contentOffset.y);
    if (tv.contentSize.height>=tv.frame.size.height){
        tv.contentOffset = CGPointMake(0, tv.contentSize.height-tv.frame.size.height);
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.totalDataDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    self.talkMsgDataDict = [NSMutableDictionary dictionaryWithCapacity:0];
    self.talkDataArray = [NSMutableArray arrayWithCapacity:0];
//    self.messageDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
//    self.userDataArray = [NSMutableArray arrayWithCapacity:0];
    self.keysArray = [NSMutableArray arrayWithCapacity:0];
    self.valuesArray = [NSMutableArray arrayWithCapacity:0];
    
    
    [self createBg];
    
    [self createTableView];
    
    if (self.talk_id != nil) {
        [self loadHistoryTalk];
    }else{
        [self loadTalkID];
    }
    
    [self createFakeNavigation];
    
//    [self loadNewMessageData];
//    [self talkListData];
//    [self talkSendMessageData];
    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(loadNewMessageData) userInfo:nil repeats:YES];
//    [timer setFireDate:[NSDate distantFuture]];
}
#pragma mark -
-(void)loadTalkID
{
    LOADING;
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat",self.usr_id]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", GETTALKIDAPI, self.usr_id, sig, [ControllerManager getSID]];
//    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            self.talk_id = [[load.dataDict objectForKey:@"data"] objectForKey:@"talk_id"];
            //下载完talk_id之后查看本地是否有历史聊天记录，有的话调出来
            [self loadHistoryTalk];
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)loadHistoryTalk
{
    NSFileManager * manager = [[NSFileManager alloc] init];
    NSString * docDir = DOCDIR;
    NSString * path = [docDir stringByAppendingPathComponent:@"talkData.plist"];
    if ([manager fileExistsAtPath:path]) {
        //文件存在
        NSLog(@"文件存在");
        //未读取本地文件
//        isRead = YES;
        self.totalDataDict = [NSMutableDictionary dictionaryWithDictionary:[MyControl returnDictionaryWithDataPath:path]];
        
        //判断历史记录中有没有历史消息
        if ([self.totalDataDict objectForKey:self.talk_id]) {
            //有历史消息
            
            talkModel = [self.totalDataDict objectForKey:self.talk_id];
            NSArray * msgModelArray = [talkModel.msgDict objectForKey:@"msg"];
            
            self.talkDataArray = [NSMutableArray arrayWithArray:msgModelArray];
            for (int i=0; i<msgModelArray.count;i++) {
                MessageModel * model = msgModelArray[i];
                if ([model.usr_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
                    [self presentNewMessageWithSend:YES time:model.time msg:model.msg];
                }else{
                    [self presentNewMessageWithSend:NO time:model.time msg:model.msg];
                }
            }

            //
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
//            [tv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }else{
            talkModel = [[SingleTalkModel alloc] init];
            talkModel.usr_id = self.usr_id;
            talkModel.usr_tx = self.otherTX;
            talkModel.usr_name = self.friendName;
            talkModel.unReadMsgNum = @"0";
            //这一句在用户点击返回时再添
//            talkModel.msgDict = [NSDictionary dictionaryWithObject:self.talkDataArray forKey:@"msg"];
        }
        
//        if ([self.totalDataDict objectForKey:self.talk_id]) {
//            self.talkDataDict = [self.totalDataDict objectForKey:self.talk_id];
//            self.talkDataArray = [NSMutableArray arrayWithArray:[self.talkDataDict objectForKey:@"data"]];
//            //取出每条信息添加到数组中
//            for (int i=0; i<self.talkDataArray.count; i++) {
//                NSDictionary * dict = self.talkDataArray[i];
//                if ([[dict objectForKey:@"usr_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
//                    [self presentNewMessageWithSend:YES time:[dict objectForKey:@"time"] msg:[dict objectForKey:@"msg"]];
//                }else{
//                    [self presentNewMessageWithSend:NO time:[dict objectForKey:@"time"] msg:[dict objectForKey:@"msg"]];
//                }
//
//            }
//            
//        }
    }else{
        //没有本地文件的时候
        talkModel = [[SingleTalkModel alloc] init];
        talkModel.usr_id = self.usr_id;
        talkModel.usr_tx = self.otherTX;
        talkModel.usr_name = self.friendName;
        talkModel.unReadMsgNum = @"0";
    }
//    [timer setFireDate:[NSDate date]];
    [self loadNewMessageData];
    
}
-(void)loadNewMessageData
{
    NSLog(@"==========loadNewMessageData:%d============", test++);
    if (!self.talk_id) {
        return;
    }
    //请求一个API，传usr_id，获取talk_id，根据talk_id去获取本地历史记录以及新的消息存到本地。
    //聊天里10秒刷一次，侧边栏在侧边栏弹出的时候刷新。
    NSString * url = [NSString stringWithFormat:@"%@%@", GETNEWMSGAPI,[ControllerManager getSID]];
    //    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"newMsg:%@", load.dataDict);
            if ([load.dataDict objectForKey:@"data"] && [[load.dataDict objectForKey:@"data"] count] && [[[load.dataDict objectForKey:@"data"] objectAtIndex:0] objectForKey:self.talk_id]) {
                NSLog(@"有新消息");
                //分析数据
                NSDictionary * dict = [[[load.dataDict objectForKey:@"data"] objectAtIndex:0] objectForKey:self.talk_id];
                
                [self analysisDataAndSaveAndPresent:[dict objectForKey:@"msg"]];
                //self.keysArray里是新消息的时间
                //self.valuesArray里是新消息的内容
                
                
//                //存储前先清空数组
//                self.keysArray
                
                //存储
//                for (int i=0; i<self.keysArray.count; i++) {
//                    NSLog(@"%@--%@", self.keysArray[i], self.valuesArray[i]);
//                    [self saveTalkDataWithUserID:self.usr_id time:self.keysArray[i] msg:self.valuesArray[i]];
//                    if (i == self.keysArray.count-1) {
////                        self.noticeVc.lastMessage = self.valuesArray[i];
//                    }
//                }
                
                //展示
//                NSLog(@"***************present time:%d", self.keysArray.count);
//                for (int i=0; i<self.keysArray.count; i++) {
//                    [self presentNewMessageWithSend:NO time:self.keysArray[i] msg:self.valuesArray[i]];
//                }
            }else{
                NSLog(@"没有新消息");
            }
//            LoadingSuccess;
        }else{
//            LoadingFailed;
            NSLog(@"fail");
        }
    }];
    [request release];
}
-(void)analysisDataAndSaveAndPresent:(NSDictionary *)dict
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
    NSLog(@"%@", self.keysArray);
    for (int i=0;i<self.keysArray.count;i++) {
        NSLog(@"key:%@--value:%@", self.keysArray[i], [dict objectForKey:self.keysArray[i]]);
        [self.valuesArray addObject:[dict objectForKey:self.keysArray[i]]];
        //
        MessageModel * msgModel = [[MessageModel alloc] init];
        msgModel.time = self.keysArray[i];
        msgModel.usr_id = self.usr_id;
        
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
        [self.talkDataArray addObject:msgModel];
        [msgModel release];
        
        //展示
//        [self presentNewMessageWithSend:NO time:self.keysArray[i] msg:self.valuesArray[i]];
        [self presentNewMessageWithSend:NO time:[self.talkDataArray[self.talkDataArray.count-1] time] msg:[self.talkDataArray[self.talkDataArray.count-1] msg]];
    }
    
}
-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"blurBg.png"];
    [self.view addSubview:bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
//    NSString * docDir = DOCDIR;
//    NSString * filePath = BLURBG;
//    NSLog(@"%@", filePath);
//    NSData * data = [NSData dataWithContentsOfFile:filePath];
//    //    NSLog(@"%@", data);
//    UIImage * image = [UIImage imageWithData:data];
//    bgImageView.image = image;
    
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [self.view addSubview:tempView];
}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"私信对话"];
    if (!([self.friendName isEqualToString:@""] || self.friendName == nil)) {
        titleLabel.text = self.friendName;
    }
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}
-(void)backBtnClick
{
    //退出时先暂停timer
    [timer invalidate];
    timer = nil;
    if ([[USER objectForKey:@"isFromNotice"] intValue]) {
        [USER setObject:@"0" forKey:@"isFromNotice"];
        [USER setObject:@"1" forKey:@"isBackToTalk"];
    }
    //存储对话到本地
    if (self.talkDataArray.count>0) {
        talkModel.msgDict = [NSDictionary dictionaryWithObject:self.talkDataArray forKey:@"msg"];
        [self.totalDataDict setObject:talkModel forKey:self.talk_id];
        NSData * data = [MyControl returnDataWithDictionary:self.totalDataDict];
        NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
        BOOL a = [data writeToFile:path atomically:YES];
        NSLog(@"存储结果：%d", a);
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)talkListData
//{
//    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"dog&cat"]];
//    NSString *listString = [NSString stringWithFormat:@"http://123.57.39.48/index.php?r=talk/listApi&sig=%@&SID=%@",sig,[ControllerManager getSID]];
//    NSLog(@"listString:%@",listString);
//}
- (void)talkSendMessageData
{
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat",self.usr_id]];
    NSString *sendString = [NSString stringWithFormat:@"http://release4pet.aidigame.com/index.php?r=talk/sendMsgApi&usr_id=%@&sig=%@&SID=%@", self.usr_id, sig, [ControllerManager getSID]];
    _requestSend = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:sendString]];
    _requestSend.requestMethod=@"POST";
    _requestSend.timeOutSeconds = 20;

    [_requestSend setPostValue:self.lastMessage forKey:@"msg"];
    [_requestSend setDelegate:self];
    [_requestSend startAsynchronous];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"success");
    ENDLOADING;
//    [MMProgressHUD dismissWithSuccess:@"发送成功" title:nil afterDelay:0.2];
    NSLog(@"响应：%@", [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
    //将消息存储到本地plist文件
    NSDate * date = [NSDate date];
    NSString * timeStamp = [NSString stringWithFormat:@"%d", (int)[date timeIntervalSince1970]];
    
    //存到本地
    MessageModel * model = [[MessageModel alloc] init];
    model.msg = self.lastMessage;
    model.time = timeStamp;
    model.usr_id = [USER objectForKey:@"usr_id"];
    model.img_id = @"0";
    [self.talkDataArray addObject:model];
//    NSLog(@"%@", [self.dataArray[self.dataArray.count-1] msg]);
    [model release];
    
    [self presentNewMessageWithSend:YES time:[NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]] msg:self.lastMessage];
//    [self saveTalkDataWithUserID:[USER objectForKey:@"usr_id"] time:timeStamp msg:self.lastMessage];
    //设置父控制器消息
//    NoticeViewController * vc = self.noticeVc;
//    vc.lastMessage = self.lastMessage;
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    LOADFAILED;
    NSLog(@"failed");
}
#pragma mark - 将消息存储到本地plist文件
//-(void)saveTalkDataWithUserID:(NSString *)usrID  time:(NSString *)timeStamp msg:(NSString *)msg
//{
////    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
////    fmt.dateFormat = @"yyyy-MM-dd HH:mm"; // @"yyyy-MM-dd HH:mm:ss"
////    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[timeStamp intValue]];
////    NSString *time = [fmt stringFromDate:date];
//    
//    NSFileManager * manager = [[NSFileManager alloc] init];
//    NSString * docDir = DOCDIR;
//    NSString * path = [docDir stringByAppendingPathComponent:@"talkData.plist"];
//    if ([manager fileExistsAtPath:path]) {
//        //文件存在
//        NSLog(@"文件存在");
//        if (isNewCreated) {
//            //新创建不读取本地数据
//            //直接存储数据
//            [self saveWithUserID:usrID time:timeStamp msg:msg];
//        }else{
//            //非新创建，读取本地数据
//            if (isRead) {
//                //已经读取本地文件
//            }else{
//                //未读取本地文件
//                isRead = YES;
//                self.totalDataDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//                if ([self.totalDataDict objectForKey:self.talk_id]) {
//                    self.talkDataDict = [self.totalDataDict objectForKey:self.talk_id];
//                    self.talkDataArray = [NSMutableArray arrayWithArray:[self.talkDataDict objectForKey:@"data"]];
//                }
////                NSLog(@"%@--%@", self.totalDataDict, self.talkDataDict);
//            }
//            [self saveWithUserID:usrID time:timeStamp msg:msg];
//        }
//    }else{
//        //文件不存在
//        NSLog(@"文件不存在");
//        isNewCreated = YES;
//        
//        NSMutableDictionary * messageDict = [NSMutableDictionary dictionaryWithCapacity:0];
//        [messageDict setObject:timeStamp forKey:@"time"];
//        [messageDict setObject:msg forKey:@"msg"];
//        [messageDict setObject:usrID forKey:@"usr_id"];
//        [self.talkDataArray addObject:messageDict];
//        
//        
//        [self.talkDataDict setObject:self.talkDataArray forKey:@"data"];
//        [self.talkDataDict setObject:self.usr_id forKey:@"usr_id"];
//        [self.talkDataDict setObject:self.friendName forKey:@"usr_name"];
//        [self.talkDataDict setObject:self.otherTX forKey:@"usr_tx"];
//        
//        [self.totalDataDict setObject:self.talkDataDict forKey:self.talk_id];
//        [self.totalDataDict writeToFile:path atomically:YES];
//        
////        [messageDict release];
//    }
//}
//-(void)saveWithUserID:(NSString *)usrID time:(NSString *)timeStamp msg:(NSString *)msg
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
//    [self.talkDataDict setObject:self.usr_id forKey:@"usr_id"];
//    [self.talkDataDict setObject:self.friendName forKey:@"usr_name"];
//    [self.talkDataDict setObject:self.otherTX forKey:@"usr_tx"];
//    
//    [self.totalDataDict setObject:self.talkDataDict forKey:self.talk_id];
//    [self.totalDataDict writeToFile:path atomically:YES];
//    
////    [messageDict release];
//}
//-(void)createFakeNavigation
//{
//    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
//    [self.view addSubview:navView];
//    
//    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
//    alphaView.alpha = 0.85;
//    alphaView.backgroundColor = BGCOLOR;
//    [navView addSubview:alphaView];
//    
//    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
//    [navView addSubview:backImageView];
//    
//    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
//    backBtn.showsTouchWhenHighlighted = YES;
//    //    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//    [navView addSubview:backBtn];
//    
//    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"对话"];
//    titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [navView addSubview:titleLabel];
//    
//    UIImageView * searchImageView = [MyControl createImageViewWithFrame:CGRectMake(320-31, 33, 18, 16) ImageName:@"5-5.png"];
//    [navView addSubview:searchImageView];
//    
//    UIView * line0 = [MyControl createViewWithFrame:CGRectMake(0, 63, 320, 1)];
//    line0.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.1];
//    [navView addSubview:line0];
//}
//- (void)backBtnClick
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//-(void)createNavigation
//{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"talkHeader" ofType:@"png"]] forBarMetrics:UIBarMetricsDefault];
//    UIButton * leftButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) ImageName:@"14-6.png" Target:self Action:@selector(leftButtonClick) Title:nil];
//    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = leftBarButton;
//    [leftBarButton release];
//    
//    self.navigationItem.title = [self.userDataArray[0] name];
//}
//-(void)createHeader
//{
//    UIImageView * headImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, [MyControl isIOS7]) ImageName:@""];
//    headImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"talkHeader" ofType:@"png"]];
//    headImageView.image = [headImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//    [self.view addSubview:headImageView];
//    
//    UIButton * leftButton = [MyControl createButtonWithFrame:CGRectMake(17, 25, 30, 30) ImageName:@"14-6.png" Target:self Action:@selector(leftButtonClick) Title:nil];
//    [headImageView addSubview:leftButton];
//    
//    UILabel * nameLabel = [MyControl createLabelWithFrame:CGRectMake(110, headImageView.frame.size.height-20-10, 100, 20) Font:17 Text:[self.userDataArray[0] name]];
//    nameLabel.textColor = [UIColor blackColor];
//    nameLabel.textAlignment = NSTextAlignmentCenter;
//    [headImageView addSubview:nameLabel];
//    
//}
//-(void)leftButtonClick
//{
//    [UIApplication sharedApplication].statusBarStyle = 1;
////    [self dismissViewControllerAnimated:YES completion:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"af" object:nil];
//}

#pragma mark - tableView
-(void)createTableView
{
//    UIButton * tvBgButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) ImageName:@"" Target:self Action:@selector(hideKeyboard) Title:nil];
//    [self.view addSubview:tvBgButton];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-40-64) style:UITableViewStylePlain];
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tv.allowsSelection = NO;
//    UIImageView * backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
//    tv.backgroundView = backImageView;
//    [backImageView release];
    tv.backgroundColor = [UIColor clearColor];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    
//    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
//    tv.tableHeaderView = tempView;
    
    
    //发送栏
    commentBgView2 = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height-40, 320, 40)];
    commentBgView2.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:commentBgView2];
    
    tf = [MyControl createTextFieldWithFrame:CGRectMake(5, 5, 250, 30) placeholder:@"发私信" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    tf.returnKeyType = UIReturnKeySend;
    tf.delegate = self;
    tf.layer.cornerRadius = 5;
    tf.layer.masksToBounds = YES;
    [commentBgView2 addSubview:tf];
    
    sendButton = [MyControl createButtonWithFrame:CGRectMake(260, 10, 55, 20) ImageName:@"" Target:self Action:@selector(sendButtonClick) Title:@"发送"];
    [sendButton setTitleColor:BGCOLOR forState:UIControlStateNormal];
    [commentBgView2 addSubview:sendButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)hideKeyboard
{
    [tf resignFirstResponder];
}

#pragma mark - 发送消息按钮
-(void)sendButtonClick
{
    [self textFieldShouldReturn:tf];
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d", self.dataArray.count);
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if ([[self.talkDataArray[indexPath.row] img_id] intValue] > 0) {
        cell.hasArrow = YES;
    }else{
        cell.hasArrow = NO;
    }
    
    // 设置数据
    [cell setMessageFrame:self.dataArray[indexPath.row]];
    
    cell.jumpToUserInfo = ^(void){
        int a = [[self.talkDataArray[indexPath.row] usr_id] intValue];
        if (a == 1 || a == 2 || a == 3) {
            return;
        }
        UserInfoViewController * vc = [[UserInfoViewController alloc] init];
        //    NSLog(@"%@", petInfoDict);
        vc.usr_id = [self.talkDataArray[indexPath.row] usr_id];
        vc.modalTransitionStyle = 2;
//        vc.isFromPetInfo = YES;
//        vc.petHeadImage = headerImageView.image;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    };
    
    cell.jumpToPicDetail = ^(void){
        FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
        vc.img_id = [self.talkDataArray[indexPath.row] img_id];
//        vc.usr_id = [self.talkDataArray[indexPath.row] usr_id];
        [self.view addSubview:vc.view];
        [vc release];
    };
    cell.jumpToAddress = ^(){
        AddressViewController * address = [[AddressViewController alloc] init];
        [self presentViewController:address animated:YES completion:nil];
        [address release];
    };
//    cell.messageFrame = self.dataArray[indexPath.row];
    cell.selectionStyle = 0;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.dataArray[indexPath.row] cellHeight];
}


#pragma mark - 代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //滑动让键盘消失，效果同QQ
    [self.view endEditing:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%f----%f", tv.contentSize.height-tv.frame.size.height,tv.contentOffset.y);
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
        tv.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-40+ty);
        commentBgView2.frame = CGRectMake(0, self.view.frame.size.height-40+ty, 320, 40);
        if (tv.contentSize.height>tv.frame.size.height) {
            tv.contentOffset = CGPointMake(0, tv.contentSize.height-tv.frame.size.height);
        }
    }];
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        self.view.transform = CGAffineTransformIdentity;
        NSLog(@"%f", self.view.frame.size.height);
        tv.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-40-64);
        commentBgView2.frame = CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40);
        if (tv.contentSize.height>tv.frame.size.height) {
            tv.contentOffset = CGPointMake(0, tv.contentSize.height-tv.frame.size.height);
        }
    }];
}

#pragma mark - 文本框代理方法
#pragma mark 点击textField键盘的回车按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([tf.text isKindOfClass:[NSNull class]] || tf.text.length == 0) {
        [MyControl popAlertWithView:self.view Msg:@"内容不能为空"];
//        [ControllerManager startLoading:@"发送中..."];
//        [ControllerManager loadingFailed:@"内容不能为空"];
        return NO;
    }
    
    LOADING;
//    [ControllerManager startLoading:@"发送中..."];
    
    // 5、上传信息
//    [self postData];
    NSLog(@"tf.text:%@--%@", tf.text, self.talk_id);
    self.lastMessage = tf.text;
    [self talkSendMessageData];
    
    
    return YES;
}
#pragma mark - 将新消息展示出来
-(void)presentNewMessageWithSend:(BOOL)isSend time:(NSString *)timeStamp msg:(NSString *)msg
{
    // 1、增加数据源
    NSString *content = msg;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm"; // @"yyyy-MM-dd HH:mm:ss"
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp intValue]];
    NSString *time = [fmt stringFromDate:date];
    NSLog(@"date:%@--time:%@", date, time);
    [fmt release];
    [self addMessageWithContent:content time:time isSend:isSend timeStamp:timeStamp];
    // 2、刷新表格
    [tv reloadData];
    
    [self.view insertSubview:navView aboveSubview:tv];
//    [self.view bringSubviewToFront:navView];
    // 3、滚动至当前行
//    NSLog(@"========count:%d=======",self.dataArray.count);
//    NSLog(@"*******offset:%f********", tv.contentSize.height);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
    [tv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    [tv reloadData];
//    NSLog(@"%f--%f", tv.contentSize.height-tv.frame.size.height, tv.contentOffset.y);
//    if (tv.contentSize.height>=tv.frame.size.height) {
//        [UIView animateKeyframesWithDuration:0.1 delay:0.2 options:0 animations:^{
//            tv.contentOffset = CGPointMake(0, tv.contentSize.height-tv.frame.size.height);
//        } completion:nil];
//        
//    }
    
//    NSLog(@"&&&&&&&offset:%f&&&&&&&", tv.contentOffset.y);
    // 4、清空文本框内容
    tf.text = nil;
}

#pragma mark - 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time isSend:(BOOL)isSend timeStamp:(NSString *)timeStamp{
    
    MessageFrame *mf = [[MessageFrame alloc] init];
    Message *msg = [[Message alloc] init];
    msg.content = content;
    msg.time = time;
    if (isSend) {
        msg.icon = [USER objectForKey:@"tx"];
        msg.type = MessageTypeMe;
    }else{
        msg.icon = self.otherTX;
        msg.type = MessageTypeOther;
    }
    mf.message = msg;
    
    
//    NSLog(@"%d--%d--%d", [timeStamp intValue], newestTime,[timeStamp intValue]-newestTime);
    if ([timeStamp intValue]-newestTime>=TimeGap) {
        mf.showTime = NO;
        newestTime = [timeStamp intValue];
    }else{
        mf.showTime = NO;
    }
    
//    mf.hasArrow = hasArrow;
    
    [self.dataArray addObject:mf];
    //这两个不能释放，后面还要用到，都则会崩溃
//    [mf release];
//    [msg release];
}

#pragma mark - 发送消息
-(void)postData
{  
    //发送消息 POST方法 参数为to_id 和 body
    //    #define POSTMESSAGEAPI
    NSString * url = [NSString stringWithFormat:@"%@%@", POSTMESSAGEAPI, [ControllerManager getSID]];
    NSLog(@"postUrl:%@", url);
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 20;
//    NSLog(@"%@", [self.userDataArray[0] usr_id]);
    [_request setPostValue:[self.userDataArray[0] usr_id] forKey:@"to_id"];
    [_request setPostValue:tf.text forKey:@"body"];
    
    _request.delegate = self;
    [_request startAsynchronous];
}
//-(void)requestFinished:(ASIHTTPRequest *)request
//{
//    [ControllerManager loadingSuccess:@"发送成功"];
////    [request.responseData]
//    NSError *error;
//    id responseData = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
//    NSLog(@"data:%@",responseData);
//}
//-(void)requestFailed:(ASIHTTPRequest *)request
//{
//    [ControllerManager loadingFailed:@"发送失败"];
//}
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
