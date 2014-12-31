//
//  UserCardViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/24.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "UserCardViewController.h"
#import "UserPetListModel.h"
#import "TalkViewController.h"
#import "ModifyPetOrUserInfoViewController.h"
#import "PetInfoViewController.h"

@interface UserCardViewController ()

@end

@implementation UserCardViewController
-(void)dealloc
{
    [super dealloc];
    [self.userModel release];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MobClick event:@"personal_homepage"];
    
    self.petsDataArray = [NSMutableArray arrayWithCapacity:0];
    
    if([self.usr_id isEqualToString:[USER objectForKey:@"usr_id"]]){
        isMyself = YES;
    }
    
    [self createUI];
    [self loadData];
}
-(void)loadData
{
    LOADING2;
//    user/infoApi&usr_id=
    NSString *userInfoSig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", self.usr_id]];
    NSString *userInfoString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERINFOAPI, self.usr_id, userInfoSig,[ControllerManager getSID]];
    NSLog(@"用户信息API:%@",userInfoString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:userInfoString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            ENDLOADING;
            
            NSLog(@"用户信息数据：%@",load.dataDict);
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]] && [[load.dataDict objectForKey:@"data"] count]) {
                NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                self.userModel = [[UserInfoModel alloc] init];
                [self.userModel setValuesForKeysWithDictionary:dict];
                
                if (isMyself) {
                    [USER setObject:self.userModel.gold forKey:@"gold"];
                }
                
                [self loadPetsData];
            }
            
            
            
        }else{
            LOADFAILED;
        }
        
    }];
    [request release];
}
-(void)loadPetsData
{
    LOADING2;
    NSString * code = [NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", self.usr_id];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, self.usr_id, [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            [self.petsDataArray removeAllObjects];
            
            NSArray * array = [load.dataDict objectForKey:@"data"];
            for (NSDictionary * dict in array) {
                UserPetListModel * model = [[UserPetListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                if([model.master_id isEqualToString:self.usr_id]){
                    [self.petsDataArray insertObject:model atIndex:0];
                }else{
                    [self.petsDataArray addObject:model];
                }
                
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
-(void)createUI
{
    self.view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
    }];
    
    UIButton * alphaBtn = [MyControl createButtonWithFrame:[UIScreen mainScreen].bounds ImageName:@"" Target:self Action:@selector(closeBtnClick) Title:nil];
    alphaBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.view addSubview:alphaBtn];
    
    cardBg = [MyControl createViewWithFrame:CGRectMake(17, (self.view.frame.size.height-350)/2.0-50, self.view.frame.size.width-34, 350)];
    cardBg.backgroundColor = [UIColor whiteColor];
    cardBg.layer.cornerRadius = 5;
    cardBg.layer.masksToBounds = YES;
    [self.view addSubview:cardBg];
    
    UIButton * closeBtn = [MyControl createButtonWithFrame:CGRectMake(cardBg.frame.size.width-36, 0, 36, 36) ImageName:@"various_close.png" Target:self Action:@selector(closeBtnClick) Title:nil];
    [cardBg addSubview:closeBtn];
    
    if (isMyself) {
        headBtn = [MyControl createButtonWithFrame:CGRectMake((cardBg.frame.size.width-90)/2.0, 18, 90, 90) ImageName:@"defaultUserHead.png" Target:self Action:@selector(headerClick) Title:nil];
        headBtn.layer.cornerRadius = 45;
        headBtn.layer.masksToBounds = YES;
        [cardBg addSubview:headBtn];
    }else{
        headImageView = [[ClickImage alloc]initWithFrame:CGRectMake((cardBg.frame.size.width-90)/2.0, 18, 90, 90)];
        headImageView.image = [UIImage imageNamed:@"defaultUserHead.png"];
        headImageView.canClick = YES;
        headImageView.layer.cornerRadius = 45;
        headImageView.layer.masksToBounds = YES;
        [cardBg addSubview:headImageView];
        [headImageView release];
    }
    
    nameBg = [MyControl createViewWithFrame:CGRectMake(0, 228/2, cardBg.frame.size.width, 20)];
    [cardBg addSubview:nameBg];
    
    nameLabel = [MyControl createLabelWithFrame:CGRectZero Font:17 Text:nil];
    nameLabel.textColor = ORANGE;
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    [nameBg addSubview:nameLabel];
    
    sex = [MyControl createImageViewWithFrame:CGRectZero ImageName:@""];
    [nameBg addSubview:sex];
    
    position = [MyControl createLabelWithFrame:CGRectMake(0, nameBg.frame.origin.y+20+5, cardBg.frame.size.width, 20) Font:14 Text:nil];
    position.textAlignment = NSTextAlignmentCenter;
    position.textColor = [UIColor blackColor];
    [cardBg addSubview:position];
    
    goldBg = [MyControl createViewWithFrame:CGRectMake(0, 330/2, cardBg.frame.size.width, 30)];
    goldBg.hidden = YES;
    [cardBg addSubview:goldBg];
    
    UIImageView * gold = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 30, 30) ImageName:@"gold.png"];
    [goldBg addSubview:gold];
    
    goldLabel = [MyControl createLabelWithFrame:CGRectMake(35, 5, 0, 20) Font:17 Text:nil];
    goldLabel.textColor = ORANGE;
    [goldBg addSubview:goldLabel];
    
    petsBg = [MyControl createImageViewWithFrame:CGRectMake(7, cardBg.frame.size.height-144, cardBg.frame.size.width-14, 71) ImageName:@""];
    petsBg.image = [[UIImage imageNamed:@"profile_bg_pets.png"] stretchableImageWithLeftCapWidth:11 topCapHeight:5];
    [cardBg addSubview:petsBg];
    
    leftArrow = [MyControl createImageViewWithFrame:CGRectMake(14, (petsBg.frame.size.height-16)/2.0, 16, 16) ImageName:@"profile_arrow.png"];
    [petsBg addSubview:leftArrow];
    
    rightArrow = [MyControl createImageViewWithFrame:CGRectMake(petsBg.frame.size.width-16-14, (petsBg.frame.size.height-16)/2.0, 16, 16) ImageName:@"profile_arrow_2.png"];
    [petsBg addSubview:rightArrow];
    
    leftBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, leftArrow.frame.origin.x+leftArrow.frame.size.width, petsBg.frame.size.height) ImageName:@"" Target:self Action:@selector(leftClick) Title:nil];
    [petsBg addSubview:leftBtn];
    
    rightBtn = [MyControl createButtonWithFrame:CGRectMake(rightArrow.frame.origin.x, 0, petsBg.frame.size.width-rightArrow.frame.origin.x, petsBg.frame.size.height) ImageName:@"" Target:self Action:@selector(rightClick) Title:nil];
    [petsBg addSubview:rightBtn];
    
    //436 96
    msgBtn = [MyControl createButtonWithFrame:CGRectMake((cardBg.frame.size.width-436/2.0)/2.0, cardBg.frame.size.height-60, 436/2.0, 96/2.0) ImageName:@"bt_more_green.png" Target:self Action:@selector(msgBtnClick) Title:@"私信"];
    [cardBg addSubview:msgBtn];
}

-(void)modifyUI
{
    if (self.petsDataArray.count<4) {
        leftArrow.hidden = YES;
        rightArrow.hidden = YES;
    }
    
    if (hasHeadImage) {
        hasHeadImage = NO;
    }else{
        if (isMyself) {
            [MyControl setImageForBtn:headBtn Tx:self.userModel.tx isPet:NO isRound:YES];
//            [headBtn setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL, self.userModel.tx]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                if (image) {
//                    [headBtn setBackgroundImage:[MyControl returnSquareImageWithImage:image] forState:UIControlStateNormal];
//                }
//            }];
            
            [msgBtn setTitle:@"修改资料" forState:UIControlStateNormal];
        }else{
            [MyControl setImageForImageView:headImageView Tx:self.userModel.tx isPet:NO isRound:YES];
//            [headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL, self.userModel.tx]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                if (image) {
//                    headImageView.image = [MyControl returnSquareImageWithImage:image];
//                }
//            }];
        }
    }
    
    
    CGSize size1 = [self.userModel.name sizeWithFont:[UIFont boldSystemFontOfSize:17] constrainedToSize:CGSizeMake(cardBg.frame.size.width, 20) lineBreakMode:1];
    nameLabel.frame = CGRectMake(0, 0, size1.width, 20);
    nameLabel.text = self.userModel.name;
    
    sex.frame = CGRectMake(size1.width, 2.5, 15, 15);
    if ([self.userModel.gender intValue] == 1) {
        sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    
    CGRect rect1 = nameBg.frame;
    
    nameBg.frame = CGRectMake((cardBg.frame.size.width-(size1.width+15))/2.0, rect1.origin.y, size1.width+15, 20);
    
    //
    position.text = [ControllerManager returnProvinceAndCityWithCityNum:self.userModel.city];
    
    goldBg.hidden = NO;
    CGSize size2 = [self.userModel.gold sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(cardBg.frame.size.width, 20) lineBreakMode:1];
    CGRect rect2 = goldLabel.frame;
    rect2.size.width = size2.width;
    goldLabel.frame = rect2;
    goldLabel.text = self.userModel.gold;
    
    CGRect rect3 = goldBg.frame;
    rect3.origin.x = (cardBg.frame.size.width-(35+size2.width))/2.0;
    rect3.size.width = 35+size2.width;
    goldBg.frame = rect3;
    
    //94/2 94/2    370/2
    float picWidth = 47.0;
    float arrowSpe = rightArrow.frame.origin.x-leftArrow.frame.origin.x-leftArrow.frame.size.width;
    float spe = (arrowSpe-picWidth*3)/6.0;
    
    
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(leftArrow.frame.origin.x+leftArrow.frame.size.width, (petsBg.frame.size.height-picWidth)/2.0, arrowSpe, picWidth)];
    sv.contentSize = CGSizeMake((picWidth+spe*2)*self.petsDataArray.count, picWidth);
    sv.scrollEnabled = NO;
    sv.showsHorizontalScrollIndicator = NO;
    [petsBg addSubview:sv];
    
    for (int i=0; i<self.petsDataArray.count; i++) {
        UIButton * picBtn = [MyControl createButtonWithFrame:CGRectMake(spe+(spe*2+picWidth)*i, 0, picWidth, picWidth) ImageName:@"" Target:self Action:@selector(picClick:) Title:nil];
        picBtn.tag = 100+i;
        picBtn.layer.cornerRadius = picWidth/2.0;
        picBtn.layer.masksToBounds = YES;
        [picBtn setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PETTXURL, [self.petsDataArray[i] tx]]] forState:UIControlStateNormal  placeholderImage:[UIImage imageNamed:@"defaultPetHead.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (image) {
                [picBtn setBackgroundImage:[MyControl returnSquareImageWithImage:image] forState:UIControlStateNormal];
            }
        }];
        [sv addSubview:picBtn];
        
        if ([[self.petsDataArray[i] master_id] isEqualToString:self.usr_id]) {
            UIImageView * crown = [MyControl createImageViewWithFrame:CGRectMake(picBtn.frame.origin.x+picBtn.frame.size.width-12, picBtn.frame.origin.y+picBtn.frame.size.height-15, 15, 15) ImageName:@"crown.png"];
            [sv addSubview:crown];
            
        }
        
    }
    CGRect rect = sv.frame;
    if (self.petsDataArray.count == 1) {
        rect.origin.x += spe*2+picWidth;
        sv.frame = rect;
    }else if(self.petsDataArray.count ==2){
        float spe2 = (arrowSpe-(spe*2+picWidth)*2)/2.0;
        rect.origin.x = sv.frame.origin.x+spe2;
        sv.frame = rect;
    }
}
-(void)leftClick
{
    float picWidth = 47.0;
    float arrowSpe = rightArrow.frame.origin.x-leftArrow.frame.origin.x-leftArrow.frame.size.width;
    float spe = (arrowSpe-picWidth*3)/6.0;
    
    if (sv.contentOffset.x == 0) {
        [MyControl popAlertWithView:self.view Msg:@"前面木有了~"];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            sv.contentOffset = CGPointMake(sv.contentOffset.x-(spe*2+picWidth), 0);
        }];
    }
}
-(void)rightClick
{
    float picWidth = 47.0;
    float arrowSpe = rightArrow.frame.origin.x-leftArrow.frame.origin.x-leftArrow.frame.size.width;
    float spe = (arrowSpe-picWidth*3)/6.0;
    
    NSLog(@"%f--%f--%f", spe*2+picWidth, sv.contentOffset.x, (spe*2+picWidth)*(self.petsDataArray.count-3));
    if ((spe*2+picWidth)*(self.petsDataArray.count-3) - sv.contentOffset.x < 50) {
        [MyControl popAlertWithView:self.view Msg:@"后面木有了~"];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            sv.contentOffset = CGPointMake(sv.contentOffset.x+(spe*2+picWidth), 0);
        }];
    }
}
-(void)picClick:(UIButton *)btn
{
    NSLog(@"%d", btn.tag);
    int a = btn.tag-100;
    PetMainViewController * vc = [[PetMainViewController alloc] init];
    vc.aid = [self.petsDataArray[a] aid];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)headerClick
{
    ModifyPetOrUserInfoViewController * vc = [[ModifyPetOrUserInfoViewController alloc] init];
    vc.isModifyUser = YES;
    vc.refreshUserInfo = ^(NSString * name, int gender, int city, UIImage * image){
        [sv removeFromSuperview];
        self.userModel.name = name;
        self.userModel.gender = [NSString stringWithFormat:@"%d", gender];
        self.userModel.city = [NSString stringWithFormat:@"%d", city];
        if (image) {
            hasHeadImage = YES;
            if (isMyself) {
                [headBtn setBackgroundImage:image forState:UIControlStateNormal];
            }else{
                headImageView.image = image;
            }
        }
        [self modifyUI];
    };
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)msgBtnClick
{
    if (isMyself) {
        //修改资料
        ModifyPetOrUserInfoViewController * vc = [[ModifyPetOrUserInfoViewController alloc] init];
        vc.isModifyUser = YES;
        vc.refreshUserInfo = ^(NSString * name, int gender, int city, UIImage * image){
            [sv removeFromSuperview];
            self.userModel.name = name;
            self.userModel.gender = [NSString stringWithFormat:@"%d", gender];
            self.userModel.city = [NSString stringWithFormat:@"%d", city];
            if (image) {
                hasHeadImage = YES;
                if (isMyself) {
                    [headBtn setBackgroundImage:image forState:UIControlStateNormal];
                }else{
                    headImageView.image = image;
                }
            }
            [self modifyUI];
        };
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }else{
        //私信
        if (![[USER objectForKey:@"isSuccess"] intValue]) {
            ShowAlertView;
            return;
        }
        NSLog(@"发私信");
        TalkViewController * vc = [[TalkViewController alloc] init];
        vc.friendName = self.userModel.name;
        vc.usr_id = self.usr_id;
        vc.otherTX = self.userModel.tx;
//        NSLog(@"%@--%@--%@", [headerDict objectForKey:@"name"], [headerDict objectForKey:@"usr_id"], [headerDict objectForKey:@"tx"]);
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }
}
-(void)closeBtnClick
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        self.close();
    }];
    
}
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
