//
//  VisibleViewController.m
//  MyPetty
//
//  Created by Aidi on 14-6-9.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "VisibleViewController.h"

@interface VisibleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * tv;
}
@end

@implementation VisibleViewController

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
    UIButton * buttonLeft = [MyControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) ImageName:@"14-6.png" Target:self Action:@selector(leftButtonClick) Title:nil];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    
    [self createTableView];
}
-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -创建tableView
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-[MyControl isIOS7]) style:UITableViewStyleGrouped];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    [tv release];
}

#pragma mark -tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"] autorelease];
    }
    cell.selectionStyle = 0;
    
    int a = [[USER objectForKey:@"visible"] intValue];
    if (indexPath.row == 0) {
        imageView1 = [MyControl createImageViewWithFrame:CGRectMake(15, 5, 30, 30) ImageName:@"22-1（2）.png"];
        if (a == 1) {
            imageView1.image = [UIImage imageNamed:@"22-1.png"];
        }
        [cell addSubview:imageView1];
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(50, 10, 150, 20) Font:17 Text:@"所有人"];
        label.textColor = [UIColor blackColor];
        [cell addSubview:label];
    }else if (indexPath.row == 1) {
        imageView2 = [MyControl createImageViewWithFrame:CGRectMake(15, 5, 30, 30) ImageName:@"22-2（2）.png"];
        if (a == 2) {
            imageView2.image = [UIImage imageNamed:@"22-2.png"];
        }
        [cell addSubview:imageView2];
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(50, 10, 150, 20) Font:17 Text:@"我关注的人"];
        label.textColor = [UIColor blackColor];
        [cell addSubview:label];
    }else{
        imageView3 = [MyControl createImageViewWithFrame:CGRectMake(15, 5, 30, 30) ImageName:@"22-3（2）.png"];
        if (a == 3) {
            imageView3.image = [UIImage imageNamed:@"22-3.png"];
        }
        [cell addSubview:imageView3];
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(50, 10, 150, 20) Font:17 Text:@"仅自己"];
        label.textColor = [UIColor blackColor];
        [cell addSubview:label];
    }
    
    cell.imageView.image = [UIImage imageNamed:@""];
    UIImageView * duigou = [MyControl createImageViewWithFrame:CGRectMake(320-37-10, 5, 37, 37) ImageName:@"对勾.png"];
    [cell addSubview:duigou];
    duigou.tag = 300+indexPath.row;

    if ([USER objectForKey:@"visible"]) {
        if (indexPath.row+1 != [[USER objectForKey:@"visible"] intValue]) {
            duigou.hidden = YES;
        }
    }else if(indexPath.row != 0){
        duigou.hidden = YES;
    }
    
    return cell;
}

-(void)clearDuigou:(int)num
{
    for (int i=0; i<3; i++) {
        UIImageView * duigou = (UIImageView *)[self.view viewWithTag:300+i];
        if (i == num) {
            duigou.hidden = NO;
            continue;
        }
        duigou.hidden = YES;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self clearDuigou:indexPath.row];
    [USER setObject:[NSString stringWithFormat:@"%d", indexPath.row+1] forKey:@"visible"];
    NSLog(@"%@", [USER objectForKey:@"visible"]);
    [self clear];
    if (indexPath.row == 0) {
        imageView1.image = [UIImage imageNamed:@"22-1.png"];
    }else if (indexPath.row == 1) {
        imageView2.image = [UIImage imageNamed:@"22-2.png"];
    }else{
        imageView3.image = [UIImage imageNamed:@"22-3.png"];
    }
}
-(void)clear
{
    imageView1.image = [UIImage imageNamed:@"22-1（2）.png"];
    imageView2.image = [UIImage imageNamed:@"22-2（2）.png"];
    imageView3.image = [UIImage imageNamed:@"22-3（2）.png"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
