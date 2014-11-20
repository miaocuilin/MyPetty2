//
//  MyPetViewController.m
//  MyPetty
//
//  Created by Aidi on 14-5-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MyPetViewController.h"
#import "FavoriteCell.h"
#import "AttentionCell.h"
#define DARKGRAY [UIColor darkGrayColor]
#import "InfoModel.h"
#import "UIImageView+WebCache.h"
#import "ASIFormDataRequest.h"
#import "PhotoModel.h"
#import "SettingViewController.h"
#import "DetailViewController.h"
#import "OtherHomeViewController.h"
#import "UMSocial.h"

@interface MyPetViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    UILabel * shopLabel;
    UITableView * tv;
    UITableView * tv2;
    UITableView * tvExp;
    UITableView * tvAttention;
    UITableView * tvFans;
    UITableView * tvTemp;
    
    //tableHeaderView
    UIImageView * bgImageView;
    UIButton * homeButton;
    UIButton * expButton;
    UIButton * setButton;
    //段头
    UIView * bgView2;
    
    UILabel * numLabel1;
    UIButton * button1;
    UILabel * numLabel2;
    UIButton * button2;
    UILabel * numLabel3;
    UIButton * button3;
    UILabel * photoLabel;
    UILabel * attentionLabel;
    UILabel * fansLabel;
    
    UIImageView * headImageView;
    UIImage * tempImage;
    
    ASIFormDataRequest * _request;
    
    UIButton * outButton;
}

//@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
//@property (nonatomic, strong) NSMutableArray * sessions;
@end

@implementation MyPetViewController

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
    [self login];
//    [tv reloadData];
//    tv.hidden = NO;
//    tv2.hidden = YES;
//    tv.tableHeaderView = bgImageView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArrayPhotos = [NSMutableArray arrayWithCapacity:0];
    self.attentionDataArray = [NSMutableArray arrayWithCapacity:0];
    self.fansDataArray = [NSMutableArray arrayWithCapacity:0];
    self.expArray = @[@"30", @"150", @"400", @"750", @"1200", @"1800"];
    self.array1 = @[@"账号设置", @"清除缓存", @"赏个好评", @"提个意见", @"关于我们"];
    [self createNavigation];
    [self createHeaderView];
//    [self loadAttentionData];
    [self loadData];
//    [self loadPhotoData];
//    NSUserDefaults * user = [ControllerManager shareUserDefault];
//    [user setObject:@"YES" forKey:@"LoadMyPet"];
}
#pragma mark -loadData
-(void)loadData
{
    NET = YES;
    [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", INFOAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            [self.dataArray removeAllObjects];
            
            NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            InfoModel * model = [[InfoModel alloc] init];
            experience = model.exp;
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
            [model release];
            [self loadPhotoData];
        }else{
            NSLog(@"用户数据加载失败。");
            NET = NO;
        }
    }];
}
-(void)loadPhotoData
{
    [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGESAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            [self.dataArrayPhotos removeAllObjects];
            
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for(int i=0;i<array.count;i++){
                NSDictionary * dict = array[i];
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                
//                model.headImage = tempImage;
                model.title = [USER objectForKey:@"name"];
                model.detail = [USER objectForKey:@"detailName"];
                [self.dataArrayPhotos addObject:model];
                if (i == array.count-1) {
                    self.img_id = model.img_id;
                }
                [model release];
            }
            [self loadAttentionData];
//            [tv reloadData];
        }else{
            NSLog(@"数据加载失败。");
            NET = NO;
        }
    }];
}
#pragma mark -下载关注列表
-(void)loadAttentionData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", FOLLOWINGAPI, [ControllerManager getSID]];
    NSLog(@"followingAPI:%@", url);
    
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            [self.attentionDataArray removeAllObjects];
            if ([[load.dataDict objectForKey:@"errorCode"] intValue]) {
                [self loadFansData];
                return;
            }
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                NSDictionary * dic = [dict objectForKey:@"user"];
                InfoModel * model = [[InfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.attentionDataArray addObject:model];
                
                [model release];
            }
            [self loadFansData];
        }else{
            NSLog(@"下载关注列表失败");
            NET = NO;
        }
    }];
}
#pragma mark -下载粉丝列表
-(void)loadFansData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", FOLLOWERAPI, [ControllerManager getSID]];
    NSLog(@"followerAPI:%@", url);
    
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            [self.fansDataArray removeAllObjects];
            NSLog(@"%@", load.dataDict);
            if ([[load.dataDict objectForKey:@"errorCode"] intValue]) {
                [self createTableView];
                NET = NO;
                return;
            }
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                NSDictionary * dic = [dict objectForKey:@"user"];
                InfoModel * model = [[InfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.fansDataArray addObject:model];
                isFansFriend[self.fansDataArray.count-1] = [[dict objectForKey:@"isFriend"] intValue];
                
                [model release];
            }
            [self createTableView];
//            [tv reloadData];
//            [tv2 reloadData];
//            [tvFans reloadData];
//            [tvExp reloadData];
//            [tvAttention reloadData];
            NET = NO;
        }else{
            NSLog(@"下载粉丝列表失败");
            NET = NO;
        }
    }];
}


#pragma mark -创建导航
-(void)createNavigation
{
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.barTintColor = BGCOLOR2;
    
    UIButton * buttonLeft = [MyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) ImageName:@"14-6.png" Target:self Action:@selector(leftButtonClick) Title:nil];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    
    UIButton * buttonRight = [MyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) ImageName:@"14-5.png" Target:self Action:@selector(rightButtonClick) Title:nil];
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
    
//    self.navigationItem.title = @"My Petty";
    
}
#pragma mark -buttonClick事件
-(void)leftButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightButtonClick
{
    shopLabel.hidden = NO;
    [self performSelector:@selector(labelHidden) withObject:Nil afterDelay:2];
}
-(void)labelHidden
{
    shopLabel.hidden = YES;
}

#pragma mark -创建tableView
-(void)createTableView
{
    tvTemp = nil;
    
    //个人中心-照片
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
//    tv.alpha = 0.8;
    [self.view addSubview:tv];
    tvTemp = tv;
    [tv release];
    
    //经验
    tvExp = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tvExp.delegate = self;
    tvExp.dataSource = self;
    tvExp.hidden = YES;
    tvExp.showsVerticalScrollIndicator = NO;
    tvExp.separatorStyle = 0;
//    tvExp.
    [self.view addSubview:tvExp];
    
    [tvExp release];
    
    //设置
    tv2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-80) style:UITableViewStylePlain];
    tv2.delegate = self;
    tv2.dataSource = self;
    tv2.hidden = YES;
    tv2.showsVerticalScrollIndicator = NO;

    [self.view addSubview:tv2];
    [tv2 release];
    
    //退出登录键
    outButton = [MyControl createButtonWithFrame:CGRectMake(10, self.view.frame.size.height-60, 300, 35) ImageName:nil Target:self Action:@selector(outButtonClick) Title:@"退出登录"];
    outButton.hidden = YES;
    outButton.layer.cornerRadius = 5;
    outButton.layer.masksToBounds = YES;
    outButton.backgroundColor = BGCOLOR;
    outButton.showsTouchWhenHighlighted = YES;
    [self.view addSubview:outButton];
    
    //关注
    tvAttention = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tvAttention.delegate = self;
    tvAttention.dataSource = self;
    tvAttention.hidden = YES;
    [self.view addSubview:tvAttention];
    [tvAttention release];
    
    //粉丝
    tvFans = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tvFans.delegate = self;
    tvFans.dataSource = self;
    tvFans.hidden = YES;
    [self.view addSubview:tvFans];
    [tvFans release];
    
    //设置tableHeaderView
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, 250) ImageName:@""];
    [bgImageView retain];
    bgImageView.backgroundColor = BGCOLOR2;
    
    UILabel * nameLabel = [MyControl createLabelWithFrame:CGRectMake(60, 10, 200, 30) Font:20 Text:[USER objectForKey:@"name"]];
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [bgImageView addSubview:nameLabel];
    
    /******************************************/
    //可更换的头像

    headImageView = [MyControl createImageViewWithFrame:CGRectMake(120, 40, 80, 80) ImageName:@"cat2.jpg"];
    headImageView.layer.cornerRadius = 40;
    headImageView.layer.masksToBounds = YES;
    [bgImageView addSubview:headImageView];

    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *docDir = DOCDIR;
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/headImage.png",docDir];
    if ([fileManager fileExistsAtPath:pngFilePath]) {
        UIImage * headImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:pngFilePath]];
        headImageView.image = headImage;
    }else{
        [headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PETTXURL, [self.dataArray[0] tx]]]];
    }
    
    
    UIButton * camaraButton = [MyControl createButtonWithFrame:CGRectMake(120+80-30, 40+80-30, 30, 30) ImageName:@"14-7.png" Target:self Action:@selector(camaraButtonClick) Title:nil];
    [bgImageView addSubview:camaraButton];
    
    UILabel * cateLabel = [MyControl createLabelWithFrame:CGRectMake(5, 120, 150, 30) Font:15 Text:[USER objectForKey:@"detailName"]];
//    cateLabel.font = [UIFont boldSystemFontOfSize:15];
    cateLabel.textColor = [UIColor blackColor];
    cateLabel.textAlignment = NSTextAlignmentRight;
    [bgImageView addSubview:cateLabel];
    
    UIImageView * sexImageView = [MyControl createImageViewWithFrame:CGRectMake(170, 126, 20, 20) ImageName:@"14-9.png"];
    if ([self.dataArray[0] gender] == 1) {
        sexImageView.image = [UIImage imageNamed:@"14-9.png"];
    }else{
        sexImageView.image = [UIImage imageNamed:@"14-8.png"];
    }
    [bgImageView addSubview:sexImageView];
    
    UILabel * ageLabel = [MyControl createLabelWithFrame:CGRectMake(200, 120, 80, 30) Font:15 Text:[NSString stringWithFormat:@"%d岁", [self.dataArray[0] age]] ];
//    ageLabel.font = [UIFont boldSystemFontOfSize:15];
    ageLabel.textColor = [UIColor blackColor];
    ageLabel.textAlignment = NSTextAlignmentLeft;
    [bgImageView addSubview:ageLabel];
    
    /*************************************************/
    
    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(0, 160, 320, 89/3+20)];
    [bgImageView addSubview:bgView];
    
    UIImageView * line1 = [MyControl createImageViewWithFrame:CGRectMake(0, 160, 320, 1) ImageName:@""];
    line1.image = [[UIImage imageNamed:@"line.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [bgImageView addSubview:line1];
    
    //主页按钮
    homeButton = [MyControl createButtonWithFrame:CGRectMake(60, 10, 95/3, 89/3) ImageName:@"14-2.png" Target:self Action:@selector(homeButtonClick:) Title:nil];
    [homeButton setBackgroundImage:[UIImage imageNamed:@"14-1.png"] forState:UIControlStateSelected];
    homeButton.tag = 100;
    homeButton.selected = YES;
    [bgView addSubview:homeButton];
    
    //经验按钮
    expButton = [MyControl createButtonWithFrame:CGRectMake(320/2-95/3/2, 10, 95/3, 89/3) ImageName:@"18-2.png" Target:self Action:@selector(homeButtonClick:) Title:nil];
    [expButton setBackgroundImage:[UIImage imageNamed:@"18-1.png"] forState:UIControlStateSelected];
    expButton.tag = 102;
    [bgView addSubview:expButton];
    
    //设置按钮
    setButton = [MyControl createButtonWithFrame:CGRectMake(320-80-95/3+20, 10, 95/3, 89/3) ImageName:@"14-4.png" Target:self Action:@selector(homeButtonClick:) Title:nil];
    [setButton setBackgroundImage:[UIImage imageNamed:@"14-3.png"] forState:UIControlStateSelected];
    setButton.tag = 101;
    [bgView addSubview:setButton];
    
    
    
    bgView2 = [MyControl createViewWithFrame:CGRectMake(0, 210, 320, 40)];
    [bgImageView addSubview:bgView2];
    
    UIImageView * line2 = [MyControl createImageViewWithFrame:CGRectMake(0, 210, 320, 1) ImageName:@""];
    line2.image = [[UIImage imageNamed:@"line.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [bgImageView addSubview:line2];
    
    //照片
    numLabel1 = [MyControl createLabelWithFrame:CGRectMake(10, 5, 50, 30) Font:25 Text:[NSString stringWithFormat:@"%d", [self.dataArray[0] imagesCount]]];
    numLabel1.textColor = BGCOLOR;
    numLabel1.textAlignment = NSTextAlignmentRight;
    [bgView2 addSubview:numLabel1];
    photoLabel = [MyControl createLabelWithFrame:CGRectMake(60, 12, 30, 20) Font:14 Text:@"照片"];
    photoLabel.textColor = BGCOLOR;
    photoLabel.textAlignment = NSTextAlignmentLeft;
    [bgView2 addSubview:photoLabel];
    
    button1 = [MyControl createButtonWithFrame:CGRectMake(10, 5, 80, 30) ImageName:@"" Target:self Action:@selector(numButtonClick:) Title:nil];
    button1.tag = 201;
//    button1.backgroundColor = [UIColor grayColor];
//    button1.alpha = 0.5;
    [bgView2 addSubview:button1];
    
    //关注
    numLabel2 = [MyControl createLabelWithFrame:CGRectMake(110, 5, 50, 30) Font:25 Text:[NSString stringWithFormat:@"%d", self.attentionDataArray.count]];
    NSLog(@"%d", self.attentionDataArray.count);
    numLabel2.textColor = DARKGRAY;
    numLabel2.textAlignment = NSTextAlignmentRight;
    [bgView2 addSubview:numLabel2];
    attentionLabel = [MyControl createLabelWithFrame:CGRectMake(160, 12, 30, 20) Font:14 Text:@"关注"];
    attentionLabel.textColor = DARKGRAY;
    attentionLabel.textAlignment = NSTextAlignmentLeft;
    [bgView2 addSubview:attentionLabel];
    
    button2 = [MyControl createButtonWithFrame:CGRectMake(110, 5, 80, 30) ImageName:@"" Target:self Action:@selector(numButtonClick:) Title:nil];
    button2.tag = 202;
//    button2.backgroundColor = [UIColor grayColor];
//    button2.alpha = 0.5;
    [bgView2 addSubview:button2];
    
    //粉丝
    numLabel3 = [MyControl createLabelWithFrame:CGRectMake(320-80-15-10, 5, 50, 30) Font:25 Text:[NSString stringWithFormat:@"%d", self.fansDataArray.count]];
    NSLog(@"%d", self.fansDataArray.count);
    numLabel3.textColor = DARKGRAY;
    numLabel3.textAlignment = NSTextAlignmentRight;
    [bgView2 addSubview:numLabel3];
    fansLabel = [MyControl createLabelWithFrame:CGRectMake(320-15-30-10, 12, 30, 20) Font:14 Text:@"粉丝"];
    fansLabel.textColor = DARKGRAY;
    fansLabel.textAlignment = NSTextAlignmentLeft;
    [bgView2 addSubview:fansLabel];
    
    button3 = [MyControl createButtonWithFrame:CGRectMake(320-80-15-10, 5, 80, 30) ImageName:@"" Target:self Action:@selector(numButtonClick:) Title:nil];
//    button3.backgroundColor = [UIColor grayColor];
//    button3.alpha = 0.5;
    button3.tag = 203;
    [bgView2 addSubview:button3];
    
    
    
    //Coming Soon!!!
    shopLabel = [MyControl createLabelWithFrame:CGRectMake(60, 100, 200, 40) Font:17 Text:@"Coming Soon!"];
    shopLabel.textAlignment = NSTextAlignmentCenter;
    shopLabel.backgroundColor = [UIColor darkGrayColor];
    shopLabel.layer.masksToBounds = YES;
    shopLabel.layer.cornerRadius = 5;
    shopLabel.alpha = 0.7;
    [bgImageView addSubview:shopLabel];
    shopLabel.hidden = YES;
    
    tv.tableHeaderView = bgImageView;
    
    //回到oriIndex
    if (oriIndex == 3) {
        button1.selected = NO;
        button3.selected = YES;
    }else if(oriIndex == 2){
        button1.selected = NO;
        button2.selected = YES;
    }

}
#pragma mark
#pragma mark -头像旁边相机点击事件
-(void)camaraButtonClick
{
    [self cameraClick];
//    headImageView.image = [UIImage imageNamed:@"cat1.jpg"];
}

#pragma mark -tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == tv2){
        return self.array1.count;
    }else if(tableView == tv){
        NSLog(@"-------dataArrayPhotos.count:%d------", self.dataArrayPhotos.count);
        return self.dataArrayPhotos.count;
    }else if(tableView == tvAttention){
        return self.attentionDataArray.count;
    }else if(tableView == tvExp){
        return 1;
    }else{
        return self.fansDataArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tv){
        static NSString * cellID = @"ID";
        FavoriteCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[[FavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        }
        cell.selectionStyle = NO;
        PhotoModel * model = self.dataArrayPhotos[indexPath.row];
        [cell configUI:model];
        
        NSLog(@"%d", self.dataArray.count);
        InfoModel * infoModel = self.dataArray[0];
        [cell configUsrInfo:infoModel];
        
        //本地目录，用于存放下载的原图
        NSString * docDir = DOCDIR;
        if (!docDir) {
            NSLog(@"Documents 目录未找到");
        }else{
            NSString * filePath2 = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@_small.png", model.url]];
            UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath2]];
            if (image) {
                cell.bigImageView.image = image;
                cell.bigImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                cell.bigImageView.center = CGPointMake(320/2, 300/2);
            }else{
                [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
                        //本地目录，用于存放favorite下载的原图
                        NSString * docDir = DOCDIR;
                        //                    NSLog(@"docDir:%@", docDir);
                        if (!docDir) {
                            NSLog(@"Documents 目录未找到");
                        }else{
                            NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
                            NSString * filePath2 = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@_small.png", model.url]];
                            //将下载的图片存放到本地
                            [load.data writeToFile:filePath atomically:YES];
                            
                            float width = load.dataImage.size.width;
                            float height = load.dataImage.size.height;
                            if (width>320) {
                                float w = 320/width;
                                width *= w;
                                height *= w;
                            }
                            UIImage * image = [load.dataImage imageByScalingToSize:CGSizeMake(width, height)];
                            
                            if (image.size.height>200) {
                                image = [self imageFromImage:image inRect:CGRectMake(0, height/2-100, width, 200)];
                                height = 200;
                            }
                            cell.bigImageView.image = image;
                            
                            NSData * smallImageData = UIImagePNGRepresentation(image);
                            [smallImageData writeToFile:filePath2 atomically:YES];
                            cell.bigImageView.frame = CGRectMake(0, 0, width, height);
                            cell.bigImageView.center = CGPointMake(320/2, 300/2);
                        }
                    }else{
                        //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        //            [alert show];
                        //            [alert release];
                    }
                }];
            }
        }
        
        return cell;
    }else if(tableView == tv2){
        static NSString * cellID2 = @"ID2";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if(!cell){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2] autorelease];
        }
        cell.selectionStyle = 0;
        cell.textLabel.text = self.array1[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = DARKGRAY;
        cell.accessoryType = 1;

        return cell;
    }else if(tableView == tvAttention){
        static NSString * cellID3 = @"ID3";
        AttentionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
        if(!cell){
            cell = [[[AttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3] autorelease];
        }
        InfoModel * model = self.attentionDataArray[indexPath.row];
        [cell configUI:model];
        UIButton * attentionButton = [MyControl createButtonWithFrame:CGRectMake(320-15-20-5, 23, 30, 30) ImageName:@"14-11.png" Target:self Action:@selector(attentionButtonClick:) Title:nil];
        attentionButton.tag = 1000+indexPath.row;
        attentionButton.showsTouchWhenHighlighted = YES;
        //    [attentionButton setBackgroundImage:[UIImage imageNamed:@"14-11.png"] forState:UIControlStateSelected];
        [cell addSubview:attentionButton];
        cell.selectionStyle = 0;
        return cell;
    }else if(tableView == tvExp){
        //经验
        UITableViewCell * cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"exp"] autorelease];
        
        sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-210)];
        sv.contentSize = CGSizeMake(320, 650);
        [cell.contentView addSubview:sv];
        
        UILabel * titleLable = [MyControl createLabelWithFrame:CGRectMake(10, 10, 300, 30) Font:13 Text:@"经验值达到相应的等级，相应的图章会亮起来哦！"];
        titleLable.textColor = [UIColor grayColor];
        titleLable.textAlignment = NSTextAlignmentCenter;
        [sv addSubview:titleLable];
        
        //进度条
   
        for(int i=0;i<6;i++){
            if (i<5) {
                UIImageView * lineRed = [MyControl createImageViewWithFrame:CGRectMake(145, 67.5+i*100, 5, 0) ImageName:@""];
                lineRed.image = [[UIImage imageNamed:@"18-7.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
                [sv addSubview:lineRed];
                lineRed.tag = 400+i;
                UIImageView * lineGray = [MyControl createImageViewWithFrame:CGRectMake(145, lineRed.frame.origin.y+lineRed.frame.size.height, 5, 100-lineRed.frame.size.height) ImageName:@""];
                lineGray.image = [[UIImage imageNamed:@"18-6.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
                [sv addSubview:lineGray];
                lineGray.tag = 450+i;
            }
            
            /*********************************/
            UIImageView * level = [MyControl createImageViewWithFrame:CGRectMake(80, 50+i*100, 97/2, 68/2) ImageName:@"18-4.png"];
            [sv addSubview:level];
            level.tag = 500+i;
            
            UILabel * expLabel = [MyControl createLabelWithFrame:CGRectMake(12, 18, 25, 10) Font:10 Text:self.expArray[i]];
            expLabel.textAlignment = NSTextAlignmentCenter;
            [level addSubview:expLabel];
            
            /*********************************/
            UIImageView * food = [MyControl createImageViewWithFrame:CGRectMake(170, 45+i*100, 170/2, 90/2) ImageName:@""];
            
            //2代表猫，1代表狗
            if ([[USER objectForKey:@"type"] isEqualToString:@"2"]) {
                food.image = [UIImage imageNamed:[NSString stringWithFormat:@"bcat%d_1.png", i+1]];
            }else{
                food.image = [UIImage imageNamed:[NSString stringWithFormat:@"bdog%d_1.png", i+1]];
            }
            [sv addSubview:food];
            food.tag = 600+i;
            
            /*********************************/
            UIImageView * ball = [MyControl createImageViewWithFrame:CGRectMake(140, 60+i*100, 15, 15) ImageName:@"18-5-2.png"];
            [sv addSubview:ball];
            ball.tag = 700+i;
            
            
        }
        
        /*****************************************/
        if(experience<30){
        
        }else if (experience<150) {
            [self changeImageWithLevel:1];
            [self changeProgressWithLevel:1];
        }else if(experience<400){
            [self changeImageWithLevel:2];
            [self changeProgressWithLevel:2];
        }else if(experience<750){
            [self changeImageWithLevel:3];
            [self changeProgressWithLevel:3];
        }else if(experience<1200){
            [self changeImageWithLevel:4];
            [self changeProgressWithLevel:4];
        }else if(experience<1800){
            [self changeImageWithLevel:5];
            [self changeProgressWithLevel:5];
        }else if(experience>=1800){
            [self changeImageWithLevel:6];
            [self changeProgressWithLevel:6];
        }
        
        
        return cell;
    }else{
        //粉丝tableView
        static NSString * cellID4 = @"ID4";
        AttentionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID4];
        if(!cell){
            cell = [[[AttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID4] autorelease];
        }
        InfoModel * model = self.fansDataArray[indexPath.row];
        [cell configUI:model];
        UIButton * fansAttentionButton = [MyControl createButtonWithFrame:CGRectMake(320-15-20-5, 23, 30, 30) ImageName:@"14-10.png" Target:self Action:@selector(attentionButtonClick2:) Title:nil];
        [fansAttentionButton setBackgroundImage:[UIImage imageNamed:@"14-11.png"] forState:UIControlStateSelected];
        if (isFansFriend[indexPath.row]) {
            fansAttentionButton.selected = YES;
        }
        fansAttentionButton.tag = 2000+indexPath.row;
        fansAttentionButton.showsTouchWhenHighlighted = YES;
        [cell addSubview:fansAttentionButton];
        cell.selectionStyle = 0;
        return cell;
    }
    
}
#pragma mark -取图片的一部分
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}


#pragma mark -根据经验改变进度条
-(void)changeProgressWithLevel:(int)level
{
    [self setRedBeforeLevel:level];
    if (level<6) {
        float height = (experience-[self.expArray[level-1] floatValue])/([self.expArray[level] floatValue]-[self.expArray[level-1] floatValue])*100;
        
        UIImageView * lineRed = (UIImageView *)[sv viewWithTag:400+level-1];
        lineRed.frame = CGRectMake(145, 67.5+(level-1)*100, 5, height);
        
        UIImageView * lineGray = (UIImageView *)[sv viewWithTag:450+level-1];
        lineGray.frame = CGRectMake(145, lineRed.frame.origin.y+lineRed.frame.size.height, 5, 100-lineRed.frame.size.height);
    }
}
-(void)setRedBeforeLevel:(int)level
{
    for(int i=0;i<level-1;i++){
        UIImageView * lineRed = (UIImageView *)[sv viewWithTag:400+i];
        lineRed.frame = CGRectMake(145, 67.5+i*100, 5, 100);
        UIImageView * lineGray = (UIImageView *)[sv viewWithTag:450+i];
        lineGray.frame = CGRectMake(145, 67.5+lineRed.frame.size.height, 5, 100-lineRed.frame.size.height);
    }
}


#pragma mark -根据经验改变图片
-(void)changeImageWithLevel:(int)level
{
    for(int i=0;i<level;i++){
        UIImageView * level = (UIImageView *)[sv viewWithTag:500+i];
        level.image = [UIImage imageNamed:@"18-3.png"];
        
        UIImageView * food = (UIImageView *)[sv viewWithTag:600+i];
        if ([[USER objectForKey:@"type"] isEqualToString:@"2"]) {
            food.image = [UIImage imageNamed:[NSString stringWithFormat:@"bcat%d_2.png", i+1]];
        }else{
            food.image = [UIImage imageNamed:[NSString stringWithFormat:@"bdog%d_2.png", i+1]];
        }
        
        UIImageView * ball = (UIImageView *)[sv viewWithTag:700+i];
        ball.image = [UIImage imageNamed:@"18-5.png"];
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv2 && indexPath.row == 0) {
        //跳转到账号设置
        SettingViewController * vc = [[SettingViewController alloc] init];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
        [nc release];
        [vc release];
    }else if(tableView == tv){
        PhotoModel * model = self.dataArrayPhotos[indexPath.row];
        //跳转到详情页，并传值
        DetailViewController * vc = [[DetailViewController alloc] init];
        vc.img_id = model.img_id;
        vc.usr_id = model.usr_id;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }else if(tableView == tvAttention){
        OtherHomeViewController * other = [[OtherHomeViewController alloc] init];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:other];
        other.usr_id = [self.attentionDataArray[indexPath.row] usr_id];
        NSLog(@"other.usr_id:%@", other.usr_id);
        [self presentViewController:nc animated:YES completion:nil];
        [other release];
        [nc release];
    }
}
#pragma mark -创建段头视图
-(void)createHeaderView
{
    
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv) {
        return 300;
    }else if(tableView == tv2){
        return 42;
    }else if(tableView == tvExp){
        return self.view.frame.size.height-210;
    }else{
        return 65;
    }
    
}

#pragma mark -照片，关注，粉丝按钮点击事件
-(void)numButtonClick:(UIButton *)button
{
    outButton.hidden = YES;
    [self resetColor];
    [self resetTableHeaderView];
    
    if (button.tag == 201) {
        NSLog(@"照片");
        tvTemp = tv;
        
        tv.hidden = NO;
        tv.tableHeaderView = bgImageView;
        numLabel1.textColor = BGCOLOR;
        photoLabel.textColor = BGCOLOR;
    }else if(button.tag == 202){
        NSLog(@"关注");
        tvTemp = tvAttention;
        tvAttention.hidden = NO;
        tvAttention.tableHeaderView = bgImageView;
        numLabel2.textColor = BGCOLOR;
        attentionLabel.textColor = BGCOLOR;
        [tv2 reloadData];
    }else if(button.tag == 203){
        NSLog(@"粉丝");
        tvTemp = tvFans;
        
        tvFans.hidden = NO;
        tvFans.tableHeaderView = bgImageView;
        numLabel3.textColor = BGCOLOR;
        fansLabel.textColor = BGCOLOR;
    }
}


-(void)homeButtonClick:(UIButton *)button
{
    [self resetTableHeaderView];
    
    if(button.tag == 100){
        //Home
        tv.contentOffset = CGPointMake(0, 0);
        outButton.hidden = YES;
        homeButton.selected = YES;
        setButton.selected = NO;
        expButton.selected = NO;
        tvTemp.hidden = NO;
        bgImageView.frame = CGRectMake(0, 0, 320, 250);
        tvTemp.tableHeaderView = bgImageView;
    }else if(button.tag == 101){
        //Setting
        outButton.hidden = NO;
        homeButton.selected = NO;
        expButton.selected = NO;
        setButton.selected = YES;
        tv2.hidden = NO;
        bgImageView.frame = CGRectMake(0, 0, 320, 210);
        bgImageView.clipsToBounds = YES;
        tv2.tableHeaderView = bgImageView;
        
        [tv2 reloadData];
    }else if(button.tag == 102){
        //Experience
        outButton.hidden = YES;
        homeButton.selected = NO;
        expButton.selected = YES;
        setButton.selected = NO;
        tvExp.hidden = NO;
        bgImageView.frame = CGRectMake(0, 0, 320, 210);
        bgImageView.clipsToBounds = YES;
        tvExp.tableHeaderView = bgImageView;
    }
}

-(void)resetTableHeaderView
{
    tv.tableHeaderView = nil;
    tv2.tableHeaderView = nil;
    tvAttention.tableHeaderView = nil;
    tvFans.tableHeaderView = nil;
    tvExp.tableHeaderView = nil;
    
    tv.hidden = YES;
    tv2.hidden = YES;
    tvAttention.hidden = YES;
    tvFans.hidden = YES;
    tvExp.hidden = YES;
}
-(void)resetColor
{
    numLabel1.textColor = DARKGRAY;
    photoLabel.textColor = DARKGRAY;
    numLabel2.textColor = DARKGRAY;
    attentionLabel.textColor = DARKGRAY;
    numLabel3.textColor = DARKGRAY;
    fansLabel.textColor = DARKGRAY;
}

#pragma mark
#pragma mark -相机拍照，图片处理
-(void)cameraClick
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                return;
            }
        }
        //跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
        [imagePickerController release];
    }
}

#pragma mark - UIImagePicker Delegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    tempImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [tempImage retain];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"您确定要将此图片设置为头像么?" message:Nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 97;
    [alert show];
    [alert release];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark -alertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag /1000 == 1) {
        //关注
        NSString * usr_id = [self.attentionDataArray[alertView.tag%1000] usr_id];
        NSString * code = [NSString stringWithFormat:@"usr_id=%@dog&cat", usr_id];
        NSString * sig = [MyMD5 md5:code];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", UNFOLLOWAPI, usr_id, sig, [ControllerManager getSID]];
        if (buttonIndex) {
            NSLog(@"url:%@", url);
            
            [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    //数据下载成功
                    if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                        [self.attentionDataArray removeObjectAtIndex:alertView.tag%1000];
                        numLabel2.text = [NSString stringWithFormat:@"%d", [numLabel2.text intValue]-1];
                        [self login];
                        oriIndex = 2;
                        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消关注成功 ^_^" ];
                    }else{
                        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消关注失败 = =."];
                    }
                }else{
                    //数据下载失败
                    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消关注请求失败 = =."];
                }
            }];
        }else{
            //未关注
        }
    }else if(alertView.tag == 97){
        //设置头像
        if(buttonIndex){
            headImageView.image = tempImage;
            [self postImage];
            [tv reloadData];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        //粉丝
        NSString * code = [NSString stringWithFormat:@"usr_id=%@dog&cat", self.usr_id];
        NSString * sig = [MyMD5 md5:code];
        NSString * url = nil;
        if (alertView.tag == 200) {
            url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", FOLLOWAPI, self.usr_id, sig, [ControllerManager getSID]];
        }else if(alertView.tag == 201){
            url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", UNFOLLOWAPI, self.usr_id, sig, [ControllerManager getSID]];
        }
        if (buttonIndex) {
            NSLog(@"url:%@", url);
            
            [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    //数据下载成功
                    if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                        UIButton * button = (UIButton *)[self.view viewWithTag:fansButtonIndex];
                        button.selected = !button.selected;
                        [self login];
                        
                        oriIndex = 3;
                        if (alertView.tag == 200) {
                            
                            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"关注成功 ^_^"];
//                            isFansFriend[fansButtonIndex-2000] = YES;
                        }else{
                            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消关注成功 ^_^" ];
//                            isFansFriend[fansButtonIndex-2000] = NO;
                        }
                        
                    }else{
                        if (alertView.tag == 200) {
                            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"关注失败 = =."];
                        }else{
                            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消关注失败 = =."];
                        }
                    }
                }else{
                    //数据下载失败
                    if (alertView.tag == 200) {
                        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"关注请求失败 = =."];
                    }else{
                        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消关注请求失败 = =."];
                    }
                }
            }];
        }else{
            //未关注
        }
    }
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark
#pragma mark -ASI
-(void)postImage
{
    //网络上传
    NSString * url = [NSString stringWithFormat:@"%@%@", TXAPI, [ControllerManager getSID]];
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 20;
    
//    NSData
    
    NSData * data = UIImageJPEGRepresentation(tempImage, 0.1);
    //    NSLog(@"data:%@", data);
    //    [_request setPostValue:data forKey:@"image"];
    [_request setData:data withFileName:@"headImage.png" andContentType:@"image/jpg" forKey:@"tx"];
    
    _request.delegate = self;
    [_request startAsynchronous];
    
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    //头像存放在本地
    NSData * data = UIImageJPEGRepresentation(tempImage, 0.1);
    NSString *docDir = DOCDIR;
    
    NSLog(@"%@",docDir);
    NSLog(@"saving png");
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/headImage.png",docDir];
    
    BOOL a = [data writeToFile:pngFilePath atomically:YES];
    NSLog(@"头像存放结果：%d", a);
    //更新tableView数据

    
    NSLog(@"headImage upload success");
    NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
    [self getUserData];
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"headImage upload failed");
}

#pragma mark -获取用户数据
-(void)getUserData
{
    NSString * url = [NSString stringWithFormat:@"http://54.199.161.210/dc/index.php?r=user/infoApi&&sig=beac851bfcd1b0d3dc98b327aa7fbad2&SID=%@", [ControllerManager getSID]];
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"errorCode"] intValue] == 2) {
                //SID过期,需要重新登录获取SID
                [self login];
                [self getUserData];
                return;
            }else{
                //SID未过期，直接获取用户数据
                NSLog(@"用户数据：%@", load.dataDict);
                NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                [USER setObject:[dict objectForKey:@"age"] forKey:@"age"];
                [USER setObject:[dict objectForKey:@"code"] forKey:@"code"];
                [USER setObject:[dict objectForKey:@"gender"] forKey:@"gender"];
                [USER setObject:[dict objectForKey:@"name"] forKey:@"name"];
                [USER setObject:[dict objectForKey:@"type"] forKey:@"type"];
                [USER setObject:[dict objectForKey:@"usr_id"] forKey:@"usr_id"];
                //                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }];
}
#pragma mark -登录
-(void)login
{
    [[httpDownloadBlock alloc] initWithUrlStr:LOGINAPI Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            [ControllerManager setIsSuccess:[[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]];
            [ControllerManager setSID:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"]];
            NSLog(@"isSuccess:%d,SID:%@", [ControllerManager getIsSuccess], [ControllerManager getSID]);
            [self loadPhotoData];
            if ([ControllerManager getIsSuccess]) {
                [self getUserData];
            }
        }
    }];
}

#pragma mark -退出登录
-(void)outButtonClick
{
    NSLog(@"退出登录");
}

#pragma mark -取消关注button点击事件
-(void)attentionButtonClick:(UIButton *)button
{
    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"提示" Message:@"您确定要取消关注Ta么？" delegate:self cancelTitle:@"不忍心" otherTitles:@"残忍取消"];
    alert.tag = button.tag;
}

-(void)attentionButtonClick2:(UIButton *)button
{
    fansButtonIndex = button.tag;
    self.usr_id = [self.fansDataArray[button.tag-2000] usr_id];
    if (!button.selected) {
        //请求关注API
        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"提示" Message:@"您确定要关注Ta么？" delegate:self cancelTitle:@"我才不要" otherTitles:@"是滴"];
        alert.tag = 200;
    }else{
        //请求解除关注API
        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"提示" Message:@"您确定要取消关注Ta么？" delegate:self cancelTitle:@"不忍心" otherTitles:@"残忍取消"];
        alert.tag = 201;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
