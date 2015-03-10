//
//  ChooseInViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-1.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ChooseInViewController.h"
#import "RegisterViewController.h"
#import "ChooseFamilyViewController.h"
#import "HyperlinksButton.h"
#import "PermitViewController.h"
@interface ChooseInViewController ()

@end

@implementation ChooseInViewController

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
    [super viewDidAppear:animated];
    if ([[USER objectForKey:@"isChooseInShouldDismiss"] intValue]) {
        [USER setObject:@"0" forKey:@"isChooseInShouldDismiss"];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!self.isFromAdd) {
        [MobClick event:@"register_choose"];
    }
    
    if ([[USER objectForKey:@"planet"] intValue] == 1) {
        self.isMi = YES;
    }
    
    [self createUI];
}

-(void)createUI
{
    UIImageView * bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"blurBg.jpg"];
    [self.view addSubview:bgImageView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 18/2, 31/2) ImageName:@"choosein_back2.png"];
    [self.view addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:backBtn];
    
    float w = 159*0.6;
    float h = 97*0.6;
    UIImageView * icon = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-w)/2.0, 100, w, h) ImageName:@"choosein_icon.png"];
    [self.view addSubview:icon];
    /******************************/
    
    UIButton * haveBtn = [MyControl createButtonWithFrame:CGRectMake((self.view.frame.size.width-520/2)/2.0, self.view.frame.size.height-530/2.0, 520/2, 123/2) ImageName:@"has_star.jpg" Target:self Action:@selector(haveBtnClick) Title:nil];
    [self.view addSubview:haveBtn];
    /************Wa*************/

    
    UIButton * notHaveBtn = [MyControl createButtonWithFrame:CGRectMake((self.view.frame.size.width-520/2)/2.0, self.view.frame.size.height-348/2.0, 520/2, 123/2) ImageName:@"no_star.jpg" Target:self Action:@selector(notHaveBtnClick) Title:nil];
    [self.view addSubview:notHaveBtn];
    /******************************/

    
    shakeBgView = [MyControl createViewWithFrame:CGRectMake(notHaveBtn.frame.origin.x, notHaveBtn.frame.origin.y+117/2+5, 300, 20)];
    [self.view addSubview:shakeBgView];
    
    rightBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 20, 20) ImageName:@"atUsers_unSelected.png" Target:self Action:@selector(rightBtnClick:) Title:nil];
    [rightBtn setImage:[UIImage imageNamed:@"atUsers_selected.png"] forState:UIControlStateSelected];
    
//    rightBtn.selected = YES;
    [shakeBgView addSubview:rightBtn];
    
    UILabel * label = [MyControl createLabelWithFrame:CGRectMake(rightBtn.frame.origin.x+25, rightBtn.frame.origin.y, 200, 20) Font:12 Text:@"我已经阅读并同意"];
    [shakeBgView addSubview:label];

    CGSize size = [label.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    
    NSString * str = @"《用户协议》";
    CGSize size2 = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    
    HyperlinksButton * hyperBtn = [[HyperlinksButton alloc] initWithFrame:CGRectMake(label.frame.origin.x+size.width, label.frame.origin.y+4, size2.width, size2.height)];
    [hyperBtn setColor:[UIColor colorWithRed:85/255.0 green:134/255.0 blue:156/255.0 alpha:1]];
    [hyperBtn setTitleColor:[UIColor colorWithRed:85/255.0 green:134/255.0 blue:156/255.0 alpha:1] forState:UIControlStateNormal];
    hyperBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [hyperBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [hyperBtn addTarget:self action:@selector(hyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    hyperBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [shakeBgView addSubview:hyperBtn];
    
    if (self.isFromAdd) {
        rightBtn.selected = YES;
        rightBtn.hidden = YES;
        label.hidden = YES;
        hyperBtn.hidden = YES;
    }
    
}
-(void)hyBtnClick
{
//    NSLog(@"111111");
    PermitViewController * vc = [[PermitViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)rightBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
}
- (void)animateIncorrectPassword:(UIView *)view {
    // Clear the password field
    
    // Animate the alert to show that the entered string was wrong
    // "Shakes" similar to OS X login screen
    CGAffineTransform moveRight = CGAffineTransformTranslate(CGAffineTransformIdentity, 5, 0);
    CGAffineTransform moveLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -5, 0);
    CGAffineTransform resetTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    
    CGAffineTransform transform = CGAffineTransformIdentity;   //申明旋转量
    transform = CGAffineTransformMakeRotation(-M_PI/2);     //设置旋转量具体值
    
    [UIView animateWithDuration:0.05 animations:^{
        // Translate left
        view.transform = moveLeft;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.05 animations:^{
            
            // Translate right
            view.transform = moveRight;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.05 animations:^{
                
                // Translate left
                view.transform = moveLeft;
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.05 animations:^{
                    
                    // Translate to origin
                    view.transform = resetTransform;
                }];
            }];
            
        }];
    }];
    
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)switchBtnClick
{
    if (_isMi) {
        [self throughPlanet:2];
//        _isMi = NO;
        NSLog(@"切换到汪星");
    }else{
        [self throughPlanet:1];
//        _isMi = YES;
        NSLog(@"切换到喵星");
    }
    //注意以下两种方法的区别
//    for (UIView * view in self.view.subviews) {
//        [view removeFromSuperview];
//    }
//    for (int i=0; i<8; i++) {
//        [self.view.subviews[0] removeFromSuperview];
//    }
//    [self createUI];
}
#pragma mark - 穿越
-(void)throughPlanet:(int)planet
{
    StartLoading;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"planet=%ddog&cat", planet]];
    NSString * url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", THROUGHAPI, planet, sig, [USER objectForKey:@"SID"]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            //            if ([[load.dataDict objectForKey:@"isSuccess"] intValue]) {
            //
            //            }
            if (_isMi) {
                _isMi = NO;
                [USER setObject:@"2" forKey:@"planet"];
            }else{
                _isMi = YES;
                [USER setObject:@"1" forKey:@"planet"];
            }
            for (UIView * view in self.view.subviews) {
                [view removeFromSuperview];
            }
            [self createUI];
            [MMProgressHUD dismissWithSuccess:@"切换成功" title:nil afterDelay:0.2];
        }else{
            LoadingFailed;
        }
    }];
    [request release];
}

//-(void)updateAmbassadorMessage
//{
//    if (num == self.ambString.length+1) {
//        [Timer invalidate];
//        Timer = nil;
//        return;
//    }
//    tempString = [self.ambString substringWithRange:NSMakeRange(0, num++)];
//    ambassadorMessage.text = tempString;
//}
-(void)haveBtnClick
{
    if (!rightBtn.selected) {
        [self animateIncorrectPassword:shakeBgView];
        return;
    }
    RegisterViewController * vc = [[RegisterViewController alloc] init];
//    ChooseFamilyViewController * vc = [[ChooseFamilyViewController alloc] init];
//    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
//    vc.dismiss = ^(){
//        [self dismissViewControllerAnimated:YES completion:nil];
//    };
    if (self.isOldUser) {
        vc.isOldUser = YES;
    }
    [self presentViewController:vc animated:YES completion:nil];
//    [nc release];
    [vc release];
    
    NSLog(@"创建");
//    JDSideMenu * sideMenu = [ControllerManager shareJDSideMenu];
//    [sideMenu setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"30-3" ofType:@"png"]]];
//    [self presentViewController:sideMenu animated:YES completion:nil];
}
-(void)notHaveBtnClick
{
    if (!rightBtn.selected) {
        [self animateIncorrectPassword:shakeBgView];
        return;
    }
//    RegisterViewController * vc = [[RegisterViewController alloc] init];
    [USER setObject:@"0" forKey:@"isChooseFamilyShouldDismiss"];
    ChooseFamilyViewController * vc = [[ChooseFamilyViewController alloc] init];
//    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.isMi = self.isMi;
    [self presentViewController:vc animated:YES completion:nil];
//    [nc release];
    [vc release];
    
    NSLog(@"加入");
//    JDSideMenu * sideMenu = [ControllerManager shareJDSideMenu];
//    [sideMenu setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"30-3" ofType:@"png"]]];
//    [self presentViewController:sideMenu animated:YES completion:nil];
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
}


@end
