//
//  NewWaterFlowViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/10/24.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "NewWaterFlowViewController.h"
#import "PhotoModel.h"
#import "WaterFlowCell.h"
#import "PicDetailViewController.h"
#define LabelFont 12
@implementation NewWaterFlowViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArray1 = [NSMutableArray arrayWithCapacity:0];
    self.dataArray2 = [NSMutableArray arrayWithCapacity:0];
    self.tempArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createBg];
//    [self createFakeNavigation];
    [self createTableView];
    [self loadData];
}

#pragma mark -
-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:bgImageView];
    
    NSString * docDir = DOCDIR;
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    
    UIImage * image = [UIImage imageWithData:data];
    bgImageView.image = image;
    
//    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
//    [self.view addSubview:tempView];
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
//    
//    camara = [MyControl createButtonWithFrame:CGRectMake(320-82/2-15, 64-54/2-7, 82/2, 54/2) ImageName:@"相机图标.png" Target:self Action:@selector(camaraClick) Title:nil];
//    camara.showsTouchWhenHighlighted = YES;
//    [navView addSubview:camara];
//}
//-(void)menuBtnClick:(UIButton *)btn{}
//-(void)camaraClick{}

#pragma mark -
-(void)createTableView
{
    bgTv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
//    tv.delegate = self;
//    tv.dataSource = self;
    bgTv.separatorStyle = 0;
    bgTv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgTv];
    [bgTv release];
    [bgTv addHeaderWithTarget:self action:@selector(loadData)];
    [bgTv addFooterWithTarget:self action:@selector(loadNextData)];
    
    self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.separatorStyle = 0;
    self.tv.showsVerticalScrollIndicator = NO;
    self.tv.backgroundColor = [UIColor clearColor];
//    self.tv.bounces = NO;
    [bgTv addSubview:self.tv];
    [self.tv release];
    
    tv2 = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tv2.delegate = self;
    tv2.dataSource = self;
    tv2.separatorStyle = 0;
    tv2.showsVerticalScrollIndicator = NO;
    tv2.backgroundColor = [UIColor clearColor];
    [bgTv addSubview:tv2];
    [tv2 release];
}
#pragma mark - 数据加载
-(void)loadData
{
    StartLoading;
    
    NSString * url = [NSString stringWithFormat:@"%@%@", RECOAPI, [ControllerManager getSID]];
    
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            LoadingSuccess;
            
            NSLog(@"萌宠推荐数据:%@", load.dataDict);
            [self.dataArray removeAllObjects];
            [self.dataArray1 removeAllObjects];
            [self.dataArray2 removeAllObjects];
            [self.tempArray removeAllObjects];
            height1 = 0;
            height2 = 0;
            tempNum = 0;
            tempCount = 0;
            count = 0;
            page = 0;
            
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            
            tempNum = array.count;
            //多线程
//            NSOperationQueue * queue = [[NSOperationQueue alloc] init];
//            [queue setMaxConcurrentOperationCount:1];
            self.tempArray = [NSMutableArray arrayWithArray:array];
            
            [self downloadImageWithArray];
//            for (NSDictionary * dict in array) {
//                PhotoModel * model = [[PhotoModel alloc] init];
//                [model setValuesForKeysWithDictionary:dict];
//                [self.dataArray addObject:model];
//                
//                if ([model.cmt isKindOfClass:[NSString class]] && model.cmt.length) {
//                    CGSize size = [model.cmt sizeWithFont:[UIFont systemFontOfSize:LabelFont] constrainedToSize:CGSizeMake(self.view.frame.size.width/2-8-4, 100) lineBreakMode:1];
//                    model.cmtHeight = size.height;
////                    NSLog(@"%@--%d", model.cmt, model.cmtHeight);
//                }else{
//                    model.cmtHeight = 0;
//                }
//                
////                NSLog(@"%@--%d", model.cmt, model.cmtHeight);
//                
//                NSString * path = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
////                NSLog(@"%@", path);
//                UIImage * image = [UIImage imageWithContentsOfFile:path];
//                if (image) {
//                    //比例调整 w=20 h=15    W=15  H=(W/w)*h
//                    model.width = self.view.frame.size.width/2-8;
//                    model.height = (model.width/image.size.width)*image.size.height;
//                    tempCount++;
//                    [self check];
//                }else{
//                    model.height = 100;
//                    dispatch_queue_t queue;
//                    queue = dispatch_queue_create("com", NULL);
//                    dispatch_async(queue, ^{
//                        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]]];
//                        
//                        UIImage * tempImage = [UIImage imageWithData:data];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            tempCount++;
//                            
//                            model.width = self.view.frame.size.width/2-8;
//                            model.height = (model.width/tempImage.size.width)*tempImage.size.height;
//                            BOOL a = [data writeToFile:path atomically:YES];
//                            NSLog(@"瀑布流图片存储结果a:%d", a);
//                            [self check];
//                        });
//                    });
                    
//                    NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage:) object:model];
//                    [queue addOperation:operation];
            
                    
                    
//                    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//                        if (isFinish) {
//                            tempCount++;
//                            
//                            model.width = self.view.frame.size.width/2-8;
//                            model.height = (model.width/load.dataImage.size.width)*load.dataImage.size.height;
//                            BOOL a = [load.data writeToFile:path atomically:YES];
//                            NSLog(@"瀑布流图片存储结果a:%d", a);
//                            
//                            [self check];
//                        }else{
//                            
//                        }
//                    }];
//                    [request release];
            
                    
//                    model.height = 100.0f;
//                    model.width = self.view.frame.size.width/2-8;
//                    NSDictionary * tempDict = [MyControl imageSizeFrom:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]]];
//                    model.height = (model.width/[[tempDict objectForKey:@"width"] floatValue])*[[tempDict objectForKey:@"height"] floatValue];
//                }
//                [model release];
//            }
//            self.lastImg_id = [self.dataArray[self.dataArray.count-1] img_id];
            
//            LoadingSuccess;
        }else{
            LoadingFailed;
//            [qtmquitView headerEndRefreshing];
            NSLog(@"数据加载失败");
        }
        [bgTv headerEndRefreshing];
    }];
    [request release];
}
-(void)downloadImageWithArray
{
    if (!self.tempArray.count) {
        return;
    }
    NSDictionary * dict = self.tempArray[0];
    PhotoModel * model = [[PhotoModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    [self.dataArray addObject:model];
    
    if (self.tempArray.count == 1) {
        page++;
//        self.lastImg_id = [self.dataArray[self.dataArray.count-1] img_id];
//        NSLog(@"lastImg_id:%@", self.lastImg_id);
    }
    
    if ([model.cmt isKindOfClass:[NSString class]] && model.cmt.length) {
        CGSize size = [model.cmt sizeWithFont:[UIFont systemFontOfSize:LabelFont] constrainedToSize:CGSizeMake(self.view.frame.size.width/2-4*3, 100) lineBreakMode:1];
        model.cmtWidth = size.width;
        model.cmtHeight = size.height+23;
//        NSLog(@"%f--%f--%@--%.1f--%.1f", self.view.frame.size.width/2, size.width, model.cmt, size.height, model.cmtHeight);
    }else{
        model.cmtHeight = 35;
    }
    
    //                NSLog(@"%@--%d", model.cmt, model.cmtHeight);
    
    NSString * path = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
    //                NSLog(@"%@", path);
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    if (image) {
        //比例调整 w=20 h=15    W=15  H=(W/w)*h
        model.width = self.view.frame.size.width/2-4-2;
        model.height = (model.width/image.size.width)*image.size.height;
        tempCount++;
        [self check];
        [self.tempArray removeObjectAtIndex:0];
        [self downloadImageWithArray];
    }else{
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                tempCount++;
                
                model.width = self.view.frame.size.width/2-4-2;
                model.height = (model.width/load.dataImage.size.width)*load.dataImage.size.height;
                BOOL a = [load.data writeToFile:path atomically:YES];
                NSLog(@"瀑布流图片存储结果a:%d", a);
                
                [self check];
                
                [self.tempArray removeObjectAtIndex:0];
                [self downloadImageWithArray];
            }else{
                
            }
        }];
        [request release];
    }
    [model release];
}

-(void)downloadImage:(PhotoModel *)model
{
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]]];
    
    UIImage * tempImage = [UIImage imageWithData:data];

    tempCount++;
    
    model.width = self.view.frame.size.width/2-8;
    model.height = (model.width/tempImage.size.width)*tempImage.size.height;
    NSString * path = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
    BOOL a = [data writeToFile:path atomically:YES];
    NSLog(@"瀑布流图片存储结果a:%d", a);
    
    [self check];
}
-(void)check
{
    NSLog(@"***%d---%d", tempNum, tempCount);
//    if (tempCount != tempNum) {
        if(!tempCount){
//            [self.tv reloadData];
//            [tv2 reloadData];
            return;
        }
//        return;
//    }
//    LoadingSuccess;
//    count = self.dataArray.count;
    
    //分配tv和tv2
    if (!count) {
        [self.dataArray1 addObject:self.dataArray[0]];
        height1 = [self.dataArray[0] height]+[self.dataArray[0] cmtHeight]+4*2;
        count = 1;
        [self.tv reloadData];
        tv2.contentSize = self.tv.contentSize;
        return;
    }
    
    
    for (int i=count; i<tempCount; i++) {
        PhotoModel * model = self.dataArray[i];
        if (height1>height2) {
            [self.dataArray2 addObject:self.dataArray[i]];
            height2 += model.height+model.cmtHeight+4*2;
            [tv2 reloadData];
        }else{
            [self.dataArray1 addObject:self.dataArray[i]];
            height1 += model.height+model.cmtHeight+4*2;
            [self.tv reloadData];
        }
    }
    
    count = tempCount;
    
    //            NSLog(@"%d", self.dataArray.count);
//    [self.tv reloadData];
//    [tv2 reloadData];
    
    if (height1>height2) {
        //                bgTv.contentSize = CGSizeMake(self.view.frame.size.width, tv.contentSize.height);
        tv2.contentSize = self.tv.contentSize;
    }else{
        //                bgTv.contentSize = CGSizeMake(self.view.frame.size.width, tv2.contentSize.height);
        self.tv.contentSize = tv2.contentSize;
    }
    
}
-(void)loadNextData
{
    StartLoading;
    if (self.dataArray.count % 10 != 0) {
        LoadingSuccess;
        [bgTv footerEndRefreshing];
        return;
    }
    NSString * str = [NSString stringWithFormat:@"page=%ddog&cat", page];
    NSString * sig = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", RECOAPI2, page, sig, [ControllerManager getSID]];
    //    NSLog(@"next-url:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"loadMore:%@", load.dataDict);
            LoadingSuccess;
            
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            tempNum = array.count;
            tempCount = 0;
            
            //多线程
//            NSOperationQueue * queue = [[NSOperationQueue alloc] init];
//            [queue setMaxConcurrentOperationCount:1];
            [self.tempArray removeAllObjects];
            self.tempArray = [NSMutableArray arrayWithArray:array];
            [self downloadImageWithArray2];
//            for (NSDictionary * dict in array) {
//                PhotoModel * model = [[PhotoModel alloc] init];
//                [model setValuesForKeysWithDictionary: dict];
//                [self.dataArray addObject:model];
//                
//                if ([model.cmt isKindOfClass:[NSString class]] && model.cmt.length) {
//                    CGSize size = [model.cmt sizeWithFont:[UIFont systemFontOfSize:LabelFont] constrainedToSize:CGSizeMake(self.view.frame.size.width/2-8-4, 100) lineBreakMode:1];
//                    model.cmtHeight = size.height;
////                    NSLog(@"%@--%d", model.cmt, model.cmtHeight);
//                }else{
//                    model.cmtHeight = 0;
//                }
//                
//                NSString * path = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
//                UIImage * image = [UIImage imageWithContentsOfFile:path];
//                
//                if (image) {
//                    //比例调整 w=20 h=15    W=15  H=(W/w)*h
//                    model.width = self.view.frame.size.width/2-8;
//                    model.height = (model.width/image.size.width)*image.size.height;
//                    tempCount++;
//                    [self check2];
//                }else{
//                    NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage2:) object:model];
//                    [queue addOperation:operation];
//                    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//                        if (isFinish) {
//                            tempCount++;
//                            
//                            model.width = self.view.frame.size.width/2-8;
//                            model.height = (model.width/load.dataImage.size.width)*load.dataImage.size.height;
//                            BOOL a = [load.data writeToFile:path atomically:YES];
//                            NSLog(@"瀑布流图片存储结果a:%d", a);
//                            [self check2];
//                        }else{
//                            
//                        }
//                    }];
//                    [request release];
//                    model.height = 100.0f;
//                    model.width = self.view.frame.size.width/2-8;
//                    NSDictionary * tempDict = [MyControl imageSizeFrom:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]]];
//                    model.height = (model.width/[[tempDict objectForKey:@"width"] floatValue])*[[tempDict objectForKey:@"height"] floatValue];
//                }
//                
//                [model release];
//            }
//            self.lastImg_id = [self.dataArray[self.dataArray.count-1] img_id];
//            [qtmquitView reloadData];
//            [qtmquitView footerEndRefreshing];
//            LoadingSuccess;
        }else{
            NSLog(@"数据加载失败");
            LoadingFailed;
        }
        [bgTv footerEndRefreshing];
    }];
    [request release];
}
-(void)downloadImageWithArray2
{
    if (!self.tempArray.count) {
        return;
    }
    NSDictionary * dict = self.tempArray[0];
    PhotoModel * model = [[PhotoModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    [self.dataArray addObject:model];
    
    
    if (self.tempArray.count == 1) {
        page++;
//        self.lastImg_id = [self.dataArray[self.dataArray.count-1] img_id];
//        NSLog(@"lastImg_id:%@", self.lastImg_id);
    }
    if ([model.cmt isKindOfClass:[NSString class]] && model.cmt.length) {
        CGSize size = [model.cmt sizeWithFont:[UIFont systemFontOfSize:LabelFont] constrainedToSize:CGSizeMake(self.view.frame.size.width/2-4*3, 100) lineBreakMode:1];
        model.cmtWidth = size.width;
        model.cmtHeight = size.height+23;
        //                    NSLog(@"%@--%d", model.cmt, model.cmtHeight);
    }else{
        model.cmtHeight = 35;
    }
    
    //                NSLog(@"%@--%d", model.cmt, model.cmtHeight);
    
    NSString * path = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
    //                NSLog(@"%@", path);
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    if (image) {
        //比例调整 w=20 h=15    W=15  H=(W/w)*h
        model.width = self.view.frame.size.width/2-4-2;
        model.height = (model.width/image.size.width)*image.size.height;
        tempCount++;
        [self check2];
        [self.tempArray removeObjectAtIndex:0];
        [self downloadImageWithArray2];
    }else{
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                tempCount++;
                
                model.width = self.view.frame.size.width/2-4-2;
                model.height = (model.width/load.dataImage.size.width)*load.dataImage.size.height;
                BOOL a = [load.data writeToFile:path atomically:YES];
                NSLog(@"瀑布流图片存储结果a:%d", a);
                
                [self check2];
                
                [self.tempArray removeObjectAtIndex:0];
                [self downloadImageWithArray2];
            }else{
                
            }
        }];
        [request release];
    }
    [model release];
}
-(void)downloadImage2:(PhotoModel *)model
{
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]]];
    
    UIImage * tempImage = [UIImage imageWithData:data];
    
    tempCount++;
    
    model.width = self.view.frame.size.width/2-8;
    model.height = (model.width/tempImage.size.width)*tempImage.size.height;
    NSString * path = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
    BOOL a = [data writeToFile:path atomically:YES];
    NSLog(@"瀑布流图片存储结果a:%d", a);
    
    [self check2];
}
-(void)check2
{
    NSLog(@"***%d---%d--%d--%d", tempNum, tempCount, self.dataArray.count, count);
//    if (tempCount != tempNum) {
//        if(tempCount % 2 == 0 && tempCount != 0){
//            [self.tv reloadData];
//            [tv2 reloadData];
//        }
//        return;
//    }
//    LoadingSuccess
//    ;
    if(!tempCount){
        return;
    }
    //分配tv和tv2
    for (int i=count; i<count+1; i++) {
        PhotoModel * model = self.dataArray[i];
        if (height1>height2) {
            [self.dataArray2 addObject:self.dataArray[i]];
            height2 += model.height+model.cmtHeight+4*2;
            [tv2 reloadData];
        }else{
            [self.dataArray1 addObject:self.dataArray[i]];
            height1 += model.height+model.cmtHeight+4*2;
            [self.tv reloadData];
        }
    }
//    count += tempCount;
    count++;
    
    //            NSLog(@"%d", self.dataArray.count);
//    [self.tv reloadData];
//    [tv2 reloadData];
    
    if (height1>height2) {
        //                bgTv.contentSize = CGSizeMake(self.view.frame.size.width, tv.contentSize.height);
        tv2.contentSize = self.tv.contentSize;
    }else{
        //                bgTv.contentSize = CGSizeMake(self.view.frame.size.width, tv2.contentSize.height);
        self.tv.contentSize = tv2.contentSize;
    }
    
    //
    
}

#pragma mark - 代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tv) {
        tv2.contentOffset = self.tv.contentOffset;
    }else if(scrollView == tv2){
        self.tv.contentOffset = tv2.contentOffset;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tv) {
//        NSLog(@"%d", self.dataArray.count);
        return self.dataArray1.count;
    }else if(tableView == tv2){
        return self.dataArray2.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tv) {
        static NSString * cellID = @"ID";
        WaterFlowCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[WaterFlowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
            [cell adjustOriginalXWithIsLeft:YES];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        PhotoModel * model = self.dataArray1[indexPath.row];
        [cell configUI:model isLeft:YES];
        cell.selectionStyle = NO;
        cell.jumpToPicDetail = ^(void){
            PhotoModel * model = self.dataArray1[indexPath.row];
            //跳转到详情页，并传值
            PicDetailViewController * vc = [[PicDetailViewController alloc] init];
            vc.img_id = model.img_id;
            vc.usr_id = model.usr_id;
            [self presentViewController:vc animated:YES completion:nil];
            [vc release];
        };
        
        if (self.dataArray1.count+self.dataArray2.count == self.dataArray.count && indexPath.row == self.dataArray1.count-1) {
            [bgTv footerBeginRefreshing];
        }
        return cell;
    }else{
        static NSString * cellID2 = @"ID2";
        WaterFlowCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (!cell) {
            cell = [[[WaterFlowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2] autorelease];
            [cell adjustOriginalXWithIsLeft:NO];
        }
        cell.backgroundColor = [UIColor clearColor];
        PhotoModel * model = self.dataArray2[indexPath.row];
        [cell configUI:model isLeft:NO];
        cell.selectionStyle = NO;
        cell.jumpToPicDetail = ^(void){
            PhotoModel * model = self.dataArray2[indexPath.row];
            //跳转到详情页，并传值
            PicDetailViewController * vc = [[PicDetailViewController alloc] init];
            vc.img_id = model.img_id;
            vc.usr_id = model.usr_id;
            [self presentViewController:vc animated:YES completion:nil];
            [vc release];
        };
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tv) {
        
        PhotoModel * model = self.dataArray1[indexPath.row];
        return model.height+model.cmtHeight+4+4;
        
    }else if(tableView == tv2){
        PhotoModel * model = self.dataArray2[indexPath.row];
        return model.height+model.cmtHeight+4+4;
        
    }else{
        return 0;
    }
}
@end
