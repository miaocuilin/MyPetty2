//
//  UserInfoViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoActivityCell.h"
#import "UserInfoRankCell.h"
#import "UserPetListModel.h"
#import "PetInfoModel.h"
#import "ChooseInViewController.h"
#import "TalkViewController.h"
#import "UserActivityListModel.h"
#import "PicDetailViewController.h"
#import "ModifyPetOrUserInfoViewController.h"
//@class PetInfoViewController;

@interface UserInfoViewController ()
{
    NSDictionary *headerDict;
}
@end

@implementation UserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userPetListArray = [NSMutableArray arrayWithCapacity:0];
    self.userAttentionListArray = [NSMutableArray arrayWithCapacity:0];
    self.userActivityListArray = [NSMutableArray arrayWithCapacity:0];
    
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    self.goodsNumArray = [NSMutableArray arrayWithCapacity:0];
    
    cellNum = 15;
//    isOwner = YES;
    [self loadUserInfoData];
    [self loadMyCountryInfoData];
    
    [self createScrollView];
    [self createFakeNavigation];
//    [self createHeader];
    [self createTableView1];
    
}

#pragma mark - 用户信息
- (void)loadUserInfoData
{
    StartLoading;
//    user/infoApi&usr_id=
    NSString *userInfoSig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", self.usr_id]];
    NSString *userInfoString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERINFOAPI, self.usr_id, userInfoSig,[ControllerManager getSID]];
    NSLog(@"用户信息API:%@",userInfoString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:userInfoString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            NSLog(@"用户信息数据：%@",load.dataDict);
           headerDict=  [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            if ([[headerDict objectForKey:@"usr_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
                titleLabel.text = @"我的档案";
            }else{
                titleLabel.text = @"TA的档案";
            }
            if ([[headerDict objectForKey:@"usr_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
                isOwner = YES;
            }
            LoadingSuccess;
            [self createHeader];
            //
            
            
        }else{
            LoadingFailed;
        }
        
    }];
    [request release];

}
-(void)loadMyCountryInfoData
{
//    user/petsApi&usr_id=(若用户为自己则留空不填)
    NSString * code = [NSString stringWithFormat:@"is_simple=0&usr_id=%@dog&cat", self.usr_id];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 0, self.usr_id, [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"%@", load.dataDict);
            [self.userPetListArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (NSDictionary * dict in array) {
                UserPetListModel * model = [[UserPetListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.userPetListArray addObject:model];
                [model release];
            }
            [tv reloadData];
        }else{
        
        }
    }];
    [request release];
}
-(void)loadMyAttentionCountryData
{
    NSString * code = [NSString stringWithFormat:@"usr_id=%@dog&cat", self.usr_id];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERATTENTIONLISTAPI, self.usr_id, [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"%@", load.dataDict);
            [self.userAttentionListArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (NSDictionary * dict in array) {
                PetInfoModel * model = [[PetInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.userAttentionListArray addObject:model];
                [model release];
            }
            [tv2 reloadData];
        }else{
            
        }
    }];
    [request release];
}
-(void)loadActData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", self.usr_id]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERACTLISTAPI, self.usr_id, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"%@", load.dataDict);
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (NSDictionary * dict in array) {
                UserActivityListModel * model = [[UserActivityListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.userActivityListArray addObject:model];
                [model release];
            }
            [tv3 reloadData];
        }else{
            
        }
    }];
    [request release];
}
-(void)loadBagData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", self.usr_id]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERGOODSLISTAPI, self.usr_id, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"背包物品:%@", load.dataDict);
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = [load.dataDict objectForKey:@"data"];
                [self.goodsArray removeAllObjects];
                [self.goodsNumArray removeAllObjects];
                
                for (NSString * itemId in [dict allKeys]) {
                    [self.goodsArray addObject:itemId];
                }
                //排序
                for (int i=0; i<self.goodsArray.count; i++) {
                    for (int j=0; j<self.goodsArray.count-i-1; j++) {
                        if ([self.goodsArray[j] intValue] > [self.goodsArray[j+1] intValue]) {
                            NSString * str1 = [NSString stringWithFormat:@"%@", self.goodsArray[j]];
                            NSString * str2 = [NSString stringWithFormat:@"%@", self.goodsArray[j+1]];
                            self.goodsArray[j] = str2;
                            self.goodsArray[j+1] = str1;
                        }
                    }
                }
                //获取对应数量
                for (int i=0; i<self.goodsArray.count; i++) {
                    self.goodsNumArray[i] = [dict objectForKey:self.goodsArray[i]];
                }
                //剔除数目为0的物品
                for(int i=0;i<self.goodsArray.count;i++){
                    if ([self.goodsNumArray[i] intValue] == 0) {
                        [self.goodsArray removeObjectAtIndex:i];
                        [self.goodsNumArray removeObjectAtIndex:i];
                        i--;
                    }
                }
            }
            [self createTableView4];
        }else{
            
        }
    }];
    [request release];
}

#pragma mark - 用户列表

#pragma mark - 
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
    
    titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"用户资料"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIImageView * more = [MyControl createImageViewWithFrame:CGRectMake(280, 38, 47/2, 9/2) ImageName:@"threePoint.png"];
    [navView addSubview:more];
    
    UIButton * moreBtn = [MyControl createButtonWithFrame:CGRectMake(270, 25, 47/2+20, 9/2+16+10) ImageName:@"" Target:self Action:@selector(moreBtnClick) Title:nil];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    moreBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:moreBtn];
}

#pragma mark - 导航点击事件
-(void)backBtnClick
{
    NSLog(@"back");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)moreBtnClick
{
    NSLog(@"more");
    /********截图***********/
    UIImage * image = [MyControl imageWithView:[UIApplication sharedApplication].keyWindow];
    //存到本地
    NSString * filePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"screenshot_user.png"]];
    //将下载的图片存放到本地
    NSData * data = UIImageJPEGRepresentation(image, 0.5);
    BOOL isWriten = [data writeToFile:filePath atomically:YES];
    NSLog(@"--isWriten:%d", isWriten);
    /**********************/
    if (!isMoreCreated) {
        //create more
        [self createMore];
        isMoreCreated = YES;
    }
    [self.view bringSubviewToFront:menuBgBtn];
    [self.view bringSubviewToFront:moreView];
    
    //show more
    menuBgBtn.hidden = NO;
    CGRect rect = moreView.frame;
    rect.origin.y -= rect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        moreView.frame = rect;
        menuBgBtn.alpha = 0.5;
    }];
    
}
#pragma mark - 创建更多视图
-(void)createMore
{
    menuBgBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:nil];
    menuBgBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:menuBgBtn];
    menuBgBtn.alpha = 0;
    menuBgBtn.hidden = YES;
    
    // 318*234
    moreView = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 234)];
    moreView.backgroundColor = [ControllerManager colorWithHexString:@"efefef"];
    [self.view addSubview:moreView];
    
    //orange line
    UIView * orangeLine = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 4)];
    orangeLine.backgroundColor = [ControllerManager colorWithHexString:@"fc7b51"];
    [moreView addSubview:orangeLine];
    //label
    UILabel * shareLabel = [MyControl createLabelWithFrame:CGRectMake(15, 10, 80, 15) Font:13 Text:@"分享到"];
    shareLabel.textColor = [UIColor blackColor];
    [moreView addSubview:shareLabel];
    //3个按钮
    NSArray * arr = @[@"more_weixin.png", @"more_friend.png", @"more_sina.png"];
    NSArray * arr2 = @[@"微信好友", @"朋友圈", @"微博"];
    for(int i=0;i<3;i++){
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(40+i*92, 33, 42, 42) ImageName:arr[i] Target:self Action:@selector(shareClick:) Title:nil];
        button.tag = 200+i;
        [moreView addSubview:button];
        
        CGRect rect = button.frame;
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(rect.origin.x-10, rect.origin.y+rect.size.height+5, rect.size.width+20, 15) Font:12 Text:arr2[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        //        label.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [moreView addSubview:label];
    }
    //grayLine1
    UIView * grayLine1 = [MyControl createViewWithFrame:CGRectMake(0, 105, 320, 2)];
    grayLine1.backgroundColor = [ControllerManager colorWithHexString:@"e3e3e3"];
    [moreView addSubview:grayLine1];
    
    //OwnerView
    UIView * ownerView = [MyControl createViewWithFrame:CGRectMake(0, 127, 320, 76/2)];
    [moreView addSubview:ownerView];
    
    UIButton * privateMessage = [MyControl createButtonWithFrame:CGRectMake(30, 0, 526/2, 76/2) ImageName:@"" Target:self Action:@selector(sendMessage) Title:@"私信"];
    privateMessage.backgroundColor = BGCOLOR5;
    privateMessage.showsTouchWhenHighlighted = YES;
    privateMessage.layer.cornerRadius = 5;
    privateMessage.layer.masksToBounds = YES;
    privateMessage.titleLabel.font = [UIFont systemFontOfSize:15];
    [ownerView addSubview:privateMessage];
    
    UIButton * modifyUserInfo = [MyControl createButtonWithFrame:privateMessage.frame ImageName:@"" Target:self Action:@selector(modifyUserInfo) Title:@"修改资料"];
    modifyUserInfo.titleLabel.font = [UIFont systemFontOfSize:15];
    modifyUserInfo.backgroundColor = [UIColor lightGrayColor];
    modifyUserInfo.layer.cornerRadius = 5;
    modifyUserInfo.layer.masksToBounds = YES;
    modifyUserInfo.showsTouchWhenHighlighted = YES;
    modifyUserInfo.hidden = YES;
    [ownerView addSubview:modifyUserInfo];
    
    //grayLine2
    UIView * grayLine2 = [MyControl createViewWithFrame:CGRectMake(0, 180, 320, 5)];
    grayLine2.backgroundColor = [ControllerManager colorWithHexString:@"e3e3e3"];
    [moreView addSubview:grayLine2];
    
    //cancelBtn
    UIButton * cancelBtn = [MyControl createButtonWithFrame:CGRectMake(0, 188, 320, 46) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:@"取消"];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [moreView addSubview:cancelBtn];
    
    /*************************/
    if (isOwner) {
        privateMessage.hidden = YES;
        modifyUserInfo.hidden = NO;
//        grayLine1.hidden = YES;
//        moreView.frame = CGRectMake(0, self.view.frame.size.height, 320, 156);
//        grayLine2.frame = CGRectMake(0, 104, 320, 4);
//        cancelBtn.frame = CGRectMake(0, 110, 320, 46);
    }
}
-(void)modifyUserInfo
{
    NSLog(@"跳转到修改用户资料");
    ModifyPetOrUserInfoViewController * vc = [[ModifyPetOrUserInfoViewController alloc] init];
    vc.isModifyUser = YES;
    vc.refreshUserInfo = ^(void){
        for (UIView * view in self.view.subviews) {
            [view removeFromSuperview];
        }
        
        isCreated[0] = 0;
        isCreated[1] = 0;
        isCreated[2] = 0;
        isCreated[3] = 0;
        isMoreCreated = 0;
        isOwner = 0;
        [self viewDidLoad];
    };
    [self cancelBtnClick];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}


-(void)shareClick:(UIButton *)button
{
    NSString * imagePath = [DOCDIR stringByAppendingPathComponent:@"screenshot_user.png"];
    UIImage * screenshotImage = [UIImage imageWithContentsOfFile:imagePath];
    if (button.tag == 200) {
        NSLog(@"微信");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:screenshotImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self cancelBtnClick];
                StartLoading;
                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                StartLoading;
                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
            
        }];
    }else if(button.tag == 201){
        NSLog(@"朋友圈");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:screenshotImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self cancelBtnClick];
                StartLoading;
                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                StartLoading;
                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
            
        }];
    }else{
        NSLog(@"微博");
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"#宠物星球App#" image:screenshotImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self cancelBtnClick];
                StartLoading;
                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                NSLog(@"失败原因：%@", response);
                StartLoading;
                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
            
        }];
    }
}
-(void)sendMessage
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        [self cancelBtnClick];
        return;
    }
    NSLog(@"发私信");
    TalkViewController * vc = [[TalkViewController alloc] init];
    [self cancelBtnClick];
    vc.friendName = [headerDict objectForKey:@"name"];
    vc.usr_id = [headerDict objectForKey:@"usr_id"];
    vc.otherTX = [headerDict objectForKey:@"tx"];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)cancelBtnClick
{
    NSLog(@"cancel");
    CGRect rect = moreView.frame;
    rect.origin.y += rect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        moreView.frame = rect;
        menuBgBtn.alpha = 0;
    } completion:^(BOOL finished) {
        menuBgBtn.hidden = YES;
    }];
}
#pragma mark - 创建tableView的tableHeaderView
-(void)createHeader
{
    bgView = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 200)];
    [self.view addSubview:bgView];
    
    [self.view bringSubviewToFront:navView];
    [self.view bringSubviewToFront:toolBgView];
    //
    bgImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    UIImage * image = [UIImage imageNamed:@"defaultUserHead.png"];
    bgImageView1.image = [image applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    [bgView addSubview:bgImageView1];
    [bgImageView1 release];
    
    //蒙版
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 200)];
    alphaView.alpha = 0.7;
    alphaView.backgroundColor = [ControllerManager colorWithHexString:@"a85848"];
    [bgView addSubview:alphaView];
    
    //头像
    
    headImageView = [[ClickImage alloc] initWithFrame:CGRectMake(10, 25, 70, 70)];
    headImageView.canClick = YES;
    headImageView.image = [UIImage imageNamed:@"defaultUserHead.png"];
    headImageView.layer.cornerRadius = 70/2;
    headImageView.layer.masksToBounds = YES;
    [bgView addSubview:headImageView];
    [headImageView release];

    /**************************/
    if (!([[headerDict objectForKey:@"tx"] isKindOfClass:[NSNull class]] || [[headerDict objectForKey:@"tx"] length]==0)) {
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [headerDict objectForKey:@"tx"]]];
        //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
        if (image) {
            headImageView.image = image;
            bgImageView1.image = [image applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
        }else{
            //下载头像
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", USERTXURL, [headerDict objectForKey:@"tx"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    headImageView.image = load.dataImage;
                    bgImageView1.image = [load.dataImage applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
                    NSString * docDir = DOCDIR;
                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [headerDict objectForKey:@"tx"]]];
                    [load.data writeToFile:txFilePath atomically:YES];
                }else{
                    NSLog(@"头像下载失败");
                }
            }];
            [request release];
        }
    }
    /**************************/
    
    //等级
//    UILabel * exp = [MyControl createLabelWithFrame:CGRectMake(headImageView.frame.origin.x+70-20, headImageView.frame.origin.y+70-16, 30, 16) Font:10 Text:[NSString stringWithFormat:@"Lv.%@",[headerDict objectForKey:@"lv"]]];
//    exp.textAlignment = NSTextAlignmentCenter;
//    exp.backgroundColor = [UIColor colorWithRed:249/255.0 green:135/255.0 blue:88/255.0 alpha:1];
//    exp.textColor = [UIColor colorWithRed:229/255.0 green:79/255.0 blue:36/255.0 alpha:1];
//    exp.layer.cornerRadius = 3;
//    exp.layer.masksToBounds = YES;
//    exp.font = [UIFont boldSystemFontOfSize:10];
//    [bgView addSubview:exp];
    
//    UIButton * attentionBtn = [MyControl createButtonWithFrame:CGRectMake(60, 75, 20, 20) ImageName:@"" Target:self Action:@selector(attentionBtnClick) Title:@"关注"];
//    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:10];
//    attentionBtn.layer.cornerRadius = 20/2;
//    attentionBtn.layer.masksToBounds = YES;
//    attentionBtn.backgroundColor = BGCOLOR4;
//    //    attentionBtn.showsTouchWhenHighlighted = YES;
//    [bgView addSubview:attentionBtn];
    
    //
    NSString *str = [NSString stringWithFormat:@"%@",[headerDict objectForKey:@"name"]];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(100, 100) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel * name = [MyControl createLabelWithFrame:CGRectMake(105, 25, size.width+5, 20) Font:15 Text:str];
    [bgView addSubview:name];
    
    UIImageView * sex = [MyControl createImageViewWithFrame:CGRectMake(name.frame.origin.x+name.frame.size.width, 25, 17, 17) ImageName:@"man.png"];
    if ([[headerDict objectForKey:@"gender"] intValue] == 2) {
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    [bgView addSubview:sex];
    
    //
    UILabel * cateNameLabel = [MyControl createLabelWithFrame:CGRectMake(105, 55, 130, 20) Font:14 Text:[ControllerManager returnProvinceAndCityWithCityNum:[headerDict objectForKey:@"city"]]];
    cateNameLabel.font = [UIFont boldSystemFontOfSize:14];
//    cateNameLabel.alpha = 0.65;
    [bgView addSubview:cateNameLabel];
    
    //
    
    NSString * str2= [NSString stringWithFormat:@"经纪人 — %@联萌", [headerDict objectForKey:@"a_name"]];
    CGSize size2 = [str2 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 100) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel * positionAndUserName = [MyControl createLabelWithFrame:CGRectMake(105, 170/2, size2.width, 20) Font:15 Text:str2];
    //    positionAndUserName.font = [UIFont boldSystemFontOfSize:15];
    [bgView addSubview:positionAndUserName];
    
    //宠物头像，点击进入宠物主页
    UIButton * userImageBtn = [MyControl createButtonWithFrame:CGRectMake(positionAndUserName.frame.origin.x+positionAndUserName.frame.size.width+5, 160/2, 30, 30) ImageName:@"defaultPetHead.png" Target:self Action:@selector(jumpToUserInfo) Title:nil];
    if (self.petHeadImage != nil) {
        [userImageBtn setBackgroundImage:self.petHeadImage forState:UIControlStateNormal];
    }else{
        /**************************/
        if (!([[headerDict objectForKey:@"a_tx"] isKindOfClass:[NSNull class]] || [[headerDict objectForKey:@"a_tx"] length]==0)) {
            NSString * docDir = DOCDIR;
            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [headerDict objectForKey:@"a_tx"]]];
            //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
            UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
            if (image) {
                [userImageBtn setBackgroundImage:image forState:UIControlStateNormal];
                //            headImageView.image = image;
            }else{
                //下载头像
                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXAPI, [headerDict objectForKey:@"tx"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
                        [userImageBtn setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                        //                    headImageView.image = load.dataImage;
                        NSString * docDir = DOCDIR;
                        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [headerDict objectForKey:@"a_tx"]]];
                        [load.data writeToFile:txFilePath atomically:YES];
                    }else{
                        NSLog(@"头像下载失败");
                    }
                }];
                [request release];
            }
        }
        /**************************/
    }
    
    userImageBtn.layer.cornerRadius = 15;
    userImageBtn.layer.masksToBounds = YES;
    [bgView addSubview:userImageBtn];
    
    //123  164
    UIImageView * flagImageView = [MyControl createImageViewWithFrame:CGRectMake(240, 0, 123/2, 164/2) ImageName:@"flag_gold.png"];
    [bgView addSubview:flagImageView];
    
    UILabel * gold = [MyControl createLabelWithFrame:CGRectMake(0, 10, 60, 20) Font:12 Text:[NSString stringWithFormat:@"%@",[headerDict objectForKey:@"gold"]]];
    gold.textAlignment = NSTextAlignmentCenter;
    [flagImageView addSubview:gold];
    
    UIButton * GXList = [MyControl createButtonWithFrame:CGRectMake(0, 0, 62, 70) ImageName:@"" Target:self Action:@selector(GXListClick) Title:@""];
//    GXList.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [flagImageView addSubview:GXList];

    //五角星
    UIImageView * star = [MyControl createImageViewWithFrame:CGRectMake(74/2, 126, 20, 20) ImageName:@"yellow_star.png"];
    [bgView addSubview:star];
    
    NSString * str3= [NSString stringWithFormat:@"Lv.%@",[headerDict objectForKey:@"lv"]];
    CGSize size3 = [str3 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 100) lineBreakMode:1];
    UILabel * RQLabel = [MyControl createLabelWithFrame:CGRectMake(64, 130, size3.width, 15) Font:13 Text:str3];
    [bgView addSubview:RQLabel];
    
    UIImageView * RQBgImageView = [MyControl createImageViewWithFrame:CGRectMake(64+size3.width, 132, 350/2, 13) ImageName:@""];
    RQBgImageView.image = [[UIImage imageNamed:@"RQBg.png"] stretchableImageWithLeftCapWidth:37/2 topCapHeight:26/2];
    //边缘处理
    RQBgImageView.layer.cornerRadius = 6;
    RQBgImageView.layer.masksToBounds = YES;
    [bgView addSubview:RQBgImageView];
    
    int needExp = [ControllerManager returnExpOfNeedWithLv:[headerDict objectForKey:@"lv"]];
    int length = [[headerDict objectForKey:@"exp"] floatValue]/needExp*173;
    //    float length = 3.5/2*70;
    NSLog(@"%d", length);
    UIImageView * RQImageView = [MyControl createImageViewWithFrame:CGRectMake(1, 1, length, 11) ImageName:@""];
    RQImageView.image = [[UIImage imageNamed:@"RQImage.png"] stretchableImageWithLeftCapWidth:51/2 topCapHeight:25/2];
    [RQBgImageView addSubview:RQImageView];
    
    UILabel * RQNumLabel = [MyControl createLabelWithFrame:CGRectMake(50, 0, 75, 13) Font:12 Text:[NSString stringWithFormat:@"%d/%d", [[headerDict objectForKey:@"exp"] intValue], needExp]];
    RQNumLabel.textAlignment = NSTextAlignmentCenter;
    [RQBgImageView addSubview:RQNumLabel];
    
}

#pragma mark - 跳转点击事件
-(void)jumpToUserInfo
{
    NSLog(@"%d", self.isFromPetInfo);
    if (self.isFromPetInfo) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
//        PetInfoViewController * vc = [[PetInfoViewController alloc] init];
//        [self presentViewController:vc animated:YES completion:nil];
//        [vc release];
    }
    
}
-(void)GXListClick
{
    NSLog(@"跳转充值");
}

#pragma mark - 创建scrollView
-(void)createScrollView
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    sv.contentSize = CGSizeMake(320*4, self.view.frame.size.height);
    sv.delegate = self;
    sv.pagingEnabled = YES;
    //为防止和cell的手势冲突需要关闭scrollView的滑动属性。
    sv.scrollEnabled = NO;
    [self.view addSubview:sv];
}

#pragma mark - 创建tableView&&createTool

-(void)createTableView1
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = 0;
    [sv addSubview:tv];
    
    UIView * tvHeaderView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 264)];
    tv.tableHeaderView = tvHeaderView;

    isCreated[0] = 1;
    
    [self.view bringSubviewToFront:bgView];
    [self.view bringSubviewToFront:navView];
    
    //为保证切换条在所有层的最上面，所以在此创建
    toolBgView = [MyControl createViewWithFrame:CGRectMake(0, 64+200-44, 320, 44)];
    [self.view addSubview:toolBgView];
    
    UIView * toolAlphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 44)];
    toolAlphaView.alpha = 0.4;
    toolAlphaView.backgroundColor = [ControllerManager colorWithHexString:@"8e2918"];
    [toolBgView addSubview:toolAlphaView];
    
    NSArray * unSeletedArray = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
    NSArray * seletedArray = @[@"page1_selected.png", @"page2_selected.png", @"page3_selected.png", @"page4_selected.png"];
    for(int i=0;i<seletedArray.count;i++){
        UIButton * imageButton = [MyControl createButtonWithFrame:CGRectMake(25+i*80, 9, 30, 30) ImageName:unSeletedArray[i] Target:self Action:@selector(imageButtonClick) Title:nil];
        [imageButton setBackgroundImage:[UIImage imageNamed:seletedArray[i]] forState:UIControlStateSelected];
        [toolBgView addSubview:imageButton];
        imageButton.tag = 100+i;
        if (i == 0) {
            imageButton.selected = YES;
        }
        
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(i*80, 0, 80, 44) ImageName:@"" Target:self Action:@selector(toolBtnClick:) Title:nil];
        button.tag = 200+i;
        [toolBgView addSubview:button];
    }
    //移动底条
    bottom = [MyControl createViewWithFrame:CGRectMake(0, 40, 80, 4)];
    bottom.backgroundColor = BGCOLOR;
    [toolBgView addSubview:bottom];
    
    [self.view bringSubviewToFront:toolBgView];
    
    //加入从商店跳背包偏移量设置320*3 这里将直接偏移
    sv.contentOffset = CGPointMake(self.offset, 0);
}
-(void)createTableView2
{
    //
    tv2 = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv2.delegate = self;
    tv2.dataSource = self;
    tv2.separatorStyle = 0;
    [sv addSubview:tv2];
    
    UIView * tvHeaderView2 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 264)];
    tv2.tableHeaderView = tvHeaderView2;
    
    [self.view bringSubviewToFront:bgView];
    [self.view bringSubviewToFront:navView];
    [self.view bringSubviewToFront:toolBgView];
    isCreated[1] = 1;
}
-(void)createTableView3
{
    //
    tv3 = [[UITableView alloc] initWithFrame:CGRectMake(320*2, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv3.delegate = self;
    tv3.dataSource = self;
    tv3.separatorStyle = 0;
    [sv addSubview:tv3];
    
    UIView * tvHeaderView3 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 264)];
    tv3.tableHeaderView = tvHeaderView3;
    
    [self.view bringSubviewToFront:bgView];
    [self.view bringSubviewToFront:navView];
    [self.view bringSubviewToFront:toolBgView];
    isCreated[2] = 1;
}
-(void)createTableView4
{
    //
    tv4 = [[UITableView alloc] initWithFrame:CGRectMake(320*3, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv4.delegate = self;
    tv4.dataSource = self;
    tv4.separatorStyle = 0;
    [sv addSubview:tv4];
    
    UIView * tvHeaderView4 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 264)];
    tv4.tableHeaderView = tvHeaderView4;
    
    [self.view bringSubviewToFront:bgView];
    [self.view bringSubviewToFront:navView];
    [self.view bringSubviewToFront:toolBgView];
    isCreated[3] = 1;
}



-(void)imageButtonClick
{
    
}
-(void)toolBtnClick:(UIButton *)button
{
    for(int i=0;i<4;i++){
        UIButton * btn = (UIButton *)[toolBgView viewWithTag:100+i];
        btn.selected = NO;
    }
    int a = button.tag;
    UIButton * temp = (UIButton *)[toolBgView viewWithTag:a-100];
    temp.selected = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        bottom.frame = CGRectMake((a-200)*80, 40, 80, 4);
        
        sv.contentOffset = CGPointMake(320*(a-200), 0);
    }];
    
    if (a == 200) {
        if (!isCreated[a-200]) {
            [self createTableView1];
        }
    }else if(a == 201) {
        if (!isCreated[a-200]) {
            [self createTableView2];
            [self loadMyAttentionCountryData];
        }
    }else if(a == 202) {
        if (!isCreated[a-200]) {
            [self createTableView3];
            [self loadActData];
        }
    }else{
        if (!isCreated[a-200]) {
            [self loadBagData];
        }
    }
}

#pragma mark - scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int x = sv.contentOffset.x;
    
    if (scrollView == sv && x%320 == 0) {
        tempTv = nil;
        if (x/320 == 0) {
            tempTv = tv;
        }else if(x/320 == 1){
            tempTv = tv2;
        }else if(x/320 == 2){
            tempTv = tv3;
        }else{
            tempTv = tv4;
        }
        //对应的按钮变颜色
        UIButton * button = (UIButton *)[toolBgView viewWithTag:200+x/320];
        [self toolBtnClick:button];
        //小橘条位置变化
        [UIView animateWithDuration:0.2 animations:^{
            bottom.frame = CGRectMake(80*x/320, 40, 80, 4);
            tempTv.contentOffset = CGPointMake(0, 0);
            tempTv = nil;
            bgView.frame = CGRectMake(0, 64, 320, 200);
            toolBgView.frame = CGRectMake(0, 64+200-44, 320, 44);
        }];
    }
    
    if (scrollView != sv) {
        bgView.frame = CGRectMake(0, 64-scrollView.contentOffset.y, 320, 200);
        //
        if (scrollView.contentOffset.y<=200-44) {
            toolBgView.frame = CGRectMake(0, 64+200-44-scrollView.contentOffset.y, 320, 44);
        }else{
            toolBgView.frame = CGRectMake(0, 64, 320, 44);
            
        }
    }
    //        else{
    //        //每次转换tableView后校准header和tool的位置
    //        bgView.frame = CGRectMake(0, 64-scrollView.contentOffset.y, 320, 200);
    //        toolBgView.frame = CGRectMake(0, 64, 320, 44);
    //    }
}
#pragma mark - tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tv4) {
        if (self.goodsArray.count) {
            return 1;
        }else{
            return 0;
        }
    }else if(tableView == tv){
        //+的这个1是添加王国的按钮
        if ([self.usr_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
            return self.userPetListArray.count+1;
        }else{
            return self.userPetListArray.count;
        }
    }else if(tableView == tv2){
        return self.userAttentionListArray.count;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv) {
        if (indexPath.row == self.userPetListArray.count) {
            static NSString * cellID0 = @"ID0";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID0];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[cellID0 autorelease]];
            }
            cell.selectionStyle = 0;
            
            UIButton * button = [MyControl createButtonWithFrame:CGRectMake(40, 8, 240, 35) ImageName:@"" Target:self Action:@selector(addCountry) Title:@"+"];
            [cell addSubview:button];
            button.backgroundColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1];
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:30];
            return cell;
        }
        
        static NSString * cellID = @"ID";
        CountryInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CountryInfoCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor whiteColor];
        //不要忘记指针指向
        cell.delegate = self;
        cell.selectionStyle = 0;
//        if (indexPath.row == 0) {
//            UIImageView * crown = [MyControl createImageViewWithFrame:CGRectMake(55, 52, 20, 20) ImageName:@"crown.png"];
//            [cell addSubview:crown];
//        }
        if ([self.usr_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
            [cell modify:indexPath.row isSelf:YES];
        }else{
            [cell modify:indexPath.row isSelf:NO];
        }
        [cell configUI:self.userPetListArray[indexPath.row]];
        return cell;
    }else if (tableView == tv2) {
        static NSString * cellID2 = @"ID2";
        UserInfoRankCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoRankCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = 0;
        [cell configUI:self.userAttentionListArray[indexPath.row]];
        return cell;
    }else if (tableView == tv3) {
        
        static NSString * cellID3 = @"ID3";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3] autorelease];
        }
        
        return cell;
//        UserInfoActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
//        if(!cell){
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoActivityCell" owner:self options:nil] objectAtIndex:0];
//        }
//        cell.selectionStyle = 0;
//        UserActivityListModel * model = self.userActivityListArray[indexPath.row];
//        [cell configUI:model];
//        cell.jumpToDetail = ^(NSString * img_id){
//            PicDetailViewController * vc = [[PicDetailViewController alloc] init];
//            vc.img_id = img_id;
//            [self presentViewController:vc animated:YES completion:nil];
//            [vc release];
//        };
////        [cell modifyWithString:@"# 萌宠时装秀 #"];
//        return cell;
    }else{
        static NSString * cellID4 = @"ID4";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID4];
        if(!cell){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID4] autorelease];
        }
        cell.selectionStyle = 0;
        
        for(int i=0;i<self.goodsArray.count;i++){
            CGRect rect = CGRectMake(20+i%3*100, 15+i/3*100, 85, 90);
            NSDictionary * dict = [ControllerManager returnGiftDictWithItemId:self.goodsArray[i]];
            
            UIImageView * imageView = [MyControl createImageViewWithFrame:rect ImageName:@"product_bg.png"];
            if ([[dict objectForKey:@"no"] intValue]>=2000) {
                imageView.image = [UIImage imageNamed:@"trick_bg.png"];
            }
            [cell addSubview:imageView];
            
//            UIImageView * triangle = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 32, 32) ImageName:@"gift_triangle.png"];
//            [imageView addSubview:triangle];
            
            UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(-3, 3, 20, 9) Font:8 Text:@"人气"];
            rq.font = [UIFont boldSystemFontOfSize:8];
            rq.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
            [imageView addSubview:rq];
            
            UILabel * rqNum = [MyControl createLabelWithFrame:CGRectMake(-1, 10, 25, 10) Font:9 Text:nil];
            if ([[dict objectForKey:@"add_rq"] rangeOfString:@"-"].location == NSNotFound) {
                rqNum.text = [NSString stringWithFormat:@"+%@", [dict objectForKey:@"add_rq"]];
            }else{
                rqNum.text = [dict objectForKey:@"add_rq"];
            }
            rqNum.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
            rqNum.textAlignment = NSTextAlignmentCenter;
            //            rqNum.backgroundColor = [UIColor redColor];
            [imageView addSubview:rqNum];
            
            UILabel * giftName = [MyControl createLabelWithFrame:CGRectMake(0, 5, 85, 15) Font:11 Text:[dict objectForKey:@"name"]];
            giftName.textColor = [UIColor grayColor];
            giftName.textAlignment = NSTextAlignmentCenter;
            [imageView addSubview:giftName];
            
            UIImageView * giftPic = [MyControl createImageViewWithFrame:CGRectMake(5, 20, 75, 50) ImageName:[NSString stringWithFormat:@"%@.png", [dict objectForKey:@"no"]]];
            [imageView addSubview:giftPic];
            
            UIImageView * gift = [MyControl createImageViewWithFrame:CGRectMake(20, 90-14-5, 12, 14) ImageName:@"detail_gift.png"];
            [imageView addSubview:gift];
            
            UILabel * giftNum = [MyControl createLabelWithFrame:CGRectMake(35, 90-18, 40, 15) Font:13 Text:[NSString stringWithFormat:@" × %@", self.goodsNumArray[i]]];
            giftNum.textColor = BGCOLOR;
            [imageView addSubview:giftNum];
            
            UIButton * button = [MyControl createButtonWithFrame:rect ImageName:@"" Target:self Action:@selector(buttonClick:) Title:nil];
            [cell addSubview:button];
            button.tag = 1000+i;
        }
        return cell;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消关注";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.usr_id isEqualToString:[USER objectForKey:@"usr_id"]] && tableView == tv2) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv2 && editingStyle==UITableViewCellEditingStyleDelete) {
        [self unFollow:indexPath.row];
        [self.userAttentionListArray removeObjectAtIndex:indexPath.row];
        //删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
//    else if(tableView == tv){
//        if ([self.usr_id isEqualToString:[self.userPetListArray[indexPath.row] master_id]]) {
//            StartLoading;
//            [MMProgressHUD dismissWithError:@"不能退出自己的国家" afterDelay:1];
//            return;
//        }
//        [self quitCountryWithRow:indexPath.row];
//        [self.userPetListArray removeObjectAtIndex:indexPath.row];
//        //删除单元格的某一行时，在用动画效果实现删除过程
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//    }
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv) {
        return 100.0f;
    }else if(tableView == tv2){
        return 70.0f;
    }else if (tableView == tv3) {
        return 200.0f;
    }else{
        int i = self.goodsArray.count;
        if (i%3) {
            return 15+(i/3+1)*100;
        }else{
            return 15+i/3*100;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv) {
        NSLog(@"%d", indexPath.row);
//        UserPetListModel * model = self.userPetListArray[indexPath.row];
//        PetInfoViewController * vc = [[PetInfoViewController alloc] init];
//
//        vc.aid = model.aid;
//        [self presentViewController:vc animated:YES completion:nil];
//        [vc release];
    }
}

#pragma mark - cell代理
-(void)swipeTableViewCell:(CountryInfoCell *)cell didClickButtonWithIndex:(NSInteger)index
{
    if (sv.contentOffset.x == 0) {
        if (index == 1) {
            //退出国家
            NSIndexPath * cellIndexPath = [tv indexPathForCell:cell];
            NSLog(@"%@", [self.userPetListArray[cellIndexPath.row] master_id]);
            if ([self.usr_id isEqualToString:[self.userPetListArray[cellIndexPath.row] master_id]]) {
                StartLoading;
                [MMProgressHUD dismissWithError:@"不能退出自己的国家" afterDelay:1];
                return;
            }
            [self quitCountryWithRow:cellIndexPath.row];
            
            [self.userPetListArray removeObjectAtIndex:cellIndexPath.row];
            [tv deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }else if(index == 2){
            //切换并置顶
            
        }
    }
}
#pragma mark -
-(void)unFollow:(int)row
{
    NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", [self.userAttentionListArray[row] aid]];
    NSString * sig = [MyMD5 md5:code];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", UNFOLLOWAPI, [self.userAttentionListArray[row] aid], sig, [ControllerManager getSID]];
    NSLog(@"unfollowApiurl:%@", url);
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:@"取消关注中..."];
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"%@", load.dataDict);
            [MMProgressHUD dismissWithSuccess:@"取消关注成功" title:nil afterDelay:1];
        }else{
            [MMProgressHUD dismissWithError:@"取消关注失败" afterDelay:1];
        }
    }];
    [request release];
}
-(void)quitCountryWithRow:(int)row
{
    NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", [self.userPetListArray[row] aid]];
    NSString * sig = [MyMD5 md5:code];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", EXITFAMILYAPI, [self.userPetListArray[row] aid], sig, [ControllerManager getSID]];
    NSLog(@"quitApiurl:%@", url);
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:@"退出中..."];
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                [MMProgressHUD dismissWithSuccess:@"退出成功" title:nil afterDelay:1];
            }else{
                [MMProgressHUD dismissWithSuccess:@"退出失败" title:nil afterDelay:1];
            }
            
        }else{
            [MMProgressHUD dismissWithError:@"退出失败" afterDelay:1];
        }
    }];
    [request release];
}

//礼物点击事件
-(void)buttonClick:(UIButton *)btn
{
    NSLog(@"%d", btn.tag);
}
-(void)addCountry
{
    NSLog(@"加入国家");
    ChooseInViewController * vc = [[ChooseInViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
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
