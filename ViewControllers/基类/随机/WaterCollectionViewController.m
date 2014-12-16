//
//  WaterCollectionViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/14.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "WaterCollectionViewController.h"
#import "PhotoModel.h"
#import "ColllectionViewCell.h"
#import <QuartzCore/QuartzCore.h>


@interface WaterCollectionViewController ()

@end

@implementation WaterCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.images = [NSMutableArray arrayWithCapacity:0];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    [self.collectionView registerClass:[ColllectionViewCell class] forCellWithReuseIdentifier:@"CELL_ID"];
    self.collectionView.allowsSelection = YES;
    self.collectionView.frame = self.view.bounds;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [((WaterFlowLayout*)self.collectionView.collectionViewLayout) setFlowdatasource:self];
    [((WaterFlowLayout*)self.collectionView.collectionViewLayout) setFlowdelegate:self];
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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
            [self.collectionView reloadData];
            //            self.lastImg_id = [self.dataArray[self.dataArray.count-1] img_id];
//            [collection reloadData];
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

#pragma mark -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColllectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_ID" forIndexPath:indexPath];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, [self.dataArray[indexPath.row] url]]]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate methods
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d selected", indexPath.item);
}
#pragma mark-  UICollecitonViewDelegateWaterFlowLayout
- (CGFloat)flowLayout:(WaterFlowLayout *)flowView heightForRowAtIndex:(int)index
{
    return 100;
}


#pragma mark- UICollectionViewDatasourceFlowLayout
- (NSInteger)numberOfColumnsInFlowLayout:(WaterFlowLayout*)flowlayout
{
    return 2;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    
    if (bottomEdge >=  floor(scrollView.contentSize.height) )
    {
        //load more images
//        self.currentPage ++;
        [self.collectionView reloadData];
    }
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

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
//    return 0;
//}
//
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
//    return 0;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell
//    
//    return cell;
//}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
