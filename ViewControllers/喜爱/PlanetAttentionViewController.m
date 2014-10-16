//
//  PlanetAttentionViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-9-10.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PlanetAttentionViewController.h"
#import "PlanetAttentionCell.h"
#import "PhotoModel.h"
#import "PicDetailViewController.h"
#import "PetInfoViewController.h"
@interface PlanetAttentionViewController ()

@end

@implementation PlanetAttentionViewController

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
    [self loadData];
    [self createTableView];
    
}
-(void)loadData
{
    StartLoading;
    NSString * url = [NSString stringWithFormat:@"%@%@", FAVORITEAPI, [ControllerManager getSID]];
    NSLog(@"关注页面的url :%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"%@", load.dataDict);
            [self.dataArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                [model release];
            }

            [tv reloadData];
            LoadingSuccess;
            [tv headerEndRefreshing];
        }else{
            LoadingFailed;
        }
    }];
    [request release];
}
-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
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
#pragma mark -
-(void)headRefresh
{
    [self loadData];
}

-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = 0;
    tv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tv];
    
    [tv addHeaderWithTarget:self action:@selector(headRefresh)];
    
//    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
//    tv.tableHeaderView = tempView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * cellID0 = @"ID0";
        UITableViewCell * cell0 = [tableView dequeueReusableCellWithIdentifier:cellID0];
        if (!cell0) {
            cell0 = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID0] autorelease];
        }
        cell0.backgroundColor = [UIColor clearColor];
        cell0.selectionStyle = 0;
        return cell0;
    }else{
        static NSString * cellID = @"ID";
        PlanetAttentionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PlanetAttentionCell" owner:self options:nil] objectAtIndex:0];
        }
        PhotoModel * model = self.dataArray[indexPath.row-1];
        [cell configUI:model];
        cell.jumpToDetail = ^(NSString * img_id){
            PicDetailViewController * vc = [[PicDetailViewController alloc] init];
            vc.img_id = img_id;
            [self presentViewController:vc animated:YES completion:nil];
            [vc release];
        };
        cell.jumpToPetInfo = ^(NSString * aid){
            PetInfoViewController * vc = [[PetInfoViewController alloc] init];
            vc.aid = aid;
            [self presentViewController:vc animated:YES completion:nil];
            [vc release];
        };
        cell.selectionStyle = 0;
        return cell;
    }
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 35.0f;
    }else{
        return 250.0f;
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
