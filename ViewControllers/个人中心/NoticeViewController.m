//
//  NoticeViewController.m
//  MyPetty
//
//  Created by Aidi on 14-7-3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeCell.h"
#import "SystemCell.h"
#import "SystemMessageListModel.h"

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.systemDataArray = [NSMutableArray arrayWithCapacity:0];
    self.messageDataArray = [NSMutableArray arrayWithCapacity:0];
    for (int i =0; i < 30; i++) {
        NSNumber *num = [NSNumber numberWithInt:i];
        [self.systemDataArray addObject:num];
        [self.messageDataArray addObject:num];
    }
    [self createBg];
    [self createTableView];
    [self createNavgation];
    [self createDivision];
    
    [self loadData];
//    [self loadMessageData];
//    [self loadSystemData];
    [self createAlphaBtn];
}
/****************************/
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

#pragma mark -
-(void)loadData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", NOTIFYAPI, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
        }
    }];
    [request release];
}
-(void)loadMessageData
{
    NSString * code = [NSString stringWithFormat:@"is_system=%ddog&cat", 0];
    NSString * sig = [MyMD5 md5:code];
    NSString * url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", NOTIFYAPI, 0, sig, [ControllerManager getSID]];
    NSLog(@"messageAPI:%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            [self.messageDataArray removeAllObjects];
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                SystemMessageListModel * model = [[SystemMessageListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.messageDataArray addObject:model];
                [model release];
            }
            [messageTableView headerEndRefreshing];
            [messageTableView reloadData];
        }else{
            NSLog(@"非系统数据读取失败");
            [messageTableView headerEndRefreshing];
        }
    }];
}
-(void)loadSystemData
{
    NSString * code = [NSString stringWithFormat:@"is_system=%ddog&cat", 1];
    NSString * sig = [MyMD5 md5:code];
    NSString * url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", NOTIFYAPI, 1, sig, [ControllerManager getSID]];
    NSLog(@"systemAPI:%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"systemData:%@", load.dataDict);
            [self.systemDataArray removeAllObjects];
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                SystemMessageListModel * model = [[SystemMessageListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.systemDataArray addObject:model];
                [model release];
            }
            [systemTableView headerEndRefreshing];
            [systemTableView reloadData];
        }else{
            NSLog(@"系统数据读取失败");
            [systemTableView headerEndRefreshing];
        }
    }];
}
-(void)loadMoreMessageData
{
    if (self.messageDataArray.count == 0) {
        [messageTableView footerEndRefreshing];
        return;
    }
    NSString * code = [NSString stringWithFormat:@"is_system=%d&mail_id=%@dog&cat", 0, [self.messageDataArray[self.messageDataArray.count-1] mail_id]];
    NSString * sig = [MyMD5 md5:code];
    NSString * url = [NSString stringWithFormat:@"%@%d&mail_id=%@&sig=%@&SID=%@", NOTIFYAPI, 0, [self.messageDataArray[self.messageDataArray.count-1] mail_id], sig, [ControllerManager getSID]];
    NSLog(@"messageMoreAPI:%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                SystemMessageListModel * model = [[SystemMessageListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.messageDataArray addObject:model];
                [model release];
            }
            [messageTableView footerEndRefreshing];
            [messageTableView reloadData];
        }else{
            NSLog(@"非系统数据读取失败");
        }
    }];
}
-(void)loadMoreSystemData
{
    if (self.systemDataArray.count == 0) {
        [systemTableView footerEndRefreshing];
        return;
    }
    NSString * code = [NSString stringWithFormat:@"is_system=%d&mail_id=%@dog&cat", 1, [self.systemDataArray[self.systemDataArray.count-1] mail_id]];
    NSString * sig = [MyMD5 md5:code];
    NSString * url = [NSString stringWithFormat:@"%@%d&mail_id=%@&sig=%@&SID=%@", NOTIFYAPI, 1, [self.systemDataArray[self.systemDataArray.count-1] mail_id], sig, [ControllerManager getSID]];
    NSLog(@"systemMoreAPI:%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                SystemMessageListModel * model = [[SystemMessageListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.systemDataArray addObject:model];
                [model release];
            }
            [systemTableView footerEndRefreshing];
            [systemTableView reloadData];
        }else{
            NSLog(@"系统数据读取失败");
        }
    }];
}

- (void)createNavgation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
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
//    [self dismissViewControllerAnimated:NO completion:nil];
    button.selected = !button.selected;
    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
    if (button.selected) {
        [menu showMenuAnimated:YES];
        alphaBtn.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            alphaBtn.alpha = 0.5;
        }];
    }else{
        [menu hideMenuAnimated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            alphaBtn.alpha = 0;
        } completion:^(BOOL finished) {
            alphaBtn.hidden = YES;
        }];
    }
}
- (void)searchBtnClick
{
    NSLog(@"搜索");
}

- (void)createDivision
{
    
    UIView *ViewButton = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 35)];
    [self.view addSubview:ViewButton];
    
    UIView * alphaView = [MyControl createViewWithFrame:ViewButton.bounds];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [ViewButton addSubview:alphaView];
    
    messageLabel = [MyControl createLabelWithFrame:CGRectMake(32, 5, 100, 26) Font:15 Text:@"私信"];
    messageLabel.backgroundColor = SelectedColor;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.layer.cornerRadius = 5;
    messageLabel.layer.masksToBounds = YES;
    [ViewButton addSubview:messageLabel];
    
    messageButton = [MyControl createButtonWithFrame:CGRectMake(32, 5, 100, 26) ImageName:nil Target:self Action:@selector(messageClick:) Title:nil];
    
//    messageButton.selected = YES;
    [ViewButton addSubview:messageButton];
    
    systemLabel = [MyControl createLabelWithFrame:CGRectMake(190, 5, 100, 26) Font:15 Text:@"评论"];
    systemLabel.textAlignment = NSTextAlignmentCenter;
    systemLabel.layer.cornerRadius = 5;
    systemLabel.layer.masksToBounds = YES;
    [ViewButton addSubview:systemLabel];
    
    systemButton = [MyControl createButtonWithFrame:CGRectMake(190, 5, 100, 26) ImageName:nil Target:self Action:@selector(systemClick:) Title:nil];
    [ViewButton addSubview:systemButton];
    
//    UIImageView *line = [MyControl createImageViewWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1) ImageName:@"31-2.png"];
//    [self.view addSubview:line];
}

- (void)changeBackgroundColor
{
    UIColor *Temp = messageLabel.backgroundColor;
    messageLabel.backgroundColor = systemLabel.backgroundColor;
    systemLabel.backgroundColor = Temp;
}

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
    messageTableView.tableHeaderView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35+64)] autorelease];
    
    
    systemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:systemTableView];
    systemTableView.hidden = YES;
    systemTableView.delegate = self;
    systemTableView.dataSource = self;
    systemTableView.separatorStyle = 0;
    [systemTableView setBackgroundColor:[UIColor clearColor]];
//    systemTableView.editing = YES;
//    [systemTableView addHeaderWithTarget:self action:@selector(loadSystemData)];
//    [systemTableView addFooterWithTarget:self action:@selector(loadMoreSystemData)];
    systemTableView.tableHeaderView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35+64)] autorelease];
    [systemTableView release];
    
}
#pragma mark - TableView DataSoure and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //此处由self.messageButton改为tableView == messageTableView看是否解决崩溃问题
    if (tableView == messageTableView) {
        return self.messageDataArray.count;
    }else{
        return self.systemDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == messageTableView) {
        static NSString *cellIdentifier = @"cellMessage";
        NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
//        SystemMessageListModel * model = self.messageDataArray[indexPath.row];
//        [cell configUI:model];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
        static NSString *cellIdentifier2 = @"cellSystem";
        SystemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell == nil) {
            cell = [[SystemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
        }
        cell.selectionStyle = 0;
//        SystemMessageListModel * model = self.systemDataArray[indexPath.row];
//        [cell configUI:model];
        cell.backgroundColor = [UIColor clearColor];

        return cell;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //        获取选中删除行索引值
        NSInteger row = [indexPath row];
        if (tableView == messageTableView) {

            //        通过获取的索引值删除数组中的值
            [self.messageDataArray removeObjectAtIndex:row];
        }else{
            [self.systemDataArray removeObjectAtIndex:row];
        }
        
        //        删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
    
}
#pragma mark - Button 点击事件
-  (void)returnClick:(UIButton *)button
{
    button.selected = !button.selected;
    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
    if (button.selected) {
        [menu showMenuAnimated:YES];
    }else{
        [menu hideMenuAnimated:YES];
    }
//    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clearClick
{
//    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"您确定要清除消息么？" Message:nil delegate:self cancelTitle:@"取消" otherTitles:@"确定"];
}
#pragma mark - alert代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [self.systemDataArray removeAllObjects];
//    [systemTableView reloadData];
}

- (void)messageClick:(UIButton *)sender
{
//    if (!sender.selected) {
//        [self changeBackgroundColor];
//        sender.selected = YES;
    systemLabel.backgroundColor = [UIColor clearColor];
    messageLabel.backgroundColor = SelectedColor;
        systemButton.selected = NO;
        messageTableView.hidden = NO;
        systemTableView.hidden = YES;
//    }
    
    [messageTableView reloadData];
}
- (void)systemClick:(UIButton *)sender
{
//    if (!sender.selected) {
//        [self changeBackgroundColor];
//        sender.selected = YES;
    messageLabel.backgroundColor = [UIColor clearColor];
    systemLabel.backgroundColor = SelectedColor;
        messageButton.selected = NO;
        systemTableView.hidden = NO;
        messageTableView.hidden = YES;
//    }
    [systemTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 图片毛玻璃化
-(void)createBg
{
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:self.bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"%@", data);
    UIImage * image = [UIImage imageWithData:data];
    self.bgImageView.image = image;
    //    self.bgImageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    
    //毛玻璃化，需要先设置图片再设置其他
//    [self.bgImageView setFramesCount:20];
//    [self.bgImageView setBlurAmount:1];
    
    //这里必须延时执行，否则会变白
    //注意，由于图片较大，这里需要的时间必须在2秒以上
//    [self performSelector:@selector(blurImage) withObject:nil afterDelay:0.25f];
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:tempView];
}


@end
