//
//  PetMain_Photo_ViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetMain_Photo_ViewController.h"
#import "PhotoModel.h"
#import "PetMain_Photo_CollectionViewCell.h"


@interface PetMain_Photo_ViewController ()

@end

@implementation PetMain_Photo_ViewController

-(void)dealloc
{
    [super dealloc];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createFakeNavigation];
    [self createCollectionView];
    [self loadPhotoData];
}
#pragma mark - 国王照片数据
-(void)loadPhotoData
{
    LOADING;
    NSString *petImagesSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.model.aid]];
    NSString *petImageAPIString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",PETIMAGESAPI,self.model.aid,petImagesSig,[ControllerManager getSID]];
    NSLog(@" 国王照片数据API:%@",petImageAPIString);
    
    __block PetMain_Photo_ViewController * blockSelf = self;
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:petImageAPIString Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            ENDLOADING;
            //            NSLog(@"国王照片数据:%@", load.dataDict);
            [blockSelf.dataArray removeAllObjects];
            
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for(int i=0;i<array.count;i++){
                NSDictionary * dict = array[i];
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                
                //model.headImage = tempImage;
                model.title = [USER objectForKey:@"name"];
                model.detail = [USER objectForKey:@"detailName"];
                [blockSelf.dataArray addObject:model];
                if (i == array.count-1) {
                    blockSelf.lastImg_id = model.img_id;
                }
                [model release];
            }
            
            [blockSelf->collection reloadData];
            [blockSelf->collection headerEndRefreshing];
        }else{
            [blockSelf->collection headerEndRefreshing];
            LOADFAILED;
        }
    }];
    [request release];
}
- (void)loadMorePhoto
{
    NSString *petImagesSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&img_id=%@dog&cat",self.model.aid,self.lastImg_id]];
    NSString *petImageAPIString = [NSString stringWithFormat:@"%@%@&img_id=%@&sig=%@&SID=%@",PETIMAGESAPI,self.model.aid,self.lastImg_id,petImagesSig,[ControllerManager getSID]];
    //    NSLog(@" 更多国王照片数据API:%@",petImageAPIString);
    __block PetMain_Photo_ViewController * blockSelf = self;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:petImageAPIString Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            //            NSLog(@"更多国王照片数据:%@", load.dataDict);
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for(int i=0;i<array.count;i++){
                NSDictionary * dict = array[i];
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                
                //model.headImage = tempImage;
                model.title = [USER objectForKey:@"name"];
                model.detail = [USER objectForKey:@"detailName"];
                [blockSelf.dataArray addObject:model];
                if (i == array.count-1) {
                    blockSelf.lastImg_id = model.img_id;
                }
                [model release];
            }
//            isPhotoDownload = YES;
            [blockSelf->collection reloadData];
            [blockSelf->collection footerEndRefreshing];
            //            self.view.userInteractionEnabled = YES;
//            NET = NO;
        }else{
            [blockSelf->collection headerEndRefreshing];
            //            self.view.userInteractionEnabled = YES;
//            NSLog(@"数据加载失败。");
//            NET = NO;
        }
    }];
    [request release];
}
#pragma mark -

-(void)createFakeNavigation
{
    UIImageView * blurImage = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:blurImage];
    
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 22, 60, 40) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"照片"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}
- (void)backBtnClick
{
    NSLog(@"dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
-(void)createCollectionView
{
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
    float spe = self.view.frame.size.width/3;
    flow.itemSize = CGSizeMake(spe, spe);
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 0;
//    flow.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    
    collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) collectionViewLayout:flow];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor whiteColor];
    [collection registerClass:[PetMain_Photo_CollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    [self.view addSubview:collection];
    [collection addHeaderWithTarget:self action:@selector(loadPhotoData)];
    [collection addFooterWithTarget:self action:@selector(loadMorePhoto)];
    
    [flow release];
    [collection release];
}
#pragma mark - collectionDataSource
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 3;
//}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//        NSLog(@"%d", self.dataArray.count);
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"collection";
    PetMain_Photo_CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[[PetMain_Photo_CollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3.0, self.view.frame.size.width/3.0)] autorelease];
    }
    PhotoModel * model = self.dataArray[indexPath.row];
    [cell modifyUIWithUrl:model.url];
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
#pragma mark - collectionDelegateFlowLayout
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
////    float a = (self.view.frame.size.width/2.0-276/2)/2.0;
//    return UIEdgeInsetsMake(2,2,2,2);
//}
#pragma mark - collectionDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row);
    FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
    vc.img_id = [self.dataArray[indexPath.row] img_id];
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    [vc release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
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
