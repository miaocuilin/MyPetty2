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
#import "DetailViewController.h"
#import "PhotoModel.h"
#import "UIImageView+WebCache.h"
#import "PicDetailViewController.h"
#import "ToolTipsViewController.h"
@interface RandomViewController () <TMQuiltViewDataSource,TMQuiltViewDelegate>
{
    TMQuiltView *qtmquitView;
    UIImageView * heart;
    ToolTipsViewController *toolTipsVC;
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
//-(void)viewDidAppear:(BOOL)animated
//{
//    if (!isLoaded) {
//        [self loadData];
//    }
//    isLoaded = YES;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createBg];
    [self createQtmquitView];
//    [self createFakeNavigation];
    [self loadData];
	
//	[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
//    self.menuBgView.frame = CGRectMake(50, self.view.frame.size.height-40, 220, 80);
//    [self.view bringSubviewToFront:self.menuBgBtn];
    
    //多线程
//    queue = [[NSOperationQueue alloc] init];
//    [queue setMaxConcurrentOperationCount:4];
    
}

-(void)createBg
{
    UIImageView * blur = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"blurBg.png"];
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
        [ControllerManager HUDImageIcon:@"Star.png" showView:self.view yOffset:0 Number:index];
    }
    
    BOOL islevel = [ControllerManager levelPOP:[USER objectForKey:@"oldexp"] addExp:index];
    if (islevel) {
        ToolTipsViewController *level = [[ToolTipsViewController alloc] init];
        level.expLevel = [[USER objectForKey:@"level"] integerValue];
        [self addChildViewController:level];
        [level didMoveToParentViewController:self];
        [self.view addSubview:level.view];
        [level createExpAlertView];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    
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
-(void)createQtmquitView
{
    qtmquitView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-[MyControl isIOS7])];
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
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", RECOMMENDAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            //只包含img_id和图片的url
            NSLog(@"宇宙广场数据:%@", load.dataDict);
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
            StartLoading;
            LoadingFailed;
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
    
    NSString * str = [NSString stringWithFormat:@"img_id=%@dog&cat", self.lastImg_id];
    NSString * sig = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", RECOMMENDAPI2, self.lastImg_id, sig, [ControllerManager getSID]];
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
            StartLoading;
            LoadingFailed;
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
    }
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
    NSString * docDir = DOCDIR;
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }else{
        NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
//        NSLog(@"randomFilePath:%@", randomFilePath);
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:randomFilePath]];
        if (image) {
            cell.photoView.image = image;
            //            [self refreshView];
//            [self setFooterView];
//            [qtmquitView addFooterWithTarget:self action:@selector(footerRereshing)];
        }else{
//            cell.photoView.image = [UIImage imageNamed:@"20-1.png"];
//            cell.photoView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"20-1" ofType:@"png"]];
            [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    //本地目录，用于存放favorite下载的原图
                    NSString * docDir = DOCDIR;
                    NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
                    //将下载的图片存放到本地
                    BOOL a = [load.data writeToFile:randomFilePath atomically:YES];
                    NSLog(@"图片存储情况：%d", a);
//                    threadCount--;
//                    NSLog(@"---threadCount:%d--count:%d", threadCount, queue.operationCount);
                    cell.photoView.image = load.dataImage;
                    [qtmquitView reloadData];
                    //
                    //                    [qtmquitView addFooterWithTarget:self action:@selector(footerRereshing)];
                    //                    [self setFooterView];
                }else{
                    //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    //            [alert show];
                    //            [alert release];
                }
            }];

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
        }
    }
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
    NSString * docDir = DOCDIR;
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }else{
        NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
//        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:randomFilePath]];
        UIImage * image = [UIImage imageWithContentsOfFile:randomFilePath];
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
            return Height[indexPath.row];
        }else{
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
        }
    }
    
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
            //无尺寸的旧照片
            if (model.cmtHeight) {
                Height[indexPath.row] = arc4random()%50+100 +model.cmtHeight+10+18;
            }else{
                Height[indexPath.row] = arc4random()%50+100 +35;
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
//    [ControllerManager HUDText:@"你得到了一个魔法棒" showView:self.view yOffset:110];
//    [ControllerManager HUDImageIcon:@"gold.png" showView:self.view yOffset:-40 Number:10];
//    [self HUDImageIcon:[UIImage imageNamed:@"gold.png"] showView:self.view yOffset:50 Number:100];
//    if (![ControllerManager getIsSuccess]) {
//        [USER setObject:[NSString stringWithFormat:@"%d", 1000+indexPath.row] forKey:@"pageNum"];
//        [UIView animateWithDuration:0.3 animations:^{
//            view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height+[MyControl isIOS7]);
//        }];
//        return;
//    }
    PhotoModel * model = self.dataArray[indexPath.row];
    //跳转到详情页，并传值
    PicDetailViewController * vc = [[PicDetailViewController alloc] init];
//    DetailViewController * vc = [[DetailViewController alloc] init];
    vc.img_id = model.img_id;
    vc.usr_id = model.usr_id;
//    if ([ControllerManager getIsSuccess]) {
//        vc.aid = [model.url substringToIndex:10];
//    }
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}

- (void)didReceiveMemoryWarning
{
//    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"内存不足"];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
