//
//  RecommendViewController.m
//  MyPetty
//
//  Created by Aidi on 14-7-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "RecommendViewController.h"

@interface RecommendViewController ()

@end

@implementation RecommendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self createQtmquitView];
    
}
-(void)loadData
{
    StartLoading;
    
    NSString * url = [NSString stringWithFormat:@"%@%@", RANDOMAPI, [ControllerManager getSID]];
//    NSLog(@"recommendAPI:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            //只包含img_id和图片的url
            //NSLog(@"萌宠推荐数据:%@", load.dataDict);
            [self.dataArray removeAllObjects];
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                
                [model release];
            }
            
            self.lastImg_id = [self.dataArray[self.dataArray.count-1] img_id];
            [qtmquitView reloadData];
            [qtmquitView headerEndRefreshing];
            
            LoadingSuccess;
        }else{
            LoadingFailed;
            [qtmquitView headerEndRefreshing];
            NSLog(@"数据加载失败");
        }
    }];
    [request release];
}

-(void)loadNextData
{
    if (self.dataArray.count % 10 != 0) {
        [qtmquitView footerEndRefreshing];
        return;
    }
    NSString * str = [NSString stringWithFormat:@"img_id=%@dog&cat", self.lastImg_id];
    NSString * sig = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", RECOMMENDAPI2, self.lastImg_id, sig, [ControllerManager getSID]];
//    NSLog(@"next-url:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
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
            [qtmquitView footerEndRefreshing];
        }else{
            NSLog(@"数据加载失败");
        }
    }];
    [request release];
}

#pragma mark - 创建quitView
-(void)createQtmquitView
{
    qtmquitView = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-[MyControl isIOS7])];
	qtmquitView.delegate = self;
	qtmquitView.dataSource = self;
    
	[self.view addSubview:qtmquitView];
    
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [qtmquitView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [qtmquitView addFooterWithTarget:self action:@selector(footerRereshing)];
}
- (void)headerRereshing
{
    [self loadData];
}
- (void)footerRereshing
{
    [self loadNextData];
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
    //图片存放到本地，从本地取
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }else{
        NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
        //        NSLog(@"randomFilePath:%@", randomFilePath);
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:randomFilePath]];
        if (image) {
            cell.photoView.image = image;
        }else{
            cell.photoView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"20-1" ofType:@"png"]];
            
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
                        [qtmquitView reloadData];
                    }
                }else{
                }
            }];
        }
    }
    
    if (indexPath.row == self.dataArray.count-1) {
        [quiltView footerBeginRefreshing];
    }
    
    return cell;
}


#pragma mark - TMQuiltViewDelegate

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    return 2;
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
        //        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:randomFilePath]];
        UIImage * image = [UIImage imageWithContentsOfFile:randomFilePath];
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
                        
                        //每次新下载完一张图片后都刷新瀑布流
                        //                        if (indexPath.row == self.dataArray.count-1) {
                        //                            [qtmquitView reloadData];
                        //                        }
                        
                    }
                }else{
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
    //    return 100;
    if (Height[indexPath.row] == 0) {
        return 100;
    }else if(Height[indexPath.row] < 100){
        return 100;
    }else if(Height[indexPath.row] < 300){
        return Height[indexPath.row]/1.3;
    }else{
        if (Height[indexPath.row]/4 < 100) {
            return 100;
        }
        return Height[indexPath.row]/4;
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
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
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
