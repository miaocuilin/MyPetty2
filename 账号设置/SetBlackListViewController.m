//
//  SetBlackListViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "SetBlackListViewController.h"
#import "BlackListCell.h"
#import "InfoModel.h"
#import "EaseMob.h"
#import "FAQViewController.h"
#import "FAQCell.h"
@interface SetBlackListViewController () <IChatManagerDelegate,UIAlertViewDelegate>

@end

@implementation SetBlackListViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self getBlackList];
    [self createBg];
    [self createTableView];
    [self createFakeNavigation];
    
}
#pragma mark -
-(void)getBlackList
{
    BOOL isLogin = [[[EaseMob sharedInstance] chatManager] isLoggedIn];
    if (!isLogin) {
        NSLog(@"未登录");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未登录，不能查看黑名单，是否重新登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [alert show];
        return;
    }
    [[EaseMob sharedInstance].chatManager asyncFetchBlockedListWithCompletion:^(NSArray *blockedList, EMError *error) {
        if (!error) {
            NSLog(@"获取成功 -- %@",blockedList);
            [self loadData:blockedList];
        }else{
            NSLog(@"%@", error);
            UILabel * label = [MyControl createLabelWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 20) Font:15 Text:@"小黑屋里还没人~"];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
//            label.tag = 100;
            [self.view addSubview:label];
        }
    } onQueue:nil];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[USER objectForKey:@"usr_id"] password:[USER objectForKey:@"code"] completion:^(NSDictionary *loginInfo, EMError *error) {
            if (!error) {
                NSLog(@"登录成功");
                [[EaseMob sharedInstance].chatManager setApnsNickname:[USER objectForKey:@"name"]];
//                UILabel * label = (UILabel *)[self.view viewWithTag:100];
//                [label removeFromSuperview];
                [self getBlackList];
            }else{
                NSLog(@"%@", error);
            }
        } onQueue:nil];
    }
}
-(void)loadData:(NSArray *)tempArray
{
    NSMutableString * str = [NSMutableString stringWithCapacity:0];
    for (int i=0; i<tempArray.count; i++) {
        [str appendString:tempArray[i]];
        if (i != tempArray.count-1) {
            [str appendString:@","];
        }
    }
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_ids=%@dog&cat", str]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERSINFOAPI, str, sig, [USER objectForKey:@"SID"]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                [self.dataArray removeAllObjects];
                NSArray * array = [load.dataDict objectForKey:@"data"];
                for (NSDictionary * dict in array) {
                    InfoModel * model = [[InfoModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                    [model release];
                }
                [tv reloadData];
                
            }
        }else{
        
        }
    }];
    [request release];
}

#pragma mark - 创建背景及导航
-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"blurBg.jpg"];
    [self.view addSubview:bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
//    NSString * docDir = DOCDIR;
//    NSString * filePath = BLURBG;
//    //    NSLog(@"%@", filePath);
//    NSData * data = [NSData dataWithContentsOfFile:filePath];
//    //    NSLog(@"%@", data);
//    UIImage * image = [UIImage imageWithData:data];
//    bgImageView.image = image;
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [self.view addSubview:tempView];
}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"解除黑名单"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:titleLabel];
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 创建tableView
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.backgroundColor = [UIColor clearColor];
    tv.separatorStyle = 0;
    [self.view addSubview:tv];
    [tv release];
    
    UIView * headView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    tv.tableHeaderView = headView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    BlackListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[BlackListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    
    InfoModel *model = self.dataArray[indexPath.row];
//    cell.cancelBtnClick = ^(int a, NSString * master_id){
//        NSLog(@"clickDefaultPet:%d", a);
//        //请求切换默认宠物API
//        [self changeDefaultPet:[self.userPetListArray[a] aid] MasterId:master_id];
//    };
//    NSLog(@"%@", model.name);
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
    [cell configUIWithModel:model];
    cell.deleteBlack = ^(){
//        NSIndexPath * cellIndexPath = [tv indexPathForCell:cell];
        NSLog(@"%d", indexPath.row);
        //通过获取的索引值删除数组中的值
        [self.dataArray removeObjectAtIndex:indexPath.row];
        //删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [tv reloadData];
        
        [self registerEaseMobDelegate];
        // 将6001移除黑名单
        EMError *error = [[EaseMob sharedInstance].chatManager unblockBuddy:model.usr_id];
        if (!error && self.dataArray.count == 0) {
            NSLog(@"发送成功");
            UILabel * label = [MyControl createLabelWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 20) Font:15 Text:@"小黑屋里还没人~"];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:label];
        }
    };
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
}

#pragma mark -
#pragma mark - IChatManagerDelegate
- (void)didUnblockBuddy:(EMBuddy *)buddy error:(EMError **)pError{
    if (!pError) {
        [MyControl popAlertWithView:self.view Msg:@"移除成功"];
    }
}

// 向SDK中注册回调
- (void)registerEaseMobDelegate{
    // 此处先取消一次，是为了保证只将self注册过一次回调。
    [self unRegisterEaseMobDelegate];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

// 取消SDK中注册的回调
- (void)unRegisterEaseMobDelegate{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
@end
