//
//  PetMain_Gift_ViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetMain_Gift_ViewController.h"

@interface PetMain_Gift_ViewController ()

@end

@implementation PetMain_Gift_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    self.goodsNumArray = [NSMutableArray arrayWithCapacity:0];
    [self createFakeNavigation];
    [self loadData];
}

-(void)loadData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.model.aid]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETGOODSLISTAPI, self.model.aid, sig, [ControllerManager getSID]];
    NSLog(@"国王礼物API:%@", url);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
//            NSLog(@"国王礼物数据：%@",load.dataDict);
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
                //剔除数目为0的物品
                //                for(int i=0;i<self.goodsArray.count;i++){
                //                    if ([self.goodsNumArray[i] intValue] == 0) {
                //                        [self.goodsArray removeObjectAtIndex:i];
                //                        [self.goodsNumArray removeObjectAtIndex:i];
                //                        i--;
                //                    }
                //                }
            }
            [self createScrollView];
        }
    }];
    [request release];
}
#pragma mark -
-(void)createFakeNavigation
{
    UIImageView * blurImage = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.png"];
    [self.view addSubview:blurImage];
    
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
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"礼物"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}
- (void)backBtnClick
{
    NSLog(@"dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createScrollView
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    sv.showsVerticalScrollIndicator = NO;
    sv.contentSize = CGSizeMake(self.view.frame.size.width, 15+ceilf(self.goodsArray.count/3.0)*100);
    [self.view addSubview:sv];
    
    float spe = (self.view.frame.size.width-40-85*3)/2.0;
    for(int i=0;i<self.goodsArray.count;i++){
        CGRect rect = CGRectMake(20+i%3*(85+spe), 15+i/3*100, 85, 90);
        NSDictionary * dict = [ControllerManager returnGiftDictWithItemId:self.goodsArray[i]];
        UIImageView * imageView = [MyControl createImageViewWithFrame:rect ImageName:@"product_bg.png"];
        if ([[dict objectForKey:@"no"] intValue]>=2000) {
            imageView.image = [UIImage imageNamed:@"trick_bg.png"];
        }
        [sv addSubview:imageView];
        
        //            UIImageView * triangle = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 32, 32) ImageName:@"gift_triangle.png"];
        //            [imageView addSubview:triangle];
        
        UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(-1, 4, 20, 9) Font:8 Text:@"人气"];
        rq.font = [UIFont boldSystemFontOfSize:8];
        rq.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
        [imageView addSubview:rq];
        
        UILabel * rqNum = [MyControl createLabelWithFrame:CGRectMake(-1, 11, 25, 10) Font:8 Text:@"+150"];
        rqNum.font = [UIFont systemFontOfSize:8];
        if ([[dict objectForKey:@"add_rq"] rangeOfString:@"-"].location == NSNotFound) {
            rqNum.text = [NSString stringWithFormat:@"+%@", [dict objectForKey:@"add_rq"]];
        }else{
            rqNum.text = [dict objectForKey:@"add_rq"];
        }
        rqNum.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
        rqNum.textAlignment = NSTextAlignmentCenter;
        //            rqNum.backgroundColor = [UIColor redColor];
        [imageView addSubview:rqNum];
        
        UILabel * giftName = [MyControl createLabelWithFrame:CGRectMake(0, 5, 85, 15) Font:11 Text:[dict objectForKey:@"name"]];
        giftName.textColor = [UIColor grayColor];
        giftName.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:giftName];
        
        UIImageView * giftPic = [MyControl createImageViewWithFrame:CGRectMake(13, 20, 59, 50) ImageName:[NSString stringWithFormat:@"%@.png", [dict objectForKey:@"no"]]];
        [imageView addSubview:giftPic];
        
        UIImageView * gift = [MyControl createImageViewWithFrame:CGRectMake(20, 90-14-5, 12, 14) ImageName:@"detail_gift.png"];
        [imageView addSubview:gift];
        
        UILabel * giftNum = [MyControl createLabelWithFrame:CGRectMake(35, 90-18, 40, 15) Font:13 Text:[NSString stringWithFormat:@" × %@", self.goodsNumArray[i]]];
        giftNum.textColor = BGCOLOR;
        [imageView addSubview:giftNum];
        
        UIButton * button = [MyControl createButtonWithFrame:rect ImageName:@"" Target:self Action:@selector(buttonClick:) Title:nil];
        [sv addSubview:button];
        button.tag = 1000+i;
    }
}
-(void)buttonClick:(UIButton *)btn
{
    NSLog(@"%d", btn.tag);
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
