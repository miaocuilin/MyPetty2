//
//  RandomaViewController.m
//  MyPetty
//
//  Created by apple on 14/6/27.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "RandomViewController.h"
#import "MJRefresh.h"
#import "TMQuiltView.h"
#import "TMPhotoQuiltViewCell.h"
#import "PhotoModel.h"
#import "UIImageView+WebCache.h"
#import "FrontImageDetailViewController.h"
#import "WalkAndTeaseViewController.h"
#import "PicturePlayView.h"

@interface RandomViewController () <TMQuiltViewDataSource,TMQuiltViewDelegate,PictureplayDelegate>
{
    TMQuiltView *qtmquitView;
    UIImageView * heart;
    CGFloat beginOffsetY;
    CGFloat endOffsetY;
    
    PicturePlayView *playView;
    BOOL hasBanner;
//    CGRect playRect;
}
@property (nonatomic, retain) NSMutableArray *images;
@end

@implementation RandomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//animal/recommendApi[&type=][&aid=]
//- (void)animal
//{
//    NSString *sig = [NSString stringWithFormat:@"dog&cat"];
//    NSString *string = [NSString stringWithFormat:@"http://123.57.39.48/index.php?r=animal/recommendApi&sig=%@&SID=%@",sig,[ControllerManager getSID]];
//    NSLog(@"string:%@",string);
//}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (!isLoaded) {
//        [self loadData];
//    }
    isLoaded = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.bannerDataArray = [NSMutableArray arrayWithCapacity:0];
//    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self createBg];
    [self createQtmquitView];
//    [self createFakeNavigation];
    [self loadData];
    [self loadBannerData];
	
//	[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
//    self.menuBgView.frame = CGRectMake(50, self.view.frame.size.height-40, 220, 80);
//    [self.view bringSubviewToFront:self.menuBgBtn];
    
    //多线程
//    queue = [[NSOperationQueue alloc] init];
//    [queue setMaxConcurrentOperationCount:4];
    
//    @try{
//        
//    }
//    @catch(NSException *exception) {
//        NSLog(@"exception:%@", exception);
//    }
//    @finally {
//        
//    }
}
-(void)loadBannerData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", BANNERAPI, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            [self.bannerDataArray removeAllObjects];
//            NSLog(@"%@", load.dataDict);
            if ([[load.dataDict objectForKey:@"confVersion"] isEqualToString:[USER objectForKey:@"versionKey"]]) {
                isConf = YES;
            }
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]] && [[[load.dataDict objectForKey:@"data"] objectAtIndex:0] isKindOfClass:[NSArray class]] && [[[load.dataDict objectForKey:@"data"] objectAtIndex:0] count]) {
                
                NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                if (array.count) {
                    hasBanner = YES;
                }
                self.bannerDataArray = [NSMutableArray arrayWithArray:array];
                
                NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dict in array) {
                    [tempArray addObject:[dict objectForKey:@"img_url"]];
                }
                playView = [[PicturePlayView alloc] initWithFrame:CGRectMake(0, 32, WIDTH, 80) UrlArray:tempArray OtherView:NO isFromBanner:YES];
                playView.delegate = self;
//                playView.isFromBanner = YES;
                [self.view addSubview:playView];
                
                
                CGFloat h = 77;
                CGRect rect = qtmquitView.frame;
                rect.origin.y = sv.frame.origin.y+h+4+32;
                rect.size.height = self.view.frame.size.height-32-25-(h+8);
                qtmquitView.frame = rect;
                
            /******************华丽分割线*********************/
//                NSLog(@"%@", array);
//                NSLog(@"%@", [array[0] objectForKey:@"img_url"]);
//                sv = [[UIScrollView alloc] initWithFrame:CGRectMake(4, 64+4, self.view.frame.size.width-8, 80)];
//                sv.delegate = self;
//                //轮播
//                if (array.count>1) {
//                    timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(bannerPlay) userInfo:nil repeats:YES];
//                }
//                
//                if (array.count>1) {
//                    pageCount = array.count+2;
//                }else{
//                    pageCount = array.count;
//                }
//                
//                sv.contentSize = CGSizeMake(sv.frame.size.width*pageCount, 80);
//                if (pageCount>1) {
//                    sv.contentOffset = CGPointMake(sv.frame.size.width, 0);
//                }
//                sv.showsHorizontalScrollIndicator = NO;
////                sv.backgroundColor = [UIColor purpleColor];
//                sv.pagingEnabled = YES;
//                [self.view addSubview:sv];
//                
//                pageContorl = [[UIPageControl alloc] initWithFrame:CGRectMake((sv.frame.size.width-100)/2.0, sv.frame.origin.y+sv.frame.size.height-15, 100, 10)];
//                pageContorl.numberOfPages = pageCount;
//                if (pageCount>1) {
//                    pageContorl.numberOfPages = pageCount-2;
//                }else{
//                    pageContorl.hidden = YES;
//                }
//                [self.view addSubview:pageContorl];
//                
//                for (int i=0; i<pageCount; i++) {
//                    UIButton * button = [MyControl createButtonWithFrame:CGRectMake(sv.frame.size.width*i, 0, sv.frame.size.width, sv.frame.size.height) ImageName:@"" Target:self Action:@selector(bannerClick:) Title:nil];
//                    button.tag = 100+i;
//                    if (pageCount == 1) {
//                        [button setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/banner/%@", IMAGEURL, [array[i] objectForKey:@"img_url"]]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                            if (image) {
//                                float w = sv.frame.size.width;
//                                float h = w*image.size.height/image.size.width;
//                                CGRect rect = button.frame;
//                                rect.size.height = h;
//                                button.frame = rect;
//                                
//                                CGRect rect2 = sv.frame;
//                                rect2.size.height = h;
//                                sv.frame = rect2;
//                                
//                                CGRect rect4 = pageContorl.frame;
//                                rect4.origin.y = sv.frame.origin.y+sv.frame.size.height-15;
//                                pageContorl.frame = rect4;
//                                
//                                CGRect rect3 = qtmquitView.frame;
//                                rect3.origin.y = sv.frame.origin.y+h+4+32;
//                                rect3.size.height = self.view.frame.size.height-32-25-(h+8);
//                                qtmquitView.frame = rect3;
//
////                                CGRect rect5 = sv.frame;
////                                rect5.size.height = image.size.height;
////                                sv.frame = rect5;
//                                
//                                sv.contentSize = CGSizeMake(sv.contentSize.width, sv.frame.size.height);
//                            }
//                        }];
//                    }else{
//                        if (i == 0) {
//                            [button setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/banner/%@", IMAGEURL, [array[pageCount-3] objectForKey:@"img_url"]]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                                float w = sv.frame.size.width;
//                                float h = w*image.size.height/image.size.width;
//                                CGRect rect = button.frame;
//                                rect.size.height = h;
//                                button.frame = rect;
//                                
//                                CGRect rect2 = sv.frame;
//                                rect2.size.height = h;
//                                sv.frame = rect2;
//                                
//                                CGRect rect4 = pageContorl.frame;
//                                rect4.origin.y = sv.frame.origin.y+sv.frame.size.height-15;
//                                pageContorl.frame = rect4;
//                                
//                                CGRect rect3 = qtmquitView.frame;
//                                rect3.origin.y = sv.frame.origin.y+h+4+32;
//                                rect3.size.height = self.view.frame.size.height-32-25-(h+8);
//                                qtmquitView.frame = rect3;
//                                
//                                sv.contentSize = CGSizeMake(sv.contentSize.width, sv.frame.size.height);
//                            }];
//                        }else if(i == pageCount-1){
//                            [button setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/banner/%@", IMAGEURL, [array[0] objectForKey:@"img_url"]]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                                float w = sv.frame.size.width;
//                                float h = w*image.size.height/image.size.width;
//                                CGRect rect = button.frame;
//                                rect.size.height = h;
//                                button.frame = rect;
//                                
//                                CGRect rect2 = sv.frame;
//                                rect2.size.height = h;
//                                sv.frame = rect2;
//                                
//                                CGRect rect4 = pageContorl.frame;
//                                rect4.origin.y = sv.frame.origin.y+sv.frame.size.height-15;
//                                pageContorl.frame = rect4;
//                                
//                                CGRect rect3 = qtmquitView.frame;
//                                rect3.origin.y = sv.frame.origin.y+h+4+32;
//                                rect3.size.height = self.view.frame.size.height-32-25-(h+8);
//                                qtmquitView.frame = rect3;
//                            }];
//                        }else{
//                            [button setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/banner/%@", IMAGEURL, [array[i-1] objectForKey:@"img_url"]]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                                float w = sv.frame.size.width;
//                                float h = w*image.size.height/image.size.width;
//                                CGRect rect = button.frame;
//                                rect.size.height = h;
//                                button.frame = rect;
//                                
//                                CGRect rect2 = sv.frame;
//                                rect2.size.height = h;
//                                sv.frame = rect2;
//                                
//                                CGRect rect4 = pageContorl.frame;
//                                rect4.origin.y = sv.frame.origin.y+sv.frame.size.height-15;
//                                pageContorl.frame = rect4;
//                                
//                                CGRect rect3 = qtmquitView.frame;
//                                rect3.origin.y = sv.frame.origin.y+h+4+32;
//                                rect3.size.height = self.view.frame.size.height-32-25-(h+8);
//                                qtmquitView.frame = rect3;
//                                
////                                CGRect rect5 = sv.frame;
////                                rect5.size.height = image.size.height;
////                                sv.frame = rect5;
////                                
//                                sv.contentSize = CGSizeMake(sv.contentSize.width, sv.frame.size.height);
//                                
//                            }];
//                        }
//                    }
//                    
//                    [sv addSubview:button];
//                }
                
//                qtmquitView.frame = CGRectMake(0, 64+88, 320, self.view.frame.size.height-64-25-88);
            }else{
                //瀑布流提升
                sv.hidden = YES;
                pageContorl.hidden = YES;
                qtmquitView.frame = CGRectMake(0, 32, self.view.frame.size.width, self.view.frame.size.height-32-25);
            }
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
//-(void)bannerPlay
//{
//    float a = sv.contentOffset.x/sv.frame.size.width;
//    int b = a;
////    NSLog(@"%f--%d", a, b);
//    [UIView animateWithDuration:0.5 animations:^{
//        sv.contentOffset = CGPointMake((b+1)*sv.frame.size.width, 0);
//    }];
//}
-(void)selectedIndex:(NSInteger)index
{
    if (isConf) {
        return;
    }
    WalkAndTeaseViewController * vc = [[WalkAndTeaseViewController alloc] init];
    vc.isFromBanner = YES;
    vc.URL = [self.bannerDataArray[index] objectForKey:@"url"];
    vc.share_title = [self.bannerDataArray[index] objectForKey:@"title"];
    vc.share_des = [self.bannerDataArray[index] objectForKey:@"description"];
    vc.icon = [self.bannerDataArray[index] objectForKey:@"icon"];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
    
}
//-(void)bannerClick:(UIButton *)btn
//{
//    if (isConf) {
//        return;
//    }
//    NSLog(@"%d", btn.tag);
//    int a = btn.tag-100;
//    WalkAndTeaseViewController * vc = [[WalkAndTeaseViewController alloc] init];
//    vc.isFromBanner = YES;
//
//    if (pageCount>1) {
//        if (a == 0) {
//            //最后一个
//            vc.URL = [self.bannerDataArray[self.bannerDataArray.count-1] objectForKey:@"url"];
//            vc.share_title = [self.bannerDataArray[self.bannerDataArray.count-1] objectForKey:@"title"];
//            vc.share_des = [self.bannerDataArray[self.bannerDataArray.count-1] objectForKey:@"description"];
//            vc.icon = [self.bannerDataArray[self.bannerDataArray.count-1] objectForKey:@"icon"];
//        }else if(a == pageCount-1){
//            //第一个
//            vc.URL = [self.bannerDataArray[0] objectForKey:@"url"];
//            vc.share_title = [self.bannerDataArray[0] objectForKey:@"title"];
//            vc.share_des = [self.bannerDataArray[0] objectForKey:@"description"];
//            vc.icon = [self.bannerDataArray[0] objectForKey:@"icon"];
//        }else{
//            vc.URL = [self.bannerDataArray[a-1] objectForKey:@"url"];
//            vc.share_title = [self.bannerDataArray[a-1] objectForKey:@"title"];
//            vc.share_des = [self.bannerDataArray[a-1] objectForKey:@"description"];
//            vc.icon = [self.bannerDataArray[a-1] objectForKey:@"icon"];
//        }
//    }else{
//        vc.URL = [self.bannerDataArray[0] objectForKey:@"url"];
//        vc.share_title = [self.bannerDataArray[0] objectForKey:@"title"];
//        vc.share_des = [self.bannerDataArray[0] objectForKey:@"description"];
//        vc.icon = [self.bannerDataArray[0] objectForKey:@"icon"];
//    }
//    [self presentViewController:vc animated:YES completion:nil];
//    [vc release];
//}
-(void)createBg
{
    UIImageView * blur = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"blurBg.jpg"];
    [self.view addSubview:blur];
}
//-(void)createFakeNavigation
//{
//    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
//    [self.view addSubview:navView];
//    
//    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
//    alphaView.alpha = 0.85;
//    alphaView.backgroundColor = BGCOLOR;
//    [navView addSubview:alphaView];
//    
//    self.menuBtn = [MyControl createButtonWithFrame:CGRectMake(17, 30, 82/2, 54/2) ImageName:@"menu.png" Target:self Action:@selector(menuBtnClick:) Title:nil];
//    self.menuBtn.showsTouchWhenHighlighted = YES;
//    [navView addSubview:self.menuBtn];
//    
//    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 32, 200, 20) Font:17 Text:@"宠物星球"];
//    titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [navView addSubview:titleLabel];
//}
//-(void)menuBtnClick:(UIButton *)button
//{
//    //截屏
//    [MyControl saveScreenshotsWithView:[UIApplication sharedApplication].keyWindow];
//    button.selected = !button.selected;
//    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
//    if (button.selected) {
//        [menu showMenuAnimated:YES];
//    }else{
//        [menu hideMenuAnimated:YES];
//    }
//}
//-(void)viewDidAppear:(BOOL)animated
//{
//    NSLog(@"%f", qtmquitView.frame.origin.y);
//    int oldgold = [[USER objectForKey:@"oldgold"] intValue];
//    int gold = [[USER objectForKey:@"gold"] intValue];
//    [USER setObject:[USER objectForKey:@"gold"] forKey:@"oldgold"];
//    if (oldgold < gold) {
//        int index = gold - oldgold;
//        toolTipsVC = [[ToolTipsViewController alloc ]init];
//        [self addChildViewController:toolTipsVC];
//        [toolTipsVC didMoveToParentViewController:self];
//        [self.view addSubview:toolTipsVC.view];
//        toolTipsVC.coinNumber= index;
//        toolTipsVC.nextgold = [[USER objectForKey:@"next_gold"] intValue];
//        toolTipsVC.continuousDay = [[USER objectForKey:@"con_login"] intValue];
//        [toolTipsVC createAlertView];
//    }
////    [self RandomTips];
//
//}

- (void)RandomTips
{
    int oldexp = [[USER objectForKey:@"oldexp"] intValue];
    int exp = [[USER objectForKey:@"exp"] intValue];
    [USER setObject:[USER objectForKey:@"exp"] forKey:@"oldexp"];
    int index = exp - oldexp;
    if (oldexp < exp) {
//        [ControllerManager HUDImageIcon:@"Star.png" showView:self.view yOffset:0 Number:index];
    }
    
//    BOOL islevel = [ControllerManager levelPOP:[USER objectForKey:@"oldexp"] addExp:index];
//    if (islevel) {
//        ToolTipsViewController *level = [[ToolTipsViewController alloc] init];
//        level.expLevel = [[USER objectForKey:@"level"] integerValue];
//        [self addChildViewController:level];
//        [level didMoveToParentViewController:self];
//        [self.view addSubview:level.view];
//        [level createExpAlertView];
//        [level release];
//    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[USER objectForKey:@"Menu"] intValue] == 1) {
        //头像，名称，性别，年龄
//        [self refreshMenu];
        [USER setObject:@"0" forKey:@"Menu"];
    }
//    self.sc.selectedSegmentIndex = 0;
    //    self.navigationController.navigationBar.barTintColor = BGCOLOR;
//    [qtmquitView reloadData];
}

#pragma mark - 创建qtmquitView
-(void)adjustRandomToBig
{
//    if (!hasBanner) {
        [UIView beginAnimations:nil context:nil];
        qtmquitView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-25);
        [UIView commitAnimations];
//    }else{
//        
//    }
    
}
-(void)adjustRandomToNormal
{
//    if (!hasBanner) {
        [UIView beginAnimations:nil context:nil];
        qtmquitView.frame = CGRectMake(0, 32, self.view.frame.size.width, self.view.frame.size.height-25-32);
        [UIView commitAnimations];
//    }else{
//        [UIView beginAnimations:nil context:nil];
//        qtmquitView.frame = CGRectMake(0, 32+playView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-25-32-playView.frame.size.height);
//        [UIView commitAnimations];
//    }
    
}
-(void)createQtmquitView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    qtmquitView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 32, self.view.frame.size.width, self.view.frame.size.height-25-32)];
	qtmquitView.delegate = self;
	qtmquitView.dataSource = self;
    //	qtmquitView.backgroundColor = [UIColor darkGrayColor];
    
	[self.view addSubview:qtmquitView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [qtmquitView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [qtmquitView addFooterWithTarget:self action:@selector(footerRereshing)];
//    [qtmquitView addHeaderWithCallback:^{
//        [qtmquitView reloadData];
//    }];
//#warning 自动刷新(一进入程序就下拉刷新)
//    [qtmquitView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [qtmquitView addFooterWithCallback:^{
//        [qtmquitView reloadData];
//    }];
    

//    [self.view bringSubviewToFront:indicatorView];
}
//供main调用，刷新瀑布流
-(void)headerRefresh
{
    [qtmquitView headerBeginRefreshing];
}

- (void)headerRereshing
{
//    [qtmquitView removeFooter];
    [self loadData];
}
- (void)footerRereshing
{
//    [qtmquitView removeHeader];
    [self loadNextData];
}
-(void)loadData
{
//    if (isLoaded) {
//        self.reloadRandom();
//    }
    //释放图片内存
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@", RANDOMAPI, [ControllerManager getSID]]);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", RANDOMAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            //只包含img_id和图片的url
//            NSLog(@"宇宙广场数据:%@", load.dataDict);
            for (int i=0; i<self.dataArray.count; i++) {
                Height[i] = 0;
            }
            [self.dataArray removeAllObjects];
            
            
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                
                if ([model.cmt isKindOfClass:[NSString class]] && model.cmt.length) {
                    CGSize size = [model.cmt sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.view.frame.size.width/2-4*2, 100) lineBreakMode:1];
                    model.cmtWidth = size.width;
                    model.cmtHeight = size.height+10+18;
//                    NSLog(@"%f--%f--%@--%.1f--%.1f", self.view.frame.size.width/2, size.width, model.cmt, size.height, model.cmtHeight);
                }else{
                    model.cmtHeight = 0;
                }
                
                [model release];
            }
            
            self.lastImg_id = [self.dataArray[self.dataArray.count-1] img_id];
            [qtmquitView reloadData];
            [qtmquitView headerEndRefreshing];
//            [indicatorView stopAnimating];
            
//            LoadingSuccess;
        }else{
            LOADFAILED;
//            StartLoading;
//            LoadingFailed;
//            [indicatorView stopAnimating];
            [qtmquitView headerEndRefreshing];
            NSLog(@"数据加载失败");
        }
    }];
    [request release];
}
//-(void)downloadImageWithCell:(TMPhotoQuiltViewCell *)cell
//{
//    [cell retain];
//    
//    threadCount++;
//    NSLog(@"+++threadCount:%d--count:%d", threadCount, queue.operationCount);
//    NSString * url = self.tempUrl;
////    NSLog(@"--%@", [NSString stringWithFormat:@"%@%@", IMAGEURL, self.tempUrl]);
//    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, self.tempUrl]]];
//    
//    NSString * docDir = DOCDIR;
//    NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", url]];
//    //将下载的图片存放到本地
//    BOOL a = [data writeToFile:randomFilePath atomically:YES];
//    NSLog(@"图片存储情况：%d", a);
//    threadCount--;
//    NSLog(@"---threadCount:%d--count:%d", threadCount, queue.operationCount);
//    cell.photoView.image = [UIImage imageWithData:data];
//    [qtmquitView reloadData];

    
    
//    [cell release];
//    [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, self.tempUrl] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            //本地目录，用于存放favorite下载的原图
//            NSString * docDir = DOCDIR;
//            NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", url]];
//            //将下载的图片存放到本地
//            BOOL a = [load.data writeToFile:randomFilePath atomically:YES];
//            NSLog(@"图片存储情况：%d", a);
//            threadCount--;
//            NSLog(@"---threadCount:%d--count:%d", threadCount, queue.operationCount);
//            cell.photoView.image = load.dataImage;
//            [qtmquitView reloadData];
//            //
//            //                    [qtmquitView addFooterWithTarget:self action:@selector(footerRereshing)];
//            //                    [self setFooterView];
//        }else{
//            //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            //            [alert show];
//            //            [alert release];
//        }
//    }];

//}
-(void)loadNextData
{
    //http://54.199.161.210/dc/index.php?r=image/randomApi&img_id=@&sig=@%SID=@
    if (self.dataArray.count % 10 != 0) {
        [qtmquitView footerEndRefreshing];
        return;
    }
    
    //释放图片内存
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
    
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
                [self.dataArray addObject:model];
                
                if ([model.cmt isKindOfClass:[NSString class]] && model.cmt.length) {
                    CGSize size = [model.cmt sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.view.frame.size.width/2-4*2, 100) lineBreakMode:1];
                    model.cmtWidth = size.width;
                    model.cmtHeight = size.height+10+18;
                    //                    NSLog(@"%@--%d", model.cmt, model.cmtHeight);
                }else{
                    model.cmtHeight = 0;
                }
                
                [model release];
            }
            self.lastImg_id = [self.dataArray[self.dataArray.count-1] img_id];
            [qtmquitView reloadData];
            [qtmquitView footerEndRefreshing];
        }else{
            LOADFAILED;
//            StartLoading;
//            LoadingFailed;
            [qtmquitView footerEndRefreshing];
            NSLog(@"数据加载失败");
        }
    }];
    [request release];
}



- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView
{
    return self.dataArray.count;
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"] autorelease];
        cell.layer.borderWidth = 0.8;
        cell.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
//        NSLog(@"new alloc at index: %d", indexPath.row);
    }else{
//        NSLog(@"use old at index: %d", indexPath.row);
    }
    cell.photoView.image = [UIImage imageNamed:@"water_white.png"];
    
    cell.tag = 1000+indexPath.row;
    
    PhotoModel * model = self.dataArray[indexPath.row];
    self.tempUrl = model.url;
    
    [cell configUI:model];
    
    //解析点赞者字符串，与[USER objectForKey:@"usr_id"]对比
    //    if(![model.likers isKindOfClass:[NSNull class]]){
    //        self.likersArray = [model.likers componentsSeparatedByString:@","];
    //
    //        for(NSString * str in self.likersArray){
    //            if ([str isEqualToString:[USER objectForKey:@"usr_id"]]) {
    //                isLike[indexPath.row] = YES;
    //                break;
    //            }
    //        }
    //    }
    //    if (isLike[indexPath.row]) {
    //        cell.heart.image = [UIImage imageNamed:@"11-2.png"];
    //        cell.heartButton.selected = YES;
    //    }else{
    //        cell.heart.image = [UIImage imageNamed:@"11-1.png"];
    //        cell.heartButton.selected = NO;
    //    }
    //图片存放到本地，从本地取
//    NSString * docDir = DOCDIR;
//    if (!docDir) {
//        NSLog(@"Documents 目录未找到");
//    }else{
    
//    NSURL * URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]];
//    [MyControl addSkipBackupAttributeToItemAtURL:URL];
//    NSString * key = [[SDWebImageManager sharedManager] cacheKeyForURL:URL];
//    SDImageCache * cache = [SDImageCache sharedImageCache];
//    UIImage * image = [cache imageFromDiskCacheForKey:key];
//    @try{
//        if (image) {
//            cell.photoView.image = image;
//            //            cell.photoView.image = [MyControl image:image fitInSize:CGSizeMake(self.view.frame.size.width/2-4-2, Height[indexPath.row])];
//            //            [self refreshView];
//            //            [self setFooterView];
//            //            [qtmquitView addFooterWithTarget:self action:@selector(footerRereshing)];
//        }else{
//            [cell.photoView setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"water_white.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                
////                NSURL * URL2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]];
////                [MyControl addSkipBackupAttributeToItemAtURL:URL2];
////                NSString * key2 = [[SDWebImageManager sharedManager] cacheKeyForURL:URL2];
////                SDImageCache * cache2 = [SDImageCache sharedImageCache];
////                UIImage * image2 = [cache2 imageFromDiskCacheForKey:key2];
////                if (image2) {
////                    cell.photoView.image = image2;
////                }else{
////                    cell.photoView.image = image;
////                }
//                if (cell.tag == indexPath.row+1000) {
//                    NSLog(@"下载完了第%d个图片", indexPath.row);
//                    model.width = self.view.frame.size.width/2-4-2;
//                    model.height = (model.width/image.size.width)*image.size.height;
//                    //            Height[indexPath.row] = model.height;
//                    float tempHeight = 0;
//                    if(model.cmtHeight){
//                        tempHeight = model.height+model.cmtHeight;
//                    }else{
//                        tempHeight = model.height+35;
//                    }
//                    
//                    if ([model.url rangeOfString:@"&"].location == NSNotFound) {
//                        NSLog(@"刷新瀑布流-%d", indexPath.row);
//                        Height[indexPath.row] = tempHeight;
//                        [quiltView reloadData];
//                    }
//                }else{
//                    NSLog(@"celltag:%d--row:%d", cell.tag, indexPath.row);
////                    TMPhotoQuiltViewCell * tempCell = (TMPhotoQuiltViewCell *)[self.view viewWithTag:cell.tag];
////                    cell.photoView.image = [UIImage imageNamed:@"water_white.png"];
//                    
//                }
//                //                [self reloadQuiltView];
//                
//            }];
//        }
//    }@catch(NSException * exception){
//        NSLog(@"%@", exception);
//    }@finally{
//        
//    }
//        NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
////        NSLog(@"randomFilePath:%@", randomFilePath);
//        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:randomFilePath]];
    
    
//            cell.photoView.image = [UIImage imageNamed:@"20-1.png"];
//            cell.photoView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"20-1" ofType:@"png"]];
//            [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//                if (isFinish) {
//                    //本地目录，用于存放favorite下载的原图
//                    NSString * docDir = DOCDIR;
//                    NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
//                    //将下载的图片存放到本地
//                    BOOL a = [load.data writeToFile:randomFilePath atomically:YES];
//                    NSLog(@"图片存储情况：%d", a);
//                    threadCount--;
//                    NSLog(@"---threadCount:%d--count:%d", threadCount, queue.operationCount);
//                    cell.photoView.image = load.dataImage;
//                    cell.photoView.image = [MyControl image:load.dataImage fitInSize:CGSizeMake(self.view.frame.size.width/2-4-2, Height[indexPath.row])];
//                    [qtmquitView reloadData];
                    //
                    //                    [qtmquitView addFooterWithTarget:self action:@selector(footerRereshing)];
                    //                    [self setFooterView];
//                }else{
                    //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    //            [alert show];
                    //            [alert release];
//                }
//            }];

//            NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImageWithCell:) object:cell];
//            [queue addOperation:operation];
//            [operation autorelease];

//            [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//                if (isFinish) {
//                    //本地目录，用于存放favorite下载的原图
//                    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//                    if (!docDir) {
//                        NSLog(@"Documents 目录未找到");
//                    }else{
//                        NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
//                        //将下载的图片存放到本地
//                        [load.data writeToFile:randomFilePath atomically:YES];
//                        cell.photoView.image = load.dataImage;
//                        [qtmquitView reloadData];
//                    }
//                    //
////                    [qtmquitView addFooterWithTarget:self action:@selector(footerRereshing)];
////                    [self setFooterView];
//                }else{
//                    //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    //            [alert show];
//                    //            [alert release];
//                }
//            }];
//        }
//    }
    cell.titleLabel.text = model.cmt;
    //    NSString * url = [NSString stringWithFormat:@"%@%@", IMAGEURL, model.url];
    //    [cell.photoView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"13-1.png"]];
    
    //    cell.titleLabel.text = model.likes;

//    if (indexPath.row == self.dataArray.count-1) {
//        [quiltView footerBeginRefreshing];
//    }
    
//    if (indexPath.row == (int)(self.dataArray.count/3*2-1)-1) {
//        NSLog(@"--%d", self.dataArray.count);
//    }
//    if (indexPath.row == (int)(self.dataArray.count/3*2-1)) {
//        if(limitedCount != self.dataArray.count){
//        [quiltView footerEndRefreshing];
//            [quiltView footerBeginRefreshing];
//        }
//        limitedCount = self.dataArray.count;
//        NSLog(@"--%d", self.dataArray.count);
//    }
    
    return cell;
}
//-(void)buttonClick:(UIButton *)button
//{
//    button.selected = !button.selected;
//    if (button.selected) {
//        heart.image = [UIImage imageNamed:@"11-2.png"];
//        //        numLabel.text = [NSString stringWithFormat:@"%d", [numLabel.text intValue]+1];
//    }else{
//        heart.image = [UIImage imageNamed:@"11-1.png"];
//        //        numLabel.text = [NSString stringWithFormat:@"%d", [numLabel.text intValue]-1];
//    }
//}

#pragma mark - TMQuiltViewDelegate

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    return 2;
    //    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
    //        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)
    //	{
    //        return 3;
    //    } else {
    //        return 2;
    //    }
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoModel * model = self.dataArray[indexPath.row];
    //图片存放到本地，从本地取
//    NSString * docDir = DOCDIR;
//    if (!docDir) {
//        NSLog(@"Documents 目录未找到");
//    }else{
//        NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
////        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:randomFilePath]];
//        UIImage * image = [UIImage imageWithContentsOfFile:randomFilePath];
//        if (image) {
////            Height[indexPath.row] = image.size.height;
//            model.width = self.view.frame.size.width/2-4-2;
//            model.height = (model.width/image.size.width)*image.size.height;
////            Height[indexPath.row] = model.height;
//            if(model.cmtHeight){
//                Height[indexPath.row] = model.height+model.cmtHeight;
//            }else{
//                Height[indexPath.row] = model.height+35;
//            }
//            return Height[indexPath.row];
//        }else{
//            [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//                if (isFinish) {
//                    //本地目录，用于存放favorite下载的原图
//                    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//                    if (!docDir) {
//                        NSLog(@"Documents 目录未找到");
//                    }else{
//                        NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
//                        //将下载的图片存放到本地
//                        [load.data writeToFile:randomFilePath atomically:YES];
//                        Height[indexPath.row] = load.dataImage.size.height;
//                        
//                        //每次新下载完一张图片后都刷新瀑布流
////                        if (indexPath.row == self.dataArray.count-1) {
////                            [qtmquitView reloadData];
////                        }
//                        
//                    }
//                }else{
//                    //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    //            [alert show];
//                    //            [alert release];
//                }
//            }];
//        }
//    }
    
    //    if (!didLoad[indexPath.row]) {
    //        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, [self.dataArray[indexPath.row] url]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
    //            if (isFinish) {
    //                Height[indexPath.row] = load.dataImage.size.height;
    //                didLoad[indexPath.row] = 1;
    ////                NSLog(@"----------%d行------------", indexPath.row);
    ////                NSLog(@"==didLoad%d:%d", indexPath.row, didLoad[indexPath.row]);
    //                //加载点赞页面
    //
    //                if (indexPath.row == self.dataArray.count-1) {
    //                    [qtmquitView reloadData];
    //                    [self setFooterView];
    //                }
    //                for(int i=0;i<self.dataArray.count;i++) {
    //                    if (!didLoad[i] || i != self.dataArray.count-1) {
    //                        break;
    //                    }else{
    //                        [quiltView reloadData];
    //                        [self setFooterView];
    //                    }
    //                }
    //            }
    //        }];
    //    }
//    return 100;
    if (Height[indexPath.row] == 0) {
        if ([model.url rangeOfString:@"&"].location != NSNotFound) {
            //有尺寸的照片
            //解析照片名字，得到尺寸
            NSArray * arr1 = [model.url componentsSeparatedByString:@"_"];
            NSString * str1 = [[arr1[arr1.count-1] componentsSeparatedByString:@"."] objectAtIndex:0];
            NSArray * arr2 = [str1 componentsSeparatedByString:@"&"];
            float tempWidth = [arr2[0] floatValue];
            float tempHeight = [arr2[1] floatValue];
            model.width = self.view.frame.size.width/2-4-2;
            model.height = (model.width/tempWidth)*tempHeight;
//            NSLog(@"%@--%f--%f--%d--%d", str1, tempWidth, tempHeight, model.width, model.height);
            if (model.cmtHeight) {
                Height[indexPath.row] = model.height+model.cmtHeight;
            }else{
                Height[indexPath.row] = model.height+35;
            }
            
        }else{
            //无尺寸的旧照片，查看本地是否有其照片，有取出来拿尺寸，没有就随机
            /*为了获取图片高度，如果本地有缓存图片，拿到其高度，并
             赋值，如果没有图片*/
            NSURL * URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]];
            [MyControl addSkipBackupAttributeToItemAtURL:URL];
            NSString * key = [[SDWebImageManager sharedManager] cacheKeyForURL:URL];
            SDImageCache * cache = [SDImageCache sharedImageCache];
            UIImage * image = [cache imageFromDiskCacheForKey:key];
            if (image) {
                //            Height[indexPath.row] = image.size.height;
                model.width = self.view.frame.size.width/2-4-2;
                model.height = (model.width/image.size.width)*image.size.height;
                //            Height[indexPath.row] = model.height;
                if(model.cmtHeight){
                    Height[indexPath.row] = model.height+model.cmtHeight;
                }else{
                    Height[indexPath.row] = model.height+35;
                }
                //                return Height[indexPath.row];
            }else{
                if(model.cmtHeight) {
                    Height[indexPath.row] = arc4random()%50+100 +model.cmtHeight+10+18;
                }else{
                    Height[indexPath.row] = arc4random()%50+100 +35;
                }
            }
        }
        
        
        return Height[indexPath.row];
    }else{
        return Height[indexPath.row];
//        model.width = self.view.frame.size.width/2-4-2;
//        model.height = (model.width/image.size.width)*image.size.height;
//        if (model.cmtHeight) {
//            return Height[indexPath.row]+model.cmtHeight;
//        }else{
//            return Height[indexPath.row];
//        }
    }
//    }else if(Height[indexPath.row] < 100){
//        return 100;
//    }else if(Height[indexPath.row] < 300){
//        return Height[indexPath.row]/1.3;
//    }else{
//        if (Height[indexPath.row]/4 < 100) {
//            return 100;
//        }
//        return Height[indexPath.row]/4;
//    }
    
    //    return [self imageAtIndexPath:indexPath].size.height / [self quiltViewNumberOfColumns:quiltView]/2.5;
    //    if (height<50) {
    //        NSLog(@"indexpath.%d=%f", indexPath.row, height);
    //
    //        return 50;
    //    }else{
    //        NSLog(@"indexpath.%d.height=%f", indexPath.row, height);
    //        return height;
    //    }
}

- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"index:%d",indexPath.row+1);

    PhotoModel * model = self.dataArray[indexPath.row];
    //跳转到详情页，并传值
//    PicDetailViewController * vc = [[PicDetailViewController alloc] init];
//    DetailViewController * vc = [[DetailViewController alloc] init];
    FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
    vc.img_id = model.img_id;
    vc.isFromRandom = YES;
    vc.imageURL = [MyControl returnThumbImageURLwithName:model.url Width:[UIScreen mainScreen].bounds.size.width Height:0];
    vc.imageCmt = model.cmt;
//    vc.usr_id = model.usr_id;
//    if ([ControllerManager getIsSuccess]) {
//        vc.aid = [model.url substringToIndex:10];
//    }
    [ControllerManager addTabBarViewController:vc];
//    MainViewController * main = [ControllerManager shareMain];
//    [main.view addSubview:vc.view];
    
//    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}

- (void)didReceiveMemoryWarning
{
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
//    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"内存不足"];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    
}
#pragma mark -
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == sv) {
        float a = sv.contentOffset.x/sv.frame.size.width;
//        NSLog(@"---%f", a);
        if (pageCount>1 && a == pageCount-1) {
//            NSLog(@"到达最后一张");
            
            [self performSelector:@selector(click1) withObject:nil afterDelay:0.5];
            
            pageContorl.currentPage = 0;
        }else if(pageCount > 1 && a == 0){
//            NSLog(@"到达第一张");
            scrollView.contentOffset = CGPointMake(sv.frame.size.width*(pageCount-2), 0);
            pageContorl.currentPage = pageCount-2;
        }else{
//            NSLog(@"%f", a);
            if (pageCount>1) {
                pageContorl.currentPage = a-1;
            }else{
                pageContorl.currentPage = a;
            }

        }
    }else{
//        if (scrollView.contentOffset.y <=0 && hasBanner && !(beginOffsetY <= 0 && endOffsetY < 0)) {
//            [self showBanner];
//            
//            [UIView beginAnimations:nil context:nil];
//            qtmquitView.frame = CGRectMake(0, 32+playView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-25-32-playView.frame.size.height);
//            [UIView commitAnimations];
//        }
    }
}
-(void)click1
{
    sv.contentOffset = CGPointMake(sv.frame.size.width, 0);
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    beginOffsetY = scrollView.contentOffset.y;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    endOffsetY = scrollView.contentOffset.y;
    if (beginOffsetY<endOffsetY) {
        //上滑
        if (!(beginOffsetY >= scrollView.contentSize.height-scrollView.frame.size.height && endOffsetY > scrollView.contentSize.height-scrollView.frame.size.height)) {
            self.rollUp();
            [self hideBanner];
        }
    }else{
        if (!(beginOffsetY <= 0 && endOffsetY < 0)) {
            self.rollDown();
//            [self showBanner];
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == 0) {
        [self showBanner];
        
        [UIView beginAnimations:nil context:nil];
        qtmquitView.frame = CGRectMake(0, 32+playView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-25-32-playView.frame.size.height);
        [UIView commitAnimations];
    }
}

-(void)hideBanner
{
    [UIView beginAnimations:nil context:nil];
    [MyControl setOriginY:-playView.frame.size.height WithView:playView];
    [UIView commitAnimations];
}
-(void)showBanner
{
    [UIView beginAnimations:nil context:nil];
    [MyControl setOriginY:32 WithView:playView];
    [UIView commitAnimations];
}




#pragma mark - 金币、星星、红心弹窗
- (void)HUDText:(NSString *)string showView:(UIView *)inView yOffset:(float) offset
{
    HUD = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    [inView addSubview:HUD];
    HUD.minSize = CGSizeMake(string.length * 5, 30);
    HUD.margin = 10;
    HUD.labelText = string;
    
    HUD.mode =MBProgressHUDModeText;
    [HUD show:YES];
    HUD.yOffset = offset;
    HUD.color = [UIColor colorWithRed:247/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    [HUD hide:YES afterDelay:2.0];
}

- (void)HUDImageIcon:(UIImage *)iconImage showView:(UIView *)inView yOffset:(float)offset Number:(int)num
{
    HUD = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    [inView addSubview:HUD];
    HUD.minSize = CGSizeMake(130, 60);
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.yOffset = offset;
    HUD.margin = 0;
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 60)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 42, 42)];
    [totalView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 70, 30)];
    label.text = [NSString stringWithFormat:@"+ %d",num];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentLeft;
    [totalView addSubview:label];
    HUD.customView = totalView;
    HUD.color = [UIColor colorWithRed:247/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    imageView.image = iconImage;
    [HUD hide:YES afterDelay:2.0];
    
}

@end
