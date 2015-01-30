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
#import "SetBlackListViewController.h"
#import "InviteCodeModel.h"
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
    
//    if ([[USER objectForKey:@"confVersion"] isEqualToString:@"1.0"]) {
//        isConfVersion = YES;
//    }
    
//    if(isConfVersion){
//        self.arr1 = @[@"收货地址", @"设置最爱萌星", @"解除黑名单", @"绑定新浪微博"];
//        self.arr3 = @[@"清除缓存", @"常见问题", @"意见反馈", @"关于我们"];
//    }else{
//        self.arr1 = @[@"收货地址", @"填写邀请码", @"设置最爱萌星", @"解除黑名单", @"绑定新浪微博"];
        self.arr3 = @[@"清除缓存", @"打赏提示", @"常见问题", @"意见反馈", @"关于我们"];
//    }
    
//    self.arr2 = @[@"新浪微博", @"微信朋友圈"];
    
    
    [self createBg];
    [self createTableView];
    [self createFakeNavigation];
    
//    [self createAlphaBtn];
}
//-(void)createAlphaBtn
//{
//    alphaBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(hideSideMenu) Title:nil];
//    alphaBtn.backgroundColor = [UIColor blackColor];
//    alphaBtn.alpha = 0;
//    alphaBtn.hidden = YES;
//    [self.view addSubview:alphaBtn];
//}
//-(void)hideSideMenu
//{
//    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
//    [menu hideMenuAnimated:YES];
//    [UIView animateWithDuration:0.25 animations:^{
//        alphaBtn.alpha = 0;
//    } completion:^(BOOL finished) {
//        alphaBtn.hidden = YES;
//        backBtn.selected = NO;
//    }];
//}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [tv flashScrollIndicators];
//}
-(void)createBg
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:imageView];
    
    UIView * alpha = [MyControl createViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    alpha.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [self.view addSubview:alpha];
//    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
//    [self.view addSubview:self.bgImageView];
//    //    self.bgImageView.backgroundColor = [UIColor redColor];
////    NSString * docDir = DOCDIR;
//    NSString * filePath = BLURBG;
////    NSLog(@"%@", filePath);
//    NSData * data = [NSData dataWithContentsOfFile:filePath];
//    //    NSLog(@"%@", data);
//    UIImage * image = [UIImage imageWithData:data];
//    self.bgImageView.image = image;
//
//    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
//    [self.view addSubview:tempView];
}

-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tv.dataSource = self;
    tv.delegate = self;
    tv.separatorStyle = 0;
    tv.bounces = NO;
    tv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tv];
    
//    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
//    tv.tableHeaderView = tempView;
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
    [self dismissViewControllerAnimated:YES completion:nil];
//    button.selected = !button.selected;
//    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
//    if (button.selected) {
//        [menu showMenuAnimated:YES];
//        alphaBtn.hidden = NO;
//        [UIView animateWithDuration:0.25 animations:^{
//            alphaBtn.alpha = 0.5;
//        }];
//    }else{
//        [menu hideMenuAnimated:YES];
//        [UIView animateWithDuration:0.25 animations:^{
//            alphaBtn.alpha = 0;
//        } completion:^(BOOL finished) {
//            alphaBtn.hidden = YES;
//        }];
//    }
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return self.arr1.count;
//    }else if(section == 1){
//        return 2;
//    }else{
        return self.arr3.count;
//    }
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 3;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString * cellID = @"ID";
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 1)];
        view.backgroundColor = LineGray;
        [cell addSubview:view];
    }
    
//    if (indexPath.section == 0) {
//        int a = 0;
//        if (isConfVersion) {
//            a = 3;
//        }else{
//            a = 4;
//        }
//        if (indexPath.row == a) {
//            sinaBind = [[UISwitch alloc] initWithFrame:CGRectMake(500/2, 7, 0, 0)];
//            [sinaBind addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//            [cell addSubview:sinaBind];
//            BOOL isOauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
//            if (isOauth) {
//                sinaBind.on = YES;
//            }else{
//                sinaBind.on = NO;
//            }
//        }
//        cell.textLabel.text =[NSString stringWithFormat:@"     %@",self.arr1[indexPath.row]];
//        if (![[USER objectForKey:@"isSuccess"] intValue]) {
//            cell.textLabel.textColor = [ControllerManager colorWithHexString:@"a2a2a2"];
//            sinaBind.userInteractionEnabled = NO;
//        }
//    }else if(indexPath.section == 1){
//        if (indexPath.row == 0) {
//            sina = [[UISwitch alloc] initWithFrame:CGRectMake(500/2, 7, 0, 0)];
//            if ([[USER objectForKey:@"sina"] intValue]) {
//                sina.on = YES;
//            }else{
//                sina.on = NO;
//            }
//            
//            [sina addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//            [cell addSubview:sina];
//        }else{
//            weChat = [[UISwitch alloc] initWithFrame:CGRectMake(500/2, 7, 0, 0)];
//            if ([[USER objectForKey:@"weChat"] intValue]) {
//                weChat.on = YES;
//            }else{
//                weChat.on = NO;
//            }
//            [weChat addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//            [cell addSubview:weChat];
//        }
//        
//        cell.textLabel.text =[NSString stringWithFormat:@"     %@",self.arr2[indexPath.row]];
//        if (![[USER objectForKey:@"isSuccess"] intValue]) {
//            cell.textLabel.textColor = [ControllerManager colorWithHexString:@"a2a2a2"];
//            sina.userInteractionEnabled = NO;
//            weChat.userInteractionEnabled = NO;
//        }
//    }else{
        if (indexPath.row == 0) {
            cacheLabel = [MyControl createLabelWithFrame:CGRectMake(320-100-20, 10, 100, 20) Font:15 Text:nil];
            cacheLabel.textColor = [UIColor blackColor];
            cacheLabel.textAlignment = NSTextAlignmentRight;
            cacheLabel.text = [NSString stringWithFormat:@"%.1fMB", [self fileSizeForDir:DOCDIR]];
            [cell addSubview:cacheLabel];

        }else if(indexPath.row == 1){
            _switch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50-20, 7, 0, 0)];
            [_switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:_switch];
            if ([[USER objectForKey:@"showCostAlert"] intValue] == 0) {
                _switch.on = NO;
            }else{
                _switch.on = YES;
            }
        }
        cell.textLabel.text =[NSString stringWithFormat:@"     %@",self.arr3[indexPath.row]];
        cell.textLabel.textColor = [UIColor blackColor];
//    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    [self normalCell:cell arrow:indexPath];
    
    return cell;
}
-(void)switchChanged:(UISwitch *)sw
{
    if (sw.on) {
        [USER setObject:@"1" forKey:@"showCostAlert"];
    }else{
        [USER setObject:@"0" forKey:@"showCostAlert"];
    }
}
//设置箭头和初始化cell
- (void)normalCell:(UITableViewCell *)cell arrow:(NSIndexPath *)indexPath
{
    //右箭头
    UIImageView * arrow = nil;
//    int a = 0;
//    if (isConfVersion) {
//        a = 3;
//    }else{
//        a = 4;
//    }
//    if((indexPath.section == 0 && indexPath.row != a) ||(indexPath.section == 2 && indexPath.row != 0)){
    if (indexPath.row > 1) {
        arrow = [MyControl createImageViewWithFrame:CGRectMake(570/2, 10, 20, 20) ImageName:@"14-6-2.png"];
        //        [cell addSubview:arrow];
        cell.accessoryView = arrow;
    }
    
//    }
//    if (![[USER objectForKey:@"isSuccess"] intValue] && (indexPath.section == 0 || indexPath.section == 1)) {
//        cell.accessoryView.alpha = 0.3;
////        arrow.backgroundColor = [UIColor redColor];
//    }
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"账号设置";
//    }else if(section == 1){
//        return @"同步分享";
//    }else{
//        return @"其他";
//    }
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//    
//    UIView * view2 = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//    view2.backgroundColor = [UIColor lightGrayColor];
//    view2.alpha = 0.5;
//    [view addSubview:view2];
//    
//    UILabel * label = [MyControl createLabelWithFrame:CGRectMake(15, 0, 100, 30) Font:14 Text:nil];
//    label.textColor = [UIColor blackColor];
//    [view addSubview:label];
//    
//    if (section == 0) {
//        label.text = @"账号设置";
//        return view;
//    }else if(section == 1){
//        label.text = @"同步分享";
//        return view;
//    }else{
//        label.text = @"其他";
//        return view;
//    }
//
//}
//-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        if (![[USER objectForKey:@"isSuccess"] intValue]) {
//            return;
//        }
//        if (indexPath.row == 0) {
//            NSLog(@"收货地址");
//            AddressViewController *address = [[AddressViewController alloc]init];
//            [self presentViewController:address animated:YES completion:^{
//                [address release];
//            }];
//        }else if (indexPath.row == 1) {
//            if (isConfVersion) {
//                NSLog(@"设置默认宠物");
//                SetDefaultPetViewController * vc = [[SetDefaultPetViewController alloc] init];
//                [self presentViewController:vc animated:YES completion:nil];
//                [vc release];
//            }else{
//                NSLog(@"填写邀请码");
//                [self loadMyPets];
//            }
//            
//        }else if (indexPath.row == 2){
//            if (isConfVersion) {
//                NSLog(@"设置黑名单");
//                SetBlackListViewController * vc = [[SetBlackListViewController alloc] init];
//                [self presentViewController:vc animated:YES completion:nil];
//                [vc release];
//            }else{
//                NSLog(@"设置默认宠物");
//                SetDefaultPetViewController * vc = [[SetDefaultPetViewController alloc] init];
//                [self presentViewController:vc animated:YES completion:nil];
//                [vc release];
//            }
//        }else if (indexPath.row == 3){
//            if (!isConfVersion) {
//                NSLog(@"设置黑名单");
//                SetBlackListViewController * vc = [[SetBlackListViewController alloc] init];
//                [self presentViewController:vc animated:YES completion:nil];
//                [vc release];
//            }
//        }
//    }else if (indexPath.section == 1){
//        
//    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [self clearData];
        }else if(indexPath.row == 1){
//            if(isConfVersion){
//                FAQViewController * vc = [[FAQViewController alloc] init];
//                [self presentViewController:vc animated:YES completion:nil];
//                [vc release];
//            }else{
//                //upgrade
//                
//            }
            
//            [USER setObject:@"" forKey:@"isSuccess"];
//            [USER setObject:@"" forKey:@"SID"];
//            [ControllerManager setIsSuccess:0];
//            [ControllerManager setSID:@""];
//            StartLoading;
//            [MMProgressHUD dismissWithSuccess:@"重置成功" title:nil afterDelay:0.5f];
        }if(indexPath.row == 2){
//            if (isConfVersion) {
//                FeedbackViewController *feedBackVC = [[FeedbackViewController alloc] init];
//                [self presentViewController:feedBackVC animated:YES completion:^{
//                    [feedBackVC release];
//                }];
//            }else{
                FAQViewController * vc = [[FAQViewController alloc] init];
                [self presentViewController:vc animated:YES completion:nil];
                [vc release];
//            }
            
        }else if (indexPath.row == 3) {
//            AboutViewController * vc = [[AboutViewController alloc] init];
//            [self presentViewController:vc animated:YES completion:nil];
//            [vc release];
//            if (isConfVersion) {
//                //好评
//            }else{
                FeedbackViewController *feedBackVC = [[FeedbackViewController alloc] init];
                [self presentViewController:feedBackVC animated:YES completion:^{
                    [feedBackVC release];
                }];
//            }
        }
        else if (indexPath.row == 4){
//            if (isConfVersion) {
                AboutViewController * vc = [[AboutViewController alloc] init];
                [self presentViewController:vc animated:YES completion:nil];
                [vc release];
//            }else{
//                //好评
//            }
        }
//            else if(indexPath.row == 5){
//            if (isConfVersion) {
//                
//            }else{
//                AboutViewController * vc = [[AboutViewController alloc] init];
//                [self presentViewController:vc animated:YES completion:nil];
//                [vc release];
//            }
//        }
//    }
}
#pragma mark -
//-(void)loadMyPets
//{
//    StartLoading;
//    //    user/petsApi&usr_id=(若用户为自己则留空不填)
//    NSString * code = [NSString stringWithFormat:@"is_simple=0&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
//    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 0, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
//    NSLog(@"%@", url);
//    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            NSLog(@"%@", load.dataDict);
//            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
//                NSArray * array = [load.dataDict objectForKey:@"data"];
////                if (array.count >= 10) {
////                    AlertView * view = [[AlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
////                    view.AlertType = 6;
////                    [view makeUI];
////                    [self.view addSubview:view];
////                    [view release];
////                }else{
//                    [self inputCode];
////                }
//                LoadingSuccess;
//            }else{
//                LoadingFailed;
//            }
//        }else{
//            LoadingFailed;
//        }
//    }];
//    [request release];
//}

#pragma mark -
//-(void)inputCode
//{
//    if ([[USER objectForKey:@"inviter"] isKindOfClass:[NSString class]] && [[USER objectForKey:@"inviter"] intValue]) {
//        //已经填写过 type=3
//        NSString * inviter = [USER objectForKey:@"inviter"];
//        InviteCodeModel * model = [[InviteCodeModel alloc] init];
//        model.inviter = inviter;
//        [self codeViewFailed:model];
//        return;
//    }
//    
//    CodeAlertView * codeView = [[CodeAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    codeView.AlertType = 1;
//    [codeView makeUI];
//    [self.view addSubview:codeView];
//    [UIView animateWithDuration:0.2 animations:^{
//        codeView.alpha = 1;
//    }];
//    codeView.confirmClick = ^(NSString * code){
////        if (type == 3) {
////            return;
////        }
//        
//        //请求API
//        StartLoading;
//        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"code=%@dog&cat", code]];
//        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", INVITECODEAPI, code, sig, [ControllerManager getSID]];
//        NSLog(@"%@", url);
//        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//            if (isFinish) {
//                NSLog(@"%@", load.dataDict);
//                InviteCodeModel * model = [[InviteCodeModel alloc] init];
//                [model setValuesForKeysWithDictionary:[load.dataDict objectForKey:@"data"]];
//                
//                
//                [codeView closeBtnClick];
//                //成功提示
//                NSLog(@"%@", [USER objectForKey:@"inviter"]);
////                if ([[USER objectForKey:@"inviter"] isKindOfClass:[NSString class]] && [[USER objectForKey:@"inviter"] intValue]) {
////                    [self codeViewFailed:model];
////                }else{
//                    NSString * gold = [NSString stringWithFormat:@"%d", [[USER objectForKey:@"gold"] intValue]+300];
//                    [USER setObject:gold forKey:@"gold"];
//                    
//                    [self codeViewSuccess:model];
//                    [USER setObject:model.inviter forKey:@"inviter"];
////                }
//                
//                [model release];
//                LoadingSuccess;
//            }else{
//                [MyControl loadingFailedWithContent:@"加载失败" afterDelay:0.2];
//            }
//        }];
//        [request release];
//    };
//}
//-(void)codeViewSuccess:(InviteCodeModel *)model
//{
//    CodeAlertView * codeView = [[CodeAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    codeView.AlertType = 2;
//    codeView.codeModel = model;
//    [codeView makeUI];
//    [self.view addSubview:codeView];
//    [UIView animateWithDuration:0.2 animations:^{
//        codeView.alpha = 1;
//    }];
//    codeView.confirmClick = ^(NSString * code){
//        [codeView closeBtnClick];
//    };
//}
//-(void)codeViewFailed:(InviteCodeModel *)model
//{
//    CodeAlertView * codeView = [[CodeAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    codeView.AlertType = 3;
//    codeView.codeModel = model;
//    [codeView makeUI];
//    [self.view addSubview:codeView];
//    [UIView animateWithDuration:0.2 animations:^{
//        codeView.alpha = 1;
//    }];
//    codeView.confirmClick = ^(NSString * code){
//        [codeView closeBtnClick];
//    };
//}
//#pragma mark - switchChanged
//-(void)switchChanged:(UISwitch *)_switch{
//    if (_switch == sinaBind) {
//        NSLog(@"%d", _switch.on);
//        if (_switch.on) {
//            //绑定
//            NSLog(@"绑定");
////            [MyControl startLoadingWithStatus:@"绑定中..."];
//            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//                NSLog(@"response is %@",response);
//                if (![UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina]) {
//                    StartLoading;
//                    [MyControl loadingFailedWithContent:@"绑定失败或取消绑定" afterDelay:0.5];
//                    _switch.on = NO;
//                }else{
//                    StartLoading;
//                    [MyControl loadingSuccessWithContent:@"绑定成功" afterDelay:0.5];
//                    _switch.on = YES;
//                }
//            });
//            
//        }else{
//            //解绑
//            NSLog(@"解绑");
//            [MyControl startLoadingWithStatus:@"解绑中..."];
//            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
//                NSLog(@"response is %@",response);
//                if (![UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina]) {
//                    [MyControl loadingSuccessWithContent:@"解绑成功" afterDelay:0.5];
//                    _switch.on = NO;
//                }else{
//                    [MyControl loadingFailedWithContent:@"解绑失败" afterDelay:0.5];
//                    _switch.on = YES;
//                }
//            }];
//        }
//        
//    }else if(_switch == sina){
//        NSLog(@"%d", _switch.on);
//        if (_switch.on) {
//            [USER setObject:@"1" forKey:@"sina"];
//        }else{
//            [USER setObject:@"0" forKey:@"sina"];
//        }
//    }else if(_switch == weChat){
//        NSLog(@"%d", _switch.on);
//        if (_switch.on) {
//            [USER setObject:@"1" forKey:@"weChat"];
//        }else{
//            [USER setObject:@"0" forKey:@"weChat"];
//        }
//        
//    }
//}

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
        if ([fullPath hasSuffix:@".plist"] || [fullPath rangeOfString:@"blurBg.jpg"].location != NSNotFound) {
            continue;
        }
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            //            NSDictionary *fileAttributeDic=[fileManager attributesOfFileSystemForPath:fullPath error:nil];
            size += fileAttributeDic.fileSize/ 1024.0/1024.0;
        }
//        else
//        {
//            [self fileSizeForDir:fullPath];
//        }
    }
    [fileManager release];
    
    SDImageCache * cache = [SDImageCache sharedImageCache];
    size += [cache getSize]/1024.0/1024.0;
    
    return size;
}
#pragma mark -清除数据
-(void)clearData
{
    LOADING;
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//    [MMProgressHUD showWithStatus:@"清除中..."];
    
    NSString *cachPath = DOCDIR;
        NSLog(@"%@", cachPath);
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
//    NSLog(@"files :%d",[files count]);
    for (NSString *p in files) {
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        NSLog(@"%@", path);
        if (!([path hasSuffix:@".png"] || [path hasSuffix:@".jpg"] || [path hasSuffix:@".jpeg"] || [path hasSuffix:@".bmp"] || [path hasSuffix:@".mp3"])) {
            continue;
        }
        if ([path rangeOfString:@"blurBg.jpg"].location != NSNotFound) {
            continue;
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
    fileSize = [self fileSizeForDir:DOCDIR];
    
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearDisk];
    
    cacheLabel.text = [NSString stringWithFormat:@"%.1fMB", 0.0];
    NSLog(@"%f", fileSize);
    
    [self performSelector:@selector(done) withObject:nil afterDelay:1];
    
//    [MMProgressHUD dismissWithSuccess:@"清除成功"];
}
-(void)done
{
    ENDLOADING;
    [MyControl popAlertWithView:self.view Msg:@"清除成功"];
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
