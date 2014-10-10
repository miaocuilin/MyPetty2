//
//  ActivityDetailViewController.m
//  MyPetty
//
//  Created by Aidi on 14-6-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "RewardViewController.h"
#import "TopicDetailModel.h"
#import "InfoModel.h"
#import "LikersLIstViewController.h"
#import "PublishViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <AviarySDK/AviarySDK.h>
#import "PSCollectionView.h"
#import "PSCollectionViewCell.h"
#import "PhotoModel.h"
#import "PicDetailViewController.h"
static NSString * const kAFAviaryAPIKey = @"b681eafd0b581b46";
static NSString * const kAFAviarySecret = @"389160adda815809";

@interface ActivityDetailViewController () <AFPhotoEditorControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,PSCollectionViewDelegate,PSCollectionViewDataSource,UIScrollViewDelegate>
{
    UIView *segmentView;
    UIView *segmentView2;
}

@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad
{
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
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.userDataArray = [NSMutableArray arrayWithCapacity:0];
    self.randomDataArray = [NSMutableArray arrayWithCapacity:0];
    self.newDataArray = [NSMutableArray arrayWithCapacity:0];
    self.hotDataArray = [NSMutableArray arrayWithCapacity:0];
    self.rankDataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createBg];
    [self makeNavgation];
    
    [self loadData];
//    [self loadRandomData];
//    [self makeUI];
//    [self makeNavgation];
//    [self loadHotData];
    

}

#pragma mark - 视图的创建
-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
//    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"%@", data);
    UIImage * image = [UIImage imageWithData:data];
   bgImageView.image = image;
    
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:tempView];
}
- (void)makeNavgation
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
    //    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"活动详情"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:titleLabel];
    
}

#pragma mark - 下载数据
-(void)loadData
{
    StartLoading;
    NSString * code = [NSString stringWithFormat:@"topic_id=%@dog&cat", [self.listModel topic_id]];
    NSString * sig = [MyMD5 md5:code];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", TOPICINFOAPI, [self.listModel topic_id], sig, [ControllerManager getSID]];
    NSLog(@"活动详情url:%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        NSLog(@"活动详情数据：%@",load.dataDict);
        if (isFinish) {
            NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            TopicDetailModel * model = [[TopicDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.txsArray = [dict objectForKey:@"txs"];
            [self.dataArray addObject:model];
            
            NSDate * endDate = [NSDate dateWithTimeIntervalSince1970:[self.listModel.end_time intValue]];
            NSTimeInterval  timeInterval = [endDate timeIntervalSinceNow];
            if (timeInterval<=0) {
                isEnd = YES;
            }
            
            //加载最新图片
//            if (isEnd) {
//                [self loadRankData];
//            }else{
                [self loadNewData];
//            }
            
            NSLog(@"%d",model.txsArray.count);
            if (!model.txsArray.count) {
                [self makeUI];
                LoadingSuccess
            }else{
                [self loadTxData];
            }
            [model release];

            
        }else{
            LoadingFailed;
            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"活动详情数据加载失败"];
        }
    }];
}
#pragma mark - rankData
-(void)loadRankData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"topic_id=%@dog&cat", self.listModel.topic_id]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", ACTRANKLISTAPI, self.listModel.topic_id, sig,[ControllerManager getSID]];
    NSLog(@"rankList：%@", url);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        [self.randomDataArray removeAllObjects];
        [self.rankDataArray removeAllObjects];
        NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
        for (NSDictionary * dict in array) {
            PhotoModel * model = [[PhotoModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.rankDataArray addObject:model];
            
            [model release];
        }
        [self.randomDataArray addObjectsFromArray:self.rankDataArray];
        self.lastImg_id = [self.randomDataArray[self.randomDataArray.count-1] img_id];
        [cv reloadData];
        
        LoadingSuccess;
    }];
    [request release];
}
#pragma mark - 参与用户头像下载
-(void)loadTxData
{
    self.txs = [NSMutableString stringWithCapacity:0];

    NSArray * array = [self.dataArray[0] txsArray];
    for(int i=0;i<array.count;i++){
        [self.txs appendString:array[i]];
        if (i != array.count-1) {
            [self.txs appendString:@","];
        }
    }
    NSLog(@"txs:%@", self.txs);
//    animal/othersApi&aids=
    NSString * str = [NSString stringWithFormat:@"aids=%@dog&cat", self.txs];
    NSString * code = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETLISTAPI, self.txs, code, [ControllerManager getSID]];
    NSLog(@"参与宠物列表：%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            [self.userDataArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (NSDictionary * dict in array) {
                InfoModel * model = [[InfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.userDataArray addObject:model];
                [model release];
            }
            [self makeUI];
            LoadingSuccess;
        }else{
            ShowAlertView;
            LoadingFailed;
            NSLog(@"请求赞列表失败");
        }
    }];
}
-(void)loadRandomData
{
    StartLoading;
    NSLog(@"randomAPI:%@",[NSString stringWithFormat:@"%@%@", RANDOMAPI, [ControllerManager getSID]]);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", RANDOMAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            //只包含img_id和图片的url
//            NSLog(@"宇宙广场数据:%@", load.dataDict);
            [self.randomDataArray removeAllObjects];
            [self.newDataArray removeAllObjects];
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.newDataArray addObject:model];
                
                [model release];
            }
            [self.randomDataArray addObjectsFromArray:self.newDataArray];
            self.lastImg_id = [self.randomDataArray[self.randomDataArray.count-1] img_id];
            [cv reloadData];
            
            LoadingSuccess;
        }else{
            LoadingFailed;
            NSLog(@"数据加载失败");
        }
    }];
    [request release];
}
-(void)loadRandomNextData
{
//    if (self.dataArray.count % 10 != 0) {
//        [cv footerEndRefreshing];
//        return;
//    }
    NSString * str = [NSString stringWithFormat:@"img_id=%@dog&cat", self.lastImg_id];
    NSString * sig = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", RANDOMAPI2, self.lastImg_id, sig, [ControllerManager getSID]];
    NSLog(@"next-url:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary: dict];
                [self.randomDataArray addObject:model];
                [model release];
            }
            self.lastImg_id = [self.randomDataArray[self.randomDataArray.count-1] img_id];
            [cv reloadData];
            [cv footerEndRefreshing];
        }else{
            NSLog(@"数据加载失败");
        }
    }];
    [request release];
}

- (void)loadHotData
{
    NSString *hotSig = [MyMD5 md5:[NSString stringWithFormat:@"topic_id=%@dog&cat",self.listModel.topic_id]];
    NSString *hotString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",POPULARAPI,self.listModel.topic_id,hotSig,[ControllerManager getSID]];
    NSLog(@"最热活动图片：%@",hotString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:hotString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        [self.randomDataArray removeAllObjects];
        [self.hotDataArray removeAllObjects];
        NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
        for (NSDictionary * dict in array) {
            PhotoModel * model = [[PhotoModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.hotDataArray addObject:model];
            
            [model release];
        }
        [self.randomDataArray addObjectsFromArray:self.hotDataArray];
        self.lastImg_id = [self.randomDataArray[self.randomDataArray.count-1] img_id];
        [cv reloadData];
        
        LoadingSuccess;
    }];
    [request release];
    
}
- (void)loadNewData
{
    StartLoading;
    NSString *newSig = [MyMD5 md5:[NSString stringWithFormat:@"topic_id=%@dog&cat",self.listModel.topic_id]];
    NSString *newString= [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",NEWESTAPI,self.listModel.topic_id,newSig,[ControllerManager getSID]];
    NSLog(@"最新活动图片：%@",newString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:newString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            [self.randomDataArray removeAllObjects];
            [self.newDataArray removeAllObjects];
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.newDataArray addObject:model];
                
                [model release];
            }
            [self.randomDataArray addObjectsFromArray:self.newDataArray];
            self.lastImg_id = [self.randomDataArray[self.randomDataArray.count-1] img_id];
            [cv reloadData];
            
            LoadingSuccess;
        }else{
            LoadingFailed;
            NSLog(@"数据加载失败");
        }
    }];
    [request release];
}
#pragma mark - collectionView创建
-(void)makeUI
{
    UIView *bgView = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 840/2)];
    //    [sv addSubview:bgView];
    [self.view bringSubviewToFront:navView];
    
    UIImageView * imageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, 135) ImageName:@"cat1.jpg"];
    [bgView addSubview:imageView];
    
    UIImageView * statusImageView = [MyControl createImageViewWithFrame:CGRectMake(320-20-142/2, 45, 142/2, 96/2) ImageName:@""];
    if (isEnd) {
        statusImageView.image = [UIImage imageNamed:@"24-2.png"];
    }else{
        statusImageView.image = [UIImage imageNamed:@"24-1.png"];
    }
    [imageView addSubview:statusImageView];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(13, 140, 200, 20) Font:17 Text:[self.listModel topic]];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = BGCOLOR;
    [bgView addSubview:titleLabel];
    
    //    NSString * str = @"那些年，我们一起追过的狗狗，\n一起怀念狗狗的友情岁月，和你在一起慢慢变老!";
    CGSize size = [[self.dataArray[0] des] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320-26, 500) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel * introduceLabel = [MyControl createLabelWithFrame:CGRectMake(13, 165, 320-26, size.height) Font:14 Text:[self.dataArray[0] des]];
    introduceLabel.textColor = [UIColor grayColor];
    [bgView addSubview:introduceLabel];
    
    NSArray * array = @[@"24-3.png", @"24-4.png", @"24-5.png"];
    for(int i=0;i<3;i++){
        UIView * lineView = [MyControl createViewWithFrame:CGRectMake(0, 170+size.height+i*35, 320, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [bgView addSubview:lineView];

        UIImageView * imageView2 = [MyControl createImageViewWithFrame:CGRectMake(13, 175+size.height+i*35, 25, 25) ImageName:array[i]];
        [bgView addSubview:imageView2];
        
        UILabel * desLabel = [MyControl createLabelWithFrame:CGRectMake(40, imageView2.frame.origin.y, 275, 25) Font:15 Text:@""];
        if (i == 0) {
            NSDate * startDate = [NSDate dateWithTimeIntervalSince1970:[self.listModel.start_time intValue]];
            NSDate * endDate = [NSDate dateWithTimeIntervalSince1970:[self.listModel.end_time intValue]];
            NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString * startTime = [dateFormat stringFromDate:startDate];
            NSString * endTime = [dateFormat stringFromDate:endDate];
            [dateFormat release];
            
            desLabel.text = [NSString stringWithFormat:@"%@至%@", startTime, endTime];
//            NSTimeInterval  timeInterval = [endDate timeIntervalSinceNow];
//            if (timeInterval<=0) {
//                statusImageView.image = [UIImage imageNamed:@"24-2.png"];
//            }
        }else if(i == 1){
            desLabel.text = self.listModel.reward;
            
        }else{
            //            desLabel.text = [NSString stringWithFormat:@"%@人", self.listModel.people];
            desLabel.text = [NSString stringWithFormat:@"%d人", self.userDataArray.count];
        }
        
        desLabel.textColor = [UIColor darkGrayColor];
        [bgView addSubview:desLabel];
        desLabel.tag = 100+i;
        
        if (i == 1) {
            UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(320-15-10, imageView2.frame.origin.y+5, 15, 20) ImageName:@"扩展更多图标.png"];
            [bgView addSubview:arrow];
            
            UIButton * button = [MyControl createButtonWithFrame:CGRectMake(0, lineView.frame.origin.y, 320, 35) ImageName:@"" Target:self Action:@selector(rewardClick) Title:nil];
            //            button.backgroundColor = [UIColor redColor];
            //            button.alpha = 0.5;
            [bgView addSubview:button];
        }
        
    }
    
    UILabel * desLabel = (UILabel *)[bgView viewWithTag:102];
//    NSLog(@"%f--%f", desLabel.frame.origin.y, desLabel.frame.size.height);
    //    self.userDataArray.count
    for (int i=0; i<self.userDataArray.count; i++) {
        UIImageView * headImageView = [MyControl createImageViewWithFrame:CGRectMake(13+i*35, desLabel.frame.origin.y+desLabel.frame.size.height+10, 30, 30) ImageName:@"defaultPetHead.png"];
        headImageView.layer.cornerRadius = 15;
        headImageView.layer.masksToBounds = YES;
        [bgView addSubview:headImageView];
        if (i == self.userDataArray.count-1) {
            UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(320-15-10, headImageView.frame.origin.y+5, 15, 20) ImageName:@"扩展更多图标.png"];
            [bgView addSubview:arrow];
            
            //参与用户按钮
            UIButton * partButton = [MyControl createButtonWithFrame:CGRectMake(0, headImageView.frame.origin.y, 320, 30) ImageName:@"" Target:self Action:@selector(partButtonClick) Title:nil];
//            partButton.backgroundColor = [UIColor redColor];
            [bgView addSubview:partButton];
            
            lastLine = [MyControl createViewWithFrame:CGRectMake(0, partButton.frame.origin.y+partButton.frame.size.height+5, self.view.frame.size.width, 1)];
            lastLine.backgroundColor = [UIColor whiteColor];
            [bgView addSubview:lastLine];
        }
        //头像的下载
        if (!([[self.userDataArray[i] tx] isKindOfClass:[NSNull class]] || [[self.userDataArray[i] tx] length] == 0)) {
            NSString * docDir = DOCDIR;
            if (!docDir) {
                NSLog(@"Documents 目录未找到");
            }else{
                NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [self.userDataArray[i] tx]]];
                UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txFilePath]];
                if (image) {
                    headImageView.image = image;
                }else{
                    [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, [self.userDataArray[i] tx]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                        if (isFinish) {
                            //本地目录，用于存放favorite下载的原图
                            NSString * docDir = DOCDIR;
                            //                    NSLog(@"docDir:%@", docDir);
                            if (!docDir) {
                                NSLog(@"Documents 目录未找到");
                            }else{
                                NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [self.userDataArray[i] tx]]];
                                //将下载的图片存放到本地
                                [load.data writeToFile:txFilePath atomically:YES];
                                headImageView.image = load.dataImage;
                            }
                        }else{
                        }
                    }];
                }
            }
        }
        
    }
    /*************************************/
    cv = [[PSCollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-40)];
    cv.delegate = self;
    
    cv.collectionViewDelegate = self;
    cv.collectionViewDataSource = self;
    cv.backgroundColor = [UIColor clearColor];
    cv.autoresizingMask = UIViewAutoresizingNone;
    cv.numColsPortrait = 2;
    //    cv.numColsLandscape = 1;
    cv.headerView = bgView;
    [cv addFooterWithTarget:self action:@selector(loadRandomNextData)];
    [self.view addSubview:cv];
    
    if (isEnd) {
        CGRect rect = bgView.frame;
        rect.size.height += 190;
        bgView.frame = rect;
        
        //横幅
        UIImageView * bannerImageView = [MyControl createImageViewWithFrame:CGRectMake(22.5, lastLine.frame.origin.y+15, 550/2, 97/2) ImageName:@"banner.png"];
        [bgView addSubview:bannerImageView];
        
        //铺设领奖台 Medals podium
        UIImageView * medalsPodiumImageView = [MyControl createImageViewWithFrame:CGRectMake(5, bannerImageView.frame.origin.y+130, 310, 190/2) ImageName:@"medalPodium.png"];
        [bgView addSubview:medalsPodiumImageView];
        
        //第1，2，3名
        NSArray * array = @[@"act_silver.png", @"act_gold.png", @"act_copper.png"];
        for (int i=0; i<3; i++) {
            UIImageView * photoImage = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 0, 0) ImageName:@"cat2.jpg"];
            [bgView addSubview:photoImage];
            UIImageView * medal = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 20, 25) ImageName:array[i]];
            [photoImage addSubview:medal];
//            45  60  35
            if (i == 0) {
                //2
                photoImage.frame = CGRectMake(31, medalsPodiumImageView.frame.origin.y-45, 75, 75);
            }else if(i == 1){
                //1
                photoImage.frame = CGRectMake(123, medalsPodiumImageView.frame.origin.y-60, 75, 75);
            }else{
                //3
                photoImage.frame = CGRectMake(216, medalsPodiumImageView.frame.origin.y-35, 75, 75);
            }
        }
    }else{
        //最新最热
        /*************colloctionView*****************/
        segmentView = [MyControl createViewWithFrame:CGRectMake(0, 380, bgView.frame.size.width, 35)];
        [segmentView retain];
        segmentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [bgView addSubview:segmentView];
        
        newButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, segmentView.frame.size.width/2, 35) ImageName:nil Target:self Action:@selector(newPicAction) Title:@"最新"];
        [newButton setTitleColor:BGCOLOR forState:UIControlStateNormal];
        [segmentView addSubview:newButton];
        
        UIView * verView = [MyControl createViewWithFrame:CGRectMake(self.view.frame.size.width/2-1, 2.5, 2, 30)];
        verView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        [segmentView addSubview:verView];
        
        hotButton = [MyControl createButtonWithFrame:CGRectMake(segmentView.frame.size.width/2, 0, segmentView.frame.size.width/2, 35) ImageName:nil Target:self Action:@selector(hotPicAction) Title:@"最热"];
        [hotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [segmentView addSubview:hotButton];
        
        //    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-40)];
        //    sv.contentSize = CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height);
        //    sv.scrollEnabled = NO;
        //    [self.view addSubview:sv];
    }
    

//    NSDate * endDate = [NSDate dateWithTimeIntervalSince1970:[self.listModel.end_time intValue]];
//    NSTimeInterval  timeInterval = [endDate timeIntervalSinceNow];
    
    UIButton * joinButton = [MyControl createButtonWithFrame:CGRectMake(0, self.view.frame.size.height-40, 320, 40) ImageName:@"" Target:self Action:@selector(joinButtonClick) Title:@"立即参加"];
    if (isEnd) {
        [joinButton setTitle:@"活动已结束" forState:UIControlStateNormal];
        joinButton.backgroundColor = [UIColor grayColor];
        joinButton.userInteractionEnabled = NO;
    }else{
        joinButton.backgroundColor = BGCOLOR;
    }
//    joinButton.backgroundColor = BGCOLOR;
    [self.view addSubview:joinButton];

    [self.view bringSubviewToFront:navView];
}
- (void)newPicAction
{
    NSLog(@"最新");
    
    if (self.newDataArray.count) {
        if (!isHotest) {
            return;
        }
        [self.randomDataArray removeAllObjects];
        [self.randomDataArray addObjectsFromArray:self.newDataArray];
        [cv reloadData];
    }else{
        [self loadNewData];
    }
    isHotest = NO;
    [newButton setTitleColor:BGCOLOR forState:UIControlStateNormal];
    [hotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (void)hotPicAction
{
    NSLog(@"最热");
    if (self.hotDataArray.count) {
        if (isHotest) {
            return;
        }
        [self.randomDataArray removeAllObjects];
        [self.randomDataArray addObjectsFromArray:self.hotDataArray];
        [cv reloadData];
    }else{
        [self loadHotData];
    }
    isHotest = YES;
    [newButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [hotButton setTitleColor:BGCOLOR forState:UIControlStateNormal];
}
-(void)joinButtonClick
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

-(void)partButtonClick
{
    LikersLIstViewController * vc = [[LikersLIstViewController alloc] init];
    vc.aids = self.txs;
    [USER setObject:@"1" forKey:@"isFromActivity"];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}

-(void)rewardClick
{
    //跳转到奖品页
    RewardViewController * vc = [[RewardViewController alloc] init];
    vc.topic_id = self.listModel.topic_id;
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}

-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - collectionView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%f",scrollView.contentOffset.y);
    int offset = (int)scrollView.contentOffset.y;
//    if (offset >= 400) {
//        segmentView2.hidden = NO;
//        segmentView.hidden = YES;
//    }else{
//        segmentView2.hidden = YES;
//        segmentView.hidden = NO;
//    }
    if (offset < 380 && isBerth == YES) {
        isBerth = NO;
        [segmentView removeFromSuperview];
        [cv.headerView addSubview:segmentView];
        segmentView.frame = CGRectMake(0, 380, self.view.frame.size.width, 35);
    }
    if(offset >= 380 && isBerth == NO){
        isBerth = YES;
        [segmentView removeFromSuperview];
        [self.view addSubview:segmentView];
        segmentView.frame = CGRectMake(0, 64, self.view.frame.size.width, 35);
    }
}

- (Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index {
    return [PSCollectionViewCell class];
}

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView {
    return self.randomDataArray.count;
}

- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index {
    PSCollectionViewCell *cell = [collectionView dequeueReusableViewForClass:[PSCollectionView class]];
    if (!cell) {
        cell = [[PSCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    imageview.image = [UIImage imageNamed:@"cat2.jpg"];
//    [cell addSubview:imageview];
    
    PhotoModel * model = self.randomDataArray[index];
    
    //图片存放到本地，从本地取
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }else{
        NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
        //        NSLog(@"randomFilePath:%@", randomFilePath);
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:randomFilePath]];
        if (image) {
            imageview.image = image;
        }else{

            imageview.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"20-1" ofType:@"png"]];
            
            [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    //本地目录，用于存放favorite下载的原图
                    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    if (!docDir) {
                        NSLog(@"Documents 目录未找到");
                    }else{
                        NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
                        //将下载的图片存放到本地
                        [load.data writeToFile:randomFilePath atomically:YES];
                        imageview.image = load.dataImage;
                        [cv reloadData];
                    }

                }
            }];
        }
    }
    
//    if (indexPath.row == self.dataArray.count-1) {
//        [quiltView footerBeginRefreshing];
//    }
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    [cell addSubview:imageview];

    return cell;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
//    return 100;
    PhotoModel * model = self.randomDataArray[index];
    //图片存放到本地，从本地取
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }else{
        NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
        UIImage * image = [UIImage imageWithContentsOfFile:randomFilePath];
        if (image) {
            Height[index] = image.size.height;
        }else{
            [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    //本地目录，用于存放favorite下载的原图
                    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    if (!docDir) {
                        NSLog(@"Documents 目录未找到");
                    }else{
                        NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
                        //将下载的图片存放到本地
                        [load.data writeToFile:randomFilePath atomically:YES];
                        Height[index] = load.dataImage.size.height;
                        
                    }
                }
            }];
        }
    }
    if (Height[index] == 0) {
        return 100;
    }else if(Height[index] < 100){
        return 100;
    }else if(Height[index] < 300){
        return Height[index]/1.3;
    }else{
        if (Height[index]/4 < 100) {
            return 100;
        }
        return Height[index]/4;
    }
}
-(void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    NSLog(@"%d", index);
    PicDetailViewController * vc = [[PicDetailViewController alloc] init];
    if (!isHotest) {
        //最新
        vc.img_id = [self.newDataArray[index] img_id];
    }else{
        //最热
        vc.img_id = [self.hotDataArray[index] img_id];
    }
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}

#pragma mark -
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
    
    __block ActivityDetailViewController * blockSelf = self;
    
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
    PublishViewController * vc = [[PublishViewController alloc] init];
    vc.oriImage = image;
    
    [USER setObject:@"1" forKey:@"isFromActivity"];
    [USER setObject:[NSString stringWithFormat:@"#%@#", self.listModel.topic] forKey:@"Topic"];
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:vc animated:YES completion:nil];
    }];
    [vc release];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
