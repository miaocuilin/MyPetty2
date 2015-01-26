//
//  PetMain_Fans_ViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetMain_Fans_ViewController.h"
#import "MyCountryContributeCell.h"
#import "PetNewsModel.h"
#import "CountryMembersModel.h"

@interface PetMain_Fans_ViewController ()

@end

@implementation PetMain_Fans_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createFakeNavigation];
    [self createTableView];
    [self loadKingMembersData];
}
#pragma mark - 国家成员数据
- (void)loadKingMembersData
{
    NSString *animalMembersSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.model.aid]];
    NSString *animalMembersString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETMEMBERSAPI, self.model.aid, animalMembersSig, [ControllerManager getSID]];
    NSLog(@"国王成员API:%@",animalMembersString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:animalMembersString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            [self.dataArray removeAllObjects];
            //            NSLog(@"国王成员数据：%@",load.dataDict);
            NSArray *array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            
            for (int i = 0; i<array.count; i++) {
                NSDictionary * dict = array[i];
                CountryMembersModel *model = [[CountryMembersModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                //                NSLog(@"model.usr_id:%@",model.usr_id);
                if (i == array.count-1) {
                    self.lastUsr_id = model.usr_id;
                    self.lastRank = model.rank;
                }
                //给主人调整位置到第一位
                if ([model.usr_id isEqualToString:self.model.master_id]) {
                    [self.dataArray insertObject:model atIndex:0];
                }else{
                    [self.dataArray addObject:model];
                }
                
                [model release];
            }
            
            
            //            NSLog(@"%@", [self.countryMembersDataArray[0] usr_id]);
            [tv reloadData];
            //            [self loadKingPresentsData];
        }
    }];
    [request release];
    
}
- (void)loadKingMembersDataMore
{
    NSString *animalMembersSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&rank=%@&usr_id=%@dog&cat",self.model.aid,self.lastRank,self.lastUsr_id]];
    NSString *animalMembersString = [NSString stringWithFormat:@"%@%@&rank=%@&usr_id=%@&sig=%@&SID=%@", PETMEMBERSAPI,self.model.aid,self.lastRank,self.lastUsr_id,animalMembersSig, [ControllerManager getSID]];
    NSLog(@"更多国王成员API:%@",animalMembersString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:animalMembersString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            NSLog(@"更多国王成员数据：%@",load.dataDict);
            //            [self.countryMembersDataArray removeAllObjects];
            NSArray *array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            if (array.count == 0) {
                [tv footerEndRefreshing];
                return;
            }
            for (int i = 0; i<array.count; i++) {
                NSDictionary * dict = array[i];
                CountryMembersModel *model = [[CountryMembersModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                if (i == array.count-1) {
                    self.lastUsr_id = model.usr_id;
                }
                [model release];
            }
            [tv footerEndRefreshing];
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
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"粉丝"];
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
    tv.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tv];
    [tv addFooterWithTarget:self action:@selector(loadKingMembersDataMore)];
}
#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID3 = @"ID3";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib * nib = [UINib nibWithNibName:@"MyCountryContributeCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID3];
        nibsRegistered = YES;
    }
    MyCountryContributeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
    cell.selectionStyle = 0;
    
    if (indexPath.row == 0) {
        [cell modifyWithBOOL:YES lineNum:indexPath.row];
    }else{
        [cell modifyWithBOOL:NO lineNum:indexPath.row];
    }
    CountryMembersModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell configUI:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CountryMembersModel * model = self.dataArray[indexPath.row];
    UserCardViewController * vc = [[UserCardViewController alloc] init];
    vc.usr_id = model.usr_id;
    [self.view addSubview:vc.view];
    vc.close = ^(){
        [vc.view removeFromSuperview];
    };
    [vc release];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
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
