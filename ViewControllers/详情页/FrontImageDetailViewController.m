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
#import "SendGiftViewController.h"
#import "BackImageDetailCommentViewCell.h"
#import "ChatViewController.h"

@interface FrontImageDetailViewController () <UMSocialUIDelegate>

@end

@implementation FrontImageDetailViewController
-(void)dealloc
{
    [super dealloc];
    [sv release];
    [sv2 release];
    [swipeLeft release];
    [swipeRight release];
    [bigImageView release];
    
    [_usrIdArray release];
    [_nameArray release];
    [_bodyArray release];
    [_createTimeArray release];
    [_cmtTxArray release];
    //
    [_likerTxArray release];
    [_senderTxArray release];
    [_likerIdArray release];
    [_senderIdArray release];
    //
    [_likersArray release];
    [_sendersArray release];
    [_commentersArray release];
    [_sharersArray release];
    
//    [_picDict release];
//    [_imageDict release];
//    [_petDict release];
    [_img_id release];
    
    //清除缓存图片
//    SDImageCache * cache = [SDImageCache sharedImageCache];
//    [cache clearMemory];
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if (!isLoad) {
//        if (![[USER objectForKey:@"guide_detail"] intValue]) {
//            [USER setObject:@"1" forKey:@"guide_detail"];
//            [self createGuide];
//        }
//        
//    }
//}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    isLoad = YES;
//    
//    isInThisController = YES;
//    //底部4个球跳动动画
//    UIButton * b1 = (UIButton *)[self.view viewWithTag:100];
//    UIButton * b2 = (UIButton *)[self.view viewWithTag:101];
//    UIButton * b3 = (UIButton *)[self.view viewWithTag:102];
//    UIButton * b4 = (UIButton *)[self.view viewWithTag:103];
//    CGRect r1 = b1.frame;
//    CGRect r2 = b2.frame;
//    CGRect r3 = b3.frame;
//    CGRect r4 = b4.frame;
//    
//    [self animationWithView:b1 Size:r1];
//    [self animationWithView:b2 Size:r2];
//    [self animationWithView:b3 Size:r3];
//    [self animationWithView:b4 Size:r4];
//}
-(void)createGuide
{
    guide = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"guide1.png"];
    float a = [UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height;
    float b = 320/480.0;
    if(a == b){
        guide.frame = CGRectMake(0, 0, self.view.frame.size.width, 568);
    }
    UITapGestureRecognizer * guideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideTap:)];
    [guide addGestureRecognizer:guideTap];
    
    //    FirstTabBarViewController * tabBar = [ControllerManager shareTabBar];
    [self.view addSubview:guide];
    [guideTap release];
}
-(void)guideTap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.2 animations:^{
        guide.alpha = 0;
    }completion:^(BOOL finished) {
        guide.hidden = YES;
        [guide removeFromSuperview];
        
        if(!isBackSide){
            [self swipeLeft:swipeLeft];
        }
    }];
}
-(void)createGuide2
{
    guide = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"guide_detail_back_comment.png"];
    float a = [UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height;
    float b = 320/480.0;
    if(a == b){
        guide.frame = CGRectMake(0, 0, self.view.frame.size.width, 568);
    }
    UITapGestureRecognizer * guideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideTap:)];
    [guide addGestureRecognizer:guideTap];
    
    //    FirstTabBarViewController * tabBar = [ControllerManager shareTabBar];
    [self.view addSubview:guide];
    [guideTap release];
}

-(void)animationWithView:(UIView *)view Size:(CGRect)r
{
//    [UIView animateWithDuration:0.3 animations:^{
//        view.frame = CGRectMake(r.origin.x-5, r.origin.y-10, r.size.width+10, r.size.height+10);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.4 animations:^{
//            view.frame = r;
//        } completion:nil];
//    }];
    [UIView animateWithDuration:0.2 delay:0.3 options:0 animations:^{
        view.frame = CGRectMake(r.origin.x-5, r.origin.y-10, r.size.width+10, r.size.height+10);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            view.frame = r;
        } completion:nil];
    }];
}
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    isInThisController = NO;
//}
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
    self.cmtTxArray = [NSMutableArray arrayWithCapacity:0];
    //
    self.likerTxArray = [NSMutableArray arrayWithCapacity:0];
    self.senderTxArray = [NSMutableArray arrayWithCapacity:0];
    self.likerIdArray = [NSMutableArray arrayWithCapacity:0];
    self.senderIdArray = [NSMutableArray arrayWithCapacity:0];
    //
    self.likersArray = [NSMutableArray arrayWithCapacity:0];
    self.sendersArray = [NSMutableArray arrayWithCapacity:0];
    self.commentersArray = [NSMutableArray arrayWithCapacity:0];
    self.sharersArray = [NSMutableArray arrayWithCapacity:0];
    
//    //加手势
//    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
//    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:swipeLeft];
//    
//    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
//    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:swipeRight];
    
//    UIImageView * image = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"cat2.jpg"];
//    [self.view addSubview:image];
    
    [self createUI];
    
//    [self modifyUI];
    [self loadImageData];
    
    self.view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
    } completion:^(BOOL finished) {
        if (![[USER objectForKey:@"guide_detail"] intValue]) {
            [USER setObject:@"1" forKey:@"guide_detail"];
            [self createGuide];
        }
        //
        isInThisController = YES;
        //底部4个球跳动动画
        UIButton * b1 = (UIButton *)[self.view viewWithTag:100];
        UIButton * b2 = (UIButton *)[self.view viewWithTag:101];
        UIButton * b3 = (UIButton *)[self.view viewWithTag:102];
        UIButton * b4 = (UIButton *)[self.view viewWithTag:103];
        CGRect r1 = b1.frame;
        CGRect r2 = b2.frame;
        CGRect r3 = b3.frame;
        CGRect r4 = b4.frame;
        
        [self animationWithView:b1 Size:r1];
        [self animationWithView:b2 Size:r2];
        [self animationWithView:b3 Size:r3];
        [self animationWithView:b4 Size:r4];
    }];
    
}
-(void)loadImageData
{
//    LOADING;
    
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@&usr_id=%@dog&cat", self.img_id, [USER objectForKey:@"usr_id"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&usr_id=%@&sig=%@&SID=%@", IMAGEINFOAPI, self.img_id, [USER objectForKey:@"usr_id"], sig, [ControllerManager getSID]];
    NSLog(@"imageInfoAPI:%@", url);
    
    __block FrontImageDetailViewController * blockSelf = self;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
//                [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"图片离家出走了~"];
//                [self closeClick];
//                return;
//            }
            if ([[load.dataDict objectForKey:@"confVersion"] isEqualToString:[USER objectForKey:@"versionKey"]]) {
                blockSelf->isTest = YES;
            }
            
            NSLog(@"imageInfo:%@", load.dataDict);
//            self.is_follow = [[[load.dataDict objectForKey:@"data"] objectForKey:@"is_follow"] intValue];
            
            //            if (self.is_follow) {
            //                self.attentionBtn.selected = YES;
            //            }
            blockSelf.picDict = load.dataDict;
            blockSelf.imageDict = [[load.dataDict objectForKey:@"data"] objectForKey:@"image"];
            
            //判断是否过期
//            NSDate * date = [NSDate date];
            //当前时间戳
//            NSString * stamp = [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
            //t为时间差
            //24小时为期限
//            int t = 0;
            //当前时间戳-时间戳 < 24h 才显示
//            if ([stamp intValue]-[[blockSelf.imageDict objectForKey:@"create_time"] intValue] < 24*60*60) {
//                t = 1;
//            }
            if ([[blockSelf.imageDict objectForKey:@"is_food"] isKindOfClass:[NSString class]]){
                if ([[blockSelf.imageDict objectForKey:@"is_food"] intValue] == 1) {
                    is_food = 1;
                }else if ([[blockSelf.imageDict objectForKey:@"is_food"] intValue] == 2) {
                    is_food = 2;
                }else if ([[blockSelf.imageDict objectForKey:@"is_food"] intValue] == 3) {
                    is_food = 3;
                }
            }

//            NSLog(@"%@", [self.imageDict objectForKey:@"is_food"]);
//            if ([[self.imageDict objectForKey:@"is_food"] isKindOfClass:[NSString class]]) {
//                NSLog(@"string");
//                if ([[self.imageDict objectForKey:@"is_food"] intValue] == 1) {
//                    NSLog(@"1");
//                }
//            }else{
//                
//            }
            
            if([[USER objectForKey:@"isSuccess"] intValue] && [[blockSelf.imageDict objectForKey:@"likers"] isKindOfClass:[NSString class]] && [[blockSelf.imageDict objectForKey:@"likers"] rangeOfString:[USER objectForKey:@"usr_id"]].location != NSNotFound){
                UIButton * button = (UIButton *)[blockSelf.view viewWithTag:100];
                button.selected = YES;
            }
            //likerId
//            self.likerIdArray = [NSMutableArray arrayWithArray:[[self.imageDict objectForKey:@"likers"] componentsSeparatedByString:@","]];
            
            //senderId
//            self.senderIdArray = [NSMutableArray arrayWithArray:[[self.imageDict objectForKey:@"senders"] componentsSeparatedByString:@","]];
            
            //likerTx
//            if ([[[self.picDict objectForKey:@"data"] objectForKey:@"liker_tx"] isKindOfClass:[NSArray class]]) {
//                self.likerTxArray = [[self.picDict objectForKey:@"data"] objectForKey:@"liker_tx"];
//            }
//            NSLog(@"%@--%@", [[self.picDict objectForKey:@"data"] objectForKey:@"liker_tx"], self.likerTxArray);
            //senderTx
//            if ([[[self.picDict objectForKey:@"data"] objectForKey:@"sender_tx"] isKindOfClass:[NSArray class]]) {
//                self.senderTxArray = [[self.picDict objectForKey:@"data"] objectForKey:@"sender_tx"];
//            }
//            [tv reloadData];
            
//            [self loadLikersData];
            
            [blockSelf analyseComments];
            
//            ENDLOADING;
            
            [blockSelf modifyUI];
            
            [blockSelf loadPetData];
        }else{
            blockSelf->imageNotExist = YES;
            blockSelf->sv.hidden = NO;
            [MyControl popAlertWithView:blockSelf.view Msg:@"网络或数据异常"];
            NSLog(@"数据加载失败");
        }
    }];
    [request release];
}
-(void)loadLikersData
{
//    LOADING;
    if (![[self.imageDict objectForKey:@"likers"] isKindOfClass:[NSString class]] || [[self.imageDict objectForKey:@"likers"] length] == 0) {
        return;
    }
    NSString * str = [NSString stringWithFormat:@"usr_ids=%@dog&cat", [self.imageDict objectForKey:@"likers"]];
    NSString * code = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERSINFOAPI, [self.imageDict objectForKey:@"likers"], code, [ControllerManager getSID]];
    NSLog(@"赞列表：%@", url);
    __block FrontImageDetailViewController * blockSelf = self;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            ENDLOADING;
            blockSelf->isLoaded[0] = 1;
            
            NSLog(@"zan:%@", load.dataDict);
            NSArray * array = [load.dataDict objectForKey:@"data"] ;
            for (NSDictionary * dict in array) {
                UserInfoModel * model = [[UserInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [blockSelf.likersArray addObject:model];
                [model release];
            }
            [blockSelf->tv reloadData];
        }else{
//            LOADFAILED;
        }
    }];
    [request release];
}
-(void)loadSendersData
{
    if (![[self.imageDict objectForKey:@"senders"] isKindOfClass:[NSString class]] || [[self.imageDict objectForKey:@"senders"] length] == 0) {
        return;
    }
    if(isBackSide){
        LOADING;
    }
    NSString * str = [NSString stringWithFormat:@"usr_ids=%@dog&cat", [self.imageDict objectForKey:@"senders"]];
    NSString * code = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERSINFOAPI, [self.imageDict objectForKey:@"senders"], code, [ControllerManager getSID]];
    NSLog(@"送礼列表：%@", url);
    __block FrontImageDetailViewController * blockSelf = self;
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            ENDLOADING;
            blockSelf->isLoaded[1] = 1;
            
            NSArray * array = [load.dataDict objectForKey:@"data"] ;
            for (NSDictionary * dict in array) {
                UserInfoModel * model = [[UserInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [blockSelf.sendersArray addObject:model];
                [model release];
            }
            [blockSelf->tv reloadData];
        }else{
            LOADFAILED;
        }
    }];
}
-(void)loadCommentersData
{
//    return;
    if (!self.usrIdArray.count) {
        return;
    }
    
    if(isBackSide){
        LOADING;
    }
    
    NSMutableString * mutableStr = [NSMutableString stringWithCapacity:0];
    for (int i=0; i<self.usrIdArray.count; i++) {
//        if([mutableStr rangeOfString:self.usrIdArray[i]].location != NSNotFound){
//            continue;
//        }
        [mutableStr appendString:self.usrIdArray[i]];
        if (i != self.usrIdArray.count-1) {
            [mutableStr appendString:@","];
        }
    }
    
    NSString * str = [NSString stringWithFormat:@"usr_ids=%@dog&cat", mutableStr];
    NSString * code = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERSINFOAPI, mutableStr, code, [ControllerManager getSID]];
    NSLog(@"评论列表：%@", url);
    
    __block FrontImageDetailViewController * blockSelf = self;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            ENDLOADING;
            
            blockSelf->isLoaded[2] = 1;
            
            NSArray * array = [load.dataDict objectForKey:@"data"] ;
            for (NSDictionary * dict in array) {
                UserInfoModel * model = [[UserInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [blockSelf.commentersArray addObject:model];
                [model release];
            }
            
            for (int i=0; i<blockSelf.commentersArray.count; i++) {
                for (int j=0; j<blockSelf.usrIdArray.count; j++) {
                    if ([[blockSelf.commentersArray[i] usr_id] isEqualToString:blockSelf.usrIdArray[j]]) {
                        blockSelf.cmtTxArray[j] = [blockSelf.commentersArray[i] tx];
                    }
                }
            }
            [blockSelf->desTv reloadData];
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)loadSharersData
{
    if (![[self.imageDict objectForKey:@"sharers"] isKindOfClass:[NSString class]] || [[self.imageDict objectForKey:@"sharers"] length] == 0) {
        return;
    }
//    if (!self.sharersArray.count) {
//        return;
//    }
    if(isBackSide){
        LOADING;
    }
    NSString * str = [NSString stringWithFormat:@"usr_ids=%@dog&cat", [self.imageDict objectForKey:@"sharers"]];
    NSString * code = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERSINFOAPI, [self.imageDict objectForKey:@"sharers"], code, [ControllerManager getSID]];
    NSLog(@"送礼列表：%@", url);
    __block FrontImageDetailViewController * blockSelf = self;
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            ENDLOADING;
            blockSelf->isLoaded[3] = 1;
            
            NSArray * array = [load.dataDict objectForKey:@"data"] ;
            for (NSDictionary * dict in array) {
                UserInfoModel * model = [[UserInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [blockSelf.sharersArray addObject:model];
                [model release];
            }
            [blockSelf->tv reloadData];
        }else{
            LOADFAILED;
        }
    }];
}
/******************************************/
#pragma mark -
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
            
            [self.cmtTxArray addObject:@"0"];
            //
            if ([arr1[i] rangeOfString:@"reply_id"].location == NSNotFound) {
                NSString * name = [[[[arr1[i] componentsSeparatedByString:@",body"] objectAtIndex:0] componentsSeparatedByString:@"name:"] objectAtIndex:1];
                if ([name rangeOfString:@",tx"].location != NSNotFound) {
                    name = [[name componentsSeparatedByString:@",tx"] objectAtIndex:0];
                }
                [self.nameArray addObject:name];
                //            [name release];
            }else{
                NSString * name = [[[[arr1[i] componentsSeparatedByString:@",reply_id"] objectAtIndex:0] componentsSeparatedByString:@",name:"] objectAtIndex:1];
                if ([name rangeOfString:@",tx"].location != NSNotFound) {
                    name = [[name componentsSeparatedByString:@",tx"] objectAtIndex:0];
                }
                NSString * reply_name = [[[[arr1[i] componentsSeparatedByString:@",body"] objectAtIndex:0] componentsSeparatedByString:@",reply_name:"] objectAtIndex:1];
                if ([reply_name rangeOfString:@",tx"].location != NSNotFound) {
                    reply_name = [[reply_name componentsSeparatedByString:@",tx"] objectAtIndex:0];
                }
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
    
    __block FrontImageDetailViewController * blockSelf = self;
    
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", [blockSelf.imageDict objectForKey:@"aid"]]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETINFOAPI, [blockSelf.imageDict objectForKey:@"aid"], sig, [ControllerManager getSID]];
    NSLog(@"PetInfoAPI:%@", url);
    
//    return;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"照片详情页宠物信息：%@", load.dataDict);
//            PetInfoModel * model = [[PetInfoModel alloc] init];

            blockSelf.petDict = [load.dataDict objectForKey:@"data"];
            
            [blockSelf modifyBackPage];
//            ENDLOADING;
        }else{
//            LOADFAILED;
            NSLog(@"请求宠物数据失败");
        }
    }];
    [request release];
}

#pragma mark -
-(void)modifyUI
{
    
//    LOADING;
//    bigImageView.canClick = NO;
    [bigImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, [self.imageDict objectForKey:@"url"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if(error){
            NSLog(@"%@", error);
        }else{
            bigImageView.canClick = YES;
        }
        ENDLOADING;
        sv.hidden = NO;
        
        
        CGRect rect = bigImageView.frame;
        if(!error){
            
            float p = rect.size.width*image.size.height/image.size.width;
            rect.size.height = p;
            bigImageView.frame = rect;
        }
        
        
        //
        CGRect rect2 = desLabel.frame;
        if ([[self.imageDict objectForKey:@"cmt"] isKindOfClass:[NSString class]] && [[self.imageDict objectForKey:@"cmt"] length]>0) {
            desLabel.text = [self.imageDict objectForKey:@"cmt"];
            CGSize size;
            if ([MyControl isIOS7]) {
                size = [desLabel.text boundingRectWithSize:CGSizeMake(rect2.size.width, 100) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
            }else{
                size = [desLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(rect2.size.width, 100) lineBreakMode:1];
            }
            
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
            
            CGSize size;
            if ([MyControl isIOS7]) {
                size = [topicLabel.text boundingRectWithSize:CGSizeMake(rect3.size.width, 100) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
            }else{
                size = [topicLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(rect3.size.width, 100) lineBreakMode:1];
            }
//            CGSize size = [topicLabel.text boundingRectWithSize:CGSizeMake(rect3.size.width, 100) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
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
            
            CGSize size;
            if ([MyControl isIOS7]) {
                size = [timeLabel.text boundingRectWithSize:CGSizeMake(rect4.size.width, 100) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            }else{
                size = [timeLabel.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(rect4.size.width, 100) lineBreakMode:1];
            }
//            CGSize size = [timeLabel.text boundingRectWithSize:CGSizeMake(rect4.size.width, 100) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
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
        rect5.size.height = rect4.origin.y+rect4.size.height+10+20;
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
        
        //back
        CGRect rect11 = tv.frame;
        rect11.size.height = imageBgView2.frame.size.height-rect11.origin.y-15;
        tv.frame = rect11;
        
        CGRect rect22 = desTv.frame;
        rect22.size.height = imageBgView2.frame.size.height-rect22.origin.y-15;
        desTv.frame = rect22;
    }];
    
    
}
-(void)modifyBackPage
{
    [MyControl setImageForBtn:headBtn Tx:[self.petDict objectForKey:@"tx"] isPet:YES isRound:YES];
    
    [MyControl setImageForImageView:userTx Tx:[self.petDict objectForKey:@"u_tx"] isPet:NO isRound:YES];
    
    
    if ([[self.petDict objectForKey:@"gender"] intValue] == 1) {
        sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    
    petName.text = [self.petDict objectForKey:@"name"];
    petType.text = [ControllerManager returnCateNameWithType:[self.petDict objectForKey:@"type"]];
    userName.text = [NSString stringWithFormat:@"%@", [self.petDict objectForKey:@"u_name"]];
    
    
    UILabel * zan = (UILabel *)[imageBgView2 viewWithTag:300];
    if ([zan.text intValue]<[[self.imageDict objectForKey:@"likes"] intValue]) {
        zan.text = [self.imageDict objectForKey:@"likes"];
    }
    
    UILabel * gift = (UILabel *)[imageBgView2 viewWithTag:301];
    gift.text = [self.imageDict objectForKey:@"gifts"];
    
    UILabel * comment = (UILabel *)[imageBgView2 viewWithTag:302];
    comment.text = [NSString stringWithFormat:@"%d", self.usrIdArray.count];
    
    UILabel * share = (UILabel *)[imageBgView2 viewWithTag:303];
    share.text = [self.imageDict objectForKey:@"shares"];
    
    
    //照片详情页反过来以后，能不能默认先显示评论，如果评论为0显示礼物，礼物为0显示点赞，点赞也为0显示转发，都是0的话就还是显示评论~
    if (self.usrIdArray.count) {
        UIButton * btn = (UIButton *)[imageBgView2 viewWithTag:502];
        tv.hidden = YES;
        desTv.hidden = NO;
        [self backClick:btn];
    }else{
        tv.hidden = NO;
        desTv.hidden = YES;
        UIButton * btn = nil;
        if ([gift.text intValue]) {
            btn = (UIButton *)[imageBgView2 viewWithTag:501];
        }else if([zan.text intValue]){
            btn = (UIButton *)[imageBgView2 viewWithTag:500];
        }else if([share.text intValue]){
            btn = (UIButton *)[imageBgView2 viewWithTag:503];
        }else{
            tv.hidden = YES;
            desTv.hidden = NO;
            btn = (UIButton *)[imageBgView2 viewWithTag:502];
        }
        [self backClick:btn];
    }
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
    sv.hidden = YES;
    
    //加手势
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [sv addGestureRecognizer:swipeLeft];
    
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [sv addGestureRecognizer:swipeRight];
    
    //手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [sv addGestureRecognizer:tap];
    [tap release];
    
    imageBgView = [MyControl createViewWithFrame:CGRectMake(13, 30, self.view.frame.size.width-13*2, 400)];
    imageBgView.backgroundColor = [UIColor whiteColor];
    imageBgView.layer.borderWidth = 0.8;
    imageBgView.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
    [sv addSubview:imageBgView];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2:)];
    [imageBgView addGestureRecognizer:tap2];
    [tap2 release];
    
    bigImageView = [[ClickImage alloc] initWithFrame:CGRectMake(8, 5, imageBgView.frame.size.width-16, 300)];
//    bigImageView.canClick = YES;
    bigImageView.image = [UIImage imageNamed:@"water_white.png"];
//    bigImageView = [MyControl createImageViewWithFrame:CGRectMake(8, 5, imageBgView.frame.size.width-16, 300) ImageName:@""];
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
    
    //加手势
    swipeLeft2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft2.direction = UISwipeGestureRecognizerDirectionLeft;
    [sv2 addGestureRecognizer:swipeLeft2];
    
    swipeRight2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeLeft2.direction = UISwipeGestureRecognizerDirectionLeft;
    [sv2 addGestureRecognizer:swipeRight2];
    
//    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//    [sv2 addGestureRecognizer:tap3];
//    [tap3 release];
    
    imageBgView2 = [MyControl createViewWithFrame:CGRectMake(13, 30, self.view.frame.size.width-13*2, 350)];
    imageBgView2.backgroundColor = [UIColor whiteColor];
    imageBgView2.layer.borderWidth = 0.8;
    imageBgView2.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
    [sv2 addSubview:imageBgView2];
    
//    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2:)];
//    [imageBgView2 addGestureRecognizer:tap4];
//    [tap4 release];
    
    headBtn = [MyControl createButtonWithFrame:CGRectMake(5, 12, 46, 46) ImageName:@"defaultPetHead.png" Target:self Action:@selector(headBtnClick) Title:nil];
    headBtn.layer.cornerRadius = headBtn.frame.size.width/2.0;
    headBtn.layer.masksToBounds = YES;
    [imageBgView2 addSubview:headBtn];
    
    sex = [MyControl createImageViewWithFrame:CGRectMake(55, 15, 13, 13) ImageName:@"man.png"];
    [imageBgView2 addSubview:sex];
    
    petName = [MyControl createLabelWithFrame:CGRectMake(sex.frame.origin.x+15, 15, 200, 15) Font:13 Text:@""];
    petName.textColor = [ControllerManager colorWithHexString:@"565656"];
    [imageBgView2 addSubview:petName];
    
    petType = [MyControl createLabelWithFrame:CGRectMake(sex.frame.origin.x, 36, 100, 15) Font:11 Text:@""];
    petType.textColor = GRAY;
    [imageBgView2 addSubview:petType];
    
    userTx = [MyControl createImageViewWithFrame:CGRectMake(imageBgView2.frame.size.width-20-13, 32, 20, 20) ImageName:@"defaultUserHead.png"];
    userTx.layer.cornerRadius = 10;
    userTx.layer.masksToBounds = YES;
    userTx.contentMode = UIViewContentModeScaleAspectFill;
    [imageBgView2 addSubview:userTx];
    
    userName = [MyControl createLabelWithFrame:CGRectMake(userTx.frame.origin.x-150, 36, 150, 15) Font:11 Text:@""];
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
        
        UILabel * numLabel = [MyControl createLabelWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width+5, btn.frame.origin.y, space2-5, btn.frame.size.height) Font:13 Text:@"0"];
        numLabel.textColor = GRAY;
        [imageBgView2 addSubview:numLabel];
        numLabel.tag = 300+i;
        
        UIButton * btn2 = [MyControl createButtonWithFrame:CGRectMake(20+i*(space2+23.5), line.frame.origin.y+15, 23.5+space2-5, 22) ImageName:@"" Target:self Action:@selector(backClick:) Title:nil];
        [imageBgView2 addSubview:btn2];
        btn2.tag = 500+i;
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
    
//    UITapGestureRecognizer * tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2:)];
//    [tv addGestureRecognizer:tap5];
//    [tap5 release];
    
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
    [self createBottom];
//    bottomBgView = [MyControl createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height-47, self.view.frame.size.width, 47) ImageName:@""];
//    bottomBgView.image = [[UIImage imageNamed:@"front_bottomBg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
//    [bgView addSubview:bottomBgView];
    
    //
    
    //63/2 60/2
    //左右间隔20 中间间隔(width-40-5*31.5)/4
//    float space = (self.view.frame.size.width-40-5*31.5)/4;
//    NSArray * imageArray = @[@"front_zan.png", @"front_gift.png", @"front_comment.png", @"front_share.png", @"front_more.png"];
//    for (int i=0; i<imageArray.count; i++) {
//        UIButton * btn = [MyControl createButtonWithFrame:CGRectMake(20+i*(space+31.5), 9, 31.5, 30) ImageName:imageArray[i] Target:self Action:@selector(bottomClick:) Title:nil];
//        [bottomBgView addSubview:btn];
//        btn.tag = 100+i;
//    }
    
//    if (self.isFromRandom) {
//        [bigImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, self.imageURL]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            if(error){
//                NSLog(@"%@", error);
//            }else{
//                bigImageView.canClick = YES;
//            }
//            ENDLOADING;
//            sv.hidden = NO;
//            
//            
//            CGRect rect = bigImageView.frame;
//            if(!error){
//                
//                float p = rect.size.width*image.size.height/image.size.width;
//                rect.size.height = p;
//                bigImageView.frame = rect;
//            }
//            
//            
//            //
//            CGRect rect2 = desLabel.frame;
//            if ([self.imageCmt isKindOfClass:[NSString class]] && [self.imageCmt length]>0) {
//                desLabel.text = self.imageCmt;
//                CGSize size;
//                if ([MyControl isIOS7]) {
//                    size = [desLabel.text boundingRectWithSize:CGSizeMake(rect2.size.width, 100) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
//                }else{
//                    size = [desLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(rect2.size.width, 100) lineBreakMode:1];
//                }
//                
//                rect2.size.height = size.height;
//                rect2.origin.y = rect.origin.y+rect.size
//                .height+10;
//                desLabel.frame = rect2;
//            }else{
//                rect2.size.height = 0;
//                rect2.origin.y = rect.origin.y+rect.size
//                .height+10;
//                desLabel.frame = rect2;
//            }
//            
//            CGRect rect5 = imageBgView.frame;
//            rect5.size.height = rect2.origin.y+rect2.size.height+10+20;
//            imageBgView.frame = rect5;
//            
//            sv.contentSize = CGSizeMake(sv.frame.size.width, rect5.origin.y + rect5.size.height+50);
//            
//            sv2.contentSize = CGSizeMake(sv.frame.size.width, rect5.origin.y + rect5.size.height+50);
//            
//            CGRect image2Rect = imageBgView2.frame;
//            if(imageBgView.frame.size.height>350){
//                image2Rect.size.height = rect5.size.height;
//            }else{
//                image2Rect.size.height = 350;
//            }
//            imageBgView2.frame = image2Rect;
//        }];
//    }
}
#pragma mark -
-(void)createBottom
{
    UIView * bottomBg = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    [bgView addSubview:bottomBg];
    
    NSArray * selectedArray = @[@"front_zan_select", @"front_gift_select", @"front_comment_select", @"front_more_select"];
    NSArray * unSelectedArray = @[@"front_zan_unSelect", @"front_gift_unSelect", @"front_comment_unSelect", @"front_more_unSelect"];
    for (int i=0; i<selectedArray.count; i++) {
        UIImageView * halfBall = [MyControl createImageViewWithFrame:CGRectMake(i*(self.view.frame.size.width/4.0), bottomBg.frame.size.height-50, self.view.frame.size.width/4.0, 50) ImageName:@"food_bottom_halfBall.png"];
        [bottomBg addSubview:halfBall];
        
        UIButton * ballBtn = [MyControl createButtonWithFrame:CGRectMake(halfBall.frame.origin.x+halfBall.frame.size.width/2.0-42.5/2.0, 2, 85/2.0, 94/2.0) ImageName:unSelectedArray[i] Target:self Action:@selector(ballBtnClick:) Title:nil];
        ballBtn.tag = 100+i;
        
        [ballBtn setBackgroundImage:[UIImage imageNamed:selectedArray[i]] forState:UIControlStateHighlighted];
        [bottomBg addSubview:ballBtn];
        if (i == 0) {
            [ballBtn setBackgroundImage:[UIImage imageNamed:selectedArray[i]] forState:UIControlStateSelected];
        }else{
            [ballBtn setBackgroundImage:[UIImage imageNamed:selectedArray[i]] forState:UIControlStateHighlighted];
        }
    }
}
-(void)ballBtnClick:(UIButton *)btn
{
    [self ballAnimation:btn];
    
//    if (![[USER objectForKey:@"isSuccess"] intValue] && btn.tag == 100) {
//        ShowAlertView;
//        return;
//    }
    
//    for (int i=0; i<4; i++) {
//        UIButton * button = (UIButton *)[self.view viewWithTag:100+i];
//        button.selected = NO;
//    }
//    btn.selected = YES;
    int a = btn.tag-100;
    if (a == 0) {
        //zan
        [self zanBtnClick:btn];
    }else if (a == 1) {
        //gift
        if (![ControllerManager getIsSuccess]) {
            //提示注册
            ShowAlertView;
            return;
        }
        
        if(!([[self.imageDict objectForKey:@"aid"] isKindOfClass:[NSString class]] && [[self.imageDict objectForKey:@"aid"] length])){
            [MyControl popAlertWithView:self.view Msg:@"网络异常"];
            return;
        }
        
        SendGiftViewController * vc = [[SendGiftViewController alloc] init];
        vc.receiver_aid = [self.imageDict objectForKey:@"aid"];
        vc.receiver_name = [self.petDict objectForKey:@"name"];
        vc.receiver_img_id = [self.imageDict objectForKey:@"img_id"];
        vc.hasSendGift = ^(NSString * itemId){
            NSLog(@"赠送礼物给默认宠物成功!");
            
            UserInfoModel * model = [[UserInfoModel alloc] init];
            model.name = [USER objectForKey:@"name"];
            model.tx = [USER objectForKey:@"tx"];
            model.usr_id = [USER objectForKey:@"usr_id"];
            [self.sendersArray insertObject:model atIndex:0];
            [model release];
            
            UILabel * label = (UILabel *)[imageBgView2 viewWithTag:301];
            label.text = [NSString stringWithFormat:@"%d", self.sendersArray.count];
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
    }else if (a == 2) {
        //comment
        isReply = NO;
        [self commentClick];
    }else if (a == 3) {
        //more
        NSLog(@"More");
        if (!isMoreCreated) {
            //create more
            isMoreCreated = YES;
            [self createMore];
        }
        //show more
        menuBgBtn.hidden = NO;
        CGRect rect = moreView.frame;
        rect.origin.y -= rect.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            moreView.frame = rect;
            menuBgBtn.alpha = 0.6;
        }];
//        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"更多" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享", @"私信", @"举报此照", nil];
//        [sheet showInView:self.view];
//        sheet.tag = 401;
//        [sheet release];
    }

}

//气泡动画
-(void)ballAnimation:(UIView *)view
{
    CGRect rect = view.frame;
    [UIView animateWithDuration:0.1 animations:^{
        view.frame = CGRectMake(rect.origin.x-rect.size.width*0.1, rect.origin.y, rect.size.width*1.2, rect.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            view.frame = rect;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                view.frame = CGRectMake(rect.origin.x, rect.origin.y-rect.size.height*0.1, rect.size.width, rect.size.height*1.2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    view.frame = rect;
                }];
            }];
        }];
    }];
}
#pragma mark -
-(void)tap:(UIGestureRecognizer *)tap
{
    NSLog(@"tap");
    [self closeClick];
}
-(void)tap2:(UIGestureRecognizer *)tap
{
    NSLog(@"tap2");
}
#pragma mark - 
-(void)jumpToUserClick
{
    __block UserCardViewController * vc = [[UserCardViewController alloc] init];
    vc.usr_id = [self.petDict objectForKey:@"master_id"];
//    [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
//    __block FrontImageDetailViewController * blockSelf = self;
    vc.close = ^(){
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    };
    [vc release];
//    UserInfoViewController * vc = [[UserInfoViewController alloc] init];
//    vc.usr_id = [self.petDict objectForKey:@"master_id"];
//    [self presentViewController:vc animated:YES completion:nil];
//    [vc release];
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
                    btn.selected = YES;
                    int a = [[[load.dataDict objectForKey:@"data"] objectForKey:@"gold"] intValue];
                    if (a) {
                        [ControllerManager HUDImageIcon:@"gold.png" showView:self.view yOffset:0 Number:a];
                        [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"gold"] intValue]+a] forKey:@"gold"];
                    }
                    
                    UserInfoModel * model = [[UserInfoModel alloc] init];
                    model.name = [USER objectForKey:@"name"];
                    model.tx = [USER objectForKey:@"tx"];
                    model.usr_id = [USER objectForKey:@"usr_id"];
                    [self.likersArray insertObject:model atIndex:0];
                    [model release];
//                    [self.likerIdArray insertObject:[USER objectForKey:@"usr_id"] atIndex:0];
//                    [self.likerTxArray insertObject:[USER objectForKey:@"tx"] atIndex:0];
                    UILabel * label = (UILabel *)[imageBgView2 viewWithTag:300];
                    NSLog(@"%@", label.text);
                    label.text = [NSString stringWithFormat:@"%d", [label.text intValue]+1];
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
        vc.receiver_img_id = [self.imageDict objectForKey:@"img_id"];
        vc.hasSendGift = ^(NSString * itemId){
            NSLog(@"赠送礼物给默认宠物成功!");
            
            UserInfoModel * model = [[UserInfoModel alloc] init];
            model.name = [USER objectForKey:@"name"];
            model.tx = [USER objectForKey:@"tx"];
            model.usr_id = [USER objectForKey:@"usr_id"];
            [self.sendersArray insertObject:model atIndex:0];
            [model release];
            
            UILabel * label = (UILabel *)[imageBgView2 viewWithTag:301];
            label.text = [NSString stringWithFormat:@"%d", self.sendersArray.count];
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
        NSLog(@"More");
        if (!isMoreCreated) {
            //create more
            isMoreCreated = YES;
            [self createMore];
        }
        //show more
        menuBgBtn.hidden = NO;
        CGRect rect = moreView.frame;
        rect.origin.y -= rect.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            moreView.frame = rect;
            menuBgBtn.alpha = 0.6;
        }];
//        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友", @"朋友圈", @"微博", nil];
//        [sheet showInView:self.view];
//        sheet.tag = 400;
//        [sheet release];
    }else if(btn.tag == 104){
        NSLog(@"More");
        if (!isMoreCreated) {
            //create more
            isMoreCreated = YES;
            [self createMore];
        }
        //show more
        menuBgBtn.hidden = NO;
        CGRect rect = moreView.frame;
        rect.origin.y -= rect.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            moreView.frame = rect;
            menuBgBtn.alpha = 0.6;
        }];
//        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"更多" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"私信", @"举报此照", nil];
//        [sheet showInView:self.view];
//        sheet.tag = 401;
//        [sheet release];
    }
}
#pragma mark - 创建更多视图
-(void)createMore
{
    menuBgBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:nil];
    menuBgBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:menuBgBtn];
    menuBgBtn.alpha = 0;
    menuBgBtn.hidden = YES;
    
    // 318*234
    moreView = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 180)];
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
    float spe = (self.view.frame.size.width-80-42*3)/2.0;
    for(int i=0;i<3;i++){
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(40+i*(spe+42), 33, 42, 42) ImageName:arr[i] Target:self Action:@selector(shareClick:) Title:nil];
        button.tag = 400+i;
        [moreView addSubview:button];
        
        CGRect rect = button.frame;
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(rect.origin.x-10, rect.origin.y+rect.size.height+5, rect.size.width+20, 15) Font:12 Text:arr2[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        //        label.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [moreView addSubview:label];
    }
    
    UIView * grayLine1 = [MyControl createViewWithFrame:CGRectMake(0, 105, 320, 2)];
    grayLine1.backgroundColor = [ControllerManager colorWithHexString:@"e3e3e3"];
    [moreView addSubview:grayLine1];
    
    float spe2 = (self.view.frame.size.width-20*2-72*3)/2.0;
    UIButton * reportBtn = [MyControl createButtonWithFrame:CGRectMake(20, grayLine1.frame.origin.y+15, 72, 34) ImageName:@"front_report.png" Target:self Action:@selector(reportBtnClick) Title:nil];
//    reportBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    reportBtn.backgroundColor = [UIColor lightGrayColor];
//    reportBtn.layer.cornerRadius = 5;
//    reportBtn.layer.masksToBounds = YES;
//    reportBtn.showsTouchWhenHighlighted = YES;
    [moreView addSubview:reportBtn];
    
    UIButton * addBtn = [MyControl createButtonWithFrame:CGRectMake(reportBtn.frame.origin.x+reportBtn.frame.size.width+spe2, grayLine1.frame.origin.y+15, 72, 34) ImageName:@"front_p.png" Target:self Action:@selector(addBtnClick) Title:nil];
//    addBtn.layer.cornerRadius = 8;
//    addBtn.layer.masksToBounds = YES;
//    [addBtn setBackgroundImage:[[UIImage imageNamed:@"more_greenBg2.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:25] forState:UIControlStateNormal];
//    [addBtn setBackgroundImage:[[UIImage imageNamed:@"more_orangeBg2.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:25] forState:UIControlStateSelected];
//    [addBtn setTitle:@"捧ing" forState:UIControlStateSelected];
//    addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [moreView addSubview:addBtn];
    
    UIButton * msgBtn = [MyControl createButtonWithFrame:CGRectMake(addBtn.frame.origin.x+addBtn.frame.size.width+spe2, grayLine1.frame.origin.y+15, 72, 34) ImageName:@"front_msg.png" Target:self Action:@selector(msgBtnClick) Title:nil];
//    msgBtn.layer.cornerRadius = 8;
//    msgBtn.layer.masksToBounds = YES;
//    [msgBtn setBackgroundImage:[[UIImage imageNamed:@"more_greenBg2.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:25] forState:UIControlStateNormal];
//    [msgBtn setBackgroundImage:[[UIImage imageNamed:@"more_orangeBg2.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:25] forState:UIControlStateSelected];
//    [msgBtn setTitle:@"捧ing" forState:UIControlStateSelected];
//    msgBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [moreView addSubview:msgBtn];
}
#pragma mark -
-(void)reportBtnClick
{
    NSLog(@"举报");
    [self cancelBtnClick];
    [self reportImage];
}
-(void)addBtnClick
{
    NSLog(@"pTA");
    [self cancelBtnClick];
    [self pPet];
}
-(void)msgBtnClick
{
    NSLog(@"私信");
    [self cancelBtnClick];
    [self sendMessage];
}

#pragma mark - 分享截图
//-(void)shareClick:(UIButton *)button
//{
//    [self cancelBtnClick];
//    
//    UIImage * screenshotImage = [MyControl imageWithView:tv];
//    
//    int a = button.tag-400;
//    
//    if (a == 0) {
//        NSLog(@"微信");
//        //强制分享图片
//        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:screenshotImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
//                //                StartLoading;
//                //                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
//            }else{
//                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
//                //                StartLoading;
//                //                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
//            }
//            
//        }];
//    }else if(a == 1){
//        NSLog(@"朋友圈");
//        //强制分享图片
//        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:screenshotImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
//                //                StartLoading;
//                //                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
//            }else{
//                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
//                //                StartLoading;
//                //                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
//            }
//            
//        }];
//    }else{
//        NSLog(@"微博");
//        NSString * str = @"雷达报告发现一只萌宠，火速围观！http://home4pet.imengstar.com/（分享自@宠物星球社交应用）";
//        //        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:screenshotImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//        //            if (response.responseCode == UMSResponseCodeSuccess) {
//        //                NSLog(@"分享成功！");
//        //                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
//        //                //                StartLoading;
//        //                //                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
//        //            }else{
//        //                NSLog(@"失败原因：%@", response);
//        //                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
//        //                //                StartLoading;
//        //                //                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
//        //            }
//        //
//        //        }];
//        
//        BOOL oauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
//        NSLog(@"%d", oauth);
//        if (oauth) {
//            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
//                [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:screenshotImage socialUIDelegate:self];
//                //设置分享内容和回调对象
//                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//            }];
//        }else{
//            [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:screenshotImage socialUIDelegate:self];
//            //设置分享内容和回调对象
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//        }
//    }
//}
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
        commentBgView.frame = CGRectMake(0, originalY, 320, 40);
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
    originalY = commentBgView.frame.origin.y;
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
    if(commentTextField.text == nil || commentTextField.text.length == 0){
//        [MyControl popAlertWithView:self.view Msg:@"内容为空"];
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
            int gold = [[[dict objectForKey:@"data"] objectForKey:@"gold"] intValue];
            int addExp = [[[dict objectForKey:@"data"] objectForKey:@"exp"] intValue];
            if (addExp>0) {
                [USER setObject:[NSString stringWithFormat:@"%d", exp+addExp] forKey:@"exp"];
//                [ControllerManager HUDImageIcon:@"Star.png" showView:self.view.window yOffset:0 Number:addExp];
            }
            if (gold>0) {
                [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"gold"] intValue]+gold] forKey:@"gold"];
                [ControllerManager HUDImageIcon:@"gold.png" showView:self.view.window yOffset:0 Number:gold];
            }
        }
        
        [commentTextField resignFirstResponder];
        
        //添加评论
        NSLog(@"%@", [USER objectForKey:@"usr_id"]);
        [self.cmtTxArray insertObject:[USER objectForKey:@"tx"] atIndex:0];
//        UserInfoModel * model = [[UserInfoModel alloc] init];
//        model.tx = [USER objectForKey:@"tx"];
//        [self.commentersArray insertObject:model atIndex:0];
//        [model release];
        
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
//        [MyControl popAlertWithView:self.view Msg:@"评论成功"];
        //
        UILabel * label = (UILabel *)[imageBgView2 viewWithTag:302];
        label.text = [NSString stringWithFormat:@"%d", self.nameArray.count];
        
//        [commentTextField removeFromSuperview];
        //    if (!([self.likerTxArray isKindOfClass:[NSNull class]] || self.likerTxArray.count == 0)) {
        //        [txsView removeFromSuperview];
        //    }
        [desTv reloadData];
        
        //在正面翻到背面，并切到评论列，在背面直接切
        if(!isBackSide){
           [self swipeLeft:swipeLeft];
        }
        if (triangleIndex != 2) {
            UIButton * tempBtn = (UIButton *)[imageBgView2 viewWithTag:502];
            [self backClick:tempBtn];
        }
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
            commentBgView.frame = CGRectMake(0, self.view.frame.size.height-height-commentBgView.frame.size.height, self.view.frame.size.width, commentBgView.frame.size.height);
            originalY = commentBgView.frame.origin.y;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            commentBgView.frame = CGRectMake(0, self.view.frame.size.height-height-commentBgView.frame.size.height, self.view.frame.size.width, commentBgView.frame.size.height);
            originalY = commentBgView.frame.origin.y;
        }];
    }
}
-(void)bgButtonClick
{
    [commentTextField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        commentBgView.frame = CGRectMake(-self.view.frame.size.width, originalY, 320, 40);
        bgButton.alpha = 0;
    } completion:^(BOOL finished) {
        bgButton.hidden = YES;
    }];
}
#pragma mark -
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSLog(@"%d", buttonIndex);
//    if (actionSheet.tag == 401) {
////        if (buttonIndex == 0) {
////            //查看大图
////            LargeImage * large = [[LargeImage alloc] initWithFrame:[UIScreen mainScreen].bounds];
////            [self.view addSubview:large];
////            [large modifyUIWithImage:bigImageView.image];
////            [large release];
////        }else
//        if (buttonIndex == 0) {
//            //分享
//            UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友", @"朋友圈", @"微博", nil];
//            [sheet showInView:self.view];
//            sheet.tag = 400;
//            [sheet release];
//        }else if (buttonIndex == 1) {
//            //私信
//            [self sendMessage];
//        }else if(buttonIndex == 2){
//            //举报此照
//            [self reportImage];
//        }
//    }else if(actionSheet.tag == 400){
////        [self shareClick:buttonIndex];
////        if (buttonIndex == 0) {
////            //微信好友
////        }else if (buttonIndex == 1) {
////            //朋友圈
////        }else if (buttonIndex == 2) {
////            //微博
////        }
//    }
//}
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
    if([[self.petDict objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]){
        [MyControl popAlertWithView:self.view Msg:@"不能给自己发私信哦~"];
        return;
    }
    if (!([[self.petDict objectForKey:@"u_name"] isKindOfClass:[NSString class]] && [[self.petDict objectForKey:@"u_name"] length])) {
        [MyControl popAlertWithView:self.view Msg:@"网络异常"];
        return;
    }
    
    ChatViewController * chatController = [[ChatViewController alloc] initWithChatter:[self.petDict objectForKey:@"master_id"] isGroup:NO];
    chatController.isFromCard = YES;
    chatController.nickName = [USER objectForKey:@"name"];
    chatController.tx = [USER objectForKey:@"tx"];
    chatController.other_nickName = [self.petDict objectForKey:@"u_name"];
    chatController.other_tx = [self.petDict objectForKey:@"u_tx"];
    [self presentViewController:chatController animated:YES completion:nil];
    [chatController release];
}
#pragma mark - 捧TA
-(void)pPet
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        return;
    }
    if([[self.petDict objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]){
        [MyControl popAlertWithView:self.view Msg:@"你已经捧TA了~"];
        return;
    }
    //判断是否捧过
    NSString * code = [NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            ENDLOADING;
            NSLog(@"%@", load.dataDict);
//            [self.petsDataArray removeAllObjects];
            
            NSArray * array = [load.dataDict objectForKey:@"data"];
            BOOL isP = NO;
            for(int i=0; i<array.count; i++){
                NSDictionary * dict = array[i];
                if ([[dict objectForKey:@"aid"]isEqualToString:[self.petDict objectForKey:@"aid"]]) {
                    isP = YES;
                    break;
                }
            }
            
            if (isP) {
                [MyControl popAlertWithView:self.view Msg:@"你已经捧TA了~"];
                return;
            }else{
                Alert_oneBtnView * oneBtn = [[Alert_oneBtnView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                if (array.count >= 10) {
                    int cost = array.count*5;
                    if (cost>100) {
                        cost = 100;
                    }
                    if(cost>[[USER objectForKey:@"gold"] intValue]){
                        //余额不足
                        if([[USER objectForKey:@"confVersion"] isEqualToString:[USER objectForKey:@"versionKey"]]){
                            //审核
                            [MyControl popAlertWithView:self.view Msg:@"钱包君告急！挣够金币再来捧萌星吧~"];
                        }else{
                            [ControllerManager addAlertWith:self Cost:cost SubType:1];
                        }

                        return;
                    }
                    oneBtn.type = 2;
                    oneBtn.petsNum = array.count;
                    [oneBtn makeUI];
                    [[UIApplication sharedApplication].keyWindow addSubview:oneBtn];
                    [oneBtn release];
                }else{
                    oneBtn.type = 2;
                    oneBtn.petsNum = array.count;
                    [oneBtn makeUI];
                    [[UIApplication sharedApplication].keyWindow addSubview:oneBtn];
                    [oneBtn release];
                }
                oneBtn.jump = ^(){
                    //                    [MyControl startLoadingWithStatus:@"加入中..."];
                    LOADING;
                    NSString *joinPetCricleSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", [self.petDict objectForKey:@"aid"]]];
                    NSString *joinPetCricleString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",JOINPETCRICLEAPI,[self.petDict objectForKey:@"aid"],joinPetCricleSig,[ControllerManager getSID]];
                    NSLog(@"加入圈子:%@",joinPetCricleString);
                    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:joinPetCricleString Block:^(BOOL isFinish, httpDownloadBlock *load) {
                        if (isFinish) {
                            NSLog(@"加入成功数据：%@",load.dataDict);
                            if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                                //
//                                pBtn.selected = YES;
//                                UILabel * tempLabel = (UILabel *)[headerView viewWithTag:101];
//                                tempLabel.text = [NSString stringWithFormat:@"%d", [tempLabel.text intValue]+1];
                                if (array.count>=10) {
                                    int cost = array.count*5;
                                    if (cost>100) {
                                        [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"gold"] intValue]-100] forKey:@"gold"];
                                    }else{
                                        [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"gold"] intValue]-cost] forKey:@"gold"];
                                    }
                                    
                                }
                                
                            }
                            //                            [MyControl loadingSuccessWithContent:@"加入成功" afterDelay:0.5f];
                            ENDLOADING;
                            //捧Ta成功界面
                            NoCloseAlert * noClose = [[NoCloseAlert alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                            noClose.confirm = ^(){};
                            [self.view addSubview:noClose];
                            NSString * percent = [NSString stringWithFormat:@"%@", [[load.dataDict objectForKey:@"data"] objectForKey:@"percent"]];
                            [noClose configUIWithTx:[self.petDict objectForKey:@"tx"] Name:[self.petDict objectForKey:@"name"] Percent:percent];
                            [UIView animateWithDuration:0.3 animations:^{
                                noClose.alpha = 1;
                            }];
                        }else{
                            LOADFAILED;
                            NSLog(@"加入国家失败");
                        }
                    }];
                    [request release];
                };
            }
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}

-(BOOL)isOver24Hour
{
    NSDate * date = [NSDate date];
    //当前时间戳
    NSString * stamp = [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    //t为时间差
    //24小时为期限

    //当前时间戳-时间戳 < 24h 才返回NO,说明未超过24小时
    if ([stamp intValue]-[[self.imageDict objectForKey:@"create_time"] intValue] < 24*60*60) {
        return NO;
    }else{
        return YES;
    }
}
#pragma mark - 分享截图
-(void)shareClick:(UIButton *)btn
{
    int index = btn.tag;
    [MobClick event:@"photo_share"];
    
    //判断图片发布时间是否超过24小时
    BOOL isOvertime = [self isOver24Hour];
    
    if (index == 400) {
        NSLog(@"微信");
        //强制分享图片
//        [self.imageDict objectForKey:@"cmt"]
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@", WEBBEGFOODAPI, self.img_id];
        
        NSString * str = nil;
        if(is_food && !isOvertime){
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"轻轻一点，免费赏粮！我的口粮全靠你啦~";
            if ([[self.imageDict objectForKey:@"cmt"] length]) {
                str = [self.imageDict objectForKey:@"cmt"];
            }else{
                str = @"看在我这么努力卖萌的份上快来宠宠我！免费送我点口粮好不好？";
            }
        }else{
            [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"我是%@，你有没有爱上我？", [self.petDict objectForKey:@"name"]];
            if ([[self.imageDict objectForKey:@"cmt"] length]) {
                str = [self.imageDict objectForKey:@"cmt"];
            }else{
                str = @"这是我最新的美照哦~~打滚儿求表扬~~";
            }
        }
       

        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:str image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
    }else if(index == 401){
        NSLog(@"朋友圈");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@", WEBBEGFOODAPI, self.img_id];
        
        NSString * str = nil;
        if ([[self.imageDict objectForKey:@"cmt"] length]) {
            str = [self.imageDict objectForKey:@"cmt"];
         }else{
            if (is_food && !isOvertime) {
                str = @"看在我这么努力卖萌的份上快来宠宠我！免费送我点口粮好不好？";
            }else{
                str = @"这是我最新的美照哦~~打滚儿求表扬~~";
            }
            
        }
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = str;
//        if(isFood){
//            [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"轻轻一点，免费赏粮！我的口粮全靠你啦~";
//            if ([[self.imageDict objectForKey:@"cmt"] length]) {
//                str = [self.imageDict objectForKey:@"cmt"];
//            }else{
//                str = @"看在我这么努力卖萌的份上快来宠宠我！免费送我点口粮好不好？";
//            }
//        }else{
//            [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"我是%@，你有没有爱上我？", [self.petDict objectForKey:@"name"]];
//            if ([[self.imageDict objectForKey:@"cmt"] length]) {
//                str = [self.imageDict objectForKey:@"cmt"];
//            }else{
//                str = @"这是我最新的美照哦~~打滚儿求表扬~~";
//            }
//        }
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
    }else if(index == 402){
        NSLog(@"微博");
        NSString * str = nil;
        if(is_food && !isOvertime){
            if ([[self.imageDict objectForKey:@"cmt"] length]) {
                str = [self.imageDict objectForKey:@"cmt"];
            }else{
                str = @"看在我这么努力卖萌的份上快来宠宠我！免费送我点口粮好不好？";
            }
        }else{
            if ([[self.imageDict objectForKey:@"cmt"] length]) {
                str = [self.imageDict objectForKey:@"cmt"];
            }else{
                str = @"这是我最新的美照哦~~打滚儿求表扬~~";
            }
        }
        
        NSString * last = [NSString stringWithFormat:@"%@%@（分享自@宠物星球社交应用）", WEBBEGFOODAPI, self.img_id];
        if([[self.imageDict objectForKey:@"topic_name"] isKindOfClass:[NSString class]] && [[self.imageDict objectForKey:@"topic_name"] length]){
            str = [NSString stringWithFormat:@"%@ #%@# %@", str, [self.imageDict objectForKey:@"topic_name"], last];
        }else{
            str = [NSString stringWithFormat:@"%@%@", str, last];
        }
        
        BOOL oauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
        NSLog(@"%d", oauth);
        if (oauth) {
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:bigImageView.image socialUIDelegate:self];
                //设置分享内容和回调对象
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            }];
        }else{
            [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:bigImageView.image socialUIDelegate:self];
            //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
        
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//                [self loadShareAPI];
////                shareNum.text = [NSString stringWithFormat:@"%d", [shareNum.text intValue]+1];
//                
//                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
////                StartLoading;
////                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
//            }else{
//                NSLog(@"失败原因：%@", response);
//
//                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
////                StartLoading;
////                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
//            }
//
//        }];
    }
}
#pragma mark -
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
//    NSLog(@"%@", response);
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享成功！");
        [self loadShareAPI];
        [MyControl popAlertWithView:self.view Msg:@"分享成功"];
    }else{
        NSLog(@"失败原因：%@", response);
        
        [MyControl popAlertWithView:self.view Msg:@"分享失败"];
    }
}
#pragma mark - 分享API
-(void)loadShareAPI
{
    if (is_food == 1) {
        [MobClick event:@"food_share_suc"];
    }else if (is_food == 2) {
        [MobClick event:@"topic1_share_suc"];
    }else if (is_food == 3) {
        [MobClick event:@"topic2_share_suc"];
    }
    
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@dog&cat", self.img_id]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", SHAREIMAGEAPI, self.img_id, sig, [ControllerManager getSID]];
    NSLog(@"shareUrl:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if(![[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                return;
            }
            UserInfoModel * model = [[UserInfoModel alloc] init];
            model.name = [USER objectForKey:@"name"];
            model.tx = [USER objectForKey:@"tx"];
            model.usr_id = [USER objectForKey:@"usr_id"];
            [self.sharersArray insertObject:model atIndex:0];
            [model release];
            
            UILabel * label = (UILabel *)[imageBgView2 viewWithTag:303];
            label.text = [NSString stringWithFormat:@"%d", self.sharersArray.count];
            if (triangleIndex == 3) {
                [tv reloadData];
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
    __block FrontImageDetailViewController * blockSelf = self;
    
    int ori = triangleIndex;
    triangleIndex = btn.tag%100;
    
    UIButton * tempBtn = nil;
    if (btn.tag/100 == 2) {
        tempBtn = btn;
    }else if(btn.tag/100 == 5){
        tempBtn = (UIButton *)[imageBgView2 viewWithTag:200+triangleIndex];
        if (btn.tag == 500) {
            if (!isLoaded[0]) {
                isLoaded[0] = 1;
                [self loadLikersData];
            }else if(ori == triangleIndex){
                UIButton * zanBtn = (UIButton *)[self.view viewWithTag:100];
                [self bottomClick:zanBtn];
            }
        }else if (btn.tag == 501) {
            if (!isLoaded[1]) {
                isLoaded[1] = 1;
                [self loadSendersData];
            }else if(ori == triangleIndex){
                UIButton * giftBtn = (UIButton *)[self.view viewWithTag:101];
                [self bottomClick:giftBtn];
            }
        }else if (btn.tag == 502) {
            
            if (!isLoaded[2]) {
                isLoaded[2] = 1;
//                return;
                [self loadCommentersData];
            }else if(ori == triangleIndex){
                UIButton * cmtBtn = (UIButton *)[self.view viewWithTag:102];
                [self bottomClick:cmtBtn];
            }
        }else if (btn.tag == 503) {
            if (!isLoaded[3]) {
                isLoaded[3] = 1;
                if ([[self.imageDict objectForKey:@"sharers"] isKindOfClass:[NSString class]]) {
                    [self loadSharersData];
                }else{
                    isLoaded[3] = 1;
                }
            }else if(ori == triangleIndex){
                if (ori == triangleIndex) {
                    UIButton * shareBtn = (UIButton *)[self.view viewWithTag:103];
                    [self bottomClick:shareBtn];
                }
            }
        }
    }
    
    CGRect rect = triangle.frame;
    rect.origin.x = tempBtn.frame.origin.x+tempBtn.frame.size.width/2.0-rect.size.width/2.0;
    
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
    
    if (blockSelf->triangleIndex == 2) {
        blockSelf->desTv.hidden = NO;
        blockSelf->tv.hidden = YES;
        [blockSelf->desTv reloadData];
    }else{
        blockSelf->desTv.hidden = YES;
        blockSelf->tv.hidden = NO;
        [blockSelf->tv reloadData];
    }
    
}
-(void)closeClick
{
    NSLog(@"close");
    isInThisController = NO;
    
//    [ControllerManager deleTabBarViewController:self];
//    __block FrontImageDetailViewController * blockSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
    }completion:^(BOOL finished) {
        [ControllerManager deleTabBarViewController:self];
    }];
}
-(void)headBtnClick
{
    PetMainViewController * vc = [[PetMainViewController alloc] init];
    vc.aid = [self.imageDict objectForKey:@"aid"];;
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (triangleIndex == 0) {
        return self.likersArray.count;
    }else if(triangleIndex == 1){
        return self.sendersArray.count;
    }else if(triangleIndex == 2){
//        NSLog(@"%d", self.usrIdArray.count);
        return self.usrIdArray.count;
    }else{
        return self.sharersArray.count;
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
        UserInfoModel * model = self.likersArray[indexPath.row];
        [cell configUI:model];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = 0;
        return cell;
    }else if(triangleIndex == 1){
        static NSString * cellID2 = @"ID2";
        BackImageDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if (!cell) {
            cell = [[[BackImageDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2] autorelease];
        }
        UserInfoModel * model = self.sendersArray[indexPath.row];
        [cell configUI:model];
        
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
        cell.reportBlock = ^(){
            ReportAlertView * report = [[ReportAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            report.AlertType = 2;
            [report makeUI];
            [self.view addSubview:report];
            [UIView animateWithDuration:0.2 animations:^{
                report.alpha = 1;
            }];
            report.confirmClick = ^(){
                [self reportImage];
//                [self cancelBtnClick2];
            };
        };
        
        float textWidth = [UIScreen mainScreen].bounds.size.width-13*2-10*2-40-10-35;
        float cellHeight = 0;
        
        CGSize size;
        if ([MyControl isIOS7]) {
            size = [self.bodyArray[indexPath.row] boundingRectWithSize:CGSizeMake(textWidth, 1000) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        }else{
            size = [self.bodyArray[indexPath.row] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(textWidth, 1000) lineBreakMode:1];
        }
//        CGSize size = [self.bodyArray[indexPath.row] boundingRectWithSize:CGSizeMake(textWidth, 100) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        if (size.height>15.0) {
            cellHeight = 53+size.height-15;
        }else{
            cellHeight = 53.0;
        }
//        NSLog(@"%f", cellHeight);
        [cell configUIWithName:self.nameArray[indexPath.row] Cmt:self.bodyArray[indexPath.row] Time:self.createTimeArray[indexPath.row] CellHeight:cellHeight textSize:size Tx:self.cmtTxArray[indexPath.row] isTest:isTest];
        return cell;
    }else{
        static NSString * cellID4 = @"ID4";
        BackImageDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID4];
        if (!cell) {
            cell = [[[BackImageDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID4] autorelease];
        }
        UserInfoModel * model = self.sharersArray[indexPath.row];
        [cell configUI:model];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = 0;
        return cell;
    }
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 53.0f;
    if (triangleIndex == 2) {
        float textWidth = [UIScreen mainScreen].bounds.size.width-13*2-10*2-40-10-35;
//        NSLog(@"%d--%@", indexPath.row, self.bodyArray[indexPath.row]);
        if (self.bodyArray[indexPath.row] == nil) {
            return 53.0;
        }
        
        CGSize size;
        if ([MyControl isIOS7]) {
            size = [self.bodyArray[indexPath.row] boundingRectWithSize:CGSizeMake(textWidth, 1000) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        }else{
            size = [self.bodyArray[indexPath.row] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(textWidth, 1000) lineBreakMode:1];
        }
//        CGSize size = [self.bodyArray[indexPath.row] boundingRectWithSize:CGSizeMake(textWidth, 100) options:1 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
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
    __block UserCardViewController * vc = [[UserCardViewController alloc] init];
    if (triangleIndex == 0) {
        vc.usr_id = [self.likersArray[indexPath.row] usr_id];
//        [self presentViewController:vc animated:YES completion:nil];
    }else if (triangleIndex == 1) {
        vc.usr_id = [self.sendersArray[indexPath.row] usr_id];
//        [self presentViewController:vc animated:YES completion:nil];
    }else if (triangleIndex == 2) {
        isReply = YES;
        replyRow = indexPath.row;
        [self commentClick];
//        vc.usr_id = self.usrIdArray[indexPath.row];
//        [self presentViewController:vc animated:YES completion:nil];
    }else{
        vc.usr_id = [self.sharersArray[indexPath.row] usr_id];
//        [self presentViewController:vc animated:YES completion:nil];
    }
    vc.close = ^(){
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    };
    if (triangleIndex != 2) {
        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
        [vc didMoveToParentViewController:self];
//        [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
    }
    
    [vc release];
}


#pragma mark -
-(void)swipeLeft:(UISwipeGestureRecognizer *)swipeLeft
{
    if (self.commentersArray.count && ![[USER objectForKey:@"guide_detail_back_comment"] intValue]) {
        [USER setObject:@"1" forKey:@"guide_detail_back_comment"];
        [self createGuide2];
    }
    
    NSLog(@"swipeLeft");
    if (imageNotExist) {
        [MyControl popAlertWithView:self.view  Msg:@"网络或数据异常"];
        return;
    }
    isBackSide = !isBackSide;
    if (isBackSide) {
        if(!isBackLoaded){
            isBackLoaded = YES;
//            [self loadPetData];
        }
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
    if (self.commentersArray.count && ![[USER objectForKey:@"guide_detail_back_comment"] intValue]) {
        [USER setObject:@"1" forKey:@"guide_detail_back_comment"];
        [self createGuide2];
    }
    
    NSLog(@"swipeRight");
    if (imageNotExist) {
        [MyControl popAlertWithView:self.view  Msg:@"网络或数据异常"];
        return;
    }
    isBackSide = !isBackSide;
    if (isBackSide) {
        if(!isBackLoaded){
            isBackLoaded = YES;
//            [self loadPetData];
        }
        
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
}

@end
