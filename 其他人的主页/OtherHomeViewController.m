//
//  OtherHomeViewController.m
//  MyPetty
//
//  Created by Aidi on 14-6-10.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "OtherHomeViewController.h"
#import "MyPhotoCell.h"
#import "InfoModel.h"
#import "DetailViewController.h"
#define DARKGRAY [UIColor darkGrayColor]
#import "TalkViewController.h"
@interface OtherHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIAlertViewDelegate>

@end

@implementation OtherHomeViewController

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
    self.userDataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    [self loadUserData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidden) name:@"af" object:nil];
}
-(void)hidden
{
    [afView hide];
}

#pragma mark - 改变loading动画颜色
//-(UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index
//{
//    return BGCOLOR;
//}
-(void)loadUserData
{
    //Loading界面开始启动
//    indicatorView = [[MONActivityIndicatorView alloc] init];
//    indicatorView.delegate = self;
//    indicatorView.numberOfCircles = 4;
//    indicatorView.radius = 10;
//    indicatorView.internalSpacing = 3;
//    indicatorView.center = CGPointMake(320/2, (self.view.frame.size.height-[MyControl isIOS7])/2-[MyControl isIOS7]/2);
//    indicatorView.center = self.view.center;
//    [self.view addSubview:indicatorView];
//    [indicatorView startAnimating];
    
    NSString * code = [NSString stringWithFormat:@"usr_id=%@dog&cat", self.usr_id];
    NSString * sig = [MyMD5 md5:code];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERINFOAPI, self.usr_id, sig, [ControllerManager getSID]];
    NSLog(@"url:%@", url);
    
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            [self.userDataArray removeAllObjects];
            NSLog(@"userData:%@", load.dataDict);

            if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"isFriend"] intValue]) {
                isFriend = 1;
            }
            
            NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectForKey:@"user"];
            InfoModel * model = [[InfoModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.userDataArray addObject:model];
            NSLog(@"%@---%@", model.usr_id, model.name);
            [model release];
            [self loadData];
        }else{
//            [indicatorView stopAnimating];
            NSLog(@"用户信息下载失败");
        }
    }];
}
-(void)loadData
{
//    [indicatorView startAnimating];
    NSString * code = [NSString stringWithFormat:@"usr_id=%@dog&cat", self.usr_id];
    NSString * sig = [MyMD5 md5:code];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", OTHERIMAGESAPI, self.usr_id, sig, [ControllerManager getSID]];
    NSLog(@"imageUrl:%@", url);
    
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            [self.dataArray removeAllObjects];
            NSLog(@"---%@", load.dataDict);
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                [model release];
            }

            [self createTableView];
//            [self createHeader];
//            [tv reloadData];
//            [indicatorView stopAnimating];
            [tv headerEndRefreshing];
            self.view.userInteractionEnabled = YES;
        }else{
            self.view.userInteractionEnabled = YES;
//            [indicatorView stopAnimating];
            [tv headerEndRefreshing];
            NSLog(@"用户图片下载失败");
        }
    }];
}


#pragma mark -buttonClick事件
-(void)leftButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightButtonClick
{
    NSLog(@"rightButtonClick");

    TalkViewController * vc = [[TalkViewController alloc] init];
    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.userDataArray = self.userDataArray;
    afView = [AFPopupView popupWithView:nc.view];
    [afView show];
//    [self presentViewController:nc animated:YES completion:nil];
//    [vc release];
//    [nc release];
}


-(void)createTableView
{
    //356/2
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    [tv addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tv addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.view addSubview:tv];
    tv.tableHeaderView = [self createHeader];
    
    [tv release];
}
#pragma mark - 上下拉刷新
-(void)headerRefresh
{
    self.view.userInteractionEnabled = NO;
    [self loadData];
}
-(void)footerRefresh
{
    [self loadMorePhotos];
}
-(void)loadMorePhotos
{
//    [indicatorView startAnimating];
    self.view.userInteractionEnabled = NO;
    
    NSString * str = [NSString stringWithFormat:@"img_id=%@&usr_id=%@dog&cat", [self.dataArray[self.dataArray.count-1] img_id], [self.userDataArray[0] usr_id]];
    NSString * sig = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&usr_id=%@&sig=%@&SID=%@", OTHERIMAGESAPI2, [self.dataArray[self.dataArray.count-1] img_id], [self.userDataArray[0] usr_id], sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                [model release];
            }
//            [indicatorView stopAnimating];
            self.view.userInteractionEnabled = YES;
            [tv reloadData];
            [tv footerEndRefreshing];
        }else{
            self.view.userInteractionEnabled = YES;
//            [indicatorView stopAnimating];
            [tv footerEndRefreshing];
            NSLog(@"数据加载失败。");
        }
    }];
}

#pragma mark - 创建头视图
-(UIView *)createHeader
{
    navImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, 55) ImageName:@"20-1-2.png"];
    [self.view addSubview:navImageView];
    navImageView.hidden = YES;
    
    //照片
    UILabel * numLabel2 = [MyControl createLabelWithFrame:CGRectMake(10+5+10+15, 55-30-1, 50, 30) Font:25 Text:[NSString stringWithFormat:@"%@", [self.userDataArray[0] imagesCount]]];
    numLabel2.textColor = BGCOLOR;
    numLabel2.textAlignment = NSTextAlignmentRight;
    [navImageView addSubview:numLabel2];
    UILabel * photoLabel1 = [MyControl createLabelWithFrame:CGRectMake(60+5+10+15, 55-15-9, 30, 20) Font:14 Text:@"照片"];
    photoLabel1.textColor = BGCOLOR;
    [navImageView addSubview:photoLabel1];
    
    UIImageView * bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 356/2) ImageName:@"20-1.png"];
//    [self.view addSubview:bgImageView];
    
    
    UIButton * buttonLeft = [MyControl createButtonWithFrame:CGRectMake(17, 25, 30, 30) ImageName:@"14-6.png" Target:self Action:@selector(leftButtonClick) Title:nil];
    buttonLeft.showsTouchWhenHighlighted = YES;
    [self.view addSubview:buttonLeft];
    
    UIButton * buttonRight = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-17-23, 35-3, 46*0.5, 32*0.5) ImageName:@"message.png" Target:self Action:@selector(rightButtonClick) Title:nil];
    buttonRight.showsTouchWhenHighlighted = YES;
    [self.view addSubview:buttonRight];
    
//    headImageView = [MyControl createImageViewWithFrame:CGRectMake(17, (356-72-28-128)/2, 64, 64) ImageName:@""];
    headImageView = [[ClickImage alloc] initWithFrame:CGRectMake(17, (356-72-28-128)/2, 64, 64)];
    headImageView.layer.cornerRadius = 32;
    headImageView.layer.masksToBounds = YES;
    [bgImageView addSubview:headImageView];
    headImageView.canClick = YES;
    
    //头像的加载
    NSString * txFilePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [self.userDataArray[0] tx]]];
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txFilePath]];
    if (image) {
        headImageView.image = image;
    }else{
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, [self.userDataArray[0] tx]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                //本地目录，用于存放favorite下载的原图
                NSString * docDir = DOCDIR;
                NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [self.userDataArray[0] tx]]];
                //将下载的图片存放到本地
                [load.data writeToFile:txFilePath atomically:YES];
                headImageView.image = load.dataImage;
            }else{
                
            }
        }];
    }
    
    addButton = [MyControl createButtonWithFrame:CGRectMake(17+64-30+5, headImageView.frame.origin.y+64-30, 30, 30) ImageName:@"unAttention.png" Target:self Action:@selector(addButtonClick:) Title:nil];
    [addButton setImage:[UIImage imageNamed:@"attention.png"] forState:UIControlStateSelected];
    addButton.showsTouchWhenHighlighted = YES;
    if (isFriend == 1) {
        addButton.selected = YES;
    }
    [bgImageView addSubview:addButton];
    
    CGSize size = [[self.userDataArray[0] name] sizeWithFont:[UIFont boldSystemFontOfSize:17] forWidth:150 lineBreakMode:1];
    UILabel * nameLabel = [MyControl createLabelWithFrame:CGRectMake(headImageView.frame.origin.x+64+10, headImageView.frame.origin.y+5, 150, 20) Font:17 Text:[self.userDataArray[0] name]];
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    if (size.width<150) {
        nameLabel.frame = CGRectMake(headImageView.frame.origin.x+64+10, headImageView.frame.origin.y+5, size.width, 20);
    }else{
        nameLabel.adjustsFontSizeToFitWidth = YES;
    }
    nameLabel.textColor = [UIColor blackColor];
    [bgImageView addSubview:nameLabel];
    
    //性别
    UIImageView * sex = [MyControl createImageViewWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+5, nameLabel.frame.origin.y, 28*0.75, 34*0.75) ImageName:@""];
    if ([[self.userDataArray[0] gender] intValue] == 1) {
        //公
        sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    [bgImageView addSubview:sex];
    
    
    UILabel * cateNameLabel = [MyControl createLabelWithFrame:CGRectMake(headImageView.frame.origin.x+64+10, headImageView.frame.origin.y+5+20+15, 150, 20) Font:16 Text:[NSString stringWithFormat:@"苏格兰折耳猫 | %@岁", [self.userDataArray[0] age]]];
    cateNameLabel.font = [UIFont boldSystemFontOfSize:16];
    cateNameLabel.textColor = [UIColor grayColor];
    [bgImageView addSubview:cateNameLabel];
    
    int a = [[self.userDataArray[0] type] intValue];
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
    
    
    //微信微博按钮
    UIButton * sina = [MyControl createButtonWithFrame:CGRectMake(320-45-15, cateNameLabel.frame.origin.y-15, 30, 30) ImageName:@"weibo-1.png" Target:self Action:@selector(sinaButtonClick:) Title:nil];
    sina.showsTouchWhenHighlighted = YES;
    [bgImageView addSubview:sina];
    
//    UIButton * sns = [MyControl createButtonWithFrame:CGRectMake(320-30-15, cateNameLabel.frame.origin.y-5, 30, 30) ImageName:@"2-1.png" Target:self Action:@selector(snsButtonClick:) Title:nil];
//    sns.showsTouchWhenHighlighted = YES;
//    [bgImageView addSubview:sns];
    
    UIImageView * line = [MyControl createImageViewWithFrame:CGRectMake(0, headImageView.frame.origin.y+64+14, self.view.frame.size.width, 1) ImageName:@"20-灰色线.png"];
    [bgImageView addSubview:line];
    
    /*************华丽分割线*******************/
    
    //照片
    numLabel1 = [MyControl createLabelWithFrame:CGRectMake(10+5+10+15, line.frame.origin.y+5, 50, 30) Font:25 Text:[NSString stringWithFormat:@"%@", [self.userDataArray[0] imagesCount]]];
    numLabel1.textColor = BGCOLOR;
    numLabel1.textAlignment = NSTextAlignmentRight;
    [bgImageView addSubview:numLabel1];
    photoLabel = [MyControl createLabelWithFrame:CGRectMake(60+5+10+15, line.frame.origin.y+12, 30, 20) Font:14 Text:@"照片"];
    photoLabel.textColor = BGCOLOR;
    [bgImageView addSubview:photoLabel];
    
    
    //Coming Soon!!!
    shopLabel = [MyControl createLabelWithFrame:CGRectMake(60, 100, 200, 40) Font:17 Text:@"Coming Soon!"];
    shopLabel.textAlignment = NSTextAlignmentCenter;
    shopLabel.backgroundColor = [UIColor darkGrayColor];
    shopLabel.layer.masksToBounds = YES;
    shopLabel.layer.cornerRadius = 5;
    shopLabel.alpha = 0.7;
    [bgImageView addSubview:shopLabel];
    shopLabel.hidden = YES;
    
    return bgImageView;
}
#pragma mark - 
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (tv.contentOffset.y >= 356/2-55) {
        navImageView.hidden = NO;
    }else{
        navImageView.hidden = YES;
    }
}

#pragma mark -tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPhotoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[[MyPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"] autorelease];
    }
    cell.selectionStyle = NO;
    PhotoModel * model = self.dataArray[indexPath.row];
    [cell configUI:model];
    
    //本地目录，用于存放favorite下载的原图
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSLog(@"docDir:%@", docDir);
    if (!docDir) {
        NSLog(@"Documents 目录未找到");
    }else{
        NSString * filePath2 = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_small.png", model.url]];
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath2]];
        if (image) {
            cell.bigImageView.image = image;
            cell.bigImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            cell.bigImageView.center = CGPointMake(320/2, 200/2);
        }else{
            [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    //本地目录，用于存放favorite下载的原图
                    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    //                    NSLog(@"docDir:%@", docDir);
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
                        UIImage * image = [load.dataImage imageByScalingToSize:CGSizeMake(width, height)];
                        
                        if (image.size.height>200) {
                            image = [self imageFromImage:image inRect:CGRectMake(0, height/2-100, width, 200)];
                            height = 200;
                        }
                        cell.bigImageView.image = image;
                        
                        NSData * smallImageData = UIImagePNGRepresentation(image);
                        [smallImageData writeToFile:filePath2 atomically:YES];
                        cell.bigImageView.frame = CGRectMake(0, 0, width, height);
                        cell.bigImageView.center = CGPointMake(320/2, 200/2);
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
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"MyHomeTimes"] intValue]+1] forKey:@"MyHomeTimes"];
//    NSLog(@"由个人主页进入详情页，times:%@", [USER objectForKey:@"MyHomeTimes"]);
    PhotoModel * model = self.dataArray[indexPath.row];
    //跳转到详情页，并传值
    DetailViewController * vc = [[DetailViewController alloc] init];
    vc.img_id = model.img_id;
    vc.usr_id = model.usr_id;
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -取图片的一部分
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}


-(void)addButtonClick:(UIButton *)button
{
    NSLog(@"加关注");
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
#pragma mark -alertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
                    addButton.selected = !addButton.selected;
                    if (alertView.tag == 200) {
                        isFriend = 1;
                        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"关注成功 ^_^"];
                        [USER setObject:@"1" forKey:@"favoriteNeedRefresh"];
                    }else{
                        isFriend = 0;
                        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消关注成功 ^_^" ];
                        [USER setObject:@"1" forKey:@"favoriteNeedRefresh"];
                    }
                    [USER setObject:@"1" forKey:@"favoriteRefresh"];
                    [USER setObject:@"1" forKey:@"needRefresh"];
//                    [self login];
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


#pragma mark - 微博
-(void)sinaButtonClick:(UIButton *)button
{
    NSLog(@"微博");
    
    amView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, 320, self.view.frame.size.height)];
    [self.view addSubview:amView];
    
    UIButton * bgButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(bgButtonClick) Title:nil];
    //    bgButton.backgroundColor = [UIColor blackColor];
    //    bgButton.alpha = 0.1;
    [amView addSubview:bgButton];
    
    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(35/2, 120, 570/2, 157/2)];
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [amView addSubview:bgView];
    
    UIImageView * headImage = [MyControl createImageViewWithFrame:CGRectMake(35, 120+20, 40, 40) ImageName:@"13-1.png"];
    [amView addSubview:headImage];
    
    UILabel * sinaName = [MyControl createLabelWithFrame:CGRectMake(90, 150, 150, 20) Font:17 Text:@"心理治愈系"];
    sinaName.textColor = [UIColor darkGrayColor];
    [amView addSubview:sinaName];
    
    UIButton * addButton2 = [MyControl createButtonWithFrame:CGRectMake(320-35-30, 145, 30, 30) ImageName:@"36-1.png" Target:self Action:@selector(addButtonClick2:) Title:nil];
    [addButton2 setImage:[UIImage imageNamed:@"36-2.png"] forState:UIControlStateSelected];
    [amView addSubview:addButton2];
    
    [UIView animateWithDuration:0.3 animations:^{
        amView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }];
}
-(void)bgButtonClick
{
    
    [UIView animateWithDuration:0.3 animations:^{
        amView.frame = CGRectMake(self.view.frame.size.width, 0, 320, self.view.frame.size.height);
    }];
}
-(void)addButtonClick2:(UIButton *)button
{
    button.selected = !button.selected;
}


#pragma mark -登录
-(void)login
{
    [[httpDownloadBlock alloc] initWithUrlStr:LOGINAPI Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            [ControllerManager setIsSuccess:[[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]];
            [ControllerManager setSID:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"]];
            NSLog(@"isSuccess:%d,SID:%@", [ControllerManager getIsSuccess], [ControllerManager getSID]);
            NSLog(@"是否成功？：%d", [ControllerManager getIsSuccess]);
            [self getUserData];
        }
    }];
}

#pragma mark -获取用户数据
-(void)getUserData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", INFOAPI,[ControllerManager getSID]];
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
@end
