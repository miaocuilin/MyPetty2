//
//  PetMain_Active_ViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetMain_Active_ViewController.h"
#import "MyCountryMessageCell.h"
#import "PetNewsModel.h"
#import "SendGiftViewController.h"

@interface PetMain_Active_ViewController ()

@end

@implementation PetMain_Active_ViewController
-(void)dealloc
{
    [super dealloc];
    [tv release];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createFakeNavigation];
    [self createTableView];
    [self loadData];
}
-(void)loadData
{
    //1 成为粉丝 2 加入王国 3发图片 4送礼物 5叫一叫 6逗一逗 7捣捣乱
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.model.aid]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETNEWSAPI, self.model.aid, sig, [ControllerManager getSID]];
    NSLog(@"国王动态API:%@", url);
    
    __block PetMain_Active_ViewController * blockSelf = self;
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"国王动态数据：%@",load.dataDict);
            [blockSelf.dataArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (int i=0; i<array.count; i++) {
                PetNewsModel * model = [[PetNewsModel alloc] init];
                [model setValuesForKeysWithDictionary:array[i]];
                model.content = [array[i] objectForKey:@"content"];
                if([model.type intValue] != 1){
                    if(!(([model.type intValue] == 4 || [model.type intValue] == 7) && ([[model.content objectForKey:@"item_id"] intValue]%10 >4 || [[model.content objectForKey:@"item_id"] intValue]>=2200))){
                        [blockSelf.dataArray addObject:model];
                    }
                    
                }
                [model release];
            }

            if (blockSelf.dataArray.count) {
                blockSelf.lastNid = [blockSelf.dataArray[blockSelf.dataArray.count-1] nid];
            }
            
            
            [blockSelf->tv reloadData];
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
- (void)loadMoreData
{
    //1 成为粉丝 2 加入王国 3发图片 4送礼物 5叫一叫 6逗一逗 7捣捣乱
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&nid=%@dog&cat", self.model.aid, self.lastNid]];
    NSString * url = [NSString stringWithFormat:@"%@%@&nid=%@&sig=%@&SID=%@", PETNEWSAPI2, self.model.aid, self.lastNid, sig, [ControllerManager getSID]];
    NSLog(@"国王动态API2:%@", url);
    
    __block PetMain_Active_ViewController *blockSelf = self;
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"国王动态数据2：%@",load.dataDict);
            //            [self.newsDataArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (int i=0; i<array.count; i++) {
                PetNewsModel * model = [[PetNewsModel alloc] init];
                [model setValuesForKeysWithDictionary:array[i]];
                model.content = [array[i] objectForKey:@"content"];
                if([model.type intValue] != 1){
                    if(!(([model.type intValue] == 4 || [model.type intValue] == 7) && ([[model.content objectForKey:@"item_id"] intValue]%10 >4 || [[model.content objectForKey:@"item_id"] intValue]>=2200))){
                        [blockSelf.dataArray addObject:model];
                    }
                    
                }
                [model release];
            }
            if (array.count) {
                blockSelf.lastNid = [blockSelf.dataArray[blockSelf.dataArray.count-1] nid];
            }
            [blockSelf->tv footerEndRefreshing];
            [blockSelf->tv reloadData];
            ENDLOADING;
            
        }else{
            [blockSelf->tv footerEndRefreshing];
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
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"动态"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}
- (void)backBtnClick
{
    NSLog(@"dismiss");
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
    tv.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tv];
    [tv addFooterWithTarget:self action:@selector(loadMoreData)];
//    [tv release];
}
#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    MyCountryMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[[MyCountryMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    cell.selectionStyle = 0;
    cell.clipsToBounds = YES;
    PetNewsModel * model = self.dataArray[indexPath.row];
    [cell modifyWithModel:model PetName:self.model.name];
    
    __block PetMain_Active_ViewController * blockSelf = self;
    cell.clickImage = ^(){
        FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
        vc.img_id = [[model content] objectForKey:@"img_id"];
        [ControllerManager addViewController:vc To:blockSelf];
        [vc release];
    };
    cell.sendGift = ^(){
        [blockSelf sendGift];
    };
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PetNewsModel * model = self.dataArray[indexPath.row];
    int a = [model.type intValue];
    //1.成粉 2.加入 3.发图 4.送礼 5.叫一叫 6.逗一逗 7.捣乱
    if (a == 1) {
        return 70.0f;
    }else if (a == 2) {
        return 70.0f;
    }else if (a == 3) {
        return 130.0f;
    }else if (a == 4) {
        return 125.0f;
    }else if (a == 5) {
        return 90.0f;
    }else if (a == 6) {
        return 90.0f;
    }else{
        return 105.0f;
    }
}

#pragma mark - 送礼
-(void)sendGift
{
    NSLog(@"赠送礼物");
    
    if (![ControllerManager getIsSuccess]) {
        //提示注册
        ShowAlertView;
        return;
    }else{
        SendGiftViewController * quictGiftvc = [[SendGiftViewController alloc] init];
        quictGiftvc.receiver_aid = self.model.aid;
        quictGiftvc.receiver_name = self.model.name;
        //
        __block PetMain_Active_ViewController * blockSelf = self;
        quictGiftvc.hasSendGift = ^(NSString * itemId){
            [blockSelf loadData];
        };
        
        [self addChildViewController:quictGiftvc];
        [quictGiftvc didMoveToParentViewController:self];
        [self.view addSubview:quictGiftvc.view];
        [quictGiftvc release];
        
    }
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
