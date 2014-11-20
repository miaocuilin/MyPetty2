//
//  LikersLIstViewController.m
//  MyPetty
//
//  Created by Aidi on 14-6-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "LikersLIstViewController.h"
#import "AttentionCell.h"
#import "PetInfoModel.h"
#import "PetInfoViewController.h"
@interface LikersLIstViewController ()

@end

@implementation LikersLIstViewController

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
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self createBg];
    [self createFakeNavgation];
    [self loadData];
    
}

-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
//    NSString * docDir = DOCDIR;
    NSString * filePath = BLURBG;

    NSData * data = [NSData dataWithContentsOfFile:filePath];

    UIImage * image = [UIImage imageWithData:data];
    bgImageView.image = image;
    
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:tempView];
}
#pragma mark -创建导航
- (void)createFakeNavgation
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
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"参与宠物"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)loadData
{
    NSString * str = [NSString stringWithFormat:@"aids=%@dog&cat", self.aids];
    NSString * code = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETLISTAPI, self.aids, code, [ControllerManager getSID]];
    NSLog(@"列表：%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
           
            [self.dataArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (NSDictionary * dict in array) {
                PetInfoModel * model = [[PetInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                [model release];
            }
            [self createTableView];
        }else{
            NSLog(@"请求赞列表失败");
        }
    }];
}
#pragma mark -tableView
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = 0;
    tv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tv];
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    tv.tableHeaderView = view;
    [tv release];
    
    [self.view bringSubviewToFront:navView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"点赞人数：%d", self.dataArray.count);
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttentionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[[AttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"] autorelease];
    }
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
    PetInfoModel * model = self.dataArray[indexPath.row];
    [cell configUI:model];
    
    cell.jumpToPetInfo = ^(NSString * aid){
        PetInfoViewController * vc = [[PetInfoViewController alloc] init];
        vc.aid = aid;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    };
    return cell;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([[self.dataArray[indexPath.row] usr_id] isEqualToString:[USER objectForKey:@"usr_id"]]) {
//        //跳到我的个人主页
//        NSLog(@"进入主页，times：%@", [USER objectForKey:@"MyHomeTimes"]);
//        if ([[USER objectForKey:@"MyHomeTimes"] intValue] == 2) {
////            [self.parentViewController.parentViewController dismissViewControllerAnimated:YES completion:nil];
////            [USER setObject:@"0" forKey:@"MyHomeTimes"];
//        }else{
//            MyHomeViewController * vc = [ControllerManager shareManagerMyHome];
//            [self presentViewController:vc animated:YES completion:nil];
//        }
//        
//    }else{
//        //跳到其他人的主页
//        OtherHomeViewController * vc = [[OtherHomeViewController alloc] init];
//        vc.usr_id = [self.dataArray[indexPath.row] usr_id];
//        [self presentViewController:vc animated:YES completion:nil];
//        [vc release];
//    }
//    
//}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

//-(void)returnClick
//{
//    NSLog(@"%d", [[USER objectForKey:@"isFromActivity"] intValue]);
//    if ([[USER objectForKey:@"isFromActivity"] intValue] == 1) {
//        [USER setObject:@"0" forKey:@"isFromActivity"];
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}
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
