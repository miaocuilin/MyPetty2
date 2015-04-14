//
//  ArtivleDetailViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/23.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "ArtivleDetailViewController.h"
#import "IQKeyboardManager.h"
#define BorderColor [UIColor colorWithRed:247/255.0 green:109/255.0 blue:112/255.0 alpha:1].CGColor
#define PinkColor [UIColor colorWithRed:247/255.0 green:109/255.0 blue:112/255.0 alpha:1]

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#import "ArticleDetailCell.h"


@interface ArtivleDetailViewController () <UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIView *accessorView;
@property(nonatomic,strong)UITextView *myTextView;
@property(nonatomic,strong)UITextField *tf;
@property(nonatomic,strong)UIButton *alphaBtn;
@property(nonatomic,strong)UITableView *tv;
@end

@implementation ArtivleDetailViewController
//-(void)dealloc
//{
//    NSLog(@"dealloc");
//}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self createWebView];
    [self createBottomView];
    [self createAccessorView];
}
-(void)createWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, HEIGHT-44-20)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [self.view addSubview:webView];
}

-(void)createBottomView
{
    _alphaBtn = [MyControl createButtonWithFrame:[UIScreen mainScreen].bounds ImageName:@"" Target:self Action:@selector(closeClick) Title:nil];
    self.alphaBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.view addSubview:self.alphaBtn];
    self.alphaBtn.hidden = YES;
    
    
    CGFloat spe = 15.0;
    
    _bottomView = [MyControl createViewWithFrame:CGRectMake(0, HEIGHT-44, WIDTH, 44)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    UIButton *backBtn = [MyControl createButtonWithFrame:CGRectMake(spe, 10, 24, 24) ImageName:@"page_back.png" Target:self Action:@selector(backClick) Title:nil];
    [self.bottomView addSubview:backBtn];
    
    
    //
    NSArray *nameArr = @[@"page_comment.png", @"page_share.png", @"page_like.png"];
    for (int i=0; i<3; i++) {
        UIButton *button = [MyControl createButtonWithFrame:CGRectMake(self.bottomView.frame.size.width-(24+spe)*(i+1), 10, 24, 24) ImageName:nameArr[i] Target:self Action:@selector(btnClick:) Title:nil];
        button.tag = 100+i;
        [self.bottomView addSubview:button];
    }
    
    CGFloat w = self.bottomView.frame.size.width-(24+spe)*3-backBtn.frame.size.width-spe*3;
    _tf = [MyControl createTextFieldWithFrame:CGRectMake(backBtn.frame.size.width+spe*2, 10, w, 24) placeholder:@"说点什么吧" passWord:NO leftImageView:nil rightImageView:nil Font:15];
    self.tf.delegate = self;
    self.tf.layer.cornerRadius = 10;
    self.tf.layer.masksToBounds = YES;
    self.tf.layer.borderColor = BorderColor;
    self.tf.layer.borderWidth = 1;
    [self.bottomView addSubview:self.tf];
}
-(void)btnClick:(UIButton *)sender
{
    if(sender.tag == 102){
        //点赞
        
    }else if(sender.tag == 101){
        //分享
        
    }else if(sender.tag == 100){
        //评论
        if (!self.tv) {
            [self createTableView];
        }
        
        self.alphaBtn.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.alphaBtn.alpha = 0.6;
            
            CGRect rect = self.bottomView.frame;
            rect.origin.y = HEIGHT*0.3-rect.size.height;
            self.bottomView.frame = rect;
            
            self.tv.frame = CGRectMake(0, HEIGHT*0.3, WIDTH, HEIGHT*0.7);
        }];
        
    }
}

-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createAccessorView
{
    
    _accessorView = [MyControl createViewWithFrame:CGRectMake(0, HEIGHT, WIDTH, 150)];
    CGFloat spe = 15.0;
    self.accessorView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.accessorView];
    
    UIButton *closeBtn = [MyControl createButtonWithFrame:CGRectMake(spe, spe, 28, 28) ImageName:@"page_cancle.png" Target:self Action:@selector(closeClick) Title:nil];
    [self.accessorView addSubview:closeBtn];
    
    UIButton *doneBtn = [MyControl createButtonWithFrame:CGRectMake(WIDTH-spe-28, spe, 28, 28) ImageName:@"page_confirm.png" Target:self Action:@selector(doneClick) Title:nil];
    [self.accessorView addSubview:doneBtn];
    
    CGFloat oriX = closeBtn.frame.origin.x+closeBtn.frame.size.width;
    CGFloat sizW = doneBtn.frame.origin.x-oriX;
    UILabel *textLabel = [MyControl createLabelWithFrame:CGRectMake(oriX, spe, sizW, 28) Font:17 Text:@"说点什么"];
    textLabel.textColor = PinkColor;
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.accessorView addSubview:textLabel];
    
    
    _myTextView = [[UITextView alloc] initWithFrame:CGRectMake(spe, spe*2+closeBtn.frame.size.height, WIDTH-spe*2, 86)];
        self.myTextView.layer.borderWidth = 1;
        self.myTextView.layer.borderColor = BorderColor;
    self.myTextView.delegate = self;
        [self.accessorView addSubview:self.myTextView];

}
-(void)closeClick
{
    [self.myTextView resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.accessorView.frame = CGRectMake(0, HEIGHT, WIDTH, 150);
        self.alphaBtn.alpha = 0;
        
        self.bottomView.frame = CGRectMake(0, HEIGHT-44, WIDTH, 44);
        self.tv.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT*0.7);
    } completion:^(BOOL finished) {
        self.alphaBtn.hidden = YES;
    }];
}
-(void)doneClick
{
    [self.myTextView resignFirstResponder];
    
//    self.tf.text = self.myTextView.text;
    [UIView animateWithDuration:0.2 animations:^{
        self.accessorView.frame = CGRectMake(0, HEIGHT, WIDTH, 150);
        self.alphaBtn.alpha = 0;
    } completion:^(BOOL finished) {
        self.alphaBtn.hidden = YES;
    }];
    
    //发送评论
    
    //清空myTextView
    self.myTextView.text = nil;
}

#pragma mark - textFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self closeClick];
    //弹出
    self.alphaBtn.alpha = 0;
    self.alphaBtn.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.accessorView.frame;
        rect.origin.y = HEIGHT-rect.size.height;
        self.accessorView.frame = rect;
        
        self.alphaBtn.alpha = 0.6;
    }];
    [self.myTextView becomeFirstResponder];
//                     completion:^(BOOL finished) {
//        [self.myTextView becomeFirstResponder];
//    }];
    
    return NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - createTableView
-(void)createTableView
{
    _tv = [[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, HEIGHT/2.0) style:UITableViewStylePlain];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.separatorStyle = 0;
    [self.view addSubview:self.tv];
    
    [self.tv registerClass:[ArticleDetailCell class] forCellReuseIdentifier:@"ArticleDetailCell"];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ArticleDetailCell";
    ArticleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    return cell;
}
@end
