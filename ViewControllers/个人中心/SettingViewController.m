//
//  SettingViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-18.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "SettingViewController.h"
#import "AddressViewController.h"
#import "FeedbackViewController.h"
#import "SetDefaultPetViewController.h"
#import "AboutViewController.h"
#import "FAQViewController.h"
#import "RegisterViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

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
    self.arr1 = @[@"资料修改", @"收货地址", @"设置默认宠物", @"绑定新浪微博"];
    self.arr2 = @[@"新浪微博", @"微信朋友圈"];
    self.arr3 = @[@"清除缓存", @"检查更新", @"常见问题", @"意见反馈", @"赏个好评", @"关于我们"];
    
    [self createBg];
    [self createTableView];
    [self createFakeNavigation];
    
    [self createAlphaBtn];
}
-(void)createAlphaBtn
{
    alphaBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(hideSideMenu) Title:nil];
    alphaBtn.backgroundColor = [UIColor blackColor];
    alphaBtn.alpha = 0;
    alphaBtn.hidden = YES;
    [self.view addSubview:alphaBtn];
}
-(void)hideSideMenu
{
    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
    [menu hideMenuAnimated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        alphaBtn.alpha = 0;
    } completion:^(BOOL finished) {
        alphaBtn.hidden = YES;
        backBtn.selected = NO;
    }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [tv flashScrollIndicators];
}
-(void)createBg
{
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:self.bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
//    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"%@", data);
    UIImage * image = [UIImage imageWithData:data];
    self.bgImageView.image = image;

    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:tempView];
}

-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv.dataSource = self;
    tv.delegate = self;
    tv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tv];
    
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    tv.tableHeaderView = tempView;
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
    
    backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick:) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"设置"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}
-(void)backBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
    if (button.selected) {
        [menu showMenuAnimated:YES];
        alphaBtn.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            alphaBtn.alpha = 0.5;
        }];
    }else{
        [menu hideMenuAnimated:YES];
        [UIView animateWithDuration:0.25 animations:^{
            alphaBtn.alpha = 0;
        } completion:^(BOOL finished) {
            alphaBtn.hidden = YES;
        }];
    }
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if(section == 1){
        return 2;
    }else{
        return 6;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString * cellID = @"ID";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            sinaBind = [[UISwitch alloc] initWithFrame:CGRectMake(500/2, 7, 0, 0)];
            [sinaBind addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:sinaBind];
        }
        cell.textLabel.text =[NSString stringWithFormat:@"     %@",self.arr1[indexPath.row]];
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            sina = [[UISwitch alloc] initWithFrame:CGRectMake(500/2, 7, 0, 0)];
            if ([[USER objectForKey:@"sina"] intValue]) {
                sina.on = YES;
            }else{
                sina.on = NO;
            }
            
            [sina addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:sina];
        }else{
            weChat = [[UISwitch alloc] initWithFrame:CGRectMake(500/2, 7, 0, 0)];
            if ([[USER objectForKey:@"weChat"] intValue]) {
                weChat.on = YES;
            }else{
                weChat.on = NO;
            }
            [weChat addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:weChat];
        }
        
        cell.textLabel.text =[NSString stringWithFormat:@"     %@",self.arr2[indexPath.row]];
    }else{
        if (indexPath.row == 0) {
            cacheLabel = [MyControl createLabelWithFrame:CGRectMake(320-100-20, 10, 100, 20) Font:15 Text:nil];
            cacheLabel.textColor = [UIColor blackColor];
            cacheLabel.textAlignment = NSTextAlignmentRight;
            cacheLabel.text = [NSString stringWithFormat:@"%.1fMB", [self fileSizeForDir:DOCDIR]];
            [cell addSubview:cacheLabel];

        }
        cell.textLabel.text =[NSString stringWithFormat:@"     %@",self.arr3[indexPath.row]];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    [self normalCell:cell arrow:indexPath];
    return cell;
}
//设置箭头和初始化cell
- (void)normalCell:(UITableViewCell *)cell arrow:(NSIndexPath *)indexPath
{
    //右箭头
    if((indexPath.section == 0 && indexPath.row != 3) ||(indexPath.section == 2 && indexPath.row != 0)){
        UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(570/2, 10, 20, 20) ImageName:@"14-6-2.png"];
//        [cell addSubview:arrow];
        cell.accessoryView = arrow;
    }
    
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"账号设置";
    }else if(section == 1){
        return @"同步分享";
    }else{
        return @"其他";
    }
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            RegisterViewController * vc = [[RegisterViewController alloc] init];
            vc.isModify = YES;
            [self presentViewController:vc animated:YES completion:nil];
            [vc release];
        }else if (indexPath.row == 1) {
            NSLog(@"收货地址");
            AddressViewController *address = [[AddressViewController alloc]init];
            [self presentViewController:address animated:YES completion:^{
                [address release];
            }];
        }else if(indexPath.row == 2){
            NSLog(@"设置默认宠物");
            SetDefaultPetViewController * vc = [[SetDefaultPetViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
            [vc release];
        }
    }else if (indexPath.section == 1){
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [self clearData];
        }else if(indexPath.row == 2){
            FAQViewController * vc = [[FAQViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
            [vc release];
        }else if (indexPath.row == 3) {
            FeedbackViewController *feedBackVC = [[FeedbackViewController alloc] init];
            [self presentViewController:feedBackVC animated:YES completion:^{
                [feedBackVC release];
            }];
        }else if (indexPath.row == 5){
            AboutViewController * vc = [[AboutViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
            [vc release];
        }
    }
}

#pragma mark - switchChanged
-(void)switchChanged:(UISwitch *)_switch{
    if (_switch == sinaBind) {
        NSLog(@"%d", _switch.on);
    }else if(_switch == sina){
        NSLog(@"%d", _switch.on);
        if (_switch.on) {
            [USER setObject:@"1" forKey:@"sina"];
        }else{
            [USER setObject:@"0" forKey:@"sina"];
        }
    }else if(_switch == weChat){
        NSLog(@"%d", _switch.on);
        if (_switch.on) {
            [USER setObject:@"1" forKey:@"weChat"];
        }else{
            [USER setObject:@"0" forKey:@"weChat"];
        }
        
    }
}

#pragma mark - fileSize && clearData
//计算总文件大小
-(float)fileSizeForDir:(NSString*)path//计算文件夹下文件的总大小
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float size = 0;
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        //NSLog(@"%d--%@", array.count, [array objectAtIndex:i]);
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        if ([fullPath hasSuffix:@".plist"] || [fullPath rangeOfString:@"blurBg.png"].location != NSNotFound) {
            continue;
        }
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            //            NSDictionary *fileAttributeDic=[fileManager attributesOfFileSystemForPath:fullPath error:nil];
            size += fileAttributeDic.fileSize/ 1024.0/1024.0;
        }
        else
        {
            [self fileSizeForDir:fullPath];
        }
    }
    [fileManager release];
    return size;
}
#pragma mark -清除数据
-(void)clearData
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:@"清除中..."];
    
    NSString *cachPath = DOCDIR;
    //    NSLog(@"%@", cachPath);
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
//    NSLog(@"files :%d",[files count]);
    for (NSString *p in files) {
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        NSLog(@"%@", path);
        if (!([path hasSuffix:@".png"] || [path hasSuffix:@".jpg"] || [path hasSuffix:@".jpeg"] || [path hasSuffix:@".bmp"] || [path hasSuffix:@".mp3"])) {
            continue;
        }
        if ([path rangeOfString:@"blurBg.png"].location != NSNotFound) {
            continue;
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
    fileSize = [self fileSizeForDir:DOCDIR];
    cacheLabel.text = [NSString stringWithFormat:@"%.1fMB", fileSize];
    NSLog(@"%f", fileSize);
    
    [MMProgressHUD dismissWithSuccess:@"清除成功"];
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
