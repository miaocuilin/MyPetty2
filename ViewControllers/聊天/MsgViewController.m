//
//  MsgViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MsgViewController.h"
#import "ChatListCell.h"
#import "ChatViewController.h"
#import "EaseMob.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "NSDate+Category.h"


@interface MsgViewController () <IChatManagerDelegate,SRRefreshDelegate,UIActionSheetDelegate>
{
    NSIndexPath *_currentLongPressIndex;
}
@end

@implementation MsgViewController
- (void)dealloc{
    [self unregisterNotifications];
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshDataSource];
    [self registerNotifications];
    
    BOOL isLogin = [[[EaseMob sharedInstance] chatManager] isLoggedIn];
    if (!isLogin) {
        NSLog(@"未登录");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未登录，不能发送消息，是否重新登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [alert show];
        [alert release];
    }
}
#pragma mark - alertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //登录环信
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[USER objectForKey:@"usr_id"] password:[USER objectForKey:@"code"] completion:^(NSDictionary *loginInfo, EMError *error) {
            if (!error) {
                NSLog(@"登录成功");
                [[EaseMob sharedInstance].chatManager setApnsNickname:[USER objectForKey:@"name"]];
                [self refreshDataSource];
            }else{
                NSLog(@"%@", error);
            }
        } onQueue:nil];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"消息";
    
    [self modifyUI];
    [self createFakeNavigation];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
}
-(void)modifyUI
{
    self.navigationController.navigationBarHidden = YES;
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:252/255.0 green:123/255.0 blue:81/255.0 alpha:0.3]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@""];
//    self.navigationController.navigationBar.backgroundColor = ORANGE;
//    self.navigationController.navigationBar.alpha = 0.3;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //
//    UIButton * leftBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 10, 17) ImageName:@"leftArrow.png" Target:self Action:@selector(leftBtnClick) Title:nil];
//    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    
    UIImageView * blurImage = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.png"];
    [self.view addSubview:blurImage];
//
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    alphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [self.view addSubview:alphaView];
    
//    [self createTableView];
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
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(leftBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"消息"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}
-(void)leftBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark - getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"chatListCell"];
//        [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    }
    
    return _tableView;
}
- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor clearColor];
    }
    
    return _slimeView;
}

#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return [ret autorelease];
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = @"[图片]";
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = @"[声音]";
            } break;
            case eMessageBodyType_Location: {
                ret = @"[位置]";
            } break;
            case eMessageBodyType_Video: {
                ret = @"[视频]";
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"chatListCell";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
    }
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
//    NSLog(@"%@", conversation.latestMessage.ext);
    BOOL hasOthersMsg;
    if ([conversation.latestMessageFromOthers.ext objectForKey:@"nickname"] == nil) {
        //昵称为空，说明没有对方发来的消息
        hasOthersMsg = NO;
    }else{
        hasOthersMsg = YES;
    }
    
    if (hasOthersMsg) {
        //有对方发的
        NSString * tx = [conversation.latestMessageFromOthers.ext objectForKey:@"tx"];
        if (![tx isKindOfClass:[NSNull class]] && tx.length) {
            cell.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL, tx]];
        }
        cell.name = [conversation.latestMessageFromOthers.ext objectForKey:@"nickname"];
        cell.usr_id = conversation.chatter;
    }else{
        //没有对方发的
        NSString * tx = [conversation.latestMessage.ext objectForKey:@"other_tx"];
        if (![tx isKindOfClass:[NSNull class]] && tx.length) {
            cell.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL, tx]];
        }
        cell.name = [conversation.latestMessage.ext objectForKey:@"other_nickname"];
        cell.usr_id = conversation.chatter;
    }
    
//    if ([[conversation.latestMessageFromOthers.ext objectForKey:@"other_nickname"] isEqualToString:[USER objectForKey:@"name"]]) {
//        //有对方发的
//        NSString * tx = [conversation.latestMessageFromOthers.ext objectForKey:@"tx"];
//        if (![tx isKindOfClass:[NSNull class]] && tx.length) {
//            cell.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL, tx]];
//        }
//        cell.name = [conversation.latestMessageFromOthers.ext objectForKey:@"nickname"];
//        cell.usr_id = conversation.chatter;
//    }else{
//        //没有对方发的
//        NSString * tx = [conversation.latestMessage.ext objectForKey:@"other_tx"];
//        if (![tx isKindOfClass:[NSNull class]] && tx.length) {
//            cell.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL, tx]];
//        }
//        cell.name = [conversation.latestMessage.ext objectForKey:@"other_nickname"];
//        cell.usr_id = conversation.chatter;
//    }
    
    
//    NSString * tx = [conversation.latestMessageFromOthers.ext objectForKey:@"tx"];
//    if ([tx isKindOfClass:[NSNull class]] && tx.length) {
//        cell.imageURL = [NSURL URLWithString:[conversation.latestMessageFromOthers.ext objectForKey:@"tx"]];
//    }
//    
//    cell.name = [conversation.latestMessageFromOthers.ext objectForKey:@"nickName"];//    if (!conversation.isGroup) {
        cell.placeholderImage = [UIImage imageNamed:@"defaultUserHead.png"];
//    }else{
//        NSString *imageName = @"groupPublicHeader";
//        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//        for (EMGroup *group in groupArray) {
//            if ([group.groupId isEqualToString:conversation.chatter]) {
//                cell.name = group.groupSubject;
//                imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
//                break;
//            }
//        }
//        cell.placeholderImage = [UIImage imageNamed:imageName];
//    }
    cell.detailMsg = [self subTitleMessageByConversation:conversation];
    cell.time = [self lastMessageTimeByConversation:conversation];
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];
//    if (indexPath.row % 2 == 1) {
//        cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
//    }else{
//        cell.contentView.backgroundColor = [UIColor whiteColor];
//    }
    cell.longPress = ^(){
        if (!([conversation.chatter isEqualToString:@"1"] || [conversation.chatter isEqualToString:@"2"] || [conversation.chatter isEqualToString:@"3"])) {
            [self cellImageViewLongPressAtIndexPath:indexPath];
        }
        
    };
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"环信总数据数：%d", self.dataSource.count);
    return  self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    ChatViewController *chatController;
    NSString *title = conversation.chatter;
    if (conversation.isGroup) {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *group in groupArray) {
            if ([group.groupId isEqualToString:conversation.chatter]) {
                title = group.groupSubject;
                break;
            }
        }
    }
    
    NSString *chatter = conversation.chatter;
    
    chatController = [[ChatViewController alloc] initWithChatter:chatter isGroup:conversation.isGroup];
    if ([[conversation.latestMessageFromOthers.ext objectForKey:@"other_nickname"] isEqualToString:[USER objectForKey:@"name"]]) {
        //有对方发的
        chatController.nickName = [conversation.latestMessageFromOthers.ext objectForKey:@"other_nickname"];
        chatController.other_nickName = [conversation.latestMessageFromOthers.ext objectForKey:@"nickname"];
        chatController.tx = [conversation.latestMessageFromOthers.ext objectForKey:@"other_tx"];
        chatController.other_tx = [conversation.latestMessageFromOthers.ext objectForKey:@"tx"];
    }else{
        //没有对方发的
        chatController.nickName = [conversation.latestMessage.ext objectForKey:@"nickname"];
        chatController.other_nickName = [conversation.latestMessage.ext objectForKey:@"other_nickname"];
        chatController.tx = [conversation.latestMessage.ext objectForKey:@"tx"];
        chatController.other_tx = [conversation.latestMessage.ext objectForKey:@"other_tx"];
    }
    
    chatController.title = title;
    [self.navigationController pushViewController:chatController animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:NO];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self refreshDataSource];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate
//刷新消息列表
-(void)refreshData
{
    [self refreshDataSource];
    [_tableView headerEndRefreshing];
}
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self refreshDataSource];
    [_slimeView endRefresh];
}

#pragma mark - BaseTableCellDelegate

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    EMBuddy *buddy = [EMBuddy buddyWithUsername:[self.dataSource[indexPath.row] chatter]];
//    [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([buddy.username isEqualToString:loginUsername])
    {
        return;
    }
    
    _currentLongPressIndex = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"加入黑名单" otherButtonTitles:nil, nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex && _currentLongPressIndex) {
        EMBuddy *buddy = [EMBuddy buddyWithUsername:[self.dataSource[_currentLongPressIndex.row] chatter]];
//        [self.tableView beginUpdates];
//        [[self.dataSource objectAtIndex:(_currentLongPressIndex.section - 1)] removeObjectAtIndex:_currentLongPressIndex.row];
        //        [self.contactsSource removeObject:buddy];
//        [self.tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:_currentLongPressIndex] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView  endUpdates];
        
        [[EaseMob sharedInstance].chatManager blockBuddy:buddy.username relationship:eRelationshipBoth];
    }
    
    _currentLongPressIndex = nil;
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - public

-(void)refreshDataSource
{
    self.dataSource = [self loadDataSource];
    [_tableView reloadData];
//    [self hideHud];
}

- (void)willReceiveOfflineMessages{
    NSLog(@"开始接收离线消息");
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
    NSLog(@"离线消息接收成功");
    [self refreshDataSource];
}


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
