//
//  UploadViewController.m
//  MyPetty
//
//  Created by Aidi on 14-6-8.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "UploadViewController.h"
//#import "AMBlurView.h"
#import "ASIFormDataRequest.h"
@interface UploadViewController () <UITextFieldDelegate>
{
    ASIFormDataRequest * _request;
    UITextField * tf;
    UIView * bottomView;
    UIAlertView * alert;
}
@end

@implementation UploadViewController

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
    self.view.backgroundColor = [UIColor blackColor];
    [self makeUI];
}

-(void)makeUI
{
    UIImageView * bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@""];
    bgImageView.image = self.oriImage;
    float Width = self.oriImage.size.width;
    float Height = self.oriImage.size.height;
    if (Width>320) {
        float w = 320/Width;
        Width *= w;
        Height *= w;
    }
    if (Height>568) {
        float h = 568/Height;
        Width *= h;
        Height *= h;
    }
    bgImageView.frame = CGRectMake(0, 0, Width, Height);
    bgImageView.center = self.view.center;
    [self.view addSubview:bgImageView];

    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [MyControl isIOS7])];
//    [topView setBlurTintColor:[UIColor blackColor]];
    [self.view addSubview:topView];
    [topView release];
    
    UIButton * backButton = [MyControl createButtonWithFrame:CGRectMake(15, 30, 25, 25) ImageName:@"7-7.png" Target:self Action:@selector(buttonClick) Title:nil];
    backButton.showsTouchWhenHighlighted = YES;
    [topView addSubview:backButton];
    
    int height = 60;
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-height, self.view.frame.size.width, height)];
//    [bottomView setBlurTintColor:[UIColor blackColor]];
    [self.view addSubview:bottomView];
    
    UIButton * deliver = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-10-40, 10, 40, 40) ImageName:@"" Target:self Action:@selector(deliver:) Title:@"投稿"];
    deliver.backgroundColor = [UIColor darkGrayColor];
    deliver.showsTouchWhenHighlighted = YES;
    deliver.layer.cornerRadius = 5;
    deliver.layer.masksToBounds = YES;
    [bottomView addSubview:deliver];
    
    tf = [MyControl createTextFieldWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20-40-10, height-20) placeholder:@"为您爱宠的靓照写个描述吧~" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    tf.delegate = self;
    [bottomView addSubview:tf];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}
#pragma mark -键盘监听
-(void)keyboardWillShow:(NSNotification *)info
{
    [UIView animateWithDuration:0.25 animations:^{
        bottomView.frame = CGRectMake(0, self.view.frame.size.height-60-216, self.view.frame.size.width, 60);
    }];
}
-(void)keyboardWillHide:(NSNotification *)info
{
    [UIView animateWithDuration:0.25 animations:^{
        bottomView.frame = CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60);
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
    if ([str isEqualToString:@"zh-Hans"]) {
        [UIView animateWithDuration:0.25 animations:^{
            bottomView.frame = CGRectMake(0, self.view.frame.size.height-height-60, self.view.frame.size.width, 60);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            bottomView.frame = CGRectMake(0, self.view.frame.size.height-height-60, self.view.frame.size.width, 60);
        }];
    }
}

#pragma mark -textField代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf resignFirstResponder];
    return YES;
}

#pragma mark -button点击事件
-(void)buttonClick
{
    //返回
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)deliver:(UIButton *)button
{
    button.userInteractionEnabled = NO;
    NSLog(@"投稿");
    [self postData:self.oriImage];
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
    [_request setPostValue:tf.text forKey:@"comment"];
    
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
    alert = [[UIAlertView alloc] initWithTitle:@"上传成功!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
    NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
    alert = [[UIAlertView alloc] initWithTitle:@"上传失败!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
