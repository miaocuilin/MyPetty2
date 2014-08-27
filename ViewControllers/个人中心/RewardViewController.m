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
    
    [self makeNavgation];
    [self loadData];
    [self makeUI];
}
#pragma mark - 视图的创建
- (void)makeNavgation
{
    self.navigationItem.title = @"奖品详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIButton * button1 = [MyControl createButtonWithFrame:CGRectMake(0, 0, 56/2, 56/2) ImageName:@"7-7.png" Target:self Action:@selector(returnClick) Title:nil];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
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
    for (int i=0; i<3; i++) {
        UIImageView * headImageView = [MyControl createImageViewWithFrame:CGRectMake(15, 15+i*90, 80, 80) ImageName:@"cat1.jpg"];
        [self.view addSubview:headImageView];
        
        UILabel * title = [MyControl createLabelWithFrame:CGRectMake(100, 20+i*90, 100, 20) Font:17 Text:array[i]];
        title.textColor = [UIColor blackColor];
        [self.view addSubview:title];
        
        
        CGSize size = [array2[i] sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(200, 500) lineBreakMode:2];
        
        UILabel * detail = [MyControl createLabelWithFrame:CGRectMake(100, 20+i*90+25, 200, size.height) Font:15 Text:array2[i]];
        detail.textColor = [UIColor grayColor];
        [self.view addSubview:detail];
        
        if (i == 2) {
            UIImageView * line = [MyControl createImageViewWithFrame:CGRectMake(0, headImageView.frame.origin.y+100, 320, 1) ImageName:@""];
            line.image = [[UIImage imageNamed:@"20-灰色线.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
            [self.view addSubview:line];
        }
    }
    for(int i=0;i<3;i++){
        CGSize size = [array3[i] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 500) lineBreakMode:2];
        
        if (i == 0) {
            UILabel * introduceLabel = [MyControl createLabelWithFrame:CGRectMake(20, 320, 280, size.height) Font:15   Text:array3[i]];
            introduceLabel.textColor = [UIColor blackColor];
            [self.view addSubview:introduceLabel];
        }else{
            UILabel * introduceLabel = [MyControl createLabelWithFrame:CGRectMake(20, 320+tempHeight, 280, size.height) Font:15   Text:array3[i]];
            introduceLabel.textColor = [UIColor blackColor];
            [self.view addSubview:introduceLabel];
        }
        
        tempHeight += size.height;
    }
    
}

-(void)returnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
