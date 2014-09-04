//
//  PicDetailViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-22.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PicDetailViewController.h"
#import "PresentDetailViewController.h"
#import "IQKeyboardManager.h"
#import "PetInfoModel.h"
#import "ToolTipsViewController.h"
@interface PicDetailViewController ()

@end

@implementation PicDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    self.sv.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.usrIdArray = [NSMutableArray arrayWithCapacity:0];
    self.nameArray = [NSMutableArray arrayWithCapacity:0];
    self.bodyArray = [NSMutableArray arrayWithCapacity:0];
    self.createTimeArray = [NSMutableArray arrayWithCapacity:0];
//    self.petInfoArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createIQ];
    [self loadData];
    [self createBg];
    [self.view bringSubviewToFront:self.sv];
    [self.view bringSubviewToFront:self.headerBgView];
    [self createFakeNavigation];
    [self createHeader];
//    [self createUI];
//    [self createComment];
}
- (void)createIQ
{
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
	//Enabling autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard.
	[[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
	//Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
	[[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}
#pragma mark -照片数据加载
-(void)loadData
{
    //Loading界面开始启动
    StartLoading;
    if (![ControllerManager getIsSuccess]) {
        [USER setObject:@"" forKey:@"usr_id"];
    }
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@&usr_id=%@dog&cat", self.img_id, [USER objectForKey:@"usr_id"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&usr_id=%@&sig=%@&SID=%@", IMAGEINFOAPI, self.img_id, [USER objectForKey:@"usr_id"], sig, [ControllerManager getSID]];
    NSLog(@"imageInfoAPI:%@", url);
    
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            self.is_follow = [[[load.dataDict objectForKey:@"data"] objectForKey:@"is_follow"] intValue];
            if (self.is_follow) {
                self.attentionBtn.selected = YES;
            }
            NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectForKey:@"image"];
            self.aid = [dict objectForKey:@"aid"];
            self.cmt = [dict objectForKey:@"cmt"];
            self.num = [dict objectForKey:@"likes"];
            self.imageURL = [dict objectForKey:@"url"];
            self.usr_id = [dict objectForKey:@"usr_id"];
            self.likers = [dict objectForKey:@"likers"];
            self.comments = [dict objectForKey:@"comments"];
            
            self.likerTxArray = [[load.dataDict objectForKey:@"data"] objectForKey:@"liker_tx"];
            
            self.createTime = [dict objectForKey:@"create_time"];
            
            //解析数据
            if (![self.likers isKindOfClass:[NSNull class]]) {
                self.likersArray = [self.likers componentsSeparatedByString:@","];
                NSLog(@"%@--", self.likersArray);
                for(NSString * str in self.likersArray){
                    if ([str isEqualToString:[USER objectForKey:@"usr_id"]]) {
                        isLike = YES;
                        break;
                    }
                }
            }
            
            //
            [self loadPetData];
            //
            [self downloadBigImage];
            //分析评论字符串
            [self analyseComments];
        }else{
            LoadingFailed;
            NSLog(@"数据加载失败");
        }
    }];
    [request release];
}
-(void)analyseComments
{
    if (!([self.comments isKindOfClass:[NSNull class]] || self.comments.length == 0)) {
        NSArray * arr1 = [self.comments componentsSeparatedByString:@";usr"];
        
        for(int i=1;i<arr1.count;i++){
            NSString * usrId = [[[[arr1[i] componentsSeparatedByString:@",name"] objectAtIndex:0] componentsSeparatedByString:@"_id:"] objectAtIndex:1];
            [self.usrIdArray addObject:usrId];
            //            [usrId release];
            
            NSString * name = [[[[arr1[i] componentsSeparatedByString:@",body"] objectAtIndex:0] componentsSeparatedByString:@"name:"] objectAtIndex:1];
            [self.nameArray addObject:name];
            //            [name release];
            
            NSString * body = [[[[arr1[i] componentsSeparatedByString:@",create_time"] objectAtIndex:0] componentsSeparatedByString:@"body:"] objectAtIndex:1];
            [self.bodyArray addObject:body];
            //            [body release];
            
            NSString * createTime = [[arr1[i] componentsSeparatedByString:@",create_time:"] objectAtIndex:1];
            [self.createTimeArray addObject:createTime];
            //            [createTime release];
        }
        NSLog(@"%@\n%@\n%@\n%@", self.usrIdArray, self.nameArray, self.bodyArray, self.createTimeArray);
//        if (++prepareCreateUINum == 2) {
//            [self createUI];
//        }
    }
    if (++prepareCreateUINum == 2) {
        [self createUI];
    }
}
-(void)loadPetData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.aid]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETINFOAPI, self.aid, sig, [ControllerManager getSID]];
    NSLog(@"PetInfoAPI:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
//            PetInfoModel * model = [[PetInfoModel alloc] init];
//            [model setValuesForKeysWithDictionary:load.dataDict];
//            [self.petInfoArray addObject:model];
            NSDictionary * dic = [load.dataDict objectForKey:@"data"];
            LoadingSuccess;
            //改变header数据
            self.name.text = [dic objectForKey:@"name"];
            if ([[dic objectForKey:@"gender"] intValue] == 1) {
                self.sex.image = [UIImage imageNamed:@"woman.png"];
            }
            self.cateName = [ControllerManager returnCateNameWithType:[dic objectForKey:@"type"]];
            NSLog(@"%@--%@", [dic objectForKey:@"type"], [ControllerManager returnCateNameWithType:[dic objectForKey:@"type"]]);
            self.headImageURL = [dic objectForKey:@"tx"];
            //
            [self downloadHeadImage];
            
            self.cate.text = [NSString stringWithFormat:@"%@ | %@岁", self.cateName, [dic objectForKey:@"age"]];
        }else{
            LoadingFailed;
            NSLog(@"请求宠物数据失败");
        }
    }];
    [request release];
}
//-(void)loadUserData
//{
//    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", self.usr_id]];
//    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERINFOAPI, self.usr_id, sig, [ControllerManager getSID]];
//    NSLog(@"UserInfoAPI:%@", url);
//    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            LoadingSuccess;
//            
//            NSLog(@"用户信息：%@", load.dataDict);
//            NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectForKey:@"user"];
//            self.petName = [dict objectForKey:@"a_name"];
//            if ([[dict objectForKey:@"type"] intValue]/100 == 1) {
//                self.cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"1"] objectForKey:[dict objectForKey:@"type"]];
//            }else if([[dict objectForKey:@"type"] intValue]/100 == 2){
//                self.cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"2"] objectForKey:[dict objectForKey:@"type"]];
//            }else if([[dict objectForKey:@"type"] intValue]/100 == 3){
//                self.cateName = [[[USER objectForKey:@"CateNameList"] objectForKey:@"3"] objectForKey:[dict objectForKey:@"type"]];
//            }else{
//                self.cateName = @"苏格兰折耳猫";
//            }
//            //
//            NSLog(@"%@", [dict objectForKey:@"tx"]);
//            self.headImageURL = [dict objectForKey:@"tx"];
//            
//            [self downloadHeadImage];
//            self.name.text = self.petName;
//            if ([[dict objectForKey:@"gender"] intValue] == 1) {
//                self.sex.image = [UIImage imageNamed:@"woman.png"];
//            }
//            self.cate.text = [NSString stringWithFormat:@"%@ | %@岁", self.cateName, [dict objectForKey:@"age"]];
//            if ([[load.dataDict objectForKey:@"isFriend"] intValue] == 1) {
//                [self.attentionBtn setImage:[UIImage imageNamed:@"didAttention.png"] forState:UIControlStateNormal];
//            }
//        }else{
//            LoadingFailed;
//            NSLog(@"用户信息数据加载失败");
//        }
//    }];
//    [request release];
//}


//下载头像及图像
-(void)downloadHeadImage
{
    
    if ([self.headImageURL isKindOfClass:[NSNull class]] || self.headImageURL.length==0) {
        [self.headBtn setBackgroundImage:[UIImage imageNamed:@"defaultPetHead.png"] forState:UIControlStateNormal];
    }else{
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.headImageURL]];
//        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
        if (image) {
            [self.headBtn setBackgroundImage:image forState:UIControlStateNormal];
        }else{
            //下载头像
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, self.headImageURL] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    [self.headBtn setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                    NSString * docDir = DOCDIR;
                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.headImageURL]];
                    [load.data writeToFile:txFilePath atomically:YES];
                }else{
                    NSLog(@"头像下载失败");
                }
            }];
            [request release];
        }
    }
}
-(void)downloadBigImage
{
    //先初始化bigImageView
    bigImageView = [[ClickImage alloc] initWithFrame:CGRectMake(0, 64+44, 320, 200)];
    
    NSString * docDir = DOCDIR;
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.imageURL]];
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    if (image) {
        //图片已经存在，直接调整大小
        bigImageView.image = image;
        [self adjustedImage:bigImageView];
        if (++prepareCreateUINum == 2) {
            [self createUI];
        }
    }else{
        //图片不存在，下载之后调整大小
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, self.imageURL] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                bigImageView.image = load.dataImage;
                [self adjustedImage:bigImageView];
                if (++prepareCreateUINum == 2) {
                    [self createUI];
                }
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"图片加载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                [alert release];
            }
        }];
        [request release];
    }
}
//调整图片大小
-(void)adjustedImage:(UIImageView *)imageView
{
    float width = imageView.image.size.width;
    float height = imageView.image.size.height;
    NSLog(@"%f--%f", width, height);
    if (width>320) {
        float w = 320/width;
        width *= w;
        height *= w;
    }
    if (height>568) {
        float h = 568/height;
        width *= h;
        height *= h;
    }
    if (width<320) {
        float s = 320/width;
        width *= s;
        height *= s;
    }
//    bigImageViewWidth = width;
//    bigImageViewHeight = height;
    imageView.frame = CGRectMake(0, 64+44, width, height);
//    if(height<=self.view.frame.size.height){
//        imageView.frame = CGRectMake(self.view.center.x-width/2, self.view.center.y-height/2, width, height);
//        imageView.center = self.view.center;
//    }else{
//        imageView.frame = CGRectMake(0, 0, width, height);
//        imageView.center = CGPointMake(self.view.frame.size.width/2, height/2);
//    }
}

-(void)createBg
{
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:self.bgImageView];

    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];

    UIImage * image = [UIImage imageWithData:data];
    self.bgImageView.image = image;

    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:tempView];
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
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"照片详情"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}
-(void)createHeader
{
    [self.headBtn setBackgroundImage:[UIImage imageNamed:@"cat2.jpg"] forState:UIControlStateNormal];
    self.headBtn.layer.cornerRadius = self.headBtn.frame.size.height/2;
    self.headBtn.layer.masksToBounds = YES;
    
    [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"didAttention.png"] forState:UIControlStateSelected];
}
-(void)createUI
{
    self.sv.contentSize = CGSizeMake(320, 800);
    
    //大图
//    UIImage * image = [UIImage imageNamed:@"cat2.jpg"];
//    float height = 320/image.size.width*image.size.height;
//    CGRectMake(0, 64+44, 320, height)
//    bigImageView = [[ClickImage alloc] initWithFrame:CGRectMake(0, 64+44, bigImageViewWidth, bigImageViewHeight)];
//    bigImageView.image = image;
    bigImageView.canClick = YES;
    [self.sv addSubview:bigImageView];
    [bigImageView release];
    
    //点赞
    UIImageView * zanBgView = [MyControl createImageViewWithFrame:CGRectMake(10, bigImageView.frame.size.height-10-20, 50, 20) ImageName:@"zanBg.png"];
    [bigImageView addSubview:zanBgView];
    
    zanLabel = [MyControl createLabelWithFrame:CGRectMake(20-3, 0, 30, 20) Font:12 Text:self.num];
    zanLabel.textAlignment = NSTextAlignmentRight;
    [zanBgView addSubview:zanLabel];
    
    fish = [MyControl createImageViewWithFrame:CGRectMake(0, 4, 30, 12) ImageName:@"fish.png"];
    [zanBgView addSubview:fish];
    
    UIButton * zanBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 50, 20) ImageName:@"" Target:self Action:@selector(zanBtnClick:) Title:nil];
    [zanBgView addSubview:zanBtn];
    
    if (isLike) {
        fish.image = [UIImage imageNamed:@"fish1.png"];
        zanBtn.selected = YES;
    }
    
    //礼物盒、工具条
    UIView * giftBgView = [MyControl createViewWithFrame:CGRectMake(0, bigImageView.frame.origin.y+bigImageView.frame.size.height, 320, 35)];
    giftBgView.backgroundColor = [UIColor whiteColor];
    [self.sv addSubview:giftBgView];
    
    UIButton * sendGift = [MyControl createButtonWithFrame:CGRectMake(20, 11/2, 45/2, 48/2) ImageName:@"detail_gift.png" Target:self Action:@selector(sendGiftClick) Title:nil];
    sendGift.showsTouchWhenHighlighted = YES;
    [giftBgView addSubview:sendGift];
    
    UIView * vLine = [MyControl createViewWithFrame:CGRectMake(60, 2, 1, 31)];
    vLine.backgroundColor = [UIColor lightGrayColor];
    [giftBgView addSubview:vLine];
    
    UILabel * giftNum = [MyControl createLabelWithFrame:CGRectMake(65, 7.5, 120, 20) Font:15 Text:nil];
    if (self.gifts) {
        giftNum.text = [NSString stringWithFormat:@"已经收到%@件礼物", self.gifts];
    }else{
        giftNum.text = @"已经收到0件礼物";
    }
    giftNum.textColor = [UIColor blackColor];
    [giftBgView addSubview:giftNum];
    
    //评论和分享
    UIButton * comment = [MyControl createButtonWithFrame:CGRectMake(435/2, 9, 35*0.75, 18) ImageName:@"detail_comment.png" Target:self Action:@selector(commentClick) Title:nil];
    [giftBgView addSubview:comment];
    
    commentNum = [MyControl createLabelWithFrame:CGRectMake(comment.frame.origin.x+comment.frame.size.width, 7.5, 30, 20) Font:10 Text:[NSString stringWithFormat:@"%d", self.nameArray.count]];
    commentNum.textAlignment = NSTextAlignmentCenter;
    commentNum.textColor = [UIColor lightGrayColor];
    [giftBgView addSubview:commentNum];
    
    UIButton * share = [MyControl createButtonWithFrame:CGRectMake(546/2, 9, 32*(18/30.0), 18) ImageName:@"detail_share.png" Target:self Action:@selector(shareClick) Title:nil];
    [giftBgView addSubview:share];
    
    shareNum = [MyControl createLabelWithFrame:CGRectMake(share.frame.origin.x+share.frame.size.width, 7.5, 20, 20) Font:10 Text:nil];
    if (self.shares) {
        shareNum.text = [NSString stringWithFormat:@"%@", self.shares];
    }else{
        shareNum.text = @"0";
    }
    shareNum.textAlignment = NSTextAlignmentCenter;
    shareNum.textColor = [UIColor lightGrayColor];
    [giftBgView addSubview:shareNum];
    
    //话题
    UILabel * topic = [MyControl createLabelWithFrame:CGRectMake(15, giftBgView.frame.origin.y+giftBgView.frame.size.height+10, 200, 20) Font:14 Text:@"#一起来看超级月亮#"];
    topic.textColor = BGCOLOR;
    [self.sv addSubview:topic];
    
    NSString * string = @"她渐渐的让我明白了感情的戏，戏总归是戏，再美也是暂时的假象，无论投入多深多真，结局总是如此。";
    CGSize topicSize = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290, 100) lineBreakMode:1];
    
    UILabel * topicDetail = [MyControl createLabelWithFrame:CGRectMake(15, topic.frame.origin.y+topic.frame.size.height+10, 290, topicSize.height) Font:14 Text:string];
    topicDetail.textColor = [UIColor darkGrayColor];
    [self.sv addSubview:topicDetail];
    
    UILabel * topicUser = [MyControl createLabelWithFrame:CGRectMake(15, topicDetail.frame.origin.y+topicDetail.frame.size.height+10, 200, 20) Font:14 Text:@"@一起来看流星雨 等小伙伴"];
    topicUser.textColor = BGCOLOR;
    [self.sv addSubview:topicUser];
    
    NSDate * date = [NSDate date];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    UILabel * topicTime = [MyControl createLabelWithFrame:CGRectMake(320-10-150, topicUser.frame.origin.y+3, 150, 15) Font:12 Text:[format stringFromDate:date]];
    topicTime.textAlignment = NSTextAlignmentRight;
    topicTime.textColor = [UIColor lightGrayColor];
    [self.sv addSubview:topicTime];
    [format release];
    
    //用户头像
    usersBgView = [MyControl createViewWithFrame:CGRectMake(0, topicUser.frame.origin.y+topicUser.frame.size.height+10, 320, 50)];
    usersBgView.backgroundColor = [UIColor whiteColor];
    [self.sv addSubview:usersBgView];
    
    for (int i=0; i<7; i++) {
        UIImageView * header = [MyControl createImageViewWithFrame:CGRectMake(15+i*(76/2), 10, 30, 30) ImageName:@""];
        header.layer.cornerRadius = 15;
        header.layer.masksToBounds = YES;
        if (i%2 == 0) {
            header.image = [UIImage imageNamed:@"cat1.jpg"];
        }else{
            header.image = [UIImage imageNamed:@"cat2.jpg"];
        }
        [usersBgView addSubview:header];
        
        UIImageView * giftSymbol = [MyControl createImageViewWithFrame:CGRectMake(header.frame.origin.x+18, header.frame.origin.y+20, 14, 14) ImageName:@"detail_symbol_fish.png"];
        [usersBgView addSubview:giftSymbol];
    }
    UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(320-20-10, 15, 20, 20) ImageName:@"arrow_right.png"];
    [usersBgView addSubview:arrow];
    
    UIButton * usersBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, 50) ImageName:nil Target:self Action:@selector(usersBtnClick) Title:nil];
    [usersBgView addSubview:usersBtn];
    
    [self createCmt];
    
    
    //创建评论框
    [self createComment];
    
    self.menuBgView.frame = CGRectMake(50, self.view.frame.size.height-40, 220, 80);
    [self.view bringSubviewToFront:self.menuBgBtn];
    [self.view bringSubviewToFront:self.menuBgView];
}
-(void)createCmt
{
    //创建评论
    commentsBgView = [MyControl createViewWithFrame:CGRectMake(0, usersBgView.frame.origin.y+usersBgView.frame.size.height, 320, 100)];
    [self.sv addSubview:commentsBgView];
    
    int commentsBgViewHeight = 0;
    for(int i=0;i<self.usrIdArray.count;i++){
        UILabel * cmtUserName = [MyControl createLabelWithFrame:CGRectMake(15, 10+commentsBgViewHeight, 150, 20) Font:15 Text:self.nameArray[i]];
        cmtUserName.textColor = BGCOLOR;
        [commentsBgView addSubview:cmtUserName];
        
        UILabel * timeStamp = [MyControl createLabelWithFrame:CGRectMake(320-10-100, cmtUserName.frame.origin.y+3, 100, 15) Font:12 Text:[MyControl timeFromTimeStamp:self.createTimeArray[i]]];
        timeStamp.textAlignment = NSTextAlignmentRight;
        timeStamp.textColor = [UIColor lightGrayColor];
        [commentsBgView addSubview:timeStamp];
        
        CGSize size = [self.bodyArray[i] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(290, 100) lineBreakMode:1];
        
        UILabel * cmtLabel = [MyControl createLabelWithFrame:CGRectMake(15, cmtUserName.frame.origin.y+cmtUserName.frame.size.height+10, 290, size.height) Font:15 Text:self.bodyArray[i]];
        cmtLabel.textColor = [UIColor blackColor];
        [commentsBgView addSubview:cmtLabel];
        
        UIView * line = [MyControl createViewWithFrame:CGRectMake(0, cmtLabel.frame.origin.y+cmtLabel.frame.size.height+size.height, 320, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [commentsBgView addSubview:line];
        
        commentsBgViewHeight = line.frame.origin.y+1;
    }
    commentsBgView.frame = CGRectMake(0, commentsBgView.frame.origin.y, 320, commentsBgViewHeight);
    //54为menu按钮的露出高度
    self.sv.contentSize = CGSizeMake(320, usersBgView.frame.origin.y+usersBgView.frame.size.height+commentsBgViewHeight+54);
//    NSLog(@"%f--%f--%d", usersBgView.frame.origin.y, usersBgView.frame.size.height, commentsBgViewHeight);
}
-(void)createComment
{
    bgButton = [MyControl createButtonWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64) ImageName:nil Target:self Action:@selector(bgButtonClick) Title:nil];
    bgButton.backgroundColor = [UIColor blackColor];
    bgButton.alpha = 0.3;
    bgButton.hidden = YES;
    [self.view addSubview:bgButton];
    
    commentBgView = [MyControl createViewWithFrame:CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40)];
    commentBgView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:commentBgView];
    
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 250, 30)];
    commentTextView.textColor = [UIColor lightGrayColor];
    commentTextView.text = @"写个评论呗";
    commentTextView.layer.cornerRadius = 5;
    commentTextView.layer.masksToBounds = YES;
    commentTextView.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1].CGColor;
    commentTextView.layer.borderWidth = 1.5;
    commentTextView.delegate = self;
    commentTextView.font = [UIFont systemFontOfSize:15];
    [commentBgView addSubview:commentTextView];
    [commentTextView release];
    
    UIButton * sendButton = [MyControl createButtonWithFrame:CGRectMake(260, 10, 55, 20) ImageName:@"" Target:self Action:@selector(sendButtonClick) Title:@"发送"];
    [sendButton setTitleColor:BGCOLOR forState:UIControlStateNormal];
    [commentBgView addSubview:sendButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}
#pragma mark -键盘监听
-(void)keyboardWasChange:(NSNotification *)notification
{
    float y = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    if (y == self.view.frame.size.height) {
        return;
    }
    float height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSString * str = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([str isEqualToString:@"zh-Hans"]) {
        
        [UIView animateWithDuration:0.25 animations:^{
            commentBgView.frame = CGRectMake(0, self.view.frame.size.height-height-commentBgView.frame.size.height, 320, commentBgView.frame.size.height);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            commentBgView.frame = CGRectMake(0, self.view.frame.size.height-height-commentBgView.frame.size.height, 320, commentBgView.frame.size.height);
        }];
    }
}
#pragma mark - 
-(void)sendGiftClick
{
    NSLog(@"赠送礼物");
    if (![ControllerManager getIsSuccess]) {
        //提示注册
        ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc createLoginAlertView];
        return;
    }
    PresentDetailViewController * vc = [[PresentDetailViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)commentClick
{
    NSLog(@"comment");
    if (![ControllerManager getIsSuccess]) {
        //提示注册
        ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc createLoginAlertView];
        return;
    }
//    buttonRight.userInteractionEnabled = NO;
    
//    NSLog(@"Comment");
//    if (!isCommentCreated) {
//        [self createComment];
//        isCommentCreated = 1;
//    }
    bgButton.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        commentBgView.frame = CGRectMake(0, self.view.frame.size.height-216-40, 320, 40);
    }];
    [commentTextView becomeFirstResponder];
}
-(void)shareClick
{
    NSLog(@"share");
    if (![ControllerManager getIsSuccess]) {
        //提示注册
        ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc createLoginAlertView];
        return;
    }else{
        if (!isMoreCreated) {
            //create more
            [self createMore];
        }
        //show more
        menuBgBtn.hidden = NO;
        CGRect rect = moreView.frame;
        rect.origin.y -= rect.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            moreView.frame = rect;
            menuBgBtn.alpha = 0.5;
        }];
    }
}
#pragma mark - 创建更多视图
-(void)createMore
{
    menuBgBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:nil];
    menuBgBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:menuBgBtn];
    menuBgBtn.alpha = 0;
    menuBgBtn.hidden = YES;
    
    // 318*234
    moreView = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 120)];
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
}
-(void)shareClick:(UIButton *)button
{
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//    [MMProgressHUD showWithStatus:@"正在分享..."];
    if (button.tag == 200) {
        NSLog(@"微信");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.cmt image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
//                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
                [self cancelBtnClick];
            }else{
//                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
        }];
    }else if(button.tag == 201){
        NSLog(@"朋友圈");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.cmt image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
//                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
                [self cancelBtnClick];
            }else{
//                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
        }];
    }else{
        NSLog(@"微博");
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"ha哈哈哈" image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
//                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
                [self cancelBtnClick];
            }else{
                NSLog(@"失败原因：%@", response);
//                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
        }];
    }
}
-(void)cancelBtnClick
{
    NSLog(@"cancel");
    CGRect rect = moreView.frame;
    rect.origin.y += rect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        moreView.frame = rect;
        menuBgBtn.alpha = 0;
    } completion:^(BOOL finished) {
        menuBgBtn.hidden = YES;
    }];
}
-(void)usersBtnClick
{
    NSLog(@"跳转到用户详情页");
}
-(void)bgButtonClick
{
    [commentTextView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        commentBgView.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40);
    } completion:^(BOOL finished) {
        bgButton.hidden = YES;
        commentTextView.text = @"写个评论呗";
        commentTextView.textColor = [UIColor lightGrayColor];
    }];
}

-(void)zanBtnClick:(UIButton *)btn
{
    if (![ControllerManager getIsSuccess]) {
        //提示注册
        ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc createLoginAlertView];
        return;
    }
    //
    if (!btn.selected) {
        /*================================*/
        NSString * code = [NSString stringWithFormat:@"img_id=%@dog&cat", self.img_id];
        NSString * sig = [MyMD5 md5:code];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", LIKEAPI, self.img_id, sig, [ControllerManager getSID]];
        NSLog(@"likeURL:%@", url);
        StartLoading;
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
//                NSLog(@"%@", load.dataDict);
                if (![[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                    [MMProgressHUD dismissWithError:@"点赞失败" afterDelay:1];
                }else{
                    btn.selected = YES;
                    fish.image = [UIImage imageNamed:@"fish1.png"];
                    zanLabel.text = [NSString stringWithFormat:@"%d", [zanLabel.text intValue]+1];
                    [UIView animateWithDuration:0.5 animations:^{
                        fish.frame = CGRectMake(0-15, 4-12, 30*2, 12*2);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 animations:^{
                            fish.frame = CGRectMake(0, 4, 30, 12);
                        }];
                    }];
                    [MMProgressHUD dismissWithSuccess:@"点赞成功" title:nil afterDelay:0.5];
                }
            }else{
                [MMProgressHUD dismissWithError:@"点赞请求失败" afterDelay:1];
                NSLog(@"数据请求失败");
            }
        }];
        [request release];
    }else{
        StartLoading;
        [MMProgressHUD dismissWithError:@"您已经点过赞了" afterDelay:1];
    }
    
//    btn.selected = !btn.selected;
//    if (btn.selected) {
//        fish.image = [UIImage imageNamed:@"fish1.png"];
//        zanLabel.text = [NSString stringWithFormat:@"%d", [zanLabel.text intValue]+1];
//        [UIView animateWithDuration:0.5 animations:^{
//            fish.frame = CGRectMake(0-15, 4-12, 30*2, 12*2);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.5 animations:^{
//                fish.frame = CGRectMake(0, 4, 30, 12);
//            }];
//        }];
//    }else{
//        fish.image = [UIImage imageNamed:@"fish.png"];
//        zanLabel.text = [NSString stringWithFormat:@"%d", [zanLabel.text intValue]-1];
//    }
}
- (IBAction)headBtnClick:(id)sender {
    NSLog(@"进入王国");
    if (![ControllerManager getIsSuccess]) {
        //提示注册
        ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc createLoginAlertView];
    }
}
- (IBAction)attentionBtnClick:(id)sender {
    if (![ControllerManager getIsSuccess]) {
        //提示注册
        ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc createLoginAlertView];
        return;
    }
    if (!self.attentionBtn.selected) {
        NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", self.aid];
        NSString * sig = [MyMD5 md5:code];
        NSString * url = nil;
        url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", FOLLOWAPI, self.aid, sig, [ControllerManager getSID]];
        NSLog(@"url:%@", url);
        StartLoading;
        [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"%@", load.dataDict);
                [MMProgressHUD dismissWithSuccess:@"关注成功" title:nil afterDelay:0.5];
                self.attentionBtn.selected = YES;
            }else{
                [MMProgressHUD dismissWithError:@"关注失败" afterDelay:1];
            }
        }];
//        self.attentionBtn.selected = YES;
    }else{
        StartLoading;
        [MMProgressHUD dismissWithError:@"您已关注该宠" afterDelay:1];
    }
}

-(void)backBtnClick
{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)sendButtonClick
{
    NSLog(@"发送");
    if ([commentTextView.text isEqualToString:@"写个评论呗"] || commentTextView.text.length == 0) {
        //        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"不写评论怎么发 = =。"];
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
        [MMProgressHUD showWithStatus:@"评论中..."];
        [MMProgressHUD dismissWithError:@"不写评论怎么发 = =。" afterDelay:1.5];
        return;
    }
    
    //post数据  参数img_id 和 body
    NSString * url = [NSString stringWithFormat:@"%@%@", COMMENTAPI, [ControllerManager getSID]];
    NSLog(@"postUrl:%@", url);
    ASIFormDataRequest * _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 20;
    
    //    if (![commentTextView.text isEqualToString:@"写个评论呗"]) {
//    NSLog(@"%@", commentTextView.text);
    [_request setPostValue:commentTextView.text forKey:@"body"];
    //    }else{
    //        [_request setPostValue:@"" forKey:@"body"];
    //    }
    [_request setPostValue:self.img_id forKey:@"img_id"];
    _request.delegate = self;
    [_request startAsynchronous];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:@"评论中..."];
}
#pragma mark - ASI代理
-(void)requestFinished:(ASIHTTPRequest *)request
{
//    buttonRight.userInteractionEnabled = YES;
    
    NSLog(@"success");
    [commentTextView resignFirstResponder];
    //添加评论
    [self.usrIdArray addObject:[USER objectForKey:@"usr_id"]];
    [self.nameArray addObject:[USER objectForKey:@"name"]];
    [self.bodyArray addObject:commentTextView.text];
    [self.createTimeArray addObject:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]]];
    
    [UIView animateWithDuration:0.3 animations:^{
        commentBgView.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40);
        //评论清空
        commentTextView.text = @"写个评论呗";
        commentTextView.textColor = [UIColor lightGrayColor];
    }];
    bgButton.hidden = YES;
    [MMProgressHUD dismissWithSuccess:@"评论成功" title:nil afterDelay:1];
    //
    commentNum.text = [NSString stringWithFormat:@"%d", self.nameArray.count];
    
    [commentsBgView removeFromSuperview];
//    if (!([self.likerTxArray isKindOfClass:[NSNull class]] || self.likerTxArray.count == 0)) {
//        [txsView removeFromSuperview];
//    }
    [self createCmt];
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
    [MMProgressHUD dismissWithError:@"评论失败" afterDelay:1];
}
#pragma mark - textView代理
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NSLog(@"%d--%@", commentTextView.text.length, text);
    if ([commentTextView.text isEqualToString:@"写个评论呗"]) {
        commentTextView.text = @"";
    }
//    else if(commentTextView.text.length == 1 && text == nil){
//        
//        return YES;
//    }
    commentTextView.textColor = [UIColor blackColor];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_headerBgView release];
    [_sv release];
    [_headBtn release];
    [_sex release];
    [_name release];
    [_cate release];
    [_attentionBtn release];
    [super dealloc];
}
@end
