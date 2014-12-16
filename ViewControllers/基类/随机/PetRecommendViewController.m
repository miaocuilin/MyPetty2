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
#import "UserPetListModel.h"
#import "Alert_2ButtonView2.h"
@implementation PetRecommendViewController
-(void)viewWillAppear:(BOOL)animated
{
    if (isLoaded) {
//        [self.tv headerBeginRefreshing];
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
    self.myCountryArray = [NSMutableArray arrayWithCapacity:0];
    
//    [self createBg];
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
//    LOADING;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            [self.dataArray removeAllObjects];
            for (NSDictionary * dict in array) {
                PetRecomModel * model = [[PetRecomModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                model.images = [dict objectForKey:@"images"];
                if(!model.images.count){
                    continue;
                }
                [self.dataArray addObject:model];
                [model release];
            }
            [self.tv headerEndRefreshing];
            [self.tv reloadData];
//            ENDLOADING;
        }else{
            [self.tv headerEndRefreshing];
//            [MyControl popAlertWithView:self.view Msg:@""];
        }
    }];
    [request release];
}
-(void)headerRefresh
{
    [self.tv headerBeginRefreshing];
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
    self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-25) style:UITableViewStylePlain];
    self.tv.dataSource = self;
    self.tv.delegate = self;
    self.tv.separatorStyle = 0;
    self.tv.backgroundColor = [UIColor clearColor];
    [self.tv addHeaderWithCallback:^{
        [self loadData];
    }];
    [self.view addSubview:self.tv];
    [self.tv release];
    
//    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
//    self.tv.tableHeaderView = view;
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
    cell.jumpUserClick = ^(){
        UserInfoViewController * vc = [[UserInfoViewController alloc] init];
        vc.usr_id = model.master_id;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    };
    cell.pBtnClick = ^(int a, NSString * aid){
        if (![[USER objectForKey:@"isSuccess"] intValue]) {
            ShowAlertView;
            return;
        }
        
//        AlertView * view = [[AlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        Alert_oneBtnView * oneBtn = [[Alert_oneBtnView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        if (a == 0) {
            NSString * code = [NSString stringWithFormat:@"is_simple=0&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
            NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 0, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
            NSLog(@"%@", url);
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    NSArray * array = [load.dataDict objectForKey:@"data"];
                    if (array.count >= 10) {
                        if((array.count+1)*5>[[USER objectForKey:@"gold"] intValue]){
                            //余额不足
                            [MyControl popAlertWithView:self.view Msg:@"钱包君告急！挣够金币再来捧萌星吧~"];
                            return;
                        }
//                        oneBtn.type = 1;
//                        view.CountryNum = array.count+1;
//                        [oneBtn makeUI];
//                        [oneBtn release];
                        oneBtn.type = 2;
                        oneBtn.petsNum = array.count+1;
                        [oneBtn makeUI];
                    }else{
                        oneBtn.type = 2;
                        oneBtn.petsNum = array.count+1;
                        [oneBtn makeUI];
//                        [self.view addSubview:oneBtn];
//                        [oneBtn release];
//                        view.AlertType = 2;
//                        [view makeUI];
                    }
                    oneBtn.jump = ^(){
//                        [MyControl startLoadingWithStatus:@"加入中..."];
                        LOADING;
                        NSString *joinPetCricleSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",aid]];
                        NSString *joinPetCricleString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",JOINPETCRICLEAPI,aid,joinPetCricleSig,[ControllerManager getSID]];
                        NSLog(@"加入圈子:%@",joinPetCricleString);
                        httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:joinPetCricleString Block:^(BOOL isFinish, httpDownloadBlock *load) {
                            if (isFinish) {
                                NSLog(@"加入成功数据：%@",load.dataDict);
                                if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                                    if (array.count>=10) {
                                        [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"gold"] intValue]-(array.count+1)*5] forKey:@"gold"];
                                    }
                                    
                                    cell.pBtn.selected = YES;
                                }
                                ENDLOADING;
//                                [MyControl loadingSuccessWithContent:@"加入成功" afterDelay:0.5f];
                                //捧Ta成功界面
                                NoCloseAlert * noClose = [[NoCloseAlert alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                                noClose.confirm = ^(){};
//                                MainViewController * main = [ControllerManager shareMain];
                                [[UIApplication sharedApplication].keyWindow addSubview:noClose];
                                NSString * percent = [NSString stringWithFormat:@"%@", [[load.dataDict objectForKey:@"data"] objectForKey:@"percent"]];
                                [noClose configUIWithTx:model.tx Name:model.name Percent:percent];
                                [UIView animateWithDuration:0.3 animations:^{
                                    noClose.alpha = 1;
                                }];
                                
                            }else{
                                LOADFAILED;
//                                [MyControl loadingFailedWithContent:@"加入失败" afterDelay:0.8f];
                                NSLog(@"加入萌星失败");
                            }
                        }];
                        [request release];
                    };
                }
            }];
            [request release];
            //
            
            [[UIApplication sharedApplication].keyWindow addSubview:oneBtn];
            [oneBtn release];
        }else{
            Alert_2ButtonView2 * buttonView2 = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
            buttonView2.type = 4;
            [buttonView2 makeUI];
            buttonView2.quit = ^(){
                NSLog(@"quit");
                [self loadMyCountryInfoData:aid btn:cell.pBtn Row:indexPath.row];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:buttonView2];
            [buttonView2 release];
//            view.AlertType = 5;
//            [view makeUI];
//            view.jump = ^(){
//                [self loadMyCountryInfoData:aid btn:cell.pBtn Row:indexPath.row];
//                cell.pBtn.selected = NO;
//            };
        }
    };
    cell.imageClick = ^(int a){
        NSLog(@"跳转到第%d张图片详情页", a);
        FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
        vc.img_id = [[[self.dataArray[indexPath.row] images] objectAtIndex:a] objectForKey:@"img_id"];
//        MainViewController * main = [ControllerManager shareMain];
        [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
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
-(void)loadMyCountryInfoData:(NSString *)aid btn:(UIButton *)btn Row:(int)row
{
    LOADING;
    //    user/petsApi&usr_id=(若用户为自己则留空不填)
    NSString * code = [NSString stringWithFormat:@"is_simple=0&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 0, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"%@", load.dataDict);
            NSArray * array = [load.dataDict objectForKey:@"data"];
            [self.myCountryArray removeAllObjects];
            for (NSDictionary * dict in array) {
                UserPetListModel * model = [[UserPetListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.myCountryArray addObject:model];
                [model release];
            }
            
            //
            if ([[USER objectForKey:@"usr_id"] isEqualToString:[self.dataArray[row] master_id]]) {
                //                StartLoading;
                //                [MMProgressHUD dismissWithError:@"不能不捧最爱萌星" afterDelay:1];
                ENDLOADING;
                [MyControl popAlertWithView:self.view Msg:@"不能不捧自己创建的萌星"];
                return;
//                PopupView * pop = [[PopupView alloc] init];
//                [pop modifyUIWithSize:self.view.frame.size msg:@"不能不捧自己创建的萌星"];
//                [self.view addSubview:pop];
//                [pop release];
//                
//                [UIView animateWithDuration:0.2 animations:^{
//                    pop.bgView.alpha = 1;
//                } completion:^(BOOL finished) {
//                    [UIView animateKeyframesWithDuration:0.2 delay:2 options:0 animations:^{
//                        pop.bgView.alpha = 0;
//                    } completion:^(BOOL finished) {
//                        [pop removeFromSuperview];
//                    }];
//                }];
                
            }
            if (self.myCountryArray.count == 1) {
                //                StartLoading;
                //                [MyControl loadingFailedWithContent:@"您仅有1个，不能退出" afterDelay:1];
                ENDLOADING;
                [MyControl popAlertWithView:self.view Msg:@"就剩一个啦~不能不捧啊~"];
//                PopupView * pop = [[PopupView alloc] init];
//                [pop modifyUIWithSize:self.view.frame.size msg:@"就剩一个啦~不能不捧啊~"];
//                [self.view addSubview:pop];
//                [pop release];
//                
//                [UIView animateWithDuration:0.2 animations:^{
//                    pop.bgView.alpha = 1;
//                } completion:^(BOOL finished) {
//                    [UIView animateKeyframesWithDuration:0.2 delay:2 options:0 animations:^{
//                        pop.bgView.alpha = 0;
//                    } completion:^(BOOL finished) {
//                        [pop removeFromSuperview];
//                    }];
//                }];
                return;
            }
            
            //            NSLog(@"%@", [USER objectForKey:@"aid"]);
            if ([[USER objectForKey:@"aid"] isEqualToString:[self.dataArray[row] aid]]) {
                NSMutableArray * tempArray = [NSMutableArray arrayWithArray:self.myCountryArray];
                [tempArray removeObjectAtIndex:row];
                //其他中贡献度最高的一个
                NSLog(@"退出的圈子aid：%@", [USER objectForKey:@"aid"]);
//                quitIndex = cellIndexPath.row;
                int Index = 0;
                int Contri = [[tempArray[0] t_contri] intValue];
                for(int i=1;i<tempArray.count;i++){
                    if ([[tempArray[i] t_contri]intValue]>Contri) {
                        Index = i;
                        Contri = [[tempArray[i] t_contri] intValue];
                    }
                }
                NSLog(@"需要切换到默认aid：%@", [tempArray[Index] aid]);
                //                if (Index) {
                [self changeDefaultPetAid:[tempArray[Index] aid] MasterId:[tempArray[Index] master_id] Btn:btn];
                ENDLOADING;
                return;
            }else{
                NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", [self.dataArray[row] aid]];
                NSString * sig = [MyMD5 md5:code];
                NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", EXITFAMILYAPI, [self.dataArray[row] aid], sig, [ControllerManager getSID]];
                NSLog(@"quitApiurl:%@", url);
//                [MyControl startLoadingWithStatus:@"退出中..."];
                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
                        if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                            ENDLOADING;
                            btn.selected = NO;
//                            [MMProgressHUD dismissWithSuccess:@"退出成功" title:nil afterDelay:0.5];
//                            [self.userPetListArray removeObjectAtIndex:cellIndexPath.row];
//                            [tv deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            //                            if (Index) {
                            //                                [self changeDefaultPetAid:[self.userPetListArray[Index] aid] MasterId:[self.userPetListArray[Index] master_id]];
                            //                            }else{
//                            [tv reloadData];
                            //                            }
                            
                        }else{
                            ENDLOADING;
                            [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"退出失败"];
//                            [MMProgressHUD dismissWithSuccess:@"退出失败" title:nil afterDelay:0.7];
                        }
                    }else{
                        ENDLOADING;
                        [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"退出失败"];
//                        [MMProgressHUD dismissWithError:@"退出失败" afterDelay:0.7];
                    }
                }];
                [request release];
            };
//            [self.view addSubview:view];
//            [view release];
//            }
            
            
            
//            if (array.count>1) {
//                NSString *exitPetCricleSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",aid]];
//                NSString *exitPetCricleString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",EXITPETCRICLEAPI,aid,exitPetCricleSig,[ControllerManager getSID]];
//                NSLog(@"退出圈子：%@",exitPetCricleString);
//                [MyControl startLoadingWithStatus:@"退出中..."];
//                httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:exitPetCricleString Block:^(BOOL isFinish, httpDownloadBlock *load) {
//                    if (isFinish) {
//                        //                    NSLog(@"退出成功数据：%@",load.dataDict);
//                        if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
//                            btn.selected = NO;
////                            addBtn.selected = NO;
////                            [alertView hide:YES];
////                            //刷新摇一摇--》捣捣乱
////                            self.label1.text = @"捣捣乱";
////                            [self.btn1 setBackgroundImage:[UIImage imageNamed:@"rock2.png"] forState:UIControlStateNormal];
//                        }
//                        [MyControl loadingSuccessWithContent:@"退出成功" afterDelay:0.5f];
//                    }else{
//                        [MyControl loadingFailedWithContent:@"退出失败" afterDelay:0.5f];
//                        NSLog(@"退出国家失败");
//                    }
//                    
//                }];
//                [request release];
//            }else{
//                //提示不能退
//                [MyControl popAlertWithView:self.view Msg:@"您仅有一只萌主，不能退出"];
////                [MyControl loadingFailedWithContent:@"您仅有一只萌主，不能退出" afterDelay:0.5f];
//            }
            
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
#pragma mark -
-(void)changeDefaultPetAid:(NSString *)aid MasterId:(NSString *)master_id Btn:(UIButton *)btn
{
    
//    [MyControl startLoadingWithStatus:@"切换中..."];
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", aid]];
    NSString * url =[NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", CHANGEDEFAULTPETAPI, aid, sig, [ControllerManager getSID]];
    //    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                NSLog(@"%@", aid);
                
                //退出圈子
                NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", [USER objectForKey:@"aid"]];
                NSString * sig2 = [MyMD5 md5:code];
                NSString * url2 = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", EXITFAMILYAPI, [USER objectForKey:@"aid"], sig2, [ControllerManager getSID]];
                NSLog(@"quitApiurl:%@", url2);
//                [MyControl startLoadingWithStatus:@"退出中..."];
                [USER setObject:aid forKey:@"aid"];
                [USER setObject:master_id forKey:@"master_id"];
                NSLog(@"%@--%@--%@", [USER objectForKey:@"aid"], [USER objectForKey:@"master_id"], [USER objectForKey:@"usr_id"]);
                httpDownloadBlock * request2 = [[httpDownloadBlock alloc] initWithUrlStr:url2 Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
                        if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                            ENDLOADING;
//                            [MMProgressHUD dismissWithSuccess:@"退出成功" title:nil afterDelay:0.5];
                            btn.selected = NO;
//                            [self.userPetListArray removeObjectAtIndex:quitIndex];
                            //                                [tv deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                            //                            if (Index) {
                            //                                [self changeDefaultPetAid:[self.userPetListArray[Index] aid] MasterId:[self.userPetListArray[Index] master_id]];
                            //                            }else{
                            //                                [tv reloadData];
                            
                            //                                [self loadPetInfo];
                            //                            }
                            
                        }else{
                            ENDLOADING;
                            [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"退出失败"];
//                            [MMProgressHUD dismissWithSuccess:@"退出失败" title:nil afterDelay:0.7];
                        }
                    }else{
                        ENDLOADING;
                        [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"退出失败"];
                    }
                }];
                [request2 release];
                
                
            }else{
                LOADFAILED;
//                [MMProgressHUD dismissWithError:@"切换失败" afterDelay:0.8];
            }
            
        }else{
            LOADFAILED;
//            [MMProgressHUD dismissWithError:@"切换失败" afterDelay:0.8];
        }
    }];
    [request release];
}
@end
