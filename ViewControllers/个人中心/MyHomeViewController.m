//
//  MyHomeViewController.m
//  MyPetty
//
//  Created by Aidi on 14-6-18.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MyHomeViewController.h"
#import "InfoModel.h"
#import "PhotoModel.h"
#import "MyPhotoCell.h"
#import "AttentionCell.h"
#import "DetailViewController.h"
#import "OtherHomeViewController.h"
#define DARKGRAY [UIColor darkGrayColor]
#import "UMSocial.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <AviarySDK/AviarySDK.h>

static NSString * const kAFAviaryAPIKey = @"b681eafd0b581b46";
static NSString * const kAFAviarySecret = @"389160adda815809";
@interface MyHomeViewController () <AFPhotoEditorControllerDelegate>

@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;
@end

@implementation MyHomeViewController

//-(void)dealloc
//{
//    
//    [super dealloc];
//}

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
    //改变微博的图片
    if ([UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina]) {
        [sina setImage:[UIImage imageNamed:@"weibo-1.png"] forState:UIControlStateNormal];
    }else{
        [sina setImage:[UIImage imageNamed:@"weibo.png"] forState:UIControlStateNormal];
    }
    
    attentionOrFans = 0;
    if ([[USER objectForKey:@"needRefresh"] intValue] == 1) {
        [self login];
        [self resetColor];
        numLabel1.textColor = BGCOLOR;
        photoLabel.textColor = BGCOLOR;
        [self loadUserData];
        [self loadPhotoData];
        [USER setObject:@"0" forKey:@"needRefresh"];
    }
    if ([[USER objectForKey:@"Menu"] intValue] == 1) {
        [self login];
        [self resetColor];
        numLabel1.textColor = BGCOLOR;
        photoLabel.textColor = BGCOLOR;
    }
    //1表示刚进入我的个人中心，这个字段是防止用户重复点入，个人中心-》详情页-》个人中心
    [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"MyHomeTimes"] intValue]+1] forKey:@"MyHomeTimes"];
    NSLog(@"进入主页，times：%@", [USER objectForKey:@"MyHomeTimes"]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

    
    // Do any additional setup after loading the view.
    self.userDataArray = [NSMutableArray arrayWithCapacity:0];
    self.photosDataArray = [NSMutableArray arrayWithCapacity:0];
    self.attentionDataArray = [NSMutableArray arrayWithCapacity:0];
    self.fansDataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self loadUserData];
    [self loadPhotoData];
}
#pragma mark -请求用户数据
-(void)loadUserData
{
    NET = YES;
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@", INFOAPI, [ControllerManager getSID]]);
    [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", INFOAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            [self.userDataArray removeAllObjects];
            
            NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            InfoModel * model = [[InfoModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.userDataArray addObject:model];
            [model release];
            NSLog(@"%@", [self.userDataArray[0] tx]);
            [self createHeader];
            NET = NO;
        }else{
            NSLog(@"用户数据加载失败。");
            NET = NO;
        }
    }];
}

-(void)loadPhotoData
{
    NET = YES;
    [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGESAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
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
            [tvPhotos headerEndRefreshing];
            [self loadAttentionData];
            self.view.userInteractionEnabled = YES;
        }else{
            [tvPhotos headerEndRefreshing];
            self.view.userInteractionEnabled = YES;
            NSLog(@"数据加载失败。");
            NET = NO;
        }
    }];
}
#pragma mark -下载关注列表
-(void)loadAttentionData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", FOLLOWINGAPI, [ControllerManager getSID]];
    NSLog(@"followingAPI:%@", url);
    
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            [self.attentionDataArray removeAllObjects];
            if ([[load.dataDict objectForKey:@"errorCode"] intValue]) {
                [self loadFansData];
                return;
            }
            NSDictionary * diction = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            final_id_attention = [[diction objectForKey:@"final_id"] intValue];
            NSArray * array = [diction objectForKey:@"result"];
            for (NSDictionary * dict in array) {
                NSDictionary * dic = [dict objectForKey:@"user"];
                InfoModel * model = [[InfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.attentionDataArray addObject:model];
                [model release];
            }
//            if (self.attentionDataArray.count>0) {
//                self.lastAttention_id = [self.attentionDataArray[self.attentionDataArray.count-1] usr_id];
//            }
            [self loadFansData];
//            self.view.userInteractionEnabled = YES;
        }else{
            self.view.userInteractionEnabled = YES;
            NSLog(@"下载关注列表失败");
            NET = NO;
        }
    }];
}
#pragma mark -下载粉丝列表
-(void)loadFansData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", FOLLOWERAPI, [ControllerManager getSID]];
    NSLog(@"followerAPI:%@", url);
    
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            [self.fansDataArray removeAllObjects];
            NSLog(@"%@", load.dataDict);
            if ([[load.dataDict objectForKey:@"errorCode"] intValue]) {
                self.view.userInteractionEnabled = YES;
                [self createTableView];
                //调整Attention和Fans
                [self backToAttentionOrFans];
                NET = NO;
                return;
            }

            NSDictionary * diction = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            final_id_fans = [[diction objectForKey:@"final_id"] intValue];
            NSArray * array = [diction objectForKey:@"result"];
            for (NSDictionary * dict in array) {
                NSDictionary * dic = [dict objectForKey:@"user"];
                InfoModel * model = [[InfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.fansDataArray addObject:model];
                isFansFriend[self.fansDataArray.count-1] = [[dict objectForKey:@"isFriend"] intValue];
                
                [model release];
            }
//            if (self.fansDataArray.count>0) {
//                self.lastFans_id = [self.fansDataArray[self.fansDataArray.count-1] usr_id];
//            }
            [self createTableView];
            numLabel1.text = [NSString stringWithFormat:@"%d", self.photosDataArray.count];
            numLabel2.text = [NSString stringWithFormat:@"%d", self.attentionDataArray.count];
            numLabel3.text = [NSString stringWithFormat:@"%d", self.fansDataArray.count];
            //调整Attention和Fans
            [self backToAttentionOrFans];
            NET = NO;
            self.view.userInteractionEnabled = YES;
        }else{
            self.view.userInteractionEnabled = YES;
            NSLog(@"下载粉丝列表失败");
            NET = NO;
        }
    }];
}

#pragma mark -创建头视图
-(void)createHeader
{
    UIImageView * bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 356/2) ImageName:@"20-1.png"];
    [self.view addSubview:bgImageView];
    
    self.buttonLeft = [MyControl createButtonWithFrame:CGRectMake(17, 25, 30, 30) ImageName:@"14-6.png" Target:self Action:@selector(leftButtonClick:) Title:nil];
    self.buttonLeft.showsTouchWhenHighlighted = YES;
    [bgImageView addSubview:self.buttonLeft];
    
    UIButton * buttonRight = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-17-30, 25, 30, 30) ImageName:@"14-5.png" Target:self Action:@selector(rightButtonClick) Title:nil];
    buttonRight.showsTouchWhenHighlighted = YES;
    [bgImageView addSubview:buttonRight];
    
    headImageView = [MyControl createImageViewWithFrame:CGRectMake(17, (356-72-28-128)/2, 64, 64) ImageName:@""];
    headImageView.layer.cornerRadius = 32;
    headImageView.layer.masksToBounds = YES;
    [bgImageView addSubview:headImageView];
    
    //头像的加载
    NSString * txFilePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [self.userDataArray[0] tx]]];
    NSLog(@"%@", txFilePath);
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txFilePath]];
    if (image) {
        headImageView.image = image;
    }else{
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", TXURL, [self.userDataArray[0] tx]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                //本地目录，用于存放favorite下载的原图
                NSString * docDir = DOCDIR;
                NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [self.userDataArray[0] tx]]];
                //将下载的图片存放到本地
                [load.data writeToFile:txFilePath atomically:YES];
                headImageView.image = load.dataImage;
            }else{
                
            }
        }];
    }

    UIButton * camaraButton = [MyControl createButtonWithFrame:CGRectMake(17+64-30+10, headImageView.frame.origin.y+64-30+5, 25, 25) ImageName:@"20-2.png" Target:self Action:@selector(camaraButtonClick) Title:nil];
    camaraButton.showsTouchWhenHighlighted = YES;
    [bgImageView addSubview:camaraButton];
    
    CGSize size = [[self.userDataArray[0] name] sizeWithFont:[UIFont boldSystemFontOfSize:17] forWidth:150 lineBreakMode:1];
    UILabel * nameLabel = [MyControl createLabelWithFrame:CGRectMake(headImageView.frame.origin.x+64+10, headImageView.frame.origin.y+5, 150, 20) Font:17 Text:[self.userDataArray[0] name]];
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    if (size.width<150) {
        nameLabel.frame = CGRectMake(headImageView.frame.origin.x+64+10, headImageView.frame.origin.y+5, size.width, 20);
    }else{
        nameLabel.adjustsFontSizeToFitWidth = YES;
    }
    nameLabel.textColor = [UIColor blackColor];
    [bgImageView addSubview:nameLabel];
    
    //性别
    UIImageView * sex = [MyControl createImageViewWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+5, nameLabel.frame.origin.y-3, 28*0.75, 34*0.75) ImageName:@""];
    if ([[self.userDataArray[0] gender] intValue] == 1) {
        //公
        sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    [bgImageView addSubview:sex];
    
    UILabel * cateNameLabel = [MyControl createLabelWithFrame:CGRectMake(headImageView.frame.origin.x+64+10, headImageView.frame.origin.y+5+20+15, 150, 20) Font:16 Text:[NSString stringWithFormat:@"苏格兰折耳猫 | %@岁", [self.userDataArray[0] age]]];
    cateNameLabel.font = [UIFont boldSystemFontOfSize:16];
    cateNameLabel.textColor = [UIColor grayColor];
    [bgImageView addSubview:cateNameLabel];
    
    int a = [[self.userDataArray[0] type] intValue];
    NSLog(@"%@--%d", [self.userDataArray[0] type], a);
    NSString * cateName = nil;

    if (a/100 == 1) {
        cateName = [[[USER objectForKey:@"CateNameList"]objectForKey:@"1"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else if(a/100 == 2){
        cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"2"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else if(a/100 == 3){
        cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"3"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else{
        cateName = @"未知物种";
    }
    if (cateName == nil) {
        //更新本地宠物名单列表
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", TYPEAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                [USER setObject:[load.dataDict objectForKey:@"data"] forKey:@"CateNameList"];
                NSString * path = [DOCDIR stringByAppendingPathComponent:@"CateNameList.plist"];
                NSMutableDictionary * data = [load.dataDict objectForKey:@"data"];
                //本地及内存存储
                [data writeToFile:path atomically:YES];
                [USER setObject:data forKey:@"CateNameList"];
                int a = [[self.userDataArray[0] type] intValue];
                NSString * cateName = nil;
                
                if (a/100 == 1) {
                    cateName = [[[USER objectForKey:@"CateNameList"]objectForKey:@"1"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else if(a/200 == 2){
                    cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"2"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else if(a/200 == 3){
                    cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"3"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else{
                    cateName = @"未知物种";
                }
                cateNameLabel.text = [NSString stringWithFormat:@"%@ | %@岁", cateName, [self.userDataArray[0] age]];
            }
        }];
        
    }else{
        cateNameLabel.text = [NSString stringWithFormat:@"%@ | %@岁", cateName, [self.userDataArray[0] age]];
    }
    
    
    //微信微博按钮
    sina = [MyControl createButtonWithFrame:CGRectMake(320-45-15, cateNameLabel.frame.origin.y-15, 30, 30) ImageName:@"" Target:self Action:@selector(sinaButtonClick:) Title:nil];
    if ([UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina]) {
        [sina setImage:[UIImage imageNamed:@"weibo-1.png"] forState:UIControlStateNormal];
    }else{
        [sina setImage:[UIImage imageNamed:@"weibo.png"] forState:UIControlStateNormal];
    }
    sina.showsTouchWhenHighlighted = YES;
    [bgImageView addSubview:sina];
    
//    UIButton * sns = [MyControl createButtonWithFrame:CGRectMake(320-30-15, cateNameLabel.frame.origin.y-5, 30, 30) ImageName:@"2-1.png" Target:self Action:@selector(snsButtonClick:) Title:nil];
//    sns.showsTouchWhenHighlighted = YES;
//    [bgImageView addSubview:sns];
    
    UIImageView * line = [MyControl createImageViewWithFrame:CGRectMake(0, headImageView.frame.origin.y+64+14, self.view.frame.size.width, 1) ImageName:@"20-灰色线.png"];
    [bgImageView addSubview:line];
    
    /*************华丽分割线*******************/
    
    //照片
    numLabel1 = [MyControl createLabelWithFrame:CGRectMake(10+5, line.frame.origin.y+5, 50, 30) Font:25 Text:@"0"];
    numLabel1.textColor = DARKGRAY;
    numLabel1.textAlignment = NSTextAlignmentRight;
    [bgImageView addSubview:numLabel1];
    photoLabel = [MyControl createLabelWithFrame:CGRectMake(60+5, line.frame.origin.y+12, 30, 20) Font:14 Text:@"照片"];
    photoLabel.textColor = DARKGRAY;
    [bgImageView addSubview:photoLabel];
    
    button1 = [MyControl createButtonWithFrame:CGRectMake(10+5, line.frame.origin.y+5, 80, 30) ImageName:@"" Target:self Action:@selector(numButtonClick:) Title:nil];
    button1.tag = 201;
    [bgImageView addSubview:button1];
    
    //关注
    numLabel2 = [MyControl createLabelWithFrame:CGRectMake(110, line.frame.origin.y+5, 50, 30) Font:25 Text:@"0"];

    numLabel2.textColor = DARKGRAY;
    numLabel2.textAlignment = NSTextAlignmentRight;
    [bgImageView addSubview:numLabel2];
    attentionLabel = [MyControl createLabelWithFrame:CGRectMake(160, line.frame.origin.y+12, 30, 20) Font:14 Text:@"关注"];
    attentionLabel.textColor = DARKGRAY;
    [bgImageView addSubview:attentionLabel];
    
    button2 = [MyControl createButtonWithFrame:CGRectMake(110, line.frame.origin.y+5, 80, 30) ImageName:@"" Target:self Action:@selector(numButtonClick:) Title:nil];
    button2.tag = 202;
    [bgImageView addSubview:button2];
    
    //粉丝
    numLabel3 = [MyControl createLabelWithFrame:CGRectMake(320-80-15-15, line.frame.origin.y+5, 50, 30) Font:25 Text:@"0"];
    numLabel3.textColor = DARKGRAY;
    numLabel3.textAlignment = NSTextAlignmentRight;
    [bgImageView addSubview:numLabel3];
    fansLabel = [MyControl createLabelWithFrame:CGRectMake(320-15-30-15, line.frame.origin.y+12, 30, 20) Font:14 Text:@"粉丝"];
    fansLabel.textColor = DARKGRAY;
    [bgImageView addSubview:fansLabel];
    
    button3 = [MyControl createButtonWithFrame:CGRectMake(320-80-15-15, line.frame.origin.y+5, 80, 30) ImageName:@"" Target:self Action:@selector(numButtonClick:) Title:nil];
    button3.tag = 203;
    [bgImageView addSubview:button3];
    
    UIImageView * line2 = [MyControl createImageViewWithFrame:CGRectMake(0, bgImageView.frame.size.height-1, self.view.frame.size.width, 1) ImageName:@"20-灰色线.png"];
    [bgImageView addSubview:line2];
    
    //Coming Soon!!!
    shopLabel = [MyControl createLabelWithFrame:CGRectMake(60, 100, 200, 40) Font:17 Text:@"Coming Soon!"];
    shopLabel.textAlignment = NSTextAlignmentCenter;
    shopLabel.backgroundColor = [UIColor darkGrayColor];
    shopLabel.layer.masksToBounds = YES;
    shopLabel.layer.cornerRadius = 5;
    shopLabel.alpha = 0.7;
    [bgImageView addSubview:shopLabel];
    shopLabel.hidden = YES;
    
}

#pragma mark -createTableView
-(void)createTableView
{
    //照片
    tvPhotos = [[UITableView alloc] initWithFrame:CGRectMake(0, 356/2, 320, self.view.frame.size.height-356/2) style:UITableViewStylePlain];
    tvPhotos.delegate = self;
    tvPhotos.dataSource = self;
    tvPhotos.separatorStyle = 0;
    [self.view addSubview:tvPhotos];
    [tvPhotos addHeaderWithTarget:self action:@selector(photoHeaderRefresh)];
    [tvPhotos addFooterWithTarget:self action:@selector(photoFooterRefresh)];
    [tvPhotos release];
    
    //关注
    tvAttention = [[UITableView alloc] initWithFrame:CGRectMake(0, 356/2, 320, self.view.frame.size.height-356/2) style:UITableViewStylePlain];
    tvAttention.delegate = self;
    tvAttention.dataSource = self;
    tvAttention.hidden = YES;
    tvAttention.separatorStyle = 0;
    [self.view addSubview:tvAttention];
    [tvAttention addHeaderWithTarget:self action:@selector(attentionHeaderRefresh)];
    [tvAttention addFooterWithTarget:self action:@selector(attentionFooterRefresh)];
    [tvAttention release];
    
    //粉丝
    tvFans = [[UITableView alloc] initWithFrame:CGRectMake(0, 356/2, 320, self.view.frame.size.height-356/2) style:UITableViewStylePlain];
    tvFans.delegate = self;
    tvFans.dataSource = self;
    tvFans.hidden = YES;
    tvFans.separatorStyle = 0;
    [self.view addSubview:tvFans];
    [tvFans addHeaderWithTarget:self action:@selector(fansHeaderRefresh)];
    [tvFans addFooterWithTarget:self action:@selector(fansFooterRefresh)];
    [tvFans release];
    
    [self createSinaView];
}
#pragma mark - 照片头刷新
-(void)photoHeaderRefresh
{
    [self loadPhotoData];
    
    self.view.userInteractionEnabled = NO;
}
-(void)photoFooterRefresh
{
    if (self.photosDataArray.count == 0) {
        [tvPhotos footerEndRefreshing];
        return;
    }
    [self loadMorePhotos];
}
#pragma mark - 关注头刷新
-(void)attentionHeaderRefresh
{
    [self loadAttentionData];
    self.view.userInteractionEnabled = NO;
}
-(void)attentionFooterRefresh
{
    if (self.attentionDataArray.count == 0) {
        [tvAttention footerEndRefreshing];
        return;
    }
    [self loadMoreAttention];
}
#pragma mark - 粉丝头刷新
-(void)fansHeaderRefresh
{
    [self loadFansData];
    self.view.userInteractionEnabled = NO;
}
-(void)fansFooterRefresh
{
    if (self.fansDataArray.count == 0) {
        [tvFans footerEndRefreshing];
        return;
    }
    [self loadMoreFans];
}

-(void)loadMorePhotos
{
    self.view.userInteractionEnabled = NO;
    NSString * str = [NSString stringWithFormat:@"img_id=%@dog&cat", [self.photosDataArray[self.photosDataArray.count-1] img_id]];
    NSString * sig = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", IMAGESAPI2, [self.photosDataArray[self.photosDataArray.count-1] img_id], sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.photosDataArray addObject:model];
                [model release];
            }
            
            [tvPhotos reloadData];
            [tvPhotos footerEndRefreshing];
            self.view.userInteractionEnabled = YES;
        }else{
            
            [tvPhotos footerEndRefreshing];
            self.view.userInteractionEnabled = YES;
        }
    }];
}
-(void)loadMoreAttention
{
    self.view.userInteractionEnabled = NO;
    NSString * str = [NSString stringWithFormat:@"usr_id=%ddog&cat", final_id_attention];
    NSString * sig = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", FOLLOWINGAPI2, final_id_attention, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSDictionary * diction = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            final_id_attention = [[diction objectForKey:@"final_id"] intValue];
            NSArray * array = [diction objectForKey:@"result"];
            for (NSDictionary * dict in array) {
                NSDictionary * dic = [dict objectForKey:@"user"];
                InfoModel * model = [[InfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.attentionDataArray addObject:model];
                [model release];
            }
//            self.lastAttention_id = [self.attentionDataArray[self.attentionDataArray.count-1] usr_id];
            
            [tvAttention reloadData];
            [tvAttention footerEndRefreshing];
            self.view.userInteractionEnabled = YES;
        }else{
            
            [tvAttention footerEndRefreshing];
            self.view.userInteractionEnabled = YES;
        }
    }];
}
-(void)loadMoreFans
{
    self.view.userInteractionEnabled = NO;
    NSString * str = [NSString stringWithFormat:@"usr_id=%ddog&cat", final_id_fans];
    NSString * sig = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", FOLLOWERAPI2, final_id_fans, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSDictionary * diction = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            final_id_fans = [[diction objectForKey:@"final_id"] intValue];
            NSArray * array = [diction objectForKey:@"result"];
            for (NSDictionary * dict in array) {
                NSDictionary * dic = [dict objectForKey:@"user"];
                InfoModel * model = [[InfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.fansDataArray addObject:model];
                isFansFriend[self.fansDataArray.count-1] = [[dict objectForKey:@"isFriend"] intValue];
                [model release];
            }
//            self.lastFans_id = [self.fansDataArray[self.fansDataArray.count-1] usr_id];
            
            [tvFans reloadData];
            [tvFans footerEndRefreshing];
            self.view.userInteractionEnabled = YES;
        }else{
            
            [tvFans footerEndRefreshing];
            self.view.userInteractionEnabled = YES;
        }
    }];
}

#pragma mark -tableViewDelegate方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tvPhotos) {
        return self.photosDataArray.count;
    }else if(tableView == tvAttention){
        return self.attentionDataArray.count;
    }else{
        return self.fansDataArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tvPhotos){
        static NSString * cellID = @"ID";
        MyPhotoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[[MyPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        }
        cell.selectionStyle = NO;
        PhotoModel * model = self.photosDataArray[indexPath.row];
        [cell configUI:model];
        
        NSLog(@"照片张数%d", self.photosDataArray.count);
        
        //本地目录，用于存放下载的原图
        NSString * docDir = DOCDIR;
        if (!docDir) {
            NSLog(@"Documents 目录未找到");
        }else{
            NSString * filePath2 = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_small.png", model.url]];
            UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath2]];
            if (image) {
                cell.bigImageView.image = image;
                cell.bigImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                cell.bigImageView.center = CGPointMake(320/2, 100);
            }else{
                [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
                        //本地目录，用于存放favorite下载的原图
                        NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                        //                    NSLog(@"docDir:%@", docDir);
                        if (!docDir) {
                            NSLog(@"Documents 目录未找到");
                        }else{
                            NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
                            NSString * filePath2 = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_small.png", model.url]];
                            //将下载的图片存放到本地
                            [load.data writeToFile:filePath atomically:YES];
                            
                            float width = load.dataImage.size.width;
                            float height = load.dataImage.size.height;
                            if (width>320) {
                                float w = 320/width;
                                width *= w;
                                height *= w;
                            }
                            UIImage * image = [load.dataImage imageByScalingToSize:CGSizeMake(width, height)];
                            
                            if (image.size.height>200) {
                                image = [self imageFromImage:image inRect:CGRectMake(0, height/2-100, width, 200)];
                                height = 200;
                            }
                            cell.bigImageView.image = image;
                            
                            NSData * smallImageData = UIImagePNGRepresentation(image);
                            [smallImageData writeToFile:filePath2 atomically:YES];
                            cell.bigImageView.frame = CGRectMake(0, 0, width, height);
                            cell.bigImageView.center = CGPointMake(320/2, 100);
                        }
                    }else{
                        //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        //            [alert show];
                        //            [alert release];
                    }
                }];
            }
        }
        
        return cell;
    }else if(tableView == tvAttention){
        static NSString * cellID3 = @"ID3";
        AttentionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
        if(!cell){
            cell = [[[AttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3] autorelease];
        }
        InfoModel * model = self.attentionDataArray[indexPath.row];
        [cell configUI:model];
        UIButton * attentionButton = [MyControl createButtonWithFrame:CGRectMake(320-15-20-5, 23, 22, 22) ImageName:@"14-11.png" Target:self Action:@selector(attentionButtonClick:) Title:nil];
        attentionButton.tag = 1000+indexPath.row;
        attentionButton.showsTouchWhenHighlighted = YES;
        //    [attentionButton setBackgroundImage:[UIImage imageNamed:@"14-11.png"] forState:UIControlStateSelected];
        [cell addSubview:attentionButton];
        cell.selectionStyle = 0;
        return cell;
    }else{
        //粉丝tableView
        static NSString * cellID4 = @"ID4";
        AttentionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID4];
        if(!cell){
            cell = [[[AttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID4] autorelease];
            UIButton * fansAttentionButton = [MyControl createButtonWithFrame:CGRectMake(320-15-20-5, 23, 22, 22) ImageName:@"14-10.png" Target:self Action:@selector(attentionButtonClick2:) Title:nil];
            [fansAttentionButton setBackgroundImage:[UIImage imageNamed:@"14-11.png"] forState:UIControlStateSelected];
            fansAttentionButton.tag = 2000+indexPath.row;
            fansAttentionButton.showsTouchWhenHighlighted = YES;
            [cell addSubview:fansAttentionButton];
            
            if (isFansFriend[indexPath.row]) {
                fansAttentionButton.selected = YES;
            }else{
                fansAttentionButton.selected = NO;
            }
        }
        InfoModel * model = self.fansDataArray[indexPath.row];
        [cell configUI:model];
        
        UIButton * fansAttentionButton = (UIButton *)[self.view viewWithTag:2000+indexPath.row];
        if (isFansFriend[indexPath.row]) {
            fansAttentionButton.selected = YES;
        }else{
            fansAttentionButton.selected = NO;
        }
        
        cell.selectionStyle = 0;
        return cell;
    }
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tvPhotos) {
        return 230;
    }else{
        return 65;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tvPhotos){
        [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"MyHomeTimes"] intValue]+1] forKey:@"MyHomeTimes"];
        NSLog(@"由个人主页进入详情页，times:%@", [USER objectForKey:@"MyHomeTimes"]);
        PhotoModel * model = self.photosDataArray[indexPath.row];
        //跳转到详情页，并传值
        DetailViewController * vc = [[DetailViewController alloc] init];
        vc.img_id = model.img_id;
        vc.usr_id = model.usr_id;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
//    }else if(tableView == tvAttention){
//        OtherHomeViewController * other = [[OtherHomeViewController alloc] init];
//        other.usr_id = [self.attentionDataArray[indexPath.row] usr_id];
//        NSLog(@"other.usr_id:%@", other.usr_id);
//        [self presentViewController:other animated:YES completion:nil];
//        [other release];
    }else{
        //粉丝列表
        OtherHomeViewController * other = [[OtherHomeViewController alloc] init];
        if (tableView == tvAttention) {
            other.usr_id = [self.attentionDataArray[indexPath.row] usr_id];
        }else{
            other.usr_id = [self.fansDataArray[indexPath.row] usr_id];
        }
        NSLog(@"other.usr_id:%@", other.usr_id);
        [self presentViewController:other animated:YES completion:nil];
        [other release];
    }
}

#pragma mark -buttonClick事件
-(void)leftButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
    if (button.selected) {
        //返回后数值-1
        [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"MyHomeTimes"] intValue]-1] forKey:@"MyHomeTimes"];
        NSLog(@"离开个人主页，times:%@", [USER objectForKey:@"MyHomeTimes"]);
        //    self.modalTransitionStyle = 2;
        //    [self dismissViewControllerAnimated:YES completion:nil];
        
        [menu showMenuAnimated:YES];
    }else{
        [menu hideMenuAnimated:YES];
    }
    
    
}
-(void)rightButtonClick
{
    shopLabel.hidden = NO;
    [self performSelector:@selector(labelHidden) withObject:Nil afterDelay:2];
}
-(void)labelHidden
{
    shopLabel.hidden = YES;
}
#pragma mark -相机拍照，图片处理
-(void)camaraButtonClick
{
    //拍照或选图片
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
    
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
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
        [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"MyHomeTimes"] intValue]-1] forKey:@"MyHomeTimes"];
        NSLog(@"MyHomeTimes:%@", [USER objectForKey:@"MyHomeTimes"]);
        [imagePickerController release];
    }
}

#pragma mark - UIImagePicker Delegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.tempImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSURL * assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    void(^completion)(void)  = ^(void){
        if (isCamara) {
            [self lauchEditorWithImage:self.tempImage];
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
#pragma mark -alertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag /1000 == 1) {
        //关注
        NSString * usr_id = [self.attentionDataArray[alertView.tag%1000] usr_id];
        NSString * code = [NSString stringWithFormat:@"usr_id=%@dog&cat", usr_id];
        NSString * sig = [MyMD5 md5:code];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", UNFOLLOWAPI, usr_id, sig, [ControllerManager getSID]];
        if (buttonIndex) {
            NSLog(@"url:%@", url);
            
            [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    //数据下载成功
                    if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                        [self.attentionDataArray removeObjectAtIndex:alertView.tag%1000];
                        numLabel2.text = [NSString stringWithFormat:@"%d", [numLabel2.text intValue]-1];
//                        [USER setObject:@"1" forKey:@"needRefresh"];
                        [self login];
//                        oriIndex = 2;
                        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消关注成功 ^_^" ];
//                        [USER setObject:@"1" forKey:@"favoriteNeedRefresh"];
                        [USER setObject:@"1" forKey:@"favoriteRefresh"];
                    }else{
                        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消关注失败 = =."];
                    }
                }else{
                    //数据下载失败
                    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消关注请求失败 = =."];
                }
            }];
        }else{
            //未关注
        }
    }else if(alertView.tag == 97){
        //设置头像
        if(buttonIndex){
            headImageView.image = self.tempImage;
            [self postImage];
//            [tv reloadData];
            [self dismissViewControllerAnimated:YES completion:nil];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
    }else{
        //粉丝
        NSString * code = [NSString stringWithFormat:@"usr_id=%@dog&cat", self.usr_id];
        NSString * sig = [MyMD5 md5:code];
        NSString * url = nil;
        if (alertView.tag == 200) {
            url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", FOLLOWAPI, self.usr_id, sig, [ControllerManager getSID]];
        }else if(alertView.tag == 201){
            url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", UNFOLLOWAPI, self.usr_id, sig, [ControllerManager getSID]];
        }
        if (buttonIndex) {
            NSLog(@"url:%@", url);
            
            [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    //数据下载成功
                    if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                        UIButton * button = (UIButton *)[self.view viewWithTag:fansButtonIndex];
                        button.selected = !button.selected;
                        [self login];
                        
//                        oriIndex = 3;
                        if (alertView.tag == 200) {
                            
                            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"关注成功 ^_^"];
                            //                            isFansFriend[fansButtonIndex-2000] = YES;
//                            [USER setObject:@"1" forKey:@"favoriteNeedRefresh"];
                        }else{
                            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消关注成功 ^_^" ];
                            //                            isFansFriend[fansButtonIndex-2000] = NO;
//                            [USER setObject:@"1" forKey:@"favoriteNeedRefresh"];
                        }
                        [USER setObject:@"1" forKey:@"favoriteRefresh"];
                        
                    }else{
                        if (alertView.tag == 200) {
                            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"关注失败 = =."];
                        }else{
                            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消关注失败 = =."];
                        }
                    }
                }else{
                    //数据下载失败
                    if (alertView.tag == 200) {
                        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"关注请求失败 = =."];
                    }else{
                        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消关注请求失败 = =."];
                    }
                }
            }];
        }else{
            //未关注
        }
    }
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark
#pragma mark -ASI
-(void)postImage
{
    //网络上传
    NSString * url = [NSString stringWithFormat:@"%@%@", TXAPI, [ControllerManager getSID]];
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 20;
    
    //    NSData
    
    NSData * data = UIImageJPEGRepresentation(self.tempImage, 0.1);
    //    NSLog(@"data:%@", data);
    //    [_request setPostValue:data forKey:@"image"];
    [_request setData:data withFileName:@"headImage.png" andContentType:@"image/jpg" forKey:@"tx"];
    
    _request.delegate = self;
    [_request startAsynchronous];
    
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    //上传成功，home页刷新值设为1
    [USER setObject:@"1" forKey:@"needRefresh"];
    
    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"头像上传成功"];
    
    //头像存放在本地
    NSData * data = UIImageJPEGRepresentation(self.tempImage, 0.1);
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSLog(@"%@",docDir);
    NSLog(@"saving png");
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir, [self.userDataArray[0] tx]];
    
    BOOL a = [data writeToFile:pngFilePath atomically:YES];
    NSLog(@"头像存放结果：%d", a);
    //更新tableView数据
    
    
    NSLog(@"headImage upload success");
    NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
    [self getUserData];
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"headImage upload failed");
}

#pragma mark -获取用户数据
-(void)getUserData
{
    NSString * url = [NSString stringWithFormat:@"http://54.199.161.210/dc/index.php?r=user/infoApi&&sig=beac851bfcd1b0d3dc98b327aa7fbad2&SID=%@", [ControllerManager getSID]];
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"errorCode"] intValue] == 2) {
                //SID过期,需要重新登录获取SID
                [self login];
                [self getUserData];
                return;
            }else{
                //SID未过期，直接获取用户数据
                NSLog(@"用户数据：%@", load.dataDict);
                NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                [USER setObject:[dict objectForKey:@"age"] forKey:@"age"];
                [USER setObject:[dict objectForKey:@"code"] forKey:@"code"];
                [USER setObject:[dict objectForKey:@"gender"] forKey:@"gender"];
                [USER setObject:[dict objectForKey:@"name"] forKey:@"name"];
                [USER setObject:[dict objectForKey:@"type"] forKey:@"type"];
                [USER setObject:[dict objectForKey:@"usr_id"] forKey:@"usr_id"];
                //                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}
#pragma mark -登录
-(void)login
{
    [[httpDownloadBlock alloc] initWithUrlStr:LOGINAPI Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            [ControllerManager setIsSuccess:[[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]];
            [ControllerManager setSID:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"]];
            NSLog(@"isSuccess:%d,SID:%@", [ControllerManager getIsSuccess], [ControllerManager getSID]);
            [self loadPhotoData];
            if ([ControllerManager getIsSuccess]) {
                [self getUserData];
//                if ([[USER objectForKey:@"needRefresh"] intValue] == 1) {
//                    [self loadPhotoData];
//                    [self resetColor];
//                    numLabel1.textColor = BGCOLOR;
//                    photoLabel.textColor = BGCOLOR;
//                    [USER setObject:@"0" forKey:@"needRefresh"];
//                }
            }
        }
    }];
}

#pragma mark - 新浪微博点击事件
-(void)sinaButtonClick:(UIButton *)button
{
    NSLog(@"微博");
    BOOL isOauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
    if (isOauth) {
        NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
        UMSocialAccountEntity *sinaAccount = [snsAccountDic valueForKey:UMShareToSina];
        NSLog(@"sina nickName is %@, iconURL is %@",sinaAccount.userName,sinaAccount.iconURL);
        sinaName.text = sinaAccount.userName;
        //头像存放在本地
        NSArray * array = [sinaAccount.iconURL componentsSeparatedByString:@"/"];
        NSString * sinaTX = array[array.count-1];
        NSString * txFilePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", sinaTX]];
        NSLog(@"%@", txFilePath);
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
//        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txFilePath]];
        if (image) {
            headImage.image = image;
        }else{
            [[httpDownloadBlock alloc] initWithUrlStr:sinaAccount.iconURL Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    headImage.image = load.dataImage;
                    NSString *docDir = DOCDIR;
                    NSLog(@"saving png");
                    NSString *pngFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", sinaTX]];
                    
//                    BOOL a = [load.data writeToFile:pngFilePath atomically:YES];
                    NSError * error = nil;
                    BOOL a = [load.data writeToFile:pngFilePath options:NSDataWritingAtomic error:&error];
                    NSLog(@"头像存放结果：%d", a);
                }else{
                    NSLog(@"微博头像加载失败");
                }
            }];
        }
        [UIView animateWithDuration:0.3 animations:^{
            amView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        }];
    }else{
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
            [self sinaButtonClick:button];
        });
    }
    
}
-(void)createSinaView
{
    amView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, 320, self.view.frame.size.height)];
    [self.view addSubview:amView];
    
    UIButton * bgButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(bgButtonClick) Title:nil];
    //    bgButton.backgroundColor = [UIColor blackColor];
    //    bgButton.alpha = 0.1;
    [amView addSubview:bgButton];
    
    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(35/2, 120, 570/2, 157/2)];
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [amView addSubview:bgView];
    
    headImage = [MyControl createImageViewWithFrame:CGRectMake(35, 120+20, 40, 40) ImageName:@"13-1.png"];
    [amView addSubview:headImage];
    
    sinaName = [MyControl createLabelWithFrame:CGRectMake(90, 150, 150, 20) Font:17 Text:@"心理治愈系"];
    sinaName.textColor = [UIColor darkGrayColor];
    [amView addSubview:sinaName];
    
    UIButton * addButton = [MyControl createButtonWithFrame:CGRectMake(320-35-30, 145, 30, 30) ImageName:@"36-1.png" Target:self Action:@selector(addButtonClick:) Title:nil];
    [addButton setImage:[UIImage imageNamed:@"36-2.png"] forState:UIControlStateSelected];
    [amView addSubview:addButton];
}
-(void)bgButtonClick
{
    
    [UIView animateWithDuration:0.3 animations:^{
        amView.frame = CGRectMake(self.view.frame.size.width, 0, 320, self.view.frame.size.height);
    }];
}
-(void)addButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
}

//-(void)snsButtonClick:(UIButton *)button
//{
//    NSLog(@"微信");
//}
#pragma mark - 根据需要判断回到粉丝还是关注
-(void)backToAttentionOrFans
{
    [self resetColor];
    [self hideAllTv];
    if (attentionOrFans == 0) {
        NSLog(@"照片");
        tvPhotos.hidden = NO;
        numLabel1.textColor = BGCOLOR;
        photoLabel.textColor = BGCOLOR;
    }else if(attentionOrFans == 1){
        NSLog(@"关注");
        tvAttention.hidden = NO;
        numLabel2.textColor = BGCOLOR;
        attentionLabel.textColor = BGCOLOR;
    }else if(attentionOrFans == 2){
        NSLog(@"粉丝");
        tvFans.hidden = NO;
        numLabel3.textColor = BGCOLOR;
        fansLabel.textColor = BGCOLOR;
    }
}

#pragma mark - 照片，关注，粉丝按钮点击事件
-(void)numButtonClick:(UIButton *)button
{
    [self resetColor];
    [self hideAllTv];
    if (button.tag == 201) {
        attentionOrFans = 0;
        NSLog(@"照片");
        tvPhotos.hidden = NO;
        numLabel1.textColor = BGCOLOR;
        photoLabel.textColor = BGCOLOR;
    }else if(button.tag == 202){
        attentionOrFans = 1;
        NSLog(@"关注");
        tvAttention.hidden = NO;
        numLabel2.textColor = BGCOLOR;
        attentionLabel.textColor = BGCOLOR;
    }else if(button.tag == 203){
        attentionOrFans = 2;
        NSLog(@"粉丝");
        tvFans.hidden = NO;
        numLabel3.textColor = BGCOLOR;
        fansLabel.textColor = BGCOLOR;
    }
}
#pragma mark -取消关注button点击事件
-(void)attentionButtonClick:(UIButton *)button
{
    attentionOrFans = 1;
    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"提示" Message:@"您确定要取消关注Ta么？" delegate:self cancelTitle:@"不忍心" otherTitles:@"残忍取消"];
    alert.tag = button.tag;
}

-(void)attentionButtonClick2:(UIButton *)button
{
    attentionOrFans = 2;
    fansButtonIndex = button.tag;
    self.usr_id = [self.fansDataArray[button.tag-2000] usr_id];
    if (!button.selected) {
        //请求关注API
        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"提示" Message:@"您确定要关注Ta么？" delegate:self cancelTitle:@"我才不要" otherTitles:@"是滴"];
        alert.tag = 200;
    }else{
        //请求解除关注API
        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"提示" Message:@"您确定要取消关注Ta么？" delegate:self cancelTitle:@"不忍心" otherTitles:@"残忍取消"];
        alert.tag = 201;
    }
}


#pragma mark -颜色还原
-(void)resetColor
{
    numLabel1.textColor = DARKGRAY;
    photoLabel.textColor = DARKGRAY;
    numLabel2.textColor = DARKGRAY;
    attentionLabel.textColor = DARKGRAY;
    numLabel3.textColor = DARKGRAY;
    fansLabel.textColor = DARKGRAY;
}

#pragma mark -取图片的一部分
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}
#pragma mark -hideAllTv
-(void)hideAllTv
{
    tvPhotos.hidden = YES;
    tvAttention.hidden = YES;
    tvFans.hidden = YES;
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
    
    __block MyHomeViewController * blockSelf = self;
    
    // Call render on the context. The render will asynchronously apply all changes made in the session (and therefore editor)
    // to the context's image. It will not complete until some point after the session closes (i.e. the editor hits done or
    // cancel in the editor). When rendering does complete, the completion block will be called with the result image if changes
    // were made to it, or `nil` if no changes were made. In this case, we write the image to the user's photo album, and release
    // our reference to the session.
    [context render:^(UIImage *result) {
        if (result) {
            UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
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
    self.tempImage = image;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"您确定要将此图片设置为头像么?" message:Nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 97;
    [alert show];
    [alert release];
}

// This is called when the user taps "Cancel" in the photo editor.
- (void) photoEditorCanceled:(AFPhotoEditorController *)editor
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
@end
