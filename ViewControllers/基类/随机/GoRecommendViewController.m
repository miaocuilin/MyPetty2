//
//  GoRecommendViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/27.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "GoRecommendViewController.h"
#import "HyperlinksButton.h"
#import "GoRecommendCollectionCell.h"

static NSString *cellID = @"GoRecommendCollectionCell.h";

@interface GoRecommendViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIView *navView;
    NSInteger count;
    UILabel *leftCount;
}
@end

@implementation GoRecommendViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ControllerManager hideTabBar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ControllerManager showTabBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    count = 3;
    
    [self createBgView];
    [self createFakeNavigation];
    
    [self createBottom];
}

-(void)createBgView
{
    UIImageView * blueBg = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:blueBg];
}

-(void)createFakeNavigation
{
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
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake((self.view.frame.size.width-100)/2.0, 32, 100, 20) Font:17 Text:@"美瞳全开"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIButton * help = [MyControl createButtonWithFrame:CGRectMake(320-25-15, 64-27-7, 25, 25) ImageName:@"bt_help.png" Target:self Action:@selector(helpClick) Title:nil];
    help.showsTouchWhenHighlighted = YES;
    [navView addSubview:help];
}

-(void)helpClick
{
    
}
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
-(void)createBottom
{
    NSString *str = @"获得更多推荐票数";
    CGSize size = [str boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    HyperlinksButton *hyper = [[HyperlinksButton alloc] initWithFrame:CGRectMake((WIDTH-size.width)/2.0, HEIGHT-30, size.width, size.height)];
    [hyper setTitle:str forState:UIControlStateNormal];
    [hyper setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    hyper.titleLabel.font = [UIFont systemFontOfSize:14];
    [hyper setColor:[UIColor grayColor]];
    [hyper addTarget:self action:@selector(getMoreTickets) forControlEvents:UIControlEventTouchUpInside];
    hyper.showsTouchWhenHighlighted = YES;
    [self.view addSubview:hyper];
    
    
    leftCount = [MyControl createLabelWithFrame:CGRectMake(hyper.frame.origin.x+hyper.frame.size.width-30, hyper.frame.origin.y-10-20, 30, 20) Font:19 Text:@"x 3"];
    leftCount.textAlignment = NSTextAlignmentRight;
    leftCount.textColor = [UIColor lightGrayColor];
    [self.view addSubview:leftCount];
    
    //172  150
    CGFloat h = size.width*0.8*150/172.0;
    UIButton *heartBtn = [MyControl createButtonWithFrame:CGRectMake(hyper.frame.origin.x, hyper.frame.origin.y-h-10, size.width*0.8, h) ImageName:@"bt_heart.png" Target:self Action:@selector(heartBtnClick) Title:nil];
    [self.view addSubview:heartBtn];
    
    
    [self createCollectionWithHeight:heartBtn.frame.origin.y-64];
}
-(void)getMoreTickets
{
    
}
-(void)heartBtnClick
{
    if (count == 0) {
        Alert_2ButtonView2 *alert = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alert.type = 6;
        [alert makeUI];
        [self.view addSubview:alert];
        alert.exchangeRecommend = ^(){
            NSLog(@"兑换推荐票");
        };
    }else{
        count--;
        leftCount.text = [NSString stringWithFormat:@"x %d", count];
    }
}

#pragma mark -
-(void)createCollectionWithHeight:(CGFloat)height
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(WIDTH, height-5-20);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+5, WIDTH, height-5-20) collectionViewLayout:layout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor clearColor];
    collection.pagingEnabled = YES;
    collection.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:collection];
    
    [collection registerClass:[GoRecommendCollectionCell class] forCellWithReuseIdentifier:cellID];
}

#pragma mark -
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoRecommendCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor purpleColor];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
