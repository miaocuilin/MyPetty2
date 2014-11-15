//
//  SendGiftViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-9-24.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "SendGiftViewController.h"
#import "GiftShopViewController.h"
#import "GiftShopModel.h"
@interface SendGiftViewController ()

@end

@implementation SendGiftViewController

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
    self.bagItemIdArray = [NSMutableArray arrayWithCapacity:0];
    self.bagItemNumArray = [NSMutableArray arrayWithCapacity:0];
    self.giftArray = [NSMutableArray arrayWithArray:[ControllerManager returnAllGiftsArray]];
    self.tempGiftArray = [NSMutableArray arrayWithArray:self.giftArray];
    
    [self backgroundView];
    [self loadBagData];
//    [self createUI];
}

- (void)backgroundView
{
    UIView *bgView = [MyControl createViewWithFrame:self.view.frame];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
}
#pragma mark - 背包数据
- (void)loadBagData
{
    StartLoading;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERGOODSLISTAPI, [USER objectForKey:@"usr_id"], sig, [ControllerManager getSID]];
//    NSLog(@"背包url:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"背包物品数据：%@",load.dataDict);
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                for (NSString * key in [[load.dataDict objectForKey:@"data"] allKeys]) {
                    if([key intValue]%10 >4){
                        continue;
                    }
                    [self.bagItemIdArray addObject:key];
                }
                //排序
                for (int i=0; i<self.bagItemIdArray.count; i++) {
                    for (int j=0; j<self.bagItemIdArray.count-i-1; j++) {
                        if ([self.bagItemIdArray[j] intValue] > [self.bagItemIdArray[j+1] intValue]) {
                            NSString * str1 = [NSString stringWithFormat:@"%@", self.bagItemIdArray[j]];
                            NSString * str2 = [NSString stringWithFormat:@"%@", self.bagItemIdArray[j+1]];
                            self.bagItemIdArray[j] = str2;
                            self.bagItemIdArray[j+1] = str1;
                        }
                    }
                }
                //
                for (NSString * str in self.bagItemIdArray) {
                    [self.bagItemNumArray addObject:[[load.dataDict objectForKey:@"data"] objectForKey:str]];
                }
                for(int i=0;i<self.bagItemIdArray.count;i++){
                    if ([self.bagItemNumArray[i] intValue] == 0) {
                        [self.bagItemIdArray removeObjectAtIndex:i];
                        [self.bagItemNumArray removeObjectAtIndex:i];
                        i--;
                    }
                }
            }
            
            //将背包中有的从所有物品中剔除
//            NSLog(@"%d", self.tempGiftArray.count);
            for (int i=0; i<self.tempGiftArray.count; i++) {
                for (int j=0; j<self.bagItemIdArray.count; j++) {
                    if ([[self.tempGiftArray[i] objectForKey:@"no"] isEqualToString:self.bagItemIdArray[j]]) {
                        [self.tempGiftArray removeObjectAtIndex:i];
                        i--;
                        break;
                    }
                }
            }
//            NSLog(@"%d", self.tempGiftArray.count);
            //
            LoadingSuccess;
            [self createBgView];
            [self createUI];
        }else{
            LoadingFailed;
        }
    }];
    [request release];
}
#pragma mark - 搭建页面
-(void)createBgView
{
    totalView = [MyControl createViewWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-212, 300, 425)];
    totalView.layer.cornerRadius = 10;
    totalView.layer.masksToBounds = YES;
    totalView.backgroundColor = [UIColor colorWithRed:252/255.0 green:238/255.0 blue:226/255.0 alpha:1];
    [self.view addSubview:totalView];
    
    UIImageView *titleView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 300, 40) ImageName:@"title_bg.png"];
    [totalView addSubview:titleView];
    UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:16 Text:@"给Ta送个礼物吧"];
    if (self.receiver_name.length != 0) {
        titleLabel.text = [NSString stringWithFormat:@"给%@送个礼物吧", self.receiver_name];
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:titleLabel];
    
    UIImageView *closeImageView = [MyControl createImageViewWithFrame:CGRectMake(260, 10, 20, 20) ImageName:@"30-1.png"];
    [totalView addSubview:closeImageView];
    
    UIButton *closeButton = [MyControl createButtonWithFrame:CGRectMake(252.5, 2.5, 35, 35) ImageName:nil Target:self Action:@selector(closeGiftAction) Title:nil];
    closeButton.showsTouchWhenHighlighted = YES;
    [totalView addSubview:closeButton];
    
    giftPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 310+45, 300, 20)];
    giftPageControl.userInteractionEnabled = NO;
    giftPageControl.numberOfPages =ceilf(self.giftArray.count/4.0);
    giftPageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:252/255.0 green:123/255.0 blue:81/255.0 alpha:1];
    giftPageControl.pageIndicatorTintColor = [UIColor grayColor];
    [totalView addSubview:giftPageControl];
    [giftPageControl release];
    
    UIButton *giftButton = [MyControl createButtonWithFrame:CGRectMake(40, 335+45, 220, 40) ImageName:nil Target:self Action:@selector(goShopping) Title:@"去商城"];
    giftButton.showsTouchWhenHighlighted = YES;
    giftButton.backgroundColor = [UIColor colorWithRed:252/255.0 green:123/255.0 blue:81/255.0 alpha:1];
    giftButton.layer.cornerRadius = 5;
    giftButton.layer.masksToBounds = YES;
    giftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [totalView addSubview:giftButton];
}
-(void)createUI
{
    /***************************/
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 300, 385-60)];
    sv.delegate = self;
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    [totalView addSubview:sv];
    
    CGSize scrollViewSize = CGSizeMake(300 * ceilf(self.giftArray.count/4.0), sv.frame.size.height);
    [sv setContentSize:scrollViewSize];
//    int h = 15;//水平间距
//    int v = 10;//垂直间距
    
    /*********************************************/
    for (int i=0; i<self.bagItemIdArray.count+self.tempGiftArray.count-1; i+=2) {
        //白色背景
        UIImageView * giftBgImageView = [MyControl createImageViewWithFrame:CGRectMake(25+i/4*300, 10, 222/2, 190/2) ImageName:@"giftAlert_giftBg.png"];
        [sv addSubview:giftBgImageView];
        
        UIImageView * giftBgImageView2 = [MyControl createImageViewWithFrame:CGRectMake(324/2+i/4*300, 10, 222/2, 190/2) ImageName:@"giftAlert_giftBg.png"];
        [sv addSubview:giftBgImageView2];
        if ((i+2)%4 == 0) {
            giftBgImageView.frame = CGRectMake(25+i/4*300, 10+310/2, 222/2, 190/2);
            giftBgImageView2.frame = CGRectMake(324/2+i/4*300, 10+310/2, 222/2, 190/2);
        }
        
        //礼物图片
        UIImageView * giftImageView = [MyControl createImageViewWithFrame:CGRectMake((111-98)/2.0, (95-93)/2.0, 98, 83) ImageName:@""];
        [giftBgImageView addSubview:giftImageView];
        
        UIImageView * giftImageView2 = [MyControl createImageViewWithFrame:CGRectMake((111-98)/2.0, (95-93)/2.0, 98, 83) ImageName:@""];
        [giftBgImageView2 addSubview:giftImageView2];
        
        
        //木板
        UIImageView * wood = [MyControl createImageViewWithFrame:CGRectMake(i/4*300+(300-546/2)/2.0, giftBgImageView.frame.origin.y+190/2, 546/2, 17/2.0) ImageName:@"giftAlert_wood.png"];
        [sv addSubview:wood];
        
        //
        UIImageView * hang_tag = [MyControl createImageViewWithFrame:CGRectMake(wood.frame.origin.x+4, wood.frame.origin.y-1, 246/2, 106/2) ImageName:@""];
        [sv addSubview:hang_tag];
        
        UIImageView * hang_tag2 = [MyControl createImageViewWithFrame:CGRectMake(wood.frame.origin.x+wood.frame.size.width-4-246/2, wood.frame.origin.y-1, 246/2, 106/2) ImageName:@""];
        [sv addSubview:hang_tag2];
        
        //礼物名称
        UILabel * productLabel = [MyControl createLabelWithFrame:CGRectMake(10, 18, 80, 15) Font:12 Text:nil];
        productLabel.font = [UIFont boldSystemFontOfSize:12];
        productLabel.textColor = [ControllerManager colorWithHexString:@"5F5E5E"];
        [hang_tag addSubview:productLabel];
        
        UILabel * productLabel2 = [MyControl createLabelWithFrame:CGRectMake(10, 18, 80, 15) Font:12 Text:nil];
        productLabel2.font = [UIFont boldSystemFontOfSize:12];
        productLabel2.textColor = [ControllerManager colorWithHexString:@"5F5E5E"];
        [hang_tag2 addSubview:productLabel2];
        
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
        
        //背包中礼物数量
        UIImageView * giftIcon = [MyControl createImageViewWithFrame:CGRectMake(10, 35, 15, 15) ImageName:@"giftIcon.png"];
        [hang_tag addSubview:giftIcon];
        
        UILabel * giftNum = [MyControl createLabelWithFrame:CGRectMake(28, 34, 40, 17) Font:15 Text:nil];
        giftNum.textColor = BGCOLOR;
        [hang_tag addSubview:giftNum];
        
        UIImageView * giftIcon2 = [MyControl createImageViewWithFrame:CGRectMake(10, 35, 15, 15) ImageName:@"giftIcon.png"];
        [hang_tag2 addSubview:giftIcon2];
        
        UILabel * giftNum2 = [MyControl createLabelWithFrame:CGRectMake(28, 34, 40, 17) Font:15 Text:nil];
        giftNum2.textColor = BGCOLOR;
        [hang_tag2 addSubview:giftNum2];
        
        //金币图标及价格
        UIImageView * gold = [MyControl createImageViewWithFrame:CGRectMake(10, 35, 15, 15) ImageName:@"gold.png"];
        [hang_tag addSubview:gold];
        
        UILabel * price = [MyControl createLabelWithFrame:CGRectMake(33, 34, 40, 17) Font:15 Text:nil];
        price.font = [UIFont boldSystemFontOfSize:13];
        price.textColor = BGCOLOR;
        [hang_tag addSubview:price];
        
        UIImageView * gold2 = [MyControl createImageViewWithFrame:CGRectMake(10, 35, 15, 15) ImageName:@"gold.png"];
        [hang_tag2 addSubview:gold2];
        
        UILabel * price2 = [MyControl createLabelWithFrame:CGRectMake(33, 34, 40, 17) Font:15 Text:@""];
        price2.font = [UIFont boldSystemFontOfSize:13];
        price2.textColor = BGCOLOR;
        [hang_tag2 addSubview:price2];
        
        //
        CGRect rect = giftBgImageView.frame;
        CGRect rect2 = giftBgImageView2.frame;
        UIButton * sendGiftBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) ImageName:@"" Target:self Action:@selector(sendGiftBtnClick:) Title:nil];
        sendGiftBtn.tag = 1000+i;
        [giftBgImageView addSubview:sendGiftBtn];
        
        UIButton * sendGiftBtn2 = [MyControl createButtonWithFrame:CGRectMake(0, 0, rect2.size.width, rect2.size.height) ImageName:@"" Target:self Action:@selector(sendGiftBtnClick:) Title:nil];
        sendGiftBtn2.tag = 1000+i+1;
        [giftBgImageView2 addSubview:sendGiftBtn2];
        
        //
        if (i<self.bagItemIdArray.count) {
            //背包
            gold.hidden = YES;
            price.hidden = YES;
            if ([self.bagItemIdArray[i] intValue]>=2000) {
                hang_tag.image = [UIImage imageNamed:@"giftAlert_badBg.png"];
            }else{
                hang_tag.image = [UIImage imageNamed:@"giftAlert_goodBg.png"];
            }
            giftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.bagItemIdArray[i]]];
            NSDictionary * dic = [ControllerManager returnGiftDictWithItemId:self.bagItemIdArray[i]];
            productLabel.text = [dic objectForKey:@"name"];
            rqz.text = [dic objectForKey:@"add_rq"];
            
            giftNum.text = [NSString stringWithFormat:@"x %@", self.bagItemNumArray[i]];
        }else{
            //商店
            giftIcon.hidden = YES;
            if ([[self.tempGiftArray[i-self.bagItemIdArray.count] objectForKey:@"no"] intValue]>2000) {
                hang_tag.image = [UIImage imageNamed:@"giftAlert_badBg.png"];
            }else{
                hang_tag.image = [UIImage imageNamed:@"giftAlert_goodBg.png"];
            }
            giftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [self.tempGiftArray[i-self.bagItemIdArray.count] objectForKey:@"no"]]];

            productLabel.text = [self.tempGiftArray[i-self.bagItemIdArray.count] objectForKey:@"name"];
            rqz.text = [self.tempGiftArray[i-self.bagItemIdArray.count] objectForKey:@"add_rq"];
            price.text = [self.tempGiftArray[i-self.bagItemIdArray.count] objectForKey:@"price"];
        }
        /********************/
        if (i+1<self.bagItemIdArray.count) {
            //
            gold2.hidden = YES;
            price2.hidden = YES;
            if ([self.bagItemIdArray[i+1] intValue]>=2000) {
                hang_tag2.image = [UIImage imageNamed:@"giftAlert_badBg.png"];
            }else{
                hang_tag2.image = [UIImage imageNamed:@"giftAlert_goodBg.png"];
            }
            giftImageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.bagItemIdArray[i+1]]];
            NSDictionary * dic = [ControllerManager returnGiftDictWithItemId:self.bagItemIdArray[i+1]];
            productLabel2.text = [dic objectForKey:@"name"];
            rqz2.text = [dic objectForKey:@"add_rq"];
            
            giftNum2.text = [NSString stringWithFormat:@"x %@", self.bagItemNumArray[i+1]];
        }else{
            //
            giftIcon2.hidden = YES;
            if ([[self.tempGiftArray[i+1-self.bagItemIdArray.count] objectForKey:@"no"] intValue]>2000) {
                hang_tag2.image = [UIImage imageNamed:@"giftAlert_badBg.png"];
            }else{
                hang_tag2.image = [UIImage imageNamed:@"giftAlert_goodBg.png"];
            }
            giftImageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [self.tempGiftArray[i+1-self.bagItemIdArray.count] objectForKey:@"no"]]];
            productLabel2.text = [self.tempGiftArray[i+1-self.bagItemIdArray.count] objectForKey:@"name"];
            rqz2.text = [self.tempGiftArray[i+1-self.bagItemIdArray.count] objectForKey:@"add_rq"];
            price2.text = [self.tempGiftArray[i+1-self.bagItemIdArray.count] objectForKey:@"price"];
        }
        if ([rqz.text rangeOfString:@"-"].location == NSNotFound) {
            rqz.text = [NSString stringWithFormat:@"+%@", rqz.text];
        }
        if ([rqz2.text rangeOfString:@"-"].location == NSNotFound) {
            rqz2.text = [NSString stringWithFormat:@"+%@", rqz2.text];
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*********************************************/
//    for(int i=0;i<self.bagItemIdArray.count+self.tempGiftArray.count;i++){
//    
//        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(h+i%3*(80+h)+300*(i/9), h+(i/3)%3*(90+v), 80, 90)];
//        if (i<self.bagItemIdArray.count) {
//            //背包
//            if ([self.bagItemIdArray[i] intValue]>=2000) {
//                imageView.image = [UIImage imageNamed:@"trick_bg.png"];
//            }else{
//                imageView.image = [UIImage imageNamed:@"product_bg.png"];
//            }
//        }else{
//            //商店
//            if ([[self.tempGiftArray[i-self.bagItemIdArray.count] objectForKey:@"no"] intValue]>2000) {
//                imageView.image = [UIImage imageNamed:@"trick_bg.png"];
//            }else{
//                imageView.image = [UIImage imageNamed:@"product_bg.png"];
//            }
//        }
//        [sv addSubview:imageView];
//        [imageView release];
//        
//        UIImageView *productImageView = [MyControl createImageViewWithFrame:CGRectMake((imageView.frame.size.width-75)/2, 20, 75, 50) ImageName:[NSString stringWithFormat:@"%@.png",[self.giftArray[i] objectForKey:@"no"]]];
//        [imageView addSubview:productImageView];
//        
//        UILabel * productLabel = [MyControl createLabelWithFrame:CGRectMake(0, 10, imageView.frame.size.width, 10) Font:10 Text:[self.giftArray[i] objectForKey:@"name"]];
//        productLabel.textAlignment = NSTextAlignmentCenter;
//        productLabel.font = [UIFont boldSystemFontOfSize:10];
//        productLabel.textColor = [UIColor grayColor];
//        [imageView addSubview:productLabel];
//
//        UILabel *numberCoinLabel = [MyControl createLabelWithFrame:CGRectMake(38, 75, 50, 10) Font:13 Text:nil];
//        numberCoinLabel.textColor =BGCOLOR;
//        [imageView addSubview:numberCoinLabel];
//        
//        UIImageView *coinImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 73, 13, 13) ImageName:@"gold.png"];
//        [imageView addSubview:coinImageView];
//        
//        UILabel *leftCornerLabel1 =[MyControl createLabelWithFrame:CGRectMake(-3, 4, 20, 8) Font:7 Text:@"人气"];
//        leftCornerLabel1.textAlignment = NSTextAlignmentCenter;
//        leftCornerLabel1.font = [UIFont boldSystemFontOfSize:7];
//        CGAffineTransform transform =  CGAffineTransformMakeRotation(-45.0 *M_PI / 180.0);
//        leftCornerLabel1.transform = transform;
//        
//        UILabel *leftCornerLabel2 = [MyControl createLabelWithFrame:CGRectMake(-1, 11, 25, 10) Font:8 Text:@"+50"];
//        leftCornerLabel2.font = [UIFont systemFontOfSize:8];
//        leftCornerLabel2.textAlignment = NSTextAlignmentCenter;
//        leftCornerLabel2.transform = transform;
//        [imageView addSubview:leftCornerLabel1];
//        [imageView addSubview:leftCornerLabel2];
//        
////        GiftShopModel *model = self.giftArray[i];
//        if (i>=self.bagItemIdArray.count) {
//            productImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [self.tempGiftArray[i-self.bagItemIdArray.count] objectForKey:@"no"]]];
//            productLabel.text = [self.tempGiftArray[i-self.bagItemIdArray.count] objectForKey:@"name"];
//            numberCoinLabel.text = [self.tempGiftArray[i-self.bagItemIdArray.count] objectForKey:@"price"];
//            if ([[self.tempGiftArray[i-self.bagItemIdArray.count] objectForKey:@"add_rq"] rangeOfString:@"-"].location == NSNotFound) {
//                leftCornerLabel2.text = [NSString stringWithFormat:@"+%@", [self.tempGiftArray[i-self.bagItemIdArray.count] objectForKey:@"add_rq"]];
//            }else{
//                leftCornerLabel2.text = [self.tempGiftArray[i-self.bagItemIdArray.count] objectForKey:@"add_rq"];
//            }
//            
//        }else{
//            productImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.bagItemIdArray[i]]];
//            productLabel.text = [[ControllerManager returnGiftDictWithItemId:self.bagItemIdArray[i]] objectForKey:@"name"];
//            numberCoinLabel.text = [NSString stringWithFormat:@"X %@", self.bagItemNumArray[i]];
//            coinImageView.image = [UIImage imageNamed:@"giftIcon.png"];
//            if ([[[ControllerManager returnGiftDictWithItemId:self.bagItemIdArray[i]] objectForKey:@"add_rq"] rangeOfString:@"-"].location == NSNotFound) {
//                leftCornerLabel2.text = [NSString stringWithFormat:@"+%@", [[ControllerManager returnGiftDictWithItemId:self.bagItemIdArray[i]] objectForKey:@"add_rq"]];
//            }else{
//                leftCornerLabel2.text = [[ControllerManager returnGiftDictWithItemId:self.bagItemIdArray[i]] objectForKey:@"add_rq"];
//            }
//        }
//        
////        NSLog(@"rq:%d",[[self.giftArray[i] objectForKey:@"add_rq"] intValue]);
//        
//        
//        
//        UIButton * button = [MyControl createButtonWithFrame:imageView.frame ImageName:nil Target:self Action:@selector(clickBtn:) Title:nil];
//        [sv addSubview:button];
//        button.tag = 1000+i;
//    }
    /*****************************/
}

-(void)sendGiftBtnClick:(UIButton *)btn
{
    NSLog(@"btn.tag:%d", btn.tag);
    [self clickBtn:btn];
}

#pragma mark - 点击事件
-(void)goShopping
{
    NSLog(@"去商城");
    GiftShopViewController *vc = [[GiftShopViewController alloc] init];
    vc.isQuick = YES;
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
-(void)clickBtn:(UIButton *)btn;
{
    if (btn.tag-1000 >= self.bagItemIdArray.count) {
        //购买赠送
        NSLog(@"%@", [self.tempGiftArray[btn.tag-1000-self.bagItemIdArray.count] objectForKey:@"name"]);
        [self buyGiftWithItemId:[self.tempGiftArray[btn.tag-1000-self.bagItemIdArray.count] objectForKey:@"no"]];
    }else{
        //直接赠送
        NSLog(@"%@", [[ControllerManager returnGiftDictWithItemId:self.bagItemIdArray[btn.tag-1000]] objectForKey:@"name"]);
        [self sendGiftWithItemId:self.bagItemIdArray[btn.tag-1000] fromBag:YES];
    }
    
}
#pragma mark - 买礼物
-(void)buyGiftWithItemId:(NSString *)ItemId
{
    StartLoading;
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"item_id=%@&num=1dog&cat", ItemId]];
    NSString * url = [NSString stringWithFormat:@"%@%@&num=1&sig=%@&SID=%@",BUYSHOPGIFTAPI, ItemId, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            //user_gold是NSNumber类型
            [USER setObject:[NSString stringWithFormat:@"%@",[[load.dataDict objectForKey:@"data"] objectForKey:@"user_gold"]] forKey:@"gold"];
            
            [self sendGiftWithItemId:ItemId fromBag:NO];
        }else{
            
        }
    }];
    [request release];
}

#pragma mark - 送礼物
-(void)sendGiftWithItemId:(NSString *)ItemId fromBag:(BOOL)fromBag
{
    StartLoading;
    NSString * url = nil;
    
    if (self.receiver_img_id) {
        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&img_id=%@&item_id=%@dog&cat", self.receiver_aid, self.receiver_img_id, ItemId]];
        url = [NSString stringWithFormat:@"%@%@&img_id=%@&item_id=%@&sig=%@&SID=%@", SENDSHAKEGIFT, self.receiver_aid, self.receiver_img_id, ItemId, sig, [ControllerManager getSID]];
    }else{
        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&item_id=%@dog&cat", self.receiver_aid, ItemId]];
        url = [NSString stringWithFormat:@"%@%@&item_id=%@&sig=%@&SID=%@", SENDSHAKEGIFT, self.receiver_aid,ItemId, sig, [ControllerManager getSID]];
    }
    
    NSLog(@"赠送url:%@",url);
    httpDownloadBlock *request  = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if (fromBag) {
                for (int i=0; self.bagItemIdArray.count; i++) {
                    if ([self.bagItemIdArray[i] isEqualToString:ItemId]) {
                        int a = [self.bagItemNumArray[i] intValue]-1;
                        if (a == 0) {
                            //背包中移除
                            [self.bagItemIdArray removeObjectAtIndex:i];
                            [self.bagItemNumArray removeObjectAtIndex:i];
                            //重新赋值tempGiftArray
                            self.tempGiftArray = [NSMutableArray arrayWithArray:self.giftArray];
                            //将背包中有的从tempGiftArray中剔除
                            for (int i=0; i<self.tempGiftArray.count; i++) {
                                for (int j=0; j<self.bagItemIdArray.count; j++) {
                                    if ([[self.tempGiftArray[i] objectForKey:@"no"] isEqualToString:self.bagItemIdArray[j]]) {
                                        [self.tempGiftArray removeObjectAtIndex:i];
                                        i--;
                                        break;
                                    }
                                }
                            }
                            break;
                        }else{
                            self.bagItemNumArray[i] = [NSString stringWithFormat:@"%d", [self.bagItemNumArray[i] intValue]-1];
                            break;
                        }
                        
                    }
                }
                //刷新页面
                [sv removeFromSuperview];
                [self createUI];
                //
                [ControllerManager HUDText:[NSString stringWithFormat:@"恭喜您，赠送 %@ 成功!", [[ControllerManager returnGiftDictWithItemId:ItemId] objectForKey:@"name"]] showView:self.view yOffset:-60];
            }else{
                //非背包物品
                [ControllerManager HUDText:[NSString stringWithFormat:@"恭喜您，购买并赠送 %@ 成功!", [[ControllerManager returnGiftDictWithItemId:ItemId] objectForKey:@"name"]] showView:self.view yOffset:-60];
            }
            
            int addExp = [[[load.dataDict objectForKey:@"data"] objectForKey:@"exp"] intValue];
            if (addExp>0) {
                int exp = [[USER objectForKey:@"exp"] intValue];
                [USER setObject:[NSString stringWithFormat:@"%d", addExp+exp] forKey:@"exp"];
                [ControllerManager HUDImageIcon:@"Star.png" showView:self.view yOffset:0 Number:addExp];
            }
            //送礼block
            self.hasSendGift();
            [MMProgressHUD dismissWithSuccess:@"赠送成功" title:nil afterDelay:0.1];
        }else{
            
        }
    }];
    [request release];
}
-(void)closeGiftAction
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
#pragma mark -
#pragma mark - ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    giftPageControl.currentPage = index;
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
