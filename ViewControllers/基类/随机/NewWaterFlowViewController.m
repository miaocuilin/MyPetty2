//
//  NewWaterFlowViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/10/24.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "NewWaterFlowViewController.h"
#import "PhotoModel.h"

@implementation NewWaterFlowViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createFakeNavigation];
    [self createTableView];
    [self loadData];
}

#pragma mark -
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    self.menuBtn = [MyControl createButtonWithFrame:CGRectMake(17, 30, 82/2, 54/2) ImageName:@"menu.png" Target:self Action:@selector(menuBtnClick:) Title:nil];
    self.menuBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:self.menuBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 32, 200, 20) Font:17 Text:@"宠物星球"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    camara = [MyControl createButtonWithFrame:CGRectMake(320-82/2-15, 64-54/2-7, 82/2, 54/2) ImageName:@"相机图标.png" Target:self Action:@selector(camaraClick) Title:nil];
    camara.showsTouchWhenHighlighted = YES;
    [navView addSubview:camara];
}
-(void)menuBtnClick:(UIButton *)btn{}
-(void)camaraClick{}

#pragma mark -
-(void)createTableView
{
    bgTv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
//    tv.delegate = self;
//    tv.dataSource = self;
    bgTv.separatorStyle = 0;
    [self.view addSubview:bgTv];
    [bgTv release];
    [bgTv addHeaderWithTarget:self action:@selector(loadData)];
    [bgTv addFooterWithTarget:self action:@selector(loadNextData)];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = 0;
    [bgTv addSubview:tv];
    [tv release];
    
    tv2 = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tv2.delegate = self;
    tv2.dataSource = self;
    tv2.separatorStyle = 0;
    [bgTv addSubview:tv2];
    [tv2 release];
}
#pragma mark - 数据加载
-(void)loadData
{
    StartLoading;
    
    NSString * url = [NSString stringWithFormat:@"%@%@", RANDOMAPI, [ControllerManager getSID]];
    
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"萌宠推荐数据:%@", load.dataDict);
            [self.dataArray removeAllObjects];
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                
                NSString * path = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
                UIImage * image = [UIImage imageWithContentsOfFile:path];
                if (image) {
                    //比例调整 w=20 h=15    W=15  H=(W/w)*h
                    model.width = self.view.frame.size.width/2-4;
                    model.height = (model.width/image.size.width)*image.size.height;
                }else{
                    model.width = self.view.frame.size.width/2-4;
                    model.height = 100;
                }
                
                
                
                [model release];
            }
            
            self.lastImg_id = [self.dataArray[self.dataArray.count-1] img_id];
            
            LoadingSuccess;
        }else{
            LoadingFailed;
//            [qtmquitView headerEndRefreshing];
            NSLog(@"数据加载失败");
        }
        [bgTv headerEndRefreshing];
    }];
    [request release];
}

-(void)loadNextData
{
    if (self.dataArray.count % 10 != 0) {
//        [qtmquitView footerEndRefreshing];
        return;
    }
    NSString * str = [NSString stringWithFormat:@"img_id=%@dog&cat", self.lastImg_id];
    NSString * sig = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", RECOMMENDAPI2, self.lastImg_id, sig, [ControllerManager getSID]];
    //    NSLog(@"next-url:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary: dict];
                [self.dataArray addObject:model];
                
                NSString * path = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
                UIImage * image = [UIImage imageWithContentsOfFile:path];
                
                model.width = image.size.width;
                model.height = image.size.height;
                
                [model release];
            }
            self.lastImg_id = [self.dataArray[self.dataArray.count-1] img_id];
//            [qtmquitView reloadData];
//            [qtmquitView footerEndRefreshing];
        }else{
            NSLog(@"数据加载失败");
        }
        [bgTv footerEndRefreshing];
    }];
    [request release];
}


#pragma mark - 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    
    cell.selectionStyle = NO;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataArray[indexPath.row] height];
}
@end
