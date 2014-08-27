//
//  UserInfoViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoActivityCell.h"
#import "UserInfoRankCell.h"
@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

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
    cellNum = 15;
    
    [self createScrollView];
    [self createFakeNavigation];
    [self createHeader];
    [self createTableView];
    
    
}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(17, 64-17-22, 28, 28) ImageName:@"7-7.png" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"用户资料"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIButton * joinBtn = [MyControl createButtonWithFrame:CGRectMake(320-30-17, 64-23-12, 30, 20) ImageName:@"mail.png" Target:self Action:@selector(joinBtnClick) Title:nil];
    joinBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:joinBtn];
}

#pragma mark - 导航点击事件
-(void)backBtnClick
{
    NSLog(@"back");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)joinBtnClick
{
    NSLog(@"mail");
}
#pragma mark - 创建tableView的tableHeaderView
-(void)createHeader
{
    bgView = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 200)];
    [self.view addSubview:bgView];
    
    //
    bgImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    UIImage * image = [UIImage imageNamed:@"cat1.jpg"];
    bgImageView1.image = [image applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    [bgView addSubview:bgImageView1];
    [bgImageView1 release];
    
    //蒙版
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 200)];
    alphaView.alpha = 0.7;
    alphaView.backgroundColor = [ControllerManager colorWithHexString:@"a85848"];
    [bgView addSubview:alphaView];
    
    //头像
    UIImageView * headerView = [MyControl createImageViewWithFrame:CGRectMake(10, 25, 70, 70) ImageName:@"cat1.jpg"];
    headerView.layer.cornerRadius = 70/2;
    headerView.layer.masksToBounds = YES;
    [bgView addSubview:headerView];

    //等级
    UILabel * exp = [MyControl createLabelWithFrame:CGRectMake(headerView.frame.origin.x+70-20, headerView.frame.origin.y+70-16, 30, 16) Font:10 Text:@"Lv.11"];
    exp.textAlignment = NSTextAlignmentCenter;
    exp.backgroundColor = [UIColor colorWithRed:249/255.0 green:135/255.0 blue:88/255.0 alpha:1];
    exp.textColor = [UIColor colorWithRed:229/255.0 green:79/255.0 blue:36/255.0 alpha:1];
    exp.layer.cornerRadius = 3;
    exp.layer.masksToBounds = YES;
    exp.font = [UIFont boldSystemFontOfSize:10];
    [bgView addSubview:exp];
    
//    UIButton * attentionBtn = [MyControl createButtonWithFrame:CGRectMake(60, 75, 20, 20) ImageName:@"" Target:self Action:@selector(attentionBtnClick) Title:@"关注"];
//    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:10];
//    attentionBtn.layer.cornerRadius = 20/2;
//    attentionBtn.layer.masksToBounds = YES;
//    attentionBtn.backgroundColor = BGCOLOR4;
//    //    attentionBtn.showsTouchWhenHighlighted = YES;
//    [bgView addSubview:attentionBtn];
    
    //
    NSString * str = @"Anna";
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(100, 100) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel * name = [MyControl createLabelWithFrame:CGRectMake(105, 25, size.width+5, 20) Font:15 Text:str];
    [bgView addSubview:name];
    
    UIImageView * sex = [MyControl createImageViewWithFrame:CGRectMake(name.frame.origin.x+name.frame.size.width, 25, 14, 17) ImageName:@"woman"];
    [bgView addSubview:sex];
    
    //
    UILabel * cateNameLabel = [MyControl createLabelWithFrame:CGRectMake(105, 55, 130, 20) Font:14 Text:@"北京市 | 朝阳区"];
    cateNameLabel.font = [UIFont boldSystemFontOfSize:14];
//    cateNameLabel.alpha = 0.65;
    [bgView addSubview:cateNameLabel];
    
    //
    NSString * str2= @"祭司 — 猫君国";
    CGSize size2 = [str2 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 100) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel * positionAndUserName = [MyControl createLabelWithFrame:CGRectMake(105, 170/2, size2.width, 20) Font:15 Text:str2];
    //    positionAndUserName.font = [UIFont boldSystemFontOfSize:15];
    [bgView addSubview:positionAndUserName];
    
    //用户头像，点击进入个人中心
    UIButton * userImageBtn = [MyControl createButtonWithFrame:CGRectMake(positionAndUserName.frame.origin.x+positionAndUserName.frame.size.width+5, 160/2, 30, 30) ImageName:@"cat2.jpg" Target:self Action:@selector(jumpToUserInfo) Title:nil];
    userImageBtn.layer.cornerRadius = 15;
    userImageBtn.layer.masksToBounds = YES;
    [bgView addSubview:userImageBtn];
    
    //123  164
    UIImageView * flagImageView = [MyControl createImageViewWithFrame:CGRectMake(240, 0, 123/2, 164/2) ImageName:@"flag_gold.png"];
    [bgView addSubview:flagImageView];
    
    UILabel * gold = [MyControl createLabelWithFrame:CGRectMake(0, 10, 60, 20) Font:12 Text:@"20000"];
    gold.textAlignment = NSTextAlignmentCenter;
    [flagImageView addSubview:gold];
    
    UIButton * GXList = [MyControl createButtonWithFrame:CGRectMake(0, 0, 62, 70) ImageName:@"" Target:self Action:@selector(GXListClick) Title:@""];
//    GXList.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [flagImageView addSubview:GXList];

    //五角星
    UIImageView * star = [MyControl createImageViewWithFrame:CGRectMake(74/2, 126, 20, 20) ImageName:@"yellow_star.png"];
    [bgView addSubview:star];
    
    NSString * str3= @"Lv.11";
    CGSize size3 = [str3 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 100) lineBreakMode:1];
    UILabel * RQLabel = [MyControl createLabelWithFrame:CGRectMake(64, 130, size3.width, 15) Font:13 Text:str3];
    [bgView addSubview:RQLabel];
    
    UIImageView * RQBgImageView = [MyControl createImageViewWithFrame:CGRectMake(64+size3.width, 132, 350/2, 13) ImageName:@""];
    RQBgImageView.image = [[UIImage imageNamed:@"RQBg.png"] stretchableImageWithLeftCapWidth:37/2 topCapHeight:26/2];
    //边缘处理
    RQBgImageView.layer.cornerRadius = 7;
    RQBgImageView.layer.masksToBounds = YES;
    [bgView addSubview:RQBgImageView];
    
    int length = arc4random()%(350/2);
    //    float length = 3.5/2*70;
    NSLog(@"%f", length/(350.0/2)*100.0);
    UIImageView * RQImageView = [MyControl createImageViewWithFrame:CGRectMake(1, 1, length, 11) ImageName:@""];
    RQImageView.image = [[UIImage imageNamed:@"RQImage.png"] stretchableImageWithLeftCapWidth:26/2 topCapHeight:30/2];
    [RQBgImageView addSubview:RQImageView];
    
    UILabel * RQNumLabel = [MyControl createLabelWithFrame:CGRectMake(50, 0, 75, 13) Font:12 Text:[NSString stringWithFormat:@"%d/100", (int)(length/(350.0/2)*100.0)]];
    RQNumLabel.textAlignment = NSTextAlignmentCenter;
    [RQBgImageView addSubview:RQNumLabel];
    
}

#pragma mark - 跳转点击事件
-(void)jumpToUserInfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)GXListClick
{
    NSLog(@"跳转充值");
}

#pragma mark - 创建scrollView
-(void)createScrollView
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    sv.contentSize = CGSizeMake(320*4, self.view.frame.size.height);
    sv.delegate = self;
    sv.pagingEnabled = YES;
    //为防止和cell的手势冲突需要关闭scrollView的滑动属性。
    sv.scrollEnabled = NO;
    [self.view addSubview:sv];
}

#pragma mark - 创建tableView
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    
    [sv addSubview:tv];
    
    UIView * tvHeaderView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 264)];
    tv.tableHeaderView = tvHeaderView;
    
    //
    tv2 = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    tv2.delegate = self;
    tv2.dataSource = self;
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
    
    NSArray * unSeletedArray = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
    NSArray * seletedArray = @[@"page1_selected.png", @"page2_selected.png", @"page3_selected.png", @"page4_selected.png"];
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
    
    [UIView animateWithDuration:0.2 animations:^{
        bottom.frame = CGRectMake((a-200)*80, 40, 80, 4);
        
        sv.contentOffset = CGPointMake(320*(a-200), 0);
    }];
    
    
    
    if (a == 200) {
        //        sv.contentOffset = CGPointMake(0, 0);
    }else if(a == 201) {
        //        sv.contentOffset = CGPointMake(320, 0);
    }else if(a == 202) {
        //        sv.contentOffset = CGPointMake(320*2, 0);
    }else{
        //        sv.contentOffset = CGPointMake(320*3, 0);
    }
}

#pragma mark - scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
    //        else{
    //        //每次转换tableView后校准header和tool的位置
    //        bgView.frame = CGRectMake(0, 64-scrollView.contentOffset.y, 320, 200);
    //        toolBgView.frame = CGRectMake(0, 64, 320, 44);
    //    }
}
#pragma mark - tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tv4) {
        return 1;
    }else{
        return cellNum;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv) {
        if (indexPath.row == cellNum-1) {
            static NSString * cellID0 = @"ID0";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID0];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[cellID0 autorelease]];
            }
            cell.selectionStyle = 0;
            
            UIButton * button = [MyControl createButtonWithFrame:CGRectMake(40, 8, 240, 35) ImageName:@"" Target:self Action:@selector(addCountry) Title:@"+"];
            [cell addSubview:button];
            button.backgroundColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1];
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:30];
            return cell;
        }
        
        static NSString * cellID = @"ID";
        CountryInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CountryInfoCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor whiteColor];
        //不要忘记指针指向
        cell.delegate = self;
        cell.selectionStyle = 0;
        if (indexPath.row == 0) {
            UIImageView * crown = [MyControl createImageViewWithFrame:CGRectMake(55, 52, 20, 20) ImageName:@"crown.png"];
            [cell addSubview:crown];
        }
        
        return cell;
    }else if (tableView == tv2) {
        static NSString * cellID2 = @"ID2";
        UserInfoRankCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoRankCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = 0;
        [cell modifyWithName:@"吃了么吃了么" sex:2 cate:@"107" age:@"3" position:@"祭司" userName:@"韩梅梅" rank:@"70"];
        return cell;
    }else if (tableView == tv3) {
        static NSString * cellID3 = @"ID3";
        UserInfoActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoActivityCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = 0;
        [cell modifyWithString:@"# 萌宠时装秀 #"];
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
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv) {
        return 100.0f;
    }else if(tableView == tv2){
        return 70.0f;
    }else if (tableView == tv3) {
        return 200.0f;
    }else{
        return 15+10*100;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tv) {
        NSLog(@"%d", indexPath.row);
    }
}

#pragma mark - cell代理
-(void)swipeTableViewCell:(CountryInfoCell *)cell didClickButtonWithIndex:(NSInteger)index
{
    if (sv.contentOffset.x == 0) {
        if (index == 1) {
            //退出国家
            NSIndexPath * cellIndexPath = [tv indexPathForCell:cell];
            cellNum -= 1;
            [tv deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }else if(index == 2){
            //切换并置顶
            
        }
    }
}
#pragma mark -
//礼物点击事件
-(void)buttonClick:(UIButton *)btn
{
    NSLog(@"%d", btn.tag);
}
-(void)addCountry
{
    NSLog(@"加入国家");
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

@end
