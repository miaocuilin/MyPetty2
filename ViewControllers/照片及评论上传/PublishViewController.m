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
    
    
    [self makeUI];
}

-(void)makeUI
{
    UIImageView * bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"30-3.png"];
    [self.view addSubview:bgImageView];
    
    UIButton * leftButton = [MyControl createButtonWithFrame:CGRectMake(15, 25, 25, 25) ImageName:@"7-7.png" Target:self Action:@selector(leftButtonClick) Title:nil];
    [bgImageView addSubview:leftButton];
    
    UIButton * rightButton = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-25-15, 25, 25, 25) ImageName:@"30-1.png" Target:self Action:@selector(rightButtonClick) Title:nil];
    [bgImageView addSubview:rightButton];
    
    bigImageView = [MyControl createImageViewWithFrame:CGRectMake(10, rightButton.frame.origin.y+25+10, self.view.frame.size.width-20, 230) ImageName:@""];
    bigImageView.image = self.oriImage;
    float Width = self.oriImage.size.width;
    float Height = self.oriImage.size.height;
    if (Width>300) {
        float w = 300/Width;
        Width *= w;
        Height *= w;
    }
    if (Height>230) {
        float h = 230/Height;
        Width *= h;
        Height *= h;
    }
    bigImageView.frame = CGRectMake((self.view.frame.size.width-Width)/2, bigImageView.frame.origin.y, Width, Height);
    bigImageView.layer.cornerRadius = 5;
    bigImageView.layer.masksToBounds = YES;
    [bgImageView addSubview:bigImageView];
    
//    _textView = [MyControl createTextFieldWithFrame:CGRectMake(10, bigImageView.frame.origin.y+bigImageView.frame.size.height+5, 300, 80) placeholder:@"为您爱宠的靓照写个描述吧~" passWord:NO leftImageView:nil rightImageView:nil Font:17];
    textBgView = [MyControl createViewWithFrame:CGRectMake(10, bigImageView.frame.origin.y+bigImageView.frame.size.height+5, 300, 80)];
    //将大小赋值给全局变量
    rect = textBgView.frame;
    [bgImageView addSubview:textBgView];
    
    limitLabel = [MyControl createLabelWithFrame:CGRectMake(textBgView.frame.size.width-15-80, textBgView.frame.size.height-25-30, 80, 30) Font:25 Text:@"40"];
    limitLabel.textAlignment = NSTextAlignmentRight;
    limitLabel.textColor = [UIColor colorWithRed:200/255.0 green:180/255.0 blue:180/255.0 alpha:1];
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
    
    UIButton * publishButton = [MyControl createButtonWithFrame:CGRectMake(10, textBgView.frame.origin.y+textBgView.frame.size.height+5, 300, 35) ImageName:@"" Target:self Action:@selector(publishButtonClick:) Title:@"发布"];
    publishButton.backgroundColor = BGCOLOR;
    publishButton.layer.cornerRadius = 5;
    publishButton.layer.masksToBounds = YES;
    [bgImageView addSubview:publishButton];
    
    /************************************/
    UIImageView * bgImageView2 = [MyControl createImageViewWithFrame:CGRectMake(10, publishButton.frame.origin.y+publishButton.frame.size.height+5, 300, 45) ImageName:nil];
//    bgImageView2.image = [[UIImage imageNamed:@"30-2-2.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    
    bgImageView2.image = [[UIImage imageNamed:@"30-2-2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
    [bgImageView addSubview:bgImageView2];
    
    sina = [MyControl createButtonWithFrame:CGRectMake(20, 5, 35, 35) ImageName:@"weibo.png" Target:self Action:@selector(sinaClick) Title:nil];
    if ([[USER objectForKey:@"sina"] intValue] == 1) {
        sina.selected = YES;
    }else{
        sina.selected = NO;
    }
    [bgImageView2 addSubview:sina];
    [sina setBackgroundImage:[UIImage imageNamed:@"weibo-1.png"] forState:UIControlStateSelected];
    
    UILabel * sinaLabel = [MyControl createLabelWithFrame:CGRectMake(sina.frame.origin.x+sina.frame.size.width+3, 10, 80, 25) Font:15 Text:@"新浪微博"];
    sinaLabel.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1];
    [bgImageView2 addSubview:sinaLabel];
    
    UIImageView * line = [MyControl createImageViewWithFrame:CGRectMake(300/2, 0, 2, bgImageView2.frame.size.height) ImageName:@"30-2.png"];
    [bgImageView2 addSubview:line];
    
    weChat = [MyControl createButtonWithFrame:CGRectMake(170, 5, 35, 35) ImageName:@"wxFriend.png" Target:self Action:@selector(weChatClick) Title:nil];
    if ([[USER objectForKey:@"weChat"] intValue] == 1) {
        weChat.selected = YES;
    }else{
        weChat.selected = NO;
    }
    [bgImageView2 addSubview:weChat];
    [weChat setBackgroundImage:[UIImage imageNamed:@"wxFriend-1.png"] forState:UIControlStateSelected];
    
    UILabel * weChatLabel = [MyControl createLabelWithFrame:CGRectMake(weChat.frame.origin.x+weChat.frame.size.width+3, 10, 80, 25) Font:15 Text:@"微信朋友圈"];
    weChatLabel.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1];
    [bgImageView2 addSubview:weChatLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}
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
        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"最多输入40个字哦亲~"];
        return;
    }
    
    button.userInteractionEnabled = NO;
    int s = [[USER objectForKey:@"sina"] intValue];
    int w = [[USER objectForKey:@"weChat"] intValue];
    
    if (s == 1 && w == 0) {
        BOOL isOauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
//        if (isOauth) {
//            
//        }
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:_textView.text image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            NSLog(@"sina-response:%@", response);
            button.userInteractionEnabled = YES;
            if ([response.message isEqualToString:@"user cancel the operation"]) {
                return;
            }
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self postData:self.oriImage];
            }
            
        }];
    }else if(s == 0 && w == 1){
        button.userInteractionEnabled = YES;
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_textView.text image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            NSLog(@"weChat-response:%@", response);
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self postData:self.oriImage];
            }
        }];

    }else if(s == 1 && w == 1){
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:_textView.text image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
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
                
                [self postData:self.oriImage];
            }
            
        }];
    }else{
        [self postData:self.oriImage];
    }
    
}
-(void)sinaClick
{
    sina.selected = !sina.selected;
    if (sina.selected) {
        [USER setObject:@"1" forKey:@"sina"];
    }else{
        [USER setObject:@"0" forKey:@"sina"];
    }
    
}
-(void)weChatClick
{
    weChat.selected = !weChat.selected;
    if (weChat.selected) {
        [USER setObject:@"1" forKey:@"weChat"];
    }else{
        [USER setObject:@"0" forKey:@"weChat"];
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
    if ([_textView.text isEqualToString:@"为您爱宠的靓照写个描述吧~"]) {
        _textView.text = @"";
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (_textView.text.length == 0) {
        _textView.text = @"为您爱宠的靓照写个描述吧~";
    }
}

#pragma mark -键盘监听
-(void)keyboardWillShow:(NSNotification *)info
{
    if (textBgView.frame.origin.y+textBgView.frame.size.height<=(self.view.frame.size.height-216)) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        textBgView.frame = CGRectMake(10, self.view.frame.size.height-80-216, 300, 80);
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
            textBgView.frame = CGRectMake(10, self.view.frame.size.height-height-80, 300, 80);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            textBgView.frame = CGRectMake(10, self.view.frame.size.height-height-80, 300, 80);
        }];
    }
}
#pragma mark -
-(void)leftButtonClick
{
    [self lauchEditorWithImage:self.oriImage];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self presentViewController:self.af animated:YES completion:nil];
}
-(void)rightButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark -ASI
-(void)postData:(UIImage *)image
{
    //网络上传
    NSString * url = [NSString stringWithFormat:@"%@%@", IMAGEAPI, [ControllerManager getSID]];
    NSLog(@"postUrl:%@", url);
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 20;
    
    NSData * data = UIImageJPEGRepresentation(image, 0.1);
    NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
    [_request setData:data withFileName:[NSString stringWithFormat:@"%.0f.png", timeInterval] andContentType:@"image/jpg" forKey:@"image"];
    //    [_request setPostValue:data forKey:@"image"];
    //图片
    if (![_textView.text isEqualToString:@"为您爱宠的靓照写个描述吧~"]) {
        [_request setPostValue:_textView.text forKey:@"comment"];
    }else{
        [_request setPostValue:@"" forKey:@"comment"];
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
    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"上传成功"];
    NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
    
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
        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    [vc release];
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"上传失败"];
    [self dismissViewControllerAnimated:YES completion:nil];
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
