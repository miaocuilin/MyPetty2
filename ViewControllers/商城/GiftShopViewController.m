//
//  GiftShopViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "GiftShopViewController.h"
#import "UserInfoViewController.h"
#import "UserBagViewController.h"
#import "GiftShopModel.h"
@interface GiftShopViewController ()
@property (nonatomic,retain)NSMutableArray *goodGiftDataArray;
@property (nonatomic,retain)NSMutableArray *badGiftDataArray;
@property (nonatomic,retain)NSMutableArray *giftDataArray;
@end

@implementation GiftShopViewController

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
    self.cateArray = [NSMutableArray arrayWithObjects:@"爱心礼物", @"捣乱礼物", nil];
    self.cateArray2 = [NSMutableArray arrayWithObjects:@"喵喵专用", @"汪汪专用", nil];
    self.orderArray = [NSMutableArray arrayWithObjects:@"由高到低", @"由低到高", nil];
    self.totalGoodsDataArray = [NSMutableArray arrayWithCapacity:0];
    self.priceHighToLowArray = [NSMutableArray arrayWithCapacity:0];
    self.priceLotToHighArray = [NSMutableArray arrayWithCapacity:0];
    
    [self addGiftShopData];
    [self createBg];
    [self createFakeNavigation];
    [self createHeader];
    [self createScrollView2];
    [self createScrollView];
    [self createBottom];
    
    [self createAlphaBtn];
    [self loadData];
//    [self buyGiftItemsAPI];
}
- (void)viewWillAppear:(BOOL)animated
{
    if ([USER objectForKey:@"noViewGift"] == nil || [[USER objectForKey:@"noViewGift"] length] == 0 || [[USER objectForKey:@"noViewGift"] intValue] == 0) {
        greenBall.hidden = YES;
    }else{
        giftNum.text = [NSString stringWithFormat:@"%@",[USER objectForKey:@"noViewGift"]];
        greenBall.hidden = NO;
    }
}

#pragma mark -
- (void)buyGiftItemsAPI:(NSInteger)tag
{
    GiftShopModel *model = self.giftDataArray[tag];
    NSString *item = model.no;
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"item_id=%@&num=1dog&cat",item]];
    NSString *buyItemsString = [NSString stringWithFormat:@"%@%@&num=1&sig=%@&SID=%@",BUYSHOPGIFTAPI,item,sig,[ControllerManager getSID]];
//    NSLog(@"购买商品api:%@",buyItemsString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:buyItemsString Block:^(BOOL isFinish, httpDownloadBlock *load) {
//        NSLog(@"购买商品结果：%@",load.dataDict);
        if (isFinish) {
            [USER setObject:[NSString stringWithFormat:@"%@",[[load.dataDict objectForKey:@"data"] objectForKey:@"user_gold"]] forKey:@"gold"];
            BottomGold.text = [USER objectForKey:@"gold"];
            int noViewGiftNumber = [[USER objectForKey:@"noViewGift"] intValue];
            [USER setObject:[NSString stringWithFormat:@"%d",noViewGiftNumber+1] forKey:@"noViewGift"];
            giftNum.text = [NSString stringWithFormat:@"%@",[USER objectForKey:@"noViewGift"]];
            if ([giftNum.text isEqualToString:@""]) {
                greenBall.hidden = YES;
            }else{
                greenBall.hidden = NO;
            }
            [ControllerManager HUDText:[NSString stringWithFormat:@"恭喜您，购买 %@ 成功！",model.name] showView:self.view yOffset:0];
        }
    }];
    [request release];
}
- (void)addGiftShopData
{
    self.goodGiftDataArray =[NSMutableArray arrayWithCapacity:0];
    self.badGiftDataArray = [NSMutableArray arrayWithCapacity:0];
    self.giftDataArray = [NSMutableArray arrayWithCapacity:0];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"shopGift" ofType:@"plist"];
    NSMutableDictionary *DictData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *level0 = [[DictData objectForKey:@"good"] objectForKey:@"level0"];
    NSArray *level1 =[[DictData objectForKey:@"good"] objectForKey:@"level1"];
    NSArray *level2 =[[DictData objectForKey:@"good"] objectForKey:@"level2"];
    NSArray *level3 =[[DictData objectForKey:@"good"] objectForKey:@"level3"];
    [self addData:level0 isGood:YES];
    [self addData:level1 isGood:YES];
    [self addData:level2 isGood:YES];
    [self addData:level3 isGood:YES];
    
    NSArray *level4 =[[DictData objectForKey:@"bad"] objectForKey:@"level0"];
    NSArray *level5 =[[DictData objectForKey:@"bad"] objectForKey:@"level1"];
    NSArray *level6 =[[DictData objectForKey:@"bad"] objectForKey:@"level2"];
    [self addData:level4 isGood:NO];
    [self addData:level5 isGood:NO];
    [self addData:level6 isGood:NO];
    
//    NSLog(@"data:%@",DictData);
    [self.totalGoodsDataArray addObjectsFromArray:self.goodGiftDataArray];
    [self.totalGoodsDataArray addObjectsFromArray:self.badGiftDataArray];
//    self.totalGoodsDataArray = [NSMutableArray arrayWithArray:[ControllerManager returnAllGiftsArray]];
    self.showArray = self.totalGoodsDataArray;
    
    NSMutableArray * temp1 = [NSMutableArray arrayWithArray:self.totalGoodsDataArray];
    NSMutableArray * temp2 = [NSMutableArray arrayWithArray:self.totalGoodsDataArray];
    //从高到低
    for (int i=0; i<temp1.count; i++) {
        for (int j=0; j<temp1.count-1-i; j++) {
            if ([[temp1[j] price] intValue]<[[temp1[j+1] price] intValue]) {
                GiftShopModel * model1 = temp1[j];
                GiftShopModel * model2 = temp1[j+1];
                temp1[j] = model2;
                temp1[j+1] = model1;
            }
        }
    }
    self.priceHighToLowArray = [NSMutableArray arrayWithArray:temp1];
    //从低到高
    for (int i=0; i<temp2.count; i++) {
        for (int j=0; j<temp2.count-1-i; j++) {
            if ([[temp2[j] price] intValue]>[[temp2[j+1] price] intValue]) {
                GiftShopModel * model1 = temp2[j];
                GiftShopModel * model2 = temp2[j+1];
                temp2[j] = model2;
                temp2[j+1] = model1;
            }
        }
    }
    self.priceLotToHighArray = [NSMutableArray arrayWithArray:temp2];
}
- (void)addData:(NSArray *)array isGood:(BOOL)good
{
    for (NSDictionary *dict in array) {
        GiftShopModel *model = [[GiftShopModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        if (good) {
            [self.goodGiftDataArray addObject:model];
        }else{
            [self.badGiftDataArray addObject:model];
        }
        [self.giftDataArray addObject:model];
        [model release];
    }
}
- (void)loadData
{
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"code=dog&cat"]];
    NSString *itemsString = [NSString stringWithFormat:@"%@&sig=%@&SID=%@",SHOPITEMSAPI,sig,[ControllerManager getSID]];
    NSLog(@"itemsString:%@",itemsString);
}
/****************/
-(void)createAlphaBtn
{
    alphaBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(hideSideMenu) Title:nil];
    alphaBtn.backgroundColor = [UIColor blackColor];
    alphaBtn.alpha = 0;
    alphaBtn.hidden = YES;
    [self.view addSubview:alphaBtn];
}
-(void)hideSideMenu
{
    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
    [menu hideMenuAnimated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        alphaBtn.alpha = 0;
    } completion:^(BOOL finished) {
        alphaBtn.hidden = YES;
        backBtn.selected = NO;
    }];
}

-(void)createBg
{
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:self.bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
    NSLog(@"%@", filePath);
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
    
    backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick:) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    //    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:backBtn];
    
    UIButton * titleBtn = [MyControl createButtonWithFrame:CGRectMake(60, 64-20-12-5, 200, 30) ImageName:@"" Target:self Action:@selector(titleBtnClick:) Title:@"虚拟礼物"];
    [titleBtn setTitle:@"现实礼物" forState:UIControlStateSelected];
    titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:titleBtn];
    
//    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"虚拟礼物"];
//    titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//    [navView addSubview:titleLabel];
    
    UIImageView * giftImageView = [MyControl createImageViewWithFrame:CGRectMake(320-31, 30, 51*0.4, 55*0.4) ImageName:@"tool4.png"];
    [navView addSubview:giftImageView];
    
    greenBall = [MyControl createImageViewWithFrame:CGRectMake(13, -5, 15, 15) ImageName:@"greenBall.png"];
    [giftImageView addSubview:greenBall];
    
    giftNum = [MyControl createLabelWithFrame:CGRectMake(-5, 0, 25, 15) Font:9 Text:nil];
//    giftNum.text = [NSString stringWithFormat:@"%@",[USER objectForKey:@"noViewGift"]];
    giftNum.font = [UIFont boldSystemFontOfSize:9];
    giftNum.textAlignment = NSTextAlignmentCenter;
    [greenBall addSubview:giftNum];
    
    UIButton * giftBagBtn = [MyControl createButtonWithFrame:CGRectMake(320-41, 24, 51*0.6, 55*0.6) ImageName:@"" Target:self Action:@selector(giftBagBtnClick) Title:nil];
//    giftBagBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    giftBagBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:giftBagBtn];
    
    UIView * line0 = [MyControl createViewWithFrame:CGRectMake(0, 63, 320, 1)];
    line0.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.1];
    [navView addSubview:line0];
}
-(void)titleBtnClick:(UIButton *)btn
{
    return;
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        sv2.hidden = NO;
        sv.hidden = YES;
        sv2.contentOffset = CGPointMake(0, 0);
    }else{
        sv.hidden = NO;
        sv2.hidden = YES;
        sv.contentOffset = CGPointMake(0, 0);
    }
}
-(void)backBtnClick:(UIButton *)button
{
    if (self.isQuick) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [USER setObject:@"" forKey:@"noViewGift"];
        button.selected = !button.selected;
        JDSideMenu * menu = [ControllerManager shareJDSideMenu];
        if (button.selected) {
            [menu showMenuAnimated:YES];
            alphaBtn.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                alphaBtn.alpha = 0.5;
            }];
        }else{
            [menu hideMenuAnimated:YES];
            [UIView animateWithDuration:0.25 animations:^{
                alphaBtn.alpha = 0;
            } completion:^(BOOL finished) {
                alphaBtn.hidden = YES;
            }];
        }
    }
}
-(void)giftBagBtnClick
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        return;
    }
    NSLog(@"跳转到我的背包");
//    UserInfoViewController * vc = [[UserInfoViewController alloc] init];
//    vc.offset = 320*3;
//    [self presentViewController:vc animated:YES completion:nil];
//    [vc release];
    [USER setObject:@"" forKey:@"noViewGift"];
    UserBagViewController *userBagVC = [[UserBagViewController alloc] init];
    [self presentViewController:userBagVC animated:YES completion:^{
        [userBagVC release];
    }];
}
-(void)createHeader
{
    headerView = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 35)];
    [self.view addSubview:headerView];
    
    UIView * headerBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 35)];
    headerBgView.backgroundColor = BGCOLOR;
    headerBgView.alpha = 0.85;
    [headerView addSubview:headerBgView];
    
    cateBtn = [MyControl createButtonWithFrame:CGRectMake(35, 5, 90, 25) ImageName:@"" Target:self Action:@selector(cateBtnClick) Title:@"爱心礼物"];
    cateBtn.layer.cornerRadius = 5;
    cateBtn.layer.masksToBounds = YES;
    cateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    cateBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:168/255.0 blue:146/255.0 alpha:0.6];
    [headerView addSubview:cateBtn];
    //小三角
    UIImageView * triangle1 = [MyControl createImageViewWithFrame:CGRectMake(76, 9, 10, 8) ImageName:@"5-2.png"];
    [cateBtn addSubview:triangle1];
    
    orderBtn = [MyControl createButtonWithFrame:CGRectMake(196, 5, 90, 25) ImageName:@"" Target:self Action:@selector(orderBtnClick) Title:@"价格"];
    orderBtn.layer.cornerRadius = 5;
    orderBtn.layer.masksToBounds = YES;
    orderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    orderBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:168/255.0 blue:146/255.0 alpha:0.6];
    [headerView addSubview:orderBtn];
    
    //小三角
    UIImageView * triangle2 = [MyControl createImageViewWithFrame:CGRectMake(76, 9, 10, 8) ImageName:@"5-2.png"];
    [orderBtn addSubview:triangle2];
}

-(void)cateBtnClick{
    NSLog(@"cate");
    if (dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc] showDropDown:cateBtn :&f :self.cateArray];
        [dropDown setDefaultCellType];
        dropDown.delegate = self;
        headerView.frame = CGRectMake(0, 64, 320, 35+200);
        isCateShow = YES;
    }else{
        [dropDown hideDropDown:cateBtn];
        isCateShow = NO;
        [self rel];
    }
}
-(void)orderBtnClick{
    NSLog(@"order");
    if (dropDown2 == nil) {
        CGFloat f = 120;
        dropDown2 = [[NIDropDown alloc] showDropDown:orderBtn :&f :self.orderArray];
        [dropDown2 setDefaultCellType];
        dropDown2.delegate = self;
        if (!isCateShow) {
            headerView.frame = CGRectMake(0, 64, 320, 35+120);
        }
        isOrderShow = YES;
    }else{
        isOrderShow = NO;
        [dropDown2 hideDropDown:orderBtn];
        [self rel2];
    }

}

-(void)niDropDownDelegateMethod:(NIDropDown *)sender
{
    if (sender == dropDown) {
        isCateShow = NO;
        [self rel];
    }else{
        isOrderShow = NO;
        [self rel2];
    }
    
}
-(void)didSelected:(NIDropDown *)sender Line:(int)Line Words:(NSString *)Words
{
    NSLog(@"%d--%@", Line, Words);
    if (sender == dropDown) {
//        if (Line == 0) {
            [sv removeFromSuperview];
            self.showArray = self.totalGoodsDataArray;
//        }
        [self createScrollView];
    }else{
        [sv removeFromSuperview];
        if (Line == 0) {
            self.showArray = self.priceHighToLowArray;
        }else{
            self.showArray = self.priceLotToHighArray;
        }
        [self createScrollView];
    }
//    int temp = 0;
//    for (int i=1; i< self.goodGiftDataArray.count; i++) {
//        GiftShopModel *model = self.goodGiftDataArray[i];
//        temp = [model.price intValue];
//        if (model) {
//            <#statements#>
//        }
//    }
//    [self.goodGiftDataArray exchangeObjectAtIndex:<#(NSUInteger)#> withObjectAtIndex:<#(NSUInteger)#>]
}
-(void)rel
{
    if (isOrderShow) {
        headerView.frame = CGRectMake(0, 64, 320, 35+120);
    }else{
        headerView.frame = CGRectMake(0, 64, 320, 35);
    }
    [dropDown release];
    dropDown = nil;
}
-(void)rel2
{
    if (isCateShow) {
        headerView.frame = CGRectMake(0, 64, 320, 35+200);
    }else{
        headerView.frame = CGRectMake(0, 64, 320, 35);
    }
    [dropDown2 release];
    dropDown2 = nil;
}

#pragma mark - createUI
-(void)createScrollView
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-40)];
    //    sv.contentSize = CGSizeMake(320, 64+35+15+(30/3)*100);
    [self.view addSubview:sv];
    
    [self.view bringSubviewToFront:navView];
    [self.view bringSubviewToFront:headerView];
    int index = self.showArray.count;
    if (index%3) {
        sv.contentSize = CGSizeMake(320, 64+35+15+(index/3+1)*100);
    }else{
        sv.contentSize = CGSizeMake(320, 64+35+15+(index/3)*100);
    }
    NSLog(@"index:%d",index);
    
    /***************************/
    for(int i=0;i<index;i++){
        CGRect rect = CGRectMake(20+i%3*100, 64+35+15+i/3*100, 85, 90);
        UIImageView * imageView = [MyControl createImageViewWithFrame:rect ImageName:@"product_bg.png"];
        if ([[self.showArray[i] no] intValue]>=2000) {
            imageView.image = [UIImage imageNamed:@"trick_bg.png"];
        }
        [sv addSubview:imageView];
        
//        UIImageView * triangle = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 32, 32) ImageName:@"gift_triangle.png"];
//        [imageView addSubview:triangle];
        
        UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(-3, 2, 20, 9) Font:7 Text:@"人气"];
        rq.font = [UIFont boldSystemFontOfSize:8];
        rq.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
        [imageView addSubview:rq];
        
        UILabel * rqNum = [MyControl createLabelWithFrame:CGRectMake(0, 10, 25, 8) Font:9 Text:@"+150"];
        rqNum.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
        rqNum.textAlignment = NSTextAlignmentCenter;
        //            rqNum.backgroundColor = [UIColor redColor];
        [imageView addSubview:rqNum];
        
        UILabel * giftName = [MyControl createLabelWithFrame:CGRectMake(0, 5, 85, 15) Font:11 Text:@"汪汪项圈"];
        giftName.textColor = [UIColor grayColor];
        giftName.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:giftName];
        
        UIImageView * giftPic = [MyControl createImageViewWithFrame:CGRectMake(5, 20, 75, 50) ImageName:[NSString stringWithFormat:@"bother%d_2.png", arc4random()%6+1]];
        [imageView addSubview:giftPic];
        
        UIImageView * gift = [MyControl createImageViewWithFrame:CGRectMake(20, 90-14-5, 15, 15) ImageName:@"gold.png"];
        [imageView addSubview:gift];
        
        UILabel * giftPrice = [MyControl createLabelWithFrame:CGRectMake(42, 90-19, 40, 15) Font:13 Text:[NSString stringWithFormat:@"%d", i*50+50]];
        giftPrice.textColor = BGCOLOR;
        [imageView addSubview:giftPrice];
        
        //新品，推荐，热卖标注
        UIImageView * label = [MyControl createImageViewWithFrame:CGRectMake(62, -6, 73/2, 46/2) ImageName:@"right_corner.png"];
        [imageView addSubview:label];
        label.hidden = YES;
        
        UILabel * labelLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 73/2, 46/2) Font:12 Text:nil];
        labelLabel.textAlignment = NSTextAlignmentCenter;
        [label addSubview:labelLabel];
        
        if (i == 0) {
            label.hidden = NO;
            labelLabel.text = @"新品";
        }else if (i == 2) {
            label.hidden = NO;
            labelLabel.text = @"热卖";
        }else if (i == 3) {
            label.hidden = NO;
            labelLabel.text = @"特卖";
        }
        
        UIButton * button = [MyControl createButtonWithFrame:rect ImageName:@"" Target:self Action:@selector(buttonClick:) Title:nil];
        [sv addSubview:button];
        button.tag = 1000+i;
        
        //更换礼物图片
        GiftShopModel *model = self.showArray[i];
        if ([model.add_rq rangeOfString:@"-"].location == NSNotFound) {
            rqNum.text = [NSString stringWithFormat:@"+%@",model.add_rq];
        }else{
            rqNum.text = [NSString stringWithFormat:@"%@",model.add_rq];
        }
        giftPrice.text = model.price;
        giftPic.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model.no]];
        giftName.text=model.name;
        
    }
    
    [self.view bringSubviewToFront:alphaBtn];
}
-(void)createScrollView2
{
    /************现实礼物******************/
    sv2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-40)];
    sv2.contentSize = CGSizeMake(320, 64+35+15+(30/2)*185);
    [self.view addSubview:sv2];
    sv2.hidden = YES;
    
    [self.view bringSubviewToFront:navView];
    [self.view bringSubviewToFront:headerView];
    
    for(int i=0;i<3*10;i++){
        CGRect rect = CGRectMake(10+i%2*155, 64+35+15+i/2*185, 138, 170);
        UIImageView * imageView = [MyControl createImageViewWithFrame:rect ImageName:@"giftBg.png"];
        [sv2 addSubview:imageView];
        
        UIImageView * triangle = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 32, 32) ImageName:@"gift_triangle.png"];
        [imageView addSubview:triangle];
        
        UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(-3, 1, 20, 9) Font:8 Text:@"人气"];
        rq.font = [UIFont boldSystemFontOfSize:8];
        rq.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
        [triangle addSubview:rq];
        
        UILabel * rqNum = [MyControl createLabelWithFrame:CGRectMake(-1, 8, 25, 10) Font:9 Text:@"+150"];
        rqNum.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
        rqNum.textAlignment = NSTextAlignmentCenter;
        //            rqNum.backgroundColor = [UIColor redColor];
        [triangle addSubview:rqNum];
        
        UIImageView * giftPic = [MyControl createImageViewWithFrame:CGRectMake(33, 10, 70, 90) ImageName:[NSString stringWithFormat:@"bother%d_2.png", arc4random()%6+1]];
        [imageView addSubview:giftPic];
        
        NSString * str = @"伟嘉 宠物猫粮 幼猫 海洋鱼味1.2kg";
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(108, 100) lineBreakMode:1];
        UILabel * giftName = [MyControl createLabelWithFrame:CGRectMake(15, 105, 138-30, size.height) Font:12 Text:str];
        giftName.textColor = [UIColor grayColor];
//        giftName.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:giftName];
        
        UIImageView * gift = [MyControl createImageViewWithFrame:CGRectMake(43, 150, 15, 15) ImageName:@"gold.png"];
        [imageView addSubview:gift];
        
        UILabel * giftNum = [MyControl createLabelWithFrame:CGRectMake(65, 170-20, 40, 15) Font:13 Text:[NSString stringWithFormat:@"%d", i*100+2000]];
        giftNum.textColor = BGCOLOR;
        [imageView addSubview:giftNum];
        
        //新品，推荐，热卖标注
        UIImageView * label = [MyControl createImageViewWithFrame:CGRectMake(110, -6, 73/2, 46/2) ImageName:@"right_corner.png"];
        [imageView addSubview:label];
        label.hidden = YES;
        
        UILabel * labelLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 73/2, 46/2) Font:12 Text:nil];
        labelLabel.textAlignment = NSTextAlignmentCenter;
        [label addSubview:labelLabel];
        
        if (i == 0) {
            label.hidden = NO;
            labelLabel.text = @"新品";
        }else if (i == 2) {
            label.hidden = NO;
            labelLabel.text = @"热卖";
        }else if (i == 3) {
            label.hidden = NO;
            labelLabel.text = @"特卖";
        }
        
        UIButton * button = [MyControl createButtonWithFrame:rect ImageName:@"" Target:self Action:@selector(buttonClick2:) Title:nil];
        [sv2 addSubview:button];
        button.tag = 2000+i;
    }
}
-(void)buttonClick:(UIButton *)btn
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        return;
    }
    NSLog(@"点击了虚拟礼物第%d个", btn.tag-1000+1);
    [self buyGiftItemsAPI:btn.tag -1000];
}
-(void)buttonClick2:(UIButton *)btn
{
    NSLog(@"点击了现实礼物第%d个", btn.tag-2000+1);
}
#pragma mark - createBottom
-(void)createBottom
{
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height-40, 320, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel * MyGold = [MyControl createLabelWithFrame:CGRectMake(10, 10, 100, 20) Font:15 Text:@"我的金币："];
    MyGold.textColor = [UIColor blackColor];
    [view addSubview:MyGold];
    
    CGSize size = [MyGold.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    
    BottomGold = [MyControl createLabelWithFrame:CGRectMake(MyGold.frame.origin.x+size.width, 10, 100, 20) Font:15 Text:[USER objectForKey:@"gold"]];
    BottomGold.textColor = BGCOLOR;
    [view addSubview:BottomGold];
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        BottomGold.text = @"500";
    }
    
    UIButton * moreGold = [MyControl createButtonWithFrame:CGRectMake(220, (40-25)/2.0, 90, 25) ImageName:@"" Target:self Action:@selector(moreGoldClick) Title:@"更多金币"];
    moreGold.titleLabel.font = [UIFont systemFontOfSize:15];
    moreGold.backgroundColor = BGCOLOR;
    moreGold.layer.cornerRadius = 5;
    moreGold.layer.masksToBounds = YES;
    moreGold.showsTouchWhenHighlighted = YES;
    moreGold.hidden = YES;
    [view addSubview:moreGold];
}
-(void)moreGoldClick
{
    NSLog(@"金币充值");
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
