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
-(void)dealloc
{
    [super dealloc];
}
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
    __block PetMain_Food_ViewController * blockSelf = self;
    
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        [blockSelf->tv headerEndRefreshing];
        
        if (isFinish) {
            ENDLOADING;
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * array = [load.dataDict objectForKey:@"data"];
                if ([array[0] isKindOfClass:[NSArray class]] && [array[0] count]) {
                    [blockSelf.dataArray removeAllObjects];
                    
                    for (NSDictionary * dict in array[0]) {
                        BegFoodListModel * model = [[BegFoodListModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [blockSelf.dataArray addObject:model];
                        [model release];
                    }
                    blockSelf->page = 1;
                    [blockSelf->tv reloadData];
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
    __block PetMain_Food_ViewController * blockSelf = self;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        [blockSelf->tv footerEndRefreshing];
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * array = [load.dataDict objectForKey:@"data"];
                if ([array[0] isKindOfClass:[NSArray class]] && [array[0] count]) {
                    for (NSDictionary * dict in array[0]) {
                        BegFoodListModel * model = [[BegFoodListModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [blockSelf.dataArray addObject:model];
                        [model release];
                    }
                    blockSelf->page++;
                    [blockSelf->tv reloadData];
                }else{
                    [MyControl popAlertWithView:blockSelf.view Msg:@"木有更多了~"];
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
    UIImageView * blurImage = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:blurImage];
    
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
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"挣口粮"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}
- (void)backBtnClick
{
    NSLog(@"dismiss");
    [tv addHeaderWithTarget:nil action:nil];
    [tv addFooterWithTarget:nil action:nil];

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
//    return cell;
    __block PetMain_Food_ViewController * blockSelf = self;
    __block PetMain_FoodCell * blockCell = cell;
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
                Alert_oneBtnView * oneView = [[Alert_oneBtnView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                oneView.type = 4;
                [oneView makeUI];
                oneView.jumpTB = ^(){
                    ChargeViewController * charge = [[ChargeViewController alloc] init];
                    [blockSelf presentViewController:charge animated:YES completion:nil];
                    [charge release];
                };
                [[UIApplication sharedApplication].keyWindow addSubview:oneView];
                [oneView release];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:view2];
            [view2 release];
            return;
        }
        
        if([[USER objectForKey:@"showCostAlert"] intValue] && [rewardNum.text intValue]>[[USER objectForKey:@"food"] intValue]){
            Alert_2ButtonView2 * view2 = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
            view2.type = 1;
            view2.reward = ^(){
                [blockCell reward];
            };
            view2.rewardNum = rewardNum.text;
            [view2 makeUI];
            [[UIApplication sharedApplication].keyWindow addSubview:view2];
            [view2 release];
            return;
        }
        [blockCell reward];
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
//    NSLog(@"%d", a);
    BegFoodListModel *model = self.dataArray[a];
    FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
    vc.img_id = [self.dataArray[a] img_id];
    NSURL *url = [MyControl returnThumbImageURLwithName:model.url Width:86.0*2 Height:86.0*2];
    vc.imageURL = url;
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
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
