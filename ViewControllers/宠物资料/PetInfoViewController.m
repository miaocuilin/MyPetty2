//
//  PetInfoViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetInfoViewController.h"
#import "UserInfoViewController.h"
#import "MyCountryMessageCell.h"
#import "MyCountryContributeCell.h"
#import "MyPhotoCell.h"
#import "InfoModel.h"
#import "PicDetailViewController.h"
#import "PopularityListViewController.h"
#import "ContributionViewController.h"
@interface PetInfoViewController ()

@end

@implementation PetInfoViewController

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
    self.photosDataArray = [NSMutableArray arrayWithCapacity:0];
    self.userDataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self loadKingData];
    [self loadPhotoData];
    [self createScrollView];
    [self createFakeNavigation];
//    [self createHeader];
    [self createTableView];
    
//    [self.view bringSubviewToFront:self.menuBgBtn];
//    [self.view bringSubviewToFront:self.menuBgView];
}
#pragma mark -请求国王数据
-(void)loadKingData
{
    NET = YES;
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@", INFOAPI, [ControllerManager getSID]]);
    [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", INFOAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            [self.userDataArray removeAllObjects];
            
            NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            InfoModel * model = [[InfoModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.userDataArray addObject:model];
            [model release];
            NSLog(@"%@", [self.userDataArray[0] tx]);

            [self createHeader];
            [self.view bringSubviewToFront:navView];
            [self.view bringSubviewToFront:toolBgView];
            
            [self.view bringSubviewToFront:self.menuBgBtn];
            [self.view bringSubviewToFront:self.menuBgView];
            
            NET = NO;
        }else{
            NSLog(@"用户数据加载失败。");
            NET = NO;
        }
    }];
}

-(void)loadPhotoData
{
    NET = YES;
    [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGESAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            [self.photosDataArray removeAllObjects];
            
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for(int i=0;i<array.count;i++){
                NSDictionary * dict = array[i];
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                
                //model.headImage = tempImage;
                model.title = [USER objectForKey:@"name"];
                model.detail = [USER objectForKey:@"detailName"];
                [self.photosDataArray addObject:model];
                if (i == array.count-1) {
                    self.lastImg_id = model.img_id;
                }
                [model release];
            }
            isPhotoDownload = YES;
            [tv2 reloadData];
            
            [tv2 headerEndRefreshing];
//            self.view.userInteractionEnabled = YES;
        }else{
            [tv2 headerEndRefreshing];
//            self.view.userInteractionEnabled = YES;
            NSLog(@"数据加载失败。");
            NET = NO;
        }
    }];
}
-(void)createFakeNavigation
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
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"我的王国"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIImageView * more = [MyControl createImageViewWithFrame:CGRectMake(280, 38, 47/2, 9/2) ImageName:@"threePoint.png"];
    [navView addSubview:more];
    
    UIButton * moreBtn = [MyControl createButtonWithFrame:CGRectMake(270, 25, 47/2+20, 9/2+16+10) ImageName:@"" Target:self Action:@selector(moreBtnClick) Title:nil];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];

    moreBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:moreBtn];
}

#pragma mark - 导航点击事件
-(void)backBtnClick
{
    NSLog(@"back");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)moreBtnClick
{
    NSLog(@"more");
    if (!isMoreCreated) {
        //create more
        [self createMore];
    }
    //show more
    alphaBtn.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        moreView.frame = CGRectMake(0, self.view.frame.size.height-234, 320, 234);
        alphaBtn.alpha = 0.5;
    }];

}
#pragma mark - 创建更多视图
-(void)createMore
{
    alphaBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:nil];
    alphaBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:alphaBtn];
    alphaBtn.alpha = 0;
    alphaBtn.hidden = YES;
    
    // 318*234
    moreView = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 234)];
    moreView.backgroundColor = [ControllerManager colorWithHexString:@"efefef"];
    [self.view addSubview:moreView];
    
    //orange line
    UIView * orangeLine = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 4)];
    orangeLine.backgroundColor = [ControllerManager colorWithHexString:@"fc7b51"];
    [moreView addSubview:orangeLine];
    //label
    UILabel * shareLabel = [MyControl createLabelWithFrame:CGRectMake(15, 10, 80, 15) Font:13 Text:@"分享到"];
    shareLabel.textColor = [UIColor blackColor];
    [moreView addSubview:shareLabel];
    //3个按钮
    NSArray * arr = @[@"more_weixin.png", @"more_friend.png", @"more_sina.png"];
    NSArray * arr2 = @[@"微信好友", @"朋友圈", @"微博"];
    for(int i=0;i<3;i++){
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(40+i*92, 33, 42, 42) ImageName:arr[i] Target:self Action:@selector(shareClick:) Title:nil];
        button.tag = 200+i;
        [moreView addSubview:button];
        
        CGRect rect = button.frame;
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(rect.origin.x-10, rect.origin.y+rect.size.height+5, rect.size.width+20, 15) Font:12 Text:arr2[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
//        label.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [moreView addSubview:label];
    }
    //grayLine1
    UIView * grayLine1 = [MyControl createViewWithFrame:CGRectMake(0, 105, 320, 2)];
    grayLine1.backgroundColor = [ControllerManager colorWithHexString:@"e3e3e3"];
    [moreView addSubview:grayLine1];
    
    //stranger and fakeOwner 20 127
    UIView * strangerAndFakeOwnerView = [MyControl createViewWithFrame:CGRectMake(0, 127, 320, 76/2)];
    [moreView addSubview:strangerAndFakeOwnerView];
    
    UIButton * addBtn = [MyControl createButtonWithFrame:CGRectMake(20, 0, 124, 76/2) ImageName:@"more_greenBg.png" Target:self Action:@selector(addBtnClick:) Title:@"加入"];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"more_orangeBg.png"] forState:UIControlStateSelected];
    [addBtn setTitle:@"已加入" forState:UIControlStateSelected];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [strangerAndFakeOwnerView addSubview:addBtn];
    
    UIButton * attentionBtn = [MyControl createButtonWithFrame:CGRectMake(354/2, 0, 124, 76/2) ImageName:@"more_greenBg.png" Target:self Action:@selector(attentionBtnClick:) Title:@"关注"];
    [attentionBtn setBackgroundImage:[UIImage imageNamed:@"more_orangeBg.png"] forState:UIControlStateSelected];
    [attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [strangerAndFakeOwnerView addSubview:attentionBtn];
    
//    strangerAndFakeOwnerView.hidden = YES;
    
    //OwnerView
    UIView * ownerView = [MyControl createViewWithFrame:CGRectMake(0, 127, 320, 76/2)];
    [moreView addSubview:ownerView];
    
    UIButton * takePhoto = [MyControl createButtonWithFrame:CGRectMake(30, 0, 526/2, 76/2) ImageName:@"" Target:self Action:@selector(takePhoto) Title:@"拍照"];
    [takePhoto setBackgroundImage:[[UIImage imageNamed:@"more_greenBg.png"]stretchableImageWithLeftCapWidth:100 topCapHeight:30] forState:UIControlStateNormal];
    takePhoto.titleLabel.font = [UIFont systemFontOfSize:15];
    [ownerView addSubview:takePhoto];
    
    ownerView.hidden = YES;
    
    //grayLine2
    UIView * grayLine2 = [MyControl createViewWithFrame:CGRectMake(0, 180, 320, 5)];
    grayLine2.backgroundColor = [ControllerManager colorWithHexString:@"e3e3e3"];
    [moreView addSubview:grayLine2];
    
    //cancelBtn
    UIButton * cancelBtn = [MyControl createButtonWithFrame:CGRectMake(0, 188, 320, 46) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:@"取消"];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.showsTouchWhenHighlighted = YES;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [moreView addSubview:cancelBtn];
}
-(void)shareClick:(UIButton *)button
{
    if (button.tag == 200) {
        NSLog(@"微信");
    }else if(button.tag == 201){
        NSLog(@"朋友圈");
    }else{
        NSLog(@"微博");
    }
}
-(void)addBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
}
-(void)attentionBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
}
-(void)takePhoto
{
    NSLog(@"take photos");
}
-(void)cancelBtnClick
{
    NSLog(@"cancel");
    [UIView animateWithDuration:0.3 animations:^{
        moreView.frame = CGRectMake(0, self.view.frame.size.height, 320, 234);
        alphaBtn.alpha = 0;
    } completion:^(BOOL finished) {
        alphaBtn.hidden = YES;
    }];
}
#pragma mark - 创建tableView的tableHeaderView
-(void)createHeader
{
    bgView = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 200)];
    [self.view addSubview:bgView];
    
    //
    bgImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    /************************/
    NSString * txFilePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [self.userDataArray[0] tx]]];
    NSLog(@"%@", txFilePath);
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txFilePath]];
    if (image) {
        bgImageView1.image = [image applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    }else{
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, [self.userDataArray[0] tx]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                //本地目录，用于存放favorite下载的原图
                NSString * docDir = DOCDIR;
                NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [self.userDataArray[0] tx]]];
                //将下载的图片存放到本地
                [load.data writeToFile:txFilePath atomically:YES];
                bgImageView1.image = [load.dataImage applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
            }else{
                NSLog(@"download failed");
            }
        }];
    }
    /************************/
    [bgView addSubview:bgImageView1];
    [bgImageView1 release];


    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 200)];
    alphaView.alpha = 0.7;
    alphaView.backgroundColor = [ControllerManager colorWithHexString:@"a85848"];
    [bgView addSubview:alphaView];
    
    UIImageView * headerView = [MyControl createImageViewWithFrame:CGRectMake(10, 25, 70, 70) ImageName:@""];
    headerView.layer.cornerRadius = 70/2;
    headerView.layer.masksToBounds = YES;
    [bgView addSubview:headerView];
    if (image) {
        headerView.image = image;
    }else{
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, [self.userDataArray[0] tx]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                //本地目录，用于存放favorite下载的原图
                NSString * docDir = DOCDIR;
                NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [self.userDataArray[0] tx]]];
                //将下载的图片存放到本地
                [load.data writeToFile:txFilePath atomically:YES];
                headerView.image = load.dataImage;
            }else{
                NSLog(@"download failed");
            }
        }];
    }
    
    UIButton * attentionBtn = [MyControl createButtonWithFrame:CGRectMake(60, 75, 20, 20) ImageName:@"" Target:self Action:@selector(attentionBtnClick) Title:@"关注"];
    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    attentionBtn.layer.cornerRadius = 20/2;
    attentionBtn.layer.masksToBounds = YES;
    attentionBtn.backgroundColor = BGCOLOR4;
//    attentionBtn.showsTouchWhenHighlighted = YES;
    [bgView addSubview:attentionBtn];
    
    //
    NSString * str = [self.userDataArray[0] name];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(100, 100) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel * name = [MyControl createLabelWithFrame:CGRectMake(105, 25, size.width+5, 20) Font:15 Text:str];
    [bgView addSubview:name];
    
    UIImageView * sex = [MyControl createImageViewWithFrame:CGRectMake(name.frame.origin.x+name.frame.size.width, 25, 14, 17) ImageName:@"woman"];
    if ([[self.userDataArray[0] gender] intValue] == 1) {
        sex.image = [UIImage imageNamed:@"man.png"];
    }
    [bgView addSubview:sex];
    
    //
    UILabel * cateNameLabel = [MyControl createLabelWithFrame:CGRectMake(105, 55, 130, 20) Font:14 Text:[NSString stringWithFormat:@"苏格兰折耳猫 | %@岁", [self.userDataArray[0] age]]];
    cateNameLabel.font = [UIFont boldSystemFontOfSize:13];
//    cateNameLabel.alpha = 0.65;
    [bgView addSubview:cateNameLabel];
    
    /*****************************/
    int a = [[self.userDataArray[0] type] intValue];
    NSLog(@"%@--%d", [self.userDataArray[0] type], a);
    NSString * cateName = nil;
    
    if (a/100 == 1) {
        cateName = [[[USER objectForKey:@"CateNameList"]objectForKey:@"1"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else if(a/100 == 2){
        cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"2"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else if(a/100 == 3){
        cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"3"] objectForKey:[NSString stringWithFormat:@"%d", a]];
    }else{
        cateName = @"未知物种";
    }
    if (cateName == nil) {
        //更新本地宠物名单列表
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", TYPEAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                [USER setObject:[load.dataDict objectForKey:@"data"] forKey:@"CateNameList"];
                NSString * path = [DOCDIR stringByAppendingPathComponent:@"CateNameList.plist"];
                NSMutableDictionary * data = [load.dataDict objectForKey:@"data"];
                //本地及内存存储
                [data writeToFile:path atomically:YES];
                [USER setObject:data forKey:@"CateNameList"];
                int a = [[self.userDataArray[0] type] intValue];
                NSString * cateName = nil;
                
                if (a/100 == 1) {
                    cateName = [[[USER objectForKey:@"CateNameList"]objectForKey:@"1"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else if(a/200 == 2){
                    cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"2"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else if(a/200 == 3){
                    cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"3"] objectForKey:[NSString stringWithFormat:@"%d", a]];
                }else{
                    cateName = @"未知物种";
                }
                cateNameLabel.text = [NSString stringWithFormat:@"%@ | %@岁", cateName, [self.userDataArray[0] age]];
            }
        }];
        
    }else{
        cateNameLabel.text = [NSString stringWithFormat:@"%@ | %@岁", cateName, [self.userDataArray[0] age]];
    }
    /*****************************/
    //
    NSString * str2= @"祭司 — Anna";
    CGSize size2 = [str2 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 100) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel * positionAndUserName = [MyControl createLabelWithFrame:CGRectMake(105, 170/2, size2.width, 20) Font:15 Text:str2];
//    positionAndUserName.font = [UIFont boldSystemFontOfSize:15];
    [bgView addSubview:positionAndUserName];
    
    //用户头像，点击进入个人中心
    UIButton * userImageBtn = [MyControl createButtonWithFrame:CGRectMake(positionAndUserName.frame.origin.x+positionAndUserName.frame.size.width+5, 160/2, 30, 30) ImageName:@"cat1.jpg" Target:self Action:@selector(jumpToUserInfo) Title:nil];
    userImageBtn.layer.cornerRadius = 15;
    userImageBtn.layer.masksToBounds = YES;
    [bgView addSubview:userImageBtn];
    
    //123  164
    UIImageView * flagImageView = [MyControl createImageViewWithFrame:CGRectMake(240, 0, 124/2, 164/2) ImageName:@"flag.png"];
    [bgView addSubview:flagImageView];
    
    UIButton * GXList = [MyControl createButtonWithFrame:CGRectMake(2, 3, 55, 25) ImageName:@"" Target:self Action:@selector(GXListClick) Title:@""];
    GXList.titleLabel.font = [UIFont systemFontOfSize:12];
//    GXList.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    GXList.showsTouchWhenHighlighted = YES;
    [flagImageView addSubview:GXList];

    UIButton * RQList = [MyControl createButtonWithFrame:CGRectMake(2, 32, 55, 25) ImageName:@"" Target:self Action:@selector(RQListClick) Title:@""];
//    RQList.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    RQList.titleLabel.font = [UIFont systemFontOfSize:12];
    RQList.showsTouchWhenHighlighted = YES;
    [flagImageView addSubview:RQList];
    
    //人气、成员、粉丝数
    NSString * dataStr = [NSString stringWithFormat:@"总人气 %d  |   成员 123  |   粉丝 %d", [[self.userDataArray[0] exp] intValue], [[self.userDataArray[0] follower] intValue]];
    UILabel * dataLabel = [MyControl createLabelWithFrame:CGRectMake(0, 130, 320, 15) Font:13 Text:dataStr];
    dataLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:dataLabel];
    
}
#pragma mark - 跳转点击事件
-(void)jumpToUserInfo
{
    UserInfoViewController * vc = [[UserInfoViewController alloc] init];
    vc.modalTransitionStyle = 2;
    vc.isFromPetInfo = YES;
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)GXListClick
{
    NSLog(@"跳转贡献榜");
    ContributionViewController * vc = [[ContributionViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)RQListClick
{
    NSLog(@"跳转人气榜");
    PopularityListViewController * vc = [[PopularityListViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)attentionBtnClick
{
    NSLog(@"attention");
}
#pragma mark - 创建scrollView
-(void)createScrollView
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    sv.contentSize = CGSizeMake(320*4, self.view.frame.size.height);
    sv.delegate = self;
    sv.pagingEnabled = YES;
    sv.scrollEnabled = NO;
    [self.view addSubview:sv];
}

#pragma mark - 创建tableView
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = 0;
    [sv addSubview:tv];
    
    UIView * tvHeaderView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 264)];
    tv.tableHeaderView = tvHeaderView;
    
    //
    tv2 = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv2.delegate = self;
    tv2.dataSource = self;
    tv2.separatorStyle = 0;
    [sv addSubview:tv2];
    
    UIView * tvHeaderView2 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 264)];
    tv2.tableHeaderView = tvHeaderView2;
    
    //
    tv3 = [[UITableView alloc] initWithFrame:CGRectMake(320*2, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv3.delegate = self;
    tv3.dataSource = self;
    [sv addSubview:tv3];
    
    UIView * tvHeaderView3 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 264)];
    tv3.tableHeaderView = tvHeaderView3;
    
    //
    tv4 = [[UITableView alloc] initWithFrame:CGRectMake(320*3, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv4.delegate = self;
    tv4.dataSource = self;
    [sv addSubview:tv4];
    
    UIView * tvHeaderView4 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 264)];
    tv4.tableHeaderView = tvHeaderView4;
    
    [self.view bringSubviewToFront:bgView];
    [self.view bringSubviewToFront:navView];
    
    //为保证切换条在所有层的最上面，所以在此创建
    toolBgView = [MyControl createViewWithFrame:CGRectMake(0, 64+200-44, 320, 44)];
    [self.view addSubview:toolBgView];
    
    UIView * toolAlphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 44)];
    toolAlphaView.alpha = 0.3;
    toolAlphaView.backgroundColor = [UIColor blackColor];
    [toolBgView addSubview:toolAlphaView];
    
    NSArray * unSeletedArray = @[@"tool1.png", @"tool2.png", @"tool3.png", @"tool4.png"];
    NSArray * seletedArray = @[@"tool1_selected.png", @"tool2_selected.png", @"tool3_selected.png", @"tool4_selected.png"];
    for(int i=0;i<seletedArray.count;i++){
        UIButton * imageButton = [MyControl createButtonWithFrame:CGRectMake(25+i*80, 9, 30, 26) ImageName:unSeletedArray[i] Target:self Action:@selector(imageButtonClick) Title:nil];
        [imageButton setBackgroundImage:[UIImage imageNamed:seletedArray[i]] forState:UIControlStateSelected];
        [toolBgView addSubview:imageButton];
        imageButton.tag = 100+i;
        if (i == 0) {
            imageButton.selected = YES;
        }
        
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(i*80, 0, 80, 44) ImageName:@"" Target:self Action:@selector(toolBtnClick:) Title:nil];
        button.tag = 200+i;
        [toolBgView addSubview:button];
    }
    //移动底条
    bottom = [MyControl createViewWithFrame:CGRectMake(0, 40, 80, 4)];
    bottom.backgroundColor = BGCOLOR;
    [toolBgView addSubview:bottom];
}
-(void)imageButtonClick
{

}
-(void)toolBtnClick:(UIButton *)button
{
    for(int i=0;i<4;i++){
        UIButton * btn = (UIButton *)[toolBgView viewWithTag:100+i];
        btn.selected = NO;
    }
    int a = button.tag;
    UIButton * temp = (UIButton *)[toolBgView viewWithTag:a-100];
    temp.selected = YES;
    
    int x = a-200;
    if (x == 0) {
        tempTv = tv;
    }else if(x == 1){
        tempTv = tv2;
    }else if(x == 2){
        tempTv = tv3;
    }else{
        tempTv = tv4;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        bottom.frame = CGRectMake(x*80, 40, 80, 4);
//        tempTv.contentOffset = CGPointMake(0, 0);
//        tempTv = nil;
//        bgView.frame = CGRectMake(0, 64, 320, 200);
//        toolBgView.frame = CGRectMake(0, 64+200-44, 320, 44);
        sv.contentOffset = CGPointMake(320*x, 0);
    }];
    
}

#pragma mark - scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollView.contentOffset.y = %f", scrollView.contentOffset.y);
    int x = sv.contentOffset.x;
    
    if (scrollView == sv && x%320 == 0) {
        tempTv = nil;
        if (x/320 == 0) {
            tempTv = tv;
        }else if(x/320 == 1){
            tempTv = tv2;
        }else if(x/320 == 2){
            tempTv = tv3;
        }else{
            tempTv = tv4;
        }
        //对应的按钮变颜色
        UIButton * button = (UIButton *)[toolBgView viewWithTag:200+x/320];
        [self toolBtnClick:button];
        //小橘条位置变化
        [UIView animateWithDuration:0.2 animations:^{
            bottom.frame = CGRectMake(80*x/320, 40, 80, 4);
            tempTv.contentOffset = CGPointMake(0, 0);
            tempTv = nil;
            bgView.frame = CGRectMake(0, 64, 320, 200);
            toolBgView.frame = CGRectMake(0, 64+200-44, 320, 44);
        }];
    }
    
    if (scrollView != sv) {
        bgView.frame = CGRectMake(0, 64-scrollView.contentOffset.y, 320, 200);
        //
        if (scrollView.contentOffset.y<=200-44) {
            toolBgView.frame = CGRectMake(0, 64+200-44-scrollView.contentOffset.y, 320, 44);
        }else{
            toolBgView.frame = CGRectMake(0, 64, 320, 44);
            
        }
    }

}
#pragma mark - tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tv2) {
        return self.photosDataArray.count;
    }else if(tableView == tv4){
        return 1;
    }else{
        return 20;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv) {
        static NSString * cellID = @"ID";
        MyCountryMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[[MyCountryMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        }
        cell.selectionStyle = 0;
        cell.clipsToBounds = YES;
        [cell modifyWithType:indexPath.row%7+1];
        return cell;
    }else if (tableView == tv2) {
        static NSString * cellID2 = @"ID2";
        MyPhotoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if(!cell){
            cell = [[[MyPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2] autorelease];
        }
        cell.selectionStyle = NO;

        //照片下载完后加载
        if (isPhotoDownload) {
            PhotoModel * model = self.photosDataArray[indexPath.row];
            [cell configUI:model];
//            NSLog(@"照片张数%d", self.photosDataArray.count);
            
            //本地目录，用于存放下载的原图
            NSString * docDir = DOCDIR;
            if (!docDir) {
                NSLog(@"Documents 目录未找到");
            }else{
                NSString * filePath2 = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_small.png", model.url]];
                UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath2]];
                if (image) {
                    cell.bigImageView.image = image;
//                    cell.bigImageView.frame = CGRectMake(0, 0,  image.size.width, image.size.height);
//                    NSLog(@"%f--%f", cell.bigImageView.frame.size.width, cell.bigImageView.frame.size.height);
//                    cell.bigImageView.center = CGPointMake(320/2, 100);
                }else{
                    [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                        if (isFinish) {
                            //本地目录，用于存放favorite下载的原图
                            NSString * docDir = DOCDIR;
                            if (!docDir) {
                                NSLog(@"Documents 目录未找到");
                            }else{
                                NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.url]];
                                NSString * filePath2 = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_small.png", model.url]];
                                //将下载的图片存放到本地
                                [load.data writeToFile:filePath atomically:YES];
                                
                                float width = load.dataImage.size.width;
                                float height = load.dataImage.size.height;
                                if (width>320) {
                                    float w = 320/width;
                                    width *= w;
                                    height *= w;
                                }
                                if (width<320) {
                                    width = 320;
                                    height = 320/width*height;
                                }
                                UIImage * image = [load.dataImage imageByScalingToSize:CGSizeMake(width, height)];
                                
                                if (image.size.height>200) {
                                    image = [MyControl imageFromImage:image inRect:CGRectMake(0, height/2-100, width, 200)];
                                    height = 200;
                                }
                                cell.bigImageView.image = image;
                                
                                NSData * smallImageData = UIImagePNGRepresentation(image);
                                [smallImageData writeToFile:filePath2 atomically:YES];
//                                cell.bigImageView.frame = CGRectMake(0, 0, width, height);
//                                cell.bigImageView.center = CGPointMake(320/2, 100);
                            }
                        }else{
                        }
                    }];
                }
            }
        }
        
        return cell;
    }else if (tableView == tv3) {
        static NSString * cellID3 = @"ID3";
        MyCountryContributeCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCountryContributeCell" owner:self options:nil] objectAtIndex:0];
        }
        if (indexPath.row == 0) {
            [cell modifyWithBOOL:YES lineNum:indexPath.row];
        }else{
            [cell modifyWithBOOL:NO lineNum:indexPath.row];
        }
        return cell;
    }else{
        static NSString * cellID4 = @"ID4";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID4];
        if(!cell){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID4] autorelease];
        }
        cell.selectionStyle = 0;
        
        for(int i=0;i<3*10;i++){
            CGRect rect = CGRectMake(20+i%3*100, 15+i/3*100, 85, 90);
            UIImageView * imageView = [MyControl createImageViewWithFrame:rect ImageName:@"giftBg.png"];
            [cell addSubview:imageView];
            
            UIImageView * triangle = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 32, 32) ImageName:@"gift_triangle.png"];
            [imageView addSubview:triangle];
            
            UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(-3, 1, 20, 9) Font:8 Text:@"人气"];
            rq.font = [UIFont boldSystemFontOfSize:8];
            rq.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
            [triangle addSubview:rq];
            
            UILabel * rqNum = [MyControl createLabelWithFrame:CGRectMake(-1, 8, 25, 10) Font:9 Text:@"+150"];
            rqNum.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
            rqNum.textAlignment = NSTextAlignmentCenter;
//            rqNum.backgroundColor = [UIColor redColor];
            [triangle addSubview:rqNum];
            
            UILabel * giftName = [MyControl createLabelWithFrame:CGRectMake(0, 5, 85, 15) Font:11 Text:@"汪汪项圈"];
            giftName.textColor = [UIColor grayColor];
            giftName.textAlignment = NSTextAlignmentCenter;
            [imageView addSubview:giftName];
            
            UIImageView * giftPic = [MyControl createImageViewWithFrame:CGRectMake(20, 20, 45, 45) ImageName:[NSString stringWithFormat:@"bother%d_2.png", arc4random()%6+1]];
            [imageView addSubview:giftPic];
            
            UIImageView * gift = [MyControl createImageViewWithFrame:CGRectMake(20, 90-14-5, 12, 14) ImageName:@"detail_gift.png"];
            [imageView addSubview:gift];
            
            UILabel * giftNum = [MyControl createLabelWithFrame:CGRectMake(35, 90-18, 40, 15) Font:13 Text:@" × 3"];
            giftNum.textColor = BGCOLOR;
            [imageView addSubview:giftNum];
            
            UIButton * button = [MyControl createButtonWithFrame:rect ImageName:@"" Target:self Action:@selector(buttonClick:) Title:nil];
            [cell addSubview:button];
            button.tag = 1000+i;
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv2) {
        PhotoModel * model = self.photosDataArray[indexPath.row];
        //跳转到详情页，并传值
        PicDetailViewController * vc = [[PicDetailViewController alloc] init];
        vc.img_id = model.img_id;
        vc.usr_id = model.usr_id;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv) {
        int a = indexPath.row%7+1;
        if (a == 1) {
            return 90.0f;
        }else if (a == 2) {
            return 70.0f;
        }else if (a == 3) {
            return 130.0f;
        }else if (a == 4) {
            return 90.0f;
        }else if (a == 5) {
            return 90.0f;
        }else if (a == 6) {
            return 70.0f;
        }else{
            return 70.0f;
        }
    }else if (tableView == tv2) {
        return 230.0f;
    }else if (tableView == tv3) {
        return 72.0f;
    }else{
        return 15+10*100;
    }
    //
    
}

//礼物点击事件
-(void)buttonClick:(UIButton *)btn
{
    NSLog(@"%d", btn.tag);
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
//-(void)createNavigation
//{
//    self.title = @"猫君王国";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.navigationController.navigationBar.translucent = NO;
//    if (iOS7) {
//        self.navigationController.navigationBar.barTintColor = BGCOLOR;
//    }else{
//        self.navigationController.navigationBar.tintColor = BGCOLOR;
//    }
//    
//    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 28, 28) ImageName:@"7-7.png" Target:self Action:@selector(backBtnClick) Title:nil];
//    backBtn.tag = 5;
//    backBtn.showsTouchWhenHighlighted = YES;
//    
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = leftItem;
//    [leftItem release];
//    
//    UIButton * joinBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 45, 25) ImageName:@"" Target:self Action:@selector(joinBtnClick) Title:@"加入"];
//    joinBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    joinBtn.backgroundColor = BGCOLOR4;
//    joinBtn.layer.cornerRadius = 5;
//    joinBtn.layer.masksToBounds = YES;
//    joinBtn.showsTouchWhenHighlighted = YES;
//    
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:joinBtn];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    [rightItem release];
//}

@end
