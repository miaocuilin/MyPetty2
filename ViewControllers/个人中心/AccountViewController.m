//
//  AccountViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "AccountViewController.h"
#import "AddressViewController.h"
#import "SetBlackListViewController.h"
#import "LoginViewController.h"
#import "SetPasswordViewController.h"
#import "InviteCodeModel.h"
#import "Alert_HyperlinkView.h"
#import "MessagePushSetViewController.h"
//#import "BlackListViewController.h"

@interface AccountViewController () <UMSocialUIDelegate>

@end

@implementation AccountViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[USER objectForKey:@"AccountShouldDismiss"] intValue]) {
        [USER setObject:@"0" forKey:@"AccountShouldDismiss"];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[USER objectForKey:@"confVersion"] isEqualToString:[USER objectForKey:@"versionKey"]]) {
        isConfVersion = YES;
    }
//    if(isConfVersion){
//        self.array = @[@"设置密码", @"切换账号", @"收货地址", @"解除黑名单", @"消息推送设置", @"同步分享到微信", @"同步分享到微博"];
//    }else{
//        self.array = @[@"设置密码", @"切换账号", @"收货地址", @"解除黑名单", @"填写邀请码", @"消息推送设置", @"同步分享到微信", @"同步分享到微博"];
//    }
    [self loadMyPets];
    [self createBg];
    [self createTableView];
    [self createFakeNavigation];
    
    //用于解除注册时设为1，第一次进入Login界面时直接返回的情况。
    if([[USER objectForKey:@"isLoginShouldDismiss"] intValue]){
        [USER setObject:@"0" forKey:@"isLoginShouldDismiss"];
    }
    
}
-(void)createBg
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:imageView];
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [self.view addSubview:view];
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
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"账号"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.backgroundColor = [UIColor clearColor];
    tv.separatorStyle = 0;
    tv.bounces = NO;
    [self.view addSubview:tv];
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    tv.tableHeaderView = view;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 43.5, self.view.frame.size.width, 0.5)];
        view.backgroundColor = LineGray;
        [cell addSubview:view];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"   %@", self.array[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
//    CGRect rect = cell.textLabel.frame;
//    rect.origin.x = 100;
//    cell.textLabel.frame = rect;
    
    cell.selectionStyle = 0;
    int a = 0;
    if (isConfVersion) {
        if (hasMyPet) {
            a = 4;
        }else{
            a = 3;
        }
    }else{
        if (hasMyPet) {
            a = 5;
        }else{
            a = 4;
        }
    }
    if (indexPath.row <= a) {
//        if (indexPath.row == a-1) {
//            //微信
//            if ([[USER objectForKey:@"wechat"] isKindOfClass:[NSString class]] && [[USER objectForKey:@"wechat"] length]) {
//                UILabel * label = [MyControl createLabelWithFrame:CGRectMake(self.view.frame.size.width-60, 10, 40, 20) Font:12 Text:@"已绑定"];
//                label.textColor = [UIColor blackColor];
//                cell.accessoryView = label;
//            }else{
//                UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(self.view.frame.size.width-40, 10, 20, 20) ImageName:@"14-6-2.png"];
//                cell.accessoryView = arrow;
//            }
//        }else if(indexPath.row == a){
//            //微博
//
////            NSLog(@"%@--%d--%d", [USER objectForKey:@"weibo"], [[USER objectForKey:@"weibo"] isKindOfClass:[NSString class]], [[USER objectForKey:@"weibo"] length]);
//            if ([[USER objectForKey:@"weibo"] isKindOfClass:[NSString class]] && [[USER objectForKey:@"weibo"] length]) {
//                UILabel * label = [MyControl createLabelWithFrame:CGRectMake(self.view.frame.size.width-60, 10, 40, 20) Font:12 Text:@"已绑定"];
//                label.textColor = [UIColor blackColor];
//                cell.accessoryView = label;
//            }else{
//                UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(self.view.frame.size.width-40, 10, 20, 20) ImageName:@"14-6-2.png"];
//                cell.accessoryView = arrow;
//            }
//        }else{
            //箭头
            UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(self.view.frame.size.width-40, 10, 20, 20) ImageName:@"14-6-2.png"];
            cell.accessoryView = arrow;
//        }
        
    }else{
        //switch
        UISwitch * swit = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50-10, 7, 50, 30)];
        [swit addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        swit.tag = 100+indexPath.row;
        [cell addSubview:swit];
        
        if(indexPath.row == a+1){
            //同步分享微信
            if ([[USER objectForKey:@"weChat"] intValue]) {
                swit.on = YES;
            }else{
                swit.on = NO;
            }
        }else if(indexPath.row == a+2){
            //同步分享微博
            if ([[USER objectForKey:@"sina"] intValue]) {
                swit.on = YES;
            }else{
                swit.on = NO;
            }
        }
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int x = indexPath.row;
    if (x == 0) {
        //设置密码
        SetPasswordViewController * vc = [[SetPasswordViewController alloc] init];
        if([[USER objectForKey:@"password"] isKindOfClass:[NSString class]] && [[USER objectForKey:@"password"] length]){
            vc.isModify = YES;
        }
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
        
    }else if (x == 1) {
        //切换账号
        NSLog(@"%d--%d", [[USER objectForKey:@"password"] isKindOfClass:[NSString class]], [[USER objectForKey:@"password"] length]);
//        if (![[USER objectForKey:@"password"] isKindOfClass:[NSString class]] || ![[USER objectForKey:@"password"] length]) {
            Alert_HyperlinkView * hyper = [[Alert_HyperlinkView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            hyper.type = 1;
        
            [hyper makeUI];
            [self.view addSubview:hyper];
            hyper.jumpSetPwd = ^(){
                SetPasswordViewController * set = [[SetPasswordViewController alloc] init];
                NSLog(@"%@", [USER objectForKey:@"password"]);
                if ([[USER objectForKey:@"password"] isKindOfClass:[NSString class]] && [[USER objectForKey:@"password"] length]) {
                    set.isModify = YES;
                }
                [self presentViewController:set animated:YES completion:nil];
                [set release];
            };
            hyper.jumpLogin = ^(){
                LoginViewController * vc = [[LoginViewController alloc] init];
                vc.isFromAccount = YES;
                [self presentViewController:vc animated:YES completion:nil];
                [vc release];
            };
            [hyper release];
//        }else{
//            LoginViewController * vc = [[LoginViewController alloc] init];
//            vc.isFromAccount = YES;
//            [self presentViewController:vc animated:YES completion:nil];
//            [vc release];
//        }
        
    }else if (x == 2) {
        if (hasMyPet) {
            //收货地址
            AddressViewController *address = [[AddressViewController alloc]init];
            address.pet_id = self.pet_id;
            [self presentViewController:address animated:YES completion:^{
                [address release];
            }];
        }else{
            //解除黑名单
            SetBlackListViewController * vc = [[SetBlackListViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
            [vc release];
        }
    }else if (x == 3) {
        if (hasMyPet) {
            //解除黑名单
            SetBlackListViewController * vc = [[SetBlackListViewController alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
            [vc release];
        }else{
            if (isConfVersion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MessagePushSetViewController * vc = [[MessagePushSetViewController alloc] init];
                    [self presentViewController:vc animated:YES completion:nil];
                    [vc release];
                });
            }else{
                //填写邀请码
                [self inputCode];
                //            [self loadMyPets];
            }
        }
    }else if(x == 4){
        if(hasMyPet){
            if (isConfVersion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MessagePushSetViewController * vc = [[MessagePushSetViewController alloc] init];
                    [self presentViewController:vc animated:YES completion:nil];
                    [vc release];
                });
                //微信绑定
                //            if (![[USER objectForKey:@"wechat"] length]) {
                //                [self bindWeChat];
                //            };
            }else{
                //填写邀请码
                [self inputCode];
                //            [self loadMyPets];
            }
        }else{
            if (!isConfVersion) {
                
                //            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
                dispatch_async(dispatch_get_main_queue(), ^{
                    MessagePushSetViewController * vc = [[MessagePushSetViewController alloc] init];
                    [self presentViewController:vc animated:YES completion:nil];
                    [vc release];
                });
                
                //            [nav release];
            }
        }
    }else if(x == 5){
        if (hasMyPet) {
            if (!isConfVersion) {
                
                //            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
                dispatch_async(dispatch_get_main_queue(), ^{
                    MessagePushSetViewController * vc = [[MessagePushSetViewController alloc] init];
                    [self presentViewController:vc animated:YES completion:nil];
                    [vc release];
                });
                
                //            [nav release];
            }
        }
//        if (!isConfVersion) {
//            
////            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                MessagePushSetViewController * vc = [[MessagePushSetViewController alloc] init];
//                [self presentViewController:vc animated:YES completion:nil];
//                [vc release];
//            });
//            
////            [nav release];
//        }
    }
//    else if(x == 5){
//        if (isConfVersion) {
//            //微博绑定
//            if (![[USER objectForKey:@"weibo"] length]) {
//                [self bindSina];
//            };
//        }else{
//            //微信绑定
//            if (![[USER objectForKey:@"wechat"] length]) {
//                [self bindWeChat];
//            };
//        }
//    }else if(x == 6){
//        if (!isConfVersion) {
//            //微博绑定
//            if (![[USER objectForKey:@"weibo"] length]) {
//                [self bindSina];
//            };
//        }
//    }
}
#pragma mark -
#pragma mark -
-(void)loadMyPets
{
    LOADING;
    //    user/petsApi&usr_id=(若用户为自己则留空不填)
    NSString * code = [NSString stringWithFormat:@"is_simple=0&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 0, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * array = [load.dataDict objectForKey:@"data"];
                //                if (array.count >= 10) {
                //                    AlertView * view = [[AlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                //                    view.AlertType = 6;
                //                    [view makeUI];
                //                    [self.view addSubview:view];
                //                    [view release];
                //                }else{
                
                //                }
                for (NSDictionary * dict in array) {
                    if ([[dict objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
                        hasMyPet = YES;
                        self.pet_id = [dict objectForKey:@"aid"];
                        break;
                    }
                }
                
                if(isConfVersion){
                    if (hasMyPet) {
                        self.array = @[@"设置密码", @"切换账号", @"收货地址", @"解除黑名单", @"消息推送设置", @"同步分享到微信", @"同步分享到微博"];
                    }else{
                        self.array = @[@"设置密码", @"切换账号", @"解除黑名单", @"消息推送设置", @"同步分享到微信", @"同步分享到微博"];
                    }
                    
                }else{
                    if (hasMyPet) {
                        self.array = @[@"设置密码", @"切换账号", @"收货地址", @"解除黑名单", @"填写邀请码", @"消息推送设置", @"同步分享到微信", @"同步分享到微博"];
                    }else{
                        self.array = @[@"设置密码", @"切换账号", @"解除黑名单", @"填写邀请码", @"消息推送设置", @"同步分享到微信", @"同步分享到微博"];
                    }
                    
                }
                [tv reloadData];
                ENDLOADING;
            }else{
                LOADFAILED;
            }
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}

#pragma mark -
-(void)inputCode
{
    if ([[USER objectForKey:@"inviter"] isKindOfClass:[NSString class]] && [[USER objectForKey:@"inviter"] intValue]) {
        //已经填写过 type=3
        NSString * inviter = [USER objectForKey:@"inviter"];
        InviteCodeModel * model = [[InviteCodeModel alloc] init];
        model.inviter = inviter;
        [self codeViewFailed:model];
        [model release];
        return;
    }
    
    CodeAlertView * codeView = [[CodeAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    codeView.AlertType = 1;
    [codeView makeUI];
    [self.view addSubview:codeView];
    [UIView animateWithDuration:0.2 animations:^{
        codeView.alpha = 1;
    }];
    codeView.confirmClick = ^(NSString * code){
        //        if (type == 3) {
        //            return;
        //        }
        
        //请求API
        LOADING;
        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"code=%@dog&cat", code]];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", INVITECODEAPI, code, sig, [ControllerManager getSID]];
        NSLog(@"%@", url);
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"%@", load.dataDict);
                InviteCodeModel * model = [[InviteCodeModel alloc] init];
                [model setValuesForKeysWithDictionary:[load.dataDict objectForKey:@"data"]];
                
                
                [codeView closeBtnClick];
                //成功提示
                NSLog(@"%@", [USER objectForKey:@"inviter"]);
                //                if ([[USER objectForKey:@"inviter"] isKindOfClass:[NSString class]] && [[USER objectForKey:@"inviter"] intValue]) {
                //                    [self codeViewFailed:model];
                //                }else{
                NSString * gold = [NSString stringWithFormat:@"%d", [[USER objectForKey:@"gold"] intValue]+300];
                [USER setObject:gold forKey:@"gold"];
                
                [self codeViewSuccess:model];
                [USER setObject:model.inviter forKey:@"inviter"];
                //                }
                
                [model release];
                ENDLOADING;
            }else{
                LOADFAILED;
//                [MyControl loadingFailedWithContent:@"加载失败" afterDelay:0.2];
            }
        }];
        [request release];
    };
}
-(void)codeViewSuccess:(InviteCodeModel *)model
{
    CodeAlertView * codeView = [[CodeAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    codeView.AlertType = 2;
    codeView.codeModel = model;
    [codeView makeUI];
    [self.view addSubview:codeView];
    [UIView animateWithDuration:0.2 animations:^{
        codeView.alpha = 1;
    }];
    codeView.confirmClick = ^(NSString * code){
        [codeView closeBtnClick];
    };
}
-(void)codeViewFailed:(InviteCodeModel *)model
{
    CodeAlertView * codeView = [[CodeAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    codeView.AlertType = 3;
    codeView.codeModel = model;
    [codeView makeUI];
    [self.view addSubview:codeView];
    [UIView animateWithDuration:0.2 animations:^{
        codeView.alpha = 1;
    }];
    codeView.confirmClick = ^(NSString * code){
        [codeView closeBtnClick];
    };
}
-(void)bindWeChat
{
    //绑微信
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
        if (response.viewControllerType == UMSViewControllerOauth) {
            NSLog(@"didFinishOauthAndGetAccount response is %@",response);
            if (response.responseCode == 200) {
                [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
                    NSLog(@"SnsInformation is %@",response.data);
                    NSDictionary * dic = (NSDictionary *)response.data;
                    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"wechat=%@dog&cat", [dic objectForKey:@"unionid"]]];
                    NSString * url = [NSString stringWithFormat:@"%@&wechat=%@&sig=%@&SID=%@", BIND3PARTYAPI, [dic objectForKey:@"unionid"], sig, [ControllerManager getSID]];
                    NSLog(@"%@", url);
                    LOADING;
                    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                        if (isFinish) {
                            if([[[load.dataDict objectForKey:@"data"] objectForKey:@"isBinded"] intValue]){
                                [USER setObject:[dic objectForKey:@"unionid"] forKey:@"wechat"];
                                [MyControl popAlertWithView:self.view Msg:@"绑定成功"];
                                [tv reloadData];
                            }else{
                                [MyControl popAlertWithView:self.view Msg:@"绑定失败"];
                            }
                            ENDLOADING;
                        }else{
                            LOADFAILED;
                        }
                    }];
                    [request release];
                }];
            }
        }
    });
}
-(void)bindSina
{
    //绑微博
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
        if (response.viewControllerType == UMSViewControllerOauth) {
            NSLog(@"didFinishOauthAndGetAccount response is %@",response);
            if (response.responseCode == 200) {
                [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                    NSLog(@"SnsInformation is %@",response.data);
                    NSDictionary * dic = (NSDictionary *)response.data;
                    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"weibo=%@dog&cat", [dic objectForKey:@"uid"]]];
                    NSString * url = [NSString stringWithFormat:@"%@&weibo=%@&sig=%@&SID=%@", BIND3PARTYAPI, [dic objectForKey:@"uid"], sig, [ControllerManager getSID]];
                    NSLog(@"%@", url);
                    LOADING;
                    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                        if (isFinish) {
                            if([[[load.dataDict objectForKey:@"data"] objectForKey:@"isBinded"] intValue]){
                                [USER setObject:[NSString stringWithFormat:@"%@", [dic objectForKey:@"uid"]] forKey:@"weibo"];
                                [MyControl popAlertWithView:self.view Msg:@"绑定成功"];
                                [tv reloadData];
                            }else{
                                [MyControl popAlertWithView:self.view Msg:@"绑定失败"];
                            }
                            ENDLOADING;
                        }else{
                            LOADFAILED;
                        }
                    }];
                    [request release];
                }];
            }
        }
    });
}
#pragma mark -
-(void)switchChange:(UISwitch *)swit
{
    int a = swit.tag-100;
//    if (isConfVersion) {
//        a -= 1;
//    }
    if (a == self.array.count-2) {
        //同步微信
        if (swit.on) {
            [USER setObject:@"1" forKey:@"weChat"];
        }else{
            [USER setObject:@"0" forKey:@"weChat"];
        }
        
    }else if (a == self.array.count-1) {
        //同步微博
        if (swit.on) {
            [USER setObject:@"1" forKey:@"sina"];
        }else{
            [USER setObject:@"0" forKey:@"sina"];
        }
    }
}
#pragma mark -

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
