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
//    UIView * statusView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 20)];
//    statusView.backgroundColor = BGCOLOR;
//    [self.view addSubview:statusView];
    
//    ambassadorMessage = [MyControl createLabelWithFrame:CGRectMake(80, 60, 140, 40) Font:15 Text:nil];
//    ambassadorMessage.font = [UIFont boldSystemFontOfSize:15];
//    if (_isMi) {
//        ambassadorMessage.text = @"我 是 喵 星 大 使，\n欢 迎 来 到 喵 星！";
//    }else{
//        ambassadorMessage.text = @"我 是 汪 星 大 使，\n欢 迎 来 到 汪 星！";
//    }
//    Timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateAmbassadorMessage) userInfo:nil repeats:YES];
//    [self.view addSubview:ambassadorMessage];
    
    
//    UIImageView * ambassador = [MyControl createImageViewWithFrame:CGRectMake(370/2, 170/2, 230/2, 206/2) ImageName:@""];
//    if (_isMi) {
//        ambassador.image = [UIImage imageNamed:@"catAmbassador.png"];
//    }else{
//        ambassador.image = [UIImage imageNamed:@"dogAmbassador.png"];
//    }
//    [self.view addSubview:ambassador];
    
//    UIImageView * cloud = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-572/2)/2, self.view.frame.size.height-170-50-342/2, 572/2, 342/2) ImageName:@"2-c.png"];
//    [self.view addSubview:cloud];
    
    /************Mi*************/
//    UIImageView * haveBg = [MyControl createImageViewWithFrame:CGRectMake(130/2-10, 15, 373/2+10, 95/2) ImageName:@""];
//    haveBg.image = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2-e" ofType:@"png"]] stretchableImageWithLeftCapWidth:130 topCapHeight:0];
//    [cloud addSubview:haveBg];
//    
//    UILabel * haveLable1 = [MyControl createLabelWithFrame:CGRectMake(10+3, 0, 50, 20) Font:14 Text:@"有喵喵"];
//    if (!_isMi) {
//        haveLable1.text = @"有汪汪";
//    }
//    [haveBg addSubview:haveLable1];
//    
//    UILabel * haveLable2 = [MyControl createLabelWithFrame:CGRectMake(10+5, 22, 170, 20) Font:14 Text:@"立 刻 创 建 喵 喵 的 王 国"];
//    haveLable2.font = [UIFont boldSystemFontOfSize:15];
//    if (!_isMi) {
//        haveLable2.text = @"立 刻 创 建 汪 汪 的 家 族";
//    }
//    [haveBg addSubview:haveLable2];
    
//    UIImageView * haveBg = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-520/2)/2.0, (self.view.frame.size.height-117/2.0)/2.0, 520/2, 117/2) ImageName:@"has_star.png"];
//    if (_isMi) {
//        haveBg.image = [UIImage imageNamed:@"haveCat.png"];
//    }else{
//        haveBg.image = [UIImage imageNamed:@"haveDog.png"];
//    }
//    [self.view addSubview:haveBg];
    
    UIButton * haveBtn = [MyControl createButtonWithFrame:CGRectMake((self.view.frame.size.width-520/2)/2.0, self.view.frame.size.height-530/2.0, 520/2, 117/2) ImageName:@"has_star.png" Target:self Action:@selector(haveBtnClick) Title:nil];
    [self.view addSubview:haveBtn];
    /************Wa*************/
//    UIImageView * notHaveBg = [MyControl createImageViewWithFrame:CGRectMake(130/2-10, 70, 373/2+10, 95/2) ImageName:@""];
//    notHaveBg.image = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2-d" ofType:@"png"]] stretchableImageWithLeftCapWidth:30 topCapHeight:0];
//    [cloud addSubview:notHaveBg];
    
//    UILabel * notHaveLable1 = [MyControl createLabelWithFrame:CGRectMake(250/2+13, 0, 50, 20) Font:14 Text:@"没喵喵"];
//    if (!_isMi) {
//        notHaveLable1.text = @"没汪汪";
//    }
//    [notHaveBg addSubview:notHaveLable1];
//    
//    UILabel * notHaveLable2 = [MyControl createLabelWithFrame:CGRectMake(10-5, 22, 190, 20) Font:14 Text:@"快 来 加 入 萌 猫 们 的 王 国"];
//    notHaveLable2.font = [UIFont boldSystemFontOfSize:15];
//    if (!_isMi) {
//        notHaveLable2.text = @"快 来 加 入 萌 狗 们 的 家 族";
//    }
//    [notHaveBg addSubview:notHaveLable2];
//    
//    UIImageView * notHaveBg = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-434/2)/2, cloud.frame.origin.y+60, 434/2, 167/2) ImageName:@"choosein_noPet.png"];
//    if (_isMi) {
//        notHaveBg.image = [UIImage imageNamed:@"noCat.png"];
//    }else{
//        notHaveBg.image = [UIImage imageNamed:@"noDog.png"];
//    }
//    [self.view addSubview:notHaveBg];
    
    UIButton * notHaveBtn = [MyControl createButtonWithFrame:CGRectMake((self.view.frame.size.width-520/2)/2.0, self.view.frame.size.height-348/2.0, 520/2, 117/2) ImageName:@"no_star.png" Target:self Action:@selector(notHaveBtnClick) Title:nil];
    [self.view addSubview:notHaveBtn];
    /******************************/
//    UIImageView * earth = [MyControl createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height-100, 320, 219/2) ImageName:@"2-b.png"];
//    [self.view addSubview:earth];
    
//    UIImageView * switchBg = [MyControl createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height-45, 150, 45) ImageName:@""];
//    switchBg.image = [[UIImage imageNamed:@"switchBg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
//    [self.view addSubview:switchBg];
//    
//    UIImageView * head = [MyControl createImageViewWithFrame:CGRectMake(2, 2, 60, 40) ImageName:@"dogHead.png"];
//    if (!_isMi) {
//        head.frame = CGRectMake(2, 2, 40, 40);
//        head.image = [UIImage imageNamed:@"catHead.png"];
//    }
//    [switchBg addSubview:head];
//    
//    UILabel * label = [MyControl createLabelWithFrame:CGRectMake(60, 12, 80, 20) Font:15 Text:@"切换到喵星"];
//    if (_isMi) {
//        label.text = @"切换到汪星";
//    }
//    label.textColor = [UIColor colorWithRed:250/255.0 green:162/255.0 blue:134/255.0 alpha:1];
//    [switchBg addSubview:label];
    
//    UIButton * switchBtn = [MyControl createButtonWithFrame:CGRectMake(0, self.view.frame.size.height-167/2, 275/2, 167/2) ImageName:@"" Target:self Action:@selector(switchBtnClick) Title:nil];
//    if (self.isMi) {
//        [switchBtn setBackgroundImage:[UIImage imageNamed:@"dogHead.png"] forState:UIControlStateNormal];
//    }else{
//        [switchBtn setBackgroundImage:[UIImage imageNamed:@"catHead.png"] forState:UIControlStateNormal];
//    }
//    [self.view addSubview:switchBtn];
    
//    UIImageView * catAndDog = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-450/2)/2, earth.frame.origin.y-70, 450/2, 203/2) ImageName:@"choosein_cat_dog.png"];
//    [self.view addSubview:catAndDog];
    
    shakeBgView = [MyControl createViewWithFrame:CGRectMake(notHaveBtn.frame.origin.x, notHaveBtn.frame.origin.y+117/2+5, 300, 20)];
    [self.view addSubview:shakeBgView];
    
    rightBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 20, 20) ImageName:@"atUsers_unSelected.png" Target:self Action:@selector(rightBtnClick:) Title:nil];
    [rightBtn setImage:[UIImage imageNamed:@"atUsers_selected.png"] forState:UIControlStateSelected];
    
//    rightBtn.selected = YES;
    [shakeBgView addSubview:rightBtn];
    
    UILabel * label = [MyControl createLabelWithFrame:CGRectMake(rightBtn.frame.origin.x+25, rightBtn.frame.origin.y, 200, 20) Font:12 Text:@"我已经阅读并同意"];
//    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:@"我已经阅读并同意《用户协议》"];
//    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:85/255.0 green:134/255.0 blue:156/255.0 alpha:1] range:NSMakeRange(8, 6)];
//    [attString addAttribute:NSUnderlineStyleAttributeName value:[NSString stringWithFormat:@"%d", NSUnderlineStyleSingle] range:NSMakeRange(8, 6)];
//    NSDictionary * dic = @{NSFontAttributeName:[UIFont fontWithName:@"" size:12], NSUnderlineStyleSingle:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    [attString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(8, 6)];
//    label.attributedText = attString;
    [shakeBgView addSubview:label];
//    [attString release];
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
