//
//  SearchFamilyViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "SearchFamilyViewController.h"
#import "PetInfoModel.h"
#import "PetInfoViewController.h"
#import "RegisterViewController.h"
#import "SearchCell.h"
#import "ChooseFamilyDetailCell.h"

@interface SearchFamilyViewController ()

@end

@implementation SearchFamilyViewController

-(void)viewDidAppear:(BOOL)animated
{
    if ([[USER objectForKey:@"isSearchFamilyShouldDismiss"] intValue]) {
        [USER setObject:@"0" forKey:@"isSearchFamilyShouldDismiss"];
        [self dismissViewControllerAnimated:NO completion:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"af" object:nil];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    didSelected = -1;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    self.tempDataArray =[NSMutableArray arrayWithCapacity:0];
    
    [self createBg];
//    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
//    [self.view addSubview:bgView];
    
//    [self createFakeNavigation];
    [self createHeader];
    [self createTableView];
    if ([[USER objectForKey:@"isSuccess"] intValue]) {
        [self loadUserPetsList];
    }
    //监听中文输入
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextChangeNotification" object:tf];
}
-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
//    NSString * docDir = DOCDIR;
    NSString * filePath = BLURBG;
    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"%@", data);
    UIImage * image = [UIImage imageWithData:data];
    bgImageView.image = image;
    
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:tempView];
}
#pragma mark - 加载用户数据
-(void)loadUserPetsList
{
    StartLoading;
    NSString * code = [NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"UserPetsList:%@", load.dataDict);
            self.userPetsListArray = [load.dataDict objectForKey:@"data"];
            LoadingSuccess;
        }else{
            LoadingFailed;
        }
    }];
    [request release];
}

#pragma mark - 加载数据
//参数name不需要加密
- (void)loadSearchData:(NSString *)name
{
    StartLoading;
    
    NSString *searchSig = [MyMD5 md5:[NSString stringWithFormat:@"dog&cat"]];
    NSString *searchString = [NSString stringWithFormat:@"%@&name=%@&sig=%@&SID=%@", SEARCHAPI, [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], searchSig,[ControllerManager getSID]];
    NSLog(@"搜索API:%@",searchString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:searchString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        NSLog(@"搜索结果：%@",load.dataDict);
        [self.tempDataArray removeAllObjects];
        if (isFinish) {
            NSArray *array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary *dict in array) {
                PetInfoModel *model = [[PetInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.tempDataArray addObject:model];
                [model release];
            }
            [self removeUserPets];
            [tv reloadData];
            LoadingSuccess;
        }else{
            LoadingFailed;
        }
    }];
    [request release];
}
#pragma mark - 剔除用户的宠物
-(void)removeUserPets
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        return;
    };
    //self.limitDataArray
    for (int i=0; i<self.tempDataArray.count; i++) {
        for (int j=0; j<self.userPetsListArray.count; j++) {
            if ([[self.tempDataArray[i] aid] isEqualToString:[self.userPetsListArray[j] objectForKey:@"aid"]]) {
                [self.tempDataArray removeObjectAtIndex:i];
                i--;
                break;
            }
        }
    }
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
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"选择王国"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIView * line0 = [MyControl createViewWithFrame:CGRectMake(0, 63, 320, 1)];
    line0.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.1];
    [navView addSubview:line0];
}

-(void)createHeader
{
    UIView * headerView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:headerView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.backgroundColor = BGCOLOR;
    alphaView.alpha = 0.85;
    [headerView addSubview:alphaView];
    
    UIImageView * search = [MyControl createImageViewWithFrame:CGRectMake(10, 13+29, 14, 13) ImageName:@"5-5.png"];
    [headerView addSubview:search];
    
    tf = [MyControl createTextFieldWithFrame:CGRectMake(30, 10+29, 480/2, 20) placeholder:@"" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    tf.borderStyle = 0;
    tf.returnKeyType = UIReturnKeyDone;
//    tf.backgroundColor = BGCOLOR;
    tf.clearButtonMode = UITextFieldViewModeAlways;
    tf.delegate = self;
    tf.textColor = [UIColor whiteColor];
    [headerView addSubview:tf];
    
    UIView * lineView = [MyControl createViewWithFrame:CGRectMake(10, 28+29, 30+460/2, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:246/255.0 green:189/255.0 blue:142/255.0 alpha:1];
    [headerView addSubview:lineView];
    
    cancelBtn = [MyControl createButtonWithFrame:CGRectMake(320-45, 8+29, 45, 20) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:@"取消"];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelBtn.showsTouchWhenHighlighted = YES;
    [headerView addSubview:cancelBtn];
}


-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.backgroundColor = [UIColor clearColor];
    tv.separatorStyle = 0;
    [self.view addSubview:tv];
}
#pragma mark - tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == didSelected) {
        return 1;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tempDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    ChooseFamilyDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[ChooseFamilyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
        UIButton * headBtn = [MyControl createButtonWithFrame:CGRectMake(410/2, 20, 55, 55) ImageName:@"" Target:self Action:@selector(headBtnClick) Title:nil];
        headBtn.layer.cornerRadius = 55/2;
        headBtn.layer.masksToBounds = YES;
        [cell addSubview:headBtn];
    }
    cell.selectionStyle = 0;
    cell.backgroundColor = [ControllerManager colorWithHexString:@"f4c6a2"];
    /**************/
    //    NSLog(@"--%@", self.cardDict);
    [cell configUI:self.cardDict];
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PetInfoModel * model = self.tempDataArray[section];
    UIView * headerBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 70)];
    //    headerBgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * headImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 10, 50, 50) ImageName:@"defaultPetHead.png"];
    headImageView.layer.cornerRadius = headImageView.frame.size.width/2;
    headImageView.layer.masksToBounds = YES;
    [headerBgView addSubview:headImageView];
    /**************************/
    //    NSLog(@"--%@", model.tx);
    if (!([model.tx isKindOfClass:[NSNull class]] || [model.tx length]==0)) {
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
        //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
        if (image) {
            headImageView.image = [MyControl image:image fitInSize:CGSizeMake(100, 100)];
        }else{
            //下载头像
            NSLog(@"%@", [NSString stringWithFormat:@"%@%@", PETTXURL, model.tx]);
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, model.tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    headImageView.image = [MyControl image:load.dataImage fitInSize:CGSizeMake(100, 100)];
                    NSString * docDir = DOCDIR;
                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
                    [load.data writeToFile:txFilePath atomically:YES];
                }else{
                    NSLog(@"头像下载失败");
                }
            }];
            [request release];
        }
    }
    
    /**************************/
    
    
    UIImageView * sex = [MyControl createImageViewWithFrame:CGRectMake(80, 10, 34/2, 34/2) ImageName:@"man.png"];
    if ([model.gender intValue] == 2) {
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    [headerBgView addSubview:sex];
    
    UILabel * name = [MyControl createLabelWithFrame:CGRectMake(100, 10, 150, 20) Font:15 Text:@""];
    name.textColor = BGCOLOR;
    name.text = model.name;
    [headerBgView addSubview:name];
    
    UILabel * nameAndAgeLabel = [MyControl createLabelWithFrame:CGRectMake(80, 30, 150, 15) Font:13 Text:@"索马利猫 | 3岁"];
    nameAndAgeLabel.textColor = [UIColor blackColor];
    nameAndAgeLabel.text = [NSString stringWithFormat:@"%@ | %@", [ControllerManager returnCateNameWithType:model.type], [MyControl returnAgeStringWithCountOfMonth:model.age]];
    [headerBgView addSubview:nameAndAgeLabel];
    
    UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(80, 52, 70, 15) Font:12 Text:@"总人气 500"];
    rq.text = [NSString stringWithFormat:@"总人气 %@", model.t_rq];
    rq.textColor = [UIColor lightGrayColor];
    [headerBgView addSubview:rq];
    
    UILabel * memberNum = [MyControl createLabelWithFrame:CGRectMake(155, 52, 70, 15) Font:12 Text:@"|    成员 188"];
    memberNum.text = [NSString stringWithFormat:@"|    成员 %@", model.fans];
    memberNum.textColor = [UIColor lightGrayColor];
    [headerBgView addSubview:memberNum];
    
    UIButton * showOrHideBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, 65) ImageName:@"" Target:self Action:@selector(showOrHideBtnClick:) Title:nil];
    showOrHideBtn.tag = 100+section;
    [headerBgView addSubview:showOrHideBtn];
    
    UIButton * join = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-56-10, (70-36)/2, 56, 36) ImageName:@"recom_p.png" Target:self Action:@selector(joinClick:) Title:nil];
    //    join.titleLabel.font = [UIFont systemFontOfSize:14];
    //    join.backgroundColor = GREEN;
    //    join.layer.cornerRadius = 5;
    //    join.layer.masksToBounds = YES;
    [headerBgView addSubview:join];
    join.tag = 200+section;
    
    UIView * whiteLine = [MyControl createViewWithFrame:CGRectMake(0, 69, 320, 1)];
    whiteLine.backgroundColor = [UIColor whiteColor];
    [headerBgView addSubview:whiteLine];
    return headerBgView;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125.0f;
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PetInfoModel *model = self.tempDataArray[indexPath.row];
//    if (![ControllerManager getIsSuccess]) {
//        RegisterViewController *registerVC = [[RegisterViewController alloc] init];
//        registerVC.isAdoption = YES;
//        registerVC.petInfoModel =model;
//        [self presentViewController:registerVC animated:YES completion:^{
//            [registerVC release];
//        }];
//    }
//    NSLog(@"跳转到注册：%@",model.aid);
}
-(void)showOrHideBtnClick:(UIButton *)button
{
    NSLog(@"%d", button.tag);
    if (didSelected == button.tag-100) {
        didSelected = -1;
        [tv reloadData];
    }else{
        didSelected = button.tag-100;
        [self loadCardDataWithTag:didSelected];
    }
}
-(void)loadCardDataWithTag:(int)Tag
{
    NSDictionary * dic = [self.detailDict objectForKey:[self.tempDataArray[didSelected] aid]];
    if (dic) {
        self.cardDict = dic;
        [tv reloadData];
    }else{
        NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", [self.tempDataArray[didSelected] aid]];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETCARDAPI, [self.tempDataArray[didSelected] aid], [MyMD5 md5:code], [ControllerManager getSID]];
        NSLog(@"%@", url);
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                NSLog(@"%@", load.dataDict);
                [self.detailDict setObject:[load.dataDict objectForKey:@"data"] forKey:[self.tempDataArray[didSelected] aid]];
                //
                self.cardDict = [load.dataDict objectForKey:@"data"];
                [tv reloadData];
            }
        }];
        [request release];
    }
}
-(void)joinClick:(UIButton *)button
{
    NSLog(@"join-%d", button.tag-200);
    
    if ([[USER objectForKey:@"isSuccess"] intValue]) {
        
        //给出加入提示
        AlertView * view = [[AlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        view.AlertType = 2;
        [view makeUI];
        view.jump = ^(){
            [MyControl startLoadingWithStatus:@"加入中..."];
            
            PetInfoModel * model = self.tempDataArray[button.tag-200];
            NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", model.aid];
            NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", JOINFAMILYAPI, model.aid, [MyMD5 md5:code], [ControllerManager getSID]];
            NSLog(@"%@", url);
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    NSLog(@"--%@", load.dataDict);
                    [MyControl loadingSuccessWithContent:@"加入成功^_^" afterDelay:0.5f];
                    //捧Ta成功界面
                    NoCloseAlert * noClose = [[NoCloseAlert alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                    noClose.confirm = ^(){
                        [USER setObject:@"1" forKey:@"isChooseInShouldDismiss"];
                        [USER setObject:@"1" forKey:@"isChooseFamilyShouldDismiss"];
                        [self dismissViewControllerAnimated:NO completion:nil];
                    };
                    [self.view addSubview:noClose];
                    NSString * percent = [NSString stringWithFormat:@"%@", [[load.dataDict objectForKey:@"data"] objectForKey:@"percent"]];
                    [noClose configUIWithTx:model.tx Name:model.name Percent:percent];
                    [UIView animateWithDuration:0.3 animations:^{
                        noClose.alpha = 1;
                    }];
                }else{
                    [MyControl loadingFailedWithContent:@"加入失败-_-!" afterDelay:0.5f];
                }
            }];
            [request release];
            
        };
        [self.view addSubview:view];
        [view release];
        
    }else{
        RegisterViewController * vc = [[RegisterViewController alloc] init];
        vc.isAdoption = YES;
        vc.petInfoModel = self.tempDataArray[button.tag-200];
        [self presentViewController:vc animated:YES completion:nil];
        [vc release];
    }
    
}
-(void)headBtnClick
{
    NSLog(@"click row:%d", didSelected);
}
-(void)backBtnClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"af" object:nil];
}
-(void)cancelBtnClick
{
    NSLog(@"cancel");
    [tf resignFirstResponder];
    if ([cancelBtn.titleLabel.text isEqualToString:@"取消"]) {
//       [[NSNotificationCenter defaultCenter] postNotificationName:@"af" object:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
        NSLog(@"start search!");
        [self loadSearchData:tf.text];
        [tf resignFirstResponder];
    }
}

//-(void)textFiledEditChanged:(NSNotification *)noti
//{
//    NSString * toBeString = tf.text;
//    NSString * lang = [[UITextInputMode currentInputMode] primaryLanguage];
//    if ([lang isEqualToString:@"zh-Hans"]) {
//        UITextRange * selectedRange = [tf markedTextRange];
//        //获取高亮部分
//        UITextPosition * position = [tf positionFromPosition:selectedRange.start offset:0];
//    }
//}
#pragma mark - textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    have = 1;
    //    [tv reloadData];
    
//    [self loadSearchData:textField.text];
    [tf resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [tf resignFirstResponder];
    [self.tempDataArray removeAllObjects];
    [self.tempDataArray addObjectsFromArray:self.dataArray];
    [tv reloadData];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //string是最新输入的文字，textField的长度及字符要落后一个操作。
    if (![string isEqualToString:@""]) {
        [cancelBtn setTitle:@"搜索" forState:UIControlStateNormal];
    }else if(textField.text.length == 1){
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    if ([cancelBtn.titleLabel.text isEqualToString:@"搜索"]) {
        if ([string isEqualToString:@""]) {
            self.tfString = [self.tfString substringToIndex:textField.text.length-1];
        }else{
            self.tfString = [NSString stringWithFormat:@"%@%@", textField.text, string];
        }
        
    }else{
        self.tfString = nil;
    }
//    NSLog(@"%@--%d--%@--%@", textField.text, textField.text.length, string, self.tfString);
    
//    [self selectData];
    return YES;
}
-(void)selectData
{
    [self.tempDataArray removeAllObjects];
    if (self.tfString == nil) {
        [self.tempDataArray addObjectsFromArray:self.dataArray];
    }else{
        for (int i=0; i<self.dataArray.count; i++) {
            if ([self.dataArray[i] rangeOfString:self.tfString].location != NSNotFound) {
                [self.tempDataArray addObject:self.dataArray[i]];
            }
        }
    }
    [tv reloadData];
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
