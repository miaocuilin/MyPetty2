//
//  SimpleRewardViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/1/22.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "SimpleRewardViewController.h"

@interface SimpleRewardViewController ()

@end

@implementation SimpleRewardViewController
-(void)dealloc
{
    [super dealloc];
    [timer invalidate];
    [timer release];
    bigImageView.image = nil;
    bigImageView = nil,[bigImageView release];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //搭图片
    [self makeUI];
    
    //搭赏
    [self createReward];
    
    [self loadImageData];
    
    self.view.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        self.view.alpha = 1;
    }];
}
-(void)loadImageData
{
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@&usr_id=%@dog&cat", self.img_id, [USER objectForKey:@"usr_id"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&usr_id=%@&sig=%@&SID=%@", IMAGEINFOAPI, self.img_id, [USER objectForKey:@"usr_id"], sig, [ControllerManager getSID]];
    NSLog(@"imageInfoAPI:%@", url);
    
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            ENDLOADING;
//            self.picDict = load.dataDict;
            if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"image"] isKindOfClass:[NSDictionary class]]) {
                self.imageDict = [[load.dataDict objectForKey:@"data"] objectForKey:@"image"];
                [self modifyUI];
            }
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
//-(void)createUI
//{
//    [self createReward];
//}
-(void)createReward
{
    //587  98
    rewardBg = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-498/2)/2.0, self.view.frame.size.height-50-103/2-20, 498/2, 103/2) ImageName:@"food_rewardBg.png"];
    [self.view addSubview:rewardBg];
    
    //
    UIImageView * food = [MyControl createImageViewWithFrame:CGRectMake(30, (rewardBg.frame.size.height-25)/2.0, 25, 25) ImageName:@"exchange_whiteFood.png"];
    [rewardBg addSubview:food];
    
    rewardNum = [MyControl createLabelWithFrame:CGRectMake(75, 0, 47, rewardBg.frame.size.height) Font:17 Text:@"1"];
    rewardNum.font = [UIFont boldSystemFontOfSize:17];
    rewardNum.textAlignment = NSTextAlignmentCenter;
    [rewardBg addSubview:rewardNum];
    
    
    UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(125, (rewardBg.frame.size.height-31/2)/2.0, 18/2, 31/2) ImageName:@"rightArrow.png"];
    [rewardBg addSubview:arrow];
    
    
    
    //10 100 1000
    selectView = [MyControl createViewWithFrame:CGRectMake(rewardBg.frame.origin.x+45, rewardBg.frame.origin.y-105, 113, 105)];
    selectView.hidden = YES;
    [self.view addSubview:selectView];
    
    UIImageView * selectBg = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 113, 100) ImageName:@""];
    selectBg.image = [[UIImage imageNamed:@"food_selectBg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [selectView addSubview:selectBg];
    
    UIImageView * selectTri = [MyControl createImageViewWithFrame:CGRectMake((113-19/2.0)/2.0, 100, 19/2.0, 5) ImageName:@"food_selectBg_tri.png"];
    [selectView addSubview:selectTri];
    
    NSArray * numArray = @[@"1000", @"100", @"10", @"1"];
    for (int i=0; i<numArray.count; i++) {
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(0, 25*i, selectBg.frame.size.width, 25) Font:17 Text:[NSString stringWithFormat:@"   %@", numArray[i]]];
        label.tag = 200+i;
        [selectBg addSubview:label];
        
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(0, 25*i, selectBg.frame.size.width, 25) ImageName:@"" Target:self Action:@selector(numBtnClick:) Title:nil];
        [selectBg addSubview:button];
        button.tag = 100+i;
        if (i == 3) {
            label.backgroundColor = ORANGE;
        }
    }
    
    //
    UIButton * selectBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, rewardBg.frame.size.width/2.0, rewardBg.frame.size.height) ImageName:@"" Target:self Action:@selector(selectBtnClick:) Title:nil];
    selectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [rewardBg addSubview:selectBtn];
    
    //    UIButton * rewardBtn = [MyControl createButtonWithFrame:CGRectMake(rewardBg.frame.size.width/2.0, 0, rewardBg.frame.size.width/2.0, rewardBg.frame.size.height) ImageName:@"" Target:self Action:@selector(rewardBtnClick:) Title:@""];
    //    rewardBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    //    [rewardBg addSubview:rewardBtn];
    
    heartBtn = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-90, rewardBg.frame.origin.y-2, 126/2, 115/2) ImageName:@"food_heart.png" Target:self Action:@selector(rewardBtnClick:) Title:nil];
//    [heartBtn addTarget:self action:@selector(heartTouchDown) forControlEvents:UIControlEventTouchDown];
//    [heartBtn addTarget:self action:@selector(heartUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:heartBtn];
//    timer2 = [NSTimer scheduledTimerWithTimeInterval:1.9 target:self selector:@selector(heartAnimation) userInfo:nil repeats:YES];
}
#pragma mark -
-(void)numBtnClick:(UIButton *)btn
{
    [UIView animateWithDuration:0.2 animations:^{
        selectView.alpha = 0;
    } completion:^(BOOL finished) {
        selectView.hidden = YES;
    }];
    NSLog(@"%d", btn.tag);
    for (int i=0; i<4; i++) {
        UILabel * label = (UILabel *)[self.view viewWithTag:200+i];
        label.backgroundColor = [UIColor clearColor];
    }
    UILabel * label = (UILabel *)[self.view viewWithTag:100+btn.tag];
    label.backgroundColor = ORANGE;
    
    NSArray * numArray = @[@"1000", @"100", @"10", @"1"];
    rewardNum.text = numArray[btn.tag-100];
}
-(void)selectBtnClick:(UIButton *)btn
{
    if (selectView.hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            selectView.hidden = NO;
            selectView.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            selectView.alpha = 0;
        } completion:^(BOOL finished) {
            selectView.hidden = YES;
        }];
    }
    
}

-(void)rewardBtnClick:(UIButton *)btn
{
    [UIView animateWithDuration:0.2 animations:^{
        heartBtn.frame = CGRectMake(self.view.frame.size.width-90, rewardBg.frame.origin.y-2, 126/2, 115/2);
    } completion:^(BOOL finished) {
//        timer2 = [NSTimer scheduledTimerWithTimeInterval:2.4 target:self selector:@selector(heartAnimation) userInfo:nil repeats:YES];
    }];
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        return;
    }
    if ([rewardNum.text intValue]>[[USER objectForKey:@"gold"] intValue]+[[USER objectForKey:@"food"] intValue]) {
        Alert_2ButtonView2 * view2 = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
        view2.type = 2;
        view2.rewardNum = rewardNum.text;
        [view2 makeUI];
        view2.jumpCharge = ^(){
//            ChargeViewController * charge = [[ChargeViewController alloc] init];
//            [self presentViewController:charge animated:YES completion:nil];
//            [charge release];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:view2];
        [view2 release];
        return;
    }
    
    if([[USER objectForKey:@"notShowCostAlert"] intValue] && [rewardNum.text intValue]>[[USER objectForKey:@"food"] intValue]){
        Alert_2ButtonView2 * view2 = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
        view2.type = 1;
        view2.reward = ^(){
            [self reward];
        };
        view2.rewardNum = rewardNum.text;
        [view2 makeUI];
        [[UIApplication sharedApplication].keyWindow addSubview:view2];
        [view2 release];
        return;
    }
    
    [self reward];
    
}
-(void)reward
{
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@&n=%@dog&cat", self.img_id, rewardNum.text]];
    NSString * url = [NSString stringWithFormat:@"%@%@&n=%@&sig=%@&SID=%@", REWARDFOODAPI, self.img_id, rewardNum.text, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                if ([rewardNum.text intValue]>[[USER objectForKey:@"food"] intValue]) {
                    [USER setObject:@"0" forKey:@"food"];
                }else{
                    [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"food"] intValue]-[rewardNum.text intValue]] forKey:@"food"];
                }
                
                [USER setObject:[NSString stringWithFormat:@"%@", [[load.dataDict objectForKey:@"data"] objectForKey:@"gold"]] forKey:@"gold"];
                
                
                
//                BegFoodListModel * model = self.dataArray[a];
                NSString * str = [NSString stringWithFormat:@"%@", [[load.dataDict objectForKey:@"data"] objectForKey:@"food"]];
                NSMutableDictionary * tempDic = [NSMutableDictionary dictionaryWithDictionary:self.imageDict];
                [tempDic setObject:str forKey:@"food"];
                self.imageDict = tempDic;
                [self modifyUI];
//                [MyControl popAlertWithView:self.view Msg:[NSString stringWithFormat:@"打赏成功，萌星 %@ 感谢您的爱心！", [self.dataArray[a] name]]];
//                [tv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:a inSection:0]] withRowAnimation:0];
                
                
            }
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)closeClick
{
    [UIView animateWithDuration:0.4 animations:^{
        self.view.alpha = 0;
    }completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
}

#pragma mark -
-(void)makeUI
{
    //半透明背景
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.view addSubview:alphaView];
    
    bgButton = [MyControl createButtonWithFrame:[UIScreen mainScreen].bounds ImageName:@"" Target:self Action:@selector(closeClick) Title:nil];
    [self.view addSubview:bgButton];
    
//    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-50-20-98/2-70)];
//    bgView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:bgView];
    //
    whiteView = [MyControl createViewWithFrame:CGRectMake(13, 30, self.view.frame.size.width-26, [UIScreen mainScreen].bounds.size.height-50-20-98/2-70)];
    whiteView.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
    whiteView.layer.borderWidth = 0.8;
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    //从下往上搭
    //描述
    //    NSLog(@"%f--%f--%f", size.width, size.height, whiteView.frame.size.width-30);
    desLabel = [MyControl createLabelWithFrame:CGRectZero Font:14 Text:nil];
    desLabel.textColor = [ControllerManager colorWithHexString:@"777777"];
    [whiteView addSubview:desLabel];
    
    line = [MyControl createViewWithFrame:CGRectMake(5, desLabel.frame.origin.y-10, whiteView.frame.size.width-10, 1)];
    line.backgroundColor = LineGray;
    [whiteView addSubview:line];
    
    
    foodNum = [MyControl createLabelWithFrame:CGRectMake(5, line.frame.origin.y-25, 200, 20) Font:15 Text:nil];
    foodNum.textColor = ORANGE;
    [whiteView addSubview:foodNum];
    
    
    //剩余时间
    leftTime = [MyControl createLabelWithFrame:CGRectMake(whiteView.frame.size.width-220, foodNum.frame.origin.y, 210, 20) Font:13 Text:nil];
    leftTime.textAlignment = NSTextAlignmentRight;
    leftTime.textColor = [UIColor grayColor];
    [whiteView addSubview:leftTime];
    
    bigImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 100, 100) ImageName:@""];
    [whiteView addSubview:bigImageView];
    
    //    addLabel = [MyControl createLabelWithFrame:CGRectZero Font:15 Text:nil];
    //    addLabel.textColor = ORANGE;
    //    addLabel.textAlignment = NSTextAlignmentCenter;
    //    [whiteView addSubview:addLabel];
//    bigBtn = [MyControl createButtonWithFrame:whiteView.frame ImageName:@"" Target:self Action:@selector(bigBtnClick) Title:nil];
//    //    bigBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    [self addSubview:bigBtn];
}
-(void)minTime
{
    //1417692151
    NSString * str = [MyControl leftTimeFromStamp:[self.imageDict objectForKey:@"create_time"]];
    leftTime.text = [NSString stringWithFormat:@"倒计时：%@", str];
}
-(void)modifyUI
{
    leftTime.text = nil;
//    self.timeStamp = [self.imageDict objectForKey:@"create_time"];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(minTime) userInfo:nil repeats:YES];
    
    //
    desLabel.text = [self.imageDict objectForKey:@"cmt"];
    CGSize size = [[self.imageDict objectForKey:@"cmt"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(whiteView.frame.size.width-30, 100) lineBreakMode:1];
    desLabel.frame = CGRectMake(15, whiteView.frame.size.height-size.height-30, whiteView.frame.size.width-30, size.height);
    //
    line.frame = CGRectMake(5, desLabel.frame.origin.y-10, whiteView.frame.size.width-10, 1);
    //
    NSString * str2 = [NSString stringWithFormat:@"已挣得%@份口粮", [self.imageDict objectForKey:@"food"]];
    NSMutableAttributedString * mutableStr = [[NSMutableAttributedString alloc] initWithString:str2];
    [mutableStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} range:NSMakeRange(3, [[self.imageDict objectForKey:@"food"] length])];
    foodNum.attributedText = mutableStr;
    foodNum.frame = CGRectMake(5, line.frame.origin.y-25, 200, 20);
    [mutableStr release];
    
    //
    //    addLabel.frame = CGRectMake(foodNum.frame.origin.x, foodNum.frame.origin.y-15, foodNum.frame.size.width, 20);
    //    addLabel.alpha = 0;
    
    //
    leftTime.frame = CGRectMake(whiteView.frame.size.width-220, foodNum.frame.origin.y, 210, 20);
    
    //517_1417699704@50512@_640&853.png
    [bigImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, [self.imageDict objectForKey:@"url"]]] placeholderImage:[UIImage imageNamed:@"water_white.png"] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
        //        NSLog(@"%d--%lld--%.2lld", receivedSize, expectedSize, receivedSize/expectedSize);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            //            bigImageView.image = nil;
            //            bigImageView.image = [UIImage imageWithData:[MyControl compressImage:image]];
            float w = whiteView.frame.size.width;
            float h = leftTime.frame.origin.y;
            
            float imageW = image.size.width;
            float imageH = image.size.height;
            
            int margin = 5;
            if (imageW/imageH > w/h) {
                //过宽
                float realHeight = (w-margin*2)*imageH/imageW;
                bigImageView.frame = CGRectMake(margin, (h-realHeight)/2.0, w-margin*2, realHeight);
            }else{
                //过高
                float realWidth = (h-margin*2)*imageW/imageH;
                bigImageView.frame = CGRectMake((w-realWidth)/2.0, margin, realWidth, h-margin*2);
            }
            
        }
    }];
    //    [bigImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    //        if (image) {
    //
    //            float w = whiteView.frame.size.width;
    //            float h = leftTime.frame.origin.y;
    //
    //            float imageW = image.size.width;
    //            float imageH = image.size.height;
    //
    //            int margin = 5;
    //            if (imageW/imageH > w/h) {
    //                //过宽
    //                float realHeight = (w-margin*2)*imageH/imageW;
    //                bigImageView.frame = CGRectMake(margin, (h-realHeight)/2.0, w-margin*2, realHeight);
    //            }else{
    //                //过高
    //                float realWidth = (h-margin*2)*imageW/imageH;
    //                 bigImageView.frame = CGRectMake((w-realWidth)/2.0, margin, realWidth, h-margin*2);
    //            }
    //        }
    //    }];
    
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
