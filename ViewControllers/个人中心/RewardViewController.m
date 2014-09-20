//
//  RewardViewController.m
//  MyPetty
//
//  Created by Aidi on 14-6-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "RewardViewController.h"

@interface RewardViewController ()
{
    CGFloat tempHeight;
}
@end

@implementation RewardViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createBg];
    [self makeNavgation];
    [self loadData];
    [self makeUI];
}
#pragma mark - 视图的创建
-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
    //    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"%@", data);
    UIImage * image = [UIImage imageWithData:data];
    bgImageView.image = image;
    
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:tempView];
}
- (void)makeNavgation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    //    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"奖品详情"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:titleLabel];
    
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadData
{
    NSString * code = [NSString stringWithFormat:@"topic_id=%@dog&cat", self.topic_id];
    NSString * sig = [MyMD5 md5:code];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", REWARDAPI, self.topic_id, sig, [ControllerManager getSID]];
    NSLog(@"url:%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            
        }else{
            NSLog(@"数据下载失败");
        }
    }];
}

-(void)makeUI
{
    NSArray * array = @[@"一等奖", @"二等奖", @"三等奖"];
    NSArray * array2 = @[@"\"爱时尚\"专业宠物摄影机构写真一套", @"诺顿牛肉成犬粮10KG 全能营养保护", @"派宠PETSINN 小型犬巴库笑笑屋红色环保猫狗窝"];
    NSArray * array3 = @[@"1.阿猫阿狗官方在活动结束后，人气排名前三，分别获得一，二，三等奖。", @"2.必须是自家萌宠的照片哦!", @"3.奖品以实物为准。"];
//    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    sv.contentSize = CGSizeMake(self.view.frame.size.width, 568);
//    [self.view addSubview:sv];
//    
//    [self.view bringSubviewToFront:navView];
    
    for (int i=0; i<3; i++) {
        UIImageView * headImageView = [MyControl createImageViewWithFrame:CGRectMake(15, 64+15+i*90, 80, 80) ImageName:@"cat1.jpg"];
        [self.view addSubview:headImageView];
        
        UILabel * title = [MyControl createLabelWithFrame:CGRectMake(110, 64+20+i*90, 100, 20) Font:17 Text:array[i]];
        title.textColor = [UIColor blackColor];
        [self.view addSubview:title];
        
        
        CGSize size = [array2[i] sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(200, 500) lineBreakMode:2];
        
        UILabel * detail = [MyControl createLabelWithFrame:CGRectMake(110, 64+20+i*90+25, 200, size.height) Font:15 Text:array2[i]];
        detail.textColor = [UIColor grayColor];
        [self.view addSubview:detail];
        
        if (i == 2) {
            UIView * line = [MyControl createViewWithFrame:CGRectMake(0, headImageView.frame.origin.y+100, self.view.frame.size.width, 1)];
            line.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:line];
        }
    }
    for(int i=0;i<3;i++){
        CGSize size = [array3[i] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 500) lineBreakMode:2];
        
        if (i == 0) {
            UILabel * introduceLabel = [MyControl createLabelWithFrame:CGRectMake(20, 64+320-5, 280, size.height) Font:15 Text:array3[i]];
            introduceLabel.textColor = [UIColor blackColor];
            [self.view addSubview:introduceLabel];
        }else{
            UILabel * introduceLabel = [MyControl createLabelWithFrame:CGRectMake(20, 64+320-5+tempHeight, 280, size.height) Font:15   Text:array3[i]];
            introduceLabel.textColor = [UIColor blackColor];
            [self.view addSubview:introduceLabel];
        }
        
        tempHeight += size.height+5;
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
