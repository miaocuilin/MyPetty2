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
#import "PetInfoViewController.h"
#import "MassWatchViewController.h"
#import "QuickGiftViewController.h"
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
-(void)viewDidAppear:(BOOL)animated
{
    isInThisController = YES;
//    NSLog(@"%f--%f--%f", commentTextView.frame.origin.x, commentBgView.frame.origin.x, commentBgView.frame.origin.y);
}
-(void)viewDidDisappear:(BOOL)animated
{
    isInThisController = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
//    NSLog(@"%@--%d", tempArray, tempArray.count);
//    for (int i=0; i<100; i++) {
//        [tempArray addObject:@""];
//    }
//    [tempArray insertObject:@"reply_name" atIndex:8];
//    
//    NSLog(@"%@--%d", tempArray, tempArray.count);
    
    
    // Do any additional setup after loading the view from its nib.
    self.usrIdArray = [NSMutableArray arrayWithCapacity:0];
    self.nameArray = [NSMutableArray arrayWithCapacity:0];
    self.bodyArray = [NSMutableArray arrayWithCapacity:0];
    self.createTimeArray = [NSMutableArray arrayWithCapacity:0];
//    self.petInfoArray = [NSMutableArray arrayWithCapacity:0];
    self.senderTxArray = [NSMutableArray arrayWithCapacity:0];
    self.txTotalArray = [NSMutableArray arrayWithCapacity:0];
    self.txTypeTotalArray = [NSMutableArray arrayWithCapacity:0];
    
//    [self createIQ];
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
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
}
#pragma mark - 关系API


- (void)loadAttentionAPI
{
    StartLoading;
    NSLog(@"aid:%@",self.aid);
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",self.aid]];
    NSString *attentionString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",RELATIONAPI,self.aid,sig,[ControllerManager getSID]];
    NSLog(@"%@",attentionString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:attentionString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            [load.dataDict objectForKey:@"data"];
//            isFollow = [[[load.dataDict objectForKey:@"data"] objectForKey:@"is_follow"] intValue];
            NSLog(@"%d",[[[load.dataDict objectForKey:@"data"] objectForKey:@"is_fan"] intValue]);
            if (![[[load.dataDict objectForKey:@"data"] objectForKey:@"is_fan"] intValue]) {
                super.label1.text =@"捣捣乱";
                [self.btn1 setBackgroundImage:[UIImage imageNamed:@"rock2.png"] forState:UIControlStateNormal];
            }
            LoadingSuccess;
        }
    }];
    [request release];
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
            NSLog(@"imageInfo:%@", load.dataDict);
            self.is_follow = [[[load.dataDict objectForKey:@"data"] objectForKey:@"is_follow"] intValue];
            if (self.is_follow) {
                self.attentionBtn.selected = YES;
            }
            NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectForKey:@"image"];
            self.aid = [dict objectForKey:@"aid"];
            //四个动作是摇一摇还是捣捣乱
            if ([ControllerManager getIsSuccess]) {
                [self loadAttentionAPI];
            }
            self.shares = [dict objectForKey:@"shares"];
//            NSLog(@"%@", [dict objectForKey:@"shares"]);
            self.cmt = [dict objectForKey:@"cmt"];
            self.num = [dict objectForKey:@"likes"];
            self.imageURL = [dict objectForKey:@"url"];
            self.usr_id = [dict objectForKey:@"usr_id"];
            self.likers = [dict objectForKey:@"likers"];
            self.comments = [dict objectForKey:@"comments"];
            self.topic_name = [dict objectForKey:@"topic_name"];
            self.relates = [dict objectForKey:@"relates"];
            self.likerTxArray = [[load.dataDict objectForKey:@"data"] objectForKey:@"liker_tx"];
            self.senderTxArray = [[load.dataDict objectForKey:@"data"] objectForKey:@"sender_tx"];
            
            self.createTime = [dict objectForKey:@"create_time"];
            
            //解析数据
            if (![self.likers isKindOfClass:[NSNull class]]) {
                self.likersArray = [self.likers componentsSeparatedByString:@","];
                NSLog(@"self.lisersArray:%@--", self.likersArray);
                for(NSString * str in self.likersArray){
                    if (![str isEqualToString:@""] && str != nil && [str isEqualToString:[USER objectForKey:@"usr_id"]]) {
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
//            NSLog(@"%@", arr1[i]);
            NSString * usrId = [[[[arr1[i] componentsSeparatedByString:@",name"] objectAtIndex:0] componentsSeparatedByString:@"_id:"] objectAtIndex:1];
            [self.usrIdArray addObject:usrId];
            //            [usrId release];
            
            //
            if ([arr1[i] rangeOfString:@"reply_id"].location == NSNotFound) {
                NSString * name = [[[[arr1[i] componentsSeparatedByString:@",body"] objectAtIndex:0] componentsSeparatedByString:@"name:"] objectAtIndex:1];
                [self.nameArray addObject:name];
                //            [name release];
            }else{
                NSString * name = [[[[arr1[i] componentsSeparatedByString:@",reply_id"] objectAtIndex:0] componentsSeparatedByString:@",name:"] objectAtIndex:1];
                NSString * reply_name = [[[[arr1[i] componentsSeparatedByString:@",body"] objectAtIndex:0] componentsSeparatedByString:@",reply_name:"] objectAtIndex:1];
                NSString * str = [NSString stringWithFormat:@"%@&%@", name, reply_name];
                [self.nameArray addObject:str];
            }
            
            
            NSString * body = [[[[arr1[i] componentsSeparatedByString:@",create_time"] objectAtIndex:0] componentsSeparatedByString:@"body:"] objectAtIndex:1];
            [self.bodyArray addObject:body];
            //            [body release];
            
            NSString * createTime = [[arr1[i] componentsSeparatedByString:@",create_time:"] objectAtIndex:1];
            [self.createTimeArray addObject:createTime];
            //            [createTime release];
        }
//        NSLog(@"评论分析结果:%@\n%@\n%@\n%@", self.usrIdArray, self.nameArray, self.bodyArray, self.createTimeArray);
//        if (++prepareCreateUINum == 2) {
//            [self createUI];
//        }
    }
//    if (++prepareCreateUINum == 2) {
//        [self createUI];
//    }
}
-(void)loadPetData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.aid]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETINFOAPI, self.aid, sig, [ControllerManager getSID]];
    NSLog(@"PetInfoAPI:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"照片详情页宠物信息：%@", load.dataDict);
//            PetInfoModel * model = [[PetInfoModel alloc] init];
//            [model setValuesForKeysWithDictionary:load.dataDict];
//            [self.petInfoArray addObject:model];
            NSDictionary * dic = [load.dataDict objectForKey:@"data"];
            //父类的宠物信息字典
//            masterID = [dic objectForKey:@"master_id"];
            super.shakeInfoDict = dic;
            
            
            //改变header数据
            self.name.text = [dic objectForKey:@"name"];
            if ([[dic objectForKey:@"gender"] intValue] == 2) {
                self.sex.image = [UIImage imageNamed:@"woman.png"];
            }
            if ([[dic objectForKey:@"type"] intValue]/100 == 1) {
                isMi = YES;
            }
            self.cateName = [ControllerManager returnCateNameWithType:[dic objectForKey:@"type"]];
            NSLog(@"%@--%@", [dic objectForKey:@"type"], [ControllerManager returnCateNameWithType:[dic objectForKey:@"type"]]);
            self.headImageURL = [dic objectForKey:@"tx"];
            //
            [self downloadHeadImage];
            
            self.cate.text = [NSString stringWithFormat:@"%@ | %@岁", self.cateName, [dic objectForKey:@"age"]];
            
            /********************/
            if (++prepareCreateUINum == 2) {
                LoadingSuccess;
                [self createUI];
            }
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
            LoadingSuccess;
            [self createUI];
        }
    }else{
        //图片不存在，下载之后调整大小
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, self.imageURL] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                bigImageView.image = load.dataImage;
                [self adjustedImage:bigImageView];
                if (++prepareCreateUINum == 2) {
                    LoadingSuccess;
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
    NSLog(@"图片大小:%f--%f", width, height);
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
    [self.headBtn setBackgroundImage:[UIImage imageNamed:@"defaultPetHead.jpg"] forState:UIControlStateNormal];
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
    
    fish = [MyControl createImageViewWithFrame:CGRectMake(0, 4, 30, 12) ImageName:@""];
    if (isMi) {
        //48*23
        fish.frame = CGRectMake(3, 3, 30, 14);
        fish.image = [UIImage imageNamed:@"fish.png"];
    }else{
        //41*34
        fish.frame = CGRectMake(8, 3, 20, 16);
        fish.image = [UIImage imageNamed:@"bone.png"];
    }
    [zanBgView addSubview:fish];
    
    UIButton * zanBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 50, 20) ImageName:@"" Target:self Action:@selector(zanBtnClick:) Title:nil];
    [zanBgView addSubview:zanBtn];
    
    if (isLike) {
        if (isMi) {
            fish.image = [UIImage imageNamed:@"fish1.png"];
        }else{
            fish.image = [UIImage imageNamed:@"bone1.png"];
        }
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
    UIImageView * commentImageView = [MyControl createImageViewWithFrame:CGRectMake(435/2, 9, 35*0.75, 18) ImageName:@"detail_comment.png"];
    [giftBgView addSubview:commentImageView];
    
    commentNum = [MyControl createLabelWithFrame:CGRectMake(commentImageView.frame.origin.x+commentImageView.frame.size.width, 7.5, 30, 20) Font:10 Text:[NSString stringWithFormat:@"%d", self.nameArray.count]];
    commentNum.textAlignment = NSTextAlignmentCenter;
    commentNum.textColor = [UIColor lightGrayColor];
    [giftBgView addSubview:commentNum];
    
    UIButton * comment = [MyControl createButtonWithFrame:CGRectMake(435/2, 0, 45, 35) ImageName:@"" Target:self Action:@selector(commentClick) Title:nil];
//    comment.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [giftBgView addSubview:comment];
    /*******************************/
    UIImageView * shareImageView = [MyControl createImageViewWithFrame:CGRectMake(546/2, 9, 32*(18/30.0), 18) ImageName:@"detail_share.png"];
    [giftBgView addSubview:shareImageView];
    
    shareNum = [MyControl createLabelWithFrame:CGRectMake(shareImageView.frame.origin.x+shareImageView.frame.size.width, 7.5, 20, 20) Font:10 Text:nil];
    if (self.shares) {
        shareNum.text = [NSString stringWithFormat:@"%@", self.shares];
    }else{
        shareNum.text = @"0";
    }
    shareNum.textAlignment = NSTextAlignmentCenter;
    shareNum.textColor = [UIColor lightGrayColor];
    [giftBgView addSubview:shareNum];
    
    UIButton * share = [MyControl createButtonWithFrame:CGRectMake(546/2, 0, 45, 35) ImageName:@"" Target:self Action:@selector(shareClick) Title:nil];
//    share.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [giftBgView addSubview:share];
    
    //话题
    UILabel * topic = [MyControl createLabelWithFrame:CGRectMake(15, giftBgView.frame.origin.y+giftBgView.frame.size.height+10, 200, 20) Font:14 Text:@"#一起来看超级月亮#"];
    if (self.topic_name.length != 0) {
        topic.text = [NSString stringWithFormat:@"#%@#", self.topic_name];
    }
    topic.textColor = BGCOLOR;
    [self.sv addSubview:topic];
    
//    NSString * string = @"她渐渐的让我明白了感情的戏，戏总归是戏，再美也是暂时的假象，无论投入多深多真，结局总是如此。";
    NSString * string = self.cmt;
    CGSize topicSize = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290, 100) lineBreakMode:1];
    
    UILabel * topicDetail = [MyControl createLabelWithFrame:CGRectMake(15, topic.frame.origin.y+topic.frame.size.height+10, 290, topicSize.height) Font:14 Text:string];
    topicDetail.textColor = [UIColor darkGrayColor];
    [self.sv addSubview:topicDetail];

    topicUser = [MyControl createLabelWithFrame:CGRectMake(15, topicDetail.frame.origin.y+topicDetail.frame.size.height+10, 200, 20) Font:14 Text:@"没有@小伙伴"];
    topicUser.textColor = BGCOLOR;
    if (self.relates.length != 0) {
        topicUser.text = self.relates;
    }
    [self.sv addSubview:topicUser];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[self.createTime intValue]];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    UILabel * topicTime = [MyControl createLabelWithFrame:CGRectMake(320-10-150, topicUser.frame.origin.y+3, 150, 15) Font:12 Text:[format stringFromDate:date]];
    topicTime.textAlignment = NSTextAlignmentRight;
    topicTime.textColor = [UIColor lightGrayColor];
    [self.sv addSubview:topicTime];
    [format release];
    
    [self createUsersTx];
    
    [self createCmt];
    
    //创建评论框
    [self createComment];
    
    self.menuBgView.frame = CGRectMake(50, self.view.frame.size.height-40, 220, 80);
    [self.view bringSubviewToFront:self.menuBgBtn];
    [self.view bringSubviewToFront:self.menuBgView];
}
-(void)createUsersTx
{
    //用户头像
    usersBgView = [MyControl createViewWithFrame:CGRectMake(0, topicUser.frame.origin.y+topicUser.frame.size.height+10, 320, 50)];
    usersBgView.backgroundColor = [UIColor whiteColor];
    [self.sv addSubview:usersBgView];
    
    /*
     设置一个总的数组用来存储头像，送礼在前，点赞在后，详情页只能容下8个头像。
     再开一个数组存储这些人的行为是送礼还是点赞，与前面数组对应。
     当我新点赞或送礼之后，我的头像出现在下方最前端。也就是添加在数组的最前端--
     但是退出再近排布顺序还是送礼在前，点赞在后。所以我点赞之后退出再进第一个可能不是我。
     */
    if (![self.senderTxArray isKindOfClass:[NSNull class]]) {
        [self.txTotalArray addObjectsFromArray:self.senderTxArray];
        for (int i=0; i<self.senderTxArray.count; i++) {
            [self.txTypeTotalArray addObject:@"sender"];
        }
    }
    if (![self.likerTxArray isKindOfClass:[NSNull class]]) {
        [self.txTotalArray addObjectsFromArray:self.likerTxArray];
        for (int i=0; i<self.likerTxArray.count; i++) {
            [self.txTypeTotalArray addObject:@"liker"];
        }
    }
    
    //txCount最大限制为8
    if (self.txTotalArray.count > 8) {
        txCount = 8;
    }else{
        txCount = self.txTotalArray.count;
    }
    for (int i=0; i<txCount; i++) {
        UIImageView * header = [MyControl createImageViewWithFrame:CGRectMake(15+i*(76/2), 10, 30, 30) ImageName:@""];
        header.layer.cornerRadius = 15;
        header.layer.masksToBounds = YES;
        [usersBgView addSubview:header];
        NSLog(@"self.txTotalArray:%@", self.txTotalArray);
        if ([self.txTotalArray[i] isEqualToString:@""]) {
            header.image = [UIImage imageNamed:@"defaultUserHead.png"];
        }else{
            //下载头像图片
            NSString * docDir = DOCDIR;
            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.txTotalArray[i]]];
            UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
            if (image) {
                header.image = image;
            }else{
                //下载头像
                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", USERTXURL, self.txTotalArray[i]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
                        header.image = load.dataImage;
                        NSString * docDir = DOCDIR;
                        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.txTotalArray[i]]];
                        [load.data writeToFile:txFilePath atomically:YES];
                    }else{
                        NSLog(@"头像下载失败");
                    }
                }];
                [request release];
            }
        }
        
        UIImageView * giftSymbol = [MyControl createImageViewWithFrame:CGRectMake(header.frame.origin.x+18, header.frame.origin.y+20, 14, 14) ImageName:@"detail_symbol_fish.png"];
        if ([self.txTypeTotalArray[i] isEqualToString:@"sender"]) {
            giftSymbol.image = [UIImage imageNamed:@"zan_gift.png"];
        }else{
            if (isMi) {
                giftSymbol.image = [UIImage imageNamed:@"zan_fish.png"];
            }else{
                giftSymbol.image = [UIImage imageNamed:@"zan_bone.png"];
            }
        }
        [usersBgView addSubview:giftSymbol];
    }
    UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(320-20-10, 15, 20, 20) ImageName:@"arrow_right.png"];
    [usersBgView addSubview:arrow];
    
    UIButton * usersBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, 50) ImageName:nil Target:self Action:@selector(usersBtnClick) Title:nil];
    [usersBgView addSubview:usersBtn];
    

}
-(void)createCmt
{
    int height = 0;
    usersBgView.hidden = YES;
    if (txCount) {
        height = usersBgView.frame.size.height;
        usersBgView.hidden = NO;
    }
    //创建评论
    commentsBgView = [MyControl createViewWithFrame:CGRectMake(0, usersBgView.frame.origin.y+height, 320, 100)];
    [self.sv addSubview:commentsBgView];
    
    int commentsBgViewHeight = 0;
    for(int i=0;i<self.usrIdArray.count;i++){
        UILabel * cmtUserName = [MyControl createLabelWithFrame:CGRectMake(15, 10+commentsBgViewHeight, 150, 20) Font:15 Text:nil];
        if ([self.nameArray[i] rangeOfString:@"&"].location == NSNotFound) {
            cmtUserName.text = self.nameArray[i];
            cmtUserName.textColor = BGCOLOR;
        }else{
            NSString * name = [[self.nameArray[i] componentsSeparatedByString:@"&"] objectAtIndex:0];
            NSString * reply_name = [[self.nameArray[i] componentsSeparatedByString:@"&"] objectAtIndex:1];
            NSString * str = [NSString stringWithFormat:@"%@ 回复 %@", name, reply_name];
            NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:str];
            [attString addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(0, name.length)];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(name.length, 4)];
            [attString addAttribute:NSForegroundColorAttributeName value:BGCOLOR range:NSMakeRange(name.length+4, reply_name.length)];
            cmtUserName.attributedText = attString;
        }
        
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
        
        UIButton * btn = [MyControl createButtonWithFrame:CGRectMake(0, cmtUserName.frame.origin.y, self.view.frame.size.width, line.frame.origin.y+line.frame.size.height-cmtUserName.frame.origin.y) ImageName:@"" Target:self Action:@selector(replyBtnClick:) Title:nil];
//        btn.backgroundColor = [UIColor colorWithRed:arc4random()%256/256.0 green:arc4random()%256/256.0 blue:arc4random()%256/256.0 alpha:0.3];
        btn.tag = 1000 + i;
        [commentsBgView addSubview:btn];
        
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
#pragma mark - 
-(void)replyClick:(int)row
{
    NSLog(@"replyComment");
    if (![ControllerManager getIsSuccess]) {
        //提示注册
        ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc createLoginAlertView];
        return;
    }
    isReply = YES;
    replyRow = row;
    bgButton.hidden = NO;
    commentTextView.text = self.replyPlaceHolder;
    [UIView animateWithDuration:0.25 animations:^{
        bgButton.alpha = 0.3;
        commentBgView.frame = CGRectMake(0, self.view.frame.size.height-216-40, 320, 40);
    }];
    [commentTextView becomeFirstResponder];
}
#pragma mark - 回复点击事件监听
-(void)replyBtnClick:(UIButton *)btn
{
    int i = btn.tag-1000;
    NSLog(@"btn.tag:%d-回复:%@", btn.tag, self.nameArray[i]);
    if ([self.usrIdArray[i] isEqualToString:[USER objectForKey:@"usr_id"]]) {
        StartLoading;
        [MMProgressHUD dismissWithError:@"不能回复自己哦" afterDelay:0.7f];
        return;
    }

    self.replyPlaceHolder = [NSString stringWithFormat:@"回复%@", self.nameArray[i]];
    [self replyClick:i];
}


#pragma mark - 键盘监听
-(void)keyboardWasChange:(NSNotification *)notification
{
    if (!isInThisController) {
        return;
    }
    //如果不是textView触发的变化不改变位置
    if (!isCommentActive) {
        return;
    }
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
//        return;
    }else{
        QuickGiftViewController *quictGiftvc = [[QuickGiftViewController alloc] init];
        [self addChildViewController:quictGiftvc];
        [quictGiftvc didMoveToParentViewController:self];
        [self.view addSubview:quictGiftvc.view];
        [quictGiftvc release];
    }
//    PresentDetailViewController * vc = [[PresentDetailViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
//    [vc release];
    
    

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
    isReply = NO;
    bgButton.hidden = NO;
    commentTextView.text = @"写个评论呗";
    [UIView animateWithDuration:0.25 animations:^{
        bgButton.alpha = 0.3;
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
    [self cancelBtnClick];
    
    if (button.tag == 200) {
        NSLog(@"微信");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.cmt image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self loadShareAPI];
                shareNum.text = [NSString stringWithFormat:@"%d", [shareNum.text intValue]+1];
                StartLoading;
                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                StartLoading;
                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
            
        }];
    }else if(button.tag == 201){
        NSLog(@"朋友圈");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.cmt image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self loadShareAPI];
                shareNum.text = [NSString stringWithFormat:@"%d", [shareNum.text intValue]+1];
                StartLoading;
                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                StartLoading;
                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }

        }];
    }else{
        NSLog(@"微博");
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"ha哈哈哈" image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self loadShareAPI];
                shareNum.text = [NSString stringWithFormat:@"%d", [shareNum.text intValue]+1];
                StartLoading;
                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                NSLog(@"失败原因：%@", response);
                StartLoading;
                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }

        }];
    }
}
#pragma mark - 分享API
-(void)loadShareAPI
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@dog&cat", self.img_id]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", SHAREIMAGEAPI, self.img_id, sig, [ControllerManager getSID]];
    NSLog(@"shareUrl:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            //返回gold
            int gold = [[[load.dataDict objectForKey:@"data"] objectForKey:@"gold"] intValue];
            if (gold != [[USER objectForKey:@"gold"] intValue]) {
                //差值
                int add = gold-[[USER objectForKey:@"gold"] intValue];
                [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"gold"] forKey:@"gold"];
                [ControllerManager HUDImageIcon:@"gold.png" showView:self.view yOffset:0 Number:add];
            }
        }else{
            
        }
    }];
    [request release];
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
    MassWatchViewController * vc = [[MassWatchViewController alloc] init];
    vc.usr_ids = self.likers;
    vc.txTypesArray = self.txTypeTotalArray;
    vc.isMi = isMi;
    vc.modalTransitionStyle = 2;
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)bgButtonClick
{
    [commentTextView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        commentBgView.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40);
        bgButton.alpha = 0;
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
                    if (isMi) {
                        fish.image = [UIImage imageNamed:@"fish1.png"];
                    }else{
                        fish.image = [UIImage imageNamed:@"bone1.png"];
                    }
                    zanLabel.text = [NSString stringWithFormat:@"%d", [zanLabel.text intValue]+1];
                    [UIView animateWithDuration:0.5 animations:^{
                        if (isMi) {
                            //48*23
                            fish.frame = CGRectMake(0-15, 4-12, 30*2, 14*2);
                        }else{
                            //41*34
                            fish.frame = CGRectMake(0-15, 4-12, 20*2, 16*2);
                        }
                        
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 animations:^{
                            if (isMi) {
                                //48*23
                                fish.frame = CGRectMake(3, 3, 30, 14);
                            }else{
                                //41*34
                                fish.frame = CGRectMake(8, 3, 20, 16);
                            }
                        }];
                    }];
                    //在头像横条中显示
                    [self.txTotalArray removeAllObjects];
                    [self.txTypeTotalArray removeAllObjects];
                    
                    if ([USER objectForKey:@"tx"] == nil || [[USER objectForKey:@"tx"] isEqualToString:@""]) {
                        [self.txTotalArray addObject:@""];
                    }else{
                        [self.txTotalArray addObject:[USER objectForKey:@"tx"]];
                    }
                    [self.txTypeTotalArray addObject:@"liker"];
                    if ([self.likers isKindOfClass:[NSNull class]] || self.likers.length == 0) {
                        self.likers = [NSString stringWithFormat:@"%@", [USER objectForKey:@"usr_id"]];
                    }else{
                        self.likers = [NSString stringWithFormat:@"%@,%@", self.likers, [USER objectForKey:@"usr_id"]];
                    }
                    [usersBgView removeFromSuperview];
                    //【注意】这里是commentsBgView，不是commentBgView
                    [commentsBgView removeFromSuperview];
                    [self createUsersTx];
                    [self createCmt];
                    
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

#pragma mark - 进入国王
- (IBAction)headBtnClick:(id)sender {
    NSLog(@"进入王国");
    if (![ControllerManager getIsSuccess]) {
        //提示注册
        ToolTipsViewController * vc = [[ToolTipsViewController alloc] init];
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc createLoginAlertView];
    }else{
        PetInfoViewController *petInfoKing = [[PetInfoViewController alloc] init];
        petInfoKing.aid = self.aid;
        [self presentViewController:petInfoKing animated:YES completion:^{
            NSLog(@"进入王国");
        }];
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
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", FOLLOWAPI, self.aid, sig, [ControllerManager getSID]];
        NSLog(@"url:%@", url);
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
        [MMProgressHUD showWithStatus:@"关注中..."];
        [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"%@", load.dataDict);
                [MMProgressHUD dismissWithSuccess:@"关注成功" title:nil afterDelay:1];
                self.attentionBtn.selected = YES;
            }else{
                [MMProgressHUD dismissWithError:@"关注失败" afterDelay:1];
            }
        }];
    }else{
        NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", self.aid];
        NSString * sig = [MyMD5 md5:code];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", UNFOLLOWAPI, self.aid, sig, [ControllerManager getSID]];
        NSLog(@"unfollowApiurl:%@", url);
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
        [MMProgressHUD showWithStatus:@"取消关注中..."];
        [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"%@", load.dataDict);
                [MMProgressHUD dismissWithSuccess:@"取消关注成功" title:nil afterDelay:1];
                self.attentionBtn.selected = NO;
            }else{
                [MMProgressHUD dismissWithError:@"取消关注失败" afterDelay:1];
            }
        }];
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
    if (!isReply && ([commentTextView.text isEqualToString:@"写个评论呗"] || commentTextView.text.length == 0)) {
        //        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"不写评论怎么发 = =。"];
        StartLoading;
        [MMProgressHUD dismissWithError:@"不写评论怎么发 = =。" afterDelay:1.5];
        return;
    }
    if (isReply && ([commentTextView.text isEqualToString:self.replyPlaceHolder] || commentTextView.text.length == 0)) {
        StartLoading;
        [MMProgressHUD dismissWithError:@"不写内容怎么回 = =。" afterDelay:1.5];
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
    if (isReply) {
//        NSLog(@"%@--%@--%@", self.usrIdArray[replyRow],self.nameArray[replyRow],[self.nameArray[replyRow] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        [_request setPostValue:self.usrIdArray[replyRow] forKey:@"reply_id"];
        NSLog(@"%@", self.nameArray[replyRow]);
        [_request setPostValue:[self.nameArray[replyRow] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"reply_name"];
    }
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
    NSLog(@"request.responseData:%@",[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
    //经验弹窗
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    int exp = [[USER objectForKey:@"exp"] intValue];
    
    [USER setObject:[[dict objectForKey:@"data"] objectForKey:@"exp"] forKey:@"exp"];
    int index = [[USER objectForKey:@"exp"] intValue]-exp;
    if (index>0) {
        [ControllerManager HUDImageIcon:@"Star.png" showView:self.view.window yOffset:0 Number:index];
    }
    NSString * gold = [[dict objectForKey:@"data"] objectForKey:@"gold"];
    [USER setObject:gold forKey:@"gold"];
    [commentTextView resignFirstResponder];
    
    //添加评论
    [self.usrIdArray addObject:[USER objectForKey:@"usr_id"]];
    if (isReply) {
        [self.nameArray addObject:[NSString stringWithFormat:@"%@&%@", [USER objectForKey:@"name"], self.nameArray[replyRow]]];
    }else{
        [self.nameArray addObject:[USER objectForKey:@"name"]];
    }
    
    [self.bodyArray addObject:commentTextView.text];
    [self.createTimeArray addObject:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]]];
    
    [UIView animateWithDuration:0.3 animations:^{
        commentBgView.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40);
        //评论清空
        commentTextView.text = @"写个评论呗";
        commentTextView.textColor = [UIColor lightGrayColor];
    }];
    bgButton.hidden = YES;
    [MMProgressHUD dismissWithSuccess:@"评论成功" title:nil afterDelay:0.2];
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
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    isCommentActive = YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    isCommentActive = NO;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NSLog(@"%d--%@", commentTextView.text.length, text);
    if ([commentTextView.text isEqualToString:@"写个评论呗"] || [commentTextView.text isEqualToString:self.replyPlaceHolder]) {
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
