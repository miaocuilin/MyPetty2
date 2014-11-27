//
//  QuickGiftViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-9-18.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "QuickGiftViewController.h"
#import "GiftShopModel.h"
#import "QuickGiftCellectionViewCell.h"
#import "GiftShopViewController.h"
@interface QuickGiftViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,retain)NSMutableArray *giftDataArray;
@property (nonatomic,retain)NSMutableArray *tempDataArray;

@end

@implementation QuickGiftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tempDataArray = [NSMutableArray arrayWithCapacity:0];
    [self backgroundView];
    [self addGiftShopData];
    [self createCollectionView];
    [self loadBagData];
}
#pragma mark - 背包数据
- (void)loadBagData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERGOODSLISTAPI, [USER objectForKey:@"usr_id"], sig, [ControllerManager getSID]];
    NSLog(@"背包url:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        NSLog(@"背包物品数据：%@",load.dataDict);
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                [self.giftDataArray removeAllObjects];
                [self.giftDataArray addObjectsFromArray:self.tempDataArray];
                self.keyArray = [[load.dataDict objectForKey:@"data"] allKeys];
                self.shopGiftCount = self.keyArray.count;
                self.valueArray = [[load.dataDict objectForKey:@"data"] allValues];
                NSArray *array = [NSArray arrayWithArray:self.giftDataArray];
                for (GiftShopModel *model in array) {
                    for (int i = 0; i<self.keyArray.count; i++) {
                        if ([model.no isEqualToString:self.keyArray[i]]) {
                            [self.giftDataArray insertObject:model atIndex:i];
                        }
                    }
                }
                [bodyView reloadData];
            }
            
        }else{
        }
    }];
    [request release];
}
#pragma mark - 购买礼物
- (void)buyGiftItemsAPI:(NSInteger)tag
{
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"item_id=1102&num=1dog&cat"]];
    NSString *buyItemsString = [NSString stringWithFormat:@"%@1102&num=1&sig=%@&SID=%@",BUYSHOPGIFTAPI,sig,[ControllerManager getSID]];
    //    NSLog(@"购买商品api:%@",buyItemsString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:buyItemsString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        //        NSLog(@"购买商品结果：%@",load.dataDict);
        if (isFinish) {
            GiftShopModel *model = self.giftDataArray[tag];
            [USER setObject:[NSString stringWithFormat:@"%@",[[load.dataDict objectForKey:@"data"] objectForKey:@"user_gold"]] forKey:@"gold"];
            [ControllerManager HUDText:[NSString stringWithFormat:@"恭喜您，购买 %@ 成功！",model.name] showView:self.view yOffset:-60];
        }
        [self sendGiftData:1];
    }];
    [request release];
}
#pragma mark - 赠送礼物请求
- (void)sendGiftData:(NSInteger)isBuy
{
    //固定礼物1102
    NSString *item = @"1102";
    //NSString *sendSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&is_buy=%d&item_id=%@dog&cat",[USER objectForKey:@"aid"],isBuy,item]];
    //NSString *sendString = [NSString stringWithFormat:@"%@%@&is_buy=%d&item_id=%@&sig=%@&SID=%@",SENDSHAKEGIFT,[USER objectForKey:@"aid"],isBuy,item,sendSig,[ControllerManager getSID]];
    NSString *sendSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&item_id=%@dog&cat",[USER objectForKey:@"aid"],item]];
    NSString *sendString = [NSString stringWithFormat:@"%@%@&item_id=%@&sig=%@&SID=%@",SENDSHAKEGIFT,[USER objectForKey:@"aid"],item,sendSig,[ControllerManager getSID]];
    NSLog(@"赠送url:%@",sendString);
    httpDownloadBlock *request  = [[httpDownloadBlock alloc] initWithUrlStr:sendString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        NSLog(@"赠送数据：%@",load.dataDict);
        int newexp = [[[load.dataDict objectForKey:@"data"] objectForKey:@"exp"] intValue];
        int exp = [[USER objectForKey:@"exp"] intValue];
        [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"exp"] forKey:@"exp"];
        if (exp != newexp && (newexp - exp)>0) {
            int index = newexp - exp;
//            [ControllerManager HUDImageIcon:@"Star.png" showView:self.view yOffset:0 Number:index];
        }
       //重新请求背包数据
//        if (!isBuy) {
            [self loadBagData];
//        }
        
    }];
    [request release];
    
}
#pragma mark - 创建界面
- (void)createCollectionView
{
    UIView *totalView = [MyControl createViewWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-212, 300, 425)];
    totalView.layer.cornerRadius = 10;
    totalView.layer.masksToBounds = YES;
    totalView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:totalView];
    
    UIImageView *titleView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 300, 40) ImageName:@"title_bg.png"];
    [totalView addSubview:titleView];
    UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:16 Text:@"给猫君送个礼物吧"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:titleLabel];
    UIImageView *closeImageView = [MyControl createImageViewWithFrame:CGRectMake(260, 10, 20, 20) ImageName:@"30-1.png"];
    [totalView addSubview:closeImageView];
    UIButton *closeButton = [MyControl createButtonWithFrame:CGRectMake(252.5, 2.5, 35, 35) ImageName:nil Target:self Action:@selector(colseGiftAction) Title:nil];
    closeButton.showsTouchWhenHighlighted = YES;
    [totalView addSubview:closeButton];
    

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
    bodyView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, 300, 385-60) collectionViewLayout:layout];
    [bodyView registerClass:[QuickGiftCellectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    bodyView.showsVerticalScrollIndicator = NO;
    bodyView.showsHorizontalScrollIndicator = NO;
    bodyView.pagingEnabled = YES;
    bodyView.delegate = self;
    bodyView.dataSource = self;
    bodyView.backgroundColor = [UIColor whiteColor];
    [totalView addSubview:bodyView];
    
    
    
    giftPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 310+45, bodyView.frame.size.width, 20)];
    giftPageControl.backgroundColor = [UIColor clearColor];
    giftPageControl.userInteractionEnabled = NO;
//    giftPageControl.numberOfPages = (int)floorf(self.giftDataArray.count/9);
    giftPageControl.numberOfPages =ceilf(self.giftDataArray.count/9);
    giftPageControl.currentPageIndicatorTintColor = BGCOLOR;
    giftPageControl.pageIndicatorTintColor = [UIColor grayColor];
    [totalView addSubview:giftPageControl];
    [giftPageControl release];
    UILabel *giftLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 - 110, 335+45, 215, 40) Font:16 Text:@"去商城"];
    giftLabel.textAlignment = NSTextAlignmentCenter;
    giftLabel.backgroundColor = BGCOLOR;
    giftLabel.layer.cornerRadius = 5;
    giftLabel.layer.masksToBounds = YES;
    [totalView addSubview:giftLabel];
    
    UIButton *giftButton = [MyControl createButtonWithFrame:giftLabel.frame ImageName:nil Target:self Action:@selector(GoShoppingAction) Title:nil];
    giftButton.showsTouchWhenHighlighted = YES;
    [totalView addSubview:giftButton];
    
}
- (void)GoShoppingAction
{
    NSLog(@"去商城");
    GiftShopViewController *vc = [[GiftShopViewController alloc] init];
    vc.isQuick = YES;
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (void)addGiftShopData
{
    self.giftDataArray = [NSMutableArray arrayWithCapacity:0];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"shopGift" ofType:@"plist"];
    NSMutableDictionary *DictData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *level0 = [[DictData objectForKey:@"good"] objectForKey:@"level0"];
    NSArray *level1 =[[DictData objectForKey:@"good"] objectForKey:@"level1"];
    NSArray *level2 =[[DictData objectForKey:@"good"] objectForKey:@"level2"];
    NSArray *level3 =[[DictData objectForKey:@"good"] objectForKey:@"level3"];
    [self addData:level0];
    [self addData:level1];
    [self addData:level2];
    [self addData:level3];
    
    NSArray *level4 =[[DictData objectForKey:@"bad"] objectForKey:@"level0"];
    NSArray *level5 =[[DictData objectForKey:@"bad"] objectForKey:@"level1"];
    NSArray *level6 =[[DictData objectForKey:@"bad"] objectForKey:@"level2"];
    [self addData:level4];
    [self addData:level5];
    [self addData:level6];
    [self.tempDataArray addObjectsFromArray:self.giftDataArray];
    
}
- (void)addData:(NSArray *)array
{
    for (NSDictionary *dict in array) {
        GiftShopModel *model = [[GiftShopModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.giftDataArray addObject:model];
        [model release];
    }
}
#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    giftPageControl.currentPage = index;
}
#pragma mark - CollectionViewDataSourceAndDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.giftDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QuickGiftCellectionViewCell *cell = (QuickGiftCellectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    GiftShopModel *model = self.giftDataArray[indexPath.item];
    if (self.shopGiftCount >indexPath.item) {
        [cell configUI2:model itemNum:self.valueArray[indexPath.item]];
    }else{
        [cell configUI:model];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.item:%d",indexPath.item);
    GiftShopModel *model = self.giftDataArray[indexPath.item];
    if (self.shopGiftCount > indexPath.item) {
        [self sendGiftData:0];
    }else{
        [self buyGiftItemsAPI:indexPath.item];
    }
}
#pragma mark - UIColllectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 90);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (void)colseGiftAction
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (void)backgroundView
{
    UIView *bgView = [MyControl createViewWithFrame:self.view.frame];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
