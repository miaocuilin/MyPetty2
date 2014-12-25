//
//  PetMainViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetMainViewController.h"
#import "PetMainCell.h"

@interface PetMainViewController ()

@end

@implementation PetMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MobClick event:@"pet_homepage"];
    
    [self createTableView];
}

-(void)createTableView
{
    UIImageView * blurImage = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.png"];
    [self.view addSubview:blurImage];
    
    tv = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tv.showsVerticalScrollIndicator = NO;
    tv.separatorStyle = NO;
    tv.backgroundColor = [UIColor clearColor];
    tv.delegate = self;
    tv.dataSource = self;
    
    [self.view addSubview:tv];
    
    UIView * headerView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 590/2.0)];
    tv.tableHeaderView = headerView;
    
    headBlurImage = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headerView.frame.size.height) ImageName:@""];
    [headerView addSubview:headBlurImage];
    
        
    /************************************/
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [self.view addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:backBtn];
    UIImageView * threePoint = [MyControl createImageViewWithFrame:CGRectMake(self.view.frame.size.width-36, 32+17/2.0-9/4.0, 47/2.0, 9/2.0) ImageName:@"threePoint.png"];
    [self.view addSubview:threePoint];
    
    UIButton * threePBtn = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-42, 25, 25+8+4, 32) ImageName:@"" Target:self Action:@selector(threePBtnClick) Title:nil];
    threePBtn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:threePBtn];
    
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)threePBtnClick
{
    NSLog(@"More");
}


#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= 2) {
        static NSString * cellID = @"petMain";
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib * nib = [UINib nibWithNibName:@"PetMainCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellID];
            nibsRegistered = YES;
        }
        PetMainCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle = 0;
        
        [cell modifyUIWithIndex:indexPath.row Num:@"（3589）"];
        return cell;
    }else{
        static NSString * cellID = @"ID";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        }
        cell.selectionStyle = 0;
        
        return cell;
    }
    
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 3) {
        return 55.0f;
    }else{
        return 107.0f;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
