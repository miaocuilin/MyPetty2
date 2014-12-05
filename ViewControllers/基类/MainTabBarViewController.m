//
//  MainTabBarViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-19.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MainTabBarViewController.h"

#import "MyStarViewController.h"
#import "FoodViewController.h"
#import "DiscoveryViewController.h"
#import "CenterViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    if (!isLoaded) {
        [self makeUI];
        [self modifyUI];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    isLoaded = YES;
}
- (void)viewDidLoad
{
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
    UIView * bottomBg = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
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
    }
}
-(void)ballBtnClick:(UIButton *)btn
{
    [self ballAnimation:btn];
    
    if (![[USER objectForKey:@"isSuccess"] intValue] && btn.tag == 100) {
        ShowAlertView;
        return;
    }
    
    for (int i=0; i<4; i++) {
        UIButton * button = (UIButton *)[self.view viewWithTag:100+i];
        button.selected = NO;
    }
    btn.selected = YES;
    
//    NSLog(@"------%d", self.selectedIndex);
    if (btn.tag == 101 && self.selectedIndex == 1) {
        FoodViewController * vc = self.viewControllers[1];
        [vc loadData];
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




//-(void)segmentClick:(UISegmentedControl *)seg
//{
//    NSLog(@"%d", seg.selectedSegmentIndex);
//    int a = seg.selectedSegmentIndex;
//    self.selectedIndex = a;
//    UIViewController * vc = self.viewControllers[a];
//    [vc.view addSubview:sc];
//}
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
