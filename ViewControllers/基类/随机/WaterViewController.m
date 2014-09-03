//
//  WaterViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-9-2.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "WaterViewController.h"
#import "MyCollectionViewLayout.h"
#import "MyCollectionViewCell.h"
#import "PhotoModel.h"
#import "ColllectionViewCell.h"
@interface WaterViewController ()<WaterFLayoutDelegate>
@property(nonatomic)CGFloat itemWidth;
@property (nonatomic)int index;
@end

@implementation WaterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];

    [self loadData];
   
}
- (void)viewDidAppear:(BOOL)animated
{
//    [self createCollectionView];
}

- (void)createCollectionView
{
    self.itemWidth = 150.0;

//    MyCollectionViewLayout *layout = [[MyCollectionViewLayout alloc] init];
    UICollectionViewFlowLayout *grid = [[UICollectionViewFlowLayout alloc] init];
    grid.itemSize = CGSizeMake(150.0, 0.0);
    grid.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    grid.headerReferenceSize = CGSizeMake(320, 200);
    
    MyCollectionViewLayout *mylayout = [[MyCollectionViewLayout alloc] init];
    mylayout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:mylayout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.scrollEnabled=YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, self.collectionView.contentSize.height-20, 320,20 )];
    [refresh addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    refresh.backgroundColor = [UIColor redColor];
    [self.collectionView addSubview:refresh];
    [self.view addSubview:self.collectionView];

}

- (void)refreshAction:(UIRefreshControl *)sender
{
    [self loadData];
    [sender endRefreshing];
}
#pragma -mark UICollectionView delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    float height = 0;
    if (Height[indexPath.row] == 0) {
        height = 100;
    }else if(Height[indexPath.row] < 100){
        height = 100;
    }else if(Height[indexPath.row] < 300){
        height = Height[indexPath.row]/1.3;
    }else{
        if (Height[indexPath.row]/4 < 100) {
           height = 100;
        }
        height = Height[indexPath.row]/4;
    }
    return CGSizeMake(150, height);
}
//定义每个UICollectionView 的 margin

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    NSLog(@"indexPath=%d",indexPath.row);
}


//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionViews cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionViews dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    //加载图片

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
            cell.imageView.image = image;
            Height[indexPath.item] = image.size.height;

        }else{
            cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"20-1" ofType:@"png"]];
            [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    //本地目录，用于存放favorite下载的原图
                    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    if (!docDir) {
                        NSLog(@"Documents 目录未找到");
                    }else{
                        NSString * randomFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
                        //将下载的图片存放到本地
                        Height[indexPath.item] = load.dataImage.size.height;
                        [load.data writeToFile:randomFilePath atomically:YES];
                        cell.imageView.image = load.dataImage;
                        [self.collectionView reloadData];
                    }
                }
            }];
        }
    }

    return cell;
    
}



-(void)loadData
{
    StartLoading;
    
    NSLog(@"randomAPI:%@",[NSString stringWithFormat:@"%@%@", RANDOMAPI, [ControllerManager getSID]]);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", RANDOMAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
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
            self.lastImg_id = [self.dataArray[self.dataArray.count-1] img_id];
            [self createCollectionView];
            LoadingSuccess;
        }else{
            LoadingFailed;
            NSLog(@"数据加载失败");
        }
    }];
    [request release];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    
    if (bottomEdge >=  floor(scrollView.contentSize.height) )
    {
        //load more images
        self.collectionView.userInteractionEnabled = NO;
        [self loadNextData];
    }
}
-(void)loadNextData
{
    //http://54.199.161.210/dc/index.php?r=image/randomApi&img_id=@&sig=@%SID=@
    if (self.dataArray.count % 10 != 0) {
        return;
    }
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
                [model release];
            }
            self.lastImg_id = [self.dataArray[self.dataArray.count-1] img_id];
            [self.collectionView reloadData];
            self.collectionView.userInteractionEnabled = YES;

        }else{
            NSLog(@"数据加载失败");
        }
    }];
    [request release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
