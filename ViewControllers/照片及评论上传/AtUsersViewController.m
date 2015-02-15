//
//  AtUsersViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-27.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "AtUsersViewController.h"
#import "AtUsersCell.h"
//#import "InfoModel.h"
#import "SingleTalkModel.h"

@interface AtUsersViewController ()

@end

@implementation AtUsersViewController

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
    self.selectArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArrayTemp = [NSMutableArray arrayWithCapacity:0];
    self.userIdsString = [NSMutableString stringWithCapacity:0];
    
    [self createBg];
    [self createFakeNavigation];
    [self createHeader];
    [self getNearTalkUserIds];
    [self createTableView];
    
    [self.view bringSubviewToFront:navView];
    [self.view bringSubviewToFront:headerView];
    
}
-(void)getNearTalkUserIds
{
    NSFileManager * manager = [[NSFileManager alloc] init];
    NSString * docDir = DOCDIR;
    NSString * path = [docDir stringByAppendingPathComponent:@"talkData.plist"];
    if ([manager fileExistsAtPath:path]) {
        //文件存在
        NSLog(@"文件存在");
        NSMutableDictionary * totalDict = [NSMutableDictionary dictionaryWithDictionary:[MyControl returnDictionaryWithDataPath:path]];
        
        [self.dataArray removeAllObjects];
        for (NSString * key in [totalDict allKeys]) {
            SingleTalkModel * model = [totalDict objectForKey:key];
//            InfoModel * model = [[InfoModel alloc] init];
//            [model setValuesForKeysWithDictionary:dic];
            if ([model.usr_tx intValue] == 1 || [model.usr_tx intValue] == 2 || [model.usr_tx intValue] == 3) {
                continue;
            }
            [self.dataArray addObject:model];
//            [model release];
        }
        self.dataArrayTemp = [NSMutableArray arrayWithArray:self.dataArray];
    }else{
        //文件不存在
        
    }
}
-(void)createBg
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:imageView];
//    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
//    [self.view addSubview:self.bgImageView];
//
////    NSString * docDir = DOCDIR;
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
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"@用户"];
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
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 35)];
    alphaView.backgroundColor = ORANGE;
    alphaView.alpha = 0.2;
    [headerView addSubview:alphaView];
    
    //
//    UIView * redView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 1)];
//    redView.backgroundColor = [UIColor redColor];
//    redView.alpha = 0.2;
//    [headerView addSubview:redView];
    
    UIImageView * search = [MyControl createImageViewWithFrame:CGRectMake(10, 13, 14, 13) ImageName:@"5-5.png"];
    [headerView addSubview:search];
    
    tf = [MyControl createTextFieldWithFrame:CGRectMake(30, 10, 560/2, 20) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    tf.borderStyle = 0;
    tf.returnKeyType = UIReturnKeySearch;
    //    tf.backgroundColor = BGCOLOR;
    tf.delegate = self;
    tf.textColor = [UIColor whiteColor];
    tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索最近联系的小伙伴~" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.8]}];
    [headerView addSubview:tf];
    
    UIView * lineView = [MyControl createViewWithFrame:CGRectMake(10, 28, 590/2, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:246/255.0 green:189/255.0 blue:142/255.0 alpha:1];
    [headerView addSubview:lineView];

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
    self.userIdsString = [NSMutableString stringWithString:@""];
    self.selectName = @"";
    
    if (self.selectArray.count>1) {
        NSString * str = [self.dataArray[[self.selectArray[0] intValue]] usr_name];
        self.selectName = [NSString stringWithFormat:@"@%@ 等小伙伴", str];
    }else if(self.selectArray.count == 1){
        NSString * str = [self.dataArray[[self.selectArray[0] intValue]] usr_name];
        self.selectName = [NSString stringWithFormat:@"@%@ 小伙伴", str];
    }
    for (int i=0; i<self.selectArray.count; i++) {
        NSString * usr_id = [self.dataArray[i] usr_id];
        if (i == 0) {
            [self.userIdsString appendString:usr_id];
        }else{
            [self.userIdsString appendFormat:@",%@", usr_id];
        }
    }
    NSLog(@"%@--%@", self.selectName, self.userIdsString);
    self.sendNameAndIds(self.selectName, self.userIdsString);
    if (self.selectName == nil || self.selectName.length == 0) {
//        StartLoading;
//        [MyControl loadingFailedWithContent:@"没有@用户哦~" afterDelay:0.7];
        [MyControl popAlertWithView:self.view Msg:@"没有@用户哦~"];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArrayTemp.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    AtUsersCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if (!cell) {
        cell = [[[AtUsersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    cell.click = ^(int a, BOOL select){
        NSLog(@"%d -- %d", a, select);
        if (select) {
            [self.selectArray addObject:[NSString stringWithFormat:@"%d", a]];
        }else{
            [self.selectArray removeObject:[NSString stringWithFormat:@"%d", a]];
        }
        NSLog(@"%@", self.selectArray);
//        [USER setObject:self.selectArray forKey:@"atUsers"];
    };
    
    cell.selectionStyle = 0;
    SingleTalkModel * model = self.dataArrayTemp[indexPath.row];
    
    if (self.selectArray.count == 0) {
        [cell modifyWith:model row:indexPath.row selected:NO];
    }
    for (int i=0; i<self.selectArray.count; i++) {
        if ([self.selectArray[i] intValue] == indexPath.row) {
            [cell modifyWith:model row:indexPath.row selected:YES];
            break;
        }else{
            if (i == self.selectArray.count-1) {
                [cell modifyWith:model row:indexPath.row selected:NO];
            }
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tf resignFirstResponder];
}

#pragma mark - textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.dataArrayTemp = [NSMutableArray arrayWithArray:self.dataArray];
    if (tf.text.length != 0) {
        for (SingleTalkModel * model in self.dataArray) {
            if ([model.usr_name rangeOfString:tf.text].location == NSNotFound) {
                [self.dataArrayTemp removeObject:model];
            }
        }
    }
    [tv reloadData];
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
