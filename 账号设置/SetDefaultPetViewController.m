//
//  SetDefaultPetViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "SetDefaultPetViewController.h"
#import "DefaultPetCell.h"
#import "UserPetListModel.h"
@interface SetDefaultPetViewController ()

@end

@implementation SetDefaultPetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //修改aid,a_name,a_tx,age,gender
    self.userPetListArray = [NSMutableArray arrayWithCapacity:0];
    [self createBg];
    [self createTableView];
    [self createFakeNavigation];
    [self loadMyCountryInfoData];
}
#pragma mark - 用户宠物数据
-(void)loadMyCountryInfoData
{
    //    user/petsApi&usr_id=(若用户为自己则留空不填)
    NSString * code = [NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"用户宠物数据:%@", load.dataDict);
            [self.userPetListArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (NSDictionary * dict in array) {
                UserPetListModel * model = [[UserPetListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.userPetListArray addObject:model];
                [model release];
            }
            [tv reloadData];
        }else{
            
        }
    }];
    [request release];
}
#pragma mark - 创建背景及导航
-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
//    NSLog(@"%@", filePath);
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
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"设置默认宠物"];
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
    return self.userPetListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    DefaultPetCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DefaultPetCell" owner:self options:nil] objectAtIndex:0];
    }
    UserPetListModel *model = self.userPetListArray[indexPath.row];
    cell.defaultBtnClick = ^(int a, NSString * master_id){
        NSLog(@"clickDefaultPet:%d", a);
        //请求切换默认宠物API
        [self changeDefaultPet:[self.userPetListArray[a] aid] MasterId:master_id];
    };
    
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
    if ([model.aid isEqualToString:[USER objectForKey:@"aid"]]) {
        [cell configUIWithModel:model Default:YES Row:indexPath.row];
    }else{
        [cell configUIWithModel:model Default:NO Row:indexPath.row];
    }

    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
}

#pragma mark -
-(void)changeDefaultPet:(NSString *)aid MasterId:(NSString *)master_id
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:@"切换中..."];
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", aid]];
    NSString * url =[NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", CHANGEDEFAULTPETAPI, aid, sig, [ControllerManager getSID]];
//    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                NSLog(@"%@", aid);
                [USER setObject:aid forKey:@"aid"];
                [USER setObject:master_id forKey:@"master_id"];
                NSLog(@"%@--%@--%@", [USER objectForKey:@"aid"], [USER objectForKey:@"master_id"], [USER objectForKey:@"usr_id"]);
                [tv reloadData];
                [self loadPetInfo];
                
            }else{
                [MMProgressHUD dismissWithError:@"切换失败" afterDelay:0.8];
            }
            
        }else{
            [MMProgressHUD dismissWithError:@"切换失败" afterDelay:0.8];
        }
    }];
    [request release];
}
-(void)loadPetInfo
{
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showProgressWithStyle:0 title:nil status:@"切换成功，更新信息中..." confirmationMessage:@"确认取消?" cancelBlock:^{
        LoadingFailed;
    }];
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", [USER objectForKey:@"aid"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETINFOAPI, [USER objectForKey:@"aid"], sig, [ControllerManager getSID]];
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"petInfo:%@", load.dataDict);
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                
                //记录默认宠物信息
                [USER setObject:[load.dataDict objectForKey:@"data"] forKey:@"petInfoDict"];
            }
            [MMProgressHUD dismissWithSuccess:@"更新成功" title:nil afterDelay:0.5];
        }else{
            [MMProgressHUD dismissWithError:@"更新失败" afterDelay:0.5];
        }
    }];
    [request release];
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
