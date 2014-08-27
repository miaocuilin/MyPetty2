//
//  ChooseFamilyViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ChooseFamilyViewController.h"
#define GREEN [UIColor colorWithRed:147/255.0 green:203/255.0 blue:172/255.0 alpha:1]
#import "AttentionCell.h"
#import "SearchFamilyViewController.h"
#import "ChooseFamilyDetailCell.h"
#import "RegisterViewController.h"

@interface ChooseFamilyViewController ()

@end

@implementation ChooseFamilyViewController

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
    
    didSelected = -1;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.catArray = [NSMutableArray arrayWithCapacity:0];
    self.dogArray = [NSMutableArray arrayWithCapacity:0];
    self.otherArray = [NSMutableArray arrayWithCapacity:0];
    self.totalArray = [NSMutableArray arrayWithCapacity:0];
    self.systemListArray = [NSMutableArray arrayWithObjects:@"按系统推荐", @"按人气排列", @"按人数排列", nil];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [self createBg];
    [self createTableView];
    [self createFakeNavigation];
    [self createHeader];
    [self getListData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidden) name:@"af" object:nil];
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
-(void)hidden
{
    [afView hide];
}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 30, 20, 20) ImageName:@"7-7.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
//    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"选择王国"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIImageView * searchImageView = [MyControl createImageViewWithFrame:CGRectMake(320-31, 33, 18, 16) ImageName:@"5-5.png"];
    [navView addSubview:searchImageView];

    UIButton * searchBtn = [MyControl createButtonWithFrame:CGRectMake(320-41-5, 25, 35, 30) ImageName:@"" Target:self Action:@selector(searchBtnClick) Title:nil];
//    searchBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    searchBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:searchBtn];
    
    UIView * line0 = [MyControl createViewWithFrame:CGRectMake(0, 63, 320, 1)];
    line0.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.1];
    [navView addSubview:line0];
    
//    self.navigationController.navigationBar.translucent = NO;
//    if (1) {
//        self.title = @"选择王国";
//    }else{
//        self.title = @"选择家族";
//    }
//    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 56/2, 56/2) ImageName:@"7-7.png" Target:self Action:@selector(backBtnClick) Title:nil];
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = leftItem;
//    [leftItem release];
//    
//    if (iOS7) {
//        self.navigationController.navigationBar.barTintColor = BGCOLOR;
//    }
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
-(void)createHeader
{
    /*
     【注】这里如果headerView只设置35高，新创建的tableView会超出范围，tableView
     会不受控制，所以当出现二级菜单时要把透明层headerView拉长到200+35高，二级菜单
     消失后再设置回来。
    */
    UIView * headerBgView = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 35)];
    headerBgView.backgroundColor = BGCOLOR;
    headerBgView.alpha = 0.85;
    [self.view addSubview:headerBgView];
    
    headerView = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 35)];
    [self.view addSubview:headerView];
    
    raceBtn = [MyControl createButtonWithFrame:CGRectMake(30, 5, 120, 25) ImageName:@"" Target:self Action:@selector(raceBtnClick) Title:@"所有种族"];
    raceBtn.layer.cornerRadius = 5;
    raceBtn.layer.masksToBounds = YES;
    raceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    raceBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:168/255.0 blue:146/255.0 alpha:0.6];
    [headerView addSubview:raceBtn];
    //小三角
    UIImageView * triangle1 = [MyControl createImageViewWithFrame:CGRectMake(117-8, 9, 10, 8) ImageName:@"5-2.png"];
    [raceBtn addSubview:triangle1];
    
    systemBtn = [MyControl createButtonWithFrame:CGRectMake(180, 5, 110, 25) ImageName:@"" Target:self Action:@selector(systemBtnClick) Title:@"按系统推荐"];
    systemBtn.layer.cornerRadius = 5;
    systemBtn.layer.masksToBounds = YES;
    systemBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    systemBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:168/255.0 blue:146/255.0 alpha:0.6];
    [headerView addSubview:systemBtn];
    
    //小三角
    UIImageView * triangle2 = [MyControl createImageViewWithFrame:CGRectMake(97, 9, 10, 8) ImageName:@"5-2.png"];
    [systemBtn addSubview:triangle2];

    

}
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tv];
    
    UIView * tempView1 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64+35)];
    tv.tableHeaderView = tempView1;
    
    insertView = [[MyControl createViewWithFrame:CGRectMake(0, 0, 320, 100)] retain];
    insertView.backgroundColor = [UIColor colorWithRed:243/255.0 green:198/255.0 blue:164/255.0 alpha:1];
    UIImageView * downArrow = [MyControl createImageViewWithFrame:CGRectMake((320-17)/2, 0, 17, 14) ImageName:@"5-3.png"];
    [insertView addSubview:downArrow];
    
}
#pragma mark - tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == didSelected) {
        return 1;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    ChooseFamilyDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[ChooseFamilyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        UIButton * headBtn = [MyControl createButtonWithFrame:CGRectMake(410/2, 20, 55, 55) ImageName:@"" Target:self Action:@selector(headBtnClick) Title:nil];
        headBtn.layer.cornerRadius = 55/2;
        headBtn.layer.masksToBounds = YES;
        [cell addSubview:headBtn];
    }
    cell.selectionStyle = 0;
    cell.backgroundColor = [ControllerManager colorWithHexString:@"f4c6a2"];

    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 70)];
//    headerBgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * headImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 10, 50, 50) ImageName:@"cat2.jpg"];
    headImageView.layer.cornerRadius = headImageView.frame.size.width/2;
    headImageView.layer.masksToBounds = YES;
    [headerBgView addSubview:headImageView];
    
    UIImageView * sex = [MyControl createImageViewWithFrame:CGRectMake(80, 10, 28/2, 34/2) ImageName:@"man.png"];
    [headerBgView addSubview:sex];
    
    UILabel * name = [MyControl createLabelWithFrame:CGRectMake(100, 10, 150, 20) Font:15 Text:@"毛毛"];
    name.textColor = BGCOLOR;
    [headerBgView addSubview:name];
    
    UILabel * nameAndAgeLabel = [MyControl createLabelWithFrame:CGRectMake(80, 30, 150, 15) Font:13 Text:@"索马利猫 | 3岁"];
    nameAndAgeLabel.textColor = [UIColor blackColor];
    [headerBgView addSubview:nameAndAgeLabel];
    
    UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(80, 52, 70, 15) Font:12 Text:@"总人气 500"];
    rq.textColor = [UIColor lightGrayColor];
    [headerBgView addSubview:rq];
    
    UILabel * memberNum = [MyControl createLabelWithFrame:CGRectMake(155, 52, 70, 15) Font:12 Text:@"|    成员 188"];
    memberNum.textColor = [UIColor lightGrayColor];
    [headerBgView addSubview:memberNum];
    
    UIButton * showOrHideBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, 65) ImageName:@"" Target:self Action:@selector(showOrHideBtnClick:) Title:nil];
    showOrHideBtn.tag = 100+section;
    [headerBgView addSubview:showOrHideBtn];
    
    UIButton * join = [MyControl createButtonWithFrame:CGRectMake(320-60, 20, 50, 25) ImageName:@"" Target:self Action:@selector(joinClick:) Title:@"加入"];
    join.titleLabel.font = [UIFont systemFontOfSize:14];
    join.backgroundColor = GREEN;
    join.layer.cornerRadius = 5;
    join.layer.masksToBounds = YES;
    [headerBgView addSubview:join];
    join.tag = 200+section;

    UIView * whiteLine = [MyControl createViewWithFrame:CGRectMake(80, 69, 320-80, 1)];
    whiteLine.backgroundColor = [UIColor whiteColor];
    [headerBgView addSubview:whiteLine];
    return headerBgView;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125.0f;
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tv beginUpdates];
//    NSIndexPath * indexPath2 = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
//    [tv insertRowsAtIndexPaths:@[indexPath2] withRowAnimation:UITableViewRowAnimationMiddle];
//    [tv endUpdates];
}


-(void)showOrHideBtnClick:(UIButton *)button
{
    NSLog(@"%d", button.tag);
    if (didSelected == button.tag-100) {
        didSelected = -1;
    }else{
        didSelected = button.tag-100;
    }
    [tv reloadData];
//    [tv scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}
-(void)joinClick:(UIButton *)button
{
    NSLog(@"join-%d", button.tag);
    RegisterViewController * vc = [[RegisterViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)headBtnClick
{
    NSLog(@"click row:%d", didSelected);
}


-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)raceBtnClick
{
    NSLog(@"race");

    if (dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc] showDropDown:raceBtn :&f :self.totalArray];
        dropDown.delegate = self;
        headerView.frame = CGRectMake(0, 64, 320, 35+200);
        isRaceShow = YES;
    }else{
        [dropDown hideDropDown:raceBtn];
        isRaceShow = NO;
        [self rel];
    }

}
-(void)systemBtnClick
{
    NSLog(@"system");
    if (dropDown2 == nil) {
        CGFloat f = 120;
        dropDown2 = [[NIDropDown alloc] showDropDown:systemBtn :&f :self.systemListArray];
        dropDown2.delegate = self;
        if (!isRaceShow) {
            headerView.frame = CGRectMake(0, 64, 320, 35+120);
        }
        isSystemShow = YES;
    }else{
        isSystemShow = NO;
        [dropDown2 hideDropDown:systemBtn];
        [self rel2];
    }
}
-(void)niDropDownDelegateMethod:(NIDropDown *)sender
{
    if (sender == dropDown) {
        isRaceShow = NO;
        [self rel];
    }else{
        isSystemShow = NO;
        [self rel2];
    }
    
}
-(void)rel
{
    if (isSystemShow) {
        headerView.frame = CGRectMake(0, 64, 320, 35+120);
    }else{
        headerView.frame = CGRectMake(0, 64, 320, 35);
    }
    [dropDown release];
    dropDown = nil;
}
-(void)rel2
{
    if (isRaceShow) {
        headerView.frame = CGRectMake(0, 64, 320, 35+200);
    }else{
        headerView.frame = CGRectMake(0, 64, 320, 35);
    }
    [dropDown2 release];
    dropDown2 = nil;
}

-(void)searchBtnClick
{
    NSLog(@"search");
    SearchFamilyViewController * vc = [[SearchFamilyViewController alloc] init];
//    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
    afView = [AFPopupView popupWithView:vc.view];
    [afView show];
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
