//
//  MainTabBarViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-19.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "RandomViewController.h"
#import "FavoriteViewController.h"
#import "SquareViewController.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RandomViewController * rvc = [[RandomViewController alloc] init];
    FavoriteViewController * fvc = [[FavoriteViewController alloc] init];
    SquareViewController * svc = [[SquareViewController alloc] init];
//    tbc = [[UITabBarController alloc] init];

    self.viewControllers = @[svc, rvc, fvc];
    self.selectedIndex = 1;
    self.tabBar.hidden = YES;
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
    [rvc.view addSubview:sc];
}
-(void)segmentClick:(UISegmentedControl *)seg
{
    NSLog(@"%d", seg.selectedSegmentIndex);
    int a = seg.selectedSegmentIndex;
    self.selectedIndex = a;
    UIViewController * vc = self.viewControllers[a];
    [vc.view addSubview:sc];
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
