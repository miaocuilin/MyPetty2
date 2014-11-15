//
//  FeedbackViewController.m
//  MyPetty
//
//  Created by Aidi on 14-7-15.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "FeedbackViewController.h"
#import "IQKeyboardManager.h"

#define DefaultText @"想表扬，想吐槽，有好点子，通通告诉我们吧，宠物星球会在您的帮助下进步的~谢谢~"
#define UMENG_APPKEY @"538fddca56240b40a105fcfb"
@interface FeedbackViewController ()

@end

@implementation FeedbackViewController
-(void)dealloc
{
    self.umFeedback.delegate = nil;
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBg];

    self.umFeedback = [UMFeedback sharedInstance];
    [self.umFeedback setAppkey:UMENG_APPKEY delegate:self];
    
    isPhoneNum = 1;
    [self makeUI];
    [self createNavigation];
    
    //Enabling keyboard manager
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:10];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(umCheck:) name:UMFBCheckFinishedNotification object:nil];

}
//- (void)umCheck:(NSNotification *)notification {
//    NSLog(@"notification = %@", notification.userInfo);
//}


-(void)createNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick:) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"意见反馈"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}

- (void)backBtnClick:(UIButton *)sender
{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)makeUI
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 64+5, 300, 150)];
    _textView.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
    _textView.text = DefaultText;
    _textView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_textView];
    [_textView release];
    
//    UIView * keyboardBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 40)];
//    keyboardBgView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
//    UIButton * finishButton = [MyControl createButtonWithFrame:CGRectMake(320-70, 5, 50, 30) ImageName:@"" Target:self Action:@selector(finishButtonClick) Title:@"完成"];
//    [keyboardBgView addSubview:finishButton];
//    _textView.inputAccessoryView = keyboardBgView;
    
    UILabel * telLabel = [MyControl createLabelWithFrame:CGRectMake(10, _textView.bounds.size.height +64 +10, 200, 20) Font:15 Text:@"联系方式"];
    telLabel.textColor = [UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1];
    [self.view addSubview:telLabel];
    
    tf = [MyControl createTextFieldWithFrame:CGRectMake(10, 250, 300, 30) placeholder:@"您的手机号、QQ号或电子邮箱" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    tf.keyboardType = UIKeyboardTypeEmailAddress;
    tf.returnKeyType = UIReturnKeyDone;
    tf.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    tf.delegate = self;
    tf.borderStyle = 0;
    tf.layer.cornerRadius = 5;
    tf.layer.masksToBounds = YES;
    [self.view addSubview:tf];
    
    submit = [MyControl createButtonWithFrame:CGRectMake(10, 310, 300, 35) ImageName:@"" Target:self Action:@selector(submitClick) Title:@"提交"];
    submit.backgroundColor = [UIColor grayColor];
    submit.layer.cornerRadius = 5;
    submit.layer.masksToBounds = YES;
    submit.showsTouchWhenHighlighted = YES;
    submit.userInteractionEnabled = NO;
    [self.view addSubview:submit];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma mark - 发送
-(void)submitClick
{
//    if (![self validateEmail:tf.text]) {
//        StartLoading;
//        [ControllerManager loadingFailed:@"要填写正确的邮箱哦"];
//        return;
//    }

    [ControllerManager startLoading:@"发送中..."];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:_textView.text forKey:@"content"];
//    [dictionary setObject:@"2" forKey:@"age_group"];
//    [dictionary setObject:@"female" forKey:@"gender"];
//    [dictionary setObject:@[@"Good",@"VIP"] forKey:@"tags"];
    NSDictionary * contact = [NSDictionary dictionaryWithObject:tf.text forKey:@"email"];
    [dictionary setObject:contact forKey:@"contact"];
    NSLog(@"%@",[USER objectForKey:@"name"]);
    NSDictionary *remark = [NSDictionary dictionaryWithObject:[USER objectForKey:@"name"] forKey:@"name"];
    [dictionary setObject:remark forKey:@"remark"];
//    [self.umFeedback postFeedback:dictionary];
    [self.umFeedback post:dictionary];
}
-(void)postFinishedWithError:(NSError *)error
{
    NSLog(@"FeedBackError:%@", error);
    if (![error isKindOfClass:[NSNull class]]) {
        [ControllerManager loadingSuccess:@"感谢您的意见"];
    }else{
        LoadingFailed;
//        [ControllerManager loadingFailed:@"发送失败"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


//-(void)keyboardWillShow:(NSNotification *)note
//{
////    NSLog(@"%@", note);
//    if (isPhoneNum) {
//        CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGFloat ty = - rect.size.height;
//        //time 0.25
//        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//            self.view.transform = CGAffineTransformMakeTranslation(0, (self.view.frame.size.height-ty));
//        }];
//    }
//}
//-(void)keyboardWillHide:(NSNotification *)note
//{
//    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        self.view.transform = CGAffineTransformIdentity;
//    }];
//}

#pragma mark - textField代理方法
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    isPhoneNum = NO;
    if ([_textView.text isEqualToString:DefaultText]) {
        _textView.text = nil;
        _textView.textColor = [UIColor blackColor];
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    isPhoneNum = YES;
    if (_textView.text.length == 0) {
        _textView.text = DefaultText;
        _textView.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
    }
    [self completeButton];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark -
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf resignFirstResponder];
    [self completeButton];
    return YES;
}

//判断完成按钮的颜色
- (void)completeButton
{
    if (_textView.text.length == 0 || [_textView.text isEqualToString:DefaultText]) {
        submit.backgroundColor = [UIColor grayColor];
    }else{
        submit.backgroundColor = BGCOLOR;
        submit.userInteractionEnabled = YES;
    }
}

-(void)createBg
{
    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:self.bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = DOCDIR;
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"%@", data);
    UIImage * image = [UIImage imageWithData:data];
    self.bgImageView.image = image;
    //    self.bgImageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    
    //毛玻璃化，需要先设置图片再设置其他
//    [self.bgImageView setFramesCount:20];
//    [self.bgImageView setBlurAmount:1];
    
    //这里必须延时执行，否则会变白
    //注意，由于图片较大，这里需要的时间必须在2秒以上
//    [self performSelector:@selector(blurImage) withObject:nil afterDelay:0.25f];
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:tempView];
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
