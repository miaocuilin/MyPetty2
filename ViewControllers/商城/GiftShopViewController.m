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
@interface GiftShopViewController ()

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
    self.cateArray = [NSMutableArray arrayWithObjects:@"全部", @"新品", @"热卖", @"推荐", nil];
    self.cateArray2 = [NSMutableArray arrayWithObjects:@"喵喵专用", @"汪汪专用", nil];
    self.orderArray = [NSMutableArray arrayWithObjects:@"由高到低", @"由低到高", nil];
    
    [self createBg];
    [self createFakeNavigation];
    [self createHeader];
    [self createUI];
    [self createBottom];
    
    [self createAlphaBtn];
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
    
    UIImageView * greenBall = [MyControl createImageViewWithFrame:CGRectMake(13, -5, 15, 15) ImageName:@"greenBall.png"];
    [giftImageView addSubview:greenBall];
    
    UILabel * giftNum = [MyControl createLabelWithFrame:CGRectMake(-5, 0, 25, 15) Font:9 Text:@"107"];
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
-(void)giftBagBtnClick
{
    NSLog(@"跳转到背包");
//    UserInfoViewController * vc = [[UserInfoViewController alloc] init];
//    vc.offset = 320*3;
//    [self presentViewController:vc animated:YES completion:nil];
//    [vc release];
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
    
    cateBtn = [MyControl createButtonWithFrame:CGRectMake(35, 5, 90, 25) ImageName:@"" Target:self Action:@selector(cateBtnClick) Title:@"全部"];
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
-(void)createUI
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-40)];
    sv.contentSize = CGSizeMake(320, 64+35+15+(30/3)*100);
    [self.view addSubview:sv];
    
    [self.view bringSubviewToFront:navView];
    [self.view bringSubviewToFront:headerView];
    
    for(int i=0;i<3*10;i++){
        CGRect rect = CGRectMake(20+i%3*100, 64+35+15+i/3*100, 85, 90);
        UIImageView * imageView = [MyControl createImageViewWithFrame:rect ImageName:@"giftBg.png"];
        [sv addSubview:imageView];
        
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
        
        UILabel * giftName = [MyControl createLabelWithFrame:CGRectMake(0, 5, 85, 15) Font:11 Text:@"汪汪项圈"];
        giftName.textColor = [UIColor grayColor];
        giftName.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:giftName];
        
        UIImageView * giftPic = [MyControl createImageViewWithFrame:CGRectMake(20, 20, 45, 45) ImageName:[NSString stringWithFormat:@"bother%d_2.png", arc4random()%6+1]];
        [imageView addSubview:giftPic];
        
        UIImageView * gift = [MyControl createImageViewWithFrame:CGRectMake(20, 90-14-5, 15, 15) ImageName:@"gold.png"];
        [imageView addSubview:gift];
        
        UILabel * giftNum = [MyControl createLabelWithFrame:CGRectMake(42, 90-19, 40, 15) Font:13 Text:[NSString stringWithFormat:@"%d", i*50+50]];
        giftNum.textColor = BGCOLOR;
        [imageView addSubview:giftNum];
        
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
    }
    
    /******************************/
    
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
    NSLog(@"点击了虚拟礼物第%d个", btn.tag-1000+1);
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
    
    UILabel * gold = [MyControl createLabelWithFrame:CGRectMake(MyGold.frame.origin.x+size.width, 10, 100, 20) Font:15 Text:@"20000"];
    gold.textColor = BGCOLOR;
    [view addSubview:gold];
    
    UIButton * moreGold = [MyControl createButtonWithFrame:CGRectMake(220, (40-25)/2.0, 90, 25) ImageName:@"" Target:self Action:@selector(moreGoldClick) Title:@"更多金币"];
    moreGold.titleLabel.font = [UIFont systemFontOfSize:15];
    moreGold.backgroundColor = BGCOLOR;
    moreGold.layer.cornerRadius = 5;
    moreGold.layer.masksToBounds = YES;
    moreGold.showsTouchWhenHighlighted = YES;
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
