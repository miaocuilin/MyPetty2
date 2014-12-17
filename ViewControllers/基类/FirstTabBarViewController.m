//
//  FirstTabBarViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/17.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "FirstTabBarViewController.h"

#import "MyStarViewController.h"
#import "FoodViewController.h"
#import "DiscoveryViewController.h"
#import "CenterViewController.h"
#import "SingleTalkModel.h"
#import "MessageModel.h"

@interface FirstTabBarViewController ()

@end

@implementation FirstTabBarViewController
-(void)viewWillAppear:(BOOL)animated
{
    if (!isLoaded) {
        if (![[USER objectForKey:@"guide_food"] intValue]) {
            [self createGuide];
            [USER setObject:@"1" forKey:@"guide_food"];
        }
        
        [self makeUI];
        [self modifyUI];
    }
    if (self.selectedIndex == 3) {
        CenterViewController * vc4 = self.viewControllers[3];
        [vc4 refresh];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    isLoaded = YES;
}
-(void)createGuide
{
    guide = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"guide2.png"];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [guide addGestureRecognizer:tap];
    
    //    FirstTabBarViewController * tabBar = [ControllerManager shareTabBar];
    [self.view addSubview:guide];
    [tap release];
}
-(void)tap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.2 animations:^{
        guide.alpha = 0;
    }completion:^(BOOL finished) {
        guide.hidden = YES;
    }];
}
-(void)refreshMessageNum
{
    [self getNewMessage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MyStarViewController * vc1 = [[MyStarViewController alloc] init];
    FoodViewController * vc2 = [[FoodViewController alloc] init];
    DiscoveryViewController * vc3 = [[DiscoveryViewController alloc] init];
    CenterViewController * vc4 = [[CenterViewController alloc] init];
    //    tbc = [[UITabBarController alloc] init];
    
    self.viewControllers = @[vc1, vc2, vc3, vc4];
    self.selectedIndex = 1;
    self.tabBar.hidden = YES;
    [vc1 release];
    [vc2 release];
    [vc3 release];
    [vc4 release];
    
    [self createBottom];
    //    NSArray * scArray = @[@"萌宠推荐", @"宇宙广场", @"星球关注"];
    //    sc = [[UISegmentedControl alloc] initWithItems:scArray];
    //    sc.backgroundColor = [UIColor whiteColor];
    //    sc.alpha = 0.7;
    //    sc.layer.cornerRadius = 4;
    //    sc.layer.masksToBounds = YES;
    //    sc.frame = CGRectMake(10, 69, 300, 30);
    //    [sc addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    //    //默认选中第二个，宇宙广场
    //    sc.selectedSegmentIndex = 1;
    //    sc.tintColor = BGCOLOR;
    //    [rvc.view addSubview:sc];
}

#pragma mark -
-(void)makeUI
{
    sv = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    sv.pagingEnabled = YES;
    sv.showsVerticalScrollIndicator = NO;
    sv.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
    sv.delegate = self;
    [self.view addSubview:sv];
    
    UIImageView * bgImageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@""];
    if (self.preImage) {
        bgImageView.image = [self.preImage applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    }else{
        bgImageView.image = [UIImage imageNamed:@"blurBg.png"];
    }
    [sv addSubview:bgImageView];
    
    UIButton * btn = [MyControl createButtonWithFrame:CGRectMake((self.view.frame.size.width-32)/2.0, self.view.frame.size.height-50, 32, 32) ImageName:@"foodFirst_btn.png" Target:self Action:@selector(btnClick) Title:nil];
    [bgImageView addSubview:btn];
    
    UIImageView * imageView = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-128)/2.0, self.view.frame.size.height-490/2, 128, 103) ImageName:@"foodFirst_image.png"];
    [bgImageView addSubview:imageView];
    
    label1 = [MyControl createLabelWithFrame:CGRectMake(0, imageView.frame.origin.y-174, self.view.frame.size.width, 35) Font:18 Text:nil];
    label1.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:label1];
    
    label2 = [MyControl createLabelWithFrame:CGRectMake(0, label1.frame.origin.y+60, self.view.frame.size.width, 28) Font:18 Text:@"已经挣得"];
    label2.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:label2];
    
    label3 = [MyControl createLabelWithFrame:CGRectMake(0, label2.frame.origin.y+50, self.view.frame.size.width, 35) Font:18 Text:nil];
    label3.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:label3];
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"%f", sv.contentOffset.y);
//}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (sv.contentOffset.y == self.view.frame.size.height) {
        sv.hidden = YES;
    }
}
-(void)modifyUI
{
    NSMutableAttributedString * mutableStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@位萌星", self.animalNum]];
    [mutableStr1 addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:28]} range:NSMakeRange(0, self.animalNum.length)];
    label1.attributedText = mutableStr1;
    [mutableStr1 release];
    
    NSMutableAttributedString * mutableStr3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@份口粮", self.foodNum]];
    [mutableStr3 addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:28]} range:NSMakeRange(0, self.foodNum.length)];
    label3.attributedText = mutableStr3;
    [mutableStr3 release];
}

-(void)btnClick
{
    //界面上滑
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        sv.contentOffset = CGPointMake(0, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        sv.hidden = YES;
    }];
    
    
    //    MainTabBarViewController * main = [[MainTabBarViewController alloc] init];
    //    main.selectedIndex = 1;
    //    [self presentViewController:main animated:YES completion:nil];
    //    [main release];
}


#pragma mark -
-(void)createBottom
{
    bottomBg = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    [self.view addSubview:bottomBg];
    
    NSArray * selectedArray = @[@"food_myStar_selected", @"food_beg_selected", @"food_discovery_selected", @"food_center_selected"];
    NSArray * unSelectedArray = @[@"food_myStar_unSelected", @"food_beg_unSelected", @"food_discovery_unSelected", @"food_center_unSelected"];
    for (int i=0; i<selectedArray.count; i++) {
        UIImageView * halfBall = [MyControl createImageViewWithFrame:CGRectMake(i*(self.view.frame.size.width/4.0), bottomBg.frame.size.height-50, self.view.frame.size.width/4.0, 50) ImageName:@"food_bottom_halfBall.png"];
        [bottomBg addSubview:halfBall];
        
        UIButton * ballBtn = [MyControl createButtonWithFrame:CGRectMake(halfBall.frame.origin.x+halfBall.frame.size.width/2.0-42.5/2.0, 2, 85/2.0, 85/2.0) ImageName:unSelectedArray[i] Target:self Action:@selector(ballBtnClick:) Title:nil];
        ballBtn.tag = 100+i;
        
        [ballBtn setBackgroundImage:[UIImage imageNamed:selectedArray[i]] forState:UIControlStateSelected];
        [bottomBg addSubview:ballBtn];
        if (i == 1) {
            ballBtn.selected = YES;
        }
        if (i == 3) {
            msgNumBg = [MyControl createImageViewWithFrame:CGRectMake(ballBtn.frame.size.width-15, -5, 22, 22) ImageName:@"center_msgBg.png"];
            msgNumBg.hidden = YES;
            [ballBtn addSubview:msgNumBg];
            
            msgNum = [MyControl createLabelWithFrame:CGRectMake(-10, 0, 42, 22) Font:12 Text:@"50"];
            msgNum.textAlignment = NSTextAlignmentCenter;
            [msgNumBg addSubview:msgNum];
        }
    }
    
    [self refreshMessageNum];
}
-(void)ballBtnClick:(UIButton *)btn
{
    [self ballAnimation:btn];
    
    if (![[USER objectForKey:@"isSuccess"] intValue] && btn.tag == 100) {
        ShowAlertView;
        return;
    }
    [self refreshMessageNum];
    
    for (int i=0; i<4; i++) {
        //这里写button的直接父控件bottomBg再去找tag，不然会出问题
        UIButton * button = (UIButton *)[bottomBg viewWithTag:100+i];
        //UIButton * button = (UIButton *)[self.view viewWithTag:100+i];
        button.selected = NO;
    }
    btn.selected = YES;
    
    //    NSLog(@"------%d", self.selectedIndex);
    if (btn.tag == 100) {
        MyStarViewController * vc = self.viewControllers[0];
        [vc.tv headerBeginRefreshing];
    }else if (btn.tag == 101 && self.selectedIndex == 1) {
        FoodViewController * vc = self.viewControllers[1];
        [vc loadData];
    }else if(btn.tag == 102 && self.selectedIndex == 2){
        DiscoveryViewController * vc = self.viewControllers[2];
        [vc refresh];
    }else if(btn.tag == 103 && self.selectedIndex == 3){
        CenterViewController * vc = self.viewControllers[3];
        [vc refresh];
    }
    self.selectedIndex = btn.tag-100;
    
    //    NSLog(@"%d------", self.selectedIndex);
    
    //    if(btn.tag-100){
    //
    //    }else if(btn.tag-100){
    //
    //    }else if(btn.tag-100){
    //
    //    }else if(btn.tag-100){
    //
    //    }
}

//气泡动画
-(void)ballAnimation:(UIView *)view
{
    CGRect rect = view.frame;
    [UIView animateWithDuration:0.1 animations:^{
        view.frame = CGRectMake(rect.origin.x-rect.size.width*0.1, rect.origin.y, rect.size.width*1.2, rect.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            view.frame = rect;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                view.frame = CGRectMake(rect.origin.x, rect.origin.y-rect.size.height*0.1, rect.size.width, rect.size.height*1.2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    view.frame = rect;
                }];
            }];
        }];
    }];
}

#pragma mark -
-(void)getNewMessage
{
    //    LOADING;
    NSString * url = [NSString stringWithFormat:@"%@%@", GETNEWMSGAPI,[ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"/*=====================*/");
            NSLog(@"newMsg:%@", load.dataDict);
            NSLog(@"/*=====================*/");
            //【注意】这里需要将talkIDArray每次清空
            [self.talkIDArray removeAllObjects];
            [self.nwDataArray removeAllObjects];
            [self.nwMsgDataArray removeAllObjects];
            
            NSArray * array = [load.dataDict objectForKey:@"data"];
            if (array.count) {
                self.hasNewMsg = YES;
                
                for (int i=0; i<array.count; i++) {
                    NSDictionary * dict = array[i];
                    NSString * key = [[dict allKeys] objectAtIndex:0];
                    NSDictionary * dict2 = [dict objectForKey:key];
                    if ([[dict2 objectForKey:@"usr_name"] isKindOfClass:[NSNull class]]) {
                        [dict2 setValue:@"" forKey:@"usr_name"];
                    }
                    if ([[dict2 objectForKey:@"usr_tx"] isKindOfClass:[NSNull class]]) {
                        [dict2 setValue:@"" forKey:@"usr_tx"];
                    }
                }
                //                NSLog(@"%@--%@", array, self.nwDataArray);
                [self.nwDataArray addObjectsFromArray:array];
                //                NSLog(@"%@--%@", array, self.nwDataArray);
            }else{
                self.hasNewMsg = NO;
            }
            //如果有除本地外的新消息，存储到本地
            
            /**********************/
            NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
            NSLog(@"%@", [[MyControl returnDictionaryWithDataPath:path] allKeys]);
            
            if (self.hasNewMsg) {
                //分解数据添加到7个数组中
                [self apartNewMsgToArray];
                //查看是否有旧消息，进行合并
                [self loadHistoryMessageAndSaveToLocal];
                
                //遍历整个本地字典，拿到消息数之和，返回给侧边栏
                
                msgNum.text = [self getNewMessageNum];
                msgNumBg.hidden = NO;
                //                ENDLOADING;
            }else{
                //遍历本地消息，取出未读数相加返回
                NSFileManager * fileManager = [[NSFileManager alloc] init];
                if ([fileManager fileExistsAtPath:path]) {
                    NSString * num = [self getNewMessageNum];
                    if ([num intValue]) {
                        msgNum.text = num;
                        msgNumBg.hidden = NO;
                    }else{
                        msgNumBg.hidden = YES;
                    }
                    
                    
                }else{
                    msgNum.text = @"0";
                    msgNumBg.hidden = YES;
                }
                //返回
                
                //                ENDLOADING;
                
            }
            
            
        }else{
            //            LOADFAILED;
        }
    }];
    [request release];
}
#pragma mark -
-(void)loadHistoryMessageAndSaveToLocal
{
    NSFileManager * manager = [[NSFileManager alloc] init];
    NSString * docDir = DOCDIR;
    NSString * path = [docDir stringByAppendingPathComponent:@"talkData.plist"];
    if ([manager fileExistsAtPath:path]) {
        //文件存在
        NSLog(@"文件存在");
        
        NSMutableDictionary * totalDict = [NSMutableDictionary dictionaryWithDictionary:[MyControl returnDictionaryWithDataPath:path]];
        
        NSArray * oldTalkIDArray = [totalDict allKeys];
        
        
        //合并
        for (int i=0; i<self.talkIDArray.count; i++) {
            NSString * key = self.talkIDArray[i];
            
            if (oldTalkIDArray.count) {
                for (int j=0; j<oldTalkIDArray.count; j++) {
                    
                    
                    if ([key isEqualToString:oldTalkIDArray[j]]) {
                        //找到相同对话，合并
                        SingleTalkModel * model = [totalDict objectForKey:key];
                        NSMutableArray * oldMsgArray = [NSMutableArray arrayWithArray:[model.msgDict objectForKey:@"msg"]];
                        //
                        SingleTalkModel * newModel = self.nwMsgDataArray[i];
                        NSArray * newArray = [newModel.msgDict objectForKey:@"msg"];
                        
                        //1.合并消息
                        
                        [oldMsgArray addObjectsFromArray:newArray];
                        model.msgDict = [NSDictionary dictionaryWithObject:oldMsgArray forKey:@"msg"];
                        //2.合并未读消息数
                        model.unReadMsgNum = [NSString stringWithFormat:@"%d", [model.unReadMsgNum intValue] + [newModel.unReadMsgNum intValue]];
                        //3.更新usr_tx
                        model.usr_tx = newModel.usr_tx;
                        //4.更新usr_name
                        model.usr_name = newModel.usr_name;
                        
                        //合并完毕
                        break;
                    }else if(j == oldTalkIDArray.count-1){
                        //将新的添加
                        [totalDict setObject:self.nwMsgDataArray[i] forKey:key];
                    }
                }
            }else{
                [totalDict setObject:self.nwMsgDataArray[i] forKey:key];
            }
            
        }
        //新旧消息全部合并完毕，重新存储到本地
        //        NSLog(@"%@", totalDict);
        NSData * data = [MyControl returnDataWithDictionary:totalDict];
        BOOL a = [data writeToFile:path atomically:YES];
        NSLog(@"---存储合并后数据结果:%d", a);
    }else{
        //本地没有文件
        //存到本地
        NSMutableDictionary * newDataDict = [NSMutableDictionary dictionaryWithCapacity:0];
        for (int i=0; i<self.talkIDArray.count; i++) {
            [newDataDict setObject:self.nwMsgDataArray[i] forKey:self.talkIDArray[i]];
        }
        NSString * docDir = DOCDIR;
        NSString * path = [docDir stringByAppendingPathComponent:@"talkData.plist"];
        
        //        NSLog(@"%@", newDataDict);
        //dict-->NSData
        NSData * data = [MyControl returnDataWithDictionary:newDataDict];
        BOOL a = [data writeToFile:path atomically:YES];
        NSLog(@"---存储新数据结果:%d", a);
    }
}

#pragma mark - getNewMessageNum
-(NSString *)getNewMessageNum
{
    NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
    NSDictionary * dict = [MyControl returnDictionaryWithDataPath:path];
    //    NSLog(@"%@", dict);
    int num = 0;
    NSArray * array = [dict allKeys];
    for (int i=0; i<array.count; i++) {
        SingleTalkModel * model = [dict objectForKey:array[i]];
        num += [model.unReadMsgNum intValue];
    }
    return [NSString stringWithFormat:@"%d", num];
}
#pragma mark -
-(void)apartNewMsgToArray
{
    for (int i=0; i<self.nwDataArray.count; i++) {
        //创建对象
        SingleTalkModel * talkModel = [[SingleTalkModel alloc] init];
        
        
        //分析数据
        //1.获得talk_id,添加到数组
        NSString * talkID = [[self.nwDataArray[i] allKeys] objectAtIndex:0];
        [self.talkIDArray addObject:talkID];
        
        
        NSDictionary * dict = [self.nwDataArray[i] objectForKey:talkID];
        //2.usr_id添加到userIDArray
        talkModel.usr_id = [dict objectForKey:@"usr_id"];
        
        
        
        //3.头像，添加到数组
        if ([[dict objectForKey:@"usr_tx"] isKindOfClass:[NSNull class]]) {
            talkModel.usr_tx = @"";
            
        }else{
            talkModel.usr_tx = [dict objectForKey:@"usr_tx"];
            
        }
        
        //4.姓名，添加到数组
        if ([[dict objectForKey:@"usr_name"] isKindOfClass:[NSNull class]] || [[dict objectForKey:@"usr_name"] length] == 0) {
            if ([[dict objectForKey:@"usr_id"] intValue] == 1) {
                talkModel.usr_name = @"事务官"; //狗
                talkModel.usr_tx = @"1";
                
            }else if([[dict objectForKey:@"usr_id"] intValue] == 2){
                talkModel.usr_name = @"联络官"; //猫
                talkModel.usr_tx = @"2";
                
            }else if([[dict objectForKey:@"usr_id"] intValue] == 3){
                talkModel.usr_name = @"顺风小鸽";
                talkModel.usr_tx = @"3";
                
            }
        }else{
            talkModel.usr_name = [dict objectForKey:@"usr_name"];
            
        }
        
        //5.新消息数
        NSNumber * number = [dict objectForKey:@"new_msg"];
        talkModel.unReadMsgNum = [NSString stringWithFormat:@"%@", number];
        
        //6.新消息的时间self.keysArray
        //7.新消息的内容self.valuesArray
        [self analysisData:[dict objectForKey:@"msg"] usrId:[dict objectForKey:@"usr_id"] talkModel:talkModel];
        //
        [self.nwMsgDataArray addObject:talkModel];
        
    }
}
-(void)analysisData:(NSDictionary *)dict usrId:(NSString *)usrID talkModel:(SingleTalkModel *)model
{
    
    NSMutableArray * tempNewMsgArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.keysArray removeAllObjects];
    [self.valuesArray removeAllObjects];
    //keysArray赋值
    for (NSString * key in [dict allKeys]) {
        [self.keysArray addObject:key];
    }
    
    //key值数组冒泡排序
    for (int i=0; i<self.keysArray.count; i++) {
        for (int j=0; j<self.keysArray.count-i-1; j++) {
            if ([self.keysArray[j] intValue] > [self.keysArray[j+1] intValue]) {
                NSString * str = [NSString stringWithFormat:@"%@", self.keysArray[j]];
                NSString * str1 = [NSString stringWithFormat:@"%@", self.keysArray[j+1]];
                self.keysArray[j] = str1;
                self.keysArray[j+1] = str;
            }
        }
    }
    //    NSLog(@"%@", self.keysArray);
    for (int i=0;i<self.keysArray.count;i++) {
        //        NSLog(@"key:%@--value:%@", self.keysArray[i], [dict objectForKey:self.keysArray[i]]);
        MessageModel * msgModel = [[MessageModel alloc] init];
        msgModel.time = self.keysArray[i];
        msgModel.usr_id = usrID;
        
        NSString * msg = [dict objectForKey:self.keysArray[i]];
        NSLog(@"%@", msg);
        if ([msg rangeOfString:@"["].location != NSNotFound && [msg rangeOfString:@"]"].location != NSNotFound) {
            int x = [msg rangeOfString:@"]"].location;
            
            msgModel.msg = [msg substringFromIndex:x+1];
            msgModel.img_id = [msg substringWithRange:NSMakeRange(1, x)];
        }else{
            msgModel.msg = msg;
            msgModel.img_id = @"0";
        }
        [tempNewMsgArray addObject:msgModel];
        [msgModel release];
        //        [self.valuesArray addObject:msg];
    }
    //
    model.msgDict = [NSDictionary dictionaryWithObject:tempNewMsgArray forKey:@"msg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
