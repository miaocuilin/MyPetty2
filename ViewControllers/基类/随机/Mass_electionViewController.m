//
//  Mass_electionViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/26.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "Mass_electionViewController.h"
#import "PicturePlayView.h"
#import "MassCollectionCell.h"
#import "MassHeaderView.h"
#import "GoRecommendViewController.h"

static NSString * cellID = @"Mass_electionCell";
static NSString * headerViewID = @"Mass_electionHeaderView";
@interface Mass_electionViewController () <PictureplayDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)PicturePlayView *playView;
//@property(nonatomic,strong)NSMutableArray *
@end

@implementation Mass_electionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createImages];
    [self createMenuView];
    [self createCollection];
    
    [self loadData];
}
#pragma mark -
-(void)loadData
{
    LOADING;
    NSString *url = [NSString stringWithFormat:@"%@%@", MASSELECTIONAPI, [ControllerManager getSID]];
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
}


#pragma mark -
-(void)createImages
{
    NSArray *array = @[@"1484_1427345737@101349@_1500&2000.png", @"1535_1427341719@81528@_960&1280.png", @"938_1427340479@77458@_768&1024.png"];
    _playView = [[PicturePlayView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/3.0) UrlArray:array OtherView:YES isFromBanner:NO];
    self.playView.autoresizesSubviews = NO;
    self.playView.delegate = self;
    [self.view addSubview:self.playView];
}
-(void)createMenuView
{
    UIView *view = [MyControl createViewWithFrame:CGRectMake(0, self.playView.frame.size.height, WIDTH, 50)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:view];
    
//    128/64
    CGFloat btnW = 64.0;
    CGFloat btnH = 32.0;
    UIButton *joinBtn = [MyControl createButtonWithFrame:CGRectMake(WIDTH-10-btnW, (view.frame.size.height-btnH)/2.0, btnW, btnH) ImageName:@"bt_participate.png" Target:self Action:@selector(joinClick) Title:nil];
    [view addSubview:joinBtn];
    
    UIButton *recomBtn = [MyControl createButtonWithFrame:CGRectMake(WIDTH-10*2-btnW*2, (view.frame.size.height-btnH)/2.0, btnW, btnH) ImageName:@"bt_recommend.png" Target:self Action:@selector(recomClick) Title:nil];
    [view addSubview:recomBtn];
    
    UILabel *countLabel = [MyControl createLabelWithFrame:CGRectMake(10, 0, recomBtn.frame.origin.x-10, view.frame.size.height) Font:13 Text:nil];
    countLabel.textColor = [UIColor blackColor];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"您今天还剩3个推荐名额"];
    [attStr setAttributes:@{NSForegroundColorAttributeName:ORANGE, NSFontAttributeName:[UIFont systemFontOfSize:25]} range:NSMakeRange(5, 1)];
    countLabel.attributedText = attStr;
    [view addSubview:countLabel];
}
-(void)joinClick
{
    
}
-(void)recomClick
{
    GoRecommendViewController *recommend = [[GoRecommendViewController alloc] init];
    [self.navigationController pushViewController:recommend animated:YES];
}

#pragma mark -
-(void)createCollection
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat w = (WIDTH-10-10-5-5)/3.0;
//    CGFloat w = WIDTH/3.0;
    layout.itemSize = CGSizeMake(w, w);
//    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    //这里的sectionInset设置的是整段的边框缩进
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 22, 10);
    //【注意】这里需要先设置header的高度，否则默认为0显示不出
    layout.headerReferenceSize = CGSizeMake(WIDTH, 110);
    
    CGFloat oriY = self.playView.frame.size.height+50;
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, oriY, WIDTH, HEIGHT-oriY-25) collectionViewLayout:layout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collection];
    

    [collection registerClass:[MassCollectionCell class] forCellWithReuseIdentifier:cellID];
    [collection registerClass:[MassHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID];
}
#pragma mark - 

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 18;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MassCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(kind == UICollectionElementKindSectionHeader){
        MassHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewID forIndexPath:indexPath];
        header.headClickBlock = ^(NSInteger i){
            //点击了第i个头像
            NSLog(@"%d", i);
        };
        return header;
    }
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.row:%d", indexPath.row);
}

#pragma mark -delegate
-(void)selectedIndex:(NSInteger)index
{
    NSLog(@"index:%d", index);
}

@end
