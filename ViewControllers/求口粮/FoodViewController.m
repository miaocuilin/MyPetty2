//
//  FoodViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/2.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "FoodViewController.h"
#import "FoodCell.h"
#import "BegFoodListModel.h"
#import "PetInfoViewController.h"
#import "UserInfoViewController.h"
#import "Alert_2ButtonView2.h"
#import "ChargeViewController.h"
@interface FoodViewController ()

@end

@implementation FoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createFakeNavigation];
    
    [self createReward];
    
    [self createTableView];
//    [self createBottom];
    [self loadData];
    
//    isLoaded = YES;
}

-(void)loadData
{
    LOADING;
//    if (isLoaded) {
//        [UIView animateWithDuration:0.2 animations:^{
//            tv.contentOffset = CGPointMake(0, 0);
//        }];
//    }
    page = 0;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"page=%ddog&cat", page]];
    NSString * url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", BEGFOODAPI, page, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"%@", load.dataDict);
            [self.dataArray removeAllObjects];
            if (![[[load.dataDict objectForKey:@"data"] objectAtIndex:0] isKindOfClass:[NSArray class]] || [[[load.dataDict objectForKey:@"data"] objectAtIndex:0] count] == 0) {
                ENDLOADING;
                return;
            }
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                BegFoodListModel * model = [[BegFoodListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                [model release];
            }
            page++;
            [tv reloadData];
            
            [UIView animateWithDuration:0.2 animations:^{
                tv.contentOffset = CGPointMake(0, 0);
            }];
            
            [self refreshHeader:0];
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)loadMoreData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"page=%ddog&cat", page]];
    NSString * url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", BEGFOODAPI, page, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if (![[[load.dataDict objectForKey:@"data"] objectAtIndex:0] isKindOfClass:[NSArray class]]) {
//                ENDLOADING;
                return;
            }
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            if (!array.count) {
                return;
            }
            for (NSDictionary * dict in array) {
                BegFoodListModel * model = [[BegFoodListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                [model release];
            }
            page++;
            [tv reloadData];
//            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)createFakeNavigation
{
    UIImageView * image = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.png"];
    [self.view addSubview:image];
    
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    petHeadBtn = [MyControl createButtonWithFrame:CGRectMake(25, 20, 38, 38) ImageName:@"defaultPetHead.png" Target:self Action:@selector(headBtnClick) Title:nil];
    petHeadBtn.layer.cornerRadius = 19;
    petHeadBtn.layer.masksToBounds = YES;
    [navView addSubview:petHeadBtn];
    
    sex = [MyControl createImageViewWithFrame:CGRectMake(70, petHeadBtn.frame.origin.y+5, 13, 13) ImageName:@"man.png"];
    [navView addSubview:sex];
    
    petName = [MyControl createLabelWithFrame:CGRectMake(sex.frame.origin.x+15, petHeadBtn.frame.origin.y+5, 200, 15) Font:13 Text:nil];
    [navView addSubview:petName];
    
    petType = [MyControl createLabelWithFrame:CGRectMake(sex.frame.origin.x, 40, 100, 15) Font:11 Text:nil];
    [navView addSubview:petType];
    
    userHeadImage = [MyControl createImageViewWithFrame:CGRectMake(navView.frame.size.width-20-13, 77/2, 20, 20) ImageName:@"defaultUserHead.png"];
    userHeadImage.layer.cornerRadius = 10;
    userHeadImage.layer.masksToBounds = YES;
    [navView addSubview:userHeadImage];
    
    userName = [MyControl createLabelWithFrame:CGRectMake(userHeadImage.frame.origin.x-155, userHeadImage.frame.origin.y+2.5, 150, 15) Font:11 Text:nil];
    userName.textAlignment = NSTextAlignmentRight;
    [navView addSubview:userName];
    
    jumpUserBtn = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-100, userHeadImage.frame.origin.y, 100, 20) ImageName:@"" Target:self Action:@selector(jumpUserClick) Title:nil];
    [navView addSubview:jumpUserBtn];
}
-(void)createReward
{
    //587  98
    rewardBg = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-569/2)/2.0, self.view.frame.size.height-50-103/2-20, 569/2, 103/2) ImageName:@"food_rewardBg.png"];
    [self.view addSubview:rewardBg];
    
    rewardNum = [MyControl createLabelWithFrame:CGRectMake(22, 0, 50, rewardBg.frame.size.height) Font:17 Text:@"1"];
    rewardNum.font = [UIFont boldSystemFontOfSize:17];
    rewardNum.textAlignment = NSTextAlignmentCenter;
    [rewardBg addSubview:rewardNum];
    
    
    
    UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(218/2, (rewardBg.frame.size.height-31/2)/2.0, 18/2, 31/2) ImageName:@"rightArrow.png"];
    [rewardBg addSubview:arrow];
    
    UIImageView * food = [MyControl createImageViewWithFrame:CGRectMake(arrow.frame.origin.x-35, (rewardBg.frame.size.height-25)/2.0, 25, 25) ImageName:@"exchange_orangeFood.png"];
    [rewardBg addSubview:food];
    
    //10 100 1000
    selectView = [MyControl createViewWithFrame:CGRectMake(rewardBg.frame.origin.x+20, rewardBg.frame.origin.y-105, 113, 105)];
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
    
    UIButton * rewardBtn = [MyControl createButtonWithFrame:CGRectMake(rewardBg.frame.size.width/2.0, 0, rewardBg.frame.size.width/2.0, rewardBg.frame.size.height) ImageName:@"" Target:self Action:@selector(rewardBtnClick:) Title:@"赏"];
    rewardBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [rewardBg addSubview:rewardBtn];
}
#pragma mark - 
-(void)createTableView
{
//    -25, 70+25, rewardBg.frame.origin.y-70-10, self.view.frame.size.width
    tv = [[UITableView alloc] initWithFrame:CGRectMake(20, 70-18, rewardBg.frame.origin.y-70-10, self.view.frame.size.width) style:UITableViewStylePlain];
    NSLog(@"%f--%f", self.view.frame.size.width/self.view.frame.size.height, 320/480.0);
    float a = self.view.frame.size.width/self.view.frame.size.height;
    float b = 320/480.0;
    if (a != b) {
        tv.frame = CGRectMake(-25, 70+25, rewardBg.frame.origin.y-70-10, self.view.frame.size.width);
    }
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    tv.transform = CGAffineTransformMakeRotation(-M_PI/2);
    tv.showsVerticalScrollIndicator = NO;
    tv.separatorStyle = 0;
    tv.pagingEnabled = YES;
    tv.backgroundColor = [UIColor clearColor];
    
    [self.view bringSubviewToFront:selectView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    FoodCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[FoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    BegFoodListModel * model = self.dataArray[indexPath.row];
    [cell modifyUI:model];
    
    
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = 0;
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width;
}
#pragma mark -
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == tv && self.dataArray.count) {
        if (tv.contentOffset.y == (self.dataArray.count-1)*self.view.frame.size.width) {
            [self loadMoreData];
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == tv && self.dataArray.count) {
        int a = tv.contentOffset.y/self.view.frame.size.width;
        [self refreshHeader:a];
    }
}
-(void)refreshHeader:(int)a
{
    //更新顶栏数据
    BegFoodListModel * model = self.dataArray[a];
    
    [petHeadBtn setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PETTXURL, model.tx]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultPetHead.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            [petHeadBtn setBackgroundImage:[MyControl returnSquareImageWithImage:image] forState:UIControlStateNormal];
        }
    }];
    if ([model.gender intValue] == 1) {
        sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    petName.text = model.name;
    petType.text = [ControllerManager returnCateNameWithType:model.type];
    userName.text = [NSString stringWithFormat:@"By %@", model.u_name];
    [userHeadImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL, model.u_tx]] placeholderImage:[UIImage imageNamed:@"defaultUserHead.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            userHeadImage.image = [MyControl returnSquareImageWithImage:image];
        }
    }];
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
            ChargeViewController * charge = [[ChargeViewController alloc] init];
            [self presentViewController:charge animated:YES completion:nil];
            [charge release];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:view2];
        [view2 release];
        return;
    }
    
    if(![[USER objectForKey:@"notShowCostAlert"] intValue] && [rewardNum.text intValue]>[[USER objectForKey:@"food"] intValue]){
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
    int a = tv.contentOffset.y/self.view.frame.size.width;
    
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@&n=%@dog&cat", [self.dataArray[a] img_id], rewardNum.text]];
    NSString * url = [NSString stringWithFormat:@"%@%@&n=%@&sig=%@&SID=%@", REWARDFOODAPI, [self.dataArray[a] img_id], rewardNum.text, sig, [ControllerManager getSID]];
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
                BegFoodListModel * model = self.dataArray[a];
                model.food = [NSString stringWithFormat:@"%@", [[load.dataDict objectForKey:@"data"] objectForKey:@"food"]];
                [MyControl popAlertWithView:self.view Msg:[NSString stringWithFormat:@"打赏成功，萌星 %@ 感谢您的爱心！", [self.dataArray[a] name]]];
                [tv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:a inSection:0]] withRowAnimation:0];
            }
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)headBtnClick
{
    //跳转宠物主页
    PetInfoViewController * vc = [[PetInfoViewController alloc] init];
    int a = tv.contentOffset.y/self.view.frame.size.width;
    vc.aid = [self.dataArray[a] aid];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)jumpUserClick
{
    UserInfoViewController * vc = [[UserInfoViewController alloc] init];
    int a = tv.contentOffset.y/self.view.frame.size.width;
    vc.usr_id = [self.dataArray[a] usr_id];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
//-(void)createBottom
//{
//    UIView * bottomBg = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100)];
//    [self.view addSubview:bottomBg];
//
//    NSArray * selectedArray = @[@"food_myStar_selected", @"food_beg_selected", @"food_discovery_selected", @"food_center_selected"];
//    NSArray * unSelectedArray = @[@"food_myStar_unSelected", @"food_beg_unSelected", @"food_discovery_unSelected", @"food_center_unSelected"];
//    for (int i=0; i<selectedArray.count; i++) {
//        UIImageView * halfBall = [MyControl createImageViewWithFrame:CGRectMake(i*(self.view.frame.size.width/4.0), bottomBg.frame.size.height-28, self.view.frame.size.width/4.0, 28) ImageName:@"food_bottom_halfBall.png"];
//        [bottomBg addSubview:halfBall];
//
//        UIButton * ballBtn = [MyControl createButtonWithFrame:CGRectMake(halfBall.frame.origin.x+halfBall.frame.size.width/2.0-42.5/2.0, bottomBg.frame.size.height-halfBall.frame.size.height-85/4.0, 85/2.0, 85/2.0) ImageName:unSelectedArray[i] Target:self Action:@selector(ballBtnClick:) Title:nil];
//        ballBtn.tag = 100+i;
//
//        [ballBtn setBackgroundImage:[UIImage imageNamed:selectedArray[i]] forState:UIControlStateSelected];
//        [bottomBg addSubview:ballBtn];
//        if (i == 1) {
//            ballBtn.selected = YES;
//        }
//    }
//}

//-(void)ballBtnClick:(UIButton *)btn
//{
//    for (int i=0; i<4; i++) {
//        UIButton * button = (UIButton *)[self.view viewWithTag:100+i];
//        button.selected = NO;
//    }
//    btn.selected = YES;
//    
//    [self ballAnimation:btn];
//    
//    if(btn.tag-100){
//        
//    }else if(btn.tag-100){
//        
//    }else if(btn.tag-100){
//        
//    }else if(btn.tag-100){
//        
//    }
//}
//
////气泡动画
//-(void)ballAnimation:(UIView *)view
//{
//    CGRect rect = view.frame;
//    [UIView animateWithDuration:0.1 animations:^{
//        view.frame = CGRectMake(rect.origin.x-rect.size.width*0.1, rect.origin.y, rect.size.width*1.2, rect.size.height);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.1 animations:^{
//            view.frame = rect;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.1 animations:^{
//                view.frame = CGRectMake(rect.origin.x, rect.origin.y-rect.size.height*0.1, rect.size.width, rect.size.height*1.2);
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.1 animations:^{
//                    view.frame = rect;
//                }];
//            }];
//        }];
//    }];
//}
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
