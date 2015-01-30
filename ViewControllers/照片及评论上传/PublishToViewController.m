//
//  PublishToViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/8.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PublishToViewController.h"
#import "PublishToCell.h"
#import "UserPetListModel.h"

@interface PublishToViewController ()

@end

@implementation PublishToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.selectArray = [NSMutableArray arrayWithCapacity:0];
    self.selectNameArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createBg];
    [self createTabelView];
    [self createFakeNavigation];
    [self loadData];
}
-(void)loadData
{
    LOADING;
    NSString * code = [NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            [self.dataArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (NSDictionary * dict in array) {
                if (![[dict objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
                    continue;
                }
                UserPetListModel * model = [[UserPetListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                if ([model.aid isEqualToString:self.aid]) {
                    self.index = self.dataArray.count-1;
                }
                [model release];
            }
            [tv reloadData];
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)createBg
{
    UIImageView * bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"blurBg.jpg"];
    [self.view addSubview:bgImageView];
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    [self.view addSubview:tempView];
}
-(void)createFakeNavigation
{
    UIView * navView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"发布到"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIButton * rightButton = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-170/2*0.9-10, backImageView.frame.origin.y-4, 170/2*0.9, 54/2*0.9) ImageName:@"exchange_cateBtn.png" Target:self Action:@selector(rightButtonClick) Title:@"确定"];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    rightButton.showsTouchWhenHighlighted = YES;
    [navView addSubview:rightButton];
}
#pragma mark - 点击事件
-(void)backBtnClick
{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightButtonClick
{
    NSLog(@"%@", self.selectArray);
    
    self.selectedArray(self.selectArray, self.selectNameArray);
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
-(void)createTabelView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.backgroundColor = [UIColor clearColor];
    tv.separatorStyle = 0;
    [self.view addSubview:tv];
    
//    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
//    tv.tableHeaderView = view;
}
#pragma mark -
#pragma mark - tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib * nib = [UINib nibWithNibName:@"PublishToCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        nibsRegistered = YES;
    }
    PublishToCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (self.index == indexPath.row) {
        [cell configUI:self.dataArray[indexPath.row] Index:indexPath.row BtnSelected:YES];
    }else{
        [cell configUI:self.dataArray[indexPath.row] Index:indexPath.row BtnSelected:NO];
    }
    
    cell.selectBlock = ^(int a){
        [self.selectArray removeAllObjects];
        [self.selectNameArray removeAllObjects];
        
        [self.selectArray addObject:[self.dataArray[indexPath.row] aid]];
        [self.selectNameArray addObject:[self.dataArray[indexPath.row] name]];
        self.index = indexPath.row;
        [tv reloadData];
    };
//    cell.unSelectBlock = ^(int a){
//        [self.selectArray removeObject:[self.dataArray[indexPath.row] aid]];
//        [self.selectNameArray removeObject:[self.dataArray[indexPath.row] name]];
//    };
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"选择了第%d个", indexPath.row);
////    tf.text = self.dataArray[indexPath.row];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
