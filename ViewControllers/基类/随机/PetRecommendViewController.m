//
//  PetRecommendViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetRecommendViewController.h"
#import "PetRecommendCell.h"
#import "PetRecomModel.h"
#import "PicDetailViewController.h"
#import "PetInfoViewController.h"
#import "UserInfoViewController.h"
@implementation PetRecommendViewController
-(void)viewWillAppear:(BOOL)animated
{
    if (isLoaded) {
        [self.tv headerBeginRefreshing];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    isLoaded = YES;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createBg];
    [self createTableView];
    [self loadData];
}
-(void)loadData
{
    NSString * sig = nil;
    NSString * url = nil;
    if ([[USER objectForKey:@"isSuccess"] intValue]) {
        sig = [NSString stringWithFormat:@"usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
        url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", STARRECOMAPI, [USER objectForKey:@"usr_id"], [MyMD5 md5:sig], [ControllerManager getSID]];
    }else{
        sig = [NSString stringWithFormat:@"usr_id=0dog&cat"];
        url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", STARRECOMAPI, 0, [MyMD5 md5:sig], [ControllerManager getSID]];
    }
    
    NSLog(@"%@", url);
    StartLoading;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            [self.dataArray removeAllObjects];
            for (NSDictionary * dict in array) {
                PetRecomModel * model = [[PetRecomModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                model.images = [dict objectForKey:@"images"];
                [self.dataArray addObject:model];
                [model release];
            }
            [self.tv headerEndRefreshing];
            [self.tv reloadData];
            LoadingSuccess;
        }else{
            LoadingFailed;
        }
    }];
    [request release];
}
-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"blurBg.png"];
    [self.view addSubview:bgImageView];
    
//    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
//    NSLog(@"%@", filePath);
//    NSData * data = [NSData dataWithContentsOfFile:filePath];
//    
//    UIImage * image = [UIImage imageWithData:data];
//    bgImageView.image = image;
//    
//    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
//    [self.view addSubview:tempView];
}
-(void)createTableView
{
    self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.tv.dataSource = self;
    self.tv.delegate = self;
    self.tv.separatorStyle = 0;
    self.tv.backgroundColor = [UIColor clearColor];
    [self.tv addHeaderWithCallback:^{
        [self loadData];
    }];
    [self.view addSubview:self.tv];
    [self.tv release];
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.tv.tableHeaderView = view;
}

#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    PetRecommendCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[PetRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    PetRecomModel * model = self.dataArray[indexPath.row];
    [cell configUI:model];
    cell.jumpPetClick = ^(NSString * aid){
        PetInfoViewController * vc = [[PetInfoViewController alloc] init];
        vc.aid = aid;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    };
    cell.pBtnClick = ^(int a, NSString * aid){
        if (![[USER objectForKey:@"isSuccess"] intValue]) {
            ShowAlertView;
            return;
        }
        
        AlertView * view = [[AlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:view];
        if (a == 0) {
            NSString * code = [NSString stringWithFormat:@"is_simple=0&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
            NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 0, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
            NSLog(@"%@", url);
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    NSArray * array = [load.dataDict objectForKey:@"data"];
                    if (array.count >= 10) {
                        view.AlertType = 3;
                        [view makeUI];
                    }else{
                        view.AlertType = 2;
                        [view makeUI];
                        view.jump = ^(){
                            [MyControl startLoadingWithStatus:@"加入中..."];
                            NSString *joinPetCricleSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",aid]];
                            NSString *joinPetCricleString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",JOINPETCRICLEAPI,aid,joinPetCricleSig,[ControllerManager getSID]];
                            NSLog(@"加入圈子:%@",joinPetCricleString);
                            httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:joinPetCricleString Block:^(BOOL isFinish, httpDownloadBlock *load) {
                                if (isFinish) {
                                    NSLog(@"加入成功数据：%@",load.dataDict);
                                    if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                                        cell.pBtn.selected = YES;
                                    }
                                    [MyControl loadingSuccessWithContent:@"加入成功" afterDelay:0.5f];
                                }else{
                                    [MyControl loadingFailedWithContent:@"加入失败" afterDelay:0.8f];
                                    NSLog(@"加入国家失败");
                                }
                            }];
                            [request release];
                        };
                    }
                }
            }];
            [request release];
            //
            
            [self.view addSubview:view];
            [view release];
        }else{
            view.AlertType = 5;
            [view makeUI];
            view.jump = ^(){
                [self loadMyCountryInfoData:aid btn:cell.pBtn];
//                cell.pBtn.selected = NO;
            };
        }
    };
    cell.imageClick = ^(int a){
        NSLog(@"跳转到第%d张图片详情页", a);
        PicDetailViewController * vc = [[PicDetailViewController alloc] init];
        vc.img_id = [[[self.dataArray[indexPath.row] images] objectAtIndex:a] objectForKey:@"img_id"];
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    };
    cell.clipsToBounds = YES;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = 0;
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.0f;
}
-(void)loadMyCountryInfoData:(NSString *)aid btn:(UIButton *)btn
{
    StartLoading;
    //    user/petsApi&usr_id=(若用户为自己则留空不填)
    NSString * code = [NSString stringWithFormat:@"is_simple=0&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 0, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            //            NSLog(@"%@", load.dataDict);
            //            [self.userPetListArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            if (array.count>1) {
                NSString *exitPetCricleSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",aid]];
                NSString *exitPetCricleString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",EXITPETCRICLEAPI,aid,exitPetCricleSig,[ControllerManager getSID]];
                NSLog(@"退出圈子：%@",exitPetCricleString);
                [MyControl startLoadingWithStatus:@"退出中..."];
                httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:exitPetCricleString Block:^(BOOL isFinish, httpDownloadBlock *load) {
                    if (isFinish) {
                        //                    NSLog(@"退出成功数据：%@",load.dataDict);
                        if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                            btn.selected = NO;
//                            addBtn.selected = NO;
//                            [alertView hide:YES];
//                            //刷新摇一摇--》捣捣乱
//                            self.label1.text = @"捣捣乱";
//                            [self.btn1 setBackgroundImage:[UIImage imageNamed:@"rock2.png"] forState:UIControlStateNormal];
                        }
                        [MyControl loadingSuccessWithContent:@"退出成功" afterDelay:0.5f];
                    }else{
                        [MyControl loadingFailedWithContent:@"退出失败" afterDelay:0.5f];
                        NSLog(@"退出国家失败");
                    }
                    
                }];
                [request release];
            }else{
                //提示不能退
                [MyControl loadingFailedWithContent:@"您仅有一只萌主，不能退出" afterDelay:0.5f];
            }
            
        }else{
            LoadingFailed;
        }
    }];
    [request release];
}
@end
