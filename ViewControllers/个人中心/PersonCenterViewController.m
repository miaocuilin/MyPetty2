//
//  PersonCenterViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/31.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "PersonCenterStarCell.h"
#import "PersonCenterGoldCell.h"
#import "PersonCenterSetCell.h"
#import "SettingViewController.h"
#import "ChooseInViewController.h"
#import "MsgViewController.h"
#import "ExchangeViewController.h"
#import "UserBagViewController.h"
#import "WalkAndTeaseViewController.h"
#import "SetPasswordViewController.h"
#import "Alert_HyperlinkView.h"
#import "AddressViewController.h"
#import "SetBlackListViewController.h"
#import "MessagePushSetViewController.h"
#import "InviteCodeModel.h"
#import "UserPetListModel.h"

@interface PersonCenterViewController () <UITableViewDataSource,UITableViewDelegate>
{
    BOOL isConfVersion;
    BOOL hasMyPet;
}
@property(nonatomic,strong)UIImageView *blurImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *headBtn;
@property(nonatomic,strong)UILabel *goldLabel;
@property(nonatomic,strong)UIImageView *goldImage;
@property(nonatomic,strong)UIImageView *sexImage;
@property(nonatomic,strong)UILabel *sexLabel;
@property(nonatomic,strong)UILabel *locationLabel;
@property(nonatomic,strong)UIImageView *msgCountImage;
@property(nonatomic,strong)UILabel *msgCountLabel;

@property(nonatomic,strong)UITableView *tv;
@property(nonatomic,strong)UIView *underLine;
@property(nonatomic,strong)UIImageView *missionCountImage;
@property(nonatomic,strong)UILabel *missionCountLabel;

@property(nonatomic)NSInteger selectedIndex;
@property(nonatomic,strong)NSArray *setArray;

@property(nonatomic,strong)UISwitch *weixinSwitch;
@property(nonatomic,strong)UISwitch *weiboSwitch;

@property(nonatomic,strong)NSMutableArray *petsArray;
@end

@implementation PersonCenterViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self modifyUI];
    if(!self.selectedIndex){
        [self getMyPettys];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.petsArray = [NSMutableArray arrayWithCapacity:0];
    
//    self.setArray = @[@"设置密码", @"切换账号", @"收货地址", @"解除黑名单", @"填写邀请码", @"消息推送设置", @"同步分享到微信", @"同步分享到微博"];
    
    
    [self judgeSetRowNum];
    [self makeUI];
//    [self modifyUI];
    [self getMyPettys];
}

-(void)getMyPettys
{
    [self.petsArray removeAllObjects];
    NSArray *array = [USER objectForKey:@"myPetsDataArray"];
    for (NSDictionary *dict in array) {
        UserPetListModel *model = [[UserPetListModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.petsArray addObject:model];
    }
    [self.tv reloadData];
}
-(void)judgeSetRowNum
{
    NSArray *array = [USER objectForKey:@"myPetsDataArray"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    isConfVersion = ![[USER objectForKey:@"confVersion"] isEqualToString:version];
    if ([array isKindOfClass:[NSArray class]] && array.count) {
        for (NSDictionary * dict in array) {
            if ([[dict objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
                hasMyPet = YES;
                self.pet_id = [dict objectForKey:@"aid"];
                break;
            }
        }
    }
    
    if(isConfVersion){
        if (hasMyPet) {
            self.setArray = @[@"设置密码", @"切换账号", @"收货地址", @"解除黑名单", @"消息推送设置", @"同步分享到微信", @"同步分享到微博"];
        }else{
            self.setArray = @[@"设置密码", @"切换账号", @"解除黑名单", @"消息推送设置", @"同步分享到微信", @"同步分享到微博"];
        }
    }else{
        if (hasMyPet) {
            self.setArray = @[@"设置密码", @"切换账号", @"收货地址", @"解除黑名单", @"填写邀请码", @"消息推送设置", @"同步分享到微信", @"同步分享到微博"];
        }else{
            self.setArray = @[@"设置密码", @"切换账号", @"解除黑名单", @"填写邀请码", @"消息推送设置", @"同步分享到微信", @"同步分享到微博"];
        }
    }
}
-(void)makeUI
{
    UIImageView *blurBg = [MyControl createImageViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) ImageName:@"blurBg.jpg"];
    [self.view addSubview:blurBg];
    
    self.blurImage = [MyControl createImageViewWithFrame:CGRectMake(0, 0, WIDTH, 240) ImageName:@""];
//    self.blurImage.backgroundColor = [UIColor clearColor];
    
//    401_1422966300headImage.png
    
//    self.blurImage.image = [[UIImage imageNamed:@"defaultUserHead.png"] applyBlurWithRadius:15 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    self.blurImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.blurImage];
    
    UIImageView * addImage = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 17, 17) ImageName:@"moreBtn.png"];
    [self.blurImage addSubview:addImage];
    
    UIButton * addBtn = [MyControl createButtonWithFrame:CGRectMake(10, 28, 30, 25) ImageName:@"" Target:self Action:@selector(addBtnClick) Title:nil];
    addBtn.showsTouchWhenHighlighted = YES;
    [self.blurImage addSubview:addBtn];
    
    
    self.titleLabel = [MyControl createLabelWithFrame:CGRectMake((WIDTH-200)/2.0, 32, 200, 20) Font:17 Text:@"游荡的两脚兽"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.blurImage addSubview:self.titleLabel];
    
    
    UIButton *setBtn = [MyControl createButtonWithFrame:CGRectMake(320-20-17, 30, 20, 20) ImageName:@"center_set.png" Target:self Action:@selector(setBtnClick) Title:nil];
    setBtn.showsTouchWhenHighlighted = YES;
    [self.blurImage addSubview:setBtn];
    
    //
    self.headBtn = [MyControl createButtonWithFrame:CGRectMake((WIDTH-64)/2.0, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+20, 64, 64) ImageName:@"defaultUserHead.png" Target:self Action:@selector(headClick) Title:nil];
    [self.blurImage addSubview:self.headBtn];
    
    self.sexImage = [MyControl createImageViewWithFrame:CGRectMake(WIDTH/2.0-8, self.headBtn.frame.origin.y+self.headBtn.frame.size.height+15, 8, 12) ImageName:@"gender_girl.png"];
    [self.blurImage addSubview:self.sexImage];
    
    self.sexLabel = [MyControl createLabelWithFrame:CGRectMake(self.sexImage.frame.origin.x+self.sexImage.frame.size.width+2, self.sexImage.frame.origin.y, 30, 12) Font:11 Text:nil];
    [self.blurImage addSubview:self.sexLabel];
    
    NSString *str = @"0";
    CGSize size = [str boundingRectWithSize:CGSizeMake(WIDTH, 12) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    self.goldLabel = [MyControl createLabelWithFrame:CGRectMake(self.sexImage.frame.origin.x-size.width-30, self.sexImage.frame.origin.y, size.width, 12) Font:11 Text:@"0"];
    [self.blurImage addSubview:self.goldLabel];
    
    self.goldImage = [MyControl createImageViewWithFrame:CGRectMake(self.goldLabel.frame.origin.x-5-12, self.sexImage.frame.origin.y, 12, 12) ImageName:@"gold_small.png"];
    [self.blurImage addSubview:self.goldImage];
    
    UIImageView *locationImage = [MyControl createImageViewWithFrame:CGRectMake(self.sexLabel.frame.origin.x+self.sexLabel.frame.size.width, self.sexImage.frame.origin.y, 9, 12) ImageName:@"icon_location.png"];
    [self.blurImage addSubview:locationImage];
    
    CGFloat locationX = locationImage.frame.origin.x+locationImage.frame.size.width+5;
    self.locationLabel = [MyControl createLabelWithFrame:CGRectMake(locationX, self.sexImage.frame.origin.y, WIDTH-locationX, 12) Font:11 Text:nil];
    [self.blurImage addSubview:self.locationLabel];
    
    //line
    UIView *lineView = [MyControl createViewWithFrame:CGRectMake(15, self.sexImage.frame.origin.y+self.sexImage.frame.size.height+10, WIDTH-30, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.blurImage addSubview:lineView];
    
    CGFloat width = 35;
    CGFloat spaceToLeft = 50;
    CGFloat spe = (WIDTH-50*2-width*4)/3.0;
    
    NSArray *nameArray = @[@"bt_message.png", @"bt_exchange.png", @"bt_charge.png", @"bt_gift.png"];
    NSArray *textArray = @[@"私信", @"兑换", @"充值", @"礼物"];
    for (int i=0; i<4; i++) {
        UIButton *btn = [MyControl createButtonWithFrame:CGRectMake(spaceToLeft+(width+spe)*i, lineView.frame.origin.y+10, width, width) ImageName:nameArray[i] Target:self Action:@selector(actionBtnClick:) Title:nil];
        [self.blurImage addSubview:btn];
        btn.tag = 100+i;
        
        if(i == 0){
            self.msgCountImage = [MyControl createImageViewWithFrame:CGRectMake(width-10, -5, 15, 15) ImageName:@"center_msgBg.png"];
            [btn addSubview:self.msgCountImage];
            
            self.msgCountLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 15, 15) Font:10 Text:@"9"];
            self.msgCountLabel.numberOfLines = 1;
            self.msgCountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            self.msgCountLabel.textAlignment = NSTextAlignmentCenter;
            [self.msgCountImage addSubview:self.msgCountLabel];
            self.msgCountImage.hidden = YES;
        }
        
        UILabel *text = [MyControl createLabelWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+btn.frame.size.height, btn.frame.size.width, 15) Font:11 Text:textArray[i]];
        text.textAlignment = NSTextAlignmentCenter;
        [self.blurImage addSubview:text];
    }
    
    //tableView
    [self createTableView];
}
-(void)addBtnClick
{
    ShouldShowRegist;
    
    ChooseInViewController * vc = [[ChooseInViewController alloc] init];
    vc.isOldUser = YES;
    vc.isFromAdd = YES;
    [self presentViewController:vc animated:YES completion:nil];
//    [vc release];
}
-(void)setBtnClick
{
    SettingViewController * vc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark -
-(void)headClick
{
    ShouldShowRegist;
    
    UserCardViewController * vc = [[UserCardViewController alloc] init];
    __unsafe_unretained UserCardViewController *weakVC = vc;
    vc.usr_id = [USER objectForKey:@"usr_id"];
    [ControllerManager addTabBarViewController:vc];
    vc.close = ^(){
        [ControllerManager deleTabBarViewController:weakVC];
    };
}
#pragma mark -
-(void)actionBtnClick:(UIButton *)sender
{
    ShouldShowRegist;
    int a = sender.tag-100;
    if (a == 0) {
        //私信
        MsgViewController * vc = [[MsgViewController alloc] init];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
    }else if(a == 1){
        //兑换
        ExchangeViewController * vc = [[ExchangeViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else if(a == 2){
        //充值
        WalkAndTeaseViewController *vc = [[WalkAndTeaseViewController alloc] init];
        vc.aid = [USER objectForKey:@"aid"];
        [self presentViewController:vc animated:YES completion:nil];
    }else if(a == 3){
        //礼物
        UserBagViewController * vc = [[UserBagViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
#pragma mark -
-(void)modifyUI
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        return;
    }
    NSURL * url = [MyControl returnThumbUserTxURLwithName:[USER objectForKey:@"tx"] Width:self.blurImage.frame.size.width*2 Height:self.blurImage.frame.size.height*2];
    __block PersonCenterViewController *blockSelf = self;
    [self.blurImage setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image){
            blockSelf.blurImage.image = [image applyBlurWithRadius:15 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
        }
    }];
    
    self.titleLabel.text = [USER objectForKey:@"name"];
    [MyControl setImageForBtn:self.headBtn Tx:[USER objectForKey:@"tx"] isPet:NO isRound:YES];
    
    NSString *str = [USER objectForKey:@"gold"];
    CGSize size = [str boundingRectWithSize:CGSizeMake(WIDTH, 12) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    self.goldLabel.text = str;
    [MyControl setOriginX:self.sexImage.frame.origin.x-25-size.width WithView:self.goldLabel];
    [MyControl setWidth:size.width WithView:self.goldLabel];
    [MyControl setOriginX:self.goldLabel.frame.origin.x-5-12 WithView:self.goldImage];
    
    if ([[USER objectForKey:@"gender"] intValue] == 1) {
        self.sexImage.image = [UIImage imageNamed:@"gender_boy.png"];
        self.sexLabel.text = @"男";
    }else{
        self.sexImage.image = [UIImage imageNamed:@"gender_girl.png"];
        self.sexLabel.text = @"女";
    }
    self.locationLabel.text = [ControllerManager returnProvinceAndCityWithCityNum:[USER objectForKey:@"city"]];
    
    int a = [MyControl returnUnreadMessageCount];
    if (a) {
        self.msgCountImage.hidden = NO;
        self.msgCountLabel.text = [NSString stringWithFormat:@"%d", a];
    }else{
        self.msgCountImage.hidden = YES;
    }
}


#pragma mark - tableView
-(void)createTableView
{
    self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0, self.blurImage.frame.size.height+40, WIDTH, HEIGHT-self.blurImage.frame.size.height-50-40) style:UITableViewStylePlain];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    [self.view addSubview:self.tv];
    self.tv.separatorStyle = 0;
    
//    [self.tv registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [self.tv registerNib:[UINib nibWithNibName:@"PersonCenterStarCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonCenterStarCell"];
    [self.tv registerNib:[UINib nibWithNibName:@"PersonCenterGoldCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonCenterGoldCell"];
//    [self.tv registerClass:[PersonCenterSetCell class] forCellReuseIdentifier:@"PersonCenterSetCell"];
    
    UIView *headerView = [MyControl createViewWithFrame:CGRectMake(0, self.blurImage.frame.size.height, WIDTH, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    NSArray *labelArray = @[@"我的萌星", @"赚金币", @"账号管理"];
    for (int i=0; i<3; i++) {
        UILabel *label = [MyControl createLabelWithFrame:CGRectMake(WIDTH/3.0*i, 0, WIDTH/3.0, headerView.frame.size.height) Font:15 Text:labelArray[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [headerView addSubview:label];
        
        if (i == 0) {
            self.underLine = [MyControl createViewWithFrame:CGRectMake(WIDTH/3.0*0.2, headerView.frame.size.height-4, WIDTH/3.0*0.6, 2)];
            self.underLine.backgroundColor = ORANGE;
            self.underLine.layer.cornerRadius = 1;
            self.underLine.layer.masksToBounds = YES;
            [headerView addSubview:self.underLine];
        }
        
        if (i == 1) {
            NSString *str = labelArray[i];
            CGSize size = [str boundingRectWithSize:CGSizeMake(WIDTH/3.0, headerView.frame.size.height) options:2 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            self.missionCountImage = [MyControl createImageViewWithFrame:CGRectMake(label.frame.size.width/2.0+size.width/2.0, (headerView.frame.size.height-15)/2.0, 15, 15) ImageName:@"center_msgBg.png"];
            [label addSubview:self.missionCountImage];
            
            self.missionCountLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 15, 15) Font:10 Text:@"15"];
            self.missionCountLabel.textAlignment = NSTextAlignmentCenter;
            self.missionCountLabel.numberOfLines = 1;
            self.missionCountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [self.missionCountImage addSubview:self.missionCountLabel];
            
            self.missionCountImage.hidden = YES;
        }
        
        UIButton *btn = [MyControl createButtonWithFrame:CGRectMake(0, 0, label.frame.size.width, label.frame.size.height) ImageName:@"" Target:self Action:@selector(headerBtnClick:) Title:nil];
        btn.tag = 200+i;
        [label addSubview:btn];
    }
    UIView *lineView = [MyControl createViewWithFrame:CGRectMake(0, 39, WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [headerView addSubview:lineView];
    
//    self.tv.tableHeaderView = headerView;
}
-(void)headerBtnClick:(UIButton *)sender
{
    NSInteger a = sender.tag-200;
    if (a == 0) {
        [self getMyPettys];
    }
    if (self.selectedIndex != a) {
        self.selectedIndex = a;
        [self.tv reloadData];
    }
    
    
    CGFloat oriX = a*(WIDTH/3.0)+WIDTH/3.0*0.2;
    __block CGRect rect = self.underLine.frame;
    if (rect.origin.x != oriX) {
        [UIView animateWithDuration:0.2 animations:^{
            rect.origin.x = oriX;
            self.underLine.frame = rect;
        }];
    }
}

#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        return 0;
    }else{
        if(self.selectedIndex == 0){
            return self.petsArray.count;
        }else if(self.selectedIndex == 1){
            return 10;
        }else{
            return self.setArray.count;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.selectedIndex){
        PersonCenterStarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCenterStarCell"];
        cell.accessoryView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 20, 20) ImageName:@"14-6-2.png"];
        UserPetListModel *model = self.petsArray[indexPath.row];
        [cell modifyUI:model];
        
        cell.selectionStyle = 0;
        return cell;
    }else if(self.selectedIndex == 1){
        PersonCenterGoldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCenterGoldCell"];
        
        cell.selectionStyle = 0;
        return cell;
    }else{
        static NSString *cellID3 = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
            UIView *view = [MyControl createViewWithFrame:CGRectMake(0, 49, WIDTH, 1)];
            view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
            [cell.contentView addSubview:view];
        }
        cell.selectionStyle = 0;
        
        cell.textLabel.text = self.setArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.indentationLevel = 1;
        cell.indentationWidth = 10;
        
        int a = 0;
        if (isConfVersion) {
            if (hasMyPet) {
                a = 4;
            }else{
                a = 3;
            }
        }else{
            if (hasMyPet) {
                a = 5;
            }else{
                a = 4;
            }
        }
        
        if (indexPath.row <= a) {
            cell.accessoryView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 20, 20) ImageName:@"14-6-2.png"];
        }else{
            if (indexPath.row == a+1) {
                if (!self.weixinSwitch) {
                    self.weixinSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                    [self.weixinSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
                }
                if ([[USER objectForKey:@"weChat"] intValue]) {
                    self.weixinSwitch.on = YES;
                }else{
                    self.weixinSwitch.on = NO;
                }
                
                cell.accessoryView = self.weixinSwitch;
            }else if(indexPath.row == a+2){
                if (!self.weiboSwitch) {
                    self.weiboSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                    [self.weiboSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
                }
                if ([[USER objectForKey:@"sina"] intValue]) {
                    self.weiboSwitch.on = YES;
                }else{
                    self.weiboSwitch.on = NO;
                }
                cell.accessoryView = self.weiboSwitch;
            }
        }
        
        
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.selectedIndex == 0){
        UserPetListModel *model = self.petsArray[indexPath.row];
        PetMainViewController * vc = [[PetMainViewController alloc] init];
        vc.aid = model.aid;
        [self presentViewController:vc animated:YES completion:nil];
    }else if(self.selectedIndex == 1){
        
    }else if(self.selectedIndex == 2){
        //
        int x = indexPath.row;
        if (x == 0) {
            //设置密码
            SetPasswordViewController * vc = [[SetPasswordViewController alloc] init];
            if([[USER objectForKey:@"password"] isKindOfClass:[NSString class]] && [[USER objectForKey:@"password"] length]){
                vc.isModify = YES;
            }
            [self presentViewController:vc animated:YES completion:nil];
            //        [vc release];
            
        }else if (x == 1) {
            //切换账号
            NSLog(@"%d--%d", [[USER objectForKey:@"password"] isKindOfClass:[NSString class]], [[USER objectForKey:@"password"] length]);
            //        if (![[USER objectForKey:@"password"] isKindOfClass:[NSString class]] || ![[USER objectForKey:@"password"] length]) {
            Alert_HyperlinkView * hyper = [[Alert_HyperlinkView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            hyper.type = 1;
            
            [hyper makeUI];
            [self.view addSubview:hyper];
            hyper.jumpSetPwd = ^(){
                SetPasswordViewController * set = [[SetPasswordViewController alloc] init];
                NSLog(@"%@", [USER objectForKey:@"password"]);
                if ([[USER objectForKey:@"password"] isKindOfClass:[NSString class]] && [[USER objectForKey:@"password"] length]) {
                    set.isModify = YES;
                }
                [self presentViewController:set animated:YES completion:nil];
                //            [set release];
            };
            hyper.jumpLogin = ^(){
                LoginViewController * vc = [[LoginViewController alloc] init];
                vc.isFromAccount = YES;
                [self presentViewController:vc animated:YES completion:nil];
                //            [vc release];
            };
            //        [hyper release];
            //        }else{
            //            LoginViewController * vc = [[LoginViewController alloc] init];
            //            vc.isFromAccount = YES;
            //            [self presentViewController:vc animated:YES completion:nil];
            //            [vc release];
            //        }
            
        }else if (x == 2) {
            if (hasMyPet) {
                //收货地址
                AddressViewController *address = [[AddressViewController alloc]init];
                address.pet_id = self.pet_id;
                [self presentViewController:address animated:YES completion:^{
                    //                [address release];
                }];
            }else{
                //解除黑名单
                SetBlackListViewController * vc = [[SetBlackListViewController alloc] init];
                [self presentViewController:vc animated:YES completion:nil];
                //            [vc release];
            }
        }else if (x == 3) {
            if (hasMyPet) {
                //解除黑名单
                SetBlackListViewController * vc = [[SetBlackListViewController alloc] init];
                [self presentViewController:vc animated:YES completion:nil];
                //            [vc release];
            }else{
                if (isConfVersion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MessagePushSetViewController * vc = [[MessagePushSetViewController alloc] init];
                        [self presentViewController:vc animated:YES completion:nil];
                        //                    [vc release];
                    });
                }else{
                    //填写邀请码
                    [self inputCode];
                    //            [self loadMyPets];
                }
            }
        }else if(x == 4){
            if(hasMyPet){
                if (isConfVersion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MessagePushSetViewController * vc = [[MessagePushSetViewController alloc] init];
                        [self presentViewController:vc animated:YES completion:nil];
                        //                    [vc release];
                    });
                    //微信绑定
                    //            if (![[USER objectForKey:@"wechat"] length]) {
                    //                [self bindWeChat];
                    //            };
                }else{
                    //填写邀请码
                    [self inputCode];
                    //            [self loadMyPets];
                }
            }else{
                if (!isConfVersion) {
                    
                    //            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MessagePushSetViewController * vc = [[MessagePushSetViewController alloc] init];
                        [self presentViewController:vc animated:YES completion:nil];
                        //                    [vc release];
                    });
                    
                    //            [nav release];
                }
            }
        }else if(x == 5){
            if (hasMyPet) {
                if (!isConfVersion) {
                    
                    //            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MessagePushSetViewController * vc = [[MessagePushSetViewController alloc] init];
                        [self presentViewController:vc animated:YES completion:nil];
                        //                    [vc release];
                    });
                    
                    //            [nav release];
                }
            }
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


#pragma mark - inputCode
-(void)inputCode
{
    if ([[USER objectForKey:@"inviter"] isKindOfClass:[NSString class]] && [[USER objectForKey:@"inviter"] intValue]) {
        //已经填写过 type=3
        NSString * inviter = [USER objectForKey:@"inviter"];
        InviteCodeModel * model = [[InviteCodeModel alloc] init];
        model.inviter = inviter;
        [self codeViewFailed:model];
//        [model release];
        return;
    }
    
    CodeAlertView * codeView = [[CodeAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    codeView.AlertType = 1;
    [codeView makeUI];
    [self.view addSubview:codeView];
    [UIView animateWithDuration:0.2 animations:^{
        codeView.alpha = 1;
    }];
    
    __unsafe_unretained CodeAlertView *weakCodeView = codeView;
    
    codeView.confirmClick = ^(NSString * code){
        
        //请求API
        LOADING;
        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"code=%@dog&cat", code]];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", INVITECODEAPI, code, sig, [ControllerManager getSID]];
        NSLog(@"%@", url);
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"%@", load.dataDict);
                InviteCodeModel * model = [[InviteCodeModel alloc] init];
                [model setValuesForKeysWithDictionary:[load.dataDict objectForKey:@"data"]];
                
                
                [weakCodeView closeBtnClick];
                //成功提示
                NSLog(@"%@", [USER objectForKey:@"inviter"]);
                NSString * gold = [NSString stringWithFormat:@"%d", [[USER objectForKey:@"gold"] intValue]+300];
                [USER setObject:gold forKey:@"gold"];
                
                [self codeViewSuccess:model];
                [USER setObject:model.inviter forKey:@"inviter"];
                //                }
                
//                [model release];
                ENDLOADING;
            }else{
                LOADFAILED;
                //                [MyControl loadingFailedWithContent:@"加载失败" afterDelay:0.2];
            }
        }];
//        [request release];
    };
}
-(void)codeViewSuccess:(InviteCodeModel *)model
{
    CodeAlertView * codeView = [[CodeAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    codeView.AlertType = 2;
    codeView.codeModel = model;
    [codeView makeUI];
    [self.view addSubview:codeView];
    [UIView animateWithDuration:0.2 animations:^{
        codeView.alpha = 1;
    }];
    __unsafe_unretained CodeAlertView *weakCodeView = codeView;
    
    codeView.confirmClick = ^(NSString * code){
        [weakCodeView closeBtnClick];
    };
}
-(void)codeViewFailed:(InviteCodeModel *)model
{
    CodeAlertView * codeView = [[CodeAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    codeView.AlertType = 3;
    codeView.codeModel = model;
    [codeView makeUI];
    [self.view addSubview:codeView];
    [UIView animateWithDuration:0.2 animations:^{
        codeView.alpha = 1;
    }];
    
    __unsafe_unretained CodeAlertView *weakCodeView = codeView;
    codeView.confirmClick = ^(NSString * code){
        [weakCodeView closeBtnClick];
    };
}
#pragma mark -
-(void)switchChange:(UISwitch *)swit
{
//    int a = swit.tag-100;

    if (swit == self.weixinSwitch) {
        //同步微信
        if (swit.on) {
            [USER setObject:@"1" forKey:@"weChat"];
        }else{
            [USER setObject:@"0" forKey:@"weChat"];
        }
        
    }else if (swit == self.weiboSwitch) {
        //同步微博
        if (swit.on) {
            [USER setObject:@"1" forKey:@"sina"];
        }else{
            [USER setObject:@"0" forKey:@"sina"];
        }
    }
}
@end
