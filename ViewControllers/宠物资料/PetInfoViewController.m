//
//  PetInfoViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetInfoViewController.h"
#import "UserInfoViewController.h"
#import "MyCountryMessageCell.h"
#import "MyCountryContributeCell.h"
#import "MyPhotoCell.h"
#import "InfoModel.h"
#import "PicDetailViewController.h"
#import "PopularityListViewController.h"
#import "ContributionViewController.h"

#import "CountryMembersModel.h"
#import "ToolTipsViewController.h"
#import "MJRefresh.h"

#import "PublishViewController.h"
#import "PetNewsModel.h"
#import "SendGiftViewController.h"
#import "ModifyPetOrUserInfoViewController.h"
#import "PetInfoModel.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <AviarySDK/AviarySDK.h>
static NSString * const kAFAviaryAPIKey = @"b681eafd0b581b46";
static NSString * const kAFAviarySecret = @"389160adda815809";
@interface PetInfoViewController ()<AFPhotoEditorControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSDictionary *petInfoDict;
    UIButton * addBtn;
    UIButton * attentionBtn;
    BOOL attentionBtnFirst;
    
    BOOL isCamara;
    UIActionSheet * sheet;
    BOOL isFans;
    BOOL isFollow;
}
@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;
@property(nonatomic,retain)UIImage * oriImage;

@end

@implementation PetInfoViewController
- (NSString *)aid
{
    if (!_aid) {
        _aid = [USER objectForKey:@"aid"];
    }
    return _aid;
}
-(void)viewWillAppear:(BOOL)animated
{
    if (isLoaded) {
        [self loadCountryList];
        //更新头像
        NSLog(@"%@", [USER objectForKey:@"petInfoDict"]);
        BOOL a = [[USER objectForKey:@"petInfoDict"] isKindOfClass:[NSDictionary class]];
        if (a) {
            if (!([[[USER objectForKey:@"petInfoDict"] objectForKey:@"tx"] isKindOfClass:[NSNull class]] || [[[USER objectForKey:@"petInfoDict"] objectForKey:@"tx"] length]==0)) {
                NSString * docDir = DOCDIR;
                NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [[USER objectForKey:@"petInfoDict"] objectForKey:@"tx"]]];
                //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
                UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
                if (image) {
                    [self.headButton setBackgroundImage:image forState:UIControlStateNormal];
                    //            headImageView.image = image;
                }else{
                    //下载头像
                    NSString * url = [NSString stringWithFormat:@"%@%@", PETTXURL, [[USER objectForKey:@"petInfoDict"] objectForKey:@"tx"]];
                    NSLog(@"%@", url);
                    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                        if (isFinish) {
                            [self.headButton setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                            //                    headImageView.image = load.dataImage;
                            NSString * docDir = DOCDIR;
                            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [[USER objectForKey:@"petInfoDict"] objectForKey:@"tx"]]];
                            [load.data writeToFile:txFilePath atomically:YES];
                        }else{
                            NSLog(@"头像下载失败");
                        }
                    }];
                    [request release];
                }
            }
        }
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    isLoaded = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MobClick event:@"pet_homepage"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Allocate Asset Library
    ALAssetsLibrary * assetLibrary = [[ALAssetsLibrary alloc] init];
    [self setAssetLibrary:assetLibrary];
    
    // Allocate Sessions Array
    NSMutableArray * sessions = [NSMutableArray new];
    [self setSessions:sessions];
    [sessions release];
    
    // Start the Aviary Editor OpenGL Load
    [AFOpenGLManager beginOpenGLLoad];
    
    self.newsDataArray = [NSMutableArray arrayWithCapacity:0];
    self.photosDataArray = [NSMutableArray arrayWithCapacity:0];
//    self.userDataArray = [NSMutableArray arrayWithCapacity:0];
    self.countryMembersDataArray = [NSMutableArray arrayWithCapacity:0];
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    self.goodsNumArray = [NSMutableArray arrayWithCapacity:0];
    
    
    
    
    [self createFakeNavigation];
    [self createScrollView];

    [self createNewsTableView];
    [self createToolsView];
    
    [self loadKingData];
//    [self loadAttentionAPI];
//    [self.view bringSubviewToFront:self.menuBgBtn];
//    [self.view bringSubviewToFront:self.menuBgView];
//    [self loadAttentionAPI];
}
#pragma mark - 关系API
- (void)loadAttentionAPI
{
    StartLoading;
//    animal/relationApi&aid=
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",self.aid]];
    NSString *attentionString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",RELATIONAPI,self.aid,sig,[ControllerManager getSID]];
    NSLog(@"%@",attentionString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:attentionString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            [load.dataDict objectForKey:@"data"];
            isFans = [[[load.dataDict objectForKey:@"data"] objectForKey:@"is_fan"] intValue];
            isFollow = [[[load.dataDict objectForKey:@"data"] objectForKey:@"is_follow"] intValue];
            NSLog(@"%d",isFollow);
            attentionBtn.selected = isFollow;
            addBtn.selected = isFans;
            if (!isFans) {
                super.label1.text =@"捣捣乱";
                [self.btn1 setBackgroundImage:[UIImage imageNamed:@"rock2.png"] forState:UIControlStateNormal];
            }
            LoadingSuccess;
        }
    }];
    [request release];
}
#pragma mark - 国王动态数据
- (void)loadKingDynamicData
{
    //1 成为粉丝 2 加入王国 3发图片 4送礼物 5叫一叫 6逗一逗 7捣捣乱
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",self.aid]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETNEWSAPI, self.aid, sig, [ControllerManager getSID]];
    NSLog(@"国王动态API:%@", url);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"国王动态数据：%@",load.dataDict);
            [self.newsDataArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (int i=0; i<array.count; i++) {
                PetNewsModel * model = [[PetNewsModel alloc] init];
                [model setValuesForKeysWithDictionary:array[i]];
                model.content = [array[i] objectForKey:@"content"];
                if([model.type intValue] != 1){
                    if(!(([model.type intValue] == 4 || [model.type intValue] == 7) && ([[model.content objectForKey:@"item_id"] intValue]%10 >4 || [[model.content objectForKey:@"item_id"] intValue]>=2200))){
                        [self.newsDataArray addObject:model];
                    }
                    
                }
                [model release];
            }
            
            [tv reloadData];
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
#pragma mark - 国家成员数据
- (void)loadKingMembersData
{
    NSString *animalMembersSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",self.aid]];
    NSString *animalMembersString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETMEMBERSAPI,self.aid,animalMembersSig, [ControllerManager getSID]];
    NSLog(@"国王成员API:%@",animalMembersString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:animalMembersString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            [self.countryMembersDataArray removeAllObjects];
//            NSLog(@"国王成员数据：%@",load.dataDict);
            NSArray *array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            
            for (int i = 0; i<array.count; i++) {
                NSDictionary * dict = array[i];
                CountryMembersModel *model = [[CountryMembersModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
//                NSLog(@"model.usr_id:%@",model.usr_id);
                //给主人调整位置到第一位
                if ([model.usr_id isEqualToString:self.master_id]) {
                    [self.countryMembersDataArray insertObject:model atIndex:0];
                }else{
                    [self.countryMembersDataArray addObject:model];
                }
                if (i == array.count-1) {
                    self.lastUsr_id = model.usr_id;
                    self.lastRank = model.rank;
                }
                [model release];
            }
            
            
//            NSLog(@"%@", [self.countryMembersDataArray[0] usr_id]);
            [self createCountryMembersTableView];
//            [self loadKingPresentsData];
        }
    }];
    [request release];
    
}
- (void)loadKingMembersDataMore
{
    NSString *animalMembersSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&rank=%@&usr_id=%@dog&cat",self.aid,self.lastRank,self.lastUsr_id]];
    NSString *animalMembersString = [NSString stringWithFormat:@"%@%@&rank=%@&usr_id=%@&sig=%@&SID=%@", PETMEMBERSAPI,self.aid,self.lastRank,self.lastUsr_id,animalMembersSig, [ControllerManager getSID]];
    NSLog(@"更多国王成员API:%@",animalMembersString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:animalMembersString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            NSLog(@"更多国王成员数据：%@",load.dataDict);
//            [self.countryMembersDataArray removeAllObjects];
            NSArray *array = [load.dataDict objectForKey:@"data"];
            
            for (int i = 0; i<array.count; i++) {
                NSDictionary * dict = array[i];
                CountryMembersModel *model = [[CountryMembersModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.countryMembersDataArray addObject:model];
                if (i == array.count-1) {
                    self.lastUsr_id = model.usr_id;
                }
                [model release];
            }
            [tv3 footerEndRefreshing];
        }
    }];
    [request release];
}
#pragma mark - 国王礼物数据

- (void)loadKingPresentsData
{
    NSString *animalPresentsSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",self.aid]];
    NSString *animalPresentsString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETGOODSLISTAPI, self.aid, animalPresentsSig, [ControllerManager getSID]];
    NSLog(@"国王礼物API:%@",animalPresentsString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:animalPresentsString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
//            NSLog(@"国王礼物数据：%@",load.dataDict);
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = [load.dataDict objectForKey:@"data"];
                [self.goodsArray removeAllObjects];
                [self.goodsNumArray removeAllObjects];
                
                for (NSString * itemId in [dict allKeys]) {
                    if ([itemId intValue]%10 >4 || [itemId intValue]>=2200) {
                        continue;
                    }
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
//                for(int i=0;i<self.goodsArray.count;i++){
//                    if ([self.goodsNumArray[i] intValue] == 0) {
//                        [self.goodsArray removeObjectAtIndex:i];
//                        [self.goodsNumArray removeObjectAtIndex:i];
//                        i--;
//                    }
//                }
            }
            [self createPresentsTableView];
        }
    }];
    [request release];
}

#pragma mark -
-(void)loadCountryList
{
    NSString * code = [NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            //            [self.userPetListArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for(int i=0;i<array.count;i++){
                if ([[array[i] objectForKey:@"aid"] isEqualToString:self.aid]) {
                    self.label1.text = @"摇一摇";
                    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"shake.png"] forState:UIControlStateNormal];
                    break;
                }else if(i == array.count-1){
                    self.label1.text = @"捣捣乱";
                    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"rock2.png"] forState:UIControlStateNormal];
                }
            }
        }else{
            
        }
    }];
    [request release];
}
#pragma mark - 请求国王数据
-(void)loadKingData
{
    LOADING;
    NSString *animalInfoSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",self.aid]];
    NSString *animalInfoAPI = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", ANIMALINFOAPI,self.aid,animalInfoSig, [ControllerManager getSID]];
//    NSLog(@"国王信息API:%@", animalInfoAPI);
    [[httpDownloadBlock alloc] initWithUrlStr:animalInfoAPI Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"国王信息:%@", load.dataDict);
            petInfoDict = [load.dataDict objectForKey:@"data"];
            self.master_id = [petInfoDict objectForKey:@"master_id"];
            
            self.pet_aid = [petInfoDict objectForKey:@"aid"];
            self.pet_name = [petInfoDict objectForKey:@"name"];
            self.pet_tx = [petInfoDict objectForKey:@"tx"];

            titleLabel.text = [NSString stringWithFormat:@"萌星 %@", [petInfoDict objectForKey:@"name"]];

            [self loadCountryList];
//            NSArray * array = [USER objectForKey:@"petAidArray"];
//            NSLog(@"%@--%@", array, [petInfoDict objectForKey:@"aid"]);
//            for (int i=0; i<array.count; i++) {
//                if ([array[i] isEqualToString:[petInfoDict objectForKey:@"aid"]]) {
//                    self.label1.text = @"摇一摇";
//                    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"shake.png"] forState:UIControlStateNormal];
//                    break;
//                }else if(i == array.count-1){
//                    self.label1.text = @"捣捣乱";
//                    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"rock2.png"] forState:UIControlStateNormal];
//                }
//            }
            if ([[petInfoDict objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
                self.label3.text = @"萌叫叫";
                [self.btn3 setBackgroundImage:[UIImage imageNamed:@"sound.png"] forState:UIControlStateNormal];
            }else{
                self.label3.text = @"萌印象";
                [self.btn3 setBackgroundImage:[UIImage imageNamed:@"touch.png"] forState:UIControlStateNormal];
            }
            //宠物父类信息字典
//            self.shakeInfoDict = [load.dataDict objectForKey:@"data"];
//            self.pet_aid = [self.shakeInfoDict objectForKey:@"aid"];
            [self createHeader];

            [self.view bringSubviewToFront:navView];
            [self.view bringSubviewToFront:toolBgView];
            
            [self.view bringSubviewToFront:self.menuBgBtn];
            [self.view bringSubviewToFront:self.menuBgView];
            
            [self loadKingDynamicData];
//            LoadingSuccess;
        }else{
            NSLog(@"用户数据加载失败。");
            LOADFAILED;
        }
    }];
}
#pragma mark - 国王照片数据
-(void)loadPhotoData
{
    NET = YES;
    NSString *petImagesSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",self.aid]];
    NSString *petImageAPIString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",PETIMAGESAPI,self.aid,petImagesSig,[ControllerManager getSID]];
    NSLog(@" 国王照片数据API:%@",petImageAPIString);
    [[httpDownloadBlock alloc] initWithUrlStr:petImageAPIString Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"国王照片数据:%@", load.dataDict);
            [self.photosDataArray removeAllObjects];
            
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for(int i=0;i<array.count;i++){
                NSDictionary * dict = array[i];
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                
                //model.headImage = tempImage;
                model.title = [USER objectForKey:@"name"];
                model.detail = [USER objectForKey:@"detailName"];
                [self.photosDataArray addObject:model];
                if (i == array.count-1) {
                    self.lastImg_id = model.img_id;
                }
                [model release];
            }
            isPhotoDownload = YES;
            [self createPhotosTableView];
//            self.view.userInteractionEnabled = YES;
            NET = NO;
        }else{
            [tv2 headerEndRefreshing];
//            self.view.userInteractionEnabled = YES;
            NSLog(@"数据加载失败。");
            NET = NO;
        }
    }];
}
- (void)loadPhotoDataMore
{
    NET = YES;
    NSString *petImagesSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&img_id=%@dog&cat",self.aid,self.lastImg_id]];
    NSString *petImageAPIString = [NSString stringWithFormat:@"%@%@&img_id=%@&sig=%@&SID=%@",PETIMAGESAPI,self.aid,self.lastImg_id,petImagesSig,[ControllerManager getSID]];
//    NSLog(@" 更多国王照片数据API:%@",petImageAPIString);
    [[httpDownloadBlock alloc] initWithUrlStr:petImageAPIString Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"更多国王照片数据:%@", load.dataDict);
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for(int i=0;i<array.count;i++){
                NSDictionary * dict = array[i];
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                
                //model.headImage = tempImage;
                model.title = [USER objectForKey:@"name"];
                model.detail = [USER objectForKey:@"detailName"];
                [self.photosDataArray addObject:model];
                if (i == array.count-1) {
                    self.lastImg_id = model.img_id;
                }
                [model release];
            }
            isPhotoDownload = YES;
            [tv2 reloadData];
            [tv2 footerEndRefreshing];
//            self.view.userInteractionEnabled = YES;
            NET = NO;
        }else{
            [tv2 headerEndRefreshing];
            //            self.view.userInteractionEnabled = YES;
            NSLog(@"数据加载失败。");
            NET = NO;
        }
    }];

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
    
    titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"我的王国"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIImageView * more = [MyControl createImageViewWithFrame:CGRectMake(self.view.frame.size.width-17-17, 32, 17, 17) ImageName:@"moreBtn.png"];
    [navView addSubview:more];
    
    UIButton * moreBtn = [MyControl createButtonWithFrame:CGRectMake(270, 25, 47/2+20, 9/2+16+10+4) ImageName:@"" Target:self Action:@selector(moreBtnClick) Title:nil];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    moreBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//    moreBtn.showsTouchWhenHighlighted = YES;
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
    NSString * filePath = [NSTemporaryDirectory() stringByAppendingString:@"screenshot_pet.png"];
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
    //
//    NSLog(@"%@--%@", self.master_id, [USER objectForKey:@"usr_id"]);
    if ([[USER objectForKey:@"isSuccess"] intValue] && ![[petInfoDict objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
        [self loadAttentionAPI];

    }
    
    [self.view bringSubviewToFront:alphaBtn];
    [self.view bringSubviewToFront:moreView];
    //show more
    alphaBtn.hidden = NO;
    CGRect rect = moreView.frame;
    rect.origin.y -= rect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        moreView.frame = rect;
        alphaBtn.alpha = 0.5;
    }];

    

}
#pragma mark - 创建更多视图
-(void)createMore
{
    alphaBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:nil];
    alphaBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:alphaBtn];
    alphaBtn.alpha = 0;
    alphaBtn.hidden = YES;
    
    // 318*234
    moreView = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 234)];
    moreView.backgroundColor = [ControllerManager colorWithHexString:@"efefef"];
//    [self.view bringSubviewToFront:moreView];
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
    
    if (![[petInfoDict objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
        //stranger and fakeOwner 20 127
        UIView * strangerAndFakeOwnerView = [MyControl createViewWithFrame:CGRectMake(0, 127, 320, 76/2)];
        [moreView addSubview:strangerAndFakeOwnerView];
        
        addBtn = [MyControl createButtonWithFrame:CGRectMake((self.view.frame.size.width-246)/2.0, 0, 246, 76/2) ImageName:@"" Target:self Action:@selector(addBtnClick:) Title:@"捧TA"];
        addBtn.layer.cornerRadius = 8;
        addBtn.layer.masksToBounds = YES;
        [addBtn setBackgroundImage:[[UIImage imageNamed:@"more_greenBg2.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:25] forState:UIControlStateNormal];
        [addBtn setBackgroundImage:[[UIImage imageNamed:@"more_orangeBg2.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:25] forState:UIControlStateSelected];
        [addBtn setTitle:@"捧ing" forState:UIControlStateSelected];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [strangerAndFakeOwnerView addSubview:addBtn];
        
//        attentionBtn = [MyControl createButtonWithFrame:CGRectMake(354/2, 0, 124, 76/2) ImageName:@"more_greenBg.png" Target:self Action:@selector(attentionBtnClick:) Title:@"关注"];
//        [attentionBtn setBackgroundImage:[UIImage imageNamed:@"more_orangeBg.png"] forState:UIControlStateSelected];
//        NSLog(@"attentionBtn:%d",attentionBtn.selected);
//        [attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
//        attentionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [strangerAndFakeOwnerView addSubview:attentionBtn];
        //    strangerAndFakeOwnerView.hidden = YES;
        
    }else{
        //OwnerView
        UIView * ownerView = [MyControl createViewWithFrame:CGRectMake(0, 127, self.view.frame.size.width, 76/2)];
        [moreView addSubview:ownerView];
        
        UIButton * takePhoto = [MyControl createButtonWithFrame:CGRectMake(20, 0, 250/2, 76/2) ImageName:@"" Target:self Action:@selector(takePhoto) Title:@"拍照"];
        takePhoto.backgroundColor = BGCOLOR5;
        takePhoto.layer.cornerRadius = 5;
        takePhoto.layer.masksToBounds = YES;
        takePhoto.titleLabel.font = [UIFont systemFontOfSize:15];
        takePhoto.showsTouchWhenHighlighted = YES;
        [ownerView addSubview:takePhoto];
        //        ownerView.hidden = YES;
        
        UIButton * modifyPetInfo = [MyControl createButtonWithFrame:CGRectMake(355/2, 0, 250/2, 76/2) ImageName:@"" Target:self Action:@selector(modifyPetInfo) Title:@"修改资料"];
        modifyPetInfo.titleLabel.font = [UIFont systemFontOfSize:15];
        modifyPetInfo.backgroundColor = [UIColor lightGrayColor];
        modifyPetInfo.layer.cornerRadius = 5;
        modifyPetInfo.layer.masksToBounds = YES;
        modifyPetInfo.showsTouchWhenHighlighted = YES;
        [ownerView addSubview:modifyPetInfo];
    }
    
    
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

}
-(void)modifyPetInfo
{
    NSLog(@"跳转到修改宠物资料");
    ModifyPetOrUserInfoViewController * vc = [[ModifyPetOrUserInfoViewController alloc] init];
    PetInfoModel * model = [[PetInfoModel alloc] init];
    [model setValuesForKeysWithDictionary:petInfoDict];
    vc.petInfoModel = model;
    [model release];
    
    [self cancelBtnClick];
    vc.refreshPetInfo = ^(void){
        //刷新
        for (UIView * view in self.view.subviews) {
            [view removeFromSuperview];
        }
        //
        isCreated[0] = 0;
        isCreated[1] = 0;
        isCreated[2] = 0;
        isCreated[3] = 0;
        isPhotoDownload = 0;
        isMoreCreated = 0;
        
        //
        [self viewDidLoad];
//        NSString * txPetFilePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [[USER objectForKey:@"petInfoDict"] objectForKey:@"tx"]]];
//        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txPetFilePath]];
//        if (image) {
//            headerImageView.image = image;
//            //连menu头像也换了
//            [self.headButton setBackgroundImage:image forState:UIControlStateNormal];
//        }else{
//            [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL,[[USER objectForKey:@"petInfoDict"] objectForKey:@"tx"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//                if (isFinish) {
//                    //本地目录，用于存放favorite下载的原图
//                    NSLog(@"宠物头像：%@",load.dataImage);
//                    if (load.dataImage == NULL) {
//                        headerImageView.image = [UIImage imageNamed:@"defaultPetHead.png"];
//                    }else{
//                        NSString * docDir = DOCDIR;
//                        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [[USER objectForKey:@"petInfoDict"] objectForKey:@"tx"]]];
//                        //将下载的图片存放到本地
//                        [load.data writeToFile:txFilePath atomically:YES];
//                        headerImageView.image = load.dataImage;
//                        
//                        [self.headButton setBackgroundImage:load.dataImage forState:UIControlStateNormal];
//                    }
//                    
//                }else{
//                    NSLog(@"download failed");
//                }
//            }];
//        }
//        //
//        NSString * str = [[USER objectForKey:@"petInfoDict"] objectForKey:@"name"];
//        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(100, 100) lineBreakMode:NSLineBreakByCharWrapping];
//        name.text = [[USER objectForKey:@"petInfoDict"] objectForKey:@"name"];
//        name.frame = CGRectMake(105, 25, size.width+5, 20);
//        
//        /****页面标题修改*****/
//        titleLabel.text = [NSString stringWithFormat:@"%@联萌", name.text];
//        
//        sex.frame = CGRectMake(name.frame.origin.x+name.frame.size.width, 25, 17, 17);
//        if ([[[USER objectForKey:@"petInfoDict"] objectForKey:@"gender"] intValue] == 1) {
//            sex.image = [UIImage imageNamed:@"man.png"];
//        }else{
//            sex.image = [UIImage imageNamed:@"woman.png"];
//        }
//        
//        cateNameLabel.text = [NSString stringWithFormat:@"%@ | %@", [ControllerManager returnCateNameWithType:[[USER objectForKey:@"petInfoDict"] objectForKey:@"type"]], [MyControl returnAgeStringWithCountOfMonth:[[USER objectForKey:@"petInfoDict"] objectForKey:@"age"]]];
    
    };
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}

/******************************/
-(void)shareClick:(UIButton *)button
{
    NSString * imagePath = [NSTemporaryDirectory() stringByAppendingString:@"screenshot_pet.png"];
    UIImage * screenshotImage = [UIImage imageWithContentsOfFile:imagePath];
    if (button.tag == 200) {
        NSLog(@"微信");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:screenshotImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");

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

                StartLoading;
                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                StartLoading;
                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
            
        }];
    }else{
        NSLog(@"微博");
         NSString * str = @"雷达报告发现一只萌宠，火速围观！http://home4pet.aidigame.com/（分享自@宠物星球社交应用）";
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:screenshotImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");

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
-(void)addBtnClick:(UIButton *)button
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        [self cancelBtnClick];
        return;
    }
    AlertView * view = [[AlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    if (!button.selected) {
//        [self createJoinCountryAlertView];
//        StartLoading;
        //    user/petsApi&usr_id=(若用户为自己则留空不填)
        NSString * code = [NSString stringWithFormat:@"is_simple=0&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
        NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 0, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
        NSLog(@"%@", url);
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSArray * array = [load.dataDict objectForKey:@"data"];
                if (array.count >= 10) {
                    view.AlertType = 3;
                    [view makeUI];
                }else{
                    view.AlertType = 2;
                    [view makeUI];
                    view.jump = ^(){
                        [MyControl startLoadingWithStatus:@"加入中..."];
                        NSString *joinPetCricleSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",self.aid]];
                        NSString *joinPetCricleString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",JOINPETCRICLEAPI,self.aid,joinPetCricleSig,[ControllerManager getSID]];
                        NSLog(@"加入圈子:%@",joinPetCricleString);
                        httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:joinPetCricleString Block:^(BOOL isFinish, httpDownloadBlock *load) {
                            if (isFinish) {
                                NSLog(@"加入成功数据：%@",load.dataDict);
                                if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                                    addBtn.selected = YES;
                                    //                        [alertView hide:YES];
                                    attentionBtn.selected = YES;
                                    //刷新捣捣乱--》摇一摇
                                    self.label1.text = @"摇一摇";
                                    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"shake.png"] forState:UIControlStateNormal];
                                }
                                [MyControl loadingSuccessWithContent:@"加入成功" afterDelay:0.5f];
                                //捧Ta成功界面
                                NoCloseAlert * noClose = [[NoCloseAlert alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                                noClose.confirm = ^(){};
                                [self.view addSubview:noClose];
                                NSString * percent = [NSString stringWithFormat:@"%@", [[load.dataDict objectForKey:@"data"] objectForKey:@"percent"]];
                                [noClose configUIWithTx:[petInfoDict objectForKey:@"tx"] Name:[petInfoDict objectForKey:@"name"] Percent:percent];
                                [UIView animateWithDuration:0.3 animations:^{
                                    noClose.alpha = 1;
                                }];
                            }else{
                                [MyControl loadingFailedWithContent:@"加入失败" afterDelay:0.8f];
                                NSLog(@"加入国家失败");
                            }
                        }];
                        [request release];
                    };
                }
            }
        }];
        [request release];
        //
        
        [self.view addSubview:view];
        [view release];
    }else{
//        [self createExitCountryAlertView];
        view.AlertType = 5;
        [view makeUI];
        view.jump = ^(){
            [self loadMyCountryInfoData];
        };
    }
    [self.view addSubview:view];
    [view release];
}
-(void)attentionBtnClick:(UIButton *)button
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        [self cancelBtnClick];
        return;
    }
    if (!button.selected) {
//        [self createAttentionAlertView];
        [MyControl startLoadingWithStatus:@"关注中..."];
        NSString *petAttentionSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",self.aid]];
        NSString *petAttentionString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",PETATTENTIONAPI,self.aid,petAttentionSig,[ControllerManager getSID]];
        NSLog(@"关注宠物：%@",petAttentionString);
        httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:petAttentionString Block:^(BOOL isFinish, httpDownloadBlock *load) {
            if (isFinish) {
                //                    NSLog(@"关注成功数据：%@",load.dataDict);
                if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                    attentionBtn.selected = YES;
//                    [alertView hide:YES];
                }
                [MyControl loadingSuccessWithContent:@"关注成功" afterDelay:0.5f];
            }else{
                [MyControl loadingFailedWithContent:@"关注失败" afterDelay:0.8f];
                NSLog(@"关注失败");
            }
        }];
        [request release];
    }else{
//        [self createAttentionCancelAlertView];
        AlertView * view = [[AlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        view.AlertType = 4;
        [view makeUI];
        view.jump = ^(){
            //取消关注
            NSString *petAttentionSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",self.aid]];
            NSString *petAttentionString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",PETATTENTIONCANCELAPI,self.aid,petAttentionSig,[ControllerManager getSID]];
            NSLog(@"取消关注宠物：%@",petAttentionString);
            httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:petAttentionString Block:^(BOOL isFinish, httpDownloadBlock *load) {
                if (isFinish) {
                    NSLog(@"取消关注成功数据：%@",load.dataDict);
                    if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                        attentionBtn.selected = NO;
//                        [alertView hide:YES];
                    }
                    
                }else{
                    NSLog(@"关注失败");
                }
            }];
            [request release];
        };
        [self.view addSubview:view];
        [view release];
    }

    
}
-(void)takePhoto
{
    NSLog(@"take photos");
//    moreView.hidden = YES;
//    alphaBtn.hidden = YES;
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
        ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc createLoginAlertView];
        //        [vc autorelease];
    }
    

}
-(void)cancelBtnClick
{
    NSLog(@"cancel");

    [UIView animateWithDuration:0.3 animations:^{
        moreView.frame = CGRectMake(0, self.view.frame.size.height, 320, 234);
        alphaBtn.alpha = 0;
    } completion:^(BOOL finished) {
//        [moreView bringSubviewToFront:self]
        
        alphaBtn.hidden = YES;
    }];
}
#pragma mark - 确认加入国家/离开国家弹窗
- (void)cancelAction
{
    [alertView hide:YES];
}
- (void)sureAction:(UIButton *)sender
{
    if (sender.tag == 222) {
        if (!addBtn.selected) {
            
        }else{
            
            [self loadMyCountryInfoData];

        }
    }else if (sender.tag== 223){
        if (!attentionBtn.selected) {
            
        }else{
            
        }
    }
}
-(void)loadMyCountryInfoData
{
    StartLoading;
    //    user/petsApi&usr_id=(若用户为自己则留空不填)
    NSString * code = [NSString stringWithFormat:@"is_simple=0&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 0, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            //            NSLog(@"%@", load.dataDict);
//            [self.userPetListArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            if (array.count>1) {
                NSString *exitPetCricleSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",self.aid]];
                NSString *exitPetCricleString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",EXITPETCRICLEAPI,self.aid,exitPetCricleSig,[ControllerManager getSID]];
                NSLog(@"退出圈子：%@",exitPetCricleString);
                [MyControl startLoadingWithStatus:@"退出中..."];
                httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:exitPetCricleString Block:^(BOOL isFinish, httpDownloadBlock *load) {
                    if (isFinish) {
                        //                    NSLog(@"退出成功数据：%@",load.dataDict);
                        if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                            addBtn.selected = NO;
                            [alertView hide:YES];
                            //刷新摇一摇--》捣捣乱
                            self.label1.text = @"捣捣乱";
                            [self.btn1 setBackgroundImage:[UIImage imageNamed:@"rock2.png"] forState:UIControlStateNormal];
                        }
                        [MyControl loadingSuccessWithContent:@"退出成功" afterDelay:0.5f];
                    }else{
                        [MyControl loadingFailedWithContent:@"退出失败" afterDelay:0.5f];
                        NSLog(@"退出国家失败");
                    }
                    
                }];
                [request release];
            }else{
               //提示不能退
                [MyControl loadingFailedWithContent:@"您仅有一只萌主，不能退出" afterDelay:0.5f];
            }

        }else{
            LoadingFailed;
        }
    }];
    [request release];
}
- (void)createAttentionAlertView
{
    alertView = [self alertViewInit:CGSizeMake(290, 215)];

    UIView *bodyView =[self JoinAndBuyBody:223 Title:@"确认"];
    UILabel *askLabel1 = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 -80, 80, 160, 20) Font:16 Text:@"确定加入关注吗？"];
    askLabel1.textAlignment = NSTextAlignmentCenter;
    askLabel1.textColor = [UIColor grayColor];
    [bodyView addSubview:askLabel1];
    alertView.customView = bodyView;
    [alertView show:YES];
}
- (void)createAttentionCancelAlertView
{
    alertView = [self alertViewInit:CGSizeMake(290, 215)];
    
    UIView *bodyView =[self JoinAndBuyBody:223 Title:@"确认"];
    NSArray *askArray = @[@"真的忍心取消关注TA么？",@"这是真的么~",@"是么~"];
    for (int i = 0 ; i< askArray.count; i++) {
        UILabel *askLabel1 = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 -80, 40+i*30, 160, 20) Font:16 Text:askArray[i]];
        askLabel1.textAlignment = NSTextAlignmentCenter;
        askLabel1.textColor = [UIColor grayColor];
        [bodyView addSubview:askLabel1];
    }
    alertView.customView = bodyView;
    [alertView show:YES];
}
- (void)createExitCountryAlertView
{
    alertView = [self alertViewInit:CGSizeMake(290, 215)];
    
    UIView *bodyView =[self JoinAndBuyBody:222 Title:@"确认"];
    NSArray *askArray = @[@"你说什么？",@"退出国家！",@"三思而后行啊~"];
    for (int i = 0 ; i< askArray.count; i++) {
        UILabel *askLabel1 = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 -80, 20+i*30, 160, 20) Font:16 Text:askArray[i]];
        askLabel1.textAlignment = NSTextAlignmentCenter;
        askLabel1.textColor = [UIColor grayColor];
        [bodyView addSubview:askLabel1];
    }
    alertView.customView = bodyView;
    [alertView show:YES];
}
- (void)createJoinCountryAlertView
{
    alertView = [self alertViewInit:CGSizeMake(290, 215)];
    
    UIView *bodyView =[self JoinAndBuyBody:222 Title:@"确认"];
    UILabel *askLabel1 = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 -80, 80, 160, 20) Font:16 Text:@"确定加入一个新国家？"];
    askLabel1.textColor = [UIColor grayColor];
    [bodyView addSubview:askLabel1];
    
    UILabel *descLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 - 120, 120, 230, 20) Font:13 Text:@"星球提示：每个人最多加入10个圈子"];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = [UIColor grayColor];
    [bodyView addSubview:descLabel];
    alertView.customView = bodyView;
    [alertView show:YES];
}
- (UIView *)JoinAndBuyBody:(NSInteger)tagNumber Title:(NSString *)titleString
{
    UIView *bodyView = [MyControl createViewWithFrame:CGRectMake(0, 0, 290, 215)];
    bodyView.backgroundColor = [UIColor clearColor];
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 215)];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 0.8;
    [bodyView addSubview:alphaView];
    bodyView.layer.cornerRadius = 10;
    bodyView.layer.masksToBounds = YES;
    
    //创建取消和确认button
    
    UIImageView *cancelImageView = [MyControl createImageViewWithFrame:CGRectMake(250, 5, 30, 30) ImageName:@"button_close.png"];
    [bodyView addSubview:cancelImageView];
    
    UIButton *cancelButton = [MyControl createButtonWithFrame:CGRectMake(250, 5, 30, 30) ImageName:nil Target:self Action:@selector(cancelAction) Title:nil];
    cancelButton.showsTouchWhenHighlighted = YES;
    [bodyView addSubview:cancelButton];
    
    UILabel *sureLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2-70, 160, 140, 35) Font:16 Text:titleString];
    
    sureLabel.backgroundColor = BGCOLOR;
    sureLabel.layer.cornerRadius = 5;
    sureLabel.layer.masksToBounds = YES;
    sureLabel.textAlignment = NSTextAlignmentCenter;
    [bodyView addSubview:sureLabel];
    
    UIButton *sureButton = [MyControl createButtonWithFrame:sureLabel.frame ImageName:nil Target:self Action:@selector(sureAction:) Title:nil];
    sureButton.showsTouchWhenHighlighted = YES;
    sureButton.tag = tagNumber;
    [bodyView addSubview:sureButton];
    return bodyView;
}
- (MBProgressHUD *)alertViewInit:(CGSize)widthAndHeight
{
    MBProgressHUD * alertViewInit = [[MBProgressHUD alloc] initWithWindow:self.view.window];
    [self.view.window addSubview:alertViewInit];
    alertViewInit.mode = MBProgressHUDModeCustomView;
    alertViewInit.color = [UIColor clearColor];
    alertViewInit.dimBackground = YES;
    alertViewInit.margin = 0 ;
    alertViewInit.removeFromSuperViewOnHide = YES;
    //    alertViewInit.minSize = CGSizeMake(235.0f, 340.0f);
    alertViewInit.minSize = widthAndHeight;
    return alertViewInit;
}
#pragma mark - 创建tableView的tableHeaderView
-(void)createHeader
{
    bgView = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 200)];
    [self.view addSubview:bgView];
    
    //
    bgImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    /************************/
    NSString * txPetFilePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [petInfoDict objectForKey:@"tx"]]];
//    NSLog(@"本地宠物头像路径：%@", txPetFilePath);
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txPetFilePath]];
    if (image) {
        bgImageView1.image = [image applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    }else{

        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL,[petInfoDict objectForKey:@"tx"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                //本地目录，用于存放favorite下载的原图
                    NSString * docDir = DOCDIR;
                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [petInfoDict objectForKey:@"tx"]]];
                    //将下载的图片存放到本地
                    [load.data writeToFile:txFilePath atomically:YES];
                    bgImageView1.image = [load.dataImage applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
            }else{
                NSLog(@"download failed");
            }
        }];
    }
    /************************/
    [bgView addSubview:bgImageView1];
    [bgImageView1 release];


    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 200)];
    alphaView.alpha = 0.7;
    alphaView.backgroundColor = [ControllerManager colorWithHexString:@"a85848"];
    [bgView addSubview:alphaView];
//    ClickImage * headerView = [MyControl createImageViewWithFrame:CGRectMake(10, 25, 70, 70) ImageName:@""];
    
    BOOL equal = [self.master_id isEqualToString:[USER objectForKey:@"usr_id"]];
    if (equal) {
        headBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 70, 70) ImageName:@"defaultPetHead.png" Target:self Action:@selector(headerClick) Title:nil];
        headBtn.layer.cornerRadius = 70/2;
        headBtn.layer.masksToBounds = YES;
        [bgView addSubview:headBtn];
    }else{
        headerImageView = [[ClickImage alloc]initWithFrame:CGRectMake(10, 25, 70, 70)];
        headerImageView.image = [UIImage imageNamed:@"defaultPetHead.png"];
        headerImageView.canClick = YES;
        headerImageView.layer.cornerRadius = 70/2;
        headerImageView.layer.masksToBounds = YES;
        [bgView addSubview:headerImageView];
        [headerImageView release];
    }
    
    

    
    if (image) {
        if(equal){
            [headBtn setBackgroundImage:image forState:UIControlStateNormal];
        }else{
            headerImageView.image = image;
        }
        
        
    }else{
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL,[petInfoDict objectForKey:@"tx"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                //本地目录，用于存放favorite下载的原图
                NSLog(@"宠物头像：%@",load.dataImage);
                if (load.dataImage == NULL) {
//                    headerImageView.image = [UIImage imageNamed:@"defaultPetHead.png"];
                }else{
                    NSString * docDir = DOCDIR;
                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [petInfoDict objectForKey:@"tx"]]];
                    //将下载的图片存放到本地
                    [load.data writeToFile:txFilePath atomically:YES];
                    if(equal){
                        [headBtn setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                    }else{
                        headerImageView.image = load.dataImage;
                    }
                }
                
            }else{
                NSLog(@"download failed");
            }
        }];
    }
    
//    UIButton * attentionBtn = [MyControl createButtonWithFrame:CGRectMake(60, 75, 20, 20) ImageName:@"" Target:self Action:@selector(attentionBtnClick) Title:@"关注"];
//    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:10];
//    attentionBtn.layer.cornerRadius = 20/2;
//    attentionBtn.layer.masksToBounds = YES;
//    attentionBtn.backgroundColor = BGCOLOR4;
//    attentionBtn.showsTouchWhenHighlighted = YES;
//    [bgView addSubview:attentionBtn];
    
    //
    NSString * str = [petInfoDict objectForKey:@"name"];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(120, 20) lineBreakMode:NSLineBreakByCharWrapping];
    name = [MyControl createLabelWithFrame:CGRectMake(105, 25, size.width+3, 20) Font:14 Text:str];
    [bgView addSubview:name];
    
    sex = [MyControl createImageViewWithFrame:CGRectMake(name.frame.origin.x+name.frame.size.width, 25, 17, 17) ImageName:@"woman"];
    if ([[petInfoDict objectForKey:@"gender"] intValue] == 1) {
        sex.image = [UIImage imageNamed:@"man.png"];
    }
    [bgView addSubview:sex];
    
    //
    int age = [[petInfoDict objectForKey:@"age"] intValue];

    NSString * cateStr = [NSString stringWithFormat:@"%@ | %@", [ControllerManager returnCateNameWithType:[petInfoDict objectForKey:@"type"]], [MyControl returnAgeStringWithCountOfMonth:[petInfoDict objectForKey:@"age"]]];
    CGSize size3 = [cateStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(130, 100) lineBreakMode:NSLineBreakByCharWrapping];
    cateNameLabel = [MyControl createLabelWithFrame:CGRectMake(105, 55, 130, size3.height) Font:14 Text:[NSString stringWithFormat:@"苏格兰折耳猫 | %d岁", age]];
//    cateNameLabel.font = [UIFont boldSystemFontOfSize:13];
//    cateNameLabel.alpha = 0.65;
    cateNameLabel.text = cateStr;
    [bgView addSubview:cateNameLabel];
    
    
    /*****************************/
    NSString *str2 = [NSString stringWithFormat:@"经纪人—%@",[petInfoDict objectForKey:@"u_name"]];
//    NSString *str2 = [NSString stringWithFormat:@"祭司 - %@",[self.userDataArray[0] u_name]];
    CGSize size2 = [str2 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 100) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel * positionAndUserName = [MyControl createLabelWithFrame:CGRectMake(105, 170/2, size2.width, 20) Font:14 Text:str2];
//    positionAndUserName.font = [UIFont boldSystemFontOfSize:15];
    [bgView addSubview:positionAndUserName];
    
    //用户头像，点击进入个人中心
    UIButton * userImageBtn = [MyControl createButtonWithFrame:CGRectMake(positionAndUserName.frame.origin.x+positionAndUserName.frame.size.width+5, 160/2, 30, 30) ImageName:@"" Target:self Action:@selector(jumpToUserInfo) Title:nil];
    userImageBtn.layer.cornerRadius = 15;
    userImageBtn.layer.masksToBounds = YES;
    [bgView addSubview:userImageBtn];
    
    NSString * txUserFilePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [petInfoDict objectForKey:@"u_tx"]]];
//    NSLog(@"本地用户头像路径：%@", txUserFilePath);
    UIImage *User_image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txUserFilePath]];
    if (User_image) {
        [userImageBtn setBackgroundImage:User_image forState:UIControlStateNormal];
    }else{
        
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", USERTXURL,[petInfoDict objectForKey:@"u_tx"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"load.dataImage:%@",load.dataImage);
                if (load.dataImage == NULL) {
                    [userImageBtn setBackgroundImage:[UIImage imageNamed:@"defaultPetHead.png"] forState:UIControlStateNormal];
                }else{
                    //本地目录，用于存放favorite下载的原图
                    NSString * docDir = DOCDIR;
                    NSString * txUserFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [petInfoDict objectForKey:@"u_tx"]]];
                    //将下载的图片存放到本地
                    [load.data writeToFile:txUserFilePath atomically:YES];
                    [userImageBtn setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                }
            }else{
                NSLog(@"download failed");
            }
        }];
    }

    
    //123  164
    UIImageView * flagImageView = [MyControl createImageViewWithFrame:CGRectMake(240, 0, 123*0.45, 164*0.45) ImageName:@"flag.png"];
    [bgView addSubview:flagImageView];
    
    
    UIButton * GXList = [MyControl createButtonWithFrame:CGRectMake(2, 5, 52, 24) ImageName:@"" Target:self Action:@selector(GXListClick) Title:@"贡献榜"];
    GXList.titleLabel.font = [UIFont systemFontOfSize:12];
//    GXList.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    GXList.showsTouchWhenHighlighted = YES;
    [flagImageView addSubview:GXList];

    UIButton * RQList = [MyControl createButtonWithFrame:CGRectMake(2, 32, 52, 24) ImageName:@"" Target:self Action:@selector(RQListClick) Title:@"人气榜"];
//    RQList.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    RQList.titleLabel.font = [UIFont systemFontOfSize:12];
    RQList.showsTouchWhenHighlighted = YES;
    [flagImageView addSubview:RQList];
    
    //人气、成员、粉丝数
    int t_rq = [[petInfoDict objectForKey:@"t_rq"] intValue];
    int fans = [[petInfoDict objectForKey:@"fans"] intValue];
//    int followers = [[petInfoDict objectForKey:@"followers"] intValue];
    NSString * dataStr = [NSString stringWithFormat:@"总人气 %d  |   成员 %d", t_rq, fans];
    UILabel * dataLabel = [MyControl createLabelWithFrame:CGRectMake(0, 130, 320, 15) Font:13 Text:dataStr];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:dataLabel];
    
}
-(void)headerClick
{
    [self modifyPetInfo];
}
#pragma mark - 跳转点击事件
-(void)jumpToUserInfo
{
    UserInfoViewController * vc = [[UserInfoViewController alloc] init];
//    NSLog(@"%@", petInfoDict);
    vc.usr_id = [petInfoDict objectForKey:@"master_id"];
    vc.modalTransitionStyle = 2;
    vc.isFromPetInfo = YES;
    if ([self.master_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
        vc.petHeadImage = headBtn.currentBackgroundImage;
    }else{
        vc.petHeadImage = headerImageView.image;
    }
    
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)GXListClick
{
    NSLog(@"跳转贡献榜");

    ContributionViewController * vc = [[ContributionViewController alloc] init];
    vc.aid = self.aid;
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)RQListClick
{
    NSLog(@"跳转人气榜");
    PopularityListViewController * vc = [[PopularityListViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)attentionBtnClick
{
    NSLog(@"attention");
}
#pragma mark - 创建scrollView
-(void)createScrollView
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    sv.contentSize = CGSizeMake(320*4, self.view.frame.size.height);
    sv.delegate = self;
    sv.pagingEnabled = YES;
    sv.scrollEnabled = NO;
    [self.view addSubview:sv];
}

#pragma mark - 创建tableView
- (void)createNewsTableView
{
    //动态
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = 0;
    [sv addSubview:tv];
    
    UIView * tvHeaderView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 264)];
    tv.tableHeaderView = tvHeaderView;

}
- (void)createPhotosTableView
{
    //图片
    tv2 = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv2.delegate = self;
    tv2.dataSource = self;
    tv2.separatorStyle = 0;
    [tv2 addFooterWithTarget:self action:@selector(loadPhotoDataMore)];
    [sv addSubview:tv2];
    
    UIView * tvHeaderView2 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 264)];
    tv2.tableHeaderView = tvHeaderView2;

}
- (void)createCountryMembersTableView
{
    //成员
    tv3 = [[UITableView alloc] initWithFrame:CGRectMake(320*2, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv3.delegate = self;
    tv3.dataSource = self;
    tv3.separatorStyle = 0;
//    [tv3 addFooterWithTarget:self action:@selector(loadKingMembersDataMore)];
    [sv addSubview:tv3];
    
    UIView * tvHeaderView3 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 264)];
    tv3.tableHeaderView = tvHeaderView3;
}
- (void)createPresentsTableView
{
    //礼物
    tv4 = [[UITableView alloc] initWithFrame:CGRectMake(320*3, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv4.delegate = self;
    tv4.dataSource = self;
    tv4.separatorStyle = 0;
    [sv addSubview:tv4];
    
    UIView * tvHeaderView4 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 264)];
    tv4.tableHeaderView = tvHeaderView4;

}
-(void)createToolsView
{
    [self.view bringSubviewToFront:bgView];
    [self.view bringSubviewToFront:navView];
    
    //为保证切换条在所有层的最上面，所以在此创建
    toolBgView = [MyControl createViewWithFrame:CGRectMake(0, 64+200-44, 320, 44)];
    [self.view addSubview:toolBgView];
    
    UIView * toolAlphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 44)];
    toolAlphaView.alpha = 0.4;
    toolAlphaView.backgroundColor = [ControllerManager colorWithHexString:@"8e2918"];
    [toolBgView addSubview:toolAlphaView];
    
    NSArray * unSeletedArray = @[@"tool1.png", @"tool2.png", @"tool3.png", @"tool4.png"];
    NSArray * seletedArray = @[@"tool1_selected.png", @"tool2_selected.png", @"tool3_selected.png", @"tool4_selected.png"];
    for(int i=0;i<seletedArray.count;i++){
        UIButton * imageButton = [MyControl createButtonWithFrame:CGRectMake(25+i*80, 9, 30, 26) ImageName:unSeletedArray[i] Target:self Action:@selector(imageButtonClick) Title:nil];
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
}
-(void)imageButtonClick
{
    NSLog(@"111");
}
#pragma mark -
-(void)toolBtnClick:(UIButton *)button
{
    for(int i=0;i<4;i++){
        UIButton * btn = (UIButton *)[toolBgView viewWithTag:100+i];
        btn.selected = NO;
    }
    int a = button.tag;
    UIButton * temp = (UIButton *)[toolBgView viewWithTag:a-100];
    temp.selected = YES;
   
//    if (isCreated[0]) {
//        [self loadKingDynamicData];
//    }else if (isCreated)
    
    int x = a-200;
    if (x == 0) {
        tempTv = tv;
//        if (!isCreated[0]) {
//            [self loadKingDynamicData];
//            isCreated[0] = 1;
//        }
    }else if(x == 1){
        tempTv = tv2;
        if (!isCreated[1]) {
            [self loadPhotoData];
            isCreated[1] = 1;
        }
    }else if(x == 2){
        tempTv = tv3;
        if (!isCreated[2]) {
            [self loadKingMembersData];
            isCreated[2] = 1;
        }
    }else{
        tempTv = tv4;
        if (!isCreated[3]) {
            [self loadKingPresentsData];
            isCreated[3] = 1;
        }
    }

    [UIView animateWithDuration:0.2 animations:^{
        bottom.frame = CGRectMake(x*80, 40, 80, 4);
//        tempTv.contentOffset = CGPointMake(0, 0);
//        tempTv = nil;
//        bgView.frame = CGRectMake(0, 64, 320, 200);
//        toolBgView.frame = CGRectMake(0, 64+200-44, 320, 44);
        sv.contentOffset = CGPointMake(320*x, 0);
    }];
}

#pragma mark - scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollView.contentOffset.y = %f", scrollView.contentOffset.y);
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

}
#pragma mark - tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tv2) {
        return self.photosDataArray.count;
    }else if(tableView == tv4){
        return 1;
    }else if(tableView == tv3){
        return self.countryMembersDataArray.count;
    }else{
        //tv
        return self.newsDataArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv) {
        static NSString * cellID = @"ID";
        MyCountryMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[[MyCountryMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        }
        cell.selectionStyle = 0;
        cell.clipsToBounds = YES;
        PetNewsModel * model = self.newsDataArray[indexPath.row];
        [cell modifyWithModel:model PetName:[petInfoDict objectForKey:@"name"]];
    
        cell.clickImage = ^(){
            PicDetailViewController * vc = [[PicDetailViewController alloc] init];
            vc.img_id = [[model content] objectForKey:@"img_id"];
            vc.usr_id = [[model content] objectForKey:@"usr_id"];
            [self presentViewController:vc animated:YES completion:nil];
            [vc release];
        };
        cell.sendGift = ^(){
            [self sendGift];
        };
        return cell;
    }else if (tableView == tv2) {
        static NSString * cellID2 = @"ID2";
        MyPhotoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if(!cell){
            cell = [[[MyPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2] autorelease];
        }
        cell.selectionStyle = NO;
        cell.unRegister = ^(){
            ShowAlertView;
            return;
        };
        //照片下载完后加载
        if (isPhotoDownload) {
            PhotoModel * model = self.photosDataArray[indexPath.row];
            
            [cell configUI:model type:[petInfoDict objectForKey:@"type"]];
//            NSLog(@"照片张数%d", self.photosDataArray.count);
            
            //本地目录，用于存放下载的原图
            NSString * docDir = DOCDIR;
            if (!docDir) {
                NSLog(@"Documents 目录未找到");
            }else{
                NSString * filePath2 = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@_middle.png", model.url]];
                UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath2]];
                if (image) {
                    cell.bigImageView.image = image;
                }else{
                    [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                        if (isFinish) {
                            //本地目录，用于存放favorite下载的原图
                            NSString * docDir = DOCDIR;
                            if (!docDir) {
                                NSLog(@"Documents 目录未找到");
                            }else{
                                NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
                                NSString * filePath2 = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@_middle.png", model.url]];
                                //将下载的图片存放到本地
                                [load.data writeToFile:filePath atomically:YES];
                                
                                UIImage * image2 = [MyControl returnImageWithImage:load.dataImage Width:self.view.frame.size.width Height:200.0f];
                                
                                cell.bigImageView.image = image2;
                                
                                NSData * smallImageData = UIImageJPEGRepresentation(image2, 0.1);
                                [smallImageData writeToFile:filePath2 atomically:YES];
//                                cell.bigImageView.frame = CGRectMake(0, 0, width, height);
//                                cell.bigImageView.center = CGPointMake(320/2, 100);
                            }
                        }else{
                        }
                    }];
                }
            }
        }
        
        return cell;
    }else if (tableView == tv3) {
        static NSString * cellID3 = @"ID3";
        MyCountryContributeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCountryContributeCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = 0;
        
        if (indexPath.row == 0) {
            [cell modifyWithBOOL:YES lineNum:indexPath.row];
        }else{
            [cell modifyWithBOOL:NO lineNum:indexPath.row];
        }
        CountryMembersModel *model = [self.countryMembersDataArray objectAtIndex:indexPath.row];
        [cell configUI:model];
        return cell;
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
            
            UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(-1, 4, 20, 9) Font:8 Text:@"人气"];
            rq.font = [UIFont boldSystemFontOfSize:8];
            rq.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
            [imageView addSubview:rq];
            
            UILabel * rqNum = [MyControl createLabelWithFrame:CGRectMake(-1, 11, 25, 10) Font:8 Text:@"+150"];
            rqNum.font = [UIFont systemFontOfSize:8];
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
            
            UIImageView * giftPic = [MyControl createImageViewWithFrame:CGRectMake(13, 20, 59, 50) ImageName:[NSString stringWithFormat:@"%@.png", [dict objectForKey:@"no"]]];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv2) {
        PhotoModel * model = self.photosDataArray[indexPath.row];
        //跳转到详情页，并传值
        PicDetailViewController * vc = [[PicDetailViewController alloc] init];
        vc.img_id = model.img_id;
        vc.usr_id = model.usr_id;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }
    if (tableView == tv3) {
//        NSLog(@"%@--%@", [self.countryMembersDataArray[0] name], [self.countryMembersDataArray[0] usr_id]);
        CountryMembersModel * model = self.countryMembersDataArray[indexPath.row];
        
//        NSLog(@"%d--%d--%@--%@--%@", indexPath.row, self.countryMembersDataArray.count, model.tx, model.usr_id, [self.countryMembersDataArray[indexPath.row] usr_id]);
        //跳转到用户页面
//        NSLog(@"model.usr_id:%@--%@---%@",model.usr_id,model.city,model.gender);
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
//        NSLog(@"%@", model.usr_id);
        userInfoVC.usr_id = model.usr_id;
        [self presentViewController:userInfoVC animated:YES completion:^{
            [userInfoVC release];
        }];
    }
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv) {
        PhotoModel * model = self.newsDataArray[indexPath.row];
        int a = [model.type intValue];
        //1.成粉 2.加入 3.发图 4.送礼 5.叫一叫 6.逗一逗 7.捣乱
        if (a == 1) {
            return 70.0f;
        }else if (a == 2) {
            return 70.0f;
        }else if (a == 3) {
            return 130.0f;
        }else if (a == 4) {
            return 125.0f;
        }else if (a == 5) {
            return 90.0f;
        }else if (a == 6) {
            return 90.0f;
        }else{
            return 105.0f;
        }
    }else if (tableView == tv2) {
        return 230.0f;
    }else if (tableView == tv3) {
        return 72.0f;
    }else{
        int i = self.goodsArray.count;
        if (i%3) {
            //50是为了避免被4个动作挡住
            return 15+(i/3+1)*100+50;
        }else{
            return 15+i/3*100+50;
        }
    }
 
}

//礼物点击事件
-(void)buttonClick:(UIButton *)btn
{
    NSLog(@"%d", btn.tag);
}
#pragma mark - 送礼
-(void)sendGift
{
    NSLog(@"赠送礼物");
    
    if (![ControllerManager getIsSuccess]) {
        //提示注册
        ShowAlertView;
        return;
    }else{
        SendGiftViewController * quictGiftvc = [[SendGiftViewController alloc] init];
        quictGiftvc.receiver_aid = [petInfoDict objectForKey:@"aid"];
        quictGiftvc.receiver_name = [petInfoDict objectForKey:@"name"];
        //
        quictGiftvc.hasSendGift = ^(NSString * itemId){
            [self loadKingDynamicData];
        };
        
        [self addChildViewController:quictGiftvc];
        [quictGiftvc didMoveToParentViewController:self];
        [self.view addSubview:quictGiftvc.view];
        [quictGiftvc release];
        
    }
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
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSURL * assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    void(^completion)(void)  = ^(void){
        if (isCamara) {
            [self lauchEditorWithImage:image];
        }else{
            [[self assetLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                if (asset){
                    [self launchEditorWithAsset:asset];
                }
            } failureBlock:^(NSError *error) {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable access to your device's photos." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }];
        }};
    
    [self dismissViewControllerAnimated:NO completion:completion];
    
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
    
    __block PetInfoViewController * blockSelf = self;
    
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
        vc.aid = self.aid;
        vc.name = [petInfoDict objectForKey:@"name"];
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
