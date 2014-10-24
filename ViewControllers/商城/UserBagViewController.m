//
//  UserBagViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-9-5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "UserBagViewController.h"
#import "UserBagCollectionViewCell.h"
#import "PresentDetailViewController.h"
@interface UserBagViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,retain)UIImageView * bgImageView;

@end

@implementation UserBagViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    self.goodsNumArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createBg];
    [self loadData];
    [self createCollectionView];
    [self createFakeNavigation];

}
-(void)loadData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERGOODSLISTAPI, [USER objectForKey:@"usr_id"], sig, [ControllerManager getSID]];
//    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"背包物品:%@", load.dataDict);
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = [load.dataDict objectForKey:@"data"];
                [self.goodsArray removeAllObjects];
                [self.goodsNumArray removeAllObjects];
                
                for (NSString * itemId in [dict allKeys]) {
                    [self.goodsArray addObject:itemId];
                }
                //排序
                for (int i=0; i<self.goodsArray.count; i++) {
                    for (int j=0; j<self.goodsArray.count-i-1; j++) {
                        if ([self.goodsArray[j] intValue] > [self.goodsArray[j+1] intValue]) {
                            NSString * str1 = [NSString stringWithFormat:@"%@", self.goodsArray[j]];
                            NSString * str2 = [NSString stringWithFormat:@"%@", self.goodsArray[j+1]];
                            self.goodsArray[j] = str2;
                            self.goodsArray[j+1] = str1;
                        }
                    }
                }
                //获取对应数量
                for (int i=0; i<self.goodsArray.count; i++) {
                    self.goodsNumArray[i] = [dict objectForKey:self.goodsArray[i]];
                }
                for(int i=0;i<self.goodsArray.count;i++){
                    if ([self.goodsNumArray[i] intValue] == 0) {
                        [self.goodsArray removeObjectAtIndex:i];
                        [self.goodsNumArray removeObjectAtIndex:i];
                        i--;
                    }
                }
                [self.collectionView reloadData];
            }
        }else{
        
        }
    }];
    [request release];
}
- (void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 64);
    layout.itemSize = CGSizeMake(85, 100);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UserBagCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goodsArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"cell";
    UserBagCollectionViewCell *cell = (UserBagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    [cell configUIWithItemId:self.goodsArray[indexPath.row] Num:self.goodsNumArray[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.item:%d",indexPath.item);
//    PresentDetailViewController *presentDetailVC = [[PresentDetailViewController alloc] init];
//    [self presentViewController:presentDetailVC animated:YES completion:^{
//        [presentDetailVC release];
//    }];
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 15, 0, 15);
//    return UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
}
-(void)createBg
{
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:self.bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
//    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"%@", data);
    UIImage * image = [UIImage imageWithData:data];
    self.bgImageView.image = image;
    
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:tempView];
}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    //    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"我的物品栏"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIView * line0 = [MyControl createViewWithFrame:CGRectMake(0, 63, 320, 1)];
    line0.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.1];
    [navView addSubview:line0];
}
- (void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
