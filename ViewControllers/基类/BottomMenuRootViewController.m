//
//  BottomMenuRootViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-18.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "BottomMenuRootViewController.h"
#import "PetInfoViewController.h"
#import "ToolTipsViewController.h"
#import "TouchViewController.h"
#import "ShakeViewController.h"
#import "ShoutViewController.h"
#import "CallViewController.h"

#define headBtnWidth 64
#define circleWidth 82
@interface BottomMenuRootViewController ()
{
    NSString *masterID;
    NSDictionary *animalInfoDict;
}

@end

@implementation BottomMenuRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createMenu];
}
- (void)viewWillAppear:(BOOL)animated
{
    if ([ControllerManager getIsSuccess]) {
        [self loadAnimalInfoData];
    }
}

- (void)loadAnimalInfoData
{
    NSString *aid = [USER objectForKey:@"aid"];
    NSString *animalInfoSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",aid]];
NSString *animalInfo = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",ANIMALINFOAPI,aid,animalInfoSig,[ControllerManager getSID]];
    NSLog(@"宠物信息API:%@",animalInfo);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:animalInfo Block:^(BOOL isFinish, httpDownloadBlock *load) {
        NSLog(@"宠物信息：%@",load.dataDict);
        if (isFinish) {
            masterID =[[load.dataDict objectForKey:@"data"] objectForKey:@"master_id"];
            animalInfoDict = [load.dataDict objectForKey:@"data"];
//            [self createMenu];
            
            NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@_headImage.png.png", DOCDIR, [USER objectForKey:@"aid"]];
            
            UIImage *image =[UIImage imageWithContentsOfFile:pngFilePath];
            if (image) {
                [self.headButton setBackgroundImage:image forState:UIControlStateNormal];
            }else{
                httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@",PETTXURL,[USER objectForKey:@"a_tx"]] Block:^(BOOL isFinish, httpDownloadBlock *load) {
                    if (isFinish) {
                        if (load.dataImage == NULL) {
                            [self.headButton setBackgroundImage:[UIImage imageNamed:@"defaultPetHead.png"] forState:UIControlStateNormal];
                        }else{
                            [self.headButton setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                            [load.data writeToFile:pngFilePath atomically:YES];
                        }
                    }
                }];
                [request release];
            }

            
            
            if ([masterID isEqualToString:[USER objectForKey:@"usr_id"]]){
                self.label3.text = @"叫一叫";
            }

        }
    }];
    [request release];
}
-(void)createMenu
{
    self.menuBgBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(menuBgBtnClick) Title:nil];
    self.menuBgBtn.backgroundColor = [UIColor blackColor];
    self.menuBgBtn.alpha = 0;
    self.menuBgBtn.hidden = YES;
    [self.view addSubview:self.menuBgBtn];
    
    self.menuBgView = [MyControl createViewWithFrame:CGRectMake(50, self.view.frame.size.height-headBtnWidth+24, 220, headBtnWidth)];
//    self.menuBgView.backgroundColor = [UIColor redColor];
//    self.menuBgView.alpha = 0.5;
    [self.view addSubview:self.menuBgView];
    
    self.btn1 = [MyControl createButtonWithFrame:CGRectMake(90, 100, 40, 40) ImageName:@"shake.png" Target:self Action:@selector(btn1Click) Title:nil];
    self.btn1.layer.cornerRadius = 20;
    self.btn1.layer.masksToBounds = YES;
    [self.menuBgView addSubview:self.btn1];
    
    self.btn2 = [MyControl createButtonWithFrame:CGRectMake(90, 100, 40, 40) ImageName:@"present.png" Target:self Action:@selector(btn2Click) Title:nil];
    self.btn2.layer.cornerRadius = 20;
    self.btn2.layer.masksToBounds = YES;
    [self.menuBgView addSubview:self.btn2];
    
    self.btn3 = [MyControl createButtonWithFrame:CGRectMake(90, 100, 40, 40) ImageName:@"sound.png" Target:self Action:@selector(btn3Click) Title:nil];
    self.btn3.layer.cornerRadius = 20;
    self.btn3.layer.masksToBounds = YES;
    [self.menuBgView addSubview:self.btn3];
    
    self.btn4 = [MyControl createButtonWithFrame:CGRectMake(90, 100, 40, 40) ImageName:@"havefun.png" Target:self Action:@selector(btn4Click) Title:nil];
    self.btn4.layer.cornerRadius = 20;
    self.btn4.layer.masksToBounds = YES;
    [self.menuBgView addSubview:self.btn4];
    
    self.label1 = [MyControl createLabelWithFrame:CGRectMake(90, 140, 40, 15) Font:13 Text:@"摇一摇"];
    self.label1.textAlignment = NSTextAlignmentCenter;
    [self.menuBgView addSubview:self.label1];
    
    self.label2 = [MyControl createLabelWithFrame:CGRectMake(90, 140, 40, 15) Font:13 Text:@"送礼物"];
    self.label2.textAlignment = NSTextAlignmentCenter;
    [self.menuBgView addSubview:self.label2];
    
    self.label3 = [MyControl createLabelWithFrame:CGRectMake(90, 140, 40, 15) Font:13 Text:@"摸一摸"];
    self.label3.textAlignment = NSTextAlignmentCenter;
    [self.menuBgView addSubview:self.label3];
    
    
    self.label4 = [MyControl createLabelWithFrame:CGRectMake(90, 140, 40, 15) Font:13 Text:@"逗一逗"];
    if ([[USER objectForKey:@"planet"] intValue]==2) {
        self.label4.text = @"遛一遛";
    }
    self.label4.textAlignment = NSTextAlignmentCenter;
    [self.menuBgView addSubview:self.label4];
    
    headCircle = [MyControl createImageViewWithFrame:CGRectMake(60+9, self.menuBgView.frame.size.height-circleWidth+5, circleWidth, circleWidth) ImageName:@"headCircle.png"];
    [self.menuBgView addSubview:headCircle];
    
    self.headButton = [MyControl createButtonWithFrame:CGRectMake(78, self.self.menuBgView.frame.size.height-headBtnWidth, headBtnWidth, headBtnWidth) ImageName:@"defaultPetHead.png" Target:self Action:@selector(headBtnClick) Title:nil];
    if (!([[USER objectForKey:@"a_tx"] isKindOfClass:[NSNull class]] || [[USER objectForKey:@"a_tx"] length]==0)) {
//        NSString *animalTXPath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[USER objectForKey:@"a_tx"]]];
        

    }
    
    self.headButton.layer.cornerRadius = headBtnWidth/2;
    self.headButton.layer.masksToBounds = YES;
    [self.menuBgView addSubview:self.headButton];
}
#pragma mark -
-(void)isRegister
{
    if (![ControllerManager getIsSuccess]) {
        ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc createLoginAlertView];
        
        [self hideAll];
        return;
    }
}
-(void)btn1Click
{
    [self isRegister];
    if (![ControllerManager getIsSuccess]) {
        return;
    }
    
    NSLog(@"摇一摇");
    ShakeViewController *shake = [[ShakeViewController alloc] init];
    [self addChildViewController:shake];
    [shake release];
    [shake didMoveToParentViewController:self];
    [shake becomeFirstResponder];
    [self.view addSubview:shake.view];
    shake.titleString = self.label1.text;
    shake.animalInfoDict = animalInfoDict;
    [self hideAll];
}

-(void)btn2Click
{
    [self isRegister];
    if (![ControllerManager getIsSuccess]) {
        return;
    }
    
    NSLog(@"送礼物");
    ToolTipsViewController *tool = [[ToolTipsViewController alloc] init];
    [self addChildViewController:tool];
    [tool release];
    [tool didMoveToParentViewController:self];
    [self.view addSubview:tool.view];
    [tool createPresentGiftAlertView];
    [self hideAll];
}
-(void)btn3Click
{
    [self isRegister];
    if (![ControllerManager getIsSuccess]) {
        return;
    }
    
    NSLog(@"录音和摸一摸");
//    CallViewController *call = [[CallViewController alloc] init];
//    [self addChildViewController:call];
//    [call release];
//    [call didMoveToParentViewController:self];
//    [call createRecordOne];
//    [self.view addSubview:call.view];
    if ([masterID isEqualToString:[USER objectForKey:@"usr_id"]]) {
        ShoutViewController *shout = [[ShoutViewController alloc] init];
        [self addChildViewController:shout];
        shout.animalInfoDict = animalInfoDict;
        [shout release];
        [shout didMoveToParentViewController:self];
//        [shout createRecordOne];
        [self.view addSubview:shout.view];
        [self hideAll];
    }else{
        
        TouchViewController *touch = [[TouchViewController alloc] init];
        touch.animalInfoDict = animalInfoDict;
        [self addChildViewController:touch];
        [touch release];
        [touch didMoveToParentViewController:self];
        [self.view addSubview:touch.view];
        //    [touch createAlertView];
        [self hideAll];
    }
    
}
-(void)btn4Click
{
    [self isRegister];
    if (![ControllerManager getIsSuccess]) {
        return;
    }
    NSLog(@"遛一遛");
    
    TouchViewController *touch = [[TouchViewController alloc] init];
    [self addChildViewController:touch];
    [touch release];
    [touch didMoveToParentViewController:self];
    [self.view addSubview:touch.view];
    [self hideAll];
}
-(void)headBtnClick
{
    if(isOpen){
        if (![ControllerManager getIsSuccess]) {
            ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
            [self addChildViewController:vc];
            [self.view addSubview:vc.view];
            [vc createLoginAlertView];
            
            [self hideAll];
            return;
        }
        NSLog(@"跳到王国");
        [self hideAll];
        PetInfoViewController * vc = [[PetInfoViewController alloc] init];
        vc.aid = [USER objectForKey:@"aid"];
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
        
    }else{
        [self showAll];
    }
}
-(void)menuBgBtnClick
{
    [self hideAll];
}
-(void)showAll
{
    isOpen = YES;
    self.menuBgBtn.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.menuBgBtn.alpha = 0.5;
        NSLog(@"---%f---", self.view.frame.size.height);
        self.menuBgView.frame = CGRectMake(50, self.view.frame.size.height-165, 220, 160);
        self.headButton.frame = CGRectMake(78, self.menuBgView.frame.size.height-headBtnWidth, headBtnWidth, headBtnWidth);
        headCircle.frame = CGRectMake(60+9, self.menuBgView.frame.size.height-circleWidth+5, circleWidth, circleWidth);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.btn1.frame = CGRectMake(20, 90, 40, 40);
            self.btn2.frame = CGRectMake(60, 25, 40, 40);
            self.btn3.frame = CGRectMake(120, 25, 40, 40);
            self.btn4.frame = CGRectMake(160, 90, 40, 40);
            
            self.label1.frame = CGRectMake(20, 130, 40, 15);
            self.label2.frame = CGRectMake(60, 65, 40, 15);
            self.label3.frame = CGRectMake(120, 65, 40, 15);
            self.label4.frame = CGRectMake(160, 130, 40, 15);
        }];
    }];
    
}
-(void)hideAll
{
    NSLog(@"hideAll");
    if (isOpen) {
        isOpen = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.btn1.frame = CGRectMake(90, 100, 40, 40);
            self.btn2.frame = CGRectMake(90, 100, 40, 40);
            self.btn3.frame = CGRectMake(90, 100, 40, 40);
            self.btn4.frame = CGRectMake(90, 100, 40, 40);
            
            self.label1.frame = CGRectMake(90, 140, 40, 15);
            self.label2.frame = CGRectMake(90, 140, 40, 15);
            self.label3.frame = CGRectMake(90, 140, 40, 15);
            self.label4.frame = CGRectMake(90, 140, 40, 15);
        } completion:^(BOOL finished) {
            [self hideBall];
        }];
        }
}
-(void)hideBall
{
    [UIView animateWithDuration:0.2 animations:^{
        self.menuBgBtn.alpha = 0;
        self.menuBgView.frame = CGRectMake(50, self.view.frame.size.height-headBtnWidth+24, 220, headBtnWidth);
        self.headButton.frame = CGRectMake(78, self.menuBgView.frame.size.height-headBtnWidth, headBtnWidth, headBtnWidth);
        headCircle.frame = CGRectMake(60+9, self.menuBgView.frame.size.height-circleWidth+5, circleWidth, circleWidth);
//        NSLog(@"%f--%f", self.menuBgView.frame.origin.y, headCircle.frame.origin.y);
    } completion:^(BOOL finished) {
        self.menuBgBtn.hidden = YES;
//        NSLog(@"%f--%f", self.menuBgView.frame.size.height, self.btn1.frame.origin.y);
    }];
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
