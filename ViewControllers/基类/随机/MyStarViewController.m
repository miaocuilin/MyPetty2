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
#import "UserPetListModel.h"
#import "ChooseInViewController.h"
#import "PublishViewController.h"
#import "Alert_BegFoodViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <AviarySDK/AviarySDK.h>
static NSString * const kAFAviaryAPIKey = @"b681eafd0b581b46";
static NSString * const kAFAviarySecret = @"389160adda815809";

@interface MyStarViewController () <AFPhotoEditorControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BOOL isCamara;
    UIActionSheet * sheet;
}
@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;
@property(nonatomic,retain)UIImage * oriImage;
@end

@implementation MyStarViewController
-(void)viewWillAppear:(BOOL)animated
{
    if (isLoaded) {
//        [self.tv headerBeginRefreshing];
    }else if(![[USER objectForKey:@"guide_star"] intValue]){
        [self createGuide];
        [USER setObject:@"1" forKey:@"guide_star"];
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    isLoaded = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Allocate Asset Library
    ALAssetsLibrary * assetLibrary = [[ALAssetsLibrary alloc] init];
    [self setAssetLibrary:assetLibrary];
    
    // Allocate Sessions Array
    NSMutableArray * sessions = [NSMutableArray new];
    [self setSessions:sessions];
    [sessions release];
    
    // Start the Aviary Editor OpenGL Load
    [AFOpenGLManager beginOpenGLLoad];
    
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.userPetListArray = [NSMutableArray arrayWithCapacity:0];
    [self createBg];
    [self createTableView];
    [self createFakeNavigation];
//    [self loadMyPets];
    [self loadData];
    
    
}
-(void)createGuide
{
    guide = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"guide3.png"];
    float a = [UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height;
    float b = 320/480.0;
    if(a == b){
        guide.frame = CGRectMake(0, 0, self.view.frame.size.width, 568);
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [guide addGestureRecognizer:tap];
    
//    FirstTabBarViewController * tabBar = [ControllerManager shareTabBar];
    [[UIApplication sharedApplication].keyWindow addSubview:guide];
    [tap release];
}
-(void)tap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.2 animations:^{
        guide.alpha = 0;
    }completion:^(BOOL finished) {
        guide.hidden = YES;
    }];
}
-(void)createBg
{
    UIImageView * blueBg = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.png"];
    [self.view addSubview:blueBg];
}
-(void)createFakeNavigation
{
    
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIImageView * addImage = [MyControl createImageViewWithFrame:CGRectMake(17, 32+4, 17, 17) ImageName:@"moreBtn.png"];
    [navView addSubview:addImage];
    
    UIButton * addBtn = [MyControl createButtonWithFrame:CGRectMake(10, 32, 30, 25) ImageName:@"" Target:self Action:@selector(addBtnClick) Title:nil];
    addBtn.showsTouchWhenHighlighted = YES;
//    addBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:addBtn];

    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake((self.view.frame.size.width-100)/2.0, 32, 100, 20) Font:17 Text:@"我的萌星"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    
    camara = [MyControl createButtonWithFrame:CGRectMake(320-61/2-15, 64-51/2-7, 61/2, 51/2) ImageName:@"newCamara.png" Target:self Action:@selector(camaraClick) Title:nil];
    camara.showsTouchWhenHighlighted = YES;
    [navView addSubview:camara];
}
-(void)addBtnClick
{
    ChooseInViewController * vc = [[ChooseInViewController alloc] init];
    vc.isOldUser = YES;
    vc.isFromAdd = YES;
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)camaraClick
{
    self.tempAid = [USER objectForKey:@"aid"];
    self.tempName = @"";
    isBeg = NO;
    if ([ControllerManager getIsSuccess]) {
        if (sheet == nil) {
            // 判断是否支持相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
            }
            else {
                
                sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
            }
            
            sheet.tag = 255;
            
        }else{
            
        }
        [sheet showInView:self.view];
    }else{
        //提示注册
        ShowAlertView;
    }
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
//    if (!isLoaded) {
//        LOADING;
//    }

    NSString * url = [NSString stringWithFormat:@"%@%@", MYSTARAPI, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * requset = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"我的萌星：%@", load.dataDict);
            
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            [self.dataArray removeAllObjects];
            [USER setObject:[NSString stringWithFormat:@"%d", array.count] forKey:@"countryNum"];
            
            for (NSDictionary * dict in array) {
                MyStarModel * model = [[MyStarModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                model.dict = dict;
                model.images = [dict objectForKey:@"images"];
                [self.dataArray addObject:model];
                
                [model release];
            }
            //判断camara是否出现
            for(int i=0;i<self.dataArray.count;i++){
                if ([[self.dataArray[i] master_id] isEqualToString:[USER objectForKey:@"usr_id"]]) {
                    camara.hidden = NO;
                    break;
                }else if(i == self.dataArray.count-1){
                    camara.hidden = YES;
                }
            }
            
//            NSLog(@"%d", self.dataArray.count);
            //
            NSMutableArray * tempArray = [NSMutableArray arrayWithArray:self.dataArray];
            [self.dataArray removeAllObjects];
            for (int i=0; i<tempArray.count; i++) {
                if ([[tempArray[i] master_id] isEqualToString:[USER objectForKey:@"usr_id"]]) {
                    [self.dataArray addObject:tempArray[i]];
                    [tempArray removeObjectAtIndex:i];
                    i--;
                }
            }
            [self.dataArray addObjectsFromArray:tempArray];
            NSLog(@"%d", self.dataArray.count);
            
            [self.tv headerEndRefreshing];
            [self.tv reloadData];
//            ENDLOADING;
        }else{
            [self.tv headerEndRefreshing];
            if(![USER objectForKey:@"notAlertError"] && [[USER objectForKey:@"isSuccess"] intValue]){
                ENDLOADING;
                NSLog(@"========myStar========");
            }else{
                [USER setObject:@"0" forKey:@"notAlertError"];
            }
            
        }
    }];
    [requset release];
}

-(void)createTableView
{
    self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-25) style:UITableViewStylePlain];
    self.tv.dataSource = self;
    self.tv.delegate = self;
    self.tv.separatorStyle = 0;
    self.tv.backgroundColor = [UIColor clearColor];
    [self.tv addHeaderWithCallback:^{
        [self loadData];
    }];
    [self.view addSubview:self.tv];
    [self.tv release];
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
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
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
        [self.view addSubview:codeView];
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
//        MainViewController * mvc = [ControllerManager shareMain];
        if (a == 0) {
            //求口粮
            
            //请求API判断是否是否能发图
            LOADING;
            NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", model.aid]];
            NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", ALERT7DATAAPI, model.aid, sig, [ControllerManager getSID]];
            NSLog(@"%@", url);
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    NSLog(@"%@", load.dataDict);
                    if([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]] && ![[[load.dataDict objectForKey:@"data"] objectAtIndex:0] isKindOfClass:[NSDictionary class]]){
                        if ([model.master_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
                            
                            self.tempAid = model.aid;
                            self.tempName = model.name;
                            isBeg = YES;
                            
                            if (sheet == nil) {
                                // 判断是否支持相机
                                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                {
                                    sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
                                }
                                else {
                                    
                                    sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
                                }
                                
                                sheet.tag = 255;
                                
                            }
                            [sheet showInView:self.view];
                        }else{
                            [MyControl popAlertWithView:self.view Msg:[NSString stringWithFormat:@"萌星%@，今天还没挣口粮呢~", model.name]];
                        }
                        
                    }else{
                        //弹分享框
                        Alert_BegFoodViewController * vc = [[Alert_BegFoodViewController alloc] init];
                        vc.dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                        vc.name = model.name;
                        [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
//                        [vc release];
                    }
                    ENDLOADING;
                }else{
                    LOADFAILED;
                }
            }];
            [request release];

        }else if (a == 1) {
            
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
            shake.updateContri = ^(NSString * add_rq){
                //                NSLog(@"%@--%@", add_rq, cell.contributionLabel.text);
                int contri = [[cell.contributionLabel.text substringFromIndex:3] intValue];
                //                cell.contributionLabel.text = [NSString stringWithFormat:@"贡献度%d", contri+[add_rq intValue]];
                model.t_contri = [NSString stringWithFormat:@"%d", contri+[add_rq intValue]];
                [self.tv reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
                //                NSLog(@"%@--%d", cell.contributionLabel.text, contri+[add_rq intValue]);
            };
            [self addChildViewController:shake];
            [shake release];
            [shake didMoveToParentViewController:self];
            [shake becomeFirstResponder];
            [self.view addSubview:shake.view];
        }else if (a == 2) {
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
                int contri = [[cell.contributionLabel.text substringFromIndex:3] intValue];
                
                model.t_contri = [NSString stringWithFormat:@"%d", contri+[[[ControllerManager returnGiftDictWithItemId:itemId] objectForKey:@"add_rq"] intValue]];
                [self.tv reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                //
                //                MainViewController * main = [ControllerManager shareMain];
                ResultOfBuyView * result = [[ResultOfBuyView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                [UIView animateWithDuration:0.3 animations:^{
                    result.alpha = 1;
                }];
                result.confirm = ^(){
                    [vc closeGiftAction];
                };
                [result configUIWithName:self.pet_name ItemId:itemId Tx:self.pet_tx];
                [self.view addSubview:result];
                
                
            };
            [self addChildViewController:vc];
            [vc didMoveToParentViewController:self];
            
            [self.view addSubview:vc.view];
            [vc release];
            
            
            
            
//            if ([model.master_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
////                NSLog(@"叫一叫");
////                label.text = @"叫一叫";
//                
//                RecordViewController *shout = [[RecordViewController alloc] init];
//                shout.isFromStar = YES;
//                shout.recordBack = ^(void){
//                    label.text = @"叫过了";
//                    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:model.dict];
//                    [dict setObject:[NSNumber numberWithInt:1] forKey:@"is_voiced"];
//                    model.dict = dict;
//                    model.is_voiced = [NSNumber numberWithInt:1];
//                };
//                shout.pet_aid = self.pet_aid;
//                shout.pet_name = self.pet_name;
//                shout.pet_tx = self.pet_tx;
//                [self addChildViewController:shout];
//                [shout release];
//                [shout didMoveToParentViewController:self];
//                //        [shout createRecordOne];
//                [self.view addSubview:shout.view];
//            }else{
//                NSLog(@"摸一摸");
//                label.text = @"摸一摸";
            
//            }
        }else if (a == 3) {
            UILabel * label = (UILabel *)[cell viewWithTag:303];
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
            [self addChildViewController:touch];
            [touch release];
            [touch didMoveToParentViewController:self];
            [self.view addSubview:touch.view];
            
            
//            WalkAndTeaseViewController *walkAndTeasevc = [[WalkAndTeaseViewController alloc] init];
//            walkAndTeasevc.aid = self.pet_aid;
//            [self presentViewController:walkAndTeasevc animated:YES completion:nil];
//            [walkAndTeasevc release];
        }
    };
    cell.imageClick = ^(NSString * img_id){
        FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
        vc.img_id = img_id;

        [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
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

#pragma mark - 相机
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        [USER setObject:[NSString stringWithFormat:@"%d", buttonIndex] forKey:@"buttonIndex"];
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                    
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    isCamara = YES;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    isCamara = NO;
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                isCamara = NO;
            } else {
                return;
            }
        }
        //跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.sourceType = sourceType;
        
        if ([self hasValidAPIKey]) {
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }
        
        [imagePickerController release];
    }
}

#pragma mark - UIImagePicker Delegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@", info);
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    NSLog(@"%d", image.imageOrientation);
    image = [MyControl fixOrientation:image];
//    NSLog(@"%d", image.imageOrientation);
//    NSURL * assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
//    
//    void(^completion)(void)  = ^(void){
//        if (isCamara) {
//            [self lauchEditorWithImage:image];
//        }else{
//            [self lauchEditorWithImage:image];
            //            [[self assetLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            //                if (asset){
            //                    [self launchEditorWithAsset:asset];
            //                }
            //            } failureBlock:^(NSError *error) {
            //                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable access to your device's photos." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            //            }];
//        }};
    
//    [self dismissViewControllerAnimated:NO completion:completion];
    [self dismissViewControllerAnimated:NO completion:^{
        //Publish
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        PublishViewController * vc = [[PublishViewController alloc] init];
        if (isBeg) {
            vc.isBeg = isBeg;
        }
        vc.oriImage = image;
        vc.name = self.tempName;
        vc.aid = self.tempAid;
        vc.showFrontImage = ^(NSString * img_id){
            FrontImageDetailViewController * front = [[FrontImageDetailViewController alloc] init];
            front.img_id = img_id;
            [[UIApplication sharedApplication].keyWindow addSubview:front.view];
            [front release];
            
        };
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }];
    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - ALAssets Helper Methods

- (UIImage *)editingResImageForAsset:(ALAsset*)asset
{
    CGImageRef image = [[asset defaultRepresentation] fullScreenImage];
    
    return [UIImage imageWithCGImage:image scale:1.0 orientation:UIImageOrientationUp];
}

- (UIImage *)highResImageForAsset:(ALAsset*)asset
{
    ALAssetRepresentation * representation = [asset defaultRepresentation];
    
    CGImageRef image = [representation fullResolutionImage];
    UIImageOrientation orientation = (UIImageOrientation)[representation orientation];
    CGFloat scale = [representation scale];
    
    return [UIImage imageWithCGImage:image scale:scale orientation:orientation];
}

#pragma mark - Status Bar Style

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private Helper Methods

- (BOOL) hasValidAPIKey
{
    if ([kAFAviaryAPIKey isEqualToString:@"<YOUR-API-KEY>"] || [kAFAviarySecret isEqualToString:@"<YOUR-SECRET>"]) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                    message:@"You forgot to add your API key and secret!"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}

#pragma mark -图片编辑
#pragma mark =================================
#pragma mark - Photo Editor Launch Methods

//********************自己方法******************
-(void)lauchEditorWithImage:(UIImage *)image
{
    UIImage * editingResImage = image;
    UIImage * highResImage = image;
    [self launchPhotoEditorWithImage:editingResImage highResolutionImage:highResImage];
}

//*********************************************
- (void) launchEditorWithAsset:(ALAsset *)asset
{
    UIImage * editingResImage = [self editingResImageForAsset:asset];
    UIImage * highResImage = [self highResImageForAsset:asset];
    
    [self launchPhotoEditorWithImage:editingResImage highResolutionImage:highResImage];
}
#pragma mark - Photo Editor Creation and Presentation
- (void) launchPhotoEditorWithImage:(UIImage *)editingResImage highResolutionImage:(UIImage *)highResImage
{
    // Customize the editor's apperance. The customization options really only need to be set once in this case since they are never changing, so we used dispatch once here.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setPhotoEditorCustomizationOptions];
    });
    
    // Initialize the photo editor and set its delegate
    AFPhotoEditorController * photoEditor = [[AFPhotoEditorController alloc] initWithImage:editingResImage];
    [photoEditor setDelegate:self];
    
    // If a high res image is passed, create the high res context with the image and the photo editor.
    if (highResImage) {
        [self setupHighResContextForPhotoEditor:photoEditor withImage:highResImage];
    }
    
    // Present the photo editor.
    [self presentViewController:photoEditor animated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void) setupHighResContextForPhotoEditor:(AFPhotoEditorController *)photoEditor withImage:(UIImage *)highResImage
{
    // Capture a reference to the editor's session, which internally tracks user actions on a photo.
    __block AFPhotoEditorSession *session = [photoEditor session];
    
    // Add the session to our sessions array. We need to retain the session until all contexts we create from it are finished rendering.
    [[self sessions] addObject:session];
    
    // Create a context from the session with the high res image.
    AFPhotoEditorContext *context = [session createContextWithImage:highResImage];
    
    __block MyStarViewController * blockSelf = self;
    
    // Call render on the context. The render will asynchronously apply all changes made in the session (and therefore editor)
    // to the context's image. It will not complete until some point after the session closes (i.e. the editor hits done or
    // cancel in the editor). When rendering does complete, the completion block will be called with the result image if changes
    // were made to it, or `nil` if no changes were made. In this case, we write the image to the user's photo album, and release
    // our reference to the session.
    [context render:^(UIImage *result) {
        if (result) {
            //            UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
        }
        
        [[blockSelf sessions] removeObject:session];
        
        blockSelf = nil;
        session = nil;
        
    }];
}

#pragma Photo Editor Delegate Methods

// This is called when the user taps "Done" in the photo editor.
- (void) photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    self.oriImage = image;
    
    [self dismissViewControllerAnimated:YES completion:^{
        PublishViewController * vc = [[PublishViewController alloc] init];
        vc.oriImage = image;
        vc.aid = [USER objectForKey:@"aid"];
        vc.name = [USER objectForKey:@"a_name"];
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

// This is called when the user taps "Cancel" in the photo editor.
- (void) photoEditorCanceled:(AFPhotoEditorController *)editor
{
    int a = [[USER objectForKey:@"buttonIndex"] intValue];
    [self dismissViewControllerAnimated:YES completion:^{
        [self actionSheet:sheet clickedButtonAtIndex:a];
    }];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - Photo Editor Customization

- (void) setPhotoEditorCustomizationOptions
{
    // Set API Key and Secret
    [AFPhotoEditorController setAPIKey:kAFAviaryAPIKey secret:kAFAviarySecret];
    
    // Set Tool Order
    NSArray * toolOrder = @[kAFEffects, kAFFocus, kAFFrames, kAFStickers, kAFEnhance, kAFOrientation, kAFCrop, kAFAdjustments, kAFSplash, kAFDraw, kAFText, kAFRedeye, kAFWhiten, kAFBlemish, kAFMeme];
    [AFPhotoEditorCustomization setToolOrder:toolOrder];
    
    // Set Custom Crop Sizes
    [AFPhotoEditorCustomization setCropToolOriginalEnabled:NO];
    [AFPhotoEditorCustomization setCropToolCustomEnabled:YES];
    NSDictionary * fourBySix = @{kAFCropPresetHeight : @(4.0f), kAFCropPresetWidth : @(6.0f)};
    NSDictionary * fiveBySeven = @{kAFCropPresetHeight : @(5.0f), kAFCropPresetWidth : @(7.0f)};
    NSDictionary * square = @{kAFCropPresetName: @"Square", kAFCropPresetHeight : @(1.0f), kAFCropPresetWidth : @(1.0f)};
    [AFPhotoEditorCustomization setCropToolPresets:@[fourBySix, fiveBySeven, square]];
    
    // Set Supported Orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray * supportedOrientations = @[@(UIInterfaceOrientationPortrait), @(UIInterfaceOrientationPortraitUpsideDown), @(UIInterfaceOrientationLandscapeLeft), @(UIInterfaceOrientationLandscapeRight)];
        [AFPhotoEditorCustomization setSupportedIpadOrientations:supportedOrientations];
    }
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
