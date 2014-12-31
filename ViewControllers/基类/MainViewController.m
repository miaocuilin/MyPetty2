//
//  MainViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MainViewController.h"
#import "RandomViewController.h"
#import "FavoriteViewController.h"
#import "RecommendViewController.h"
#import "PlanetAttentionViewController.h"
#import "RegisterViewController.h"
#import "PublishViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <AviarySDK/AviarySDK.h>
#import "ToolTipsViewController.h"
#import "ShakeViewController.h"
#import "TipsView.h"
#import "NewWaterFlowViewController.h"
#import "PetRecommendViewController.h"
#import "MyStarViewController.h"
#import "SearchResultModel.h"
#import "PetSearchCell.h"
#import "PetInfoViewController.h"
#import "UserInfoModel.h"
#import "UserInfoViewController.h"
#import "SingleTalkModel.h"
#import "MessageModel.h"

#define WORDCOLOR [UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1]
#define BROWNCOLOR [UIColor colorWithRed:247/255.0 green:192/255.0 blue:152/255.0 alpha:1]
static NSString * const kAFAviaryAPIKey = @"b681eafd0b581b46";
static NSString * const kAFAviarySecret = @"389160adda815809";
@interface MainViewController () <AFPhotoEditorControllerDelegate>
{
    MyStarViewController * vc1;
    RandomViewController * vc2;
//    PlanetAttentionViewController * vc3;
    PetRecommendViewController * vc3;
}
@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    if (!([[USER objectForKey:@"petInfoDict"] isKindOfClass:[NSDictionary class]] && [[[USER objectForKey:@"petInfoDict"] objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]])) {
        camara.hidden = YES;
    }else{
        camara.hidden = NO;
    }
//    self.pet_aid = [USER objectForKey:@"aid"];
//    self.pet_name = [USER objectForKey:@"a_name"];
//    self.pet_tx = [USER objectForKey:@"a_tx"];
//    if (![self.currentTx isEqualToString:[[USER objectForKey:@"petInfoDict"] objectForKey:@"tx"]]) {
//        if ([[USER objectForKey:@"petInfoDict"] isKindOfClass:[NSDictionary class]] && [USER objectForKey:@"petInfoDict"] != nil) {
//            /**************************/
//            NSDictionary * dict = [USER objectForKey:@"petInfoDict"];
//            if (!([[dict objectForKey:@"tx"] isKindOfClass:[NSNull class]] || [[dict objectForKey:@"tx"] length]==0)) {
//                NSString * docDir = DOCDIR;
//                NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [dict objectForKey:@"tx"]]];
//                NSLog(@"--%@--%@", txFilePath, [dict objectForKey:@"tx"]);
//                UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
//                if (image) {
//                    [self.headButton setBackgroundImage:image forState:UIControlStateNormal];
//                    //            headImageView.image = image;
//                }else{
//                    //下载头像
//                    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, [dict objectForKey:@"tx"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//                        if (isFinish) {
//                            [self.headButton setBackgroundImage:load.dataImage forState:UIControlStateNormal];
//                            //                    headImageView.image = load.dataImage;
//                            NSString * docDir = DOCDIR;
//                            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [dict objectForKey:@"tx"]]];
//                            [load.data writeToFile:txFilePath atomically:YES];
//                        }else{
//                            NSLog(@"头像下载失败");
//                        }
//                    }];
//                    [request release];
//                }
//            }else{
//                [self.headButton setBackgroundImage:[UIImage imageNamed:@"defaultPetHead.png"] forState:UIControlStateNormal];
//            }
//            /**************************/
//        }else{
//            [self.headButton setBackgroundImage:[UIImage imageNamed:@"defaultPetHead.png"] forState:UIControlStateNormal];
//        }
//    }
    //判断isLoaded和confVersion和是否是刚注册完3项来判断是否要弹出输入邀请码
    if(isLoaded && ![[USER objectForKey:@"confVersion"] isEqualToString:@"1.0"] && [[USER objectForKey:@"isJustRegister"] intValue]){
        [USER setObject:@"0" forKey:@"isJustRegister"];
        [self inputCode];
    }
    
    if(isLoaded && [[USER objectForKey:@"isSuccess"] intValue]){
        [self getNewMessage];
    }
}
#pragma mark -
-(void)inputCode
{
    CodeAlertView * codeView = [[CodeAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    codeView.AlertType = 1;
    [codeView makeUI];
    [self.view addSubview:codeView];
    [UIView animateWithDuration:0.2 animations:^{
        codeView.alpha = 1;
    }];
    codeView.confirmClick = ^(NSString * code){
        //请求API
        StartLoading;
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
//                }
                
                [USER setObject:model.inviter forKey:@"inviter"];
                [model release];
                LoadingSuccess;
            }else{
                [MyControl loadingFailedWithContent:@"加载失败，请检查网络连接" afterDelay:0.2];
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
#pragma mark -
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isLoaded = YES;
    
    self.menuBtn.selected = NO;
//    TipsView *tips = [[TipsView alloc] initWithFrame:self.view.frame tipsName:REGISTER];
//    [self.view addSubview:tips];
//    if ([[USER objectForKey:@"petInfoDict"] isKindOfClass:[NSDictionary class]] && [[[USER objectForKey:@"petInfoDict"] objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
//        self.label3.text = @"萌叫叫";
//        [self.btn3 setBackgroundImage:[UIImage imageNamed:@"sound.png"] forState:UIControlStateNormal];
//    }else{
//        self.label3.text = @"萌印象";
//        [self.btn3 setBackgroundImage:[UIImage imageNamed:@"touch.png"] forState:UIControlStateNormal];
//    }
    
}
//-(BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
//-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    NSLog(@"========motionBegan");
//}

- (void)viewDidLoad
{
    
//    self.pet_aid = [USER objectForKey:@"aid"];
//    self.pet_name = [USER objectForKey:@"a_name"];
//    self.pet_tx = [USER objectForKey:@"a_tx"];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Allocate Asset Library
    ALAssetsLibrary * assetLibrary = [[ALAssetsLibrary alloc] init];
    [self setAssetLibrary:assetLibrary];
    
    // Allocate Sessions Array
    NSMutableArray * sessions = [NSMutableArray new];
    [self setSessions:sessions];
    [sessions release];
    
    // Start the Aviary Editor OpenGL Load
    [AFOpenGLManager beginOpenGLLoad];

    self.searchArray = [NSMutableArray arrayWithCapacity:0];
    self.searchUserArray = [NSMutableArray arrayWithCapacity:0];
    //
    self.talkIDArray = [NSMutableArray arrayWithCapacity:0];
    self.nwDataArray = [NSMutableArray arrayWithCapacity:0];
    self.nwMsgDataArray = [NSMutableArray arrayWithCapacity:0];
    self.keysArray = [NSMutableArray arrayWithCapacity:0];
    self.valuesArray = [NSMutableArray arrayWithCapacity:0];
    
    segmentClickIndex = 1;
    [self createScrollView];
    [self createFakeNavigation];
    [self createViewControllers];
    [self createSegment];
    [self createTableView];
    [self createSearchView];
    
//    [self.view bringSubviewToFront:self.menuBgBtn];
//    [self.view bringSubviewToFront:self.menuBgView];
    
    [self createAlphaBtn];
    
    if([[USER objectForKey:@"isSuccess"] intValue]){
        [self getNewMessage];
    }
    
//    if ([ControllerManager getIsSuccess]) {
//        [self loadAnimalInfoData];
//    }
//    if ([[USER objectForKey:@"petInfoDict"] isKindOfClass:[NSDictionary class]] && [[[USER objectForKey:@"petInfoDict"] objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
//        self.label3.text = @"叫一叫";
//        [self.btn3 setBackgroundImage:[UIImage imageNamed:@"shout.png"] forState:UIControlStateNormal];
//    }else{
//        self.label3.text = @"摸一摸";
//        [self.btn3 setBackgroundImage:[UIImage imageNamed:@"touch.png"] forState:UIControlStateNormal];
//    }
    
//    [self checkUpdateOutVer:@"1.0.1" InsideVer:@"1.0.1"];
}
-(void)loadMoreUser
{
//    if(!isSearchUser){
//        [tv footerEndRefreshing];
//        return;
//    }
    StartLoading;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"page=%ddog&cat", page]];
    NSString * url = [NSString stringWithFormat:@"%@%@&page=%d&sig=%@&SID=%@", SEARCHUSERAPI, [tf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], page, sig,[ControllerManager getSID]];
    NSLog(@"%@--%@--%@", tf.text, self.tfString, url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            //NSLog(@"%@", load.dataDict);
            
            NSArray *array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            if (array.count == 0) {
                [tv footerEndRefreshing];
                LoadingSuccess;
                return;
            }
            for (NSDictionary *dict in array) {
                UserInfoModel *model = [[UserInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.searchUserArray addObject:model];
                [model release];
            }
            [tv footerEndRefreshing];
            LoadingSuccess;
            [tv reloadData];
            page++;
            
        }else{
            [tv footerEndRefreshing];
            LoadingFailed;
        }
    }];
    [request release];
}
-(void)loadMorePets
{
    StartLoading;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.lastAid]];
    NSString * url = [NSString stringWithFormat:@"%@&aid=%@&name=%@&sig=%@&SID=%@", SEARCHAPI, self.lastAid, [tf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], sig,[ControllerManager getSID]];
//            NSLog(@"%@--%@--%@", tf.text, self.tfString, url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
//           NSLog(@"%@", load.dataDict);

            
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            if (array.count == 0) {
                LoadingSuccess;
                [tv footerEndRefreshing];
                return;
            }
            for (NSDictionary *dict in array) {
                SearchResultModel *model = [[SearchResultModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.searchArray addObject:model];
                [model release];
            }
            self.lastAid = [self.searchArray[self.searchArray.count-1] aid];
            LoadingSuccess;
            [tv footerEndRefreshing];
            [tv reloadData];
            
//            self.sv.scrollEnabled = NO;
//            blurImageView.hidden = NO;
//            if (segmentClickIndex == 0) {
//                vc1.view.hidden = YES;
//            }else if(segmentClickIndex == 1){
//                vc2.view.hidden = YES;
//            }else if (segmentClickIndex == 2){
//                vc3.view.hidden = YES;
//            }
            
        }else{
            [tv footerEndRefreshing];
            LoadingFailed;
        }
    }];
    [request release];
}
-(void)createTableView
{
    blurImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"blurBg.png"];
    [self.view insertSubview:blurImageView belowSubview:navView];
    blurImageView.hidden = YES;
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tv.dataSource = self;
    tv.delegate = self;
    tv.separatorStyle = 0;
    tv.backgroundColor = [UIColor clearColor];
    [blurImageView addSubview:tv];
    [tv release];
    [tv addFooterWithCallback:^{
        [self loadMorePets];
    }];
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, tv.frame.size.width, 35)];
    tv.tableHeaderView = view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d", self.searchArray.count);
    if (isSearchUser) {
        return self.searchUserArray.count;
    }else{
        return self.searchArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    PetSearchCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PetSearchCell" owner:self options:nil] objectAtIndex:0];
    }
    if (!isSearchUser) {
        SearchResultModel * model = self.searchArray[indexPath.row];
        [cell configUI:model];
    }else{
        UserInfoModel * model = self.searchUserArray[indexPath.row];
        [cell configUI2:model];
    }
    
    
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row);
    if (isSearchUser) {
        UserInfoViewController * vc = [[UserInfoViewController alloc] init];
        vc.usr_id = [self.searchUserArray[indexPath.row] usr_id];
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }else{
        PetInfoViewController * vc = [[PetInfoViewController alloc] init];
        vc.aid = [self.searchArray[indexPath.row] aid];
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }
    
//    [cancel setTitle:@"取消" forState:UIControlStateNormal];
//    [self cancelClick:cancel];
}
//- (void)loadAnimalInfoData
//{
//    NSString *aid = [USER objectForKey:@"aid"];
//    NSString *animalInfoSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",aid]];
//    NSString *animalInfo = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",ANIMALINFOAPI,aid,animalInfoSig,[ControllerManager getSID]];
//    NSLog(@"宠物信息API:%@",animalInfo);
//    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:animalInfo Block:^(BOOL isFinish, httpDownloadBlock *load) {
//        NSLog(@"Main宠物信息：%@",load.dataDict);
//        if (isFinish) {
//            self.masterID =[[load.dataDict objectForKey:@"data"] objectForKey:@"master_id"];
//            super.animalInfoDict = [load.dataDict objectForKey:@"data"];
//            //            [self createMenu];
//            super.shakeInfoDict = [load.dataDict objectForKey:@"data"];
//                
//            if ([self.masterID isEqualToString:[USER objectForKey:@"usr_id"]]){
//                self.label3.text = @"叫一叫";
//            }
//            
//        }
//    }];
//    [request release];
//    
//    if (!([[USER objectForKey:@"a_tx"] isKindOfClass:[NSNull class]] || [[USER objectForKey:@"a_tx"] length]==0)) {
//        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@_headImage.png.png", DOCDIR, [USER objectForKey:@"aid"]];
//        
//        UIImage *image =[UIImage imageWithContentsOfFile:pngFilePath];
//        if (image) {
//            [self.headButton setBackgroundImage:image forState:UIControlStateNormal];
//        }else{
//            httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@",PETTXURL,[USER objectForKey:@"a_tx"]] Block:^(BOOL isFinish, httpDownloadBlock *load) {
//                if (isFinish) {
//                    if (load.dataImage == NULL) {
//                        [self.headButton setBackgroundImage:[UIImage imageNamed:@"defaultPetHead.png"] forState:UIControlStateNormal];
//                    }else{
//                        [self.headButton setBackgroundImage:load.dataImage forState:UIControlStateNormal];
//                        [load.data writeToFile:pngFilePath atomically:YES];
//                    }
//                }
//            }];
//            [request release];
//        }
//    }
//}
/***********************/
-(void)createAlphaBtn
{
    self.alphaBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(hideSideMenu) Title:nil];
    self.alphaBtn.backgroundColor = [UIColor blackColor];
    self.alphaBtn.alpha = 0;
    self.alphaBtn.hidden = YES;
    [self.view addSubview:self.alphaBtn];
}
-(void)hideSideMenu
{
    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
    [menu hideMenuAnimated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.alphaBtn.alpha = 0;
    } completion:^(BOOL finished) {
        self.alphaBtn.hidden = YES;
        self.menuBtn.selected = NO;
    }];
}

-(void)topBtnClick
{
    [tf becomeFirstResponder];
    sc.hidden = YES;
    searchBg.hidden = NO;
    
//    sv.scrollEnabled = NO;
//    blurImageView.hidden = NO;
//    if (segmentClickIndex == 0) {
//        vc1.view.hidden = YES;
//    }else if(segmentClickIndex == 1){
//        vc2.view.hidden = YES;
//    }else if (segmentClickIndex == 2){
//        vc3.view.hidden = YES;
//    }
}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    self.menuBtn = [MyControl createButtonWithFrame:CGRectMake(17, 30, 82/2, 54/2) ImageName:@"menu.png" Target:self Action:@selector(menuBtnClick:) Title:nil];
    self.menuBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:self.menuBtn];
    
    //新消息数
    self.msgNum = [MyControl createImageViewWithFrame:CGRectMake(35, -5, 19, 18) ImageName:@"main_msgNum.png"];
    [self.menuBtn addSubview:self.msgNum];
    self.msgNum.hidden = YES;
    
    self.numLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 19, 18) Font:9 Text:@"0"];
    self.numLabel.textColor = BGCOLOR;
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    [self.msgNum addSubview:self.numLabel];
    
    
    NSString * str = @"宠物星球";
    CGSize size = [str sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:1];
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake((self.view.frame.size.width-size.width)/2.0, 32, size.width, 20) Font:17 Text:@"宠物星球"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIImageView * search = [MyControl createImageViewWithFrame:CGRectMake(titleLabel.frame.origin.x+size.width+5, 32+2.5, 15, 15) ImageName:@"main_search.png"];
    [navView addSubview:search];
    
    UIButton * topBtn = [MyControl createButtonWithFrame:CGRectMake(titleLabel.frame.origin.x, 32, size.width+20, 20) ImageName:@"" Target:self Action:@selector(topBtnClick) Title:nil];
//    topBtn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:topBtn];
    
    camara = [MyControl createButtonWithFrame:CGRectMake(320-82/2-15, 64-54/2-7, 82/2, 54/2) ImageName:@"相机图标.png" Target:self Action:@selector(cameraClick) Title:nil];
    camara.showsTouchWhenHighlighted = YES;
    [navView addSubview:camara];
}
#pragma mark - 
#pragma mark -
-(void)getNewMessage
{
//    StartLoading;
    NSString * url = [NSString stringWithFormat:@"%@%@", GETNEWMSGAPI,[ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"/*=====================*/");
            NSLog(@"newMsg:%@", load.dataDict);
            NSLog(@"/*=====================*/");
            //【注意】这里需要将talkIDArray每次清空
            [self.talkIDArray removeAllObjects];
            [self.nwDataArray removeAllObjects];
            [self.nwMsgDataArray removeAllObjects];
            
            NSArray * array = [load.dataDict objectForKey:@"data"];
            if (array.count) {
                self.hasNewMsg = YES;
                
                for (int i=0; i<array.count; i++) {
                    NSDictionary * dict = array[i];
                    NSString * key = [[dict allKeys] objectAtIndex:0];
                    NSDictionary * dict2 = [dict objectForKey:key];
                    if ([[dict2 objectForKey:@"usr_name"] isKindOfClass:[NSNull class]]) {
                        [dict2 setValue:@"" forKey:@"usr_name"];
                    }
                    if ([[dict2 objectForKey:@"usr_tx"] isKindOfClass:[NSNull class]]) {
                        [dict2 setValue:@"" forKey:@"usr_tx"];
                    }
                }
                
                [self.nwDataArray addObjectsFromArray:array];
            }else{
                self.hasNewMsg = NO;
            }
            
            /**********************/
            NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
            NSLog(@"%@", [[MyControl returnDictionaryWithDataPath:path] allKeys]);
            
            if (self.hasNewMsg) {
                //分解数据添加到7个数组中
                [self apartNewMsgToArray];
                //查看是否有旧消息，进行合并
                [self loadHistoryMessageAndSaveToLocal];
                
                //遍历整个本地字典，拿到消息数之和，返回给侧边栏
                self.msgNum.hidden = NO;
                self.numLabel.text = [self getNewMessageNum];
//                self.refreshNewMsgNum([self getNewMessageNum]);
//                LoadingSuccess;
            }else{
                //遍历本地消息，取出未读数相加返回
                NSFileManager * fileManager = [[NSFileManager alloc] init];
                if ([fileManager fileExistsAtPath:path]) {
                    self.numLabel.text = [self getNewMessageNum];
                    if ([self.numLabel.text intValue]) {
                        self.msgNum.hidden = NO;
                    }else{
                        self.msgNum.hidden = YES;
                    }
//                    self.refreshNewMsgNum([self getNewMessageNum]);
                }else{
                    self.msgNum.hidden = YES;
                    self.numLabel.text = @"0";
//                    self.refreshNewMsgNum(@"0");
                }
                //返回
                //            self.refreshNewMsgNum(self.newDataArray);
//                [MyControl loadingSuccessWithContent:@"加载完成" afterDelay:0.2f];
            }
            
            //            NSLog(@"%@", self.newDataArray);
            //            [self.newDataArray removeAllObjects];
        }else{
//            StartLoading;
//            LoadingFailed;
        }
    }];
    [request release];
}
#pragma mark -
-(void)loadHistoryMessageAndSaveToLocal
{
    NSFileManager * manager = [[NSFileManager alloc] init];
    NSString * docDir = DOCDIR;
    NSString * path = [docDir stringByAppendingPathComponent:@"talkData.plist"];
    if ([manager fileExistsAtPath:path]) {
        //文件存在
        NSLog(@"文件存在");
        NSMutableDictionary * totalDict = [NSMutableDictionary dictionaryWithDictionary:[MyControl returnDictionaryWithDataPath:path]];
        NSArray * oldTalkIDArray = [totalDict allKeys];
        
        //        NSLog(@"/*============================*/");
        //        SingleTalkModel * model0 = [totalDict objectForKey:oldTalkIDArray[0]];
        //        NSArray * array0 = [model0.msgDict objectForKey:@"msg"];
        //        for (int i=0; i<array0.count; i++) {
        //            MessageModel * mod = array0[i];
        //            NSLog(@"%@", mod.msg);
        //        }
        //        NSLog(@"/*============================*/");
        //合并
        for (int i=0; i<self.talkIDArray.count; i++) {
            
            for (int j=0; j<oldTalkIDArray.count; j++) {
                NSString * key = self.talkIDArray[i];
                
                if ([key isEqualToString:oldTalkIDArray[j]]) {
                    //找到相同对话，合并
                    SingleTalkModel * model = [totalDict objectForKey:key];
                    NSMutableArray * oldMsgArray = [NSMutableArray arrayWithArray:[model.msgDict objectForKey:@"msg"]];
                    //
                    SingleTalkModel * nwModel = self.nwMsgDataArray[i];
                    NSArray * nwArray = [nwModel.msgDict objectForKey:@"msg"];
                    
                    
                    [oldMsgArray addObjectsFromArray:nwArray];
                    model.msgDict = [NSDictionary dictionaryWithObject:oldMsgArray forKey:@"msg"];
                    //2.合并未读消息数
                    model.unReadMsgNum = [NSString stringWithFormat:@"%d", [model.unReadMsgNum intValue] + [nwModel.unReadMsgNum intValue]];
                    //3.更新usr_tx
                    model.usr_tx = nwModel.usr_tx;
                    //4.更新usr_name
                    model.usr_name = nwModel.usr_name;
                    
                    //合并完毕
                    break;
                }else if(j == oldTalkIDArray.count-1){
                    //将新的添加
                    [totalDict setObject:self.nwMsgDataArray[i] forKey:key];
                }
            }
        }
        //新旧消息全部合并完毕，重新存储到本地
        NSData * data = [MyControl returnDataWithDictionary:totalDict];
        BOOL a = [data writeToFile:path atomically:YES];
        NSLog(@"---存储合并后数据结果:%d", a);
    }else{
        //本地没有文件
        //存到本地
        NSMutableDictionary * nwDataDict = [NSMutableDictionary dictionaryWithCapacity:0];
        for (int i=0; i<self.talkIDArray.count; i++) {
            [nwDataDict setObject:self.nwMsgDataArray[i] forKey:self.talkIDArray[i]];
        }
        NSString * docDir = DOCDIR;
        NSString * path = [docDir stringByAppendingPathComponent:@"talkData.plist"];
        //dict-->NSData
        NSData * data = [MyControl returnDataWithDictionary:nwDataDict];
        BOOL a = [data writeToFile:path atomically:YES];
        NSLog(@"---存储新数据结果:%d", a);
    }
}

#pragma mark - getNewMessageNum
-(NSString *)getNewMessageNum
{
    NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
    NSDictionary * dict = [MyControl returnDictionaryWithDataPath:path];
    int num = 0;
    NSArray * array = [dict allKeys];
    for (int i=0; i<array.count; i++) {
        SingleTalkModel * model = [dict objectForKey:array[i]];
        num += [model.unReadMsgNum intValue];
    }
    return [NSString stringWithFormat:@"%d", num];
}
#pragma mark -
-(void)apartNewMsgToArray
{
    for (int i=0; i<self.nwDataArray.count; i++) {
        //创建对象
        SingleTalkModel * talkModel = [[SingleTalkModel alloc] init];
        
        
        //分析数据
        //1.获得talk_id,添加到数组
        NSString * talkID = [[self.nwDataArray[i] allKeys] objectAtIndex:0];
        [self.talkIDArray addObject:talkID];
        
        
        NSDictionary * dict = [self.nwDataArray[i] objectForKey:talkID];
        //2.usr_id添加到userIDArray
        talkModel.usr_id = [dict objectForKey:@"usr_id"];
        //        [self.userIDArray addObject:[dict objectForKey:@"usr_id"]];
        
        
        //3.头像，添加到数组
        if ([[dict objectForKey:@"usr_tx"] isKindOfClass:[NSNull class]]) {
            talkModel.usr_tx = @"";
            //            [self.userTxArray addObject:@""];
        }else{
            talkModel.usr_tx = [dict objectForKey:@"usr_tx"];
            //            [self.userTxArray addObject:[dict objectForKey:@"usr_tx"]];
        }
        
        //4.姓名，添加到数组
        if ([[dict objectForKey:@"usr_name"] isKindOfClass:[NSNull class]] || [[dict objectForKey:@"usr_name"] length] == 0) {
            if ([[dict objectForKey:@"usr_id"] intValue] == 1) {
                talkModel.usr_name = @"事务官"; //狗
                talkModel.usr_tx = @"1";
                //                [self.userNameArray addObject:@"汪汪"];
            }else if([[dict objectForKey:@"usr_id"] intValue] == 2){
                talkModel.usr_name = @"联络官"; //猫
                talkModel.usr_tx = @"2";
                //                [self.userNameArray addObject:@"喵喵"];
            }else if([[dict objectForKey:@"usr_id"] intValue] == 3){
                talkModel.usr_name = @"顺风小鸽";
                talkModel.usr_tx = @"3";
                //                [self.userNameArray addObject:@"顺风小鸽"];
            }
        }else{
            talkModel.usr_name = [dict objectForKey:@"usr_name"];
            //            [self.userNameArray addObject:[dict objectForKey:@"usr_name"]];
        }
        
        //5.新消息数
        NSNumber * number = [dict objectForKey:@"new_msg"];
        talkModel.unReadMsgNum = [NSString stringWithFormat:@"%@", number];
        //        [self.newMsgNumArray addObject:[NSString stringWithFormat:@"%@", number]];
        //6.新消息的时间self.keysArray
        //7.新消息的内容self.valuesArray
        [self analysisData:[dict objectForKey:@"msg"] usrId:[dict objectForKey:@"usr_id"] talkModel:talkModel];
        //
        [self.nwMsgDataArray addObject:talkModel];
        //        [self.lastTalkTimeArray addObject:self.keysArray[self.keysArray.count-1]];
        //        [self.lastTalkContentArray addObject:self.valuesArray[self.valuesArray.count-1]];
        //存储newMsgArray
        //        NSMutableDictionary * dict1 = [NSMutableDictionary dictionaryWithCapacity:0];
        //
        //        [dict1 setObject:[NSArray arrayWithArray:self.keysArray] forKey:@"key"];
        //        [dict1 setObject:[NSArray arrayWithArray:self.valuesArray] forKey:@"value"];
        //        [self.newMsgArray addObject:dict1];
    }
}
-(void)analysisData:(NSDictionary *)dict usrId:(NSString *)usrID talkModel:(SingleTalkModel *)model
{
    
    NSMutableArray * tempNewMsgArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.keysArray removeAllObjects];
    [self.valuesArray removeAllObjects];
    //keysArray赋值
    for (NSString * key in [dict allKeys]) {
        [self.keysArray addObject:key];
    }
    
    //key值数组冒泡排序
    for (int i=0; i<self.keysArray.count; i++) {
        for (int j=0; j<self.keysArray.count-i-1; j++) {
            if ([self.keysArray[j] intValue] > [self.keysArray[j+1] intValue]) {
                NSString * str = [NSString stringWithFormat:@"%@", self.keysArray[j]];
                NSString * str1 = [NSString stringWithFormat:@"%@", self.keysArray[j+1]];
                self.keysArray[j] = str1;
                self.keysArray[j+1] = str;
            }
        }
    }
    //    NSLog(@"%@", self.keysArray);
    for (int i=0;i<self.keysArray.count;i++) {
        //        NSLog(@"key:%@--value:%@", self.keysArray[i], [dict objectForKey:self.keysArray[i]]);
        MessageModel * msgModel = [[MessageModel alloc] init];
        msgModel.time = self.keysArray[i];
        msgModel.usr_id = usrID;
        
        NSString * msg = [dict objectForKey:self.keysArray[i]];
        NSLog(@"%@", msg);
        if ([msg rangeOfString:@"["].location != NSNotFound && [msg rangeOfString:@"]"].location != NSNotFound) {
            int x = [msg rangeOfString:@"]"].location;
            
            msgModel.msg = [msg substringFromIndex:x+1];
            msgModel.img_id = [msg substringWithRange:NSMakeRange(1, x)];
        }else{
            msgModel.msg = msg;
            msgModel.img_id = @"0";
        }
        [tempNewMsgArray addObject:msgModel];
        [msgModel release];
        //        [self.valuesArray addObject:msg];
    }
    //
    model.msgDict = [NSDictionary dictionaryWithObject:tempNewMsgArray forKey:@"msg"];
}

#pragma mark -
#pragma mark -
-(void)menuBtnClick:(UIButton *)button
{
    /***********/
//    [ControllerManager setIsSuccess:1];
    
    button.selected = !button.selected;
    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
//    if ([ControllerManager getIsSuccess]) {
        if (button.selected) {
            //截屏
            UIImage * image = [MyControl imageWithView:[UIApplication sharedApplication].keyWindow];
            UIImage * image2 = [image applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
            [MyControl saveScreenshotsWithImage:image2];
            //        [UIView animateWithDuration:0.1 animations:^{
            //            [MyControl saveScreenshotsWithView:[UIApplication sharedApplication].keyWindow];
            //        }];
            
            [menu showMenuAnimated:YES];
            self.alphaBtn.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.alphaBtn.alpha = 0.5;
            }];
        }else{
            [menu hideMenuAnimated:YES];
            [UIView animateWithDuration:0.25 animations:^{
                self.alphaBtn.alpha = 0;
            } completion:^(BOOL finished) {
                self.alphaBtn.hidden = YES;
            }];
        }
//    }
//    else{
//        //提示注册
//    }
}
-(void)createScrollView
{
    self.sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.sv.delegate = self;
    self.sv.contentSize = CGSizeMake(320*3, self.view.frame.size.height);
    self.sv.contentOffset = CGPointMake(320, 0);
    self.sv.pagingEnabled = YES;
    self.sv.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.sv];
}
-(void)createViewControllers
{
//    RecommendViewController * rvc = [[RecommendViewController alloc] init];
    vc2 = [[RandomViewController alloc] init];
    [self addChildViewController:vc2];
    [vc2.view setFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
    vc2.reloadRandom = ^(){
        if([ControllerManager getIsSuccess]){
            [self getNewMessage];
        }
    };
    [self.sv addSubview:vc2.view];
    
//    WaterViewController *water = [[WaterViewController alloc] init];
//    [self addChildViewController:water];
//    [water.view setFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
//    [sv addSubview:water.view];

    
//    [self.view bringSubviewToFront:self.menuBgBtn];
//    [self.view bringSubviewToFront:self.menuBgView];
}

-(void)createSearchView
{
    //532/2  58/2  226 215 215
    searchBg = [MyControl createViewWithFrame:CGRectMake(0, 69-5, self.view.frame.size.width, 58/2)];
    searchBg.hidden = YES;
    [self.view addSubview:searchBg];
    
    UIView * brownView = [MyControl createViewWithFrame:CGRectMake(10, 5, 532/2, 58/2)];
    brownView.backgroundColor = BROWNCOLOR;
    brownView.alpha = 0.8;
    brownView.layer.cornerRadius = 13;
    brownView.layer.masksToBounds = YES;
    [searchBg addSubview:brownView];
    
    typeBtn = [MyControl createButtonWithFrame:CGRectMake(10+5, 4.5+5, 144/2, 20) ImageName:@"" Target:self Action:@selector(typeBtnClick:) Title:@"萌 星"];
    [typeBtn setTitleColor:WORDCOLOR forState:UIControlStateNormal];
    typeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [searchBg addSubview:typeBtn];

    UIImageView * triangle = [MyControl createImageViewWithFrame:CGRectMake(typeBtn.frame.origin.x+typeBtn.frame.size.width-7, typeBtn.frame.origin.y+typeBtn.frame.size.height-7, 7, 7) ImageName:@"main_search_triangle.png"];
    [searchBg addSubview:triangle];
    
    tf = [MyControl createTextFieldWithFrame:CGRectMake(typeBtn.frame.origin.x+typeBtn.frame.size.width+5, typeBtn.frame.origin.y, brownView.frame.size.width-15-typeBtn.frame.size.width, 20) placeholder:@"搜索" passWord:NO leftImageView:nil rightImageView:nil Font:13];
    tf.borderStyle = 0;
    tf.autocapitalizationType = 0;
    tf.autocorrectionType = 0;
    tf.delegate = self;
    tf.returnKeyType = UIReturnKeySearch;
//    tf.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [searchBg addSubview:tf];
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(brownView.frame.origin.x+brownView.frame.size.width+3, brownView.frame.origin.y, 40-6, 29)];
    view.layer.cornerRadius = 7;
    view.layer.masksToBounds = YES;
    view.backgroundColor = BROWNCOLOR;
    view.alpha = 0.8;
    [searchBg addSubview:view];
    
    cancel = [MyControl createButtonWithFrame:CGRectMake(brownView.frame.origin.x+brownView.frame.size.width, brownView.frame.origin.y, 40, 29) ImageName:@"" Target:self Action:@selector(cancelClick:) Title:@"取消"];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchBg addSubview:cancel];
    
}
-(void)cancelClick:(UIButton *)btn
{
    //隐藏searchBg
    if ([btn.titleLabel.text isEqualToString:@"搜索"]) {
        //请求搜索API
        [MobClick event:@"search"];
        [self textFieldShouldReturn:tf];
    }else{
        self.sv.scrollEnabled = YES;
        blurImageView.hidden = YES;
        if (segmentClickIndex == 0) {
            vc1.view.hidden = NO;
        }else if(segmentClickIndex == 1){
            vc2.view.hidden = NO;
        }else if (segmentClickIndex == 2){
            vc3.view.hidden = NO;
        }
        [tf resignFirstResponder];
        sc.hidden = NO;
        searchBg.hidden = YES;
    }
}
#pragma mark - daili
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    if(tf.text.length>0){
//        [cancel setTitle:@"取消" forState:UIControlStateNormal];
//    }
//    return YES;
//}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //string是最新输入的文字，textField的长度及字符要落后一个操作。
    if (![string isEqualToString:@""]) {
        [cancel setTitle:@"搜索" forState:UIControlStateNormal];
    }else if(textField.text.length == 1){
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
    }
    if ([cancel.titleLabel.text isEqualToString:@"搜索"]) {
        if ([string isEqualToString:@""]) {
            //退格
            NSLog(@"%d--%d", textField.text.length, self.tfString.length);
            if (self.tfString.length>=textField.text.length-1) {
                self.tfString = [self.tfString substringToIndex:textField.text.length-1];
            }
        }else{
            self.tfString = [NSString stringWithFormat:@"%@%@", textField.text, string];
        }
        
    }else{
        self.tfString = nil;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf resignFirstResponder];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    if (self.tfString != nil) {
        //开始搜索
        NSLog(@"搜索");
        if ([typeBtn.titleLabel.text isEqualToString:@"萌 星"]) {
            //搜索宠物
            LOADING;
            NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"dog&cat"]];
            NSString * url = [NSString stringWithFormat:@"%@&name=%@&sig=%@&SID=%@", SEARCHAPI, [tf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], sig,[ControllerManager getSID]];
//            NSLog(@"%@--%@--%@", tf.text, self.tfString, url);
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if(isFinish){
                    NSLog(@"%@", load.dataDict);
                    [self.searchArray removeAllObjects];
                    
                    NSArray *array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                    if (array.count == 0) {
                        ENDLOADING;
                        return;
                    }
                    for (NSDictionary *dict in array) {
                        SearchResultModel *model = [[SearchResultModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [self.searchArray addObject:model];
                        [model release];
                    }
                    self.lastAid = [self.searchArray[array.count-1] aid];
                    ENDLOADING;
                    [tv reloadData];
                    
                    self.sv.scrollEnabled = NO;
                    blurImageView.hidden = NO;
                    if (segmentClickIndex == 0) {
                        vc1.view.hidden = YES;
                    }else if(segmentClickIndex == 1){
                        vc2.view.hidden = YES;
                    }else if (segmentClickIndex == 2){
                        vc3.view.hidden = YES;
                    }

                }else{
                    LOADFAILED;
                }
            }];
            [request release];
        }else{
            //搜索经纪人
            LOADING;
            NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"dog&cat"]];
            NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", SEARCHUSERAPI, [tf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], sig,[ControllerManager getSID]];
            NSLog(@"%@--%@--%@", tf.text, self.tfString, url);
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if(isFinish){
//                    NSLog(@"%@", load.dataDict);
                    [self.searchUserArray removeAllObjects];
                    page = 0;
                    
                    NSArray *array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                    if (array.count == 0) {
                        ENDLOADING;
                        return;
                    }
                    for (NSDictionary *dict in array) {
                        UserInfoModel *model = [[UserInfoModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [self.searchUserArray addObject:model];
                        [model release];
                    }
                    ENDLOADING;
                    [tv reloadData];
                    page++;
                    
                    self.sv.scrollEnabled = NO;
                    blurImageView.hidden = NO;
                    if (segmentClickIndex == 0) {
                        vc1.view.hidden = YES;
                    }else if(segmentClickIndex == 1){
                        vc2.view.hidden = YES;
                    }else if (segmentClickIndex == 2){
                        vc3.view.hidden = YES;
                    }
                    
                }else{
                    LOADFAILED;
                }
            }];
            [request release];
        }
    }
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    self.tfString = nil;
    return YES;
}
-(void)typeBtnClick:(UIButton *)btn
{
    if (dropDown == nil) {
        
        CGFloat f = 80;
        dropDown = [[NIDropDown alloc] showDropDown:btn :&f :[NSArray arrayWithObjects:@"萌 星", @"经纪人", nil]];
        //        NSLog(@"%@", self.totalArray);
        [dropDown setCellTextColor:WORDCOLOR Font:[UIFont systemFontOfSize:13] BgColor:BROWNCOLOR lineColor:[UIColor brownColor]];
        dropDown.alpha = 0.9;
        CGRect rect = searchBg.frame;
        rect.size.height += 89;
        searchBg.frame = rect;
        
        dropDown.delegate = self;
    }else{
        [dropDown hideDropDown:btn];
        [self rel];
    }
}
#pragma mark - niDrop代理
-(void)niDropDownDelegateMethod:(NIDropDown *)sender
{
    [self rel];
}
-(void)didSelected:(NIDropDown *)sender Line:(int)Line Words:(NSString *)Words
{
    NSLog(@"%d--%@", Line, Words);
    if (Line == 0) {
        isSearchUser = NO;
        [tv addFooterWithCallback:^{
            [self loadMoreUser];
        }];
    }else{
        isSearchUser = YES;
        [tv addFooterWithCallback:^{
            [self loadMorePets];
        }];
    }
}
-(void)rel
{
    CGRect rect = searchBg.frame;
    rect.size.height -= 89;
    searchBg.frame = rect;
    [dropDown release];
    dropDown = nil;
}
-(void)createSegment
{
    NSArray * scArray = @[@"我的萌星", @"最新萌照", @"萌星推荐"];
    sc = [[UISegmentedControl alloc] initWithItems:scArray];
    sc.backgroundColor = [UIColor whiteColor];
    sc.alpha = 0.7;
//    sc.hidden = YES;
    sc.layer.cornerRadius = 4;
    sc.layer.masksToBounds = YES;
    sc.frame = CGRectMake(10, 69, 300, 30);
    [sc addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    //默认选中第二个，宇宙广场
    sc.selectedSegmentIndex = 1;
    sc.tintColor = BGCOLOR;
    [self.view addSubview:sc];
}
-(void)segmentClick:(UISegmentedControl *)seg
{
    if (sc.selectedSegmentIndex == 0 && ![ControllerManager getIsSuccess] && [ControllerManager getSID] != nil) {
        //*************************
        ShowAlertView;
        //*************************
        
//        ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
//        [self addChildViewController:vc];
//        [self.view addSubview:vc.view];
//        [vc createLoginAlertView];
        
        sc.selectedSegmentIndex = segmentClickIndex;
        return;
    }
    
    
    int a = sc.selectedSegmentIndex;
    if (segmentClickIndex != a) {
        [self getNewMessage];
    }
    segmentClickIndex = a;
    if (a == 0) {
//        self.menuBgView.hidden = YES;
        if (isCreated[0] == 0) {
            isCreated[0] = YES;
            vc1 = [[MyStarViewController alloc] init];
            [self addChildViewController:vc1];
            [vc1.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            [self.sv addSubview:vc1.view];
            [self.view bringSubviewToFront:sc];
            
//            [self.view bringSubviewToFront:self.menuBgBtn];
//            [self.view bringSubviewToFront:self.menuBgView];
            [self.view bringSubviewToFront:self.alphaBtn];
        }else{
            [vc1.tv headerBeginRefreshing];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.sv.contentOffset = CGPointMake(0, 0);
        }];
    }else if(a == 1){
//        self.menuBgView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.sv.contentOffset = CGPointMake(320, 0);
        }];
        [vc2 headerRefresh];
    }else{
//        self.menuBgView.hidden = NO;
        if (isCreated[2] == 0) {
            isCreated[2] = YES;
            vc3 = [[PetRecommendViewController alloc] init];
            [self addChildViewController:vc3];
            [vc3.view setFrame:CGRectMake(320*2, 0, 320, self.view.frame.size.height)];
            [self.sv addSubview:vc3.view];
            [self.view bringSubviewToFront:sc];
            
//            [self.view bringSubviewToFront:self.menuBgBtn];
//            [self.view bringSubviewToFront:self.menuBgView];
            [self.view bringSubviewToFront:self.alphaBtn];
        }else{
            [vc3.tv headerBeginRefreshing];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.sv.contentOffset = CGPointMake(320*2, 0);
        }];
    }
    sc.selectedSegmentIndex = segmentClickIndex;
}
#pragma mark - scrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == tv) {
        return;
    }
    
    
    int a = self.sv.contentOffset.x;
    if(a == 0){
        if (![ControllerManager getIsSuccess] && [ControllerManager getSID] != nil) {
            self.sv.contentOffset = CGPointMake(sc.selectedSegmentIndex*self.view.frame.size.width, 0);
            ShowAlertView;
            return;
        }
    }
    int b = sc.selectedSegmentIndex;
    if (b != a) {
        [self getNewMessage];
    }
    sc.selectedSegmentIndex = a/320;
    
    if (a == 0) {
//        self.menuBgView.hidden = YES;
        if (isCreated[0] == NO) {
            isCreated[0] = YES;
            vc1 = [[MyStarViewController alloc] init];
            [self addChildViewController:vc1];
            [vc1.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            [self.sv addSubview:vc1.view];
            [self.view bringSubviewToFront:sc];
            
//            [self.view bringSubviewToFront:self.menuBgBtn];
//            [self.view bringSubviewToFront:self.menuBgView];
            [self.view bringSubviewToFront:self.alphaBtn];
        }else{
            if (b != sc.selectedSegmentIndex) {
//                [vc1.tv headerBeginRefreshing];
            }
            
        }
    }else if(a == self.view.frame.size.width){
//        [vc2 headerRefresh];
    }else if(a == self.view.frame.size.width*2){
//        self.menuBgView.hidden = NO;
//        if (![ControllerManager getIsSuccess]) {
//            sv.contentOffset = CGPointMake(320, 0);
//            /***************************/
//            ShowAlertView;
//            /***************************/
//            return;
//        }
        if (isCreated[2] == NO) {
            isCreated[2] = YES;
            vc3 = [[PetRecommendViewController alloc] init];
            [self addChildViewController:vc3];
            [vc3.view setFrame:CGRectMake(320*2, 0, 320, self.view.frame.size.height)];
            [self.sv addSubview:vc3.view];
            [self.view bringSubviewToFront:sc];
            
//            [self.view bringSubviewToFront:self.menuBgBtn];
//            [self.view bringSubviewToFront:self.menuBgView];
            [self.view bringSubviewToFront:self.alphaBtn];
        }else{
            if (b != sc.selectedSegmentIndex) {
//                [vc3.tv headerBeginRefreshing];
            }
            
        }
    }else{
//        self.menuBgView.hidden = NO;
    }
}
//-(void)unShakeNum:(int)num index:(int)index
//{
//    [vc1 refreshShakeNum:num Index:index];
//}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.x == 0) {
//        
//        if (isCreated[0] == NO) {
//            isCreated[0] = YES;
//            vc1 = [[MyStarViewController alloc] init];
//            
////            super.unShakeNum = ^(int a, int index){
////                //index表示第几行
////                NSLog(@"%d--%d", a, index);
////                [vc1 refreshShakeNum:a Index:index];
////            };
////            vc1.actClick = ^(int a, int index){
////                [self changeActIndex:index];
////                if (a == 0) {
////                    [self btn1Click];
////                }else if (a == 1) {
////                    [self btn2Click];
////                }else if (a == 2) {
////                    [self btn3Click];
////                }else if (a == 3) {
////                    [self btn4Click];
////                }
////            };
////            vc1.actClickSend = ^(NSString * aid, NSString * name, NSString * tx){
////                self.pet_aid = aid;
////                self.pet_name = name;
////                self.pet_tx = tx;
////            };
//            [self addChildViewController:vc1];
//            [vc1.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//            [sv addSubview:vc1.view];
//            [self.view bringSubviewToFront:sc];
//            
//            [self.view bringSubviewToFront:self.menuBgBtn];
//            [self.view bringSubviewToFront:self.menuBgView];
//            [self.view bringSubviewToFront:self.alphaBtn];
//        }
//    }else if(scrollView.contentOffset.x == 320*2){
////        if (![ControllerManager getIsSuccess]) {
////            sv.contentOffset = CGPointMake(320, 0);
////            /***************************/
////            ShowAlertView;
////            /***************************/
////            return;
////        }
//        if (isCreated[2] == NO) {
//            isCreated[2] = YES;
////            FavoriteViewController * fvc = [[FavoriteViewController alloc] init];
//            vc3 = [[PetRecommendViewController alloc] init];
//            [self addChildViewController:vc3];
//            [vc3.view setFrame:CGRectMake(320*2, 0, 320, self.view.frame.size.height)];
//            [sv addSubview:vc3.view];
//            [self.view bringSubviewToFront:sc];
//            
//            [self.view bringSubviewToFront:self.menuBgBtn];
//            [self.view bringSubviewToFront:self.menuBgView];
//            [self.view bringSubviewToFront:self.alphaBtn];
//        }
//    }
//}

//===============================================//
-(void)cameraClick
{
//    NSLog(@"animalInfoDict:%@",animalInfoDict);
//    NSLog(@"master_id:%@",masterID);
    
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
            
        }
//        if ([self.masterID isEqualToString:[USER objectForKey:@"usr_id"]]) {
//            else{
//                
//            }
        [sheet showInView:self.view];
        
//        }else{
//            [ControllerManager HUDText:@"只有主人才可以(⊙o⊙)哦~~" showView:self.view yOffset:0];
//        }
        
    }else{
        //提示注册
        /***************************/
        ShowAlertView;
        /***************************/
    }
    
}
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
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
            [self lauchEditorWithImage:image];
//            [[self assetLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
//                if (asset){
//                    [self launchEditorWithAsset:asset];
//                }
//            } failureBlock:^(NSError *error) {
//                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable access to your device's photos." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//            }];
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
    
    __block MainViewController * blockSelf = self;
    
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
    //    [[self imagePreviewView] setImage:image];
    //    [[self imagePreviewView] setContentMode:UIViewContentModeScaleAspectFit];
    
    //跳转到UploadViewController
    //    UploadViewController * vc = [[UploadViewController alloc] init];
    //    vc.oriImage = image;
    //    [self presentViewController:vc animated:YES completion:nil];
    
    //    NSLog(@"上传图片");
    //    [self postData:image];
    
    //    UINavigationController * nc = [ControllerManager shareManagerMyPet];
    //    MyPetViewController * vc = nc.viewControllers[0];
    //    vc.myBlock();
    
    [self dismissViewControllerAnimated:YES completion:^{
        //        UploadViewController * vc = [[UploadViewController alloc] init];
        PublishViewController * vc = [[PublishViewController alloc] init];
        vc.oriImage = image;
        //        vc.af = editor;
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

//-(void)checkUpdateOutVer:(NSString *)outVer InsideVer:(NSString *)insideVer
//{
//    /*
//     本地保存version作为参考对象，如果login里的外层version与本地不同就是
//     强制更新，如果是里层的不同就不强制，安排取消按钮，取消后不做任何操作。
//     */
//    int type1 = 0;
//    int type2 = 0;
//    if (![outVer isEqualToString:[USER objectForKey:@"version"]]) {
//        //强制更新
//        type1 = 1;
//    }
//    if (![insideVer isEqualToString:[USER objectForKey:@"version"]]) {
//        type2 = 1;
//    }
//    if (type1 == 1 || type2 == 1) {
//        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"version=%@dog&cat", [USER objectForKey:@"version"]]];
//        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", UPDATEAPI, [USER objectForKey:@"version"], sig, [ControllerManager getSID]];
//        NSLog(@"%@", url);
//        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//            if (isFinish) {
////                self.ios_url = [[load.dataDict objectForKey:@"data"] objectForKey:@"ios_url"];
////                self.ios_url = @"http://www.baidu.com";
//                NSString * msg = [[load.dataDict objectForKey:@"data"] objectForKey:@"upgrade_content"];
//                
//                NSString * msg2 = [msg stringByReplacingOccurrencesOfString:@"&" withString:@"\n"];
//                if(type1 == 1){
//                    //强制
//                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:msg2 delegate:self cancelButtonTitle:nil otherButtonTitles:@"马上更新", nil];
//                    [alert show];
//                    [alert release];
//                }else{
//                    //非强制更新
//                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:[[load.dataDict objectForKey:@"data"] objectForKey:@"upgrade_content"] delegate:self cancelButtonTitle:@"稍后更新" otherButtonTitles:@"马上更新", nil];
//                    [alert show];
//                    [alert release];
//                }
//            }else{
//                StartLoading;
//                LoadingFailed;
//            }
//        }];
//        [request release];
//    }
//}
//#pragma mark - delegate
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSLog(@"%d", buttonIndex);
//    if (buttonIndex == 0) {
//        //稍后更新
//        
//    }else{
//        //马上更新
//        
//    }
//}
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
