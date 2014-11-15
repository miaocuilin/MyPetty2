//
//  ActivityViewController.m
//  MyPetty
//
//  Created by apple on 14/6/25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActiveCell.h"
#import "ActivityDetailViewController.h"
#import "TopicListModel.h"

@interface ActivityViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
}
//@property (nonatomic,strong)UITableView *tableView;
//@property (nonatomic,strong)ActivityCell *tableViewCell;
@end

@implementation ActivityViewController

//- (void)dealloc
//{
//    _tableView = nil;
//    _tableViewCell = nil;
//    [super dealloc];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createBg];
    [self createFakeNavigation];
//    [self createTableView];
    [self loadData];
}
#pragma mark - 视图的创建
-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = DOCDIR;
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"%@", data);
    UIImage * image = [UIImage imageWithData:data];
    bgImageView.image = image;
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:tempView];
}
-(void)createFakeNavigation
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
    //    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"活动"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:titleLabel];
}
//
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
#pragma mark -下载新消息并显示历史记录和最新消息
-(void)loadData
{
    NSLog(@"%@%@",TOPICLISTAPI,[ControllerManager getSID]);
    [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", TOPICLISTAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"topicList:%@", load.dataDict);
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                TopicListModel * model = [[TopicListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                [model release];
            }
//            self loadPhoto
            [self createTableView];
        }else{
            StartLoading;
            LoadingFailed;
//            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"活动数据请求失败"];
        }
    }];
}
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView release];
    
    UIView * headerView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    _tableView.tableHeaderView = headerView;
    
    [self.view bringSubviewToFront:navView];
    
    /************************/
    [self createAlphaBtn];
}

#pragma mark - 表视图datasource和delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idetifierCell = @"cell";
    ActiveCell * _tableViewCell = [tableView dequeueReusableCellWithIdentifier:idetifierCell];
    if (_tableViewCell == nil) {
        _tableViewCell = [[[ActiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifierCell]autorelease];
    }
    _tableViewCell.backgroundColor = [UIColor clearColor];
    _tableViewCell.selectionStyle = 0;
    TopicListModel * model = self.dataArray[indexPath.row];
    [_tableViewCell configUI:model];
    return _tableViewCell;
    
}
//设置cellHeight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到活动详情页
    ActivityDetailViewController * vc = [[ActivityDetailViewController alloc] init];
    vc.listModel = self.dataArray[indexPath.row];
    
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}


#pragma mark - 点击事件
- (void)backBtnClick:(UIButton *)button
{
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
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//- (void)createNavgation
//{
////    self.navigationController.navigationBar.alpha = 0.85;
//    if (iOS7) {
//        self.navigationController.navigationBar.barTintColor = BGCOLOR;
//    }else{
//        self.navigationController.navigationBar.tintColor = BGCOLOR;
//    }
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationItem.title = @"活动";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    UIButton * button1 = [MyControl createButtonWithFrame:CGRectMake(0, 0, 56/2, 56/2) ImageName:@"7-7.png" Target:self Action:@selector(returnClick:) Title:nil];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
//
//    self.navigationItem.leftBarButtonItem = leftItem;
//    [leftItem release];
//}

@end
