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
@interface TalkViewController ()

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
-(void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
//    self.userDataArray = [NSMutableArray arrayWithCapacity:0];
    
//    [self createHeader];
    [self createNavigation];
    [self createTableView];
}

-(void)createNavigation
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"talkHeader" ofType:@"png"]] forBarMetrics:UIBarMetricsDefault];
    UIButton * leftButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) ImageName:@"14-6.png" Target:self Action:@selector(leftButtonClick) Title:nil];
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    [leftBarButton release];
    
    self.navigationItem.title = [self.userDataArray[0] name];
}
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
-(void)leftButtonClick
{
    [UIApplication sharedApplication].statusBarStyle = 1;
//    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"af" object:nil];
}

#pragma mark - tableView
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-[MyControl isIOS7]-40) style:UITableViewStylePlain];
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tv.allowsSelection = NO;
//    UIImageView * backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
//    tv.backgroundView = backImageView;
//    [backImageView release];
    tv.backgroundColor = [UIColor clearColor];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    
    UIButton * tvBgButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, tv.frame.size.width, tv.frame.size.height) ImageName:@"" Target:self Action:@selector(hideKeyboard) Title:nil];
    [tv addSubview:tvBgButton];
    
    //发送栏
    commentBgView = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height-[MyControl isIOS7]-40, 320, 40)];
    commentBgView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:commentBgView];
    
    tf = [MyControl createTextFieldWithFrame:CGRectMake(5, 5, 250, 30) placeholder:@"发私信" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    tf.returnKeyType = UIReturnKeySend;
    tf.delegate = self;
    tf.layer.cornerRadius = 5;
    tf.layer.masksToBounds = YES;
    [commentBgView addSubview:tf];
    
    sendButton = [MyControl createButtonWithFrame:CGRectMake(260, 10, 55, 20) ImageName:@"" Target:self Action:@selector(sendButtonClick) Title:@"发送"];
    [sendButton setTitleColor:BGCOLOR forState:UIControlStateNormal];
    [commentBgView addSubview:sendButton];
    
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
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // 设置数据
    cell.messageFrame = self.dataArray[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.dataArray[indexPath.row] cellHeight];
}


#pragma mark - 代理方法
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    //滑动让键盘消失，效果同QQ
//    [self.view endEditing:YES];
//}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
        tv.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-40+ty);
        commentBgView.frame = CGRectMake(0, self.view.frame.size.height-40+ty, 320, 40);
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
        tv.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-40);
        commentBgView.frame = CGRectMake(0, self.view.frame.size.height-40, 320, 40);
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
        [ControllerManager startLoading:@"发送中..."];
        [ControllerManager loadingFailed:@"内容不能为空"];
        return NO;
    }
    [ControllerManager startLoading:@"发送中..."];
    
    // 5、上传信息
    [self postData];
    
    // 1、增加数据源
    NSString *content = textField.text;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    fmt.dateFormat = @"MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
    NSString *time = [fmt stringFromDate:date];
    [fmt release];
    [self addMessageWithContent:content time:time];
    // 2、刷新表格
    [tv reloadData];
    // 3、滚动至当前行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    [tv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    // 4、清空文本框内容
    tf.text = nil;
    
    return YES;
}

#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time{
    
    MessageFrame *mf = [[MessageFrame alloc] init];
    Message *msg = [[Message alloc] init];
    msg.content = content;
    msg.time = time;
    msg.icon = [USER objectForKey:@"tx"];
    msg.type = MessageTypeMe;
    mf.message = msg;
    
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
-(void)requestFinished:(ASIHTTPRequest *)request
{
    [ControllerManager loadingSuccess:@"发送成功"];
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [ControllerManager loadingFailed:@"发送失败"];
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
