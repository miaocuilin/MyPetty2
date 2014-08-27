//
//  RandomViewController.m
//  MyPetty
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//
/*
#import "RandomViewController.h"
#import "TMQuiltView.h"
#import "TMPhotoQuiltViewCell.h"
#import "DetailViewController.h"
//#import "UMSocial.h"
#import "PhotoModel.h"
#import "UIImageView+WebCache.h"
@interface RandomViewController () <TMQuiltViewDataSource,TMQuiltViewDelegate,MONActivityIndicatorViewDelegate>
{
    TMQuiltView *qtmquitView;
    UIImageView * heart;
    MONActivityIndicatorView * indicatorView;
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
-(void)viewWillAppear:(BOOL)animated
{
    if ([[USER objectForKey:@"Menu"] intValue] == 1) {
        //头像，名称，性别，年龄
        [self refreshMenu];
        [USER setObject:@"0" forKey:@"Menu"];
    }
    self.sc.selectedSegmentIndex = 0;
//    self.navigationController.navigationBar.barTintColor = BGCOLOR;
    [qtmquitView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
//    self.view.backgroundColor = BGCOLOR2;
    [self createQtmquitView];
    [self loadData];
	
//	[qtmquitView reloadData];
    [self createHeaderView];
	[self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.0f];
}
-(UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index
{
    return BGCOLOR;
}
-(void)loadData
{
    //Loading界面开始启动
    indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 4;
    indicatorView.radius = 10;
    indicatorView.internalSpacing = 3;
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];
    [indicatorView startAnimating];
    
    [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", RANDOMAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"dataDict:%@", load.dataDict);
            [self.dataArray removeAllObjects];
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                
                [model release];
            }
            if (self.dataArray.count == 10) {
                self.lastImg_id = [self.dataArray[9] img_id];
            }
            [qtmquitView reloadData];
            [indicatorView stopAnimating];
        }else{
            [indicatorView stopAnimating];
            NSLog(@"数据加载失败");
        }
    }];
}
-(void)loadNextData
{
//    http://54.199.161.210/dc/index.php?r=image/randomApi&img_id=@&sig=@%SID=@
    if (self.dataArray.count % 10 != 0) {
        return;
    }
    NSString * str = [NSString stringWithFormat:@"img_id=%@dog&cat", self.lastImg_id];
    NSString * sig = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", RANDOMAPI2, self.lastImg_id, sig, [ControllerManager getSID]];
    NSLog(@"next-url:%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary: dict];
                [self.dataArray addObject:model];
                [model release];
            }
            self.lastImg_id = [self.dataArray[self.dataArray.count-1] img_id];
            [qtmquitView reloadData];
        }else{
            NSLog(@"数据加载失败");
        }
    }];
}

-(void)createQtmquitView
{
    qtmquitView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-[MyControl isIOS7])];
	qtmquitView.delegate = self;
	qtmquitView.dataSource = self;
//	qtmquitView.backgroundColor = [UIColor darkGrayColor];
    
	[self.view addSubview:qtmquitView];
    [self.view bringSubviewToFront:indicatorView];
}

//-(void)shouquan
//{
//    UMSocialSnsPlatform * snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity * response){
//        NSLog(@"response is %@", response);
//    });
//    
//    BOOL isOauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
//    if(!isOauth){
//        UINavigationController * oauthController = [[UMSocialControllerService defaultControllerService] getSocialOauthController:UMShareToSina];
//        [self presentViewController:oauthController animated:YES completion:nil];
//    }
//}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[qtmquitView addSubview:_refreshHeaderView];
    
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:qtmquitView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:qtmquitView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
	//    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(qtmquitView.contentSize.height, qtmquitView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
	{
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              qtmquitView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
	{
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         qtmquitView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [qtmquitView addSubview:_refreshFooterView];
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
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
	{
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:1];
        [self loadData];
        [qtmquitView reloadData];
    }else if(aRefreshPos == EGORefreshFooter)
	{
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.5];
        [self loadNextData];
    }
	
	// overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
-(void)refreshView
{
	NSLog(@"刷新完成");
    [self testFinishedLoadData];
	
}
//加载调用的方法
-(void)getNextPageView
{
//	for(int i = 0; i < 10; i++) {
//		[_images addObject:[NSString stringWithFormat:@"%d.jpeg", i % 10 + 1]];
//	}
//	[qtmquitView reloadData];
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


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView
{
    return self.dataArray.count;
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"] autorelease];
    }
    PhotoModel * model = self.dataArray[indexPath.row];
    
//    [cell configUI:model];
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
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }else{
        NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:randomFilePath]];
        if (image) {
            cell.photoView.image = image;
//            [self refreshView];
            [self setFooterView];
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
                        cell.photoView.image = load.dataImage;
                    }
                    //
                    [self setFooterView];
                }else{
                    //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    //            [alert show];
                    //            [alert release];
                }
            }];
        }
    }
    
//    NSString * url = [NSString stringWithFormat:@"%@%@", IMAGEURL, model.url];
//    [cell.photoView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"13-1.png"]];
    
//    cell.titleLabel.text = model.likes;
    
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
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }else{
        NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:randomFilePath]];
        if (image) {
            Height[indexPath.row] = image.size.height;
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
                        Height[indexPath.row] = load.dataImage.size.height;
                    }
                }else{
                    //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    //            [alert show];
                    //            [alert release];
                }
            }];
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
    
    if (Height[indexPath.row] == 0) {
        return 200;
    }else if(Height[indexPath.row] < 100){
        return 100;
    }else{
        return Height[indexPath.row]/6;
    }
    
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
    if (![ControllerManager getIsSuccess]) {
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height+[MyControl isIOS7]);
        }];
        return;
    }
    PhotoModel * model = self.dataArray[indexPath.row];
    //跳转到详情页，并传值
    DetailViewController * vc = [[DetailViewController alloc] init];
    vc.img_id = model.img_id;
    vc.usr_id = model.usr_id;
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
@end
*/