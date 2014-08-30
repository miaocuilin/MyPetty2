//
//  SearchFamilyViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "SearchFamilyViewController.h"
#import "AttentionCell.h"
@interface SearchFamilyViewController ()

@end

@implementation SearchFamilyViewController

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
    self.dataArray = [NSMutableArray arrayWithObjects:@"1", @"11", @"111", @"2", @"22", @"222", @"3", @"33", @"333", @"你", @"你我", @"你我他", @"12", @"123", @"1234", @"21", @"321", @"4321", nil];
    self.tempDataArray = [NSMutableArray arrayWithArray:self.dataArray];
    
    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:bgView];
    
//    [self createFakeNavigation];
    [self createHeader];
    [self createTableView];
    
    //监听中文输入
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextChangeNotification" object:tf];
}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"选择王国"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIView * line0 = [MyControl createViewWithFrame:CGRectMake(0, 63, 320, 1)];
    line0.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.1];
    [navView addSubview:line0];
}
//-(void)createNavigation
//{
//    self.navigationController.navigationBar.translucent = 0;
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
//}
-(void)createHeader
{
    UIView * headerView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:headerView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.backgroundColor = BGCOLOR;
    alphaView.alpha = 0.85;
    [headerView addSubview:alphaView];
    
    UIImageView * search = [MyControl createImageViewWithFrame:CGRectMake(10, 13+29, 14, 13) ImageName:@"5-5.png"];
    [headerView addSubview:search];
    
    tf = [MyControl createTextFieldWithFrame:CGRectMake(30, 10+29, 480/2, 20) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    tf.borderStyle = 0;
//    tf.returnKeyType = UIReturnKeySearch;
//    tf.backgroundColor = BGCOLOR;
    tf.delegate = self;
    tf.textColor = [UIColor whiteColor];
    [headerView addSubview:tf];
    
    UIView * lineView = [MyControl createViewWithFrame:CGRectMake(10, 28+29, 30+460/2, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:246/255.0 green:189/255.0 blue:142/255.0 alpha:1];
    [headerView addSubview:lineView];
    
    cancelBtn = [MyControl createButtonWithFrame:CGRectMake(320-45, 8+29, 45, 20) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:@"取消"];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelBtn.showsTouchWhenHighlighted = YES;
    [headerView addSubview:cancelBtn];
}


-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.backgroundColor = [UIColor clearColor];
    tv.separatorStyle = 0;
    [self.view addSubview:tv];
}
#pragma mark - tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    AttentionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[AttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.tempDataArray[indexPath.row];
    
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

-(void)backBtnClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"af" object:nil];
}
-(void)cancelBtnClick
{
    NSLog(@"cancel");
    [tf resignFirstResponder];
    if ([cancelBtn.titleLabel.text isEqualToString:@"取消"]) {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"af" object:nil];
    }else{
        NSLog(@"start search!");
    }
}

//-(void)textFiledEditChanged:(NSNotification *)noti
//{
//    NSString * toBeString = tf.text;
//    NSString * lang = [[UITextInputMode currentInputMode] primaryLanguage];
//    if ([lang isEqualToString:@"zh-Hans"]) {
//        UITextRange * selectedRange = [tf markedTextRange];
//        //获取高亮部分
//        UITextPosition * position = [tf positionFromPosition:selectedRange.start offset:0];
//    }
//}
#pragma mark - textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    have = 1;
    //    [tv reloadData];
    [tf resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.tempDataArray removeAllObjects];
    [self.tempDataArray addObjectsFromArray:self.dataArray];
    [tv reloadData];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //string是最新输入的文字，textField的长度及字符要落后一个操作。
    if (![string isEqualToString:@""]) {
        [cancelBtn setTitle:@"搜索" forState:UIControlStateNormal];
    }else if(textField.text.length == 1){
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    if ([cancelBtn.titleLabel.text isEqualToString:@"搜索"]) {
        if ([string isEqualToString:@""]) {
            self.tfString = [self.tfString substringToIndex:textField.text.length-1];
        }else{
            self.tfString = [NSString stringWithFormat:@"%@%@", textField.text, string];
        }
        
    }else{
        self.tfString = nil;
    }
    NSLog(@"%@--%d--%@--%@", textField.text, textField.text.length, string, self.tfString);
    [self selectData];
    return YES;
}
-(void)selectData
{
    [self.tempDataArray removeAllObjects];
    if (self.tfString == nil) {
        [self.tempDataArray addObjectsFromArray:self.dataArray];
    }else{
        for (int i=0; i<self.dataArray.count; i++) {
            if ([self.dataArray[i] rangeOfString:self.tfString].location != NSNotFound) {
                [self.tempDataArray addObject:self.dataArray[i]];
            }
        }
    }
    [tv reloadData];
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
