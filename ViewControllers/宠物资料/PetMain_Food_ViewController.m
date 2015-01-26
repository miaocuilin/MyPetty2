//
//  PetMain_Food_ViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetMain_Food_ViewController.h"
#import "PetMain_FoodCell.h"
#import "BegFoodListModel.h"
#import "Alert_2ButtonView2.h"
#import "ChargeViewController.h"

@interface PetMain_Food_ViewController ()

@end

@implementation PetMain_Food_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createFakeNavigation];
    [self createTableView];
    [self loadData];
}
#pragma mark -
-(void)loadData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.model.aid]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", FOODLISTAPI, self.model.aid, sig, [ControllerManager getSID]];
//    NSLog(@"%@", url);
    LOADING;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        [tv headerEndRefreshing];
        if (isFinish) {
            ENDLOADING;
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * array = [load.dataDict objectForKey:@"data"];
                if ([array[0] isKindOfClass:[NSArray class]] && [array[0] count]) {
                    [self.dataArray removeAllObjects];
                    
                    for (NSDictionary * dict in array[0]) {
                        BegFoodListModel * model = [[BegFoodListModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [self.dataArray addObject:model];
                        [model release];
                    }
                    page = 1;
                    [tv reloadData];
                }
            }
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)loadMoreData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&page=%ddog&cat", self.model.aid, page]];
    NSString * url = [NSString stringWithFormat:@"%@%@&page=%d&sig=%@&SID=%@", FOODLISTAPI, self.model.aid, page, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        [tv footerEndRefreshing];
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * array = [load.dataDict objectForKey:@"data"];
                if ([array[0] isKindOfClass:[NSArray class]] && [array[0] count]) {
                    for (NSDictionary * dict in array[0]) {
                        BegFoodListModel * model = [[BegFoodListModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [self.dataArray addObject:model];
                        [model release];
                    }
                    page++;
                    [tv reloadData];
                }else{
                    [MyControl popAlertWithView:self.view Msg:@"木有更多了~"];
                }
            }
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
#pragma mark -
-(void)createFakeNavigation
{
    UIImageView * blurImage = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.png"];
    [self.view addSubview:blurImage];
    
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"挣口粮"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}
- (void)backBtnClick
{
    NSLog(@"dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = 0;
    [self.view addSubview:tv];
    [tv addFooterWithTarget:self action:@selector(loadMoreData)];
    [tv addHeaderWithTarget:self action:@selector(loadData)];
}
#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    self.dataArray.count
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"ID";
    PetMain_FoodCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[PetMain_FoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    [cell configUI:self.dataArray[indexPath.row]];
    cell.rewardClick = ^(UILabel * rewardNum){
        if (![[USER objectForKey:@"isSuccess"] intValue]) {
            ShowAlertView;
            return;
        }
        if ([rewardNum.text intValue]>[[USER objectForKey:@"gold"] intValue]+[[USER objectForKey:@"food"] intValue]) {
            Alert_2ButtonView2 * view2 = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
            view2.type = 2;
            view2.rewardNum = rewardNum.text;
            [view2 makeUI];
            view2.jumpCharge = ^(){
                ChargeViewController * charge = [[ChargeViewController alloc] init];
                [self presentViewController:charge animated:YES completion:nil];
                [charge release];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:view2];
            [view2 release];
            return;
        }
        
        if([[USER objectForKey:@"notShowCostAlert"] intValue] && [rewardNum.text intValue]>[[USER objectForKey:@"food"] intValue]){
            Alert_2ButtonView2 * view2 = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
            view2.type = 1;
            view2.reward = ^(){
                [cell reward];
            };
            view2.rewardNum = rewardNum.text;
            [view2 makeUI];
            [[UIApplication sharedApplication].keyWindow addSubview:view2];
            [view2 release];
            return;
        }
        [cell reward];
    };
    
    
    cell.selectionStyle = 0;
    cell.clipsToBounds = YES;
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //105  165
    NSDate * date = [NSDate date];
    //当前时间戳
    int stamp = [[NSString stringWithFormat:@"%f", [date timeIntervalSince1970]] intValue];
    int timeStamp = [[self.dataArray[indexPath.row] create_time] intValue];
    if(stamp-timeStamp >= 24*60*60){
        return 105.0f;
    }else{
        return 165.0f;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int a = indexPath.row;
    NSLog(@"%d", a);
    FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
    vc.img_id = [self.dataArray[a] img_id];
    [self.view addSubview:vc.view];
    [vc release];
}
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
