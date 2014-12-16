//
//  CollectionWaterFlowViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/14.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "CollectionWaterFlowViewController.h"
#import "CollectionWaterFlowCell.h"
#import "PhotoModel.h"
@interface CollectionWaterFlowViewController ()

@end

@implementation CollectionWaterFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self createCollectionView];
    [self loadData];
}
-(void)loadData
{
    //    if (isLoaded) {
    //        self.reloadRandom();
    //    }
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", RECOMMENDAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            //只包含img_id和图片的url
            //            NSLog(@"宇宙广场数据:%@", load.dataDict);
//            for (int i=0; i<self.dataArray.count; i++) {
//                Height[i] = 0;
//            }
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
            
//            self.lastImg_id = [self.dataArray[self.dataArray.count-1] img_id];
            [collection reloadData];
//            [qtmquitView headerEndRefreshing];
            //            [indicatorView stopAnimating];
            
            //            LoadingSuccess;
        }else{
            LOADFAILED;
            //            StartLoading;
            //            LoadingFailed;
            //            [indicatorView stopAnimating];
//            [qtmquitView headerEndRefreshing];
            NSLog(@"数据加载失败");
        }
    }];
    [request release];
}
-(void)createCollectionView
{
//    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
//    flow.itemSize = CGSizeMake(276/2, 180);
    
    collection = [[PSCollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-96/2) collectionViewLayout:flow];
    collection.delegate = self;
    collection.collectionViewDataSource = self;
    collection.collectionViewDelegate = self;
    collection.backgroundColor = [UIColor clearColor];
    collection.autoresizingMask = ~UIViewAutoresizingNone;
//    [collection registerClass:[ExchangeCollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    collection.numColsPortrait = 2;
    [self.view addSubview:collection];
    
//    [flow release];

}
#pragma mark - 
-(Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index
{
    return [CollectionWaterFlowCell class];
}
-(NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView
{
    return self.dataArray.count;
}
-(PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index
{
    PSCollectionViewCell * cell = [collectionView dequeueReusableViewForClass:[PSCollectionViewCell class]];
    
    return cell;
}
-(void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    NSLog(@"%d", index);
}
-(CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    return 100.0f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
