//
//  PopularityListViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PopularityListViewController.h"
#define YELLOW [UIColor colorWithRed:250/255.0 green:230/255.0 blue:180/255.0 alpha:1]
#import "PopularityCell.h"
#import "popularityListModel.h"
@interface PopularityListViewController ()

@property (nonatomic,assign)NSInteger category;
@end

@implementation PopularityListViewController

- (NSInteger)category
{
    if (!_category) {
        _category = 0;
    }
    return _category;
}
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
    self.catArray = [NSMutableArray arrayWithCapacity:0];
    self.dogArray = [NSMutableArray arrayWithCapacity:0];
    self.otherArray = [NSMutableArray arrayWithCapacity:0];
    self.totalArray = [NSMutableArray arrayWithCapacity:0];
    self.titleArray = [NSMutableArray arrayWithObjects:@"总人气榜",@"人气日榜", @"人气周榜", @"人气月榜",  nil];
    self.myCountryRankArray = [NSMutableArray arrayWithObjects:@"10", @"38", @"66", @"88", nil];
    self.rankData = [NSMutableArray arrayWithCapacity:0];
    [self getListData];
    [self createBg];
    [self createTableView];
    [self createHeader2];
    [self createHeader];
    [self createFakeNavigation];
    
    [self createArrow];
    [self findMeBtnClick];
    [self loadData];

}
- (void)loadData
{
    NSString *rankSig = [MyMD5 md5:[NSString stringWithFormat:@"category=%ddog&cat",self.category]];
    NSString *rank = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@",POPULARRANKAPI,self.category,rankSig,[ControllerManager getSID]];
    NSLog(@"rank:%@",rank);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:rank Block:^(BOOL isFinish, httpDownloadBlock *load) {
        NSLog(@"人气排行数据：%@",load.dataDict);
        if (isFinish) {
            arrow.hidden = NO;
            [self.rankData removeAllObjects];
            NSArray *array = [load.dataDict objectForKey:@"data"];
            for (int i = 0; i<array.count; i++) {
                NSDictionary *dict = array[i];
                popularityListModel *model = [[popularityListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.rankData addObject:model];
                [model release];
            }
//            [self createTableView];
            [tv reloadData];
            [tv2 reloadData];
        }
    }];
    [request release];
}
-(void)getListData
{
    NSDictionary * oriDict = [USER objectForKey:@"CateNameList"];
    //将数据存到数组中
    NSDictionary * dict1 = [oriDict objectForKey:@"1"];
    NSDictionary * dict2 = [oriDict objectForKey:@"2"];
    NSDictionary * dict3 = [oriDict objectForKey:@"3"];
    
    [self.totalArray addObject:@"所有种族"];
    
    for (int i=0; i<[dict1 count]; i++) {
        NSString * str = [dict1 objectForKey:[NSString stringWithFormat:@"%d", 100+i+1]];
        [self.catArray addObject:str];
        [self.totalArray addObject:str];
    }
    for (int i=0; i<[dict2 count]; i++) {
        NSString * str = [dict2 objectForKey:[NSString stringWithFormat:@"%d", 200+i+1]];
        [self.dogArray addObject:str];
        [self.totalArray addObject:str];
    }
    for (int i=0; i<[dict3 count]; i++) {
        NSString * str = [dict3 objectForKey:[NSString stringWithFormat:@"%d", 300+i+1]];
        [self.otherArray addObject:str];
        [self.totalArray addObject:str];
    }
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
#pragma mark - 创建tableView
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 64+35+35+50*5) style:UITableViewStylePlain];
    if (self.view.frame.size.height == 480) {
        tv.frame = CGRectMake(0, 0, 320, 64+35+35+50*3);
    }
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = 0;
    tv.backgroundColor = [UIColor clearColor];
    tv.scrollEnabled = NO;
    [self.view addSubview:tv];
    
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64+35+35)];
    tv.tableHeaderView = tempView;
    
    tv2 = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50*3, 320, 50*3) style:UITableViewStylePlain];
    tv2.delegate = self;
    tv2.dataSource = self;
    tv2.separatorStyle = 0;
    tv2.showsVerticalScrollIndicator = NO;
    tv2.scrollEnabled = NO;
    tv2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tv2];
}
#pragma mark - 创建arrow
-(void)createArrow
{
    arrow = [MyControl createButtonWithFrame:CGRectMake(150, self.view.frame.size.height-50*4+13.5, 20, 34) ImageName:@"list_moreArrow.png" Target:self Action:@selector(showEntireList) Title:nil];
    arrow.hidden = YES;
    [self.view addSubview:arrow];
//    arrow = [MyControl createImageViewWithFrame:CGRectMake(150, self.view.frame.size.height-50*4+13.5, 20, 34) ImageName:@"list_moreArrow.png"];
//    [self.view addSubview:arrow];
}
-(void)showEntireList
{
    tv.scrollEnabled = YES;
    arrow.alpha = 0;
    arrow.hidden = YES;
//    findMeBtn.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        tv.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        tv2.frame = CGRectMake(0, self.view.frame.size.height, 320, 0);
    }];
}


#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    PopularityCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PopularityCell" owner:self options:nil] objectAtIndex:0];
    }
    popularityListModel *model = [self.rankData objectAtIndex:indexPath.row];
    [cell configUIWithName:model.name rq:model.t_rq rank:indexPath.row+1 upOrDown:indexPath.row%2 shouldLarge:NO];
    cell.cellClick = ^(int num){
        NSLog(@"跳转到第%d个国家", num);
    };
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
    
    if (tableView == tv2 && indexPath.row == myCurrentCountNum-1) {
        cell.backgroundColor = [ControllerManager colorWithHexString:@"f9f9f9"];
        [cell configUIWithName:model.name rq:model.t_rq rank:indexPath.row+1 upOrDown:indexPath.row%2 shouldLarge:YES];
    }else{
        [cell configUIWithName:model.name rq:model.t_rq rank:indexPath.row+1 upOrDown:indexPath.row%2 shouldLarge:NO];
    }
    NSLog(@"model.tx:%@",model.tx);
    if ([model.tx isEqualToString:@""]) {
        cell.headImageView.image = [UIImage imageNamed:@"defaultPetHead.png"];
    }else{
        NSString *headImagePath = [DOCDIR stringByAppendingString:model.tx];
        UIImage *image = [UIImage imageWithContentsOfFile:headImagePath];
        if (image) {
            cell.headImageView.image = image;
        }else{
            httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@",PETTXURL,model.tx] Block:^(BOOL isFinish, httpDownloadBlock *load) {
                NSLog(@"load.image:%@",load.dataImage);
                if (isFinish) {
                    if (load.dataImage == NULL) {
                        cell.headImageView.image = [UIImage imageNamed:@"defaultPetHead.png"];
                    }else{
                        cell.headImageView.image =load.dataImage;
                    }
                }
            }];
            [request release];
        }
    }
//    NSLog(@"titleBtn.currentTitle:%@",titleBtn.currentTitle);
    if ([titleBtn.currentTitle isEqualToString:@"总人气榜"]) {
        cell.rqNum.text = model.t_rq;
    }else if ([titleBtn.currentTitle isEqualToString:@"人气日榜"]){
        cell.rqNum.text = model.d_rq;
    }else if ([titleBtn.currentTitle isEqualToString:@"人气周榜"]){
        cell.rqNum.text = model.w_rq;
    }else{
        cell.rqNum.text = model.m_rq;
    }
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == tv) {
//        arrow.alpha = 0;
//        arrow.hidden = YES;
        findMeBtn.userInteractionEnabled = NO;
//
//        [UIView animateWithDuration:0.3 animations:^{
//            tv.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
//            tv2.frame = CGRectMake(0, self.view.frame.size.height, 320, 0);
//        }];
//        
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == tv) {
        NSLog(@"endDecelerating");
        findMeBtn.userInteractionEnabled = YES;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == tv) {
        NSLog(@"endDragging");
        findMeBtn.userInteractionEnabled = YES;
    }
}

#pragma mark - 创建导航
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
//    navView.backgroundColor = [UIColor redColor];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    //    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:backBtn];
    
    UILabel * titleBgLabel = [MyControl createLabelWithFrame:CGRectMake(100, 64-39, 120, 30) Font:17 Text:@"喵星"];
    titleBgLabel.font = [UIFont boldSystemFontOfSize:17];
//    titleBgLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
    [navView addSubview:titleBgLabel];
    
//    titleBtn = [MyControl createButtonWithFrame:CGRectMake(130, 64-38, 90, 30) ImageName:@"" Target:self Action:@selector(titleBtnClick:) Title:@"人气日榜"];
//    titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    titleBtn.showsTouchWhenHighlighted = YES;
//    titleBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.6];
//    [titleBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:230/255.0 blue:180/255.0 alpha:1] forState:UIControlStateNormal];
//    [navView addSubview:titleBtn];
    /*****************************/
    
    titleBtn = [MyControl createButtonWithFrame:CGRectMake(130, 64-38, 90, 30) ImageName:@"" Target:self Action:@selector(titleBtnClick:) Title:@"总人气榜"];
    titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [titleBtn setTitleColor:YELLOW forState:UIControlStateNormal];
    [navView addSubview:titleBtn];

    //小三角
    UIImageView * triangle2 = [MyControl createImageViewWithFrame:CGRectMake(82, 12, 10, 8) ImageName:@"5-3.png"];
    [titleBtn addSubview:triangle2];
    /*****************************/
    UIImageView * findMe = [MyControl createImageViewWithFrame:CGRectMake(320-35, 30, 43/2, 47/2) ImageName:@"findMe.png"];
    [navView addSubview:findMe];
    
    findMeBtn = [MyControl createButtonWithFrame:CGRectMake(320-41, 24, 51*0.6, 55*0.6) ImageName:@"" Target:self Action:@selector(findMeBtnClick) Title:nil];
//    giftBagBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    findMeBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:findMeBtn];
    
    UIView * line0 = [MyControl createViewWithFrame:CGRectMake(0, 63, 320, 1)];
    line0.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.1];
    [navView addSubview:line0];
}
#pragma mark - 导航点击事件
-(void)titleBtnClick:(UIButton *)btn
{
    if (dropDown2 == nil) {
        CGFloat f = 200;
        dropDown2 = [[NIDropDown alloc] showDropDown:titleBtn :&f :self.titleArray];
    
        [dropDown2 setCellTextColor:YELLOW Font:[UIFont boldSystemFontOfSize:15] BgColor:[UIColor colorWithRed:252/255.0 green:120/255.0 blue:85/255.0 alpha:0.6] lineColor:[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:0.6]];
        dropDown2.delegate = self;
        CGRect rect = navView.frame;
        rect.size.height = 64+160;
        navView.frame = rect;

        //当drop2打开时关闭drop1
        [dropDown hideDropDown:raceBtn];
        [self rel];
    }else{
        [dropDown2 hideDropDown:titleBtn];

        [self rel2];
    }
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)findMeBtnClick
{
    if (self.myCountryRankArray.count) {
        if (count == self.myCountryRankArray.count) {
            count = 0;
        }
        myCurrentCountNum = [self.myCountryRankArray[count++] intValue];
        
        NSLog(@"%d", myCurrentCountNum);
        tv2.contentOffset = CGPointMake(0, myCurrentCountNum*50-50*2);
        
        [tv2 reloadData];
    }
    
    NSLog(@"findMe");
    arrow.hidden = NO;
    tv.scrollEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        arrow.alpha = 1;
        if (self.view.frame.size.height == 480) {
            tv.frame = CGRectMake(0, 0, 320, 64+35+35+50*3);
        }else{
            tv.frame = CGRectMake(0, 0, 320, 64+35+35+50*5);
        }
        
        tv2.frame = CGRectMake(0, self.view.frame.size.height-50*3, 320, 50*3);
    }];
    
    //控制tv的偏移量为50的整数倍
    for (int i=0; i<100; i++) {
        if (tv.contentOffset.y>i*50 && tv.contentOffset.y<(i+1)*50) {
//            [UIView animateWithDuration:0.3 animations:^{
                tv.contentOffset = CGPointMake(0, (i+1)*50);
            findMeBtn.userInteractionEnabled = YES;
//            }];
            break;
        }
    }
}
#pragma mark - 创建顶栏1
-(void)createHeader
{
    headerView = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 35)];
    [self.view addSubview:headerView];
    
    UIView * headerBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 35)];
    headerBgView.backgroundColor = BGCOLOR;
    headerBgView.alpha = 0.85;
    [headerView addSubview:headerBgView];
    
    raceBtn = [MyControl createButtonWithFrame:CGRectMake(15, 5, 115, 25) ImageName:@"" Target:self Action:@selector(raceBtnClick) Title:@"所有种族"];
    raceBtn.layer.cornerRadius = 5;
    raceBtn.layer.masksToBounds = YES;
    raceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    raceBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:168/255.0 blue:146/255.0 alpha:0.6];
    [headerView addSubview:raceBtn];
    //小三角
    UIImageView * triangle1 = [MyControl createImageViewWithFrame:CGRectMake(102, 9, 10, 8) ImageName:@"5-2.png"];
    [raceBtn addSubview:triangle1];
}
#pragma mark - 创建顶栏2
-(void)createHeader2
{
    UIView * header2Bg = [MyControl createViewWithFrame:CGRectMake(0, 64+35, 320, 35)];
    [self.view addSubview:header2Bg];
    
    UIView * alphaView2 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 35)];
    alphaView2.backgroundColor = [ControllerManager colorWithHexString:@"c1bfbd"];
    alphaView2.alpha = 0.8;
    [header2Bg addSubview:alphaView2];
    
    UILabel * nickName = [MyControl createLabelWithFrame:CGRectMake(15, 7.5, 100, 20) Font:15 Text:@"昵称"];
    [header2Bg addSubview:nickName];
    
    UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(195, 7.5, 60, 20) Font:15 Text:@"人气值"];
    [header2Bg addSubview:rq];
    
    UILabel * rank = [MyControl createLabelWithFrame:CGRectMake(275, 7.5, 60, 20) Font:15 Text:@"排名"];
    [header2Bg addSubview:rank];
}
-(void)raceBtnClick
{
    NSLog(@"race");
    
    if (dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc] showDropDown:raceBtn :&f :self.totalArray];
        [dropDown setDefaultCellType];
        dropDown.delegate = self;
        headerView.frame = CGRectMake(0, 64, 320, 35+200);
    }else{
        [dropDown hideDropDown:raceBtn];
        [self rel];
    }
}

-(void)niDropDownDelegateMethod:(NIDropDown *)sender
{
    if (sender == dropDown) {
        [self rel];
    }else{
        [self rel2];
    }
    NSLog(@"%@",titleBtn.currentTitle);
  
    for (int i =0; i<self.titleArray.count; i++) {
        if ([titleBtn.currentTitle isEqualToString:self.titleArray[i]]) {
            self.category = i;
        }
    }
    [self loadData];
}
-(void)rel
{

    headerView.frame = CGRectMake(0, 64, 320, 35);
    [dropDown release];
    dropDown = nil;
}
-(void)rel2
{
    navView.frame = CGRectMake(0, 0, 320, 64);
    [dropDown2 release];
    dropDown2 = nil;
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
