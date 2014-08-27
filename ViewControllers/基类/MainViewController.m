//
//  MainViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MainViewController.h"
#import "RandomViewController.h"
#import "FavoriteViewController.h"
#import "SquareViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

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
    [self createScrollView];
    [self createFakeNavigation];
    [self createViewControllers];
    [self createSegment];
}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    self.menuBtn = [MyControl createButtonWithFrame:CGRectMake(17, 30, 82/2, 54/2) ImageName:@"menu.png" Target:self Action:@selector(menuBtnClick:) Title:nil];
    self.menuBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:self.menuBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 32, 200, 20) Font:17 Text:@"宠物星球"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}
-(void)menuBtnClick:(UIButton *)button
{
    
    button.selected = !button.selected;
    JDSideMenu * menu = [ControllerManager shareJDSideMenu];
    if (button.selected) {
        //截屏
        UIImage * image = [MyControl imageWithView:[UIApplication sharedApplication].keyWindow];
        UIImage * image2 = [image applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
        [MyControl saveScreenshotsWithImage:image2];
//        [UIView animateWithDuration:0.1 animations:^{
//            [MyControl saveScreenshotsWithView:[UIApplication sharedApplication].keyWindow];
//        }];
        
        [menu showMenuAnimated:YES];
    }else{
        [menu hideMenuAnimated:YES];
    }
}
-(void)createScrollView
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    sv.delegate = self;
    sv.contentSize = CGSizeMake(320*3, self.view.frame.size.height);
    sv.contentOffset = CGPointMake(320, 0);
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:sv];
}
-(void)createViewControllers
{
    RandomViewController * rvc = [[RandomViewController alloc] init];
    [self addChildViewController:rvc];
    [rvc.view setFrame:CGRectMake(320, 0, 320, self.view.frame.size.height)];
    [sv addSubview:rvc.view];
}
-(void)createSegment
{
    NSArray * scArray = @[@"萌宠推荐", @"宇宙广场", @"星球关注"];
    sc = [[UISegmentedControl alloc] initWithItems:scArray];
    sc.backgroundColor = [UIColor whiteColor];
    sc.alpha = 0.7;
    sc.layer.cornerRadius = 4;
    sc.layer.masksToBounds = YES;
    sc.frame = CGRectMake(10, 69, 300, 30);
    [sc addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    //默认选中第二个，宇宙广场
    sc.selectedSegmentIndex = 1;
    sc.tintColor = BGCOLOR;
    [self.view addSubview:sc];
}
-(void)segmentClick:(UISegmentedControl *)seg
{
    int a = sc.selectedSegmentIndex;
    if (a == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            sv.contentOffset = CGPointMake(0, 0);
        }];
    }else if(a == 1){
        [UIView animateWithDuration:0.3 animations:^{
            sv.contentOffset = CGPointMake(320, 0);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            sv.contentOffset = CGPointMake(320*2, 0);
        }];
    }
}
#pragma mark - scrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int a = sv.contentOffset.x;
    sc.selectedSegmentIndex = a/320;
    
    if (a == 0) {
        if (isCreated[0] == NO) {
            isCreated[0] = YES;
            SquareViewController * svc = [[SquareViewController alloc] init];
            [self addChildViewController:svc];
            [svc.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            [sv addSubview:svc.view];
            [self.view bringSubviewToFront:sc];
        }
    }else if(a == 320*2){
        if (isCreated[2] == NO) {
            isCreated[2] = YES;
            FavoriteViewController * fvc = [[FavoriteViewController alloc] init];
            [self addChildViewController:fvc];
            [fvc.view setFrame:CGRectMake(320*2, 0, 320, self.view.frame.size.height)];
            [sv addSubview:fvc.view];
            [self.view bringSubviewToFront:sc];
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0) {
        if (isCreated[0] == NO) {
            isCreated[0] = YES;
            SquareViewController * svc = [[SquareViewController alloc] init];
            [self addChildViewController:svc];
            [svc.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            [sv addSubview:svc.view];
            [self.view bringSubviewToFront:sc];
        }
    }else if(scrollView.contentOffset.x == 320*2){
        if (isCreated[2] == NO) {
            isCreated[2] = YES;
            FavoriteViewController * fvc = [[FavoriteViewController alloc] init];
            [self addChildViewController:fvc];
            [fvc.view setFrame:CGRectMake(320*2, 0, 320, self.view.frame.size.height)];
            [sv addSubview:fvc.view];
            [self.view bringSubviewToFront:sc];
        }
    }
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
