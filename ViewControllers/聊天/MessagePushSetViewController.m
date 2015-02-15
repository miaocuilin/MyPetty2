//
//  MessagePushSetViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/1/11.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "MessagePushSetViewController.h"
#import "EMChatServiceDefs.h"
#import "EMPushNotificationOptions.h"
#import "WCAlertView.h"
#import "EaseMob.h"

@interface MessagePushSetViewController () <UITableViewDataSource,UITableViewDelegate>
{
    EMPushNotificationDisplayStyle _pushDisplayStyle;
    BOOL _isNoDisturbing;
    NSInteger _noDisturbingStart;
    NSInteger _noDisturbingEnd;
    NSString *_nickName;
    UITableView * tv;
}
@property (strong, nonatomic) UISwitch *pushDisplaySwitch;
@end

@implementation MessagePushSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _noDisturbingStart = -1;
    _noDisturbingEnd = -1;
    
    [self createBg];
    [self createFakeNavigation];
    [self createTableView];
    
    [self refreshPushOptions];
    [tv reloadData];
}
-(void)createBg
{
    UIImageView * blurBg = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:blurBg];
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    alphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [self.view addSubview:alphaView];
}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 22, 60, 40) ImageName:@"" Target:self Action:@selector(leftBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"消息推送设置"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(navView.frame.size.width-40-17, 32, 50, 17)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    saveButton.showsTouchWhenHighlighted = YES;
    [saveButton addTarget:self action:@selector(savePushOptions) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:saveButton];
}
-(void)leftBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    tv.backgroundColor = [UIColor clearColor];
    tv.separatorStyle = 0;
    [self.view addSubview:tv];
}

#pragma mark - getter
- (UISwitch *)pushDisplaySwitch
{
    if (_pushDisplaySwitch == nil) {
        _pushDisplaySwitch = [[UISwitch alloc] init];
        [_pushDisplaySwitch addTarget:self action:@selector(pushDisplayChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _pushDisplaySwitch;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return 3;
    }
    
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return YES;
    }
    
    return NO;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(20, 0, 100, 20) Font:15 Text:@"    功能消息免打扰"];
        label.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        label.textColor = [UIColor blackColor];
//        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    return nil;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 1) {
//        return @"功能消息免打扰";
//    }
//    return nil;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"通知显示消息详情";
            
            self.pushDisplaySwitch.frame = CGRectMake(tv.frame.size.width - self.pushDisplaySwitch.frame.size.width - 10, (cell.contentView.frame.size.height - self.pushDisplaySwitch.frame.size.height) / 2, self.pushDisplaySwitch.frame.size.width, self.pushDisplaySwitch.frame.size.height);
            [cell.contentView addSubview:self.pushDisplaySwitch];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"开启";
            
            BOOL isOn = _isNoDisturbing;
            if (_noDisturbingStart == 0 && _noDisturbingEnd == 24) {
                isOn = YES;
            }
            else{
                isOn = NO;
            }
            cell.accessoryType = isOn == YES ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"只在夜间开启 (22:00 - 7:00)";
            
            BOOL isOn = _isNoDisturbing;
            if (_noDisturbingStart == 22 && _noDisturbingEnd == 7) {
                isOn = YES;
            }
            else{
                isOn = NO;
            }
            cell.accessoryType = isOn == YES ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"关闭";
            cell.accessoryType = _isNoDisturbing == YES ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 30;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL needReload = YES;
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                needReload = NO;
                [WCAlertView showAlertWithTitle:@"设置提醒"
                                        message:@"此设置会导致全天都处于免打扰模式, 不会再收到推送消息. 是否继续?"
                             customizationBlock:^(WCAlertView *alertView) {
                             } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                 switch (buttonIndex) {
                                     case 0: {
                                     } break;
                                     default: {
                                         self->_noDisturbingStart = 0;
                                         self->_noDisturbingEnd = 24;
                                         self->_isNoDisturbing = YES;
                                         [tableView reloadData];
                                     } break;
                                 }
                             } cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            } break;
            case 1:
            {
                _noDisturbingStart = 22;
                _noDisturbingEnd = 7;
                _isNoDisturbing = YES;
            }
                break;
            case 2:
            {
                _noDisturbingStart = -1;
                _noDisturbingEnd = -1;
                _isNoDisturbing = NO;
            }
                break;
                
            default:
                break;
        }
        
        if (needReload) {
            [tableView reloadData];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
}

#pragma mark - action

- (void)savePushOptions
{
    BOOL isUpdate = NO;
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    if (_pushDisplayStyle != options.displayStyle) {
        options.displayStyle = _pushDisplayStyle;
        isUpdate = YES;
    }
    
    if (_nickName && _nickName.length > 0 && ![_nickName isEqualToString:options.nickname])
    {
        options.nickname = _nickName;
        isUpdate = YES;
    }
    if (_isNoDisturbing != options.noDisturbing || options.noDisturbingStartH != _noDisturbingStart || options.noDisturbingEndH != _noDisturbingEnd){
        isUpdate = YES;
        options.noDisturbing = _isNoDisturbing;
        options.noDisturbingStartH = _noDisturbingStart;
        options.noDisturbingEndH = _noDisturbingEnd;
    }
    
    if (isUpdate) {
        [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushDisplayChanged:(UISwitch *)pushDisplaySwitch
{
    if (pushDisplaySwitch.isOn) {
#warning 此处设置详情显示时的昵称，比如_nickName = @"环信";
        _pushDisplayStyle = ePushNotificationDisplayStyle_messageSummary;
    }
    else{
        _pushDisplayStyle = ePushNotificationDisplayStyle_simpleBanner;
    }
}

- (void)refreshPushOptions
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    NSLog(@"%d", options.displayStyle);
    _nickName = options.nickname;
    _pushDisplayStyle = options.displayStyle;
    NSLog(@"%d", _pushDisplayStyle);
    _isNoDisturbing = options.noDisturbing;
    if (_isNoDisturbing) {
        _noDisturbingStart = options.noDisturbingStartH;
        _noDisturbingEnd = options.noDisturbingEndH;
    }
    
    BOOL isDisplayOn = _pushDisplayStyle == ePushNotificationDisplayStyle_simpleBanner ? NO : YES;
    [self.pushDisplaySwitch setOn:isDisplayOn animated:YES];
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
