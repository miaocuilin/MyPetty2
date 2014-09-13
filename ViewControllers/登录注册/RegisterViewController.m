//
//  RegisterViewController.m
//  MyPetty
//
//  Created by Aidi on 14-6-3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "RegisterViewController.h"
#import "RandomViewController.h"
#import "MyMD5.h"
#import "OpenUDID.h"
#import "ASIFormDataRequest.h"
#import "IQKeyboardManager.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <AviarySDK/AviarySDK.h>

static NSString * const kAFAviaryAPIKey = @"b681eafd0b581b46";
static NSString * const kAFAviarySecret = @"389160adda815809";
@interface RegisterViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,AFPhotoEditorControllerDelegate>
{
    ASIFormDataRequest * _request;
    ASIFormDataRequest * _requestUser;
    UIAlertView * alert0;
    UIAlertView * alert1;
}
@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;
@end

@implementation RegisterViewController

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
    // Allocate Asset Library
    ALAssetsLibrary * assetLibrary = [[ALAssetsLibrary alloc] init];
    [self setAssetLibrary:assetLibrary];
    
    // Allocate Sessions Array
    NSMutableArray * sessions = [NSMutableArray new];
    [self setSessions:sessions];
    [sessions release];
    
    // Start the Aviary Editor OpenGL Load
    [AFOpenGLManager beginOpenGLLoad];
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = BGCOLOR2;
    self.catArray = [NSMutableArray arrayWithCapacity:0];
    self.dogArray = [NSMutableArray arrayWithCapacity:0];
    self.otherArray = [NSMutableArray arrayWithCapacity:0];
    self.cateArray = @[@"喵星", @"汪星", @"其它星"];
    self.u_city = 1000;
    
//    self.catArray = @[@"猫咪", @"布偶猫", @"波斯猫", @"挪威猫", @"缅因猫", @"伯曼猫", @"索马利猫", @"土耳其梵猫", @"美国短尾猫", @"西伯利亚森林猫", @"巴厘猫", @"土耳其安哥拉猫", @"褴褛猫", @"拉邦猫", @"暹罗猫", @"苏格兰折耳猫", @"短毛猫", @"俄罗斯蓝猫", @"孟买猫" @"埃及猫", @"斯芬克斯猫" @"缅甸猫", @"阿比西尼亚猫", @"新加坡猫", @"中国狸花猫", @"日本短尾猫", @"东奇尼猫", @"卷毛猫", @"马恩岛猫", @"奥西猫", @"沙特尔猫", @"呵叻猫", @"美国刚毛猫", @"哈瓦那棕猫", @"波米拉猫", @"东方猫", @"混血"];
//    self.dogArray = @[@"狗狗", @"吉娃娃", @"博美犬", @"马尔济斯犬", @"约克夏梗", @"贵宾犬", @"蝴蝶犬", @"八哥犬", @"西施犬", @"比熊犬", @"北京犬", @"迷你杜宾", @"拉萨犬", @"冠毛犬", @"小型雪瑞纳", @"柯基犬", @"巴吉度犬", @"哈士奇", @"松狮", @"牧羊犬", @"柴犬", @"斗牛犬", @"萨摩耶犬", @"腊肠犬", @"猎兔犬", @"惠比特犬", @"拉布拉多", @"大麦町犬(斑点狗)", @"爱斯基摩犬", @"沙皮犬", @"山地犬", @"无毛犬", @"雪纳瑞", @"藏獒", @"史毕诺犬", @"卡斯罗", @"罗威纳犬", @"阿拉斯加雪橇犬", @"金毛", @"柯利犬", @"波尔多犬", @"法国狼犬", @"雪达犬", @"奇努克犬", @"威玛犬", @"比利时马林诺斯犬", @"寻回犬", @"浣熊犬", @"迦南犬", @"猎犬", @"梗犬", @"混血"];
    
    self.cateName = @"喵星";
    self.detailName = @"布偶猫";
    
    [self createIQ];
//    [self createNavigation];
    [self createBg];
    [self getCityData];
    [self loadCateNameList];
    
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
-(void)loadCateNameList
{
//    [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", TYPEAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
////            NSLog(@"宠物类型：%@", load.dataDict);
//            [USER setObject:[load.dataDict objectForKey:@"data"] forKey:@"CateNameList"];
//            NSString * path = [DOCDIR stringByAppendingPathComponent:@"CateNameList.plist"];
//            NSMutableDictionary * data = [load.dataDict objectForKey:@"data"];
//            [data writeToFile:path atomically:YES];
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
            //开始搭建界面
            [self createUI];
            [self createFakeNavigation];
//        }
//    }];
}
-(void)createBg
{
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:self.bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"%@", data);
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
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"注册"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}

-(void)backBtnClick
{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 获取plist文件信息
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
//    for (int i=0; i<province.count; i++) {
//        NSLog(@"%@", province[i]);
//    }
    
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
    //取出第一个字典
//    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    //取出所有key
//    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    //设置第一个key为选中 北京市
//    NSString *selectedCity = [city objectAtIndex: 0];
//    //北京市中所有区放到district数组
//    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    selectedProvince = [province objectAtIndex: 0];
    
//    [picker2 reloadComponent:1];
}


#pragma mark - 搭建界面
-(void)createUI
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-30, self.view.frame.size.height)];
    sv.contentSize = CGSizeMake(sv.frame.size.width*2, sv.frame.size.height);
    sv.pagingEnabled = YES;
    sv.clipsToBounds = NO;
    sv.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:sv];

    /***************第一页********************/
    UIView * miBgView = [MyControl createViewWithFrame:CGRectMake(20, 326/2, 280, 490/2)];
    miBgView.backgroundColor = [ControllerManager colorWithHexString:@"fca283"];
    miBgView.alpha = 0.6;
    miBgView.layer.cornerRadius = 5;
    miBgView.layer.masksToBounds = YES;
    [sv addSubview:miBgView];
  
    
    
    UIImageView * roundImageView = [MyControl createImageViewWithFrame:CGRectMake(108.5, 326/2-116/2, 217/2, 116/2) ImageName:@"4-3.png"];
    [sv addSubview:roundImageView];
    
    photoButton = [MyControl createButtonWithFrame:CGRectMake(105+(116-80)/2, 42+18+64-5, 80, 80) ImageName:@"defaultPetHead" Target:self Action:@selector(photoButtonClick) Title:nil];
    photoButton.layer.cornerRadius = 40;
    photoButton.layer.masksToBounds = YES;
    [sv addSubview:photoButton];
   
    /**************************/
    if (!([self.petInfoModel.tx isKindOfClass:[NSNull class]] || [self.petInfoModel.tx length]==0)) {
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.petInfoModel.tx]];
        //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
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
    
    UILabel * miTitle = [MyControl createLabelWithFrame:CGRectMake(100, 205, 120, 20) Font:18 Text:@"宠物信息"];
    miTitle.textAlignment = NSTextAlignmentCenter;
    [sv addSubview:miTitle];
    
    
    girl = [MyControl createButtonWithFrame:CGRectMake(110, miBgView.frame.origin.y+205, 30, 30) ImageName:@"3-5.png" Target:self Action:@selector(girlButtonClick) Title:nil];
    girl.selected = YES;
    [girl setBackgroundImage:[UIImage imageNamed:@"3-4.png"] forState:UIControlStateSelected];
    [sv addSubview:girl];
    
    boy = [MyControl createButtonWithFrame:CGRectMake(180, miBgView.frame.origin.y+205, 30, 30) ImageName:@"3-7.png" Target:self Action:@selector(boyButtonClick) Title:nil];
    [boy setBackgroundImage:[UIImage imageNamed:@"3-6.png"] forState:UIControlStateSelected];
    [sv addSubview:boy];
    
    /*******/
    if (self.isAdoption && [self.petInfoModel.gender intValue] == 1) {
        girl.selected = NO;
        boy.selected = YES;
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
            tf.backgroundColor = [UIColor clearColor];
            [bgImageView addSubview:tf];
            
            if (self.isAdoption) {
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
            
            if (self.isAdoption) {
                fromTF.text = [ControllerManager returnCateNameWithType:self.petInfoModel.type];
            }
            
            UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(185, 5, 15, 20) ImageName:@"扩展更多图标.png"];
            [bgImageView addSubview:arrow];
        }else{
            UIView * keyboardBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 40)];
            keyboardBgView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
            UIButton * finishButton2 = [MyControl createButtonWithFrame:CGRectMake(320-70, 5, 50, 30) ImageName:@"" Target:self Action:@selector(finish2ButtonClick) Title:@"完成"];
            [keyboardBgView addSubview:finishButton2];

            ageTextField = [MyControl createTextFieldWithFrame:CGRectMake(40, 5, 140, 20) placeholder:@"请输入爱宠的年龄" passWord:NO leftImageView:nil rightImageView:nil Font:13];
            ageTextField.delegate = self;
            ageTextField.borderStyle = 0;
            ageTextField.backgroundColor = [UIColor clearColor];
            ageTextField.keyboardType = UIKeyboardTypeNumberPad;
            ageTextField.inputAccessoryView = keyboardBgView;
            [bgImageView addSubview:ageTextField];
            
            if (self.isAdoption) {
                ageTextField.text = self.petInfoModel.age;
            }
            UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(185, 5, 15, 20) ImageName:@"扩展更多图标.png"];
            [bgImageView addSubview:arrow];
        }
    }
    
//    if ([[USER objectForKey:@"isAdopt"] isEqualToString:@"1"]) {
//       
//    }
    if (self.isAdoption) {
        miBgView.userInteractionEnabled = NO;
        photoButton.userInteractionEnabled = NO;
        boy.userInteractionEnabled = NO;
        girl.userInteractionEnabled = NO;
    }
    /***************新界面第二页********************/
    UIView * userBgView = [MyControl createViewWithFrame:CGRectMake(320-10, 100+64, 280, 490/2)];
    userBgView.backgroundColor = [ControllerManager colorWithHexString:@"fca283"];
    userBgView.alpha = 0.6;
    userBgView.layer.cornerRadius = 5;
    userBgView.layer.masksToBounds = YES;
    [sv addSubview:userBgView];
    
    UIImageView * roundImageView2 = [MyControl createImageViewWithFrame:CGRectMake(-30+320+108.5, 100-116/2+64, 217/2, 116/2) ImageName:@"4-3.png"];
    [sv addSubview:roundImageView2];
    
    photoButton2 = [MyControl createButtonWithFrame:CGRectMake(-30+320+105+(116-80)/2, 42+18+64-5, 80, 80) ImageName:@"defaultUserHead" Target:self Action:@selector(photoButtonClick2) Title:nil];
    photoButton2.layer.cornerRadius = 40;
    photoButton2.layer.masksToBounds = YES;
    [sv addSubview:photoButton2];
    
    UILabel * userTitle = [MyControl createLabelWithFrame:CGRectMake(-30+320+100, 205, 120, 20) Font:18 Text:@"用户信息"];
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
        }
    }
    /****************************************/
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    if (ageTextField.text || fromLabel.text || tf.text) {
//        UIButton *finishButton = [MyControl createButtonWithFrame:CGRectMake(20+self.view.frame.size.width, 370, 280, 35) ImageName:nil Target:nil Action:nil Title:@"完成"];
//        finishButton.backgroundColor = [UIColor grayColor];
//        finishButton.layer.cornerRadius = 5;
//        finishButton.layer.masksToBounds = YES;
//        [sv addSubview:finishButton];
//
//    }else {
        finishButton = [MyControl createButtonWithFrame:CGRectMake(-30+20+320+20, 425, 240, 35) ImageName:@"" Target:self Action:@selector(finishButtonClick:) Title:@"完成"];
//        finishButton.backgroundColor = BGCOLOR;
        finishButton.backgroundColor = [UIColor grayColor];
        finishButton.layer.cornerRadius = 5;
        finishButton.layer.masksToBounds = YES;
        [sv addSubview:finishButton];
//    }
    
    
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
}

#pragma mark - 男女性别选择按钮
-(void)womanClick:(UIButton *)button
{
    woman.backgroundColor = BGCOLOR;
    man.backgroundColor = [UIColor whiteColor];
    isMan = 0;
}
-(void)manClick:(UIButton *)button
{
    woman.backgroundColor = [UIColor whiteColor];
    man.backgroundColor = BGCOLOR;
    isMan = 1;
}
-(void)finish2ButtonClick
{
    [ageTextField resignFirstResponder];
    [self completeButton];
}
//判断完成按钮的颜色
- (void)completeButton
{
    if (ageTextField.text.length == 0 || tf.text.length == 0 || [fromLabel.text isEqualToString:@"点击选择爱宠种族"]) {
        finishButton.backgroundColor = [UIColor grayColor];
        return;
    }else{
        [self performSelector:@selector(gotoPage2) withObject:nil afterDelay:0.3];
    }
    
    if (ageTextField.text.length == 0 || tf.text.length == 0 || [fromLabel.text isEqualToString:@"点击选择爱宠种族"] || tfUserName.text.length == 0 || tfUserName.text.length >10 || tfCity.text.length == 0) {
        finishButton.backgroundColor = [UIColor grayColor];
    }else{
        finishButton.backgroundColor = BGCOLOR;

    }
}
-(void)gotoPage2
{
    [UIView animateWithDuration:0.3 animations:^{
        sv.contentOffset = CGPointMake(320-30, 0);
    }];
}

#pragma mark - textField代理方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == fromTF) {
        pickerBgView.hidden = NO;
        [tf resignFirstResponder];
//        [self completeButton];
        return NO;
    }else if(textField == tfCity){
        NSLog(@"弹出选择地点picker");
        [tfUserName resignFirstResponder];
        pickerBgView2.hidden = NO;
        [tfCity resignFirstResponder];
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

//- (void)addDoneButtonToKeyboard {
//    [self addButtonToKeyboardWithSelector:@selector(done:) normal:[UIImage imageNamed:@"DoneUp.png"] highlight:[UIImage imageNamed:@"DoneDown.png"]];
//}

//- (void)addButtonToKeyboardWithSelector:(SEL)sel normal:(UIImage*)nimg highlight:(UIImage*)himg{
//    // create custom button
//    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    doneButton.adjustsImageWhenHighlighted = NO;
//    
//    [doneButton setImage:nimg forState:UIControlStateNormal];
//    [doneButton setImage:himg forState:UIControlStateHighlighted];
//    [doneButton addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
//    // locate keyboard view
//    int cnt=[[UIApplication sharedApplication] windows].count;
//    UIWindow* keyboardWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:cnt-1];
//    doneButton.frame = CGRectMake(0, keyboardWindow.frame.size.height-53, 106, 53);
//    [keyboardWindow addSubview:doneButton];
//    
////    NSLog(@"keyboard:%@ %@ %@",NSStringFromCGRect(keyboardWindow.frame),NSStringFromCGRect(doneButton.frame),keyboardWindow.subviews);
//}
//- (void) done:(UIButton *)sender{
//    [ageTextField resignFirstResponder];
//    [sender removeFromSuperview];
//    [self completeButton];
//    
//}

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
    }else{
        if (component == PROVINCE_COMPONENT) {
            return [province count];
        }
        else if (component == CITY_COMPONENT) {
            return [city count];
        }
        else {
            return [district count];
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
    }else{
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
            
//            [district release];
//            NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
            //地区
//            district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
            
            //刷新2，3列
            [picker2 reloadComponent: CITY_COMPONENT];
            
            //市和地区归零显示
            [picker2 selectRow:0 inComponent:CITY_COMPONENT animated:YES];
//            [picker2 selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            //刷新2，3列
            [picker2 reloadComponent: CITY_COMPONENT];
//            [picker2 reloadComponent: DISTRICT_COMPONENT];
            
        }
        else if (component == CITY_COMPONENT) {
//            NSString *provinceIndex = [NSString stringWithFormat: @"%d", [province indexOfObject: selectedProvince]];
//            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
//            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
//            NSArray *dicKeyArray = [dic allKeys];
//            NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
//                
//                if ([obj1 integerValue] > [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedDescending;
//                }
//                
//                if ([obj1 integerValue] < [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedAscending;
//                }
//                return (NSComparisonResult)NSOrderedSame;
//            }];
            
//            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
//            NSArray *cityKeyArray = [cityDic allKeys];
//            
//            [district release];
//            district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
//            [picker2 selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
//            [picker2 reloadComponent: DISTRICT_COMPONENT];
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
    }else{
        if (component == PROVINCE_COMPONENT) {
            return [province objectAtIndex: row];
        }
        else if (component == CITY_COMPONENT) {
            return [city objectAtIndex: row];
        }
        else {
            return [district objectAtIndex: row];
        }
    }
    
}
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
//可以设置每一列中的每一行背景颜色，字体大小
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel *myView = nil;
//    if (pickerView == picker2) {
//        if (component == PROVINCE_COMPONENT) {
//            myView = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)] autorelease];
//            myView.textAlignment = NSTextAlignmentCenter;
//            myView.text = [province objectAtIndex:row];
//            myView.font = [UIFont systemFontOfSize:14];
//            myView.backgroundColor = [UIColor clearColor];
//        }
//        else if (component == CITY_COMPONENT) {
//            myView = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)] autorelease];
//            myView.textAlignment = NSTextAlignmentCenter;
//            myView.text = [city objectAtIndex:row];
//            myView.font = [UIFont systemFontOfSize:14];
//            myView.backgroundColor = [UIColor clearColor];
//        }
//        else {
//            myView = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)] autorelease];
//            myView.textAlignment = NSTextAlignmentCenter;
//            myView.text = [district objectAtIndex:row];
//            myView.font = [UIFont systemFontOfSize:14];
//            myView.backgroundColor = [UIColor clearColor];
//        }
//    }
//    
//    return myView;
//}

#pragma mark -键盘监听
//-(void)keyboardWillShow:(NSNotification *)notification
//{
//    //键盘出现时取消scrollView的滑动属性
//    sv.scrollEnabled = NO;
//    
////    (0, 150, 320, 140)
////    NSLog(@"%@", notification.userInfo);
//    
//    float Height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    NSLog(@"%f", self.view.frame.size.height);
//    if (sv.contentOffset.x == 0) {
//        if (bgView2.frame.origin.y + bgView2.frame.size.height > self.view.frame.size.height-Height) {
//            [UIView animateWithDuration:0.3 animations:^{
//                bgView2.frame = CGRectMake(0, self.view.frame.size.height-Height-bgView2.frame.origin.y, bgView2.frame.size.width, bgView2.frame.size.height);
//            }];
//        }
//    }else{
//        if (bgView3.frame.origin.y + bgView3.frame.size.height > self.view.frame.size.height-Height) {
//            [UIView animateWithDuration:0.3 animations:^{
//                bgView3.frame = CGRectMake(-30+320, self.view.frame.size.height-Height-bgView3.frame.origin.y, bgView3.frame.size.width, bgView3.frame.size.height);
//            }];
//        }
//    }
//    
//}
//-(void)keyboardWillHide:(NSNotification *)notification
//{
//    //键盘消失时开启scrollView的滑动属性
//    sv.scrollEnabled = YES;
//    
//    if (sv.contentOffset.x == 0) {
//        [UIView animateWithDuration:0.3 animations:^{
//            bgView2.frame = CGRectMake(0, 180, self.view.frame.size.width, 140);
//        }];
//    }else{
//        [UIView animateWithDuration:0.3 animations:^{
//            bgView3.frame = CGRectMake(-30+320, 180, self.view.frame.size.width, 140);
//        }];
//    }
//
//}



#pragma mark -大量button点击事件
//-(void)buttonClick:(UIButton *)button
//{
//    if (button.tag == 100) {
//        //好的，偏移
//        [UIView animateWithDuration:0.3 animations:^{
//            sv.contentOffset = CGPointMake(self.view.frame.size.width, 0);
//        }];
//    }
//}

-(void)girlButtonClick
{
    girl.selected = YES;
    boy.selected = NO;
}
-(void)boyButtonClick
{
    girl.selected = NO;
    boy.selected = YES;
}
-(void)finishButtonClick:(UIButton *)sender
{
    if (ageTextField.text.length == 0 || tf.text.length == 0 || [fromLabel.text isEqualToString:@"点击选择爱宠种族"] || tfUserName.text.length == 0 || tfCity.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"您有信息没有填写!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        return;
    }
    if (tfUserName.text.length >8) {
        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"昵称不可以超过8个汉字哦~"];
        return;
    }
    if ([ageTextField.text intValue]>=100) {
        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"不可以谎报年龄哦~"];
        return;
    }
    
    //跳转到个人主页
    NSLog(@"完成！");
    
    //将数据整合，发送给服务器进行注册
    age = [ageTextField.text intValue];
    //宠物性别
    if (boy.selected) {
        gender = 1;
    }else{
        gender = 2;
    }
    
    self.name = tf.text;
    //宠物种类
    if ([self.cateName isEqualToString:@"喵星"]) {
        type = 100+num+1;
    }else if([self.cateName isEqualToString:@"汪星"]){
        type = 200+num+1;
    }else{
        type = 300+num+1;
    }
    /*******************/
    if (self.isAdoption) {
        type = [self.petInfoModel.type intValue];
    }
    /*******************/
    [USER setObject:self.detailName forKey:@"detailName"];
    self.u_name = tfUserName.text;
    if (isMan) {
        self.u_gender = 1;
    }else{
        self.u_gender = 2;
    }
    
    //用户注册
    [self userRegister];

    //跳到主页
//    JDSideMenu * sideMenu = [ControllerManager shareJDSideMenu];
//    [sideMenu setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"30-3" ofType:@"png"]]];
//    [self presentViewController:sideMenu animated:YES completion:nil];
}

#pragma mark -注册
-(void)userRegister
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:@"正在注册，请稍后..."];
//    alert0 = [[UIAlertView alloc] initWithTitle:@"正在注册，请稍后..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alert0 show];
//    [alert0 release];
    NSString * str = nil;
    NSString * str2 = nil;
    NSString * sig = nil;
//    if([USER objectForKey:@"sinaUsid"] != nil){
//        str = [NSString stringWithFormat:@"age=%d&code=&gender=%d&name=%@&type=%d&wechat=&weibo=%@", age, gender, [self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], type, [USER objectForKey:@"sinaUsid"]];
//        str2 = [NSString stringWithFormat:@"age=%d&code=&gender=%d&type=%d&wechat=&weibo=%@dog&cat", age, gender, type, [USER objectForKey:@"sinaUsid"]];
//        sig = [MyMD5 md5:str2];
//    }else{
//        str = [NSString stringWithFormat:@"age=%d&code=&gender=%d&name=%@&type=%d&wechat=&weibo=", age, gender, [self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], type];
//        str2 = [NSString stringWithFormat:@"age=%d&code=&gender=%d&type=%d&wechat=&weibo=dog&cat", age, gender, type];
        
        str = [NSString stringWithFormat:@"age=%d&code=&gender=%d&name=%@&type=%d&u_city=%d&u_gender=%d&u_name=%@", age, gender, [self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], type, self.u_city, self.u_gender, [self.u_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        str2 = [NSString stringWithFormat:@"age=%d&code=&gender=%d&type=%d&u_city=%d&u_gender=%ddog&cat", age, gender, type, self.u_city, self.u_gender];
    /****************/
    if (self.isAdoption) {
        str = [NSString stringWithFormat:@"age=%d&aid=%@&code=&gender=%d&name=%@&type=%d&u_city=%d&u_gender=%d&u_name=%@", age, self.petInfoModel.aid, gender, [self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], type, self.u_city, self.u_gender, [self.u_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        str2 = [NSString stringWithFormat:@"age=%d&aid=%@&code=&gender=%d&type=%d&u_city=%d&u_gender=%ddog&cat", age, self.petInfoModel.aid, gender, type, self.u_city, self.u_gender];
    }
    /****************/
        sig = [MyMD5 md5:str2];
    
//    }
    //访问注册API
    NSString * message = [NSString stringWithFormat:@"%@?r=user/registerApi&%@&sig=%@&SID=%@", IPURL2, str, sig, [ControllerManager getSID]];
    //进行注册
    NSLog(@"%d", [ControllerManager getIsSuccess]);
    NSLog(@"%@", [ControllerManager getSID]);
    NSLog(@"self.name: %@",self.name);
    NSLog(@"self.nameUTF8: %@",[self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    NSLog(@"%@", message);
    [[httpDownloadBlock alloc] initWithUrlStr:message Block:^(BOOL isFinish, httpDownloadBlock * load) {
        NSLog(@"%@", load.dataDict);
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [alert0 setTitle:@"正在下载注册返回信息"];
        if (isFinish) {
            if([[load.dataDict objectForKey:@"errorCode"] intValue] == 2){
                //SID过期，重新获取
                [alert0 setTitle:@"SID过期"];

                [self login];
                [self userRegister];
                return;
            }else if([[load.dataDict objectForKey:@"errorCode"] intValue] == 1 || [[load.dataDict objectForKey:@"errorCode"] intValue] == -1){

                NSLog(@"%@", load.dataDict);
                //发生错误，显示错误信息，用户名已存在等。
                NSString * errorMessage = [load.dataDict objectForKey:@"errorMessage"];
                [alert0 setTitle:errorMessage];
                [MMProgressHUD dismissWithError:@"注册失败" afterDelay:0];
//                alert0 = [[UIAlertView alloc] initWithTitle:@"错误" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert0 show];
                
//                [alert0 release];
                
            }else{
                //[USER setObject:@"1" forKey:@"isLogin"];
//                [self login];
                [ControllerManager setIsSuccess:[[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]];
                
                if (self.oriImage || self.self.oriUserImage){
                    isNeedPostImage = YES;
                    
//                    if (self.oriImage!= nil && self.oriUserImage == nil) {
//                        doubleNeedPost = NO;
//                        [self postImage];
//                    }
//                    if (self.oriImage == nil && self.oriUserImage != nil) {
//                        doubleNeedPost = NO;
//                        [self postUserImage];
//                    }
//                    if (self.oriImage != nil && self.oriUserImage != nil) {
//                        doubleNeedPost = YES;
//                        [self postImage];
//                        [self postUserImage];
//                    }
                    
//                    [MMProgressHUD dismissWithSuccess:@"注册成功" title:nil afterDelay:0];
//                    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//                    [MMProgressHUD showWithStatus:@"上传头像中..."];
                }else{
////                    [alert0 setTitle:@"注册成功"];
//                    [MMProgressHUD dismissWithSuccess:@"注册成功" title:nil afterDelay:0.5];
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                    alert0.hidden = YES;
//                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"注册成功" message:@"未上传头像" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [alert show];
//                    [alert release];
//                    [self login];
            
//                    [USER setObject:@"1" forKey:@"Menu"];
//                    [USER setObject:@"1" forKey:@"isChooseInShouldDismiss"];
//                    [self dismissViewControllerAnimated:NO completion:nil];
                }
                [self login];
//                //注册成功，进入之前的选择页
//                NSString * pageNum = [USER objectForKey:@"pageNum"];
//                if([pageNum isEqualToString:@"1"]){
//                    UINavigationController * nc = [ControllerManager shareManagerMyPet];
//                    [self presentViewController:nc animated:YES completion:nil];
//                }else if([pageNum isEqualToString:@"2"]){
//                    //跳转到喜爱页
//                    UINavigationController * fvc = [ControllerManager shareManagerFavorite];
//                    [self presentViewController:fvc animated:NO completion:nil];
//                }else if([pageNum isEqualToString:@"3"]){
//                    UINavigationController * rvc = [ControllerManager shareManagerRandom];
//                    [self presentViewController:rvc animated:YES completion:nil];
//                    [rvc.viewControllers[0] cameraClick];
//                }

            }
        }else{
            [MMProgressHUD dismissWithError:@"注册失败%>_<%" afterDelay:0.5];
//            [alert0 setTitle:@"数据下载失败"];
//            alert0.hidden = YES;
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"数据下载失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//            [alert release];
            NSLog(@"您的网络不佳，注册失败!");
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        
        

            
        
    }];
}

-(NSString*)UTF8_To_GB2312:(NSString*)utf8string
{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* gb2312data = [utf8string dataUsingEncoding:encoding];
    return [[[NSString alloc] initWithData:gb2312data encoding:encoding] autorelease];
}

#pragma mark -登录
-(void)login
{
    NSString * code = [NSString stringWithFormat:@"planet=%@&uid=%@dog&cat", [USER objectForKey:@"planet"], [OpenUDID value]];
    NSString * url = [NSString stringWithFormat:@"%@%@&uid=%@&sig=%@&SID=%@", LOGINAPI, [USER objectForKey:@"planet"], [OpenUDID value], [MyMD5 md5:code], [ControllerManager getSID]];
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            NSLog(@"%@", load.dataDict);
            [ControllerManager setIsSuccess:[[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]];
            [ControllerManager setSID:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"]];
            NSLog(@"isSuccess:%d,SID:%@", [ControllerManager getIsSuccess], [ControllerManager getSID]);
            NSLog(@"是否成功？：%d", [ControllerManager getIsSuccess]);
            [self getUserData];
        }
    }];
}

#pragma mark -获取用户数据
-(void)getUserData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", INFOAPI,[ControllerManager getSID]];
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"errorCode"] intValue] == 2) {
                //SID过期,需要重新登录获取SID
                [self login];
                [self getUserData];
                return;
            }else{
                //SID未过期，直接获取用户数据
                NSLog(@"用户数据：%@", load.dataDict);
                NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                
                [USER setObject:[dict objectForKey:@"a_name"] forKey:@"a_name"];
                if (![[dict objectForKey:@"a_tx"] isKindOfClass:[NSNull class]]) {
                    [USER setObject:[dict objectForKey:@"a_tx"] forKey:@"a_tx"];
                }
                [USER setObject:[dict objectForKey:@"age"] forKey:@"age"];
                [USER setObject:[dict objectForKey:@"gender"] forKey:@"gender"];
                [USER setObject:[dict objectForKey:@"name"] forKey:@"name"];
                [USER setObject:[dict objectForKey:@"exp"] forKey:@"exp"];
                [USER setObject:[dict objectForKey:@"gold"] forKey:@"gold"];
                [USER setObject:[dict objectForKey:@"lv"] forKey:@"lv"];
                [USER setObject:[dict objectForKey:@"usr_id"] forKey:@"usr_id"];
                [USER setObject:[dict objectForKey:@"aid"] forKey:@"aid"];
                
                if (![[dict objectForKey:@"tx"] isKindOfClass:[NSNull class]]) {
                    [USER setObject:[dict objectForKey:@"tx"] forKey:@"tx"];
                }
                /****************/
                if (isNeedPostImage) {
                    if (self.oriImage!= nil && self.oriUserImage == nil) {
                        doubleNeedPost = NO;
                        [self postImage];
                    }
                    if (self.oriImage == nil && self.oriUserImage != nil) {
                        doubleNeedPost = NO;
                        [self postUserImage];
                    }
                    if (self.oriImage != nil && self.oriUserImage != nil) {
                        doubleNeedPost = YES;
                        [self postImage];
                        [self postUserImage];
                    }
                }else{
                    [MMProgressHUD dismissWithSuccess:@"注册成功" title:nil afterDelay:0.5];
                    [USER setObject:@"1" forKey:@"Menu"];
                    [USER setObject:@"1" forKey:@"isChooseInShouldDismiss"];
                    [self dismissViewControllerAnimated:NO completion:nil];
                }
            }
        }
    }];
}

#pragma mark
#pragma mark -ASI
-(void)postImage
{
    //宠物头像上传
    
    //网络上传
    NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", [USER objectForKey:@"aid"]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETTXAPI, [USER objectForKey:@"aid"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@--%@", code, url);
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 30;
    
    NSData * data = UIImageJPEGRepresentation(self.oriImage, 0.1);
//    NSLog(@"data:%@", data);
    //小图片用这种
//    [_request setPostValue:data forKey:@"tx"];
    //大小图片用这种，比较保险
    [_request setData:data withFileName:@"headImage.png" andContentType:@"image/jpg" forKey:@"tx"];
    
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
    [_requestUser setData:data withFileName:@"userHeadImage.png" andContentType:@"image/jpg" forKey:@"tx"];
    
    _requestUser.delegate = self;
    [_requestUser startAsynchronous];
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    [USER setObject:@"1" forKey:@"needRefresh"];
    
//    alert1.hidden = YES;
//    [alert1 release];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [alert0 setTitle:@"注册成功"];
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"注册成功" message:@"头像上传成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alert show];
//    [alert release];
    NSLog(@"headImage upload success");
    NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
//    [self getUserData];
//    alert1.hidden = YES;
    //头像存放在本地
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSLog(@"%@",docDir);
    NSLog(@"saving png");
    if (request == _request) {
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@_headImage.png.png", docDir, [USER objectForKey:@"aid"]];
        NSData * data = UIImagePNGRepresentation(self.oriImage);
        BOOL a = [data writeToFile:pngFilePath atomically:YES];
        NSLog(@"头像存放结果：%d", a);
    }else{
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@_userHeadImage.png.png", docDir, [USER objectForKey:@"usr_id"]];
        NSData * data = UIImagePNGRepresentation(self.oriUserImage);
        BOOL a = [data writeToFile:pngFilePath atomically:YES];
        NSLog(@"头像存放结果：%d", a);
    }
    
    
//    [self login];
    [USER setObject:@"1" forKey:@"Menu"];
    if (doubleNeedPost) {
        if (++postCount == 2) {
            [MMProgressHUD dismissWithSuccess:@"注册成功" title:nil afterDelay:0.5];
            [USER setObject:@"1" forKey:@"Menu"];
            [USER setObject:@"1" forKey:@"isChooseInShouldDismiss"];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }else{
        [MMProgressHUD dismissWithSuccess:@"注册成功" title:nil afterDelay:0.5];
        [USER setObject:@"1" forKey:@"Menu"];
        [USER setObject:@"1" forKey:@"isChooseInShouldDismiss"];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (request == _request) {
        [MMProgressHUD dismissWithError:@"宠物头像上传失败" afterDelay:0.5];
    }else{
        [MMProgressHUD dismissWithError:@"用户头像上传失败" afterDelay:0.5];
    }
//    [alert0 setTitle:@"头像上传失败"];
//    alert1.hidden = YES;
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"头像上传失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alert show];
//    [alert release];
//    alert1.hidden = YES;
    NSLog(@"headImage upload failed");
}

-(void)fromButtonClick
{
    [tf resignFirstResponder];
    pickerBgView.hidden = NO;
    [self completeButton];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
