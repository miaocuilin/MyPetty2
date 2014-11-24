//
//  FrontImageDetailViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/21.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "FrontImageDetailViewController.h"
#define GRAY [UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1]
#import "BackImageDetailViewCell.h"
#import "UserInfoModel.h"
#import "PetInfoViewController.h"
#import "SendGiftViewController.h"
#import "TalkViewController.h"
#import "BackImageDetailCommentViewCell.h"
#import "UserInfoViewController.h"
@interface FrontImageDetailViewController ()

@end

@implementation FrontImageDetailViewController
-(void)dealloc
{
    [sv release];
    [sv2 release];
    [swipeLeft release];
    [swipeRight release];
    [bigImageView release];
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    isInThisController = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    isInThisController = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MobClick event:@"photopage"];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.usrIdArray = [NSMutableArray arrayWithCapacity:0];
    self.nameArray = [NSMutableArray arrayWithCapacity:0];
    self.bodyArray = [NSMutableArray arrayWithCapacity:0];
    self.createTimeArray = [NSMutableArray arrayWithCapacity:0];
    //
    self.likerTxArray = [NSMutableArray arrayWithCapacity:0];
    self.senderTxArray = [NSMutableArray arrayWithCapacity:0];
    self.likerIdArray = [NSMutableArray arrayWithCapacity:0];
    self.senderIdArray = [NSMutableArray arrayWithCapacity:0];
    
    
    //加手势
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRight];
    
//    UIImageView * image = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"cat2.jpg"];
//    [self.view addSubview:image];
    
    [self createUI];
    
    [self loadImageData];
    
}
-(void)loadImageData
{
    LOADING;
    
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@&usr_id=%@dog&cat", self.img_id, [USER objectForKey:@"usr_id"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&usr_id=%@&sig=%@&SID=%@", IMAGEINFOAPI, self.img_id, [USER objectForKey:@"usr_id"], sig, [ControllerManager getSID]];
    NSLog(@"imageInfoAPI:%@", url);
    
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"confVersion"] isEqualToString:@"1.0"]) {
                isTest = YES;
            }
            
            NSLog(@"imageInfo:%@", load.dataDict);
//            self.is_follow = [[[load.dataDict objectForKey:@"data"] objectForKey:@"is_follow"] intValue];
            //            if (self.is_follow) {
            //                self.attentionBtn.selected = YES;
            //            }
            self.picDict = load.dataDict;
            self.imageDict = [[load.dataDict objectForKey:@"data"] objectForKey:@"image"];
            
            //likerId
            self.likerIdArray = [NSMutableArray arrayWithArray:[[self.imageDict objectForKey:@"likers"] componentsSeparatedByString:@","]];
            
            //senderId
            self.senderIdArray = [NSMutableArray arrayWithArray:[[self.imageDict objectForKey:@"senders"] componentsSeparatedByString:@","]];
            
            //likerTx
            if ([[[self.picDict objectForKey:@"data"] objectForKey:@"liker_tx"] isKindOfClass:[NSArray class]]) {
                self.likerTxArray = [[self.picDict objectForKey:@"data"] objectForKey:@"liker_tx"];
            }
//            NSLog(@"%@--%@", [[self.picDict objectForKey:@"data"] objectForKey:@"liker_tx"], self.likerTxArray);
            //senderTx
            if ([[[self.picDict objectForKey:@"data"] objectForKey:@"sender_tx"] isKindOfClass:[NSArray class]]) {
                self.senderTxArray = [[self.picDict objectForKey:@"data"] objectForKey:@"sender_tx"];
            }
            [tv reloadData];
            
            [self analyseComments];
            
            [self loadPetData];
            
            ENDLOADING;
            
            [self modifyUI];
        }else{
            LOADFAILED
            NSLog(@"数据加载失败");
        }
    }];
    [request release];
}
-(void)analyseComments
{
    if (!([[self.imageDict objectForKey:@"comments"] isKindOfClass:[NSNull class]] || [[self.imageDict objectForKey:@"comments"] length] == 0)) {
        NSArray * arr1 = [[self.imageDict objectForKey:@"comments"] componentsSeparatedByString:@";usr"];
        
        //以前这里i从1开始，起初好像是为了实时回复
        for(int i=0;i<arr1.count;i++){
            if (i == 0 && [arr1[i] length] == 0) {
                continue;
            }
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
                NSLog(@"%@", reply_name);
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

    }

}

-(void)loadPetData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", [self.imageDict objectForKey:@"aid"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETINFOAPI, [self.imageDict objectForKey:@"aid"], sig, [ControllerManager getSID]];
    NSLog(@"PetInfoAPI:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"照片详情页宠物信息：%@", load.dataDict);
            //            PetInfoModel * model = [[PetInfoModel alloc] init];

            self.petDict = [load.dataDict objectForKey:@"data"];
            
            [self modifyBackPage];
            ENDLOADING;
        }else{
            LOADFAILED;
            NSLog(@"请求宠物数据失败");
        }
    }];
    [request release];
}

#pragma mark -
-(void)modifyUI
{
    LOADING;
    [bigImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, [self.imageDict objectForKey:@"url"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        ENDLOADING;
        
        CGRect rect = bigImageView.frame;
        
        float p = rect.size.width*image.size.height/image.size.width;
        rect.size.height = p;
        bigImageView.frame = rect;
        
        //
        CGRect rect2 = desLabel.frame;
        if ([[self.imageDict objectForKey:@"cmt"] isKindOfClass:[NSString class]] && [[self.imageDict objectForKey:@"cmt"] length]>0) {
            desLabel.text = [self.imageDict objectForKey:@"cmt"];
            CGSize size = [desLabel.text boundingRectWithSize:CGSizeMake(rect2.size.width, 100) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
            rect2.size.height = size.height;
            rect2.origin.y = rect.origin.y+rect.size
            .height+10;
            desLabel.frame = rect2;
        }else{
            rect2.size.height = 0;
            rect2.origin.y = rect.origin.y+rect.size
            .height+10;
            desLabel.frame = rect2;
        }
        
        //话题
        CGRect rect3 = topicLabel.frame;
        if ([[self.imageDict objectForKey:@"topic_name"] isKindOfClass:[NSString class]] && [[self.imageDict objectForKey:@"topic_name"] length]>0) {
            topicLabel.text = [NSString stringWithFormat: @"#%@#", [self.imageDict objectForKey:@"topic_name"]];
            CGSize size = [topicLabel.text boundingRectWithSize:CGSizeMake(rect3.size.width, 100) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
            rect3.size.height = size.height;
            rect3.origin.y = rect2.origin.y+rect2.size
            .height+5;
            topicLabel.frame = rect3;
        }else{
            rect3.size.height = 0;
            rect3.origin.y = rect2.origin.y+rect2.size
            .height+5;
            topicLabel.frame = rect3;
        }
        
        //时间
        CGRect rect4 = timeLabel.frame;
        if ([[self.imageDict objectForKey:@"create_time"] isKindOfClass:[NSString class]] && [[self.imageDict objectForKey:@"create_time"] length]>0) {
            timeLabel.text = [MyControl timeStringFromStamp:[self.imageDict objectForKey:@"create_time"]];
            CGSize size = [timeLabel.text boundingRectWithSize:CGSizeMake(rect4.size.width, 100) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            rect4.size.height = size.height;
            rect4.origin.y = rect3.origin.y+rect3.size
            .height+5;
            timeLabel.frame = rect4;
        }else{
            rect4.size.height = 0;
            rect4.origin.y = rect3.origin.y+rect3.size
            .height+5;
            timeLabel.frame = rect4;
        }
        
        CGRect rect5 = imageBgView.frame;
        rect5.size.height = rect4.origin.y+rect4.size.height+10;
        imageBgView.frame = rect5;
        
        sv.contentSize = CGSizeMake(sv.frame.size.width, rect5.origin.y + rect5.size.height+50);
        
        sv2.contentSize = CGSizeMake(sv.frame.size.width, rect5.origin.y + rect5.size.height+50);
        
        CGRect image2Rect = imageBgView2.frame;
        if(imageBgView.frame.size.height>350){
            image2Rect.size.height = rect5.size.height;
        }else{
            image2Rect.size.height = 350;
        }
        imageBgView2.frame = image2Rect;
    }];
    
    
}
-(void)modifyBackPage
{
    //back
    CGRect rect1 = tv.frame;
    rect1.size.height = imageBgView2.frame.size.height-rect1.origin.y-15;
    tv.frame = rect1;
    
    CGRect rect2 = desTv.frame;
    rect2.size.height = imageBgView2.frame.size.height-rect2.origin.y-15;
    desTv.frame = rect2;
    
    
    [headBtn setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PETTXURL, [self.petDict objectForKey:@"tx"]]] forState:UIControlStateNormal];
    
    [userTx setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL, [self.petDict objectForKey:@"u_tx"]]]];
    
    if ([[self.petDict objectForKey:@"gender"] intValue] == 1) {
        sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    
    petName.text = [self.petDict objectForKey:@"name"];
    petType.text = [ControllerManager returnCateNameWithType:[self.petDict objectForKey:@"type"]];
    userName.text = [NSString stringWithFormat:@"By-%@", [self.petDict objectForKey:@"u_name"]];
    
    UILabel * zan = (UILabel *)[imageBgView2 viewWithTag:300];
    zan.text = [self.imageDict objectForKey:@"likes"];
    
    UILabel * gift = (UILabel *)[imageBgView2 viewWithTag:301];
    gift.text = [self.imageDict objectForKey:@"gifts"];
    
    UILabel * comment = (UILabel *)[imageBgView2 viewWithTag:302];
    comment.text = [NSString stringWithFormat:@"%d", self.usrIdArray.count];
    
    UILabel * share = (UILabel *)[imageBgView2 viewWithTag:303];
    share.text = [self.imageDict objectForKey:@"shares"];
}

#pragma mark -
-(void)createUI
{
    
    bgView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:bgView];
    
    //半透明背景
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [bgView addSubview:alphaView];
    
    /****************正面*******************/
    sv = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    sv.showsVerticalScrollIndicator = NO;
    [bgView addSubview:sv];
    
    
    imageBgView = [MyControl createViewWithFrame:CGRectMake(13, 30, self.view.frame.size.width-13*2, 400)];
    imageBgView.backgroundColor = [UIColor whiteColor];
    imageBgView.layer.borderWidth = 0.8;
    imageBgView.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
    [sv addSubview:imageBgView];
    
//    bigImageView = [[ClickImage alloc] initWithFrame:CGRectMake(8, 5, imageBgView.frame.size.width-16, 300)];
//    bigImageView.canClick = YES;
    bigImageView = [MyControl createImageViewWithFrame:CGRectMake(8, 5, imageBgView.frame.size.width-16, 300) ImageName:@""];
    [imageBgView addSubview:bigImageView];
    
    
    //图片描述
    desLabel = [MyControl createLabelWithFrame:CGRectMake(13, 315, bigImageView.frame.size.width, 20) Font:13 Text:@""];
    desLabel.textColor = GRAY;
    [imageBgView addSubview:desLabel];
    
    //话题
    topicLabel = [MyControl createLabelWithFrame:CGRectMake(13, 340, bigImageView.frame.size.width, 20) Font:13 Text:@""];
    topicLabel.textColor = [ControllerManager colorWithHexString:@"fc7b51"];
    [imageBgView addSubview:topicLabel];
    
    //时间
    timeLabel = [MyControl createLabelWithFrame:CGRectMake(13, 365, bigImageView.frame.size.width, 20) Font:12 Text:@""];
    timeLabel.font = [UIFont boldSystemFontOfSize:12];
    timeLabel.textColor = [ControllerManager colorWithHexString:@"b0b0b0"];
    [imageBgView addSubview:timeLabel];
    
    //close
    UIButton * closeBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width-24-13, -11+30, 32, 31) ImageName:@"front_close.png" Target:self Action:@selector(closeClick) Title:nil];
    [sv addSubview:closeBtn];
    
    /****************背面*******************/
    
    sv2 = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    sv2.showsVerticalScrollIndicator = NO;
    [bgView addSubview:sv2];
    sv2.hidden = YES;
    
    
    imageBgView2 = [MyControl createViewWithFrame:CGRectMake(13, 30, self.view.frame.size.width-13*2, 350)];
    imageBgView2.backgroundColor = [UIColor whiteColor];
    imageBgView2.layer.borderWidth = 0.8;
    imageBgView2.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
    [sv2 addSubview:imageBgView2];
    
    headBtn = [MyControl createButtonWithFrame:CGRectMake(5, 12, 46, 46) ImageName:@"defaultPetHead.png" Target:self Action:@selector(headBtnClick) Title:nil];
    headBtn.layer.cornerRadius = 23;
    headBtn.layer.masksToBounds = YES;
    [imageBgView2 addSubview:headBtn];
    
    sex = [MyControl createImageViewWithFrame:CGRectMake(55, 15, 13, 13) ImageName:@"man.png"];
    [imageBgView2 addSubview:sex];
    
    petName = [MyControl createLabelWithFrame:CGRectMake(sex.frame.origin.x+15, 15, 200, 15) Font:13 Text:@"大黄青葱岁月"];
    petName.textColor = [ControllerManager colorWithHexString:@"565656"];
    [imageBgView2 addSubview:petName];
    
    petType = [MyControl createLabelWithFrame:CGRectMake(sex.frame.origin.x, 36, 100, 15) Font:11 Text:@"金毛"];
    petType.textColor = GRAY;
    [imageBgView2 addSubview:petType];
    
    userTx = [MyControl createImageViewWithFrame:CGRectMake(imageBgView2.frame.size.width-20-13, 32, 20, 20) ImageName:@"defaultUserHead.png"];
    userTx.layer.cornerRadius = 10;
    userTx.layer.masksToBounds = YES;
    [imageBgView2 addSubview:userTx];
    
    userName = [MyControl createLabelWithFrame:CGRectMake(userTx.frame.origin.x-150, 36, 150, 15) Font:11 Text:@"By—彭于晏帅哥欧巴~"];
    userName.textAlignment = NSTextAlignmentRight;
    userName.textColor = GRAY;
    [imageBgView2 addSubview:userName];
    
    UIButton * jumpToUser = [MyControl createButtonWithFrame:CGRectMake(imageBgView2.frame.size.width-100, userTx.frame.origin.y, 100, 20) ImageName:@"" Target:self Action:@selector(jumpToUserClick) Title:nil];
    [imageBgView2 addSubview:jumpToUser];
    
    UIView * line = [MyControl createViewWithFrame:CGRectMake(0, 65, imageBgView2.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [imageBgView2 addSubview:line];
    
    float space2 = (imageBgView2.frame.size.width-40-20-4*23.5)/3;
    NSArray * imageArray2 = @[@"back_zan.png", @"back_gift.png", @"back_comment.png", @"back_share.png"];
    
    for (int i=0; i<imageArray2.count; i++) {
        UIButton * btn = [MyControl createButtonWithFrame:CGRectMake(20+i*(space2+23.5), line.frame.origin.y+15, 23.5, 22) ImageName:imageArray2[i] Target:self Action:@selector(backClick:) Title:nil];
        [imageBgView2 addSubview:btn];
        btn.tag = 200+i;
        
        UILabel * numLabel = [MyControl createLabelWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width+5, btn.frame.origin.y, space2-5, btn.frame.size.height) Font:13 Text:@"123"];
        numLabel.textColor = GRAY;
        [imageBgView2 addSubview:numLabel];
        numLabel.tag = 300+i;
    }
    
    UIButton * zanBtn = (UIButton *)[imageBgView2 viewWithTag:200];
    
    triangle = [MyControl createImageViewWithFrame:CGRectMake(20+23.5/2.0-7, zanBtn.frame.origin.y+22+10, 15, 14) ImageName:@"back_tri.png"];
    [imageBgView2 addSubview:triangle];
    
    //53*3高
    tv = [[UITableView alloc] initWithFrame:CGRectMake(10, triangle.frame.origin.y+14, imageBgView2.frame.size.width-20, 53*4) style:UITableViewStylePlain];
    tv.backgroundColor = [ControllerManager colorWithHexString:@"eaeaea"];
    tv.separatorStyle = 0;
    tv.dataSource = self;
    tv.delegate = self;
    [imageBgView2 addSubview:tv];
    
    desTv = [[UITableView alloc] initWithFrame:CGRectMake(10, triangle.frame.origin.y+14, imageBgView2.frame.size.width-20, 53*4) style:UITableViewStylePlain];
    desTv.backgroundColor = [ControllerManager colorWithHexString:@"eaeaea"];
    desTv.separatorStyle = 0;
    desTv.dataSource = self;
    desTv.delegate = self;
    [imageBgView2 addSubview:desTv];
    desTv.hidden = YES;
    
    
    //close
    UIButton * closeBtn2 = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width-24-13, -11+30, 32, 31) ImageName:@"front_close.png" Target:self Action:@selector(closeClick) Title:nil];
    [sv2 addSubview:closeBtn2];
    
    /***********************************/
    //底部按钮
    bottomBgView = [MyControl createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height-47, self.view.frame.size.width, 47) ImageName:@""];
    bottomBgView.image = [[UIImage imageNamed:@"front_bottomBg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [bgView addSubview:bottomBgView];
    
    //
    
    //63/2 60/2
    //左右间隔20 中间间隔(width-40-5*31.5)/4
    float space = (self.view.frame.size.width-40-5*31.5)/4;
    NSArray * imageArray = @[@"front_zan.png", @"front_gift.png", @"front_comment.png", @"front_share.png", @"front_more.png"];
    for (int i=0; i<imageArray.count; i++) {
        UIButton * btn = [MyControl createButtonWithFrame:CGRectMake(20+i*(space+31.5), 9, 31.5, 30) ImageName:imageArray[i] Target:self Action:@selector(bottomClick:) Title:nil];
        [bottomBgView addSubview:btn];
        btn.tag = 100+i;
    }
    
}

#pragma mark - 
-(void)jumpToUserClick
{
    UserInfoViewController * vc = [[UserInfoViewController alloc] init];
    vc.usr_id = [self.petDict objectForKey:@"master_id"];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
#pragma mark - 点赞
-(void)zanBtnClick:(UIButton *)btn
{
    if (![ControllerManager getIsSuccess]) {
        //提示注册
        ShowAlertView;
        return;
    }
    //
//    if (!btn.selected) {
        /*================================*/
        NSString * code = [NSString stringWithFormat:@"img_id=%@dog&cat", self.img_id];
        NSString * sig = [MyMD5 md5:code];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", LIKEAPI, self.img_id, sig, [ControllerManager getSID]];
        NSLog(@"likeURL:%@", url);
        
        LOADING;
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            btn.userInteractionEnabled = NO;
            [self performSelector:@selector(openInter:) withObject:btn afterDelay:2.4];
            if (isFinish) {
                NSLog(@"%@", load.dataDict);

                if (![[[load.dataDict objectForKey:@"data"] objectForKey:@"gold"] isKindOfClass:[NSNumber class]]) {
//                    [MMProgressHUD dismissWithError:@"点赞失败" afterDelay:1];
                }else{
                    [MobClick event:@"like"];
                    
                    int a = [[[load.dataDict objectForKey:@"data"] objectForKey:@"gold"] intValue];
                    if (a) {
                        [ControllerManager HUDImageIcon:@"gold.png" showView:self.view yOffset:0 Number:a];
                    }
                    
                    [self.likerIdArray insertObject:[USER objectForKey:@"usr_id"] atIndex:0];
                    [self.likerTxArray insertObject:[USER objectForKey:@"tx"] atIndex:0];
                    UILabel * label = (UILabel *)[imageBgView2 viewWithTag:300];
                    label.text = [NSString stringWithFormat:@"%d", self.likerTxArray.count];
                    if (triangleIndex == 0) {
                        [tv reloadData];
                    }
                    
//                    zanLabel.text = [NSString stringWithFormat:@"%d", [zanLabel.text intValue]+1];

                    //在头像横条中显示
                    /*因为在重新布局的时候会重新在
                     txTotalArray中添加tx数据，所以
                     在这里将数组清空，将自己tx添加
                     在最前端。
                     */
//                    [self.txTotalArray removeAllObjects];
//                    [self.txTypeTotalArray removeAllObjects];
//                    
//                    if ([USER objectForKey:@"tx"] == nil || [[USER objectForKey:@"tx"] isEqualToString:@""]) {
//                        [self.likerTxArray insertObject:@"" atIndex:0];
//                        //                        [self.txTotalArray addObject:@""];
//                    }else{
//                        [self.likerTxArray insertObject:[USER objectForKey:@"tx"] atIndex:0];
//                        //                        [self.likerTxArray addObject:[USER objectForKey:@"tx"]];
//                        //                        [self.txTotalArray addObject:[USER objectForKey:@"tx"]];
//                    }
//                    //                    [self.txTypeTotalArray insertObject:@"liker" atIndex:0];
//                    //                    [self.txTypeTotalArray addObject:@"liker"];
//                    if ([self.likers isKindOfClass:[NSNull class]] || self.likers.length == 0) {
//                        self.likers = [NSString stringWithFormat:@"%@", [USER objectForKey:@"usr_id"]];
//                    }else{
//                        self.likers = [NSString stringWithFormat:@"%@,%@", self.likers, [USER objectForKey:@"usr_id"]];
//                    }
//                    [usersBgView removeFromSuperview];
//                    //【注意】这里是commentsBgView，不是commentBgView
//                    [commentsBgView removeFromSuperview];
//                    [self createUsersTx];
//                    [self createCmt];
                    
                    //                    [MMProgressHUD dismissWithSuccess:@"点赞成功" title:nil afterDelay:0.5];
                }
                ENDLOADING;
            }else{
                ENDLOADING;
//                LoadingFailed;
                //                [MMProgressHUD dismissWithError:@"点赞请求失败" afterDelay:1];
                NSLog(@"数据请求失败");
            }
        }];
        [request release];
//    }else{
//        PopupView * pop = [[PopupView alloc] init];
//        [pop modifyUIWithSize:self.view.frame.size msg:@"您已经点过赞了"];
//        [self.view addSubview:pop];
//        [pop release];
//        
//        [UIView animateWithDuration:0.2 animations:^{
//            pop.bgView.alpha = 1;
//        } completion:^(BOOL finished) {
//            [UIView animateKeyframesWithDuration:0.2 delay:2 options:0 animations:^{
//                pop.bgView.alpha = 0;
//            } completion:^(BOOL finished) {
//                [pop removeFromSuperview];
//            }];
//        }];
//    }

}
-(void)openInter:(UIButton *)btn
{
    btn.userInteractionEnabled = YES;
}

#pragma mark -
-(void)bottomClick:(UIButton *)btn
{
    NSLog(@"%d", btn.tag);
    if (btn.tag == 100) {
        [self zanBtnClick:btn];
    }else if(btn.tag == 101){
        if (![ControllerManager getIsSuccess]) {
            //提示注册
            ShowAlertView;
            return;
        }
        
        SendGiftViewController * vc = [[SendGiftViewController alloc] init];
        vc.receiver_aid = [self.petDict objectForKey:@"aid"];
        vc.receiver_name = [self.petDict objectForKey:@"name"];
        vc.hasSendGift = ^(NSString * itemId){
            NSLog(@"赠送礼物给默认宠物成功!");
            
            [self.senderIdArray insertObject:[USER objectForKey:@"usr_id"] atIndex:0];
            [self.senderTxArray insertObject:[USER objectForKey:@"tx"] atIndex:0];
            UILabel * label = (UILabel *)[imageBgView2 viewWithTag:301];
            label.text = [NSString stringWithFormat:@"%d", self.senderTxArray.count];
            if(triangleIndex == 1){
                [tv reloadData];
            }
            //
            
            ResultOfBuyView * result = [[ResultOfBuyView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [UIView animateWithDuration:0.3 animations:^{
                result.alpha = 1;
            }];
            result.confirm = ^(){
                [vc closeGiftAction];
            };
            [result configUIWithName:[self.petDict objectForKey:@"name"] ItemId:itemId Tx:[self.petDict objectForKey:@"tx"]];
            [self.view addSubview:result];
            
            
        };
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        
        [self.view addSubview:vc.view];
        [vc release];
    }else if(btn.tag == 102){
        //评论
        isReply = NO;
        [self commentClick];
    }else if(btn.tag == 103){
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友", @"朋友圈", @"微博", nil];
        [sheet showInView:self.view];
        sheet.tag = 400;
        [sheet release];
    }else if(btn.tag == 104){
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"更多" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"查看大图", @"私信", @"举报此照", nil];
        [sheet showInView:self.view];
        sheet.tag = 401;
        [sheet release];
    }
}
#pragma mark - commentClick
-(void)commentClick
{
    if (![ControllerManager getIsSuccess]) {
        //提示注册
        ShowAlertView;
        return;
    }
    if (!isCommentCreated) {
        isCommentCreated = YES;
        [self createCommentUI];
    }
    
    if (!isReply) {
        commentTextField.placeholder = @"写个评论呗";
    }else{
        if ([self.usrIdArray[replyRow] isEqualToString:[USER objectForKey:@"usr_id"]]) {
            [MyControl popAlertWithView:self.view Msg:@"不能回复自己哦"];
            return;
        }
        
        NSString * str = nil;
        if ([self.nameArray[replyRow] rangeOfString:@"&"].location != NSNotFound) {
            str = [[self.nameArray[replyRow] componentsSeparatedByString:@"&"] objectAtIndex:0];
        }else{
            str = self.nameArray[replyRow];
        }
        
        commentTextField.placeholder = [NSString stringWithFormat:@"回复 %@", str];
    }
    bgButton.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        bgButton.alpha = 0.3;
        commentBgView.frame = CGRectMake(0, self.view.frame.size.height-216-40, 320, 40);
    }];
    [commentTextField becomeFirstResponder];
}
-(void)createCommentUI
{
    bgButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:nil Target:self Action:@selector(bgButtonClick) Title:nil];
    bgButton.backgroundColor = [UIColor blackColor];
    bgButton.alpha = 0.3;
    bgButton.hidden = YES;
    [self.view addSubview:bgButton];
    
    commentBgView = [MyControl createViewWithFrame:CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40)];
    commentBgView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.view addSubview:commentBgView];
    
    //    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 250, 30)];
    commentTextField = [MyControl createTextFieldWithFrame:CGRectMake(5, 5, 250, 30) placeholder:@"写个评论呗" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    //    commentTextView.textColor = [UIColor lightGrayColor];
    //    commentTextView.text = @"写个评论呗";
    commentTextField.layer.cornerRadius = 5;
    commentTextField.layer.masksToBounds = YES;
    commentTextField.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1].CGColor;
    commentTextField.layer.borderWidth = 1.5;
    commentTextField.delegate = self;
    //    commentTextView.font = [UIFont systemFontOfSize:15];
    //    commentTextView.returnKeyType = UIReturnKeySend;
    //关闭自动更正及大写
    commentTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    commentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [commentBgView addSubview:commentTextField];
    //    [commentTextView release];
    
    UIButton * sendButton = [MyControl createButtonWithFrame:CGRectMake(260, 10, 55, 20) ImageName:@"" Target:self Action:@selector(sendButtonClick) Title:@"发送"];
    [sendButton setTitleColor:BGCOLOR forState:UIControlStateNormal];
    [commentBgView addSubview:sendButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}
-(void)sendButtonClick
{
    if(commentTextField.text == nil){
        [MyControl popAlertWithView:self.view Msg:@"内容为空"];
        return;
    }
    //post数据  参数img_id 和 body
    NSString * url = [NSString stringWithFormat:@"%@%@", COMMENTAPI, [ControllerManager getSID]];
    NSLog(@"postUrl:%@", url);
    ASIFormDataRequest * _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 20;
    
    [_request setPostValue:commentTextField.text forKey:@"body"];
    [_request setPostValue:self.img_id forKey:@"img_id"];
    if (isReply) {
        [_request setPostValue:self.usrIdArray[replyRow] forKey:@"reply_id"];
        NSLog(@"%@", self.nameArray[replyRow]);
        NSString * str = self.nameArray[replyRow];
        //分割&
        if ([str rangeOfString:@"&"].location != NSNotFound) {
            str = [[str componentsSeparatedByString:@"&"] objectAtIndex:0];
        }else if([str rangeOfString:@"@"].location != NSNotFound){
            //分割@
            str = [[str componentsSeparatedByString:@"@"] objectAtIndex:0];
        }
        
        NSLog(@"%@", str);
        [_request setPostValue:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"reply_name"];
    }
    _request.delegate = self;
    [_request startAsynchronous];
    
    LOADING;
}

#pragma mark - ASI代理
-(void)requestFinished:(ASIHTTPRequest *)request
{
    //    buttonRight.userInteractionEnabled = YES;
    ENDLOADING;
    
    NSLog(@"success");
    NSLog(@"request.responseData:%@",[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
    //经验弹窗
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", dict);
    if ([[dict objectForKey:@"state"] intValue] == 2) {
        //过期
        [self login];
    }else{
        if ([[dict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            int exp = [[USER objectForKey:@"exp"] intValue];
            int addExp = [[[dict objectForKey:@"data"] objectForKey:@"exp"] intValue];
            if (addExp>0) {
                [USER setObject:[NSString stringWithFormat:@"%d", exp+addExp] forKey:@"exp"];
                [ControllerManager HUDImageIcon:@"Star.png" showView:self.view.window yOffset:0 Number:addExp];
            }
        }
        
        [commentTextField resignFirstResponder];
        
        //添加评论
        NSLog(@"%@", [USER objectForKey:@"usr_id"]);
        [self.usrIdArray insertObject:[USER objectForKey:@"usr_id"] atIndex:0];
        //    [self.usrIdArray addObject:[USER objectForKey:@"usr_id"]];
        if (isReply) {
            [MobClick event:@"comment"];
            
            [self.nameArray insertObject:[NSString stringWithFormat:@"%@&%@", [USER objectForKey:@"name"], self.nameArray[replyRow]] atIndex:0];
            //        [self.nameArray addObject:[NSString stringWithFormat:@"%@&%@", [USER objectForKey:@"name"], self.nameArray[replyRow]]];
        }else{
            [self.nameArray insertObject:[USER objectForKey:@"name"] atIndex:0];
            //        [self.nameArray addObject:[USER objectForKey:@"name"]];
        }
        NSLog(@"%@", commentTextField.text);
        [self.bodyArray insertObject:commentTextField.text atIndex:0];
        //    [self.bodyArray addObject:commentTextView.text];
        [self.createTimeArray insertObject:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]] atIndex:0];
        //    [self.createTimeArray addObject:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]]];
        
        [UIView animateWithDuration:0.3 animations:^{
            commentBgView.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40);
            //评论清空
            commentTextField.placeholder = @"写个评论呗";
            commentTextField.text = nil;
            //            commentTextView.textColor = [UIColor lightGrayColor];
        }];
        bgButton.hidden = YES;
        [MyControl popAlertWithView:self.view Msg:@"评论成功"];
        //
        UILabel * label = (UILabel *)[imageBgView2 viewWithTag:302];
        label.text = [NSString stringWithFormat:@"%d", self.nameArray.count];
        
//        [commentTextField removeFromSuperview];
        //    if (!([self.likerTxArray isKindOfClass:[NSNull class]] || self.likerTxArray.count == 0)) {
        //        [txsView removeFromSuperview];
        //    }
        [desTv reloadData];
    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
    ENDLOADING;
    [MyControl popAlertWithView:self.view Msg:@"评论失败"];
}
#pragma mark -
-(void)login
{
    LOADING;
    NSString * code = [NSString stringWithFormat:@"uid=%@dog&cat", UDID];
    NSString * url = [NSString stringWithFormat:@"%@&uid=%@&sig=%@", LOGINAPI, UDID, [MyMD5 md5:code]];
    NSLog(@"login-url:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            NSLog(@"%@", load.dataDict);
            [ControllerManager setIsSuccess:[[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]];
            [ControllerManager setSID:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"]];
            [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] forKey:@"isSuccess"];
            [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"] forKey:@"SID"];
            
            [self sendButtonClick];
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}

#pragma mark - 键盘监听
-(void)keyboardWasChange:(NSNotification *)notification
{
    if (!isInThisController) {
        return;
    }
    //如果不是textView触发的变化不改变位置
//    if (!isCommentActive) {
//        return;
//    }
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
-(void)bgButtonClick
{
    [commentTextField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        commentBgView.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40);
        bgButton.alpha = 0;
    } completion:^(BOOL finished) {
        bgButton.hidden = YES;
    }];
}
#pragma mark -
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d", buttonIndex);
    if (actionSheet.tag == 401) {
        if (buttonIndex == 0) {
            //查看大图
        }else if (buttonIndex == 1) {
            //私信
            [self sendMessage];
        }else if (buttonIndex == 2) {
            //举报此照
            [self reportImage];
        }
    }else if(actionSheet.tag == 400){
        [self shareClick:buttonIndex];
//        if (buttonIndex == 0) {
//            //微信好友
//        }else if (buttonIndex == 1) {
//            //朋友圈
//        }else if (buttonIndex == 2) {
//            //微博
//        }
    }
}
#pragma mark - 举报图片
-(void)reportImage
{
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@dog&cat", self.img_id]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", REPORTIMAGEAPI, self.img_id, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            ENDLOADING;
            [MyControl popAlertWithView:self.view Msg:@"举报成功"];
//            [MyControl loadingSuccessWithContent:@"举报成功" afterDelay:0.5];
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
#pragma mark - 私信
-(void)sendMessage
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        return;
    }
    NSLog(@"发私信");
    TalkViewController * vc = [[TalkViewController alloc] init];
    vc.friendName = [self.petDict objectForKey:@"u_name"];
    vc.usr_id = [self.petDict objectForKey:@"master_id"];
    vc.otherTX = [self.petDict objectForKey:@"u_tx"];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}

#pragma mark - 分享截图
-(void)shareClick:(int)index
{
    
    [MobClick event:@"photo_share"];
    
    if (index == 0) {
        NSLog(@"微信");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[self.imageDict objectForKey:@"cmt"] image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self loadShareAPI];
//                shareNum.text = [NSString stringWithFormat:@"%d", [shareNum.text intValue]+1];
                
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
//                StartLoading;
//                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
//                StartLoading;
//                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
            
        }];
    }else if(index == 1){
        NSLog(@"朋友圈");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[self.imageDict objectForKey:@"cmt"] image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self loadShareAPI];
//                shareNum.text = [NSString stringWithFormat:@"%d", [shareNum.text intValue]+1];
                
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
//                StartLoading;
//                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
//                StartLoading;
//                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
            
        }];
    }else if(index == 2){
        NSLog(@"微博");
        NSString * str = [NSString stringWithFormat:@"%@%@", [self.imageDict objectForKey:@"cmt"], @"http://home4pet.aidigame.com/（分享自@宠物星球社交应用）"];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self loadShareAPI];
//                shareNum.text = [NSString stringWithFormat:@"%d", [shareNum.text intValue]+1];
                
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
//                StartLoading;
//                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                NSLog(@"失败原因：%@", response);

                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
//                StartLoading;
//                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
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
            if(![[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                return;
            }
            //返回gold
            //            int gold = [[[load.dataDict objectForKey:@"data"] objectForKey:@"gold"] intValue];
            //            if (gold != [[USER objectForKey:@"gold"] intValue]) {
            //                //差值
            //                int add = gold-[[USER objectForKey:@"gold"] intValue];
            //                [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"gold"] forKey:@"gold"];
            //                [ControllerManager HUDImageIcon:@"gold.png" showView:self.view yOffset:0 Number:add];
            //            }
        }else{
            
        }
    }];
    [request release];
}
-(void)backClick:(UIButton *)btn
{
    NSLog(@"%d", btn.tag);
    triangleIndex = btn.tag-200;
    
    CGRect rect = triangle.frame;
    rect.origin.x = btn.frame.origin.x+btn.frame.size.width/2.0-rect.size.width/2.0;
    
    [UIView animateWithDuration:0.1 animations:^{
        triangle.frame = rect;
    }];
    
//    if (triangleIndex == 0) {
//        
//    }else if (triangleIndex == 1) {
//        
//    }else if (triangleIndex == 2) {
//        
//    }else{
//        
//    }
    
    if (triangleIndex == 2) {
        desTv.hidden = NO;
        tv.hidden = YES;
        [desTv reloadData];
    }else{
        desTv.hidden = YES;
        tv.hidden = NO;
        [tv reloadData];
    }
    
}
-(void)closeClick
{
    NSLog(@"close");
    [self.view removeFromSuperview];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)headBtnClick
{
    PetInfoViewController * vc = [[PetInfoViewController alloc] init];
    vc.aid = [self.imageDict objectForKey:@"aid"];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (triangleIndex == 0) {
        return self.likerTxArray.count;
    }else if(triangleIndex == 1){
        return self.senderTxArray.count;
    }else if(triangleIndex == 2){
//        NSLog(@"%d", self.usrIdArray.count);
        return self.usrIdArray.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (triangleIndex == 0) {
        static NSString * cellID = @"ID";
        BackImageDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[BackImageDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        }
//        NSLog(@"%@", self.likerTxArray);
        [cell configUIWithTx:self.likerTxArray[indexPath.row] Name:@"米钩钩"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = 0;
        return cell;
    }else if(triangleIndex == 1){
        static NSString * cellID2 = @"ID2";
        BackImageDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (!cell) {
            cell = [[[BackImageDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2] autorelease];
        }
        [cell configUIWithTx:self.senderTxArray[indexPath.row] Name:@"米钩钩"];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = 0;
        return cell;
    }else if(triangleIndex == 2){
        static NSString * cellID3 = @"ID3";
        BackImageDetailCommentViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
        if (!cell) {
            cell = [[[BackImageDetailCommentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3] autorelease];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = 0;
        
        float textWidth = [UIScreen mainScreen].bounds.size.width-13*2-10*2-40-10;
        float cellHeight = 0;
        
        CGSize size = [self.bodyArray[indexPath.row] boundingRectWithSize:CGSizeMake(textWidth, 100) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        if (size.height>15.0) {
            cellHeight = 53+size.height-15;
        }else{
            cellHeight = 53.0;
        }
//        NSLog(@"%f", cellHeight);
        [cell configUIWithName:self.nameArray[indexPath.row] Cmt:self.bodyArray[indexPath.row] Time:self.createTimeArray[indexPath.row] CellHeight:cellHeight textSize:size];
        return cell;
    }else{
        static NSString * cellID4 = @"ID4";
        BackImageDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID4];
        if (!cell) {
            cell = [[[BackImageDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID4] autorelease];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = 0;
        return cell;
    }
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 53.0f;
    if (triangleIndex == 2) {
        float textWidth = [UIScreen mainScreen].bounds.size.width-13*2-10*2-40-10;
//        NSLog(@"%d--%@", indexPath.row, self.bodyArray[indexPath.row]);
        if (self.bodyArray[indexPath.row] == nil) {
            return 53.0;
        }
        CGSize size = [self.bodyArray[indexPath.row] boundingRectWithSize:CGSizeMake(textWidth, 100) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        if (size.height>15.0) {
            return 53+size.height-15;
        }else{
            return 53.0;
        }
    }else{
        return 53.0;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoViewController * vc = [[UserInfoViewController alloc] init];
    if (triangleIndex == 0) {
        vc.usr_id = self.likerIdArray[indexPath.row];
        [self presentViewController:vc animated:YES completion:nil];
    }else if (triangleIndex == 1) {
        vc.usr_id = self.senderIdArray[indexPath.row];
        [self presentViewController:vc animated:YES completion:nil];
    }else if (triangleIndex == 2) {
        isReply = YES;
        replyRow = indexPath.row;
        [self commentClick];
//        vc.usr_id = self.usrIdArray[indexPath.row];
//        [self presentViewController:vc animated:YES completion:nil];
    }else{
        
    }
    
    [vc release];
}


#pragma mark -
-(void)swipeLeft:(UISwipeGestureRecognizer *)swipeLeft
{
    NSLog(@"swipeLeft");
    isBackSide = !isBackSide;
    if (isBackSide) {
        sv.hidden = YES;
        sv2.hidden = NO;
//        [self performSelector:@selector(hideSv) withObject:nil afterDelay:0.25f];
//        [self performSelector:@selector(showSv2) withObject:nil afterDelay:0.25f];
    }else{
        sv.hidden = NO;
        sv2.hidden = YES;
//        [self performSelector:@selector(showSv) withObject:nil afterDelay:0.25f];
//        [self performSelector:@selector(hideSv2) withObject:nil afterDelay:0.25f];
    }
    
    CATransition *t = [CATransition animation];
    //    @"flip",
    //    @"alignedFlip"
    t.type = @"alignedFlip";
    t.subtype = kCATransitionFromRight;
    t.duration = 0.5;
    t.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [sv.layer addAnimation:t forKey:@"Transition"];
    
    [sv2.layer addAnimation:t forKey:@"Transition"];
}
-(void)swipeRight:(UISwipeGestureRecognizer *)swipeRight
{
    NSLog(@"swipeRight");
    isBackSide = !isBackSide;
    if (isBackSide) {
        sv.hidden = YES;
        sv2.hidden = NO;
        //        [self performSelector:@selector(hideSv) withObject:nil afterDelay:0.25f];
        //        [self performSelector:@selector(showSv2) withObject:nil afterDelay:0.25f];
    }else{
        sv.hidden = NO;
        sv2.hidden = YES;
        //        [self performSelector:@selector(showSv) withObject:nil afterDelay:0.25f];
        //        [self performSelector:@selector(hideSv2) withObject:nil afterDelay:0.25f];
    }
    
    CATransition *t = [CATransition animation];
    t.type = @"alignedFlip";
    t.subtype = kCATransitionFromLeft;
    t.duration = 0.5;
    t.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [sv.layer addAnimation:t forKey:@"Transition"];
    
    [sv2.layer addAnimation:t forKey:@"Transition"];
}
//-(void)showSv
//{
//    sv.hidden = NO;
//}
//-(void)hideSv
//{
//    sv.hidden = YES;
//}
//-(void)showSv2
//{
//    sv2.hidden = NO;
//}
//-(void)hideSv2
//{
//    sv2.hidden = YES;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
