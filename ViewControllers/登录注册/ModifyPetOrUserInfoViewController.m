//
//  ModifyPetOrUserInfoViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-10-13.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ModifyPetOrUserInfoViewController.h"

#import "ASIFormDataRequest.h"
#import "IQKeyboardManager.h"
#import "OpenUDID.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <AviarySDK/AviarySDK.h>

static NSString * const kAFAviaryAPIKey = @"b681eafd0b581b46";
static NSString * const kAFAviarySecret = @"389160adda815809";

@interface ModifyPetOrUserInfoViewController () <AFPhotoEditorControllerDelegate>
{
    ASIFormDataRequest * _request;
    ASIFormDataRequest * _requestUser;
}
@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;
@end

@implementation ModifyPetOrUserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Allocate Asset Library
    ALAssetsLibrary * assetLibrary = [[ALAssetsLibrary alloc] init];
    [self setAssetLibrary:assetLibrary];
    
    // Allocate Sessions Array
    NSMutableArray * sessions = [NSMutableArray new];
    [self setSessions:sessions];
    [sessions release];
    
    // Start the Aviary Editor OpenGL Load
    [AFOpenGLManager beginOpenGLLoad];
    
    self.catArray = [NSMutableArray arrayWithCapacity:0];
    self.dogArray = [NSMutableArray arrayWithCapacity:0];
    self.otherArray = [NSMutableArray arrayWithCapacity:0];
    self.cateArray = @[@"喵喵", @"汪汪"];
    self.u_city = 1000;
    
    typeTag = 1;
    self.cateName = @"喵喵";
    self.detailName = @"布偶猫";
    
    [self createBg];
    [self createIQ];
    [self loadCateNameList];
    [self getCityData];
    
    [self createUI];
    [self createFakeNavigation];
}
-(void)createBg
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:imageView];
//    bgBlurImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
//    [self.view addSubview:bgBlurImageView];
//    //    self.bgImageView.backgroundColor = [UIColor redColor];
////    NSString * docDir = DOCDIR;
//    NSString * filePath = BLURBG;
//    NSLog(@"%@", filePath);
//    NSData * data = [NSData dataWithContentsOfFile:filePath];
//    //    NSLog(@"%@", data);
//    UIImage * image = [UIImage imageWithData:data];
//    bgBlurImageView.image = image;
//    
//    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
//    [self.view addSubview:tempView];
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
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"修改资料"];
    if(!self.isModifyUser){
        titleLabel.text = @"修改萌星资料";
    }
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}

-(void)backBtnClick
{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createIQ
{
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
	//Enabling autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard.
	[[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
	//Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
	[[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //Resign textField if touched outside of UITextField/UITextView.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}

#pragma mark - 获取并分析地区数据
-(void)getCityData
{
    //获取本地plist文件
    NSBundle *bundle = [NSBundle mainBundle];
	NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
	areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    //将所有key取出进行排序
    NSArray *components = [areaDic allKeys];
    //    NSLog(@"%@", components);
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
	NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        //        NSLog(@"%@", sortedArray[i]);
        NSString *index = [sortedArray objectAtIndex:i];
        //        NSLog(@"%@", index);
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        //        NSLog(@"%@", tmp);
        //省份，就一个，所以取第0个元素
        [provinceTmp addObject: [tmp objectAtIndex:0]];
        
    }
    
    //province中含有各个省的名称，供picker第一列用
    province = [[NSArray alloc] initWithArray: provinceTmp];
    [provinceTmp release];

    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    //取出所有市区的键值
    NSArray * cityArray = [dic allKeys];
    //城市key值排序
    NSArray *sortedArray2 = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;//递减
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;//上升
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    //从排序后的key值，取出相应value
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray2 count]; i++) {
        NSString *index = [sortedArray2 objectAtIndex:i];
        NSArray *temp = [[dic objectForKey: index] allKeys];
        [array addObject: [temp objectAtIndex:0]];
    }
    
    [city release];
    city = [[NSArray alloc] initWithArray: array];
    [array release];
    
    selectedProvince = [province objectAtIndex: 0];
    
}
-(void)loadCateNameList
{
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CateNameList" ofType:@"plist"]];
    NSLog(@"%@", dataDic);
    //将数据存到数组中
    NSDictionary * dict1 = [dataDic objectForKey:@"1"];
    NSDictionary * dict2 = [dataDic objectForKey:@"2"];
    NSDictionary * dict3 = [dataDic objectForKey:@"3"];
    
    for (int i=0; i<[dict1 count]; i++) {
        NSString * str = [dict1 objectForKey:[NSString stringWithFormat:@"%d", 100+i+1]];
        [self.catArray addObject:str];
    }
    for (int i=0; i<[dict2 count]; i++) {
        NSString * str = [dict2 objectForKey:[NSString stringWithFormat:@"%d", 200+i+1]];
        [self.dogArray addObject:str];
    }
    for (int i=0; i<[dict3 count]; i++) {
        NSString * str = [dict3 objectForKey:[NSString stringWithFormat:@"%d", 300+i+1]];
        [self.otherArray addObject:str];
    }
    self.tempArray = self.catArray;
    count = self.catArray.count;
}

#pragma mark - createUI
#pragma mark - 搭建界面
-(void)createUI
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    sv.contentSize = CGSizeMake(sv.frame.size.width*2, sv.frame.size.height);
    sv.pagingEnabled = YES;
    sv.scrollEnabled = NO;
    sv.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:sv];
    
    if (self.isModifyUser) {
        sv.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    }
    
    /***************第一页********************/
    UIView * miBgView = [MyControl createViewWithFrame:CGRectMake(20, 326/2, 280, 490/2)];
    miBgView.backgroundColor = [ControllerManager colorWithHexString:@"fca283"];
    miBgView.alpha = 0.6;
    miBgView.layer.cornerRadius = 5;
    miBgView.layer.masksToBounds = YES;
    [sv addSubview:miBgView];
    
    
    
    UIImageView * roundImageView = [MyControl createImageViewWithFrame:CGRectMake(108.5, 326/2-116/2, 217/2, 116/2) ImageName:@"4-3.png"];
    [sv addSubview:roundImageView];
    
    photoButton = [MyControl createButtonWithFrame:CGRectMake(105+(116-80)/2, 42+18+64-5, 80, 80) ImageName:@"camaraHead.png" Target:self Action:@selector(photoButtonClick) Title:nil];
    photoButton.layer.cornerRadius = 40;
    photoButton.layer.masksToBounds = YES;
    [sv addSubview:photoButton];
    
    /**************************/
    if (!([self.petInfoModel.tx isKindOfClass:[NSNull class]] || [self.petInfoModel.tx length]==0)) {
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.petInfoModel.tx]];
        //        NSLog(@"--%@--", txFilePath);
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
        if (image) {
            [photoButton setBackgroundImage:image forState:UIControlStateNormal];
        }else{
            //下载头像
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", USERTXURL, self.petInfoModel.tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    [photoButton setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                    NSString * docDir = DOCDIR;
                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.petInfoModel.tx]];
                    [load.data writeToFile:txFilePath atomically:YES];
                }else{
                    NSLog(@"头像下载失败");
                }
            }];
            [request release];
        }
    }
    
    /**************************/
    
    UILabel * miTitle = [MyControl createLabelWithFrame:CGRectMake(100, 205, 120, 20) Font:18 Text:@"萌星档案"];
    miTitle.textAlignment = NSTextAlignmentCenter;
    [sv addSubview:miTitle];
    
    
    girl = [MyControl createButtonWithFrame:CGRectMake(110, miBgView.frame.origin.y+205, 30, 30) ImageName:@"3-5.png" Target:self Action:@selector(girlButtonClick) Title:nil];
    //    girl.selected = YES;
    [girl setBackgroundImage:[UIImage imageNamed:@"3-4.png"] forState:UIControlStateSelected];
    [sv addSubview:girl];
    
    boy = [MyControl createButtonWithFrame:CGRectMake(180, miBgView.frame.origin.y+205, 30, 30) ImageName:@"3-7.png" Target:self Action:@selector(boyButtonClick) Title:nil];
    [boy setBackgroundImage:[UIImage imageNamed:@"3-6.png"] forState:UIControlStateSelected];
    [sv addSubview:boy];
    
    /*******/
    if (!self.isModifyUser) {
        if ([self.petInfoModel.gender intValue] == 1) {
            boy.selected = YES;
            girl.selected = NO;
        }else{
            boy.selected = NO;
            girl.selected = YES;
        }
    }
    
    /*******/
    
    bgView2 = [MyControl createViewWithFrame:CGRectMake(0, 75, 280, 120)];
    [miBgView addSubview:bgView2];
    
    NSArray * nameArray = @[@"名字" ,@"种族", @"年龄"];
    for(int i=0;i<3;i++){
        UIImageView * bgImageView = [MyControl createImageViewWithFrame:CGRectMake(30, i*40, 220, 30) ImageName:@"4和5页面通用.png"];
        bgImageView.layer.cornerRadius = 10;
        bgImageView.layer.masksToBounds = YES;
        [bgView2 addSubview:bgImageView];
        bgImageView.tag = 1000+i;
        
        UILabel * nameLabel = [MyControl createLabelWithFrame:CGRectMake(5, 5, 60, 20) Font:15 Text:nameArray[i]];
        nameLabel.textColor = [UIColor grayColor];
        [bgImageView addSubview:nameLabel];
        
        if (i == 0) {
            tf = [MyControl createTextFieldWithFrame:CGRectMake(40, 5, 140, 20) placeholder:@"请输入爱宠的名字" passWord:NO leftImageView:nil rightImageView:nil Font:13];
            tf.delegate = self;
            tf.borderStyle = 0;
            tf.returnKeyType = UIReturnKeyDone;
            tf.backgroundColor = [UIColor clearColor];
            [bgImageView addSubview:tf];
            
            //
            if (!self.isModifyUser) {
                tf.text = self.petInfoModel.name;
            }
            
            UIImageView * keyboard = [MyControl createImageViewWithFrame:CGRectMake(180, 6, 25, 17) ImageName:@"3-2-2.png"];
            [bgImageView addSubview:keyboard];
        }else if(i == 1){
            fromTF = [MyControl createTextFieldWithFrame:CGRectMake(40, 5, 140, 20) placeholder:@"点击选择爱宠种类" passWord:NO leftImageView:nil rightImageView:nil Font:13];
            fromTF.delegate = self;
            fromTF.borderStyle = 0;
            fromTF.backgroundColor = [UIColor clearColor];
            [bgImageView addSubview:fromTF];
            
            if (!self.isModifyUser) {
                fromTF.text = [ControllerManager returnCateNameWithType:self.petInfoModel.type];
                type = [self.petInfoModel.type intValue];
            }
            
            UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(185, 5, 15, 20) ImageName:@"扩展更多图标.png"];
            [bgImageView addSubview:arrow];
        }else{
            UIView * keyboardBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 40)];
            keyboardBgView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
            UIButton * finish2Button = [MyControl createButtonWithFrame:CGRectMake(320-70, 5, 50, 30) ImageName:@"" Target:self Action:@selector(finish2ButtonClick) Title:@"完成"];
            [keyboardBgView addSubview:finish2Button];
            
            ageTextField = [MyControl createTextFieldWithFrame:CGRectMake(40, 5, 140, 20) placeholder:@"点击选择爱宠的年龄" passWord:NO leftImageView:nil rightImageView:nil Font:13];
            ageTextField.delegate = self;
            ageTextField.borderStyle = 0;
            ageTextField.backgroundColor = [UIColor clearColor];
            ageTextField.keyboardType = UIKeyboardTypeNumberPad;
            ageTextField.inputAccessoryView = keyboardBgView;
            [bgImageView addSubview:ageTextField];
            
            if (!self.isModifyUser) {
                ageTextField.text = [MyControl returnAgeStringWithCountOfMonth:self.petInfoModel.age];
                year = [self.petInfoModel.age intValue]/12;
                month = [self.petInfoModel.age intValue]%12;
            }
            UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(185, 5, 15, 20) ImageName:@"扩展更多图标.png"];
            [bgImageView addSubview:arrow];
        }
    }
    
    finishButton = [MyControl createButtonWithFrame:CGRectMake(20+20, 425, 240, 35) ImageName:@"" Target:self Action:@selector(finishButtonClick:) Title:@"完成"];
    finishButton.backgroundColor = ORANGE;
    finishButton.layer.cornerRadius = 5;
    finishButton.layer.masksToBounds = YES;
    finishButton.showsTouchWhenHighlighted = YES;
    [sv addSubview:finishButton];
    
    /***************新界面第二页********************/
    
    UIView * userBgView = [MyControl createViewWithFrame:CGRectMake(320+20, 100+64, 280, 490/2)];
    userBgView.backgroundColor = [ControllerManager colorWithHexString:@"fca283"];
    userBgView.alpha = 0.6;
    userBgView.layer.cornerRadius = 5;
    userBgView.layer.masksToBounds = YES;
    [sv addSubview:userBgView];
    
    UIImageView * roundImageView2 = [MyControl createImageViewWithFrame:CGRectMake(320+108.5, 100-116/2+64, 217/2, 116/2) ImageName:@"4-3.png"];
    [sv addSubview:roundImageView2];
    
    photoButton2 = [MyControl createButtonWithFrame:CGRectMake(320+105+(116-80)/2, 42+18+64-5, 80, 80) ImageName:@"camaraHead.png" Target:self Action:@selector(photoButtonClick2) Title:nil];
    photoButton2.layer.cornerRadius = 40;
    photoButton2.layer.masksToBounds = YES;
    [sv addSubview:photoButton2];
    /**************************/
    if ([ControllerManager getIsSuccess] && !([[USER objectForKey:@"tx"] isKindOfClass:[NSNull class]] || [[USER objectForKey:@"tx"] length]==0)) {
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [USER objectForKey:@"tx"]]];
        //        NSLog(@"--%@--", txFilePath);
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
        if (image) {
            [photoButton2 setBackgroundImage:image forState:UIControlStateNormal];
        }else{
            //下载头像
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", USERTXURL, [USER objectForKey:@"tx"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    [photoButton2 setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                    NSString * docDir = DOCDIR;
                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [USER objectForKey:@"tx"]]];
                    [load.data writeToFile:txFilePath atomically:YES];
                }else{
                    NSLog(@"头像下载失败");
                }
            }];
            [request release];
        }
    }
    
    /**************************/
    
    UILabel * userTitle = [MyControl createLabelWithFrame:CGRectMake(320+100, 205, 120, 20) Font:18 Text:@"经纪人档案"];
    userTitle.textAlignment = NSTextAlignmentCenter;
    [sv addSubview:userTitle];
    
    bgView3 = [MyControl createViewWithFrame:CGRectMake(0, 75, 280, 120)];
    [userBgView addSubview:bgView3];
    
    NSArray * nameArray2 = @[@"昵称" ,@"性别", @"城市"];
    for(int i=0;i<3;i++){
        UIImageView * bgImageView = [MyControl createImageViewWithFrame:CGRectMake(60, i*40, 190, 30) ImageName:@""];
        if (i != 1) {
            bgImageView.image = [UIImage imageNamed:@"4和5页面通用.png"];
        }
        bgImageView.layer.cornerRadius = 10;
        bgImageView.layer.masksToBounds = YES;
        [bgView3 addSubview:bgImageView];
        bgImageView.tag = 5000+i;
        
        UILabel * nameLabel = [MyControl createLabelWithFrame:CGRectMake(15, bgImageView.frame.origin.y+5, 60, 20) Font:15 Text:nameArray2[i]];
        nameLabel.font = [UIFont boldSystemFontOfSize:15];
        [bgView3 addSubview:nameLabel];
        
        if (i == 0) {
            tfUserName = [MyControl createTextFieldWithFrame:CGRectMake(10, 5, 140, 20) placeholder:@"不超过8个汉字~" passWord:NO leftImageView:nil rightImageView:nil Font:13];
            tfUserName.delegate = self;
            tfUserName.borderStyle = 0;
            tfUserName.backgroundColor = [UIColor clearColor];
            [bgImageView addSubview:tfUserName];
            
            if (self.isModifyUser) {
                tfUserName.text = [USER objectForKey:@"name"];
            }
            UIImageView * keyboard = [MyControl createImageViewWithFrame:CGRectMake(150, 6, 25, 17) ImageName:@"3-2-2.png"];
            [bgImageView addSubview:keyboard];
        }else if(i == 1){
            woman = [MyControl createButtonWithFrame:CGRectMake(10, 5, 20, 20) ImageName:@"" Target:self Action:@selector(womanClick:) Title:nil];
            [woman setBackgroundColor:BGCOLOR];
            woman.layer.cornerRadius = 10;
            woman.layer.masksToBounds = YES;
            [bgImageView addSubview:woman];
            
            UILabel * wLabel = [MyControl createLabelWithFrame:CGRectMake(30, 5, 50, 20) Font:15 Text:@"女"];
            wLabel.font = [UIFont boldSystemFontOfSize:15];
            [bgImageView addSubview:wLabel];
            
            man = [MyControl createButtonWithFrame:CGRectMake(92, 5, 20, 20) ImageName:@"" Target:self Action:@selector(manClick:) Title:nil];
            [man setBackgroundColor:[UIColor whiteColor]];
            man.layer.cornerRadius = 10;
            man.layer.masksToBounds = YES;
            [bgImageView addSubview:man];
            
            UILabel * mLabel = [MyControl createLabelWithFrame:CGRectMake(112, 5, 50, 20) Font:15 Text:@"男"];
            mLabel.font = [UIFont boldSystemFontOfSize:15];
            [bgImageView addSubview:mLabel];
            
            if (self.isModifyUser) {
                if ([[USER objectForKey:@"gender"] intValue] == 1) {
                    [self manClick:man];
                }else{
                    [self womanClick:woman];
                }
            }
        }else{
            tfCity = [MyControl createTextFieldWithFrame:CGRectMake(10, 5, 170, 20) placeholder:@"点击选择城市" passWord:NO leftImageView:nil rightImageView:nil Font:13];
            tfCity.delegate = self;
            tfCity.borderStyle = 0;
            tfCity.backgroundColor = [UIColor clearColor];
            //此处设置字体自适应没有作用，不知为何？？
            tfCity.adjustsFontSizeToFitWidth = YES;
            CGFloat w = 5.0;
            tfCity.minimumFontSize = w;
            
            [bgImageView addSubview:tfCity];
            if (self.isModifyUser) {
//                NSString * str = [ControllerManager returnProvinceAndCityWithCityNum:[USER objectForKey:@"city"]];
//                NSArray * array = [str componentsSeparatedByString:@" | "];
//                NSMutableString * mutableStr = [NSMutableString stringWithCapacity:0];
//                for (int i=0; i<array.count; i++) {
//                    [mutableStr appendString:array[i]];
//                }
                tfCity.text = [ControllerManager returnProvinceAndCityWithCityNum:[USER objectForKey:@"city"]];
                self.u_city = [[USER objectForKey:@"city"] intValue];
            }
        }
    }
    /****************************************/
    finishButton2 = [MyControl createButtonWithFrame:CGRectMake(20+320+20, 425, 240, 35) ImageName:@"" Target:self Action:@selector(finishButtonClick2:) Title:@"完成"];
    finishButton2.backgroundColor = ORANGE;
    finishButton2.layer.cornerRadius = 5;
    finishButton2.layer.masksToBounds = YES;
    finishButton2.showsTouchWhenHighlighted = YES;
    [sv addSubview:finishButton2];
    
    
    /*****宠物种类选择器*****/
    pickerBgView = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200)];
    pickerBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.view addSubview:pickerBgView];
    pickerBgView.hidden = YES;
    
    //pickerView
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    picker.delegate = self;
    picker.dataSource = self;
    [pickerBgView addSubview:picker];
    
    UIButton * confirmButton = [MyControl createButtonWithFrame:CGRectMake(320-80, 150, 50, 30) ImageName:@"" Target:self Action:@selector(confirmButtonClick) Title:@"确认"];
    [confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pickerBgView addSubview:confirmButton];
    
    /*****城市地区选择器*****/
    pickerBgView2 = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200)];
    pickerBgView2.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.view addSubview:pickerBgView2];
    pickerBgView2.hidden = YES;
    
    //pickerView
    picker2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    picker2.delegate = self;
    picker2.dataSource = self;
    [picker2 selectRow: 0 inComponent: 0 animated: YES];
    [pickerBgView2 addSubview:picker2];
    
    UIButton * confirmButton2 = [MyControl createButtonWithFrame:CGRectMake(320-80, 150, 50, 30) ImageName:@"" Target:self Action:@selector(confirmButtonClick2) Title:@"确认"];
    [confirmButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pickerBgView2 addSubview:confirmButton2];
    
    /*****宠物年龄选择器*****/
    pickerBgView3 = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200)];
    pickerBgView3.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.view addSubview:pickerBgView3];
    pickerBgView3.hidden = YES;
    
    //pickerView3
    picker3 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    picker3.delegate = self;
    picker3.dataSource = self;
    [picker3 selectRow: 0 inComponent: 0 animated: YES];
    [pickerBgView3 addSubview:picker3];
    
    UIButton * confirmButton3 = [MyControl createButtonWithFrame:CGRectMake(320-80, 150, 50, 30) ImageName:@"" Target:self Action:@selector(confirmButtonClick3) Title:@"确认"];
    [confirmButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pickerBgView3 addSubview:confirmButton3];
}
#pragma mark - 
-(void)finishButtonClick:(UIButton *)btn
{
    NSLog(@"修改宠物资料完成");
    if (ageTextField.text.length == 0 || tf.text.length == 0 || [fromLabel.text isEqualToString:@"点击选择爱宠种族"] || (boy.selected == NO && girl.selected == NO)) {
        [MyControl popAlertWithView:self.view Msg:@"您有信息没有填写!"];
//        [MMProgressHUD dismissWithError:@"" afterDelay:1];
        return;
    }
//    if (tf.text.length>8) {
//        [MyControl popAlertWithView:self.view Msg:@"名字不可以超过8个字哦~"];
//        [MMProgressHUD dismissWithError:@"名字不可以超过8个字哦~" afterDelay:1];
//        return;
//    }
    NSLog(@"============符合要求============");
    self.name = tf.text;
    if (boy.selected) {
        gender = 1;
    }else if(girl.selected){
        gender = 2;
    }
    age = year*12+month;
    NSLog(@"name:%@--type:%d--age:%d--gender:%d", self.name, type, age, gender);
    [self petModifyInfo];
}
-(void)petModifyInfo
{
    LOADING;
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//    [MMProgressHUD showWithStatus:@"修改中..."];
    
    NSString * code = [NSString stringWithFormat:@"age=%d&aid=%@&code=&gender=%d&name=%@&type=%d", age, self.petInfoModel.aid, gender, [self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], type];
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"age=%d&aid=%@&code=&gender=%d&type=%ddog&cat", age, self.petInfoModel.aid, gender, type]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", MODIFYPETINFOAPI, code, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                //修改本地存储的宠物信息
                NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:[USER objectForKey:@"petInfoDict"]];
                [dict setObject:tf.text forKey:@"name"];
                [dict setObject:[NSString stringWithFormat:@"%d", type] forKey:@"type"];
                [dict setObject:[NSString stringWithFormat:@"%d", age] forKey:@"age"];
                [dict setObject:[NSString stringWithFormat:@"%d", gender] forKey:@"gender"];
                [USER setObject:dict forKey:@"petInfoDict"];
            }
            if (self.oriImage) {
                [self postImage];
            }else{
                LOADPETLIST;
                
                self.refreshPetInfo();
                ENDLOADING;
                [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"修改成功"];
//                [MMProgressHUD dismissWithSuccess:@"修改成功" title:nil afterDelay:0.5];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }else{
//            [MMProgressHUD dismissWithError:@"修改失败" afterDelay:0.5];
            LOADFAILED;
        }
    }];
    [request release];
    
}

-(void)finishButtonClick2:(UIButton *)btn
{
    NSLog(@"修改用户资料完成");
    if(tfUserName.text.length == 0 || tfCity.text.length == 0){
        [MyControl popAlertWithView:self.view Msg:@"您有信息没有填写!"];
//        StartLoading;
//        [MMProgressHUD dismissWithError:@"您有信息没有填写!" afterDelay:1];
        return;
    }
//    if (tfUserName.text.length >8)
//    {
//        [MyControl popAlertWithView:self.view Msg:@"昵称不可以超过8个字哦~"];
//        StartLoading;
//        [MMProgressHUD dismissWithError:@"昵称不可以超过8个字哦~" afterDelay:1];
//        return;
//    }
    NSLog(@"============符合要求============");
    self.u_name = tfUserName.text;
    if (man.selected) {
        self.u_gender = 1;
    }else if(woman.selected){
        self.u_gender = 2;
    }
    NSLog(@"u_name:%@--u_gender:%d--u_city:%d", self.u_name, self.u_gender, self.u_city);
    [self userModifyInfo];
}
-(void)userModifyInfo
{
    LOADING;
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//    [MMProgressHUD showWithStatus:@"修改中..."];
    NSString * code = [NSString stringWithFormat:@"u_city=%d&u_gender=%d&u_name=%@", self.u_city, self.u_gender, [self.u_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"u_city=%d&u_gender=%ddog&cat", self.u_city, self.u_gender]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", MODIFYUSERINFOAPI, code, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                [USER setObject:self.u_name forKey:@"name"];
                [USER setObject:[NSString stringWithFormat:@"%d", self.u_gender] forKey:@"gender"];
                [USER setObject:[NSString stringWithFormat:@"%d", self.u_city] forKey:@"city"];
            }
            if (self.oriUserImage) {
                [self postUserImage];
            }else{
                self.refreshUserInfo(self.u_name, self.u_gender, self.u_city, self.oriUserImage);
                ENDLOADING;
                [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"修改成功"];
//                [MMProgressHUD dismissWithSuccess:@"修改成功" title:nil afterDelay:0.5];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }else{
            LOADFAILED;
//            [MyControl loadingFailedWithContent:@"修改失败" afterDelay:0.1];
//            [MMProgressHUD dismissWithError:@"修改失败" afterDelay:0.5];
        }
    }];
    [request release];
}

#pragma mark -ASI
-(void)postImage
{
    //宠物头像上传
    
    //网络上传
    NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", self.petInfoModel.aid];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETTXAPI, self.petInfoModel.aid, [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@--%@", code, url);
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 30;
    
    NSData * data = UIImageJPEGRepresentation(self.oriImage, 0.1);
    //    NSLog(@"data:%@", data);
    //小图片用这种
    //    [_request setPostValue:data forKey:@"tx"];
    //大小图片用这种，比较保险
    NSString * fileName = [NSString stringWithFormat:@"%dheadImage.png", (int)[[NSDate date] timeIntervalSince1970]];
    [_request setData:data withFileName:fileName andContentType:@"image/jpg" forKey:@"tx"];
    
    _request.delegate = self;
    [_request startAsynchronous];
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}
-(void)postUserImage
{
    //网络上传
    NSString * url = [NSString stringWithFormat:@"%@%@", TXAPI, [ControllerManager getSID]];
    NSLog(@"user:%@", url);
    _requestUser = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _requestUser.requestMethod = @"POST";
    _requestUser.timeOutSeconds = 30;
    
    NSData * data = UIImageJPEGRepresentation(self.oriUserImage, 0.1);
    //    NSLog(@"data:%@", data);
    //小图片用这种
    //    [_request setPostValue:data forKey:@"tx"];
    //大小图片用这种，比较保险
    NSString * fileName = [NSString stringWithFormat:@"%duserHeadImage.png", (int)[[NSDate date] timeIntervalSince1970]];
    [_requestUser setData:data withFileName:fileName andContentType:@"image/jpg" forKey:@"tx"];
    
    _requestUser.delegate = self;
    [_requestUser startAsynchronous];
    
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", dic);
    if (request == _requestUser) {
        
        [USER setObject:[[dic objectForKey:@"data"] objectForKey:@"tx"] forKey:@"tx"];
    }else{
//        NSLog(@"%@", [[USER objectForKey:@"petInfoDict"] objectForKey:@"tx"]);
        [USER setObject:[[dic objectForKey:@"data"] objectForKey:@"tx"] forKey:@"a_tx"];
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:[USER objectForKey:@"petInfoDict"]];
        [dict setObject:[[dic objectForKey:@"data"] objectForKey:@"tx"] forKey:@"tx"];
        [USER setObject:dict forKey:@"petInfoDict"];
//        NSLog(@"%@", [[USER objectForKey:@"petInfoDict"] objectForKey:@"tx"]);
        
        LOADPETLIST;
    }
    //头像存放在本地
    NSString *docDir = DOCDIR;
    
    NSLog(@"%@",docDir);
    NSLog(@"saving png");
    if (request == _request) {
        NSString *pngFilePath = [DOCDIR stringByAppendingPathComponent:[[dic objectForKey:@"data"] objectForKey:@"tx"]];
        NSData * data = UIImageJPEGRepresentation(self.oriImage, 0.1);
        BOOL a = [data writeToFile:pngFilePath atomically:YES];
        NSLog(@"宠物头像存放结果：%d", a);
        self.refreshPetInfo();
    }else{
        NSString *pngFilePath = [DOCDIR stringByAppendingPathComponent:[[dic objectForKey:@"data"] objectForKey:@"tx"]];
        NSData * data = UIImageJPEGRepresentation(self.oriUserImage, 0.1);
        BOOL a = [data writeToFile:pngFilePath atomically:YES];
        NSLog(@"用户头像存放结果：%d", a);
        self.refreshUserInfo(self.u_name, self.u_gender, self.u_city, self.oriUserImage);
    }
    ENDLOADING;
    [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"修改成功"];
//    [MMProgressHUD dismissWithSuccess:@"修改成功" title:nil afterDelay:0.5];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    if (request == _request) {
        [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"宠物头像上传失败"];
//        [MMProgressHUD dismissWithError:@"宠物头像上传失败" afterDelay:0.5];
    }else{
        [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"用户头像上传失败"];
//        [MMProgressHUD dismissWithError:@"用户头像上传失败" afterDelay:0.5];
    }
    NSLog(@"headImage upload failed");
}
#pragma mark - 男女点击事件
-(void)girlButtonClick
{
    girl.selected = YES;
    boy.selected = NO;
    [self completeButton];
}
-(void)boyButtonClick
{
    girl.selected = NO;
    boy.selected = YES;
    [self completeButton];
}
#pragma mark - 男女性别选择按钮
-(void)womanClick:(UIButton *)button
{
    self.u_gender = 2;
    woman.backgroundColor = BGCOLOR;
    man.backgroundColor = [UIColor whiteColor];
    isMan = 0;
}
-(void)manClick:(UIButton *)button
{
    self.u_gender = 1;
    woman.backgroundColor = [UIColor whiteColor];
    man.backgroundColor = BGCOLOR;
    isMan = 1;
}
-(void)finish2ButtonClick
{
    [ageTextField resignFirstResponder];
    [self completeButton];
}
#pragma mark -
//判断完成按钮的颜色
- (void)completeButton
{
    if (!self.isModifyUser) {
        //宠物
        if (ageTextField.text.length == 0 || tf.text.length == 0 || tf.text.length>8 || [fromLabel.text isEqualToString:@"点击选择爱宠种族"] || (boy.selected == NO && girl.selected == NO)) {
            finishButton.backgroundColor = [UIColor grayColor];
            finishButton.userInteractionEnabled = NO;
            return;
        }else{
            finishButton.backgroundColor = ORANGE;
            finishButton.userInteractionEnabled = YES;
        }
    }else{
        //用户
        if (tfUserName.text.length == 0 || tfUserName.text.length >8) {
            finishButton2.backgroundColor = [UIColor grayColor];
            finishButton2.userInteractionEnabled = NO;
            return;
        }else{
            finishButton2.backgroundColor = ORANGE;
            finishButton2.userInteractionEnabled = YES;
        }
    }
}

#pragma mark - 
#pragma mark - textField代理方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == fromTF) {
        pickerBgView.hidden = NO;
        pickerBgView2.hidden = YES;
        pickerBgView3.hidden = YES;
        [tf resignFirstResponder];
        //        [self completeButton];
        return NO;
    }else if(textField == tfCity){
        NSLog(@"弹出选择地点picker");
        [tfUserName resignFirstResponder];
        pickerBgView.hidden = YES;
        pickerBgView2.hidden = NO;
        pickerBgView3.hidden = YES;
        [tfCity resignFirstResponder];
        return NO;
    }else if(textField == ageTextField){
        NSLog(@"弹出年龄选择picker");
        [tf resignFirstResponder];
        pickerBgView.hidden = YES;
        pickerBgView2.hidden = YES;
        pickerBgView3.hidden = NO;
        [ageTextField resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    //    if (textField == ageTextField) {
    //        [self performSelector:@selector(addDoneButtonToKeyboard) withObject:nil afterDelay:0.27];
    //    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    if (textField == tf) {
    [textField resignFirstResponder];
    //    }
    [self completeButton];
    return YES;
}
#pragma mark - pickerView代理方法

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == picker) {
        if (component == 0) {
            return self.cateArray.count;
        }else{
            return count;
        }
    }else if(pickerView == picker2){
        if (component == PROVINCE_COMPONENT) {
            return [province count];
        }
        else if (component == CITY_COMPONENT) {
            return [city count];
        }
        else {
            return [district count];
        }
    }else{
        if (component == 0) {
            return 100;
        }else{
            return 12;
        }
    }
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == picker) {
        if (component == 0) {
            self.cateName = self.cateArray[row];
            if (row == 0) {
                self.tempArray = self.catArray;
                count = self.catArray.count;
                if (num<self.catArray.count) {
                    self.detailName = self.catArray[num];
                }else{
                    num = self.catArray.count-1;
                    self.detailName = self.catArray[self.catArray.count-1];
                }
            }else if(row == 1){
                self.tempArray = self.dogArray;
                count = self.dogArray.count;
                if (num<self.dogArray.count) {
                    self.detailName = self.dogArray[num];
                }else{
                    num = self.dogArray.count-1;
                    self.detailName = self.dogArray[self.dogArray.count-1];
                }
            }else{
                self.tempArray = self.otherArray;
                count = self.otherArray.count;
                if (num<self.otherArray.count) {
                    self.detailName = self.otherArray[num];
                }else{
                    num = self.otherArray.count-1;
                    self.detailName = self.otherArray[self.otherArray.count-1];
                }
            }
            
            [picker reloadComponent:1];
        }else{
            self.detailName = self.tempArray[row];
            num = row;
        }
        //每次都确定type
        if (typeTag == 1) {
            type = 100+num+1;
        }else if(typeTag == 2){
            type = 200+num+1;
        }else if(typeTag == 3){
            type = 300+num+1;
        }
    }else if(pickerView == picker2){
        //picker2
        if (component == PROVINCE_COMPONENT) {
            selectedProvince = [province objectAtIndex: row];
            //取出省
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%d", row]]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
            //取出城市
            NSArray *cityArray = [dic allKeys];
            //城市key值排序
            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;//递减
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;//上升
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            //从排序后的key值，取出相应value
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0; i<[sortedArray count]; i++) {
                NSString *index = [sortedArray objectAtIndex:i];
                NSArray *temp = [[dic objectForKey: index] allKeys];
                [array addObject: [temp objectAtIndex:0]];
            }
            
            [city release];
            city = [[NSArray alloc] initWithArray: array];
            [array release];
            
            //刷新2，3列
            [picker2 reloadComponent: CITY_COMPONENT];
            
            //市和地区归零显示
            [picker2 selectRow:0 inComponent:CITY_COMPONENT animated:YES];
            //            [picker2 selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            //刷新2，3列
            [picker2 reloadComponent: CITY_COMPONENT];

            
        }
        else if (component == CITY_COMPONENT) {
 
        }
    }else if(pickerView == picker3){
        if (component == 0) {
            year = row;
        }else{
            month = row;
        }
    }
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == picker) {
        if (component == 0) {
            return self.cateArray[row];
        }else{
            return self.tempArray[row];
        }
    }else if(pickerView == picker2){
        if (component == PROVINCE_COMPONENT) {
            return [province objectAtIndex: row];
        }
        else if (component == CITY_COMPONENT) {
            return [city objectAtIndex: row];
        }
        else {
            return [district objectAtIndex: row];
        }
    }else{
        if (component == 0) {
            return [NSString stringWithFormat:@"%2d 岁", row];
        }else{
            return [NSString stringWithFormat:@"%2d 个月", row];
        }

    }
    
}
//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    
//    if (pickerView == picker3) {
//        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(0, 0, 100, 20) Font:15 Text:nil];
//        label.textColor = [UIColor blackColor];
//        label.textAlignment = NSTextAlignmentRight;
//        if (component == 0) {
//            label.text = [NSString stringWithFormat:@"%2d 岁", row];
//        }else{
//            label.text = [NSString stringWithFormat:@"%2d 个月", row];
//        }
//        return label;
//    }else{
//        return nil;
//    }
//}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (pickerView == picker) {
        if (component == 1) {
            return 200;
        }else{
            return 80;
        }
    }else{
        if (component == PROVINCE_COMPONENT) {
            return 150;
        }else{
            return 150;
        }
    }
    
}

#pragma mark - picker picker2确认点击事件
-(void)confirmButtonClick
{
    fromTF.text = [NSString stringWithFormat:@"%@-%@", self.cateName, self.detailName];
    pickerBgView.hidden = YES;
    [self completeButton];
    
}
-(void)confirmButtonClick2
{
    //点击获取当前省，市，地区
    NSInteger provinceIndex = [picker2 selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [picker2 selectedRowInComponent: CITY_COMPONENT];
    //    NSInteger districtIndex = [picker2 selectedRowInComponent: DISTRICT_COMPONENT];
    
    NSString *provinceStr = [province objectAtIndex: provinceIndex];
    NSString *cityStr = [city objectAtIndex: cityIndex];
    //    NSString *districtStr = [district objectAtIndex:districtIndex];
    
    //特别行政区的判断
    if ([provinceStr isEqualToString: cityStr]) {
        cityStr = @"";
        //        districtStr = @"";
        //    }
        //    else if ([cityStr isEqualToString: districtStr]) {
        //        districtStr = @"";
    }else if([provinceStr isEqualToString: cityStr]){
        cityStr = @"";
    }
    NSLog(@"------------%d", (provinceIndex+10)*100+cityIndex);
    self.u_city = (provinceIndex+10)*100+cityIndex;
    NSString *showMsg = [NSString stringWithFormat: @"%@%@", provinceStr, cityStr];
    tfCity.text = showMsg;
    
    pickerBgView2.hidden = YES;
    [self completeButton];
}
-(void)confirmButtonClick3
{
    ageTextField.text = [MyControl returnAgeStringWithCountOfMonth:[NSString stringWithFormat:@"%d", year*12+month]];
    pickerBgView3.hidden = YES;
    [self completeButton];
}
-(void)photoButtonClick2
{
    isUserPhoto = 1;
    [self actionSheetResopnse];
}
-(void)photoButtonClick
{
    isUserPhoto = 0;
    [self actionSheetResopnse];
}

-(void)actionSheetResopnse
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
    [self completeButton];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                    
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    isCamara = YES;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    isCamara = NO;
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                isCamara = NO;
            } else {
                return;
            }
        }
        //跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.sourceType = sourceType;
        
        if ([self hasValidAPIKey]) {
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }
        [imagePickerController release];
    }
}
#pragma mark -imagePicker代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (!isUserPhoto) {
        self.oriImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }else{
        self.oriUserImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    //    [oriImage retain];
    
    //    NSData * data = UIImageJPEGRepresentation(oriImage, 0.1);
    //
    //    UIImage * image2 = [UIImage imageWithData:data];
    //
    //    [photoButton setBackgroundImage:image2 forState:UIControlStateNormal];
    NSURL * assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    void(^completion)(void)  = ^(void){
        if (isCamara) {
            if (!isUserPhoto) {
                [self lauchEditorWithImage:self.oriImage];
            }else{
                [self lauchEditorWithImage:self.oriUserImage];
            }
            
        }else{
            [[self assetLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                if (asset){
                    [self launchEditorWithAsset:asset];
                }
            } failureBlock:^(NSError *error) {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable access to your device's photos." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }];
        }};
    
    [self dismissViewControllerAnimated:NO completion:completion];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - ALAssets Helper Methods

- (UIImage *)editingResImageForAsset:(ALAsset*)asset
{
    CGImageRef image = [[asset defaultRepresentation] fullScreenImage];
    
    return [UIImage imageWithCGImage:image scale:1.0 orientation:UIImageOrientationUp];
}

- (UIImage *)highResImageForAsset:(ALAsset*)asset
{
    ALAssetRepresentation * representation = [asset defaultRepresentation];
    
    CGImageRef image = [representation fullResolutionImage];
    UIImageOrientation orientation = (UIImageOrientation)[representation orientation];
    CGFloat scale = [representation scale];
    
    return [UIImage imageWithCGImage:image scale:scale orientation:orientation];
}

#pragma mark - Status Bar Style

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private Helper Methods

- (BOOL) hasValidAPIKey
{
    if ([kAFAviaryAPIKey isEqualToString:@"<YOUR-API-KEY>"] || [kAFAviarySecret isEqualToString:@"<YOUR-SECRET>"]) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                    message:@"You forgot to add your API key and secret!"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}

#pragma mark -图片编辑
#pragma mark =================================
#pragma mark - Photo Editor Launch Methods

//********************自己方法******************
-(void)lauchEditorWithImage:(UIImage *)image
{
    UIImage * editingResImage = image;
    UIImage * highResImage = image;
    [self launchPhotoEditorWithImage:editingResImage highResolutionImage:highResImage];
}
//*********************************************
- (void) launchEditorWithAsset:(ALAsset *)asset
{
    UIImage * editingResImage = [self editingResImageForAsset:asset];
    UIImage * highResImage = [self highResImageForAsset:asset];
    
    [self launchPhotoEditorWithImage:editingResImage highResolutionImage:highResImage];
}
#pragma mark - Photo Editor Creation and Presentation
- (void) launchPhotoEditorWithImage:(UIImage *)editingResImage highResolutionImage:(UIImage *)highResImage
{
    // Customize the editor's apperance. The customization options really only need to be set once in this case since they are never changing, so we used dispatch once here.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setPhotoEditorCustomizationOptions];
    });
    
    // Initialize the photo editor and set its delegate
    AFPhotoEditorController * photoEditor = [[AFPhotoEditorController alloc] initWithImage:editingResImage];
    [photoEditor setDelegate:self];
    
    // If a high res image is passed, create the high res context with the image and the photo editor.
    if (highResImage) {
        [self setupHighResContextForPhotoEditor:photoEditor withImage:highResImage];
    }
    
    // Present the photo editor.
    [self presentViewController:photoEditor animated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void) setupHighResContextForPhotoEditor:(AFPhotoEditorController *)photoEditor withImage:(UIImage *)highResImage
{
    // Capture a reference to the editor's session, which internally tracks user actions on a photo.
    __block AFPhotoEditorSession *session = [photoEditor session];
    
    // Add the session to our sessions array. We need to retain the session until all contexts we create from it are finished rendering.
    [[self sessions] addObject:session];
    
    // Create a context from the session with the high res image.
    AFPhotoEditorContext *context = [session createContextWithImage:highResImage];
    
    __block RegisterViewController * blockSelf = self;
    
    [context render:^(UIImage *result) {
        if (result) {
            UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
        }
        
        [[blockSelf sessions] removeObject:session];
        
        blockSelf = nil;
        session = nil;
        
    }];
}

#pragma Photo Editor Delegate Methods

// This is called when the user taps "Done" in the photo editor.
- (void) photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    
    if (isUserPhoto) {
        self.oriUserImage = image;
        [self dismissViewControllerAnimated:YES completion:^{
            [photoButton2 setBackgroundImage:self.oriUserImage forState:UIControlStateNormal];
        }];
    }else{
        self.oriImage = image;
        [self dismissViewControllerAnimated:YES completion:^{
            [photoButton setBackgroundImage:self.oriImage forState:UIControlStateNormal];
        }];
    }
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //    isUserPhoto = NO;
}

// This is called when the user taps "Cancel" in the photo editor.
- (void) photoEditorCanceled:(AFPhotoEditorController *)editor
{
    //    isUserPhoto = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - Photo Editor Customization

- (void) setPhotoEditorCustomizationOptions
{
    // Set API Key and Secret
    [AFPhotoEditorController setAPIKey:kAFAviaryAPIKey secret:kAFAviarySecret];
    
    // Set Tool Order
    NSArray * toolOrder = @[kAFEffects, kAFFocus, kAFFrames, kAFStickers, kAFEnhance, kAFOrientation, kAFCrop, kAFAdjustments, kAFSplash, kAFDraw, kAFText, kAFRedeye, kAFWhiten, kAFBlemish, kAFMeme];
    [AFPhotoEditorCustomization setToolOrder:toolOrder];
    
    // Set Custom Crop Sizes
    [AFPhotoEditorCustomization setCropToolOriginalEnabled:NO];
    [AFPhotoEditorCustomization setCropToolCustomEnabled:YES];
    NSDictionary * fourBySix = @{kAFCropPresetHeight : @(4.0f), kAFCropPresetWidth : @(6.0f)};
    NSDictionary * fiveBySeven = @{kAFCropPresetHeight : @(5.0f), kAFCropPresetWidth : @(7.0f)};
    NSDictionary * square = @{kAFCropPresetName: @"Square", kAFCropPresetHeight : @(1.0f), kAFCropPresetWidth : @(1.0f)};
    [AFPhotoEditorCustomization setCropToolPresets:@[fourBySix, fiveBySeven, square]];
    
    // Set Supported Orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray * supportedOrientations = @[@(UIInterfaceOrientationPortrait), @(UIInterfaceOrientationPortraitUpsideDown), @(UIInterfaceOrientationLandscapeLeft), @(UIInterfaceOrientationLandscapeRight)];
        [AFPhotoEditorCustomization setSupportedIpadOrientations:supportedOrientations];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
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
