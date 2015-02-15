//
//  TopicViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "TopicViewController.h"
#import "topicCell.h"
@interface TopicViewController ()

@end

@implementation TopicViewController

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
    self.topicNameArray = [NSMutableArray arrayWithCapacity:0];
    self.topicIdArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createBg];
    [self createFakeNavigation];
    [self loadTopicData];
    [self createHeader];
    [self createTableView];
    
    [self.view bringSubviewToFront:navView];
    [self.view bringSubviewToFront:headerView];
}
-(void)loadTopicData
{
    LOADING;
    NSString * url = [NSString stringWithFormat:@"%@%@", PUBLISHTOPICLISTAPI, [ControllerManager getSID]];
    NSLog(@"url:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (NSDictionary * dict in array) {
                [self.topicNameArray addObject:[dict objectForKey:@"topic"]];
                [self.topicIdArray addObject:[dict objectForKey:@"topic_id"]];
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
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"blurBg.jpg"];
    [self.view addSubview:self.bgImageView];
    
//    NSString * docDir = DOCDIR;
//    NSString * filePath = BLURBG;
//    
//    NSData * data = [NSData dataWithContentsOfFile:filePath];
//    
//    UIImage * image = [UIImage imageWithData:data];
//    self.bgImageView.image = image;
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [self.view addSubview:tempView];
}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 22, 60, 40) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"# 话题"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIButton * rightButton = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-170/2*0.9-10, backImageView.frame.origin.y-4, 170/2*0.9, 54/2*0.9) ImageName:@"exchange_cateBtn.png" Target:self Action:@selector(rightButtonClick) Title:@"确定"];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    rightButton.showsTouchWhenHighlighted = YES;
    [navView addSubview:rightButton];
}
-(void)createHeader
{
    headerView = [MyControl createViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 35)];
    [self.view addSubview:headerView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    alphaView.backgroundColor = ORANGE;
    alphaView.alpha = 0.2;
    [headerView addSubview:alphaView];
    
    //
//    UIView * redView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
//    redView.backgroundColor = [UIColor redColor];
//    redView.alpha = 0.2;
//    [headerView addSubview:redView];
    
    //
    UIImageView * searchBg = [MyControl createImageViewWithFrame:CGRectMake(10, 5, 300, 25) ImageName:@""];
    searchBg.image = [[UIImage imageNamed:@"topic_tfBg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:10];
    [headerView addSubview:searchBg];
    
    UIImageView * jinghao = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 10, 10) ImageName:@"jinghao.png"];
    tf = [MyControl createTextFieldWithFrame:CGRectMake(20, 7.5, 290, 20) placeholder:nil passWord:NO leftImageView:jinghao rightImageView:nil Font:15];
    tf.borderStyle = 0;
    //    tf.returnKeyType = UIReturnKeySearch;
    //    tf.backgroundColor = BGCOLOR;
    tf.delegate = self;
    tf.textColor = [UIColor whiteColor];
    NSAttributedString * attString = [[NSAttributedString alloc] initWithString:@" 请插入话题名称" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    tf.attributedPlaceholder = attString;
    [attString release];
    [headerView addSubview:tf];
    
}
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+35, 320, self.view.frame.size.height-(64+35)) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.backgroundColor = [UIColor clearColor];
    tv.separatorStyle = 0;
    [self.view addSubview:tv];
    
//    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64+35)];
//    tv.tableHeaderView = view;
}

#pragma mark - 点击事件
-(void)backBtnClick
{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightButtonClick
{
    NSLog(@"确定");
//    NSLog(@"%@", [tf.text class]);
    if (tf.text == nil || [tf.text isEqualToString:@""]) {
        StartLoading;
        [MyControl loadingFailedWithContent:@"话题为空" afterDelay:0.5];
    }else{
        [USER setObject:@"1" forKey:@"selectTopic"];
        [USER setObject:tf.text forKey:@"topic"];
        [tf resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicNameArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    topicCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[topicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    if ([self.topicIdArray[indexPath.row] intValue]) {
        [cell modifyWithName:self.topicNameArray[indexPath.row] isActivity:YES];
    }else{
        [cell modifyWithName:self.topicNameArray[indexPath.row] isActivity:NO];
    }
    
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了第%d个", indexPath.row);
    tf.text = self.topicNameArray[indexPath.row];
}

#pragma mark - textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
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
