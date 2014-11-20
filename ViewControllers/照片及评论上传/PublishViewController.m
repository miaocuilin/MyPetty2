//
//  PublishViewController.m
//  MyPetty
//
//  Created by Aidi on 14-7-1.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PublishViewController.h"
#import "DetailViewController.h"
//#import "UMSocialDataService.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <AviarySDK/AviarySDK.h>
static NSString * const kAFAviaryAPIKey = @"b681eafd0b581b46";
static NSString * const kAFAviarySecret = @"389160adda815809";
#import "AtUsersViewController.h"
#import "TopicViewController.h"
//#import "IQKeyboardManager.h"

@interface PublishViewController () <UITextViewDelegate,AFPhotoEditorControllerDelegate>
{
    UITextView * _textView;
    CGRect rect;
    UILabel * limitLabel;
    UIButton * sina;
    UIButton * weChat;
}
@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;
@end

@implementation PublishViewController

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
    if ([[USER objectForKey:@"selectTopic"] intValue] == 1) {
        [topic setTitle:[NSString stringWithFormat:@"#%@#", [USER objectForKey:@"topic"]] forState:UIControlStateNormal];
        [USER setObject:@"0" forKey:@"selectTopic"];
    }
    
//    if ([[[USER objectForKey:@"atUsers"] count] intValue] == 0) {
//        [users setTitle:@"点击@用户" forState:UIControlStateNormal];
//    }else{
//        [users setTitle:[NSString stringWithFormat:@"@豆豆 等%d个用户", [[[USER objectForKey:@"atUsers"] count] intValue]] forState:UIControlStateNormal];
//    }
    
    
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    isInPublish = YES;
//}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    isInPublish = NO;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //清空topic
    [USER setObject:@"点击添加话题" forKey:@"topic"];
    
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
    
    [self createBg];
    [self createFakeNavigation];
    [self makeUI];
}


-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
//    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
//    NSLog(@"%@", filePath);
//    NSData * data = [NSData dataWithContentsOfFile:filePath];
//    //    NSLog(@"%@", data);
//    UIImage * image = [UIImage imageWithData:data];
    bgImageView.image = [self.oriImage applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
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
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"发布照片"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIButton * rightButton = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-20-17, 30, 20, 20) ImageName:@"30-1.png" Target:self Action:@selector(rightButtonClick) Title:nil];
    rightButton.showsTouchWhenHighlighted = YES;
    [navView addSubview:rightButton];
}

-(void)backBtnClick
{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)makeUI
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    sv.contentSize = CGSizeMake(320, 568);
    [self.view addSubview:sv];
//    UIImageView * bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@""];
//    [self.view addSubview:bgImageView];
    
//    UIButton * leftButton = [MyControl createButtonWithFrame:CGRectMake(15, 25, 25, 25) ImageName:@"7-7.png" Target:self Action:@selector(leftButtonClick) Title:nil];
//    [navView addSubview:leftButton];
//    
//    UIButton * rightButton = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-25-15, 25, 25, 25) ImageName:@"30-1.png" Target:self Action:@selector(rightButtonClick) Title:nil];
//    [bgImageView addSubview:rightButton];
    
    bigImageView = [MyControl createImageViewWithFrame:CGRectMake(10, 64+5, self.view.frame.size.width-20, 230) ImageName:@""];
//    bigImageView.image = [UIImage imageNamed:@"cat2.jpg"];
    bigImageView.image = self.oriImage;
    float Width = self.oriImage.size.width;
    float Height = self.oriImage.size.height;
//    if (Width>300) {
//        float w = 300/Width;
//        Width *= w;
//        Height *= w;
//    }
//    if (Height>230) {
        float h = (self.view.frame.size.width-20)/Width;
//        Width *= h;
        Height *= h;
//    }
    bigImageView.frame = CGRectMake((self.view.frame.size.width-300)/2, bigImageView.frame.origin.y, self.view.frame.size.width-20, Height);
    bigImageView.layer.cornerRadius = 5;
    bigImageView.layer.masksToBounds = YES;
    [sv addSubview:bigImageView];
    
    /***********#话题#  @用户  发布到************/
    int width = (self.view.frame.size.width-20-7.5*2)/3;
    float space = 7.5;
    
    topic = [MyControl createButtonWithFrame:CGRectMake(10, bigImageView.frame.origin.y+bigImageView.frame.size.height+4, width, 30) ImageName:@"" Target:self Action:@selector(topicClick) Title:[NSString stringWithFormat:@"#%@#", [USER objectForKey:@"topic"]]];
    topic.titleLabel.font = [UIFont systemFontOfSize:13];
    topic.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    topic.layer.cornerRadius = 3;
    topic.layer.masksToBounds = YES;
    topic.showsTouchWhenHighlighted = YES;
    [sv addSubview:topic];
    
    users = [MyControl createButtonWithFrame:CGRectMake(topic.frame.origin.x+topic.frame.size.width+space, bigImageView.frame.origin.y+bigImageView.frame.size.height+4, width, 30) ImageName:@"" Target:self Action:@selector(usersClick) Title:@"点击@小伙伴"];
//    users.userInteractionEnabled = NO;
//    if ([[USER objectForKey:@"atUsers"] count] == 0) {
//        [users setTitle:@"点击@用户" forState:UIControlStateNormal];
//    }else{
//        [users setTitle:[NSString stringWithFormat:@"@豆豆 等%d个用户", [[[USER objectForKey:@"atUsers"] count] intValue]] forState:UIControlStateNormal];
//    }
    users.titleLabel.font = [UIFont systemFontOfSize:13];
    users.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    users.layer.cornerRadius = 3;
    users.layer.masksToBounds = YES;
    users.showsTouchWhenHighlighted = YES;
    [sv addSubview:users];
    
    publishTo = [MyControl createButtonWithFrame:CGRectMake(users.frame.origin.x+users.frame.size.width+space, bigImageView.frame.origin.y+bigImageView.frame.size.height+4, width, 30) ImageName:@"" Target:self Action:@selector(usersClick) Title:[NSString stringWithFormat:@"发布到%@", [[USER objectForKey:@"petInfoDict"] objectForKey:@"name"]]];
    if (self.name != nil) {
        [publishTo setTitle:[NSString stringWithFormat:@"发布到%@", self.name] forState:UIControlStateNormal];
    }
    publishTo.userInteractionEnabled = NO;
    publishTo.titleLabel.font = [UIFont systemFontOfSize:13];
    publishTo.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    publishTo.layer.cornerRadius = 3;
    publishTo.layer.masksToBounds = YES;
    publishTo.showsTouchWhenHighlighted = YES;
    [sv addSubview:publishTo];
    /***********************************/
//    _textView = [MyControl createTextFieldWithFrame:CGRectMake(10, bigImageView.frame.origin.y+bigImageView.frame.size.height+5, 300, 80) placeholder:@"为您爱宠的靓照写个描述吧~" passWord:NO leftImageView:nil rightImageView:nil Font:17];
    textBgView = [MyControl createViewWithFrame:CGRectMake(10, bigImageView.frame.origin.y+bigImageView.frame.size.height+5+33, 300, 80)];
    //将大小赋值给全局变量
    rect = textBgView.frame;
    [sv addSubview:textBgView];
    
    limitLabel = [MyControl createLabelWithFrame:CGRectMake(textBgView.frame.size.width-15-80, textBgView.frame.size.height-25-30, 80, 30) Font:25 Text:@"40"];
    limitLabel.textAlignment = NSTextAlignmentRight;
//    [UIColor colorWithRed:200/255.0 green:180/255.0 blue:180/255.0 alpha:1]
    limitLabel.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
    [textBgView addSubview:limitLabel];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    if ([[USER objectForKey:@"isFromActivity"] intValue] == 1) {
        _textView.text = [USER objectForKey:@"Topic"];
        limitLabel.text = [NSString stringWithFormat:@"%d", 40-_textView.text.length];
        [USER setObject:@"0" forKey:@"isFromActivity"];
    }else{
        _textView.text = @"为您爱宠的靓照写个描述吧~";
    }
    _textView.font = [UIFont systemFontOfSize:17];
    
    _textView.delegate = self;
    _textView.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1];
    _textView.alpha = 0.6;
    _textView.returnKeyType = UIReturnKeyDone;
//    _textView.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [textBgView addSubview:_textView];
    
    publishButton = [MyControl createButtonWithFrame:CGRectMake(10, textBgView.frame.origin.y+textBgView.frame.size.height+5, 300, 35) ImageName:@"" Target:self Action:@selector(publishButtonClick:) Title:@"发布"];
    publishButton.backgroundColor = BGCOLOR;
    publishButton.layer.cornerRadius = 5;
    publishButton.layer.masksToBounds = YES;
    [sv addSubview:publishButton];
    
    /************************************/
    UIImageView * bgImageView2 = [MyControl createImageViewWithFrame:CGRectMake(10, publishButton.frame.origin.y+publishButton.frame.size.height+5, 300, 45) ImageName:nil];
//    bgImageView2.image = [[UIImage imageNamed:@"30-2-2.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    /*******************/
    sv.contentSize = CGSizeMake(self.view.frame.size.width, bgImageView2.frame.origin.y+bgImageView2.frame.size.height+20);
    /*******************/
    bgImageView2.image = [[UIImage imageNamed:@"30-2-2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
    [sv addSubview:bgImageView2];
    
    sina = [MyControl createButtonWithFrame:CGRectMake(20+5, 5+5, 25, 25) ImageName:@"publish_unSelected.png" Target:self Action:@selector(sinaClick) Title:nil];
    [bgImageView2 addSubview:sina];
    [sina setBackgroundImage:[UIImage imageNamed:@"publish_selected.png"] forState:UIControlStateSelected];
    
    sinaLabel = [MyControl createLabelWithFrame:CGRectMake(sina.frame.origin.x+sina.frame.size.width+7, 10, 80, 25) Font:15 Text:@"新浪微博"];
    sinaLabel.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1];
    [bgImageView2 addSubview:sinaLabel];
    
    if ([[USER objectForKey:@"sina"] intValue] == 1) {
        sina.selected = YES;
        sinaLabel.textColor = BGCOLOR;
    }else{
        sina.selected = NO;
    }
    /*============================*/
    UIImageView * line = [MyControl createImageViewWithFrame:CGRectMake(300/2, 0, 2, bgImageView2.frame.size.height) ImageName:@"30-2.png"];
    [bgImageView2 addSubview:line];
    
    weChat = [MyControl createButtonWithFrame:CGRectMake(170+5, 5+5, 25, 25) ImageName:@"publish_unSelected.png" Target:self Action:@selector(weChatClick) Title:nil];
    [bgImageView2 addSubview:weChat];
    [weChat setBackgroundImage:[UIImage imageNamed:@"publish_selected.png"] forState:UIControlStateSelected];
    
    weChatLabel = [MyControl createLabelWithFrame:CGRectMake(weChat.frame.origin.x+weChat.frame.size.width+7, 10, 80, 25) Font:15 Text:@"微信朋友圈"];
    weChatLabel.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1];
    [bgImageView2 addSubview:weChatLabel];
    
    if ([[USER objectForKey:@"weChat"] intValue] == 1) {
        weChat.selected = YES;
        weChatLabel.textColor = BGCOLOR;
    }else{
        weChat.selected = NO;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [self.view bringSubviewToFront:navView];
}
#pragma mark - #话题点击事件
-(void)topicClick
{
    NSLog(@"进入#话题页");
    TopicViewController * vc = [[TopicViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)usersClick
{
    NSLog(@"进入@用户页");
    AtUsersViewController * vc = [[AtUsersViewController alloc] init];
    vc.sendNameAndIds = ^(NSString * name, NSString * idsString){
        if (name != nil && name.length != 0) {
            [users setTitle:name forState:UIControlStateNormal];
            self.usr_ids = idsString;
        }else{
            
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
#pragma mark -
-(void)publishButtonClick:(UIButton *)button
{
    //规定上传图片的大小尺寸，不符合不允许上传
//    float Width = bigImageView.image.size.width;
//    float Height = bigImageView.image.size.height;
//    if(Width<100 || Height<100){
//        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"提示" Message:@"您的照片尺寸太小，其它盆友看不清哦~\n温馨提示:最小尺寸100×100." delegate:nil cancelTitle:nil otherTitles:@"确定"];
//        return;
//    }
    
    
    //0.45           0.8
//    NSLog(@"%f--%f--%f\n%f--%f--%f", 640/1136.0*0.8, Width/Height, 640/960.0*1.2, 640/1136.0*0.8, Height/Width, 640/960.0*1.2);
//    if ((Height>Width&&(Width/Height<640/1136*0.8 || Width/Height>640/960*1.2)) || (Height<Width&&(Height/Width<640/1136*0.8 || Height/Width>640/960*1.2))) {
//        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"提示" Message:@"抱歉，您的照片长宽比不符合要求，暂不支持全景图及长图 = =。" delegate:nil cancelTitle:nil otherTitles:@"确定"];
//        return;
//    }
    if (_textView.text.length>40) {
        StartLoading;
        [MyControl loadingFailedWithContent:@"最多输入40个字哦亲~" afterDelay:0.5];
        return;
    }
    
    button.userInteractionEnabled = NO;
    int s = [[USER objectForKey:@"sina"] intValue];
    int w = [[USER objectForKey:@"weChat"] intValue];
    
    [self postData:self.oriImage];
    
    if (s == 1 && w == 0) {
//        BOOL isOauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
//        if (isOauth) {
//            
//        }
        NSString * str = nil;
        if ([_textView.text isEqualToString:@"为您爱宠的靓照写个描述吧~"]) {
            str = @"http://home4pet.aidigame.com/（分享自@宠物星球社交应用）";
        }else{
            str = [NSString stringWithFormat:@"%@ %@", _textView.text, @"http://home4pet.aidigame.com/（分享自@宠物星球社交应用）"];
        }
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            NSLog(@"sina-response:%@", response);
            button.userInteractionEnabled = YES;
            if ([response.message isEqualToString:@"user cancel the operation"]) {
                return;
            }
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
//                [self postData:self.oriImage];
            }
            
        }];
    }else if(s == 0 && w == 1){
        button.userInteractionEnabled = YES;
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_textView.text image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            NSLog(@"weChat-response:%@", response);
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
//                [self postData:self.oriImage];
            }
        }];

    }else if(s == 1 && w == 1){
        NSString * str = nil;
        if ([_textView.text isEqualToString:@"为您爱宠的靓照写个描述吧~"]) {
            str = @"http://home4pet.aidigame.com/（分享自@宠物星球社交应用）";
        }else{
            str = [NSString stringWithFormat:@"%@ %@", _textView.text, @"http://home4pet.aidigame.com/（分享自@宠物星球社交应用）"];
        }
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            button.userInteractionEnabled = YES;
            //分享微信
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_textView.text image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                NSLog(@"weChat-response:%@", response);
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
            
            NSLog(@"sina-response:%@", response);
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                
//                [self postData:self.oriImage];
            }
            
        }];
    }else{
//        [self postData:self.oriImage];
    }
    
}
#pragma mark - 新浪、微信点击事件
-(void)sinaClick
{
    sina.selected = !sina.selected;
    if (sina.selected) {
        [USER setObject:@"1" forKey:@"sina"];
        sinaLabel.textColor = BGCOLOR;
    }else{
        [USER setObject:@"0" forKey:@"sina"];
        sinaLabel.textColor = [UIColor blackColor];
    }
    
}
-(void)weChatClick
{
    weChat.selected = !weChat.selected;
    if (weChat.selected) {
        [USER setObject:@"1" forKey:@"weChat"];
        weChatLabel.textColor = BGCOLOR;
    }else{
        [USER setObject:@"0" forKey:@"weChat"];
        weChatLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark - textFieldDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length>40){
        limitLabel.textColor = [UIColor redColor];
    }else{
        limitLabel.textColor = [UIColor colorWithRed:200/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    }
    limitLabel.text = [NSString stringWithFormat:@"%d", 40-textView.text.length];
//    NSLog(@"%d", _textView.text.length);
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NSLog(@"%@", text);
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    isInPublish = YES;
    if ([_textView.text isEqualToString:@"为您爱宠的靓照写个描述吧~"]) {
        _textView.text = @"";
    }
    _textView.textColor = [UIColor blackColor];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    isInPublish = NO;
    if (_textView.text.length == 0) {
        _textView.text = @"为您爱宠的靓照写个描述吧~";
        _textView.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1];
    }
}

#pragma mark -键盘监听
-(void)keyboardWillShow:(NSNotification *)info
{
    float h = sv.contentOffset.y;
    if (textBgView.frame.origin.y+textBgView.frame.size.height-h<=(self.view.frame.size.height-216)) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        textBgView.frame = CGRectMake(10, self.view.frame.size.height-80-216+h, 300, 80);
    }];
}
-(void)keyboardWillHide:(NSNotification *)info
{
    if (textBgView.frame.origin.y == rect.origin.y) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        textBgView.frame = rect;
    }];
}

-(void)keyboardWasChange:(NSNotification *)notification
{
    if (!isInPublish) {
        return;
    }
    float y = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    if (y == self.view.frame.size.height) {
        return;
    }
    float height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSString * str = [[UITextInputMode currentInputMode] primaryLanguage];
    
//    if (_textView.frame.origin.y+_textView.frame.size.height>=(self.view.frame.size.height-height)) {
//        if (_textView.frame.origin.y == rect.origin.y) {
//            return;
//        }else{
//            _textView.frame = rect;
//            return;
//        }
//    }
    
    if ([str isEqualToString:@"zh-Hans"]) {
        
        [UIView animateWithDuration:0.25 animations:^{
            textBgView.frame = CGRectMake(10, self.view.frame.size.height-height-80+sv.contentOffset.y, 300, 80);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            textBgView.frame = CGRectMake(10, self.view.frame.size.height-height-80+sv.contentOffset.y, 300, 80);
        }];
    }
}
#pragma mark -
-(void)leftButtonClick
{
    NSLog(@"重新编辑");
//    [self lauchEditorWithImage:self.oriImage];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self presentViewController:self.af animated:YES completion:nil];
}
-(void)rightButtonClick
{
    NSLog(@"关闭");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark -ASI

-(void)postData:(UIImage *)image
{
    [MyControl startLoadingWithStatus:@"发布中..."];
//    [USER objectForKey:@"aid"]
    NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", [USER objectForKey:@"aid"]];
    
    //网络上传
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETIMAGEAPI, [USER objectForKey:@"aid"], [MyMD5 md5:code], [ControllerManager getSID]];
    if (self.aid != nil) {
        code = [NSString stringWithFormat:@"aid=%@dog&cat", self.aid];
        url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETIMAGEAPI, self.aid, [MyMD5 md5:code], [ControllerManager getSID]];
    }
    NSLog(@"postUrl:%@", url);
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 60.0;
    
//    float p = 1.0;
//    image.
    NSData * data = [MyControl scaleToSize:image];
//    NSData * data = UIImageJPEGRepresentation(image, 1);
//    NSLog(@"%d", data.length);
//    while (data.length>100*1024) {
//        p -= 0.1;
//        data = UIImageJPEGRepresentation(image, p);
//        NSLog(@"%d", data.length);
//    }
    NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
    [_request setData:data withFileName:[NSString stringWithFormat:@"%.0f%@%d%@_%d&%d.png", timeInterval, @"@", data.length, @"@", (int)image.size.width, (int)image.size.height] andContentType:@"image/jpg" forKey:@"image"];
    //    [_request setPostValue:data forKey:@"image"];
    //图片
    if (![_textView.text isEqualToString:@"为您爱宠的靓照写个描述吧~"]) {
        [_request setPostValue:_textView.text forKey:@"comment"];
    }else{
        [_request setPostValue:@"" forKey:@"comment"];
    }
//    [_request setPostValue:@"" forKey:@"comments"];
//
    [_request setPostValue:@"" forKey:@"topic_id"];
    NSLog(@"topic:%@", [USER objectForKey:@"topic"]);
    if ([[USER objectForKey:@"topic"] isEqualToString:@"点击添加话题"]) {
        [_request setPostValue:@"" forKey:@"topic_name"];
    }else{
        [_request setPostValue:[USER objectForKey:@"topic"] forKey:@"topic_name"];
    }
    /************/
    if ([users.titleLabel.text isEqualToString:@"点击@小伙伴"]) {
        [_request setPostValue:@"" forKey:@"relates"];
    }else{
        NSLog(@"%@", users.titleLabel.text);
        [_request setPostValue:users.titleLabel.text forKey:@"relates"];
    }
    
//    NSLog(@"%@", _textView.text);
    _request.delegate = self;
    [_request startAsynchronous];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    //    if ([[request.responseData objectForKey:@"errorCode"] intValue]) {
    //        <#statements#>
    //    }
    
    [USER setObject:@"1" forKey:@"needRefresh"];
    NSLog(@"success");
    StartLoading;
    
    NSLog(@"响应：%@", [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    //如果返回正常，将图片存到本地
    if([[dict objectForKey:@"data"] isKindOfClass:[NSDictionary class]] && [[[dict objectForKey:@"data"] objectForKey:@"image"] isKindOfClass:[NSDictionary class]]){
        [MobClick event:@"photo"];
        
        NSString * url = [[[dict objectForKey:@"data"] objectForKey:@"image"] objectForKey:@"url"];
        NSData * data = [MyControl scaleToSize:self.oriImage];
        NSString * path = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", url]];
        BOOL a = [data writeToFile:path atomically:YES];
        NSLog(@"本地存储结果：%d", a);
    }
    
    if ([[dict objectForKey:@"errorCode"] intValue] == -1) {
        [MMProgressHUD dismissWithError:[dict objectForKey:@"errorMessage"] afterDelay:1];
        NSLog(@"errorMessage:%@", [dict objectForKey:@"errorMessage"]);
        publishButton.userInteractionEnabled = YES;
    }else if([[dict objectForKey:@"state"] intValue] == 2){
        [self login];
    }else{
        int exp = [[USER objectForKey:@"exp"] intValue];
        [USER setObject:[[dict objectForKey:@"data"] objectForKey:@"exp"] forKey:@"exp"];
        int index = [[USER objectForKey:@"exp"] intValue]-exp;
        if (index > 0) {
            [ControllerManager HUDImageIcon:@"Star.png" showView:self.view.window yOffset:0 Number:index];
            
        }
        [MyControl loadingSuccessWithContent:@"发布成功" afterDelay:0.5f];
        
        [UIView animateWithDuration:0 delay:0.2 options:0 animations:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } completion:nil];
    }
    
    //分享到微博
//    if ([[USER objectForKey:@"sina"] intValue] == 1) {
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:_textView.text image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            NSLog(@"sina-response:%@", response);
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//            }
//            
//        }];
//    }
    
    //微博分享后再跳微信
//    if ([[USER objectForKey:@"weChat"] intValue] == 1) {
//        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_textView.text image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            NSLog(@"weChat-response:%@", response);
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//            }
//        }];
//    }
    
//    DetailViewController * vc = [[DetailViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:^{
    
    
//    }];
//    [vc release];
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"上传失败"];
    LoadingFailed;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - login
-(void)login
{
    StartLoading;
    NSString * code = [NSString stringWithFormat:@"uid=%@dog&cat",  UDID];
    NSString * url = [NSString stringWithFormat:@"%@&uid=%@&sig=%@", LOGINAPI, UDID, [MyMD5 md5:code]];
    NSLog(@"login-url:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            NSLog(@"%@", load.dataDict);
            [ControllerManager setIsSuccess:[[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]];
            [ControllerManager setSID:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"]];
            [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] forKey:@"isSuccess"];
            [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"] forKey:@"SID"];
        
            LoadingSuccess;
//            [self publishButtonClick:publishButton];
        }else{
            LoadingFailed;
        }
    }];
    [request release];
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
    
    __block PublishViewController * blockSelf = self;
    
    // Call render on the context. The render will asynchronously apply all changes made in the session (and therefore editor)
    // to the context's image. It will not complete until some point after the session closes (i.e. the editor hits done or
    // cancel in the editor). When rendering does complete, the completion block will be called with the result image if changes
    // were made to it, or `nil` if no changes were made. In this case, we write the image to the user's photo album, and release
    // our reference to the session.
    [context render:^(UIImage *result) {
        if (result) {
            //保存编辑完的照片
//            UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
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
    self.oriImage = image;
    bigImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// This is called when the user taps "Cancel" in the photo editor.
- (void) photoEditorCanceled:(AFPhotoEditorController *)editor
{
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
