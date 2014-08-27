//
//  LikersLIstViewController.m
//  MyPetty
//
//  Created by Aidi on 14-6-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "LikersLIstViewController.h"
#import "AttentionCell.h"
#import "InfoModel.h"
#import "MyHomeViewController.h"
#import "OtherHomeViewController.h"
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self makeNavigation];
    [self loadData];
}

#pragma mark -创建导航
-(void)makeNavigation
{
//    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"参与用户";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if (iOS7) {
        self.navigationController.navigationBar.barTintColor = BGCOLOR;
    }else{
        self.navigationController.navigationBar.tintColor = BGCOLOR;
    }
    UIButton * button1 = [MyControl createButtonWithFrame:CGRectMake(0, 0, 56/2, 56/2) ImageName:@"7-7.png" Target:self Action:@selector(returnClick) Title:nil];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
}
-(void)loadData
{
    NSString * str = [NSString stringWithFormat:@"usr_ids=%@dog&cat", self.usr_ids];
    NSString * code = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", LIKERSAPI, self.usr_ids, code, [ControllerManager getSID]];
    NSLog(@"赞列表：%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
           
            [self.dataArray removeAllObjects];
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                InfoModel * model = [[InfoModel alloc] init];
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
    [self.view addSubview:tv];
    [tv release];
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
    InfoModel * model = self.dataArray[indexPath.row];
    [cell configUI:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.dataArray[indexPath.row] usr_id] isEqualToString:[USER objectForKey:@"usr_id"]]) {
        //跳到我的个人主页
        NSLog(@"进入主页，times：%@", [USER objectForKey:@"MyHomeTimes"]);
        if ([[USER objectForKey:@"MyHomeTimes"] intValue] == 2) {
//            [self.parentViewController.parentViewController dismissViewControllerAnimated:YES completion:nil];
//            [USER setObject:@"0" forKey:@"MyHomeTimes"];
        }else{
            MyHomeViewController * vc = [ControllerManager shareManagerMyHome];
            [self presentViewController:vc animated:YES completion:nil];
        }
        
    }else{
        //跳到其他人的主页
        OtherHomeViewController * vc = [[OtherHomeViewController alloc] init];
        vc.usr_id = [self.dataArray[indexPath.row] usr_id];
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }
    
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(void)returnClick
{
    NSLog(@"%d", [[USER objectForKey:@"isFromActivity"] intValue]);
    if ([[USER objectForKey:@"isFromActivity"] intValue] == 1) {
        [USER setObject:@"0" forKey:@"isFromActivity"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
