//
//  ChoosePicTypeViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/3.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "ChoosePicTypeViewController.h"
#define picWidth self.view.frame.size.width/5.0
#define SECONDSPE ((self.view.frame.size.width-picWidth*2)/3.0)
#define THIRDSPE ((self.view.frame.size.width-picWidth*3)/4.0)
#define IMAGEWIDTH (self.view.frame.size.width/6.0-8)
#define IMAGESPE 30
#import "UserPetListModel.h"
#import "PublishViewController.h"
#import "Alert_BegFoodViewController.h"
#import "MenuModel.h"

@interface ChoosePicTypeViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView * bgImageView;
    UIButton * foodBtn;
    UILabel * foodLabel;
    
    UIButton * secondBtn;
    UILabel * secondLabel;
    
    UIButton * thirdBtn;
    UILabel * thirdLabel;
    
    UIView * pubBg;
    UILabel * pubLabel;
    UIScrollView * sv;
    
    UIActionSheet * sheet;
    
}
@property (nonatomic) int currentSelectedIndex;
@property (nonatomic) int publishType;

@property (nonatomic, retain) NSMutableArray * petsDataArray;
@property (nonatomic, retain) NSDictionary * menuDataDict;
@property (nonatomic, retain) NSArray * menuListArray;
@end

@implementation ChoosePicTypeViewController
-(void)dealloc
{
    bgImageView = nil;
    sv = nil;
    pubBg = nil;
    pubLabel = nil;
    sheet = nil;
    
    foodBtn = nil;
    foodLabel = nil;
    secondBtn = nil;
    secondLabel = nil;
    thirdBtn = nil;
    thirdLabel = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.petsDataArray = [NSMutableArray arrayWithCapacity:0];
    self.currentSelectedIndex = 0;
    self.count = 1;
    
    [self makeUI];

    
    self.menuListArray = [USER objectForKey:@"MenuList"];
    self.menuDataDict = [MyControl returnDictionaryWithData:[USER objectForKey:@"MenuData"]];
    
    self.count = self.menuListArray.count;
    
    [self adjustUI];
//    if ([[USER objectForKey:@"MenuData"] isKindOfClass:[NSData class]]){
//        self.menuDataDict = [MyControl returnDictionaryWithData:[USER objectForKey:@"MenuData"]];
//        if (self.menuDataDict.count>1) {
//            self.count = self.menuDataDict.count;
//            [self adjustUI];
//        }
////        else{
////            [self loadMenuData];
////        }
//    }
//    else{
//        [self loadMenuData];
//    }
    
}
//-(void)loadMenuData
//{
////    if ([[USER objectForKey:@"MenuData"] isKindOfClass:[NSData class]] && [[USER objectForKey:@"MenuData"] length] > 0) {
////        NSLog(@"%d", [[USER objectForKey:@"MenuData"] length]);
////        self.menuDataArray = [MyControl returnArrayWithData:[USER objectForKey:@"MenuData"]];
////        self.count = self.menuDataArray.count+1;
////        
////        [self adjustUI];
////    }else{
//        //加载数据
//        LOADING;
//        __block ChoosePicTypeViewController * blockSelf = self;
//        NSString * url = [NSString stringWithFormat:@"%@%@", MENUAPI, [ControllerManager getSID]];
//        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//            if (isFinish) {
//                ENDLOADING;
//                
//                NSArray * array = [load.dataDict objectForKey:@"data"];
//                if ([array isKindOfClass:[NSArray class]]) {
//                    if ([array[0] isKindOfClass:[NSArray class]]) {
//                        NSArray * arr = array[0];
//                        if (arr.count == 0) {
//                            return;
//                        }
//                        NSMutableArray * mutableArray = [NSMutableArray arrayWithCapacity:0];
//                        for (NSDictionary * dict in arr) {
//                            MenuModel * model = [[MenuModel alloc] init];
//                            [model setValuesForKeysWithDictionary:dict];
//                            [mutableArray addObject:model];
//                        }
//                        NSData * data = [MyControl returnDataWithArray:mutableArray];
//                        [USER setObject:data forKey:@"MenuData"];
//                        
//                        blockSelf.menuDataArray = [NSArray arrayWithArray:mutableArray];
//                        blockSelf.count = blockSelf.menuDataArray.count+1;
//                        
//                        [blockSelf adjustUI];
//                    }
//                }
//            }else{
//                [USER setObject:@"" forKey:@"MenuData"];
//                LOADFAILED;
//            }
//        }];
//
////    }
//}

-(void)makeUI
{
    bgImageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"pictype_bg.jpg"];
    [self.view addSubview:bgImageView];
    
    //发布到选择栏
    pubBg = [MyControl createViewWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.width/6.0)];
    pubBg.backgroundColor = [UIColor whiteColor];
    [bgImageView addSubview:pubBg];
    
    pubLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, pubBg.frame.size.width/3.0, pubBg.frame.size.height) Font:15 Text:@"发布到"];
//    107 52 50
    pubLabel.textColor = [UIColor colorWithRed:107/255.0 green:52/255.0 blue:50/255.0 alpha:1];
    pubLabel.textAlignment = NSTextAlignmentCenter;
    [pubBg addSubview:pubLabel];
    
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(pubBg.frame.size.width/2.0-IMAGEWIDTH/2.0, 4, IMAGEWIDTH*2+IMAGESPE, IMAGEWIDTH)];
    sv.showsHorizontalScrollIndicator = NO;
    [pubBg addSubview:sv];
    
    pubLabel.frame = CGRectMake(0, 0, sv.frame.origin.x, pubBg.frame.size.height);
    
    //判断并展示自己创建的宠物
//    myPetsDataArray
//    [[USER objectForKey:@"petsData"] isKindOfClass:[NSData class]]
    if([[USER objectForKey:@"myPetsDataArray"] isKindOfClass:[NSArray class]]){
        NSArray * array = [USER objectForKey:@"myPetsDataArray"];
        self.petsDataArray = [NSMutableArray arrayWithArray:array];
        [self showPets];
    }else{
        [self loadPetsData];
    }
    
//    if ([[USER objectForKey:@"petsData"] isKindOfClass:[NSData class]]) {
//        NSArray * array = [MyControl returnArrayWithData:[USER objectForKey:@"petsData"]];
//        self.petsDataArray = [NSMutableArray arrayWithArray:array];
//        [self showPets];
//    }else{
//        [self loadPetsData];
//    }
    
    
    //底部关闭按钮
    //719*92
    float h = self.view.frame.size.width*92/719.0;
    UIButton * closeBtn = [MyControl createButtonWithFrame:CGRectMake(0, self.view.frame.size.height-h, self.view.frame.size.width, h) ImageName:@"pictype_close.png" Target:self Action:@selector(closeClick) Title:nil];
    [bgImageView addSubview:closeBtn];
    
//    float picWidth = self.view.frame.size.width/5.0;
    UIButton * picBtn = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width/2.0-picWidth/2.0, self.view.frame.size.height/2.0+self.view.frame.size.height/20.0, picWidth, picWidth) ImageName:@"pictype_pic.png" Target:self Action:@selector(picBtnClick) Title:nil];
    picBtn.showsTouchWhenHighlighted = YES;
    [bgImageView addSubview:picBtn];
    
    UILabel * picLabel = [MyControl createLabelWithFrame:CGRectMake(picBtn.frame.origin.x, picBtn.frame.origin.y+picBtn.frame.size.height, picBtn.frame.size.width, 20) Font:15 Text:@"晒照片"];
    picLabel.textAlignment = NSTextAlignmentCenter;
    picLabel.textColor = [UIColor grayColor];
    [bgImageView addSubview:picLabel];
    
    //
    foodBtn = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width/2.0-picWidth/2.0, self.view.frame.size.height/2.0-self.view.frame.size.height/20.0-picWidth, picWidth, picWidth) ImageName:@"pictype_food.png" Target:self Action:@selector(foodBtnClick) Title:nil];
    foodBtn.showsTouchWhenHighlighted = YES;
    [bgImageView addSubview:foodBtn];
    
    foodLabel = [MyControl createLabelWithFrame:CGRectMake(0, foodBtn.frame.size.height, foodBtn.frame.size.width, 20) Font:15 Text:@"挣口粮"];
    foodLabel.textAlignment = NSTextAlignmentCenter;
    foodLabel.textColor = [UIColor grayColor];
    [foodBtn addSubview:foodLabel];
}

-(void)loadPetsData
{
    LOADING;
    NSString * code = [NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
//    NSLog(@"%@", url);
    __block ChoosePicTypeViewController *blockSelf = self;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"%@", load.dataDict);
            [blockSelf.petsDataArray removeAllObjects];
            
            NSArray * array = [load.dataDict objectForKey:@"data"];
            if (array.count) {
                [USER setObject:array forKey:@"myPetsDataArray"];
            }
            blockSelf.petsDataArray = [NSMutableArray arrayWithArray:array];
//            for (NSDictionary * dict in array) {
//                UserPetListModel * model = [[UserPetListModel alloc] init];
//                [model setValuesForKeysWithDictionary:dict];
//                [blockSelf.petsDataArray addObject:model];
//            }
//            
//            NSData * data = [MyControl returnDataWithArray:blockSelf.petsDataArray];
//            [USER setObject:data forKey:@"petsData"];
            
            ENDLOADING;
            [blockSelf showPets];
        }else{
            LOADFAILED;
        }
    }];
//    [request release];
}
-(void)showPets
{
    //过滤掉非创建宠物
    for(int i=0;i<self.petsDataArray.count;i++){
//        UserPetListModel * model
        NSDictionary * dict = self.petsDataArray[i];
        if (![[dict objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
            [self.petsDataArray removeObjectAtIndex:i];
            i--;
        }
    }
    
    
    for(int i=0;i<self.petsDataArray.count;i++){
        float oriX;
        if (self.petsDataArray.count == 1) {
            oriX = 0;
        }else{
            if (i == 0) {
                oriX = 0;
            }else{
                oriX = i*(IMAGEWIDTH + IMAGESPE);
            }
        }
        
        UIButton * headBgBtn = [MyControl createButtonWithFrame:CGRectMake(oriX, 0, IMAGEWIDTH, IMAGEWIDTH) ImageName:@"pictype_unSelected.png" Target:self Action:@selector(headBgBtnClick:) Title:nil];
        [headBgBtn setBackgroundImage:[UIImage imageNamed:@"pictype_selected.png"] forState:UIControlStateSelected];
        if (i == 0) {
            headBgBtn.selected = YES;
        }
        headBgBtn.tag = 100+i;
        [sv addSubview:headBgBtn];
        
        UIImageView * imageView = [MyControl createImageViewWithFrame:CGRectMake(2, 2, IMAGEWIDTH-4, IMAGEWIDTH-4) ImageName:@""];
        imageView.userInteractionEnabled = NO;
        [headBgBtn addSubview:imageView];
        
        NSDictionary * dict = self.petsDataArray[i];
        
        [MyControl setImageForImageView:imageView Tx:[dict objectForKey:@"tx"] isPet:YES isRound:YES];
    }
    if (self.petsDataArray.count > 2) {
        sv.contentSize = CGSizeMake(self.petsDataArray.count*IMAGEWIDTH + (self.petsDataArray.count-1)*IMAGESPE, sv.frame.size.height);
        
        //创建箭头
        //18 31
        float h = IMAGEWIDTH/4.0;
        float w = 18*h/31;
        //间隔
        float spe = 15;
        
        UIImageView * left = [MyControl createImageViewWithFrame:CGRectMake(sv.frame.origin.x-w-spe, sv.frame.origin.y+(IMAGEWIDTH-h)/2, w, h) ImageName:@"pictype_leftArrow.png"];
        [pubBg addSubview:left];
        
        UIImageView * right = [MyControl createImageViewWithFrame:CGRectMake(sv.frame.origin.x+sv.frame.size.width+spe, sv.frame.origin.y+(IMAGEWIDTH-h)/2, w, h) ImageName:@"pictype_rightArrow.png"];
        [pubBg addSubview:right];
        
        
        UIButton * leftBtn = [MyControl createButtonWithFrame:CGRectMake(left.frame.origin.x-spe-5, 0, spe*2+w+5, pubBg.frame.size.height) ImageName:@"" Target:self Action:@selector(leftClick) Title:nil];
//        leftBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [pubBg addSubview:leftBtn];
        
        UIButton * rightBtn = [MyControl createButtonWithFrame:CGRectMake(right.frame.origin.x-spe, 0, spe*2+w+5, pubBg.frame.size.height) ImageName:@"" Target:self Action:@selector(rightClick) Title:nil];
//        rightBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [pubBg addSubview:rightBtn];
        
        CGRect rect = pubLabel.frame;
        rect.size.width = left.frame.origin.x;
        pubLabel.frame = rect;
    }
}
#pragma mark -
-(void)leftClick
{
    float p = IMAGEWIDTH+IMAGESPE;
    float off = sv.contentOffset.x;
    if (off<=p) {
        [UIView animateWithDuration:0.2 animations:^{
            sv.contentOffset = CGPointMake(0, 0);
        }];
        if (off == 0) {
            [MyControl popAlertWithView:self.view Msg:@"前面木有了~"];
        }
        
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            sv.contentOffset = CGPointMake(off-p, 0);
        }];
    }
    
}
-(void)rightClick
{
    float p = IMAGEWIDTH+IMAGESPE;
    float off = sv.contentOffset.x;
    if ((sv.contentSize.width-off-2*p)>=p) {
        [UIView animateWithDuration:0.2 animations:^{
            sv.contentOffset = CGPointMake(off+p, 0);
        }];
    }else{
        //        NSLog(@"%f--%f", sv.contentSize.width-off-3*p, p);
        [UIView animateWithDuration:0.2 animations:^{
            sv.contentOffset = CGPointMake(sv.contentSize.width-2*p+IMAGESPE, 0);
        }];
        if (off >= (self.petsDataArray.count-2) * p) {
            [MyControl popAlertWithView:self.view Msg:@"后面木有了~"];
        }
        
    }
    
}
#pragma mark -
-(void)headBgBtnClick:(UIButton *)btn
{
    //点击已点中按钮无反应
    if (self.currentSelectedIndex == btn.tag-100) {
        return;
    }else{
        //把点中按钮的点中状态去掉
        UIButton * button = (UIButton *)[sv viewWithTag:100+self.currentSelectedIndex];
        button.selected = NO;
    }
    self.currentSelectedIndex = btn.tag-100;
    btn.selected = YES;
    
}

#pragma mark -
-(void)adjustUI
{
    if (self.count == 2) {
        [self createSecond];
    }else if(self.count == 3){
        [self createSecond];
        [self createThird];
    }
}

-(void)createSecond
{
    CGRect rect1 = foodBtn.frame;
    rect1.origin.x = SECONDSPE;
    foodBtn.frame = rect1;
    
    MenuModel * model = [self.menuDataDict objectForKey:self.menuListArray[1]];
    
    secondBtn = [MyControl createButtonWithFrame:CGRectMake(rect1.origin.x + picWidth + SECONDSPE, rect1.origin.y, picWidth, picWidth) ImageName:@"" Target:self Action:@selector(secondBtnClick) Title:nil];
    secondBtn.showsTouchWhenHighlighted = YES;
    [bgImageView addSubview:secondBtn];
    [secondBtn setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MENUURL, model.icon]] forState:UIControlStateNormal];

    
    secondLabel = [MyControl createLabelWithFrame:CGRectMake(0, secondBtn.frame.size.height, secondBtn.frame.size.width, 20) Font:15 Text:model.txt];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.textColor = [UIColor grayColor];
    [secondBtn addSubview:secondLabel];
}

-(void)createThird
{
    CGRect rect1 = foodBtn.frame;
    rect1.origin.x = THIRDSPE;
    foodBtn.frame = rect1;
    
    CGRect rect2 = secondBtn.frame;
    rect2.origin.x = rect1.origin.x + picWidth + THIRDSPE;
    secondBtn.frame = rect2;
    
    MenuModel * model = [self.menuDataDict objectForKey:self.menuListArray[2]];
    
    thirdBtn = [MyControl createButtonWithFrame:CGRectMake(rect2.origin.x + picWidth + THIRDSPE, rect2.origin.y, picWidth, picWidth) ImageName:@"" Target:self Action:@selector(thirdBtnClick) Title:nil];
    thirdBtn.showsTouchWhenHighlighted = YES;
    [bgImageView addSubview:thirdBtn];
    [thirdBtn setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MENUURL, model.icon]] forState:UIControlStateNormal];
    
    thirdLabel = [MyControl createLabelWithFrame:CGRectMake(0, thirdBtn.frame.size.height, thirdBtn.frame.size.width, 20) Font:15 Text:model.txt];
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.textColor = [UIColor grayColor];
    [thirdBtn addSubview:thirdLabel];
}

-(void)picBtnClick
{
    NSLog(@"晒照片");
    self.publishType = 0;
    [self camaraClick];
}
-(void)foodBtnClick
{
    NSLog(@"挣口粮");
    self.publishType = 1;
    [self judgeFood:self.publishType];
}
-(void)secondBtnClick
{
    NSLog(@"第二按钮");
    self.publishType = [self.menuListArray[1] integerValue];
    [self judgeFood:self.publishType];
}
-(void)thirdBtnClick
{
    NSLog(@"第三按钮");
    self.publishType = [self.menuListArray[2] integerValue];
    [self judgeFood:self.publishType];
}
#pragma mark -
-(void)judgeFood:(int)type
{
    //请求API判断是否是否能发图
    LOADING;
    NSDictionary * dict = self.petsDataArray[self.currentSelectedIndex];
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&is_food=%ddog&cat", [dict objectForKey:@"aid"], type]];
    NSString * url = [NSString stringWithFormat:@"%@%@&is_food=%d&sig=%@&SID=%@", JUDGEDOAPI, [dict objectForKey:@"aid"], type, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
//    __block NSDictionary * blockDict = dict;
    __block ChoosePicTypeViewController * blockSelf = self;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                ENDLOADING;
    
                if (![[[load.dataDict objectForKey:@"data"] objectForKey:@"r"] isKindOfClass:[NSDictionary class]]) {
                    [blockSelf camaraClick];
                }else{
                    //弹分享框
                    Alert_BegFoodViewController * vc = [[Alert_BegFoodViewController alloc] init];
                    vc.dict = [[load.dataDict objectForKey:@"data"] objectForKey:@"r"];
                    vc.name = [blockSelf.petsDataArray[blockSelf.currentSelectedIndex] objectForKey:@"name"];
                    vc.is_food = self.publishType;
                    [ControllerManager addViewController:vc To:blockSelf];
//                    [blockSelf addChildViewController:vc];
//                    [blockSelf.view addSubview:vc.view];
//                    [vc didMoveToParentViewController:blockSelf];
                }
            }else{
                LOADFAILED;
            }
        }else{
            LOADFAILED;
        }
    }];
}


-(void)camaraClick
{
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
}
-(void)closeClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - 相机
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
//        [USER setObject:[NSString stringWithFormat:@"%d", buttonIndex] forKey:@"buttonIndex"];
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
        
//        [imagePickerController release];
        //        [self performSelector:@selector(jumpCamaraOrPhoto:) withObject:[NSString stringWithFormat:@"%d", sourceType] afterDelay:0.5];
        
    }
}

#pragma mark - UIImagePicker Delegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@", info);
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%d", image.imageOrientation);
    image = [MyControl fixOrientation:image];
    
    __block ChoosePicTypeViewController * blockSelf = self;
    
    [self dismissViewControllerAnimated:NO completion:^{
        //Publish
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        PublishViewController * vc = [[PublishViewController alloc] init];
        
        vc.publishType = blockSelf.publishType;
        if (blockSelf.publishType == 1) {
            vc.isBeg = YES;
        }
        
        NSDictionary * dict = blockSelf.petsDataArray[blockSelf.currentSelectedIndex];
        UserPetListModel * model = [[UserPetListModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        
        vc.oriImage = image;
        vc.name = model.name;
        vc.aid = model.aid;
        vc.showFrontImage = ^(NSString * img_id, NSInteger isFood, NSString * aid, NSString * name){
            if (!isFood) {
                __block FrontImageDetailViewController * front = [[FrontImageDetailViewController alloc] init];
                front.img_id = img_id;
//                [ControllerManager addViewController:front To:blockSelf];
                [ControllerManager addTabBarViewController:front];
                
            }else{
                NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&is_food=%ddog&cat", [dict objectForKey:@"aid"], isFood]];
                NSString * url = [NSString stringWithFormat:@"%@%@&is_food=%d&sig=%@&SID=%@", JUDGEDOAPI, [dict objectForKey:@"aid"], isFood, sig, [ControllerManager getSID]];
                NSLog(@"%@", url);
                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"r"] isKindOfClass:[NSDictionary class]]) {
                        __block Alert_BegFoodViewController * begFood = [[Alert_BegFoodViewController alloc] init];
                        begFood.dict = [[load.dataDict objectForKey:@"data"] objectForKey:@"r"];
                        begFood.name = model.name;
                        begFood.is_food = isFood;
                        [ControllerManager addTabBarViewController:begFood];
                    }
                    
                }];
            }

            
            [blockSelf dismissViewControllerAnimated:NO completion:nil];
        };
        [blockSelf presentViewController:vc animated:YES completion:nil];
    }];
    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

@end
