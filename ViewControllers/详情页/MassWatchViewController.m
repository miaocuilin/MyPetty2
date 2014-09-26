//
//  MassWatchViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-8-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MassWatchViewController.h"
#import "MassWatchCell.h"
#import "UserInfoModel.h"
#import "TalkViewController.h"
#import "UserInfoViewController.h"
@interface MassWatchViewController ()

@end

@implementation MassWatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createBg];
    //请求两次：一次senders，一次likers。
    [self loadSendersData];
//    [self createTableView];
    [self createNavgation];
    
}

-(void)loadSendersData
{
    if (self.senders == nil || self.senders.length == 0) {
        [self loadLikersData];
        return;
    }
    StartLoading;
    NSString * str = [NSString stringWithFormat:@"usr_ids=%@dog&cat", self.senders];
    NSString * code = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", LIKERSAPI, self.senders, code, [ControllerManager getSID]];
    NSLog(@"赞列表：%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {

            [self.dataArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"] ;
            for (NSDictionary * dict in array) {
                UserInfoModel * model = [[UserInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                [model release];
            }
            sendersCount = self.dataArray.count;
            
            [self loadLikersData];
//            [self createTableView];
//            LoadingSuccess;
        }else{
            LoadingFailed;
            NSLog(@"请求赞列表失败");
        }
    }];
}
-(void)loadLikersData
{
    if (self.likers == nil || self.likers.length == 0) {
        [self createTableView];
        LoadingSuccess;
        return;
    }
    StartLoading;
    NSString * str = [NSString stringWithFormat:@"usr_ids=%@dog&cat", self.likers];
    NSString * code = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", LIKERSAPI, self.likers, code, [ControllerManager getSID]];
    NSLog(@"赞列表：%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            
//            [self.dataArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"] ;
            for (NSDictionary * dict in array) {
                UserInfoModel * model = [[UserInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                [model release];
            }
//            sendersCount = self.dataArray.count;
            
//            [self loadLikersData];
            [self createTableView];
            LoadingSuccess;
        }else{
            LoadingFailed;
            NSLog(@"请求赞列表失败");
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
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick:) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"围观群众"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];

}

-(void)backBtnClick:(UIButton *)button
{
    NSLog(@"从围观群众页返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv.dataSource = self;
    tv.delegate = self;
    tv.backgroundColor = [UIColor clearColor];
    tv.separatorStyle = 0;
    [self.view addSubview:tv];
    
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    tv.tableHeaderView = tempView;
    
    [self.view bringSubviewToFront:navView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MassWatchCell *cell = nil;
    static NSString *normalCell = @"Normal";
    cell = [tableView dequeueReusableCellWithIdentifier:normalCell];
    if (!cell) {
        cell = [[[MassWatchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell] autorelease];
    }
    cell.num = indexPath.row;
//    cell.txType = self.txTypesArray[indexPath.row];
    cell.isMi = self.isMi;
    if (indexPath.row>=sendersCount) {
        [cell configUI:self.dataArray[indexPath.row] isLiker:YES];
    }else{
        [cell configUI:self.dataArray[indexPath.row] isLiker:NO];
    }
    
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
    
    cell.jumpToUserInfo = ^(UIImage * image, NSString * usr_id){
        UserInfoViewController * vc = [[UserInfoViewController alloc] init];
        vc.usr_id = usr_id;
        vc.modalTransitionStyle = 2;
        vc.petHeadImage = image;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    };
    
    cell.cellClick = ^(int num){
        NSLog(@"跳转到第%d个国家", num);
        TalkViewController *talk = [[TalkViewController alloc] init];
        talk.friendName = [self.dataArray[num] name];
        talk.usr_id = [self.dataArray[num] usr_id];
        talk.otherTX = [self.dataArray[num] tx];
        [self presentViewController:talk animated:YES completion:nil];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
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
#pragma mark - 图片毛玻璃化
//-(void)blurImage
//{
//    [self.bgImageView blurInAnimationWithDuration:0.1f];
//}
@end
