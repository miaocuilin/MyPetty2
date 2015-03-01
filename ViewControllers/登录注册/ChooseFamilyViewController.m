//
//  ChooseFamilyViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ChooseFamilyViewController.h"
#define GREEN [UIColor colorWithRed:147/255.0 green:203/255.0 blue:172/255.0 alpha:1]
#import "AttentionCell.h"
#import "SearchFamilyViewController.h"
#import "ChooseFamilyDetailCell.h"
#import "RegisterViewController.h"
#import "PetInfoModel.h"
@interface ChooseFamilyViewController ()

@end

@implementation ChooseFamilyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[USER objectForKey:@"isChooseFamilyShouldDismiss"]intValue]) {
        [USER setObject:@"0" forKey:@"isChooseFamilyShouldDismiss"];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.from intValue] != 1 && [self.from intValue] != 2) {
        self.from = @"1";
    }
    didSelected = -1;
//    self.dataArray = [NSMutableArray arrayWithCapacity:0];
//    self.dataArray2 = [NSMutableArray arrayWithCapacity:0];
    self.limitDataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.catArray = [NSMutableArray arrayWithCapacity:0];
    self.dogArray = [NSMutableArray arrayWithCapacity:0];
    self.otherArray = [NSMutableArray arrayWithCapacity:0];
    self.totalArray = [NSMutableArray arrayWithCapacity:0];
    self.detailDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    self.systemListArray = [NSMutableArray arrayWithObjects:@"推荐", @"人气", nil];
    self.totalArray = [NSMutableArray arrayWithObjects:@"所有", @"喵喵", @"汪汪", @"其他", nil];
    self.limitTypeName = @"所有";
//    [UIApplication sharedApplication].statusBarHidden = NO;
    
    
    [self loadRecommandListData];
    [self createBg];
//    [self createTableView];
    [self createFakeNavigation];
    [self createHeader];
//    [self getListData];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidden) name:@"af" object:nil];
    [USER setObject:@"1" forKey:@"isAdopt"];
}
-(void)loadRecommandListData
{
    LOADING;
    NSString * url = [NSString stringWithFormat:@"%@%@", RECOMMANDCOUNTRYLISTAPI, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            [self.limitDataArray removeAllObjects];
            //        NSLog(@"%@", load.dataDict);
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PetInfoModel * model = [[PetInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.limitDataArray addObject:model];
                [model release];
            }
//            self.lastAid = [self.limitDataArray[self.limitDataArray.count-1] aid];
            pageNum = 1;
            
            if ([[USER objectForKey:@"isSuccess"] intValue]) {
                [self loadUserPetsList];
            }else{
                [self createTableView];
                ENDLOADING;
            }
            
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)loadUserPetsList
{
    NSString * code = [NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"UserPetsList:%@", load.dataDict);
            self.userPetsListArray = [load.dataDict objectForKey:@"data"];
            [self removeUserPets];
            
            if (isTvCreated) {
                [tv reloadData];
            }else{
                [self createTableView];
            }
            
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)createBg
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
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
//
//    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
//    [self.view addSubview:tempView];
}

//-(void)getListData
//{
//    NSDictionary * oriDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CateNameList" ofType:@"plist"]];
//    //将数据存到数组中
//    NSDictionary * dict1 = [oriDict objectForKey:@"1"];
//    NSDictionary * dict2 = [oriDict objectForKey:@"2"];
////    NSDictionary * dict3 = [oriDict objectForKey:@"3"];
//    
//    [self.totalArray addObject:@"所有种族"];
//    
//    if (self.isMi) {
//        for (int i=0; i<[dict1 count]; i++) {
//            NSString * str = [dict1 objectForKey:[NSString stringWithFormat:@"%d", 100+i+1]];
//            [self.catArray addObject:str];
//            [self.totalArray addObject:str];
//        }
//    }else{
//        for (int i=0; i<[dict2 count]; i++) {
//            NSString * str = [dict2 objectForKey:[NSString stringWithFormat:@"%d", 200+i+1]];
//            [self.dogArray addObject:str];
//            [self.totalArray addObject:str];
//        }
//    }
//    
////    for (int i=0; i<[dict3 count]; i++) {
////        NSString * str = [dict3 objectForKey:[NSString stringWithFormat:@"%d", 300+i+1]];
////        [self.otherArray addObject:str];
////        [self.totalArray addObject:str];
////    }
//}
//-(void)hidden
//{
//    [afView hide];
//}
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
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 22, 60, 40) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
//    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"选择萌星"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIImageView * searchImageView = [MyControl createImageViewWithFrame:CGRectMake(320-31, 33, 18, 16) ImageName:@"5-5.png"];
    [navView addSubview:searchImageView];

    UIButton * searchBtn = [MyControl createButtonWithFrame:CGRectMake(320-41-5, 25, 35, 30) ImageName:@"" Target:self Action:@selector(searchBtnClick) Title:nil];
//    searchBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    searchBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:searchBtn];
    
    UIView * line0 = [MyControl createViewWithFrame:CGRectMake(0, 63, 320, 1)];
    line0.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.1];
    [navView addSubview:line0];
    
//    self.navigationController.navigationBar.translucent = NO;
//    if (1) {
//        self.title = @"选择王国";
//    }else{
//        self.title = @"选择家族";
//    }
//    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 56/2, 56/2) ImageName:@"7-7.png" Target:self Action:@selector(backBtnClick) Title:nil];
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = leftItem;
//    [leftItem release];
//    
//    if (iOS7) {
//        self.navigationController.navigationBar.barTintColor = BGCOLOR;
//    }
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
-(void)createHeader
{
    /*
     【注】这里如果headerView只设置35高，新创建的tableView会超出范围，tableView
     会不受控制，所以当出现二级菜单时要把透明层headerView拉长到200+35高，二级菜单
     消失后再设置回来。
    */
    headerView = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 35)];
    [self.view addSubview:headerView];
    
    UIView * headerBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 35)];
    headerBgView.backgroundColor = ORANGE;
    headerBgView.alpha = 0.2;
    [headerView addSubview:headerBgView];
    
    raceBtn = [MyControl createButtonWithFrame:CGRectMake(30, 5, 120, 25) ImageName:@"" Target:self Action:@selector(raceBtnClick) Title:@"所有"];
    raceBtn.layer.cornerRadius = 5;
    raceBtn.layer.masksToBounds = YES;
    raceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    raceBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:168/255.0 blue:146/255.0 alpha:0.6];
    [headerView addSubview:raceBtn];
    //小三角
    UIImageView * triangle1 = [MyControl createImageViewWithFrame:CGRectMake(117-8, 9, 10, 8) ImageName:@"5-2.png"];
    [raceBtn addSubview:triangle1];
    
    systemBtn = [MyControl createButtonWithFrame:CGRectMake(180, 5, 110, 25) ImageName:@"" Target:self Action:@selector(systemBtnClick) Title:@"推荐"];
    systemBtn.layer.cornerRadius = 5;
    systemBtn.layer.masksToBounds = YES;
    systemBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    systemBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:168/255.0 blue:146/255.0 alpha:0.6];
    [headerView addSubview:systemBtn];
    
    //小三角
    UIImageView * triangle2 = [MyControl createImageViewWithFrame:CGRectMake(97, 9, 10, 8) ImageName:@"5-2.png"];
    [systemBtn addSubview:triangle2];

    

}
-(void)loadMoreData
{
    NSLog(@"loadMore");
    if (!isRQ) {
        [self loadMoreRecommandDataWithType:self.from];
    }else{
        [self loadMoreTopicDataType:self.from];
    }

}
-(void)createTableView
{
    isTvCreated = YES;
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+35, 320, self.view.frame.size.height-64-35) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.backgroundColor = [UIColor clearColor];
    tv.separatorStyle = 0;
    [self.view addSubview:tv];
    
    [tv addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [self.view bringSubviewToFront:navView];
    [self.view bringSubviewToFront:headerView];
    
//    UIView * tempView1 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64+35)];
//    tv.tableHeaderView = tempView1;
    
    insertView = [[MyControl createViewWithFrame:CGRectMake(0, 0, 320, 100)] retain];
    insertView.backgroundColor = [UIColor colorWithRed:243/255.0 green:198/255.0 blue:164/255.0 alpha:1];
    UIImageView * downArrow = [MyControl createImageViewWithFrame:CGRectMake((320-17)/2, 0, 17, 14) ImageName:@"5-3.png"];
    [insertView addSubview:downArrow];
    
}
#pragma mark - 剔除用户的宠物
-(void)removeUserPets
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        return;
    };
    //self.limitDataArray
    for (int i=0; i<self.limitDataArray.count; i++) {
        for (int j=0; j<self.userPetsListArray.count; j++) {
            if ([[self.limitDataArray[i] aid] isEqualToString:[self.userPetsListArray[j] objectForKey:@"aid"]]) {
                [self.limitDataArray removeObjectAtIndex:i];
                i--;
                break;
            }
        }
    }
}

#pragma mark - tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == didSelected) {
        return 1;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.limitDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    ChooseFamilyDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[ChooseFamilyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        UIButton * headBtn = [MyControl createButtonWithFrame:CGRectMake(410/2, 20, 55, 55) ImageName:@"" Target:self Action:@selector(headBtnClick) Title:nil];
        headBtn.layer.cornerRadius = 55/2;
        headBtn.layer.masksToBounds = YES;
        [cell addSubview:headBtn];
    }
    cell.selectionStyle = 0;
    cell.backgroundColor = [ControllerManager colorWithHexString:@"f4c6a2"];
    /**************/
//    NSLog(@"--%@", self.cardDict);
    [cell configUI:self.cardDict];
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PetInfoModel * model = self.limitDataArray[section];
    UIView * headerBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 70)];
//    headerBgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * headImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 10, 50, 50) ImageName:@"defaultPetHead.png"];
    headImageView.layer.cornerRadius = headImageView.frame.size.width/2;
    headImageView.layer.masksToBounds = YES;
    [headerBgView addSubview:headImageView];
    /**************************/
//    NSLog(@"--%@", model.tx);
    if (!([model.tx isKindOfClass:[NSNull class]] || [model.tx length]==0)) {
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
        //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
        if (image) {
            headImageView.image = [MyControl image:image fitInSize:CGSizeMake(100, 100)];
        }else{
            //下载头像
            NSLog(@"%@", [NSString stringWithFormat:@"%@%@", PETTXURL, model.tx]);
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, model.tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    headImageView.image = [MyControl image:load.dataImage fitInSize:CGSizeMake(100, 100)];
                    NSString * docDir = DOCDIR;
                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
                    [load.data writeToFile:txFilePath atomically:YES];
                }else{
                    NSLog(@"头像下载失败");
                }
            }];
            [request release];
        }
    }
    
    /**************************/
    
    
    UIImageView * sex = [MyControl createImageViewWithFrame:CGRectMake(80, 10, 34/2, 34/2) ImageName:@"man.png"];
    if ([model.gender intValue] == 2) {
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    [headerBgView addSubview:sex];
    
    UILabel * name = [MyControl createLabelWithFrame:CGRectMake(100, 10, 150, 20) Font:15 Text:@""];
    name.textColor = BGCOLOR;
    name.text = model.name;
    [headerBgView addSubview:name];
    
    UILabel * nameAndAgeLabel = [MyControl createLabelWithFrame:CGRectMake(80, 30, 175, 15) Font:13 Text:@"索马利猫 | 3岁"];
    nameAndAgeLabel.textColor = [UIColor blackColor];
    nameAndAgeLabel.text = [NSString stringWithFormat:@"%@ | %@", [ControllerManager returnCateNameWithType:model.type], [MyControl returnAgeStringWithCountOfMonth:model.age]];
    [headerBgView addSubview:nameAndAgeLabel];
    
    UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(80, 52, 90, 15) Font:12 Text:@"总人气 500"];
    rq.text = [NSString stringWithFormat:@"总人气 %@", model.t_rq];
    rq.textColor = [UIColor lightGrayColor];
    [headerBgView addSubview:rq];
    
    UILabel * memberNum = [MyControl createLabelWithFrame:CGRectMake(165, 52, 70, 15) Font:12 Text:@"|    成员 188"];
    memberNum.text = [NSString stringWithFormat:@"|    成员 %@", model.fans];
    memberNum.textColor = [UIColor lightGrayColor];
    [headerBgView addSubview:memberNum];
    
    UIButton * showOrHideBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, 65) ImageName:@"" Target:self Action:@selector(showOrHideBtnClick:) Title:nil];
    showOrHideBtn.tag = 100+section;
    [headerBgView addSubview:showOrHideBtn];
    
    UIButton * join = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-73-10, (70-36)/2, 73, 36) ImageName:@"recom_p.png" Target:self Action:@selector(joinClick:) Title:nil];
//    join.titleLabel.font = [UIFont systemFontOfSize:14];
//    join.backgroundColor = GREEN;
//    join.layer.cornerRadius = 5;
//    join.layer.masksToBounds = YES;
    [headerBgView addSubview:join];
    join.tag = 200+section;

    UIView * whiteLine = [MyControl createViewWithFrame:CGRectMake(0, 69, 320, 1)];
    whiteLine.backgroundColor = [UIColor whiteColor];
    [headerBgView addSubview:whiteLine];
    return headerBgView;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125.0f;
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tv beginUpdates];
//    NSIndexPath * indexPath2 = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
//    [tv insertRowsAtIndexPaths:@[indexPath2] withRowAnimation:UITableViewRowAnimationMiddle];
//    [tv endUpdates];
}


-(void)showOrHideBtnClick:(UIButton *)button
{
    NSLog(@"%d", button.tag);
    if (didSelected == button.tag-100) {
        didSelected = -1;
        [tv reloadData];
    }else{
        didSelected = button.tag-100;
        //此处友盟有崩溃2015.01.26 暂未测出具体问题
        [self loadCardDataWithTag:didSelected];
    }
    
//    [tv scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}
-(void)loadCardDataWithTag:(int)Tag
{
    NSDictionary * dic = [self.detailDict objectForKey:[self.limitDataArray[didSelected] aid]];
    if (dic) {
        self.cardDict = dic;
        [tv reloadData];
    }else{
        NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", [self.limitDataArray[didSelected] aid]];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETCARDAPI, [self.limitDataArray[didSelected] aid], [MyMD5 md5:code], [ControllerManager getSID]];
        NSLog(@"%@", url);
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"%@", load.dataDict);
                [self.detailDict setObject:[load.dataDict objectForKey:@"data"] forKey:[self.limitDataArray[didSelected] aid]];
                //
                self.cardDict = [load.dataDict objectForKey:@"data"];
                [tv reloadData];
            }
        }];
        [request release];
    }
}
-(void)joinClick:(UIButton *)button
{
    NSLog(@"join-%d", button.tag-200);
    
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    
    if ([ControllerManager getIsSuccess]) {
        
        //给出加入提示
        Alert_oneBtnView * view = [[Alert_oneBtnView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        int a = [[USER objectForKey:@"countryNum"] intValue];
//        if(a>=10){
//            view.type = 2;
//            view.petsNum = a+1;
//        }else{
//            view.AlertType = 2;
//        }
        if(a >= 10){
            int cost = a*5;
            if (cost>100) {
                cost = 100;
            }
            if(cost>[[USER objectForKey:@"gold"] intValue]){
                //余额不足
                if([[USER objectForKey:@"confVersion"] isEqualToString:[USER objectForKey:@"versionKey"]]){
                    //审核
                    [MyControl popAlertWithView:self.view Msg:@"钱包君告急！挣够金币再来捧萌星吧~"];
                }else{
                    [ControllerManager addAlertWith:self Cost:cost SubType:1];
                }
                
                return;
            }
            view.type = 2;
            view.petsNum = a;
            [view makeUI];
            [self.view addSubview:view];
            [view release];
        }else{
            view.type = 2;
            view.petsNum = a;
            [view makeUI];
            [self.view addSubview:view];
            [view release];
        }
//        [view makeUI];
//        [self.view addSubview:view];
//        [view release];
        view.jump = ^(){
//            [MMProgressHUD showWithStatus:@"加入中..."];
            LOADING;
            
            PetInfoModel * model = self.limitDataArray[button.tag-200];
            NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", model.aid];
            NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", JOINFAMILYAPI, model.aid, [MyMD5 md5:code], [ControllerManager getSID]];
            NSLog(@"%@", url);
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    NSLog(@"--%@", load.dataDict);
                    ENDLOADING;
                    if (a>=10) {
                        NSLog(@"%@", [USER objectForKey:@"gold"]);
                        int cost = a*5;
                        if (cost>100) {
                            [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"gold"] intValue]-100] forKey:@"gold"];
                        }else{
                            [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"gold"] intValue]-cost] forKey:@"gold"];
                        }
                        
                        NSLog(@"%@", [USER objectForKey:@"gold"]);
                        [USER setObject:@"countryNum" forKey:[NSString stringWithFormat:@"%d", a+1]];
                    }
//                    [MMProgressHUD dismissWithSuccess:@"加入成功^_^" title:nil afterDelay:0.5];
                    //刷新列表
                    //[self loadUserPetsList];
                    LOADPETLIST;
                    
                    //捧Ta成功界面
                    NoCloseAlert * noClose = [[NoCloseAlert alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                    noClose.confirm = ^(){
                        [USER setObject:@"1" forKey:@"isChooseInShouldDismiss"];
                        [self dismissViewControllerAnimated:NO completion:nil];
                    };
                    [self.view addSubview:noClose];
                    NSString * percent = [NSString stringWithFormat:@"%@", [[load.dataDict objectForKey:@"data"] objectForKey:@"percent"]];
                    [noClose configUIWithTx:model.tx Name:model.name Percent:percent];
                    [UIView animateWithDuration:0.3 animations:^{
                        noClose.alpha = 1;
                    }];
                }else{
                    LOADFAILED;
//                    [MMProgressHUD dismissWithError:@"加入失败-_-!" afterDelay:0.5];
                }
            }];
            [request release];
            
        };
        
    }else{
        RegisterViewController * vc = [[RegisterViewController alloc] init];
        vc.isAdoption = YES;
        vc.petInfoModel = self.limitDataArray[button.tag-200];
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }
    
}
-(void)headBtnClick
{
    NSLog(@"click row:%d", didSelected);
}


-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)raceBtnClick
{
    NSLog(@"race");

    if (dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc] showDropDown:raceBtn :&f :self.totalArray];
//        NSLog(@"%@", self.totalArray);
        [dropDown setDefaultCellType];
        dropDown.delegate = self;
        headerView.frame = CGRectMake(0, 64, 320, 35+200);
        isRaceShow = YES;
        if (isSystemShow) {
            isSystemShow = NO;
            [dropDown2 hideDropDown:systemBtn];
            [self rel2];
        }
        //
//        [self.limitDataArray removeAllObjects];
//        [self.limitDataArray addObjectsFromArray:self.dataArray];
    }else{
        [dropDown hideDropDown:raceBtn];
        isRaceShow = NO;
        [self rel];
    }

}
-(void)systemBtnClick
{
    NSLog(@"system");
    if (dropDown2 == nil) {
        CGFloat f = 160;
        dropDown2 = [[NIDropDown alloc] showDropDown:systemBtn :&f :self.systemListArray];
        [dropDown2 setDefaultCellType];
        dropDown2.delegate = self;
        if (!isRaceShow) {
            headerView.frame = CGRectMake(0, 64, 320, 35+160);
        }
        isSystemShow = YES;
        if (isRaceShow) {
            [dropDown hideDropDown:raceBtn];
            isRaceShow = NO;
            [self rel];
        }
//        [dropDown2 release];
    }else{
        isSystemShow = NO;
        [dropDown2 hideDropDown:systemBtn];
        [self rel2];
    }
}

#pragma mark - niDrop代理
-(void)niDropDownDelegateMethod:(NIDropDown *)sender
{
    if (sender == dropDown) {
        isRaceShow = NO;
        [self rel];
    }else{
        isSystemShow = NO;
        [self rel2];
    }
    
}
-(void)didSelected:(NIDropDown *)sender Line:(int)Line Words:(NSString *)Words
{
    NSLog(@"%d--%@", Line, Words);
    if (sender == dropDown) {
        self.limitTypeName = Words;
        self.from = [NSString stringWithFormat:@"%d", Line];
//        if (Line == 0) {
////            self.type = @"0";
//            self.from = [NSString stringWithFormat:@"%d", Line+1];
//        }else{
//            for (int i=1; i<self.totalArray.count; i++) {
//                if (Line == i) {
//                    self.type = [ControllerManager returnCateTypeWithName:self.totalArray[i]];
//                    break;
//                }
//            }
//        }
        
        
//        if ([Words isEqualToString:@"所有种族"]) {
//            if (!isRQ) {
//                [self reloadRecommandData];
//            }else{
//                [self reloadTopicData];
//            }
//            [self.limitDataArray removeAllObjects];
//            [self.limitDataArray addObjectsFromArray:self.dataArray];
//        }else{
            if (!isRQ) {
                [self loadRecommandDataWithType:self.from];
            }else{
                [self loadTopicDataWithType:self.from];
            }
//            NSLog(@"--%d", self.limitDataArray.count);
            //在下拉列表初始化时limitDataArray数组就已经重置了
            
            
            
//            for (int i=0; i<self.limitDataArray.count; i++) {
//                PetInfoModel * model = self.limitDataArray[i];
//                if (![[ControllerManager returnCateNameWithType:model.type] isEqualToString:self.limitTypeName]) {
//                    [self.limitDataArray removeObjectAtIndex:i];
//                    i--;
//                }
//            }
//        }
        
//        [tv reloadData];
    }else if(sender == dropDown2){
        NSLog(@"22222222");
        if (Line == 0) {
            //推荐
            isRQ = NO;
        }else{
            //人气
            isRQ = YES;
        }
        //请求相应的API
//        if ([self.limitTypeName isEqualToString:@"所有种族"]) {
//            //请求相应api1
//            if (isRQ) {
//                [self reloadTopicData];
//            }else{
//                [self reloadRecommandData];
//            }
//        }else{
            //请求相应api2
            if (isRQ) {
                [self loadTopicDataWithType:self.from];
            }else{
                [self loadRecommandDataWithType:self.from];
            }
//        }
    }
}
-(void)rel
{
    if (isSystemShow) {
        headerView.frame = CGRectMake(0, 64, 320, 35+120);
    }else{
        headerView.frame = CGRectMake(0, 64, 320, 35);
    }
    [dropDown release];
    dropDown = nil;
}
-(void)rel2
{
    if (isRaceShow) {
        headerView.frame = CGRectMake(0, 64, 320, 35+200);
    }else{
        headerView.frame = CGRectMake(0, 64, 320, 35);
    }
    [dropDown2 release];
    dropDown2 = nil;
}

-(void)searchBtnClick
{
    NSLog(@"search");
    [USER setObject:@"0" forKey:@"isSearchFamilyShouldDismiss"];
    SearchFamilyViewController * vc = [[SearchFamilyViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
    [vc release];
//    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
//    afView = [AFPopupView popupWithView:vc.view];
//    [afView show];
}

#pragma mark - reload

//下拉刷新的时候调用
-(void)reloadRecommandData
{
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"from=%@dog&cat", self.from]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", RECOMMANDCOUNTRYLISTAPI2, self.from, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            [self.dataArray removeAllObjects];
            [self.limitDataArray removeAllObjects];
            //        NSLog(@"%@", load.dataDict);
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PetInfoModel * model = [[PetInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.limitDataArray addObject:model];
                [model release];
            }
//            [self.limitDataArray addObjectsFromArray:self.dataArray];
//            self.lastAid = [self.limitDataArray[self.limitDataArray.count-1] aid];
            [self removeUserPets];
            pageNum = 1;
            [tv reloadData];
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)reloadTopicData
{
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"from=%@dog&cat", self.from]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", TOPICCOUNTRYLISTAPI, self.from, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            [self.dataArray2 removeAllObjects];
            [self.limitDataArray removeAllObjects];
            //        NSLog(@"%@", load.dataDict);
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PetInfoModel * model = [[PetInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.limitDataArray addObject:model];
                [model release];
            }
//            [self.limitDataArray addObjectsFromArray:self.dataArray2];
//            self.lastAid = [self.limitDataArray[self.limitDataArray.count-1] aid];
            [self removeUserPets];
            [tv reloadData];
            pageNum = 1;
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}

//当点击推荐还是人气的时候调用
-(void)loadRecommandDataWithType:(NSString *)type
{
//    if ([self.limitTypeName isEqualToString:@"所有种族"]) {
//        [self reloadRecommandData];
//    }else{
        LOADING;
        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"from=%@dog&cat", type]];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", RECOMMANDCOUNTRYLISTAPI2, type, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"%@", load.dataDict);
                [self.limitDataArray removeAllObjects];
                //        NSLog(@"%@", load.dataDict);
                
                NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                
                for (NSDictionary * dict in array) {
                    PetInfoModel * model = [[PetInfoModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.limitDataArray addObject:model];
                    [model release];
                }
                pageNum = 1;
//                if (array.count) {
//                    self.lastAid = [self.limitDataArray[self.limitDataArray.count-1] aid];
//                }else{
//                    self.lastAid = @"";
//                }
                [self removeUserPets];
                ENDLOADING;
                [tv reloadData];
            }else{
                LOADFAILED;
            }
        }];
        [request release];
//    }
}
-(void)loadTopicDataWithType:(NSString *)type
{
//    if ([self.limitTypeName isEqualToString:@"所有种族"]) {
//        [self reloadTopicData];
//    }else{
        LOADING;
        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"from=%@dog&cat", type]];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", TOPICCOUNTRYLISTAPI2, type, sig, [ControllerManager getSID]];
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"%@", load.dataDict);
                [self.limitDataArray removeAllObjects];
                //        NSLog(@"%@", load.dataDict);
                NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                for (NSDictionary * dict in array) {
                    PetInfoModel * model = [[PetInfoModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.limitDataArray addObject:model];
                    [model release];
                }
                //排除该种类为空的情况
                pageNum = 1;
//                if (array.count) {
//                    self.lastAid = [self.limitDataArray[self.limitDataArray.count-1] aid];
//                }else{
//                    self.lastAid = @"";
//                }
                [self removeUserPets];
                [tv reloadData];
                ENDLOADING;
            }else{
                LOADFAILED;
            }
        }];
        [request release];
//    }
}

//上拉加载的时候调用
-(void)loadMoreRecommandDataWithType:(NSString *)type
{
    NSLog(@"---%d", pageNum);
    NSString * sig = nil;
    NSString * url = nil;
//    if ([self.limitTypeName isEqualToString:@"所有种族"]) {
//        sig = [MyMD5 md5:[NSString stringWithFormat:@"page=%ddog&cat", pageNum]];
//        url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", RECOMMANDCOUNTRYLISTAPI3, pageNum, sig, [ControllerManager getSID]];
//    }else{
        sig = [MyMD5 md5:[NSString stringWithFormat:@"from=%@&page=%ddog&cat", type, pageNum]];
        url = [NSString stringWithFormat:@"%@%@&page=%d&sig=%@&SID=%@", RECOMMANDCOUNTRYLISTAPI3, type, pageNum, sig, [ControllerManager getSID]];
//    }
    //
    LOADING;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PetInfoModel * model = [[PetInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.limitDataArray addObject:model];
                [model release];
            }
            //排除该种类为空的情况
            if (array.count) {
                pageNum++;
                [self removeUserPets];
                [tv reloadData];
            }
            [tv footerEndRefreshing];
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
    
}
-(void)loadMoreTopicDataType:(NSString *)type
{
    NSLog(@"---%d", pageNum);
    NSString * sig = nil;
    NSString * url = nil;
//    if ([self.limitTypeName isEqualToString:@"所有种族"]) {
//        sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%ddog&cat", pageNum]];
//        url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", TOPICCOUNTRYLISTAPI3, pageNum, sig, [ControllerManager getSID]];
//    }else{
        sig = [MyMD5 md5:[NSString stringWithFormat:@"from=%@&page=%ddog&cat", type, pageNum]];
        url = [NSString stringWithFormat:@"%@%@&page=%d&sig=%@&SID=%@", TOPICCOUNTRYLISTAPI3, type, pageNum, sig, [ControllerManager getSID]];
//    }
    //
    LOADING;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PetInfoModel * model = [[PetInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.limitDataArray addObject:model];
                [model release];
            }
            //排除该种类为空的情况
            if (array.count) {
                pageNum++;
                [self removeUserPets];
                [tv reloadData];
            }
            
            [tv footerEndRefreshing];
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
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
