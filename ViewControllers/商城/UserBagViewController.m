//
//  UserBagViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-9-5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "UserBagViewController.h"
#import "UserBagCollectionViewCell.h"
@interface UserBagViewController ()


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
                    if ([itemId intValue]%10 >4 || [itemId intValue]>=2200) {
                        continue;
                    }
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
//                [self.collectionView reloadData];
                [self createScrollView];
            }
        }else{
        
        }
    }];
    [request release];
}
//- (void)createCollectionView
//{
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 64);
//    layout.itemSize = CGSizeMake(85, 100);
//    
//    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
//    [self.view addSubview:self.collectionView];
//    self.collectionView.backgroundColor = [UIColor clearColor];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    [self.collectionView registerClass:[UserBagCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//    
//}
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return self.goodsArray.count;
//}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifer = @"cell";
//    UserBagCollectionViewCell *cell = (UserBagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
//    [cell configUIWithItemId:self.goodsArray[indexPath.row] Num:self.goodsNumArray[indexPath.row]];
//    return cell;
//}
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"indexPath.item:%d",indexPath.item);
//    PresentDetailViewController *presentDetailVC = [[PresentDetailViewController alloc] init];
//    [self presentViewController:presentDetailVC animated:YES completion:^{
//        [presentDetailVC release];
//    }];
    
//}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(10, 15, 0, 15);
////    return UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
//}
-(void)createBg
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.png"];
    [self.view addSubview:imageView];
//    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
//    [self.view addSubview:self.bgImageView];
//    //    self.bgImageView.backgroundColor = [UIColor redColor];
////    NSString * docDir = DOCDIR;
//    NSString * filePath = BLURBG;
////    NSLog(@"%@", filePath);
//    NSData * data = [NSData dataWithContentsOfFile:filePath];
//    //    NSLog(@"%@", data);
//    UIImage * image = [UIImage imageWithData:data];
//    self.bgImageView.image = image;
//    
//    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
//    [self.view addSubview:tempView];
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
#pragma mark - createUI
-(void)createScrollView
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    //    sv.contentSize = CGSizeMake(320, 64+35+15+(30/3)*100);
    [self.view addSubview:sv];
    
    [self.view bringSubviewToFront:navView];
    
    int index = self.goodsArray.count;
    if (index%2) {
        sv.contentSize = CGSizeMake(self.view.frame.size.width, 15+(index/2+1)*160);
    }else{
        sv.contentSize = CGSizeMake(self.view.frame.size.width, 15+(index/2)*160);
    }
//    NSLog(@"index:%d",index);
    
    /***************************/
    for(int i=0; i<index; i+=2){
        //白色背景
        UIImageView * giftBgImageView = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-500/2)/2.0, (i/2)*160+10, 222/2, 190/2) ImageName:@"giftAlert_giftBg.png"];
        [sv addSubview:giftBgImageView];
        
        UIImageView * giftBgImageView2 = [MyControl createImageViewWithFrame:CGRectMake(giftBgImageView.frame.origin.x+274/2, (i/2)*160+10, 222/2, 190/2) ImageName:@"giftAlert_giftBg.png"];
        [sv addSubview:giftBgImageView2];
        //        if ((i+2)%4 == 0) {
        //            giftBgImageView.frame = CGRectMake(25+i/4*300, 10+310/2, 222/2, 190/2);
        //            giftBgImageView2.frame = CGRectMake(324/2+i/4*300, 10+310/2, 222/2, 190/2);
        //        }
        
        //礼物图片
        UIImageView * giftImageView = [MyControl createImageViewWithFrame:CGRectMake((111-98)/2.0, (95-93)/2.0, 98, 83) ImageName:@""];
        [giftBgImageView addSubview:giftImageView];
        
        UIImageView * giftImageView2 = [MyControl createImageViewWithFrame:CGRectMake((111-98)/2.0, (95-93)/2.0, 98, 83) ImageName:@""];
        [giftBgImageView2 addSubview:giftImageView2];
        
        
        //木板
        UIImageView * wood = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-546/2)/2.0, giftBgImageView.frame.origin.y+190/2, 546/2, 17/2.0) ImageName:@"giftAlert_wood.png"];
        [sv addSubview:wood];
        
        //
        UIImageView * hang_tag = [MyControl createImageViewWithFrame:CGRectMake(wood.frame.origin.x+4, wood.frame.origin.y-1, 246/2, 106/2) ImageName:@""];
        [sv addSubview:hang_tag];
        
        UIImageView * hang_tag2 = [MyControl createImageViewWithFrame:CGRectMake(wood.frame.origin.x+wood.frame.size.width-4-246/2, wood.frame.origin.y-1, 246/2, 106/2) ImageName:@""];
        [sv addSubview:hang_tag2];
        
        //礼物名称
        UILabel * productLabel = [MyControl createLabelWithFrame:CGRectMake(0, 18, 80, 15) Font:12 Text:nil];
        productLabel.font = [UIFont boldSystemFontOfSize:12];
        productLabel.textColor = [ControllerManager colorWithHexString:@"5F5E5E"];
        productLabel.textAlignment = NSTextAlignmentCenter;
        [hang_tag addSubview:productLabel];
        
        UILabel * productLabel2 = [MyControl createLabelWithFrame:CGRectMake(0, 18, 80, 15) Font:12 Text:nil];
        productLabel2.font = [UIFont boldSystemFontOfSize:12];
        productLabel2.textColor = [ControllerManager colorWithHexString:@"5F5E5E"];
        productLabel2.textAlignment = NSTextAlignmentCenter;
        [hang_tag2 addSubview:productLabel2];
        
        //礼物数
        UIImageView * giftImage = [MyControl createImageViewWithFrame:CGRectMake(productLabel.frame.origin.x+20, productLabel.frame.origin.y+productLabel.frame.size.height+3, 12, 14) ImageName:@"detail_gift.png"];
        [hang_tag addSubview:giftImage];
        
        UILabel * giftNum = [MyControl createLabelWithFrame:CGRectMake(giftImage.frame.origin.x+15, giftImage.frame.origin.y, 80, 15) Font:13 Text:[NSString stringWithFormat:@" × %@", self.goodsNumArray[i]]];
        giftNum.textColor = ORANGE;
        [hang_tag addSubview:giftNum];
        
        if (i+1<=self.goodsArray.count-1) {
            UIImageView * giftImage2 = [MyControl createImageViewWithFrame:CGRectMake(productLabel2.frame.origin.x+20, productLabel2.frame.origin.y+productLabel2.frame.size.height+3, 12, 14) ImageName:@"detail_gift.png"];
            [hang_tag2 addSubview:giftImage2];
            
            UILabel * giftNum2 = [MyControl createLabelWithFrame:CGRectMake(giftImage2.frame.origin.x+15, giftImage2.frame.origin.y, 80, 15) Font:13 Text:[NSString stringWithFormat:@" × %@", self.goodsNumArray[i+1]]];
            giftNum2.textColor = ORANGE;
            [hang_tag2 addSubview:giftNum2];
        }
                
        
        //人气
        UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(90, 20, 30, 15) Font:12 Text:@"人气"];
        rq.font = [UIFont boldSystemFontOfSize:12];
        [hang_tag addSubview:rq];
        
        UILabel * rq2 = [MyControl createLabelWithFrame:CGRectMake(90, 20, 30, 15) Font:12 Text:@"人气"];
        rq2.font = [UIFont boldSystemFontOfSize:12];
        [hang_tag2 addSubview:rq2];
        
        //人气值
        UILabel * rqz = [MyControl createLabelWithFrame:CGRectMake(80, 35, 42, 15) Font:12 Text:@"+100"];
        rqz.textAlignment = NSTextAlignmentCenter;
        rqz.font = [UIFont boldSystemFontOfSize:12];
        [hang_tag addSubview:rqz];
        
        UILabel * rqz2 = [MyControl createLabelWithFrame:CGRectMake(80, 35, 42, 15) Font:12 Text:@"+100"];
        rqz2.textAlignment = NSTextAlignmentCenter;
        rqz2.font = [UIFont boldSystemFontOfSize:12];
        [hang_tag2 addSubview:rqz2];
        
        
        
        
        //
//        CGRect rect = giftBgImageView.frame;
//        CGRect rect2 = giftBgImageView2.frame;
        
        /*******************i*********************/
//        NSLog(@"%@", self.goodsArray[i]);
        if ([self.goodsArray[i] intValue]>2000) {
            hang_tag.image = [UIImage imageNamed:@"giftAlert_badBg.png"];
        }else{
            hang_tag.image = [UIImage imageNamed:@"giftAlert_goodBg.png"];
        }
        giftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.goodsArray[i]]];
        NSDictionary * dict = [ControllerManager returnGiftDictWithItemId:self.goodsArray[i]];
        productLabel.text = [dict objectForKey:@"name"];
        rqz.text = [dict objectForKey:@"add_rq"];
        
        /*******************i+1*********************/
        if (i+1 == self.goodsArray.count) {
            //超出范围
            if ([self.goodsArray[i] intValue]>2000) {
                hang_tag2.image = [UIImage imageNamed:@"giftAlert_badBg.png"];
            }else{
                hang_tag2.image = [UIImage imageNamed:@"giftAlert_goodBg.png"];
            }
            rq2.text = @"";
            rqz2.text = @"";
            return;
        }
        if ([self.goodsArray[i+1] intValue]>2000) {
            hang_tag2.image = [UIImage imageNamed:@"giftAlert_badBg.png"];
        }else{
            hang_tag2.image = [UIImage imageNamed:@"giftAlert_goodBg.png"];
        }
        giftImageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.goodsArray[i+1]]];
        NSDictionary * dict2 = [ControllerManager returnGiftDictWithItemId:self.goodsArray[i+1]];
        productLabel2.text = [dict2 objectForKey:@"name"];
        rqz2.text = [dict2 objectForKey:@"add_rq"];
    }
    
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
