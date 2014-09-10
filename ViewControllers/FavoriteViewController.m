//
//  FavoriteViewController.m
//  MyPetty
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "FavoriteViewController.h"
#import "FavoriteCell.h"
#import "PhotoModel.h"
#import "DetailViewController.h"
#import "OtherHomeViewController.h"
#import "InfoModel.h"
#import "MJRefresh.h"

@interface FavoriteViewController () <MONActivityIndicatorViewDelegate>
{
    MONActivityIndicatorView *  indicatorView;
}
@end

@implementation FavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)alertNull
{
    
    UIAlertView *alertnull = [MyControl createAlertViewWithTitle:@"很遗憾！" Message:@"你的好友很懒，什么也没有做！" delegate:nil cancelTitle:nil otherTitles:@"确定"];
    
    [alertnull show];
}
-(void)viewWillAppear:(BOOL)animated
{
//    if([[USER objectForKey:@"favoriteNeedRefresh"] intValue] == 1 && [[USER objectForKey:@"isFavoriteLoaded"] intValue] == 1){
//        [self loadData];
//        [USER setObject:@"0" forKey:@"favoriteNeedRefresh"];
//    }
    if ([[USER objectForKey:@"favoriteRefresh"] intValue] == 1) {
        count = 0;
        [self loadData];
        [USER setObject:@"0" forKey:@"favoriteRefresh"];
    }
//    self.sc.selectedSegmentIndex = 1;
//    [self loadData];
    [tv reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [USER setObject:@"1" forKey:@"isFavoriteLoaded"];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.userDataArray = [NSMutableArray arrayWithCapacity:0];
    
//    [self loadData];
//    [self createTableView];
//    [self createHeaderView];
//	[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
//    self.menuBgView.frame = CGRectMake(50, self.view.frame.size.height-40, 220, 80);
}

-(UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index
{
    return BGCOLOR;
}
-(void)loadData
{
    StartLoading;
    
    //Loading界面开始启动
//    indicatorView = [[MONActivityIndicatorView alloc] init];
//    indicatorView.delegate = self;
//    indicatorView.numberOfCircles = 4;
//    indicatorView.radius = 10;
//    indicatorView.internalSpacing = 3;
//    indicatorView.center = CGPointMake(320/2, self.view.frame.size.height/2);
//    indicatorView.center = CGPointMake(320/2, (self.view.frame.size.height-[MyControl isIOS7])/2-[MyControl isIOS7]/2);
//    [self.view addSubview:indicatorView];
//    [indicatorView startAnimating];
    
//    NET = YES;
    NSString * url = [NSString stringWithFormat:@"%@%@", FAVORITEAPI, [ControllerManager getSID]];
    NSLog(@"关注页面的url :%@", url);
    
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            NSLog(@"favorite:%@", load.dataDict);
            [self.dataArray removeAllObjects];
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                if ([model.aid isEqualToString:[USER objectForKey:@"aid"]]) {
                    [model release];
                    continue;
                }
//                model.title = [USER objectForKey:@"name"];
                model.detail = [USER objectForKey:@"detailName"];
                
                [self.dataArray addObject:model];
                //获取用户信息，用于显示头像及用户名等
//                [self loadUserData:model.usr_id];
                uid[self.dataArray.count-1] = [model.usr_id intValue];
//                NSLog(@"uid:%d", uid[self.dataArray.count-1]);
                [model release];
            }
            NSLog(@"uid[count]:%d~~~count:%d~~~self.dataArray.count:%d", uid[count], count, self.dataArray.count);
            if (uid[count]) {
                [self.userDataArray removeAllObjects];
                [self loadUserData:[NSString stringWithFormat:@"%d", uid[count++]]];
            }else{
                LoadingSuccess;
//                NET = NO;
//                [self alertNull];
//                [indicatorView stopAnimating];
            }
            NSLog(@"%d", count);
//            [tv reloadData];
        }else{
            LoadingFailed;
//            [indicatorView stopAnimating];
            NSLog(@"数据加载失败。");
//            NET = NO;
        }
    }];
}
-(void)loadUserData:(NSString *)usr_id
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", usr_id]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERINFOAPI, usr_id, sig, [ControllerManager getSID]];
    NSLog(@"UserInfoAPI:%@", url);
    
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%d-用户信息：%@", count, load.dataDict);
            InfoModel * model = [[InfoModel alloc] init];
            NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectForKey:@"user"];
            [model setValuesForKeysWithDictionary:dict];
            [self.userDataArray addObject:model];
            [model release];
//            self.name = [dict objectForKey:@"name"];
//            self.headImageURL = [dict objectForKey:@"tx"];
            NSLog(@"%d ~~ %d", self.dataArray.count, self.userDataArray.count);
            if (self.userDataArray.count == self.dataArray.count) {
                LoadingSuccess;
                
                [tv headerEndRefreshing];
                [tv footerEndRefreshing];

                [indicatorView stopAnimating];
                [tv reloadData];
//                count = 0;
//                for(int i=0;i<self.dataArray.count;i++){
//                    NSLog(@"%@", [self.dataArray[i] usr_id]);
//                    NSLog(@"%@", [self.userDataArray[i] usr_id]);
//                    NSLog(@"uid:%d\n------------", uid[i]);
//                }
                for(int i=0;i<self.dataArray.count;i++){
                    NSLog(@"%d", uid[i]);
                }
                if(count <= 2){
                    [self createTableView];
                    [self.view bringSubviewToFront:indicatorView];
                }
                self.view.userInteractionEnabled = YES;
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }else{
                if (count == 2 && self.dataArray.count>2) {
                    [self createTableView];
                    [self.view bringSubviewToFront:indicatorView];
                    self.view.userInteractionEnabled = NO;
                }
                NSLog(@"%d", count);
                [self loadUserData:[NSString stringWithFormat:@"%d", uid[count++]]];
            }
//            NSLog(@"------------%d-------dataArray.count:%d------", self.userDataArray.count, self.dataArray.count);
            
        }else{
            LoadingFailed;
            self.view.userInteractionEnabled = YES;
            [indicatorView stopAnimating];
            NSLog(@"用户信息数据加载失败");
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

#pragma mark -创建tableView
-(void)createTableView
{
//    self.automaticallyAdjustsScrollViewInsets = NO;
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    [tv addHeaderWithTarget:self action:@selector(refreshHeader)];
    [tv addFooterWithTarget:self action:@selector(refreshFooter)];
//    [tv headerBeginRefreshing];
    [tv release];
    
//    [self.view bringSubviewToFront:self.menuBgBtn];
//    [self.view bringSubviewToFront:self.menuBgView];
}
#pragma mark - 刷新头尾
- (void)refreshHeader
{
    count = 0;
    [self loadData];
    self.view.userInteractionEnabled = NO;
}
-(void)refreshFooter
{
    [self loadMorePhotos];
}
-(void)loadMorePhotos
{
    [indicatorView startAnimating];
    self.view.userInteractionEnabled = NO;
    
    NSString * str = [NSString stringWithFormat:@"img_id=%@dog&cat", [self.dataArray[self.dataArray.count-1] img_id]];
    NSString * sig = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", FAVORITEAPI2, [self.dataArray[self.dataArray.count-1] img_id], sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            NSLog(@"more:%@", load.dataDict);
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            if(array.count == 0){
                [tv footerEndRefreshing];
                [indicatorView stopAnimating];
                self.view.userInteractionEnabled = YES;
                return;
            }
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                if ([model.usr_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
                    [model release];
                    continue;
                }
                //                model.title = [USER objectForKey:@"name"];
                model.detail = [USER objectForKey:@"detailName"];
                
                [self.dataArray addObject:model];
                //获取用户信息，用于显示头像及用户名等
                //                [self loadUserData:model.usr_id];
                uid[self.dataArray.count-1] = [model.usr_id intValue];
                //                NSLog(@"uid:%d", uid[self.dataArray.count-1]);
                [model release];
            }
            NSLog(@"uid[count]:%d~~~count:%d~~~self.dataArray.count:%d", uid[count], count, self.dataArray.count);
            if (uid[count]) {
                [self loadUserData:[NSString stringWithFormat:@"%d", uid[count++]]];
            }else{
                NET = NO;
                //                [self alertNull];
                [indicatorView stopAnimating];
            }
            NSLog(@"%d", count);
            //            [tv reloadData];
        }else{
            [indicatorView stopAnimating];
            NSLog(@"数据加载失败。");
            NET = NO;
        }
    }];
}

#pragma mark -tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    FavoriteCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[[FavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    
    PhotoModel * model = self.dataArray[indexPath.row];
    [cell configUI:model];
    
    NSLog(@"%d", self.userDataArray.count);
    InfoModel * infoModel = self.userDataArray[indexPath.row];
    [cell configUsrInfo:infoModel];
    
    //本地目录，用于存放favorite下载的原图
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSLog(@"docDir:%@", docDir);
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }else{
        NSString * filePath2 = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_small.png", model.url]];
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath2]];
        if (image) {
            cell.bigImageView.image = image;
            cell.bigImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            cell.bigImageView.center = CGPointMake(320/2, 300/2);
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
                        cell.bigImageView.center = CGPointMake(320/2, 300/2);
                    }
                }else{
                    //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    //            [alert show];
                    //            [alert release];
                }
            }];
        }
    }
    
    UIButton * button = [MyControl createButtonWithFrame:CGRectMake(0, 0, 130, 50) ImageName:@"" Target:self Action:@selector(otherButtonClick:) Title:nil];
//    button.backgroundColor = [UIColor redColor];
    button.alpha = 0.5;
    button.tag = 100+indexPath.row;
    [cell addSubview:button];
    
    return cell;
}

#pragma mark -取图片的一部分
/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}


#pragma mark -左上角点击事件
-(void)otherButtonClick:(UIButton *)button
{
    if ([[self.userDataArray[button.tag-100] usr_id] isEqualToString:[USER objectForKey:@"usr_id"]]) {
        //进入个人主页
        UINavigationController * nc = [ControllerManager shareManagerMyPet];
        [self presentViewController:nc animated:YES completion:nil];
    }else{
        OtherHomeViewController * other = [[OtherHomeViewController alloc] init];
        other.usr_id = [self.userDataArray[button.tag-100] usr_id];
        NSLog(@"other.usr_id:%@", other.usr_id);
        [self presentViewController:other animated:YES completion:nil];
        [other release];
    }
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoModel * model = self.dataArray[indexPath.row];
    //跳转到详情页，并传值
    DetailViewController * vc = [[DetailViewController alloc] init];
//    vc.comment = model.comment;
//    vc.num = model.likes;
//    vc.imageURL = model.url;
//    vc.name = [USER objectForKey:@"name"];
//    vc.cateName = [USER objectForKey:@"detailName"];
    vc.img_id = model.img_id;
    vc.usr_id = model.usr_id;
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
-(void)createHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[tv addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}
-(void)testFinishedLoadData{
	
    [self finishReloadingData];
    [self setFooterView];
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tv];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:tv];
        [self setFooterView];
    }
}
-(void)setFooterView{
    CGFloat height = tv.frame.size.height;
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              tv.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         tv.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [tv addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
	{
        [_refreshFooterView refreshLastUpdatedDate];
    }
}
-(void)removeFooterView
{
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}
//===============
//刷新delegate
#pragma mark -
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
	{
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.5];
        [self loadData];
        [tv reloadData];
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.5];
//        [self loadNextData];
    }
	
	// overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
	NSLog(@"刷新完成");
    [self testFinishedLoadData];
	
}
-(void)getNextPageView
{
    [tv reloadData];
    [self removeFooterView];
    [self testFinishedLoadData];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView)
	{
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView)
	{
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date];
}
*/
@end
