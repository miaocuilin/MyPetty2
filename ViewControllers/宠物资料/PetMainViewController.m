//
//  PetMainViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/25.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetMainViewController.h"
#import "PetMainCell.h"
#import "UserPetListModel.h"
#import "Alert_BegFoodViewController.h"
#import "RockViewController.h"
#import "SendGiftViewController.h"
#import "TouchViewController.h"
#import "PopularityListViewController.h"
#import "PetMain_Active_ViewController.h"
#import "PetMain_Fans_ViewController.h"
#import "PetMain_Photo_ViewController.h"
#import "PublishViewController.h"
#import "PetMain_Gift_ViewController.h"
#import "PetMain_Food_ViewController.h"
#import "ModifyPetOrUserInfoViewController.h"
#import "ChatViewController.h"

@interface PetMainViewController ()<UMSocialUIDelegate>

@end

@implementation PetMainViewController
-(void)dealloc{
    [super dealloc];
    headBlurImage.image = nil;
    [headBlurImage release];
}

-(void)createGuide
{
    guide = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"guide_petmain.png"];
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
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MobClick event:@"pet_homepage"];
    self.petsDataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self loadData];
    [self createTableView];
}
-(void)loadData
{
    LOADING;
    NSString *animalInfoSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",self.aid]];
    NSString *animalInfoAPI = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", ANIMALINFOAPI,self.aid,animalInfoSig, [ControllerManager getSID]];
    NSLog(@"萌星API:%@", animalInfoAPI);
    [[httpDownloadBlock alloc] initWithUrlStr:animalInfoAPI Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"宠物信息:%@", load.dataDict);
            if([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                self.model = [[PetInfoModel alloc] init];
                [self.model setValuesForKeysWithDictionary:[load.dataDict objectForKey:@"data"]];
                
                if ([self.model.master_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
                    isMyPet = YES;
                }
                [self modifyUI];
                if ([[USER objectForKey:@"isSuccess"] intValue]) {
                    if (isMyPet) {
                        pBtn.selected = YES;
                        ENDLOADING;
                    }else{
                        [self loadPetsData];
                    }
                    
                }else{
                    ENDLOADING;
                }
            }
        }else{
            LOADFAILED;
        }
    }];
}
-(void)loadPetsData
{
//    LOADING;
    NSString * code = [NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            [self.petsDataArray removeAllObjects];
            
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (NSDictionary * dict in array) {
                UserPetListModel * model = [[UserPetListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                if ([model.aid isEqualToString:self.aid]) {
                    pBtn.selected = YES;
                }
                [self.petsDataArray addObject:model];
                [model release];
            }
            ENDLOADING;
            [self modifyUI];
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
#pragma mark -
-(void)createTableView
{
    UIImageView * blurImage = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.png"];
    [self.view addSubview:blurImage];
    
    tv = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tv.showsVerticalScrollIndicator = NO;
    tv.separatorStyle = NO;
    tv.backgroundColor = [UIColor clearColor];
    tv.delegate = self;
    tv.dataSource = self;
    
    [self.view addSubview:tv];
    
    headerView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 590/2.0)];
    tv.tableHeaderView = headerView;
    
    headBlurImage = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headerView.frame.size.height) ImageName:@""];
    [headerView addSubview:headBlurImage];
    
    headCircle = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-102)/2.0, 64, 102, 102) ImageName:@"pet_bg_img.png"];
    [headerView addSubview:headCircle];
    
    pBtn = [MyControl createButtonWithFrame:CGRectMake(45, headCircle.frame.origin.y+35, 38, 38) ImageName:@"pet_raise_1.png" Target:self Action:@selector(pBtnClick:) Title:nil];
    [pBtn setBackgroundImage:[UIImage imageNamed:@"pet_raise_2.png"] forState:UIControlStateSelected];
    [headerView addSubview:pBtn];
    
    userHeadBtn = [MyControl createButtonWithFrame:CGRectMake(headerView.frame.size.width-45-38, headCircle.frame.origin.y+35, 38, 38) ImageName:@"defaultUserHead.png" Target:self Action:@selector(userHeadBtnClick) Title:nil];
    [headerView addSubview:userHeadBtn];
    
    nameLabel = [MyControl createLabelWithFrame:CGRectMake(0, headCircle.frame.origin.y+headCircle.frame.size.height, headerView.frame.size.width, 20) Font:15 Text:nil];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:nameLabel];
    
    sex = [MyControl createImageViewWithFrame:CGRectMake(headerView.frame.size.width/2.0, nameLabel.frame.origin.y+2.5, 15, 15) ImageName:@""];
    [headerView addSubview:sex];
    
    cateAndAgeLabel = [MyControl createLabelWithFrame:CGRectMake(0, nameLabel.frame.origin.y+nameLabel.frame.size.height, headerView.frame.size.width, 20) Font:13 Text:nil];
    cateAndAgeLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:cateAndAgeLabel];
    
    whiteBg = [MyControl createViewWithFrame:CGRectMake(10, cateAndAgeLabel.frame.origin.y+cateAndAgeLabel.frame.size.height+5, headerView.frame.size.width-20, 25)];
    whiteBg.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    whiteBg.layer.cornerRadius = 13;
    whiteBg.layer.masksToBounds = YES;
    [headerView addSubview:whiteBg];
    
    UIView * hLine = [MyControl createViewWithFrame:CGRectMake(15, whiteBg.frame.origin.y+whiteBg.frame.size.height+2, headerView.frame.size.width-30, 0.5)];
    hLine.backgroundColor = [ControllerManager colorWithHexString:@"e1e1e1"];
    [headerView addSubview:hLine];
    
    float spe = hLine.frame.size.width/3.0;
    
    UIView * vLine1 = [MyControl createViewWithFrame:CGRectMake(15+spe, hLine.frame.origin.y+hLine.frame.size.height, 0.5, headerView.frame.size.height-hLine.frame.origin.y)];
    vLine1.backgroundColor = [ControllerManager colorWithHexString:@"e1e1e1"];
    [headerView addSubview:vLine1];
    
    UIView * vLine2 = [MyControl createViewWithFrame:CGRectMake(15+spe*2, hLine.frame.origin.y+hLine.frame.size.height, 0.5, headerView.frame.size.height-hLine.frame.origin.y)];
    vLine2.backgroundColor = [ControllerManager colorWithHexString:@"e1e1e1"];
    [headerView addSubview:vLine2];
    
    NSArray * array = @[@"动态", @"粉丝", @"照片"];
    for (int i=0; i<3; i++) {
        UILabel * label1 = [MyControl createLabelWithFrame:CGRectMake(hLine.frame.origin.x+spe*i, hLine.frame.origin.y+5, spe, 20) Font:15 Text:@"100"];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont boldSystemFontOfSize:15];
        label1.tag = 100+i;
        [headerView addSubview:label1];
        
        UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(hLine.frame.origin.x+spe*i, label1.frame.origin.y+25, spe, 20) Font:15 Text:array[i]];
        label2.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label2];
        
        UIButton * button1 = [MyControl createButtonWithFrame:CGRectMake(label1.frame.origin.x, hLine.frame.origin.y, spe, vLine1.frame.size.height) ImageName:@"" Target:self Action:@selector(detailBtnClick:) Title:nil];
        button1.tag = 300+i;
        button1.showsTouchWhenHighlighted = YES;
        [headerView addSubview:button1];
    }
    /************************************/
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [self.view addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:backBtn];
    UIImageView * threePoint = [MyControl createImageViewWithFrame:CGRectMake(self.view.frame.size.width-36, 32+17/2.0-9/4.0, 47/2.0, 9/2.0) ImageName:@"threePoint.png"];
    [self.view addSubview:threePoint];
    
    UIButton * threePBtn = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-42, 25, 25+8+4, 32) ImageName:@"" Target:self Action:@selector(threePBtnClick) Title:nil];
    threePBtn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:threePBtn];
    
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)threePBtnClick
{
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
}
#pragma mark -
-(void)modifyUI
{
    NSString * str = nil;
    UIImage * defaultImage = nil;
    str = [NSString stringWithFormat:@"%@%@", PETTXURL, self.model.tx];
    defaultImage = [UIImage imageNamed:@"defaultPetHead.png"];
    [headBlurImage setImageWithURL:[NSURL URLWithString:str] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            headBlurImage.image = [image applyBlurWithRadius:15 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
        }
    }];
    
    [MyControl setImageForBtn:userHeadBtn Tx:self.model.u_tx isPet:NO isRound:YES];
    
    if (isMyPet) {
        headBtn = [MyControl createButtonWithFrame:CGRectMake((headCircle.frame.size.width-78)/2.0, (headCircle.frame.size.width-78)/2.0, 78, 78) ImageName:@"" Target:self Action:@selector(headBtnClick) Title:nil];
        [MyControl setImageForBtn:headBtn Tx:self.model.tx isPet:YES isRound:YES];
        [headCircle addSubview:headBtn];
        
        if (![[USER objectForKey:@"guide_petmain"] intValue]) {
            [USER setObject:@"1" forKey:@"guide_petmain"];
            [self createGuide];
        }
    }else{
        headImageView = [[ClickImage alloc] initWithFrame:CGRectMake((headCircle.frame.size.width-78)/2.0, (headCircle.frame.size.width-78)/2.0, 78, 78)];
        headImageView.canClick = YES;
        [MyControl setImageForImageView:headImageView Tx:self.model.tx isPet:YES isRound:YES];
        [headCircle addSubview:headImageView];
    }
    
    nameLabel.text = self.model.name;
    
    CGSize size = [nameLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(self.view.frame.size.width, 20) lineBreakMode:1];
    CGRect rect = sex.frame;
    rect.origin.x = self.view.frame.size.width/2.0+size.width/2.0;
    sex.frame = rect;
    if ([self.model.gender intValue] == 1) {
        sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    
    cateAndAgeLabel.text = [NSString stringWithFormat:@"%@ | %@", [ControllerManager returnCateNameWithType:self.model.type], [MyControl returnAgeStringWithCountOfMonth:self.model.age]];
    
    UILabel * label0 = (UILabel *)[headerView viewWithTag:100];
    label0.text = self.model.news;
    
    UILabel * label1 = (UILabel *)[headerView viewWithTag:101];
    label1.text = self.model.fans;
    
    UILabel * label2 = (UILabel *)[headerView viewWithTag:102];
    label2.text = self.model.images;
    
    
    self.rq = self.model.t_rq;
    
    [tv reloadData];
    
    if([self.model.master_id isEqualToString:[USER objectForKey:@"usr_id"]]){
        editImage = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 15, 15) ImageName:@"star_modify.png"];
        [headerView addSubview:editImage];
        
        tf = [MyControl createTextFieldWithFrame:CGRectMake(whiteBg.frame.origin.x+10, whiteBg.frame.origin.y, whiteBg.frame.size.width-20, 25) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:13];
        NSAttributedString * mutableString = [[NSAttributedString alloc] initWithString:@"点击创建独一无二的萌宣言吧~" attributes:@{NSForegroundColorAttributeName:[ControllerManager colorWithHexString:@"555555"]}];
        tf.attributedPlaceholder = mutableString;
        [mutableString release];
        if([self.model.msg isKindOfClass:[NSString class]] && self.model.msg.length){
            tf.text = self.model.msg;
        }
        tf.delegate = self;
        tf.textAlignment = NSTextAlignmentCenter;
        tf.textColor = [ControllerManager colorWithHexString:@"555555"];
        tf.returnKeyType = UIReturnKeyDone;
        tf.borderStyle = 0;
        tf.backgroundColor = [UIColor clearColor];
        [headerView addSubview:tf];
        
        NSString * str = nil;
        if (tf.text.length == 0) {
            str = @"点击创建独一无二的萌宣言吧~";
        }else{
            str = tf.text;
        }
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(tf.frame.size.width, 25) lineBreakMode:1];
        editImage.frame = CGRectMake(tf.frame.origin.x+tf.frame.size.width/2.0+size.width/2.0+5, tf.frame.origin.y+5, 15, 15);
    }else{
        msgLabel = [MyControl createLabelWithFrame:CGRectMake(whiteBg.frame.origin.x+10, whiteBg.frame.origin.y, whiteBg.frame.size.width-20, 25) Font:13 Text:[NSString stringWithFormat:@"%@暂时沉默中~", self.model.name]];
        if([self.model.msg isKindOfClass:[NSString class]] && self.model.msg.length){
            msgLabel.text = self.model.msg;
        }
        msgLabel.textColor = [ControllerManager colorWithHexString:@"555555"];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:msgLabel];
        
        CGSize size = [msgLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(tf.frame.size.width, 25) lineBreakMode:1];
        
        UIButton * msgBtn = [MyControl createButtonWithFrame:CGRectMake(msgLabel.frame.origin.x+msgLabel.frame.size.width/2.0+size.width/2.0+5, msgLabel.frame.origin.y+5, 17, 15)ImageName:@"pet_msg.png" Target:self Action:@selector(msgClick) Title:nil];
        [headerView addSubview:msgBtn];
    }
}

-(void)msgClick
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        return;
    }
    ChatViewController * chatController = [[ChatViewController alloc] initWithChatter:self.model.master_id isGroup:NO];
    chatController.isFromCard = YES;
    chatController.nickName = [USER objectForKey:@"name"];
    chatController.tx = [USER objectForKey:@"tx"];
    chatController.other_nickName = self.model.u_name;
    chatController.other_tx = self.model.u_tx;
    [self presentViewController:chatController animated:YES completion:nil];
    [chatController release];
}
#pragma mark -
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    editImage.hidden = YES;
    self.tempTFString = textField.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    editImage.hidden = NO;
    NSString * str = nil;
    if (tf.text.length == 0) {
        str = @"点击创建独一无二的萌宣言吧~";
    }else{
        str = tf.text;
    }
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(tf.frame.size.width, 25) lineBreakMode:1];
    editImage.frame = CGRectMake(tf.frame.origin.x+tf.frame.size.width/2.0+size.width/2.0+5, tf.frame.origin.y+5, 15, 15);
    [tf resignFirstResponder];
    if ([textField.text isEqualToString:self.tempTFString]) {
        return YES;
    }else{
        [self postMsg];
    }
    
    return YES;
}
-(void)postMsg
{
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.model.aid]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", MODIFYDECLAREAPI, self.model.aid, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 30.0;
    [_request setPostValue:tf.text forKey:@"msg"];
    _request.delegate = self;
    [_request startAsynchronous];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    ENDLOADING;
    NSLog(@"响应：%@", [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if([[dict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
//        CGSize tfSize = [tf.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(250, 20) lineBreakMode:1];
//        tf.frame = CGRectMake((bgView.frame.size.width-tfSize.width)/2, 152/2, tfSize.width, 20);
//        CGRect hyRect = hyperBtn.frame;
//        hyRect.origin.x = tf.frame.origin.x+tfSize.width-10;
//        hyperBtn.frame = hyRect;
//        
//        //
//        CGRect modRect = modifyBtn.frame;
//        modRect.origin.x = hyRect.origin.x+15;
//        modifyBtn.frame = modRect;
    }else{
        tf.text = self.tempTFString;
    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    tf.text = self.tempTFString;
    LOADFAILED;
}

#pragma mark -
-(void)headBtnClick
{
    //修改资料
    ModifyPetOrUserInfoViewController * vc = [[ModifyPetOrUserInfoViewController alloc] init];
    vc.refreshPetInfo = ^(){
        [self loadData];
    };
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)pBtnClick:(UIButton *)btn
{
    NSLog(@"p");
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        return;
    }
    Alert_oneBtnView * oneBtn = [[Alert_oneBtnView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (!btn.selected) {
//    user/petsApi&usr_id=(若用户为自己则留空不填)
        NSString * code = [NSString stringWithFormat:@"is_simple=0&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
        NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 0, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
        NSLog(@"%@", url);
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSArray * array = [load.dataDict objectForKey:@"data"];
                if (array.count >= 10) {
                    int cost = array.count*5;
                    if (cost>100) {
                        cost = 100;
                    }
                    if(cost>[[USER objectForKey:@"gold"] intValue]){
                        //余额不足
                        [MyControl popAlertWithView:self.view Msg:@"钱包君告急！挣够金币再来捧萌星吧~"];
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
                    NSString *joinPetCricleSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat",self.aid]];
                    NSString *joinPetCricleString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",JOINPETCRICLEAPI,self.aid,joinPetCricleSig,[ControllerManager getSID]];
                    NSLog(@"加入圈子:%@",joinPetCricleString);
                    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:joinPetCricleString Block:^(BOOL isFinish, httpDownloadBlock *load) {
                        if (isFinish) {
                            NSLog(@"加入成功数据：%@",load.dataDict);
                            if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                                //
                                pBtn.selected = YES;
                                if (self.isFromPetRecom) {
                                    self.updatePBtn();
                                }
                                UILabel * tempLabel = (UILabel *)[headerView viewWithTag:101];
                                tempLabel.text = [NSString stringWithFormat:@"%d", [tempLabel.text intValue]+1];
                                
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
                            [noClose configUIWithTx:self.model.tx Name:self.model.name Percent:percent];
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
        }];
        [request release];
        //
        
    }else{
        //        [self createExitCountryAlertView];
        Alert_2ButtonView2 * buttonView2 = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
        buttonView2.type = 4;
        [buttonView2 makeUI];
        buttonView2.quit = ^(){
            NSLog(@"quit");
            [self loadMyCountryInfoData:btn];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:buttonView2];
        [buttonView2 release];
    }
}
#pragma mark -
-(void)loadMyCountryInfoData:(UIButton *)btn
{
    LOADING;
    //    user/petsApi&usr_id=(若用户为自己则留空不填)
    NSString * code = [NSString stringWithFormat:@"is_simple=0&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 0, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            ENDLOADING;
            //            NSLog(@"%@", load.dataDict);
            //            [self.userPetListArray removeAllObjects];
            NSArray * array = [load.dataDict objectForKey:@"data"];
            NSMutableArray * countryArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary * dict in array) {
                UserPetListModel * model = [[UserPetListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                if ([model.aid isEqualToString:self.aid]) {
                    continue;
                }
                [countryArray addObject:model];
                [model release];
            }
            NSLog(@"%@--%@", [USER objectForKey:@"usr_id"], self.model.master_id);
            if ([[USER objectForKey:@"usr_id"] isEqualToString:self.model.master_id]) {
                [MyControl popAlertWithView:self.view Msg:@"不要抛弃自己家的萌星呀~"];
                return;
            }
            if (array.count == 1) {
                [MyControl popAlertWithView:self.view Msg:@"就剩一个啦~不能不捧啊~"];
                return;
            }
            if ([[USER objectForKey:@"aid"] isEqualToString:self.aid]) {
                NSMutableArray * tempArray = [NSMutableArray arrayWithArray:countryArray];
                //                [tempArray removeObjectAtIndex:row];
                //其他中贡献度最高的一个
                NSLog(@"退出的圈子aid：%@", [USER objectForKey:@"aid"]);
                int Index = 0;
                int Contri = [[tempArray[0] t_contri] intValue];
                for(int i=1;i<tempArray.count;i++){
                    if ([[tempArray[i] t_contri]intValue]>Contri) {
                        Index = i;
                        Contri = [[tempArray[i] t_contri] intValue];
                    }
                }
                NSLog(@"需要切换到默认aid：%@", [tempArray[Index] aid]);
                [self changeDefaultPetAid:[tempArray[Index] aid] MasterId:[tempArray[Index] master_id] Btn:btn];
                return;
            }else{
                NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", self.aid];
                NSString * sig = [MyMD5 md5:code];
                NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", EXITFAMILYAPI, self.aid, sig, [ControllerManager getSID]];
                NSLog(@"quitApiurl:%@", url);
                //                [MyControl startLoadingWithStatus:@"退出中..."];
                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
                        if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                            ENDLOADING;
                            btn.selected = NO;
                            
                        }else{
                            ENDLOADING;
                            [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"退出失败"];
                        }
                    }else{
                        ENDLOADING;
                        [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"退出失败"];
                    }
                }];
                [request release];
            }
            
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
#pragma mark -
-(void)changeDefaultPetAid:(NSString *)aid MasterId:(NSString *)master_id Btn:(UIButton *)btn
{
    LOADING;
    //    [MyControl startLoadingWithStatus:@"切换中..."];
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", aid]];
    NSString * url =[NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", CHANGEDEFAULTPETAPI, aid, sig, [ControllerManager getSID]];
    //    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                NSLog(@"%@", aid);
                
                //退出圈子
                NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", [USER objectForKey:@"aid"]];
                NSString * sig2 = [MyMD5 md5:code];
                NSString * url2 = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", EXITFAMILYAPI, [USER objectForKey:@"aid"], sig2, [ControllerManager getSID]];
                NSLog(@"quitApiurl:%@", url2);
                //                [MyControl startLoadingWithStatus:@"退出中..."];
                [USER setObject:aid forKey:@"aid"];
                [USER setObject:master_id forKey:@"master_id"];
                NSLog(@"%@--%@--%@", [USER objectForKey:@"aid"], [USER objectForKey:@"master_id"], [USER objectForKey:@"usr_id"]);
                httpDownloadBlock * request2 = [[httpDownloadBlock alloc] initWithUrlStr:url2 Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
                        ENDLOADING;
                        if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                            [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"退出成功"];
                            //                            [MMProgressHUD dismissWithSuccess:@"退出成功" title:nil afterDelay:0.5];
                            btn.selected = NO;
                            
                        }else{
                            [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"退出失败"];
                        }
                    }else{
                        [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"退出失败"];
                    }
                }];
                [request2 release];
                
                
            }else{
                [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"切换失败"];
            }
            
        }else{
            [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"切换失败"];
        }
    }];
    [request release];
}
#pragma mark -
-(void)userHeadBtnClick
{
    NSLog(@"user");
    UserCardViewController * vc = [[UserCardViewController alloc] init];
    vc.usr_id = self.model.master_id;
    [self.view addSubview:vc.view];
    vc.close = ^(){
        [vc.view removeFromSuperview];
    };
    [vc release];
}
-(void)detailBtnClick:(UIButton *)btn
{
    int a = btn.tag-300;
    if (a == 0) {
        PetMain_Active_ViewController * vc = [[PetMain_Active_ViewController alloc] init];
        vc.model = self.model;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }else if(a == 1){
        PetMain_Fans_ViewController * vc = [[PetMain_Fans_ViewController alloc] init];
        vc.model = self.model;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }else{
        PetMain_Photo_ViewController * vc = [[PetMain_Photo_ViewController alloc] init];
        vc.model = self.model;
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }
}


#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= 2) {
        static NSString * cellID = @"petMain";
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib * nib = [UINib nibWithNibName:@"PetMainCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellID];
            nibsRegistered = YES;
        }
        PetMainCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle = 0;
        
        if(indexPath.row == 0 && [self.model.total_food isKindOfClass:[NSString class]]){
            [cell modifyUIWithIndex:indexPath.row Num:self.model.total_food];
        }else if (indexPath.row == 1 && [self.rq isKindOfClass:[NSString class]]) {
            [cell modifyUIWithIndex:indexPath.row Num:self.rq];
//            indexPath.row == 2 && [self.model.gifts isKindOfClass:[NSString class]]
        }else if(indexPath.row == 2 && [self.rq isKindOfClass:[NSString class]]){
            [cell modifyUIWithIndex:indexPath.row Num:@"0"];
        }else{
            [cell modifyUIWithIndex:indexPath.row Num:@"100"];
        }
        
        return cell;
    }else{
        static NSString * cellID = @"ID";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
            
            NSArray * array1 = @[@"star_food.png", @"star_shake.png", @"star_gift.png", @"star_touch.png"];
            NSArray * array2 = @[@"挣口粮", @"摇一摇", @"献爱心", @"萌印象"];
            float spe = (self.view.frame.size.width-32-50*4)/3.0;
            for (int i=0; i<4; i++) {
                UIButton * btn = [MyControl createButtonWithFrame:CGRectMake(16+i*(50+spe), 8, 50, 50) ImageName:array1[i] Target:self Action:@selector(actBtnClick:) Title:nil];
                [cell addSubview:btn];
//                btn.layer.cornerRadius = 25;
//                btn.layer.masksToBounds = YES;
                btn.showsTouchWhenHighlighted = YES;
                btn.tag = 200+i;
                
                UILabel * label = [MyControl createLabelWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+50+5, 50, 15) Font:13 Text:array2[i]];
                label.textColor = [UIColor blackColor];
                label.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:label];
            }
        }
        cell.selectionStyle = 0;
        
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        PetMain_Food_ViewController * food = [[PetMain_Food_ViewController alloc] init];
        food.model = self.model;
        [self presentViewController:food animated:YES completion:nil];
        [food release];
    }else if(indexPath.row == 1){
        PopularityListViewController * rq = [[PopularityListViewController alloc] init];
//        [rq setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        rq.isFromPetMain = YES;
        rq.targetAid = self.aid;
        [self presentViewController:rq animated:YES completion:nil];
        [rq release];
    }else{
        PetMain_Gift_ViewController * gift = [[PetMain_Gift_ViewController alloc] init];
        gift.model = self.model;
        [self presentViewController:gift animated:YES completion:nil];
        [gift release];
    }
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 3) {
        return 55.0f;
    }else{
        return 107.0f;
    }
}

-(void)actBtnClick:(UIButton *)btn
{
    NSLog(@"%d",btn.tag);
    int a = btn.tag-200;
    if (a == 0) {
        //求口粮
        
        //请求API判断是否是否能发图
        LOADING;
        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.aid]];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", ALERT7DATAAPI, self.aid, sig, [ControllerManager getSID]];
        NSLog(@"%@", url);
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"%@", load.dataDict);
                if([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]] && ![[[load.dataDict objectForKey:@"data"] objectAtIndex:0] isKindOfClass:[NSDictionary class]]){
                    if ([self.model.master_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
//                        self.tempAid = model.aid;
//                        self.tempName = model.name;
//                        isBeg = YES;
                        
                        if (sheet == nil) {
                            // 判断是否支持相机
                            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                            {
                                sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
                            }
                            else {
                                
                                sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
                            }
                            
                            sheet.tag = 255;
                            
                        }
                        [sheet showInView:self.view];
                    }else{
                        [MyControl popAlertWithView:self.view Msg:[NSString stringWithFormat:@"萌星%@，今天还没挣口粮呢~", self.model.name]];
                    }
                    
                }else{
                    //弹分享框
                    Alert_BegFoodViewController * vc = [[Alert_BegFoodViewController alloc] init];
                    vc.dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                    vc.name = self.model.name;
                    [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
                    //                        [vc release];
                }
                ENDLOADING;
            }else{
                LOADFAILED;
            }
        }];
        [request release];
        
    }else if (a == 1) {
        
        RockViewController *shake = [[RockViewController alloc] init];
//        shake.isFromStar = YES;
        shake.titleString = @"摇一摇";
        //            shake.animalInfoDict = self.shakeInfoDict;
        shake.pet_aid = self.model.aid;
        shake.pet_name = self.model.name;
        shake.pet_tx = self.model.tx;
//        shake.unShakeNum = ^(int a){
//            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:model.dict];
//            [dict setObject:[NSNumber numberWithInt:1] forKey:@"shake_count"];
//            model.dict = dict;
//            model.shake_count = [NSNumber numberWithInt:a];
//            [self.tv reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        };
//        shake.updateContri = ^(NSString * add_rq){
//            //                NSLog(@"%@--%@", add_rq, cell.contributionLabel.text);
//            int contri = [[cell.contributionLabel.text substringFromIndex:3] intValue];
//            //                cell.contributionLabel.text = [NSString stringWithFormat:@"贡献度%d", contri+[add_rq intValue]];
//            model.t_contri = [NSString stringWithFormat:@"%d", contri+[add_rq intValue]];
//            [self.tv reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
//            //                NSLog(@"%@--%d", cell.contributionLabel.text, contri+[add_rq intValue]);
//        };
        [self addChildViewController:shake];
        [shake release];
        [shake didMoveToParentViewController:self];
        [shake becomeFirstResponder];
        [self.view addSubview:shake.view];
    }else if (a == 2) {
        SendGiftViewController * vc = [[SendGiftViewController alloc] init];
        vc.receiver_aid = self.model.aid;
        vc.receiver_name = self.model.name;
        vc.hasSendGift = ^(NSString * itemId){
            NSLog(@"赠送礼物给默认宠物成功!");
//            if ([[model.dict objectForKey:@"gift_count"] isKindOfClass:[NSNull class]]) {
//                NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:model.dict];
//                [dict setObject:[NSNumber numberWithInt:1] forKey:@"gift_count"];
//                model.dict = dict;
//                model.gift_count = [NSNumber numberWithInt:1];
//            }else{
//                model.gift_count = [NSNumber numberWithInt:[model.gift_count intValue]+1];
//            }
//            int contri = [[cell.contributionLabel.text substringFromIndex:3] intValue];
//            
//            model.t_contri = [NSString stringWithFormat:@"%d", contri+[[[ControllerManager returnGiftDictWithItemId:itemId] objectForKey:@"add_rq"] intValue]];
//            [self.tv reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //
            //                MainViewController * main = [ControllerManager shareMain];
            ResultOfBuyView * result = [[ResultOfBuyView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [UIView animateWithDuration:0.3 animations:^{
                result.alpha = 1;
            }];
            result.confirm = ^(){
                [vc closeGiftAction];
            };
            [result configUIWithName:self.model.name ItemId:itemId Tx:self.model.tx];
            [self.view addSubview:result];
            
            
        };
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        
        [self.view addSubview:vc.view];
        [vc release];
    }else if (a == 3) {
//        UILabel * label = (UILabel *)[self.view viewWithTag:303];
        TouchViewController *touch = [[TouchViewController alloc] init];
//        touch.isFromStar = YES;
//        touch.touchBack = ^(void){
//            label.text = @"摸过了";
//            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:model.dict];
//            [dict setObject:[NSNumber numberWithInt:1] forKey:@"is_touched"];
//            model.dict = dict;
//            model.is_touched = [NSNumber numberWithInt:1];
//        };
        touch.pet_aid = self.model.aid;
        touch.pet_name = self.model.name;
        touch.pet_tx = self.model.tx;
        [self addChildViewController:touch];
        [touch release];
        [touch didMoveToParentViewController:self];
        [self.view addSubview:touch.view];
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
}

#pragma mark - 分享截图
-(void)shareClick:(UIButton *)button
{
    [self cancelBtnClick];
    
    
    UIImage * screenshotImage = nil;
    if (isMyPet) {
        screenshotImage = headBtn.currentBackgroundImage;
    }else{
        screenshotImage = headImageView.image;
    }
    if (screenshotImage == nil) {
        screenshotImage = [UIImage imageNamed:@"record_upload.png"];
    }
    
    int a = button.tag-400;
    
    if (a == 0) {
        NSLog(@"微信");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@", PETMAINSHAREAPI, self.aid];
        [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"我是%@，来自宠物星球的大萌星！", self.model.name];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"人家在宠物星球好开心，快来跟我一起玩嘛~" image:screenshotImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
                //                StartLoading;
                //                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
                //                StartLoading;
                //                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
            
        }];
    }else if(a == 1){
        NSLog(@"朋友圈");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@", PETMAINSHAREAPI, self.aid];
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = [NSString stringWithFormat:@"我是%@，来自宠物星球的大萌星！", self.model.name];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"人家在宠物星球好开心，快来跟我一起玩嘛~" image:screenshotImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
                //                StartLoading;
                //                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
                //                StartLoading;
                //                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
            
        }];
    }else{
        NSLog(@"微博");
        NSString * str = [NSString stringWithFormat:@"人家在宠物星球好开心，快来跟我一起玩嘛~%@（分享自@宠物星球社交应用）", [NSString stringWithFormat:@"%@%@", PETMAINSHAREAPI, self.aid]];
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:screenshotImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
//                //                StartLoading;
//                //                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
//            }else{
//                NSLog(@"失败原因：%@", response);
//                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
//                //                StartLoading;
//                //                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
//            }
//            
//        }];
        
        BOOL oauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
        NSLog(@"%d", oauth);
        if (oauth) {
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:screenshotImage socialUIDelegate:self];
                //设置分享内容和回调对象
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            }];
        }else{
            [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:screenshotImage socialUIDelegate:self];
            //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
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

#pragma mark - 相机
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        [USER setObject:[NSString stringWithFormat:@"%d", buttonIndex] forKey:@"buttonIndex"];
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                    
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
//                    isCamara = YES;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                    isCamara = NO;
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//                isCamara = NO;
            } else {
                return;
            }
        }
        //跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.sourceType = sourceType;
        
//        if ([self hasValidAPIKey]) {
            [self presentViewController:imagePickerController animated:YES completion:^{}];
//        }
        
        [imagePickerController release];
    }
}

#pragma mark - UIImagePicker Delegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@", info);
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    NSLog(@"%d", image.imageOrientation);
    image = [MyControl fixOrientation:image];

    [self dismissViewControllerAnimated:NO completion:^{
        //Publish
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        PublishViewController * vc = [[PublishViewController alloc] init];

        vc.isBeg = YES;
        vc.oriImage = image;
        vc.name = self.model.name;
        vc.aid = self.model.aid;
        vc.showFrontImage = ^(NSString * img_id, BOOL isFood, NSString * aid, NSString * name){
            if (!isFood) {
                FrontImageDetailViewController * front = [[FrontImageDetailViewController alloc] init];
                front.img_id = img_id;
                [[UIApplication sharedApplication].keyWindow addSubview:front.view];
                [front release];
            }else{
                NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", aid]];
                NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", ALERT7DATAAPI, aid, sig, [ControllerManager getSID]];
                NSLog(@"%@", url);
                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    Alert_BegFoodViewController * vc = [[Alert_BegFoodViewController alloc] init];
                    vc.dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                    vc.name = name;
                    [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
                    [vc release];
                }];
                [request release];
            }
        };
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }];
    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
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
