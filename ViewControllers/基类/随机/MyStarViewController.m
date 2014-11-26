//
//  MyStarViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/6.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MyStarViewController.h"
#import "MyStarCell.h"
#import "MyStarModel.h"
#import "PicDetailViewController.h"
#import "PetInfoViewController.h"
#import "RockViewController.h"
#import "TouchViewController.h"
#import "RecordViewController.h"
#import "WalkAndTeaseViewController.h"
#import "SendGiftViewController.h"
#import "MainViewController.h"
#import "UserPetListModel.h"

@interface MyStarViewController ()

@end

@implementation MyStarViewController
-(void)viewWillAppear:(BOOL)animated
{
    MainViewController * main = [ControllerManager shareMain];
    if (isLoaded && main.sv.contentOffset.x == 0) {
        [self.tv headerBeginRefreshing];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    isLoaded = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.userPetListArray = [NSMutableArray arrayWithCapacity:0];
    [self createBg];
    [self createTableView];
//    [self loadMyPets];
    [self loadData];
}
//-(void)loadMyPets
//{
//    StartLoading;
//    NSString * code = [NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
//    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
//    NSLog(@"%@", url);
//    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            //            NSLog(@"%@", load.dataDict);
//            [self.userPetListArray removeAllObjects];
//            NSArray * array = [load.dataDict objectForKey:@"data"];
//            for (NSDictionary * dict in array) {
//                UserPetListModel * model = [[UserPetListModel alloc] init];
//                [model setValuesForKeysWithDictionary:dict];
//                [self.userPetListArray addObject:model];
//                [model release];
//            }
////            self.refreshData();
//            [self loadData];
//        }else{
//            LoadingFailed;
//            [self.tv headerEndRefreshing];
//        }
//    }];
//    [request release];
//}
-(void)loadData
{
    LOADING;
    NSString * url = [NSString stringWithFormat:@"%@%@", MYSTARAPI, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * requset = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"我的萌星：%@", load.dataDict);
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            [self.dataArray removeAllObjects];
            for (NSDictionary * dict in array) {
                MyStarModel * model = [[MyStarModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                model.dict = dict;
                model.images = [dict objectForKey:@"images"];
                [self.dataArray addObject:model];
                [model release];
            }
            [self.tv headerEndRefreshing];
            [self.tv reloadData];
            ENDLOADING;
        }else{
            [self.tv headerEndRefreshing];
            LOADFAILED;
        }
    }];
    [requset release];
}
-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"blurBg.png"];
    [self.view addSubview:bgImageView];
    
//    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
//    NSLog(@"%@", filePath);
//    NSData * data = [NSData dataWithContentsOfFile:filePath];
//    
//    UIImage * image = [UIImage imageWithData:data];
//    bgImageView.image = image;
//    
//    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
//    [self.view addSubview:tempView];
}
-(void)createTableView
{
    self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.tv.dataSource = self;
    self.tv.delegate = self;
    self.tv.separatorStyle = 0;
    self.tv.backgroundColor = [UIColor clearColor];
    [self.tv addHeaderWithCallback:^{
        [self loadData];
    }];
    [self.view addSubview:self.tv];
    [self.tv release];
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.tv.tableHeaderView = view;
}

#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
//-(void)refreshShakeNum:(int)shakeNum Index:(int)index
//{
//    MyStarModel * model = self.dataArray[index];
//    model.shake_count = [NSNumber numberWithInt:shakeNum];
//    [tv reloadData];
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    MyStarCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[MyStarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
//        [cell makeUIWithWidth:self.view.frame.size.width Height:322.0f];
    }
    MyStarModel * model = self.dataArray[indexPath.row];
    cell.inviteClick = ^(){
        //点击邀请
        MainViewController * vc = [ControllerManager shareMain];
        
        CodeAlertView * codeView = [[CodeAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        codeView.AlertType = 4;
        codeView.model = model;
        [codeView makeUI];
        codeView.shareClick = ^(int a, UIImage * image, NSString * code){
            [MobClick event:@"invite_share"];
            
            if (a == 0) {
                NSLog(@"微信");
                //强制分享图片
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:image location:nil urlResource:nil presentedController:vc completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        //                [self loadShareAPI];
                        //                shareNum.text = [NSString stringWithFormat:@"%d", [shareNum.text intValue]+1];
                        StartLoading;
                        [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
                    }else{
                        StartLoading;
                        [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
                    }
                    
                }];
            }else if(a == 1){
                NSLog(@"朋友圈");
                //强制分享图片
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:image location:nil urlResource:nil presentedController:vc completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        //                [self loadShareAPI];
                        //                shareNum.text = [NSString stringWithFormat:@"%d", [shareNum.text intValue]+1];
                        StartLoading;
                        [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
                    }else{
                        StartLoading;
                        [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
                    }
                    
                }];
            }else{
                NSLog(@"微博");
                NSString * str = [NSString stringWithFormat:@"我家萌星最闪亮！小伙伴们快来助力~~邀请码：%@，http://home4pet.aidigame.com/（分享自@宠物星球社交应用）", code];
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:image location:nil urlResource:nil presentedController:vc completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        //                [self loadShareAPI];
                        //                shareNum.text = [NSString stringWithFormat:@"%d", [shareNum.text intValue]+1];
                        StartLoading;
                        [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
                    }else{
                        NSLog(@"失败原因：%@", response);
                        StartLoading;
                        [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
                    }
                    
                }];
            }
        };
        [vc.view addSubview:codeView];
        [UIView animateWithDuration:0.2 animations:^{
            codeView.alpha = 1;
        }];
        codeView.confirmClick = ^(NSString * code){
//            [self reportImage];
//            [self cancelBtnClick2];
        };
        
    };
    cell.actClickSend = ^(NSString * aid, NSString * name, NSString * tx){
//        self.actClickSend(aid, name, tx);
        
        self.pet_aid = aid;
        self.pet_name = name;
        self.pet_tx = tx;
    };
    cell.headClick = ^(NSString * aid){
        PetInfoViewController * vc = [[PetInfoViewController alloc] init];
        vc.aid = aid;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    };
    cell.actClick = ^(int a){
//        self.actClick(a, indexPath.row);
        MainViewController * mvc = [ControllerManager shareMain];
        if (a == 0) {
            RockViewController *shake = [[RockViewController alloc] init];
            shake.isFromStar = YES;
            shake.titleString = @"摇一摇";
//            shake.animalInfoDict = self.shakeInfoDict;
            shake.pet_aid = self.pet_aid;
            shake.pet_name = self.pet_name;
            shake.pet_tx = self.pet_tx;
            shake.unShakeNum = ^(int a){
                NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:model.dict];
                [dict setObject:[NSNumber numberWithInt:1] forKey:@"shake_count"];
                model.dict = dict;
                model.shake_count = [NSNumber numberWithInt:a];
                [self.tv reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
           
            [mvc addChildViewController:shake];
            [shake release];
            [shake didMoveToParentViewController:mvc];
            [shake becomeFirstResponder];
            [mvc.view addSubview:shake.view];

        }else if (a == 1) {
            SendGiftViewController * vc = [[SendGiftViewController alloc] init];
            vc.receiver_aid = self.pet_aid;
            vc.receiver_name = self.pet_name;
            vc.hasSendGift = ^(NSString * itemId){
                NSLog(@"赠送礼物给默认宠物成功!");
                if ([[model.dict objectForKey:@"gift_count"] isKindOfClass:[NSNull class]]) {
                    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:model.dict];
                    [dict setObject:[NSNumber numberWithInt:1] forKey:@"gift_count"];
                    model.dict = dict;
                    model.gift_count = [NSNumber numberWithInt:1];
                }else{
                    model.gift_count = [NSNumber numberWithInt:[model.gift_count intValue]+1];
                }
                [self.tv reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                //
                MainViewController * main = [ControllerManager shareMain];
                ResultOfBuyView * result = [[ResultOfBuyView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                [UIView animateWithDuration:0.3 animations:^{
                    result.alpha = 1;
                }];
                result.confirm = ^(){
                    [vc closeGiftAction];
                };
                [result configUIWithName:self.pet_name ItemId:itemId Tx:self.pet_tx];
                [main.view addSubview:result];
                
                
            };
            [mvc addChildViewController:vc];
            [vc didMoveToParentViewController:mvc];
            
            [mvc.view addSubview:vc.view];
            [vc release];
        }else if (a == 2) {
            UILabel * label = (UILabel *)[cell viewWithTag:302];
            if ([model.master_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
//                NSLog(@"叫一叫");
//                label.text = @"叫一叫";
                
                RecordViewController *shout = [[RecordViewController alloc] init];
                shout.isFromStar = YES;
                shout.recordBack = ^(void){
                    label.text = @"叫过了";
                    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:model.dict];
                    [dict setObject:[NSNumber numberWithInt:1] forKey:@"is_voiced"];
                    model.dict = dict;
                    model.is_voiced = [NSNumber numberWithInt:1];
                };
                shout.pet_aid = self.pet_aid;
                shout.pet_name = self.pet_name;
                shout.pet_tx = self.pet_tx;
                [mvc addChildViewController:shout];
                [shout release];
                [shout didMoveToParentViewController:mvc];
                //        [shout createRecordOne];
                [mvc.view addSubview:shout.view];
            }else{
//                NSLog(@"摸一摸");
//                label.text = @"摸一摸";
                
                TouchViewController *touch = [[TouchViewController alloc] init];
                touch.isFromStar = YES;
                touch.touchBack = ^(void){
                    label.text = @"摸过了";
                    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:model.dict];
                    [dict setObject:[NSNumber numberWithInt:1] forKey:@"is_touched"];
                    model.dict = dict;
                    model.is_touched = [NSNumber numberWithInt:1];
                };
                touch.pet_aid = self.pet_aid;
                touch.pet_name = self.pet_name;
                touch.pet_tx = self.pet_tx;
                [mvc addChildViewController:touch];
                [touch release];
                [touch didMoveToParentViewController:mvc];
                [mvc.view addSubview:touch.view];
            }
        }else if (a == 3) {
            WalkAndTeaseViewController *walkAndTeasevc = [[WalkAndTeaseViewController alloc] init];
            walkAndTeasevc.aid = self.pet_aid;
            [self presentViewController:walkAndTeasevc animated:YES completion:nil];
            [walkAndTeasevc release];
        }
    };
    cell.imageClick = ^(NSString * img_id){
        FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
        vc.img_id = img_id;
        
        MainViewController * main = [ControllerManager shareMain];
        [main.view addSubview:vc.view];
        [vc release];
    };
    [cell adjustCellHeight:model.images.count];
    [cell configUI:model];
    cell.clipsToBounds = YES;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = 0;
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyStarModel * model = self.dataArray[indexPath.row];
    if (!model.images.count) {
        return 263.0f;
    }else{
        return 710.0/2;
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
