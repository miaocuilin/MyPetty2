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
#define WORDCOLOR [UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1]
#define BROWNCOLOR [UIColor colorWithRed:226/255.0 green:215/255.0 blue:215/255.0 alpha:1]
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
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    if (!([[USER objectForKey:@"petInfoDict"] isKindOfClass:[NSDictionary class]] && [[[USER objectForKey:@"petInfoDict"] objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]])) {
        camara.hidden = YES;
    }else{
        camara.hidden = NO;
    }
    self.pet_aid = [USER objectForKey:@"aid"];
    self.pet_name = [USER objectForKey:@"a_name"];
    self.pet_tx = [USER objectForKey:@"a_tx"];
//    if (![self.currentTx isEqualToString:[[USER objectForKey:@"petInfoDict"] objectForKey:@"tx"]]) {
        if ([[USER objectForKey:@"petInfoDict"] isKindOfClass:[NSDictionary class]] && [USER objectForKey:@"petInfoDict"] != nil) {
            /**************************/
            NSDictionary * dict = [USER objectForKey:@"petInfoDict"];
            if (!([[dict objectForKey:@"tx"] isKindOfClass:[NSNull class]] || [[dict objectForKey:@"tx"] length]==0)) {
                NSString * docDir = DOCDIR;
                NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [dict objectForKey:@"tx"]]];
                NSLog(@"--%@--%@", txFilePath, [dict objectForKey:@"tx"]);
                UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
                if (image) {
                    [self.headButton setBackgroundImage:image forState:UIControlStateNormal];
                    //            headImageView.image = image;
                }else{
                    //下载头像
                    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, [dict objectForKey:@"tx"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                        if (isFinish) {
                            [self.headButton setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                            //                    headImageView.image = load.dataImage;
                            NSString * docDir = DOCDIR;
                            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [dict objectForKey:@"tx"]]];
                            [load.data writeToFile:txFilePath atomically:YES];
                        }else{
                            NSLog(@"头像下载失败");
                        }
                    }];
                    [request release];
                }
            }else{
                [self.headButton setBackgroundImage:[UIImage imageNamed:@"defaultPetHead.png"] forState:UIControlStateNormal];
            }
            /**************************/
        }else{
            [self.headButton setBackgroundImage:[UIImage imageNamed:@"defaultPetHead.png"] forState:UIControlStateNormal];
        }
//    }
}
-(void)viewDidAppear:(BOOL)animated
{
    
    self.menuBtn.selected = NO;
//    TipsView *tips = [[TipsView alloc] initWithFrame:self.view.frame tipsName:REGISTER];
//    [self.view addSubview:tips];
    if ([[USER objectForKey:@"petInfoDict"] isKindOfClass:[NSDictionary class]] && [[[USER objectForKey:@"petInfoDict"] objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
        self.label3.text = @"萌叫叫";
        [self.btn3 setBackgroundImage:[UIImage imageNamed:@"sound.png"] forState:UIControlStateNormal];
    }else{
        self.label3.text = @"萌印象";
        [self.btn3 setBackgroundImage:[UIImage imageNamed:@"touch.png"] forState:UIControlStateNormal];
    }
    
}
- (void)viewDidLoad
{
    
    self.pet_aid = [USER objectForKey:@"aid"];
    self.pet_name = [USER objectForKey:@"a_name"];
    self.pet_tx = [USER objectForKey:@"a_tx"];
    
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
    
    segmentClickIndex = 1;
    [self createScrollView];
    [self createFakeNavigation];
    [self createViewControllers];
    [self createSegment];
    [self createTableView];
    [self createSearchView];
    
    [self.view bringSubviewToFront:self.menuBgBtn];
    [self.view bringSubviewToFront:self.menuBgView];
    
    [self createAlphaBtn];
    
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
    
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, tv.frame.size.width, 35)];
    tv.tableHeaderView = view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d", self.searchArray.count);
    return self.searchArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    PetSearchCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PetSearchCell" owner:self options:nil] objectAtIndex:0];
    }
    SearchResultModel * model = self.searchArray[indexPath.row];
    [cell configUI:model];
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
    PetInfoViewController * vc = [[PetInfoViewController alloc] init];
    vc.aid = [self.searchArray[indexPath.row] aid];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
    
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
    [self.sv addSubview:vc2.view];
    
//    WaterViewController *water = [[WaterViewController alloc] init];
//    [self addChildViewController:water];
//    [water.view setFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
//    [sv addSubview:water.view];

    
    [self.view bringSubviewToFront:self.menuBgBtn];
    [self.view bringSubviewToFront:self.menuBgView];
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
    
    cancel = [MyControl createButtonWithFrame:CGRectMake(brownView.frame.origin.x+brownView.frame.size.width, brownView.frame.origin.y, 40, 29) ImageName:@"" Target:self Action:@selector(cancelClick:) Title:@"取消"];
    [cancel setTitleColor:WORDCOLOR forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchBg addSubview:cancel];
    
}
-(void)cancelClick:(UIButton *)btn
{
    //隐藏searchBg
    if ([btn.titleLabel.text isEqualToString:@"搜索"]) {
        //请求搜索API
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
            self.tfString = [self.tfString substringToIndex:textField.text.length-1];
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
//    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    if (self.tfString != nil) {
        //开始搜索
        NSLog(@"搜索");
        if ([typeBtn.titleLabel.text isEqualToString:@"萌 星"]) {
            //搜索宠物
            StartLoading;
            NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"dog&cat"]];
            NSString * url = [NSString stringWithFormat:@"%@&name=%@&sig=%@&SID=%@", SEARCHAPI, [tf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], sig,[ControllerManager getSID]];
//            NSLog(@"%@--%@--%@", tf.text, self.tfString, url);
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if(isFinish){
//                    NSLog(@"%@", load.dataDict);
                    [self.searchArray removeAllObjects];
                    
                    NSArray *array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                    for (NSDictionary *dict in array) {
                        SearchResultModel *model = [[SearchResultModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [self.searchArray addObject:model];
                        [model release];
                    }
                    LoadingSuccess;
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
                    
                }
            }];
            [request release];
        }else{
            //搜索经纪人
            
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
        dropDown = [[NIDropDown alloc] showDropDown:btn :&f :[NSArray arrayWithObjects:@"萌 星", nil]];
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
    if (sc.selectedSegmentIndex == 0 && ![ControllerManager getIsSuccess]) {
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
    segmentClickIndex = a;
    if (a == 0) {
        self.menuBgView.hidden = YES;
        if (isCreated[0] == 0) {
            isCreated[0] = YES;
            vc1 = [[MyStarViewController alloc] init];
            [self addChildViewController:vc1];
            [vc1.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            [self.sv addSubview:vc1.view];
            [self.view bringSubviewToFront:sc];
            
            [self.view bringSubviewToFront:self.menuBgBtn];
            [self.view bringSubviewToFront:self.menuBgView];
            [self.view bringSubviewToFront:self.alphaBtn];
        }else{
            [vc1.tv headerBeginRefreshing];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.sv.contentOffset = CGPointMake(0, 0);
        }];
    }else if(a == 1){
        self.menuBgView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.sv.contentOffset = CGPointMake(320, 0);
        }];
    }else{
        self.menuBgView.hidden = NO;
        if (isCreated[2] == 0) {
            isCreated[2] = YES;
            vc3 = [[PetRecommendViewController alloc] init];
            [self addChildViewController:vc3];
            [vc3.view setFrame:CGRectMake(320*2, 0, 320, self.view.frame.size.height)];
            [self.sv addSubview:vc3.view];
            [self.view bringSubviewToFront:sc];
            
            [self.view bringSubviewToFront:self.menuBgBtn];
            [self.view bringSubviewToFront:self.menuBgView];
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
    int b = sc.selectedSegmentIndex;
    sc.selectedSegmentIndex = a/320;
    
    if (a == 0) {
        self.menuBgView.hidden = YES;
        if (isCreated[0] == NO) {
            isCreated[0] = YES;
            vc1 = [[MyStarViewController alloc] init];
            [self addChildViewController:vc1];
            [vc1.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            [self.sv addSubview:vc1.view];
            [self.view bringSubviewToFront:sc];
            
            [self.view bringSubviewToFront:self.menuBgBtn];
            [self.view bringSubviewToFront:self.menuBgView];
            [self.view bringSubviewToFront:self.alphaBtn];
        }else{
            if (b != sc.selectedSegmentIndex) {
                [vc1.tv headerBeginRefreshing];
            }
            
        }
    }else if(a == 320*2){
        self.menuBgView.hidden = NO;
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
            
            [self.view bringSubviewToFront:self.menuBgBtn];
            [self.view bringSubviewToFront:self.menuBgView];
            [self.view bringSubviewToFront:self.alphaBtn];
        }else{
            if (b != sc.selectedSegmentIndex) {
                [vc3.tv headerBeginRefreshing];
            }
            
        }
    }else{
        self.menuBgView.hidden = NO;
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
