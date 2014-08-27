//
//  BottomMenuBaseViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-13.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "BottomMenuBaseViewController.h"

@interface BottomMenuBaseViewController ()
{
    BOOL isOpen;
    UIImageView * imageView;
}


@end

@implementation BottomMenuBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%f", self.view.frame.size.height);
    int a = self.view.frame.size.height;
    if (a == 568.0) {
        //适配4寸，调整控件坐标
        self.menuBgView.frame = CGRectMake(50, 568-120, 220, 160);
//        self.menuBgView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        imageView.frame = CGRectMake(0, 0, 320, a);
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"%f", self.view.frame.size.height);
//    imageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"cat2.jpg"];
//    [self.view addSubview:imageView];
    [self.view bringSubviewToFront:self.menuBgBtn];
    [self.view bringSubviewToFront:self.menuBgView];
    //yanse
//    self.menuBgView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    
    self.headBtn.layer.cornerRadius = 40;
    self.headBtn.layer.masksToBounds = YES;
    self.button1.layer.cornerRadius = 20;
    self.button1.layer.masksToBounds = YES;
    self.button2.layer.cornerRadius = 20;
    self.button2.layer.masksToBounds = YES;
    self.button3.layer.cornerRadius = 20;
    self.button3.layer.masksToBounds = YES;
    self.button4.layer.cornerRadius = 20;
    self.button4.layer.masksToBounds = YES;
    
    self.menuBgBtn.backgroundColor = [UIColor blackColor];
    self.menuBgBtn.alpha = 0;
    self.menuBgBtn.hidden = YES;
    
    
}

- (IBAction)menuBgBtnClick:(id)sender {
    if (self.menuBgView.frame.origin.y == self.view.frame.size.height-160) {
        [self hideAll];
    }
}

- (IBAction)headBtnClick:(id)sender {
    if (isOpen) {
        [self hideAll];
    }else{
        [self showAll];
    }
//    if (self.menuBgView.frame.origin.y == self.view.frame.size.height-120) {
//        [self showBall];
//    }else if(self.menuBgView.frame.origin.y == self.view.frame.size.height-160){
//        if (isOpen) {
//            [self hideButtons];
//        }else{
//            [self showButtons];
//        }
//    }
}
//弹出4个按钮
//-(void)showButtons
//{
//    
//    isOpen = YES;
//    [UIView animateWithDuration:0.2 animations:^{
//        self.button1.frame = CGRectMake(20, 40, 40, 40);
//        self.button2.frame = CGRectMake(60, 0, 40, 40);
//        self.button3.frame = CGRectMake(120, 0, 40, 40);
//        self.button4.frame = CGRectMake(160, 40, 40, 40);
//    }];
//}
//隐藏4个按钮
//-(void)hideButtons
//{
//    isOpen = NO;
//    [UIView animateWithDuration:0.2 animations:^{
//        self.button1.frame = CGRectMake(90, 100, 40, 40);
//        self.button2.frame = CGRectMake(90, 100, 40, 40);
//        self.button3.frame = CGRectMake(90, 100, 40, 40);
//        self.button4.frame = CGRectMake(90, 100, 40, 40);
//    }];
//    
//}
//-(void)showBall
//{
//    //弹出头像
//    self.menuBgBtn.hidden = NO;
//    [UIView animateWithDuration:0.2 animations:^{
//        self.menuBgBtn.alpha = 0.5;
//        self.menuBgView.frame = CGRectMake(50, self.view.frame.size.height-160, 220, 160);
//    }];
//}
-(void)hideBall
{
    [UIView animateWithDuration:0.2 animations:^{
        self.menuBgBtn.alpha = 0;
        self.menuBgView.frame = CGRectMake(50, self.view.frame.size.height-120, 220, 160);
    } completion:^(BOOL finished) {
        self.menuBgBtn.hidden = YES;
    }];
}
-(void)showAll
{
    isOpen = YES;
    self.menuBgBtn.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.menuBgBtn.alpha = 0.5;
        self.menuBgView.frame = CGRectMake(50, self.view.frame.size.height-160, 220, 160);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.button1.frame = CGRectMake(20, 80, 40, 40);
            self.button2.frame = CGRectMake(60, 20, 40, 40);
            self.button3.frame = CGRectMake(120, 20, 40, 40);
            self.button4.frame = CGRectMake(160, 80, 40, 40);
            
            self.label1.frame = CGRectMake(20, 120, 40, 15);
            self.label2.frame = CGRectMake(60, 60, 40, 15);
            self.label3.frame = CGRectMake(120, 60, 40, 15);
            self.label4.frame = CGRectMake(160, 120, 40, 15);
        }];
    }];
    
}
-(void)hideAll
{
//    if (isOpen) {
        isOpen = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.button1.frame = CGRectMake(90, 100, 40, 40);
            self.button2.frame = CGRectMake(90, 100, 40, 40);
            self.button3.frame = CGRectMake(90, 100, 40, 40);
            self.button4.frame = CGRectMake(90, 100, 40, 40);
            
            self.label1.frame = CGRectMake(90, 140, 40, 15);
            self.label2.frame = CGRectMake(90, 140, 40, 15);
            self.label3.frame = CGRectMake(90, 140, 40, 15);
            self.label4.frame = CGRectMake(90, 140, 40, 15);
        } completion:^(BOOL finished) {
            [self hideBall];
        }];
//    }else{
//        [self hideBall];
//    }
}

- (IBAction)btn1Click:(id)sender {
    NSLog(@"1111");
    [self hideAll];
}
- (IBAction)btn2Click:(id)sender {
    NSLog(@"2222");
    [self hideAll];
}
- (IBAction)btn3Click:(id)sender {
    NSLog(@"3333");
    [self hideAll];
}
- (IBAction)btn4Click:(id)sender {
    NSLog(@"4444");
    [self hideAll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_menuBgView release];
    [_button1 release];
    [_button2 release];
    [_button3 release];
    [_button4 release];
    [_headBtn release];
    [_menuBgBtn release];
    [_label1 release];
    [_label2 release];
    [_label3 release];
    [_label4 release];
    [super dealloc];
}
@end
