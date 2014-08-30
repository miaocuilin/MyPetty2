//
//  SquareViewController.m
//  MyPetty
//
//  Created by Aidi on 14-7-31.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "SquareViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface SquareViewController () <CLLocationManagerDelegate>
{
    CLLocationManager * locManager;
}
@end

@implementation SquareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//- (BOOL)shouldAutomaticallyForwardAppearanceMethods
//{
//    return NO;
//}

//-(void)viewWillAppear:(BOOL)animated
//{
//    NSLog(@"1111");
//    
//}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self becomeFirstResponder];
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self createFakeNavigation];
    // Do any additional setup after loading the view.
//    self.menuBgView.frame = CGRectMake(50, self.view.frame.size.height-40, 220, 80);
    
    
    self.view.backgroundColor = [UIColor purpleColor];
    locManager = [[CLLocationManager alloc] init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    locManager.distanceFilter = 500.0;
    [locManager startUpdatingLocation];
    
//    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
//    [self becomeFirstResponder];
    UIButton * button = [MyControl createButtonWithFrame:CGRectMake(110, 150, 100, 50) ImageName:@"" Target:self Action:@selector(buttonClick) Title:@"重新定位"];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];

    
    [self.view addSubview:test];
    
}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(17, 30, 82/2, 54/2) ImageName:@"menu.png" Target:self Action:@selector(menuBtnClick:) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
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
        [menu showMenuAnimated:YES];
    }else{
        [menu hideMenuAnimated:YES];
    }
}
//-(UIImage *)imageWithView:(UIView *)view {
//    
//    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, view.opaque, [[UIScreen mainScreen] scale]);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    
//    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return backgroundImage;
//}
-(void)buttonClick
{
//    [MyControl saveScreenshotsWithView:[UIApplication sharedApplication].keyWindow];
    [locManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"纬度:%f 经度:%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
    [locManager stopUpdatingLocation];
}

//-(BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
//-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    NSLog(@"11111111111");
//    if (motion == UIEventSubtypeMotionShake) {
//        NSLog(@"11111111111");
//    }
//    NSLog(@"11111111111");
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
