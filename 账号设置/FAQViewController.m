//
//  FAQViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-9-11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "FAQViewController.h"
#import "FAQCell.h"
@interface FAQViewController ()
{
    UIWebView *faqWebView;
}
@end

@implementation FAQViewController

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
//    self.array = @[@"萌星与捧TA", @"挣口粮与兑换", @"贡献度", @"萌星人气值", @"基本动作", @"金币", @"献爱心"];
//    self.dataArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FAQ" ofType:@"plist"]];
//    NSLog(@"%@", self.dataDict);
    [self createBg];
//    [self createTableView];
    [self createWebView];
    [self createFakeNavigation];
}

- (void)createWebView
{
    faqWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:faqWebView];
    [faqWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:FAQAPI]]];
    [faqWebView release];
}
-(void)createBg
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.png"];
    [self.view addSubview:imageView];
//    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
//    [self.view addSubview:bgImageView];
//    //    self.bgImageView.backgroundColor = [UIColor redColor];
////    NSString * docDir = DOCDIR;
//    NSString * filePath = BLURBG;
//    NSLog(@"%@", filePath);
//    NSData * data = [NSData dataWithContentsOfFile:filePath];
//    //    NSLog(@"%@", data);
//    UIImage * image = [UIImage imageWithData:data];
//    bgImageView.image = image;
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
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"常见问题"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
}
-(void)backBtnClick
{
//    if (isSecond) {
//        isSecond = NO;
//        tv.hidden = NO;
//        tv2.hidden = YES;
//    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}
//-(void)createTableView
//{
//    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64) style:UITableViewStylePlain];
//    tv.delegate = self;
//    tv.dataSource = self;
//    tv.separatorStyle = 0;
//    tv.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:tv];
//    
////    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
////    tv.tableHeaderView = tempView;
//    
//    tv2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64) style:UITableViewStylePlain];
//    tv2.delegate = self;
//    tv2.dataSource = self;
//    tv2.separatorStyle = 0;
//    tv2.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:tv2];
//    
////    UIView * tempView2 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
////    tv2.tableHeaderView = tempView2;
//    //
//    tv2.hidden = YES;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (tableView == tv) {
//        return self.array.count;
//    }else{
////        NSLog(@"----%d", [self.dataArray[rowNum] count]);
//        return [self.dataArray[rowNum] count];
////        return 2;
//    }
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == tv) {
//        static NSString * cellID = @"ID";
//        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        if (!cell) {
//            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
//            UIView * line = [MyControl createViewWithFrame:CGRectMake(0, 43, 320, 1)];
//            line.backgroundColor = [UIColor lightGrayColor];
//            [cell addSubview:line];
//            
//            UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(570/2, 10, 20, 20) ImageName:@"14-6-2.png"];
//            //        [cell addSubview:arrow];
//            cell.accessoryView = arrow;
//        }
//        cell.textLabel.text = [NSString stringWithFormat:@" %@", self.array[indexPath.row]];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.textLabel.font = [UIFont systemFontOfSize:16];
//        cell.selectionStyle = 0;
//        return cell;
//    }else{
//        static NSString * cellID2 = @"ID2";
//        FAQCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
//        if (!cell) {
//            cell = [[[FAQCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2] autorelease];
//        }
////        NSLog(@"%@", self.dataArray);
////        NSLog(@"%@--%@", self.dataArray[rowNum], [self.dataArray[rowNum] objectAtIndex:indexPath.row]);
//        NSDictionary * dic = [self.dataArray[rowNum] objectAtIndex:indexPath.row];
//        [cell configUIWithQue:[dic objectForKey:@"que"] Ans:[dic objectForKey:@"ans"]];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = 0;
//        return cell;
//    }
//    
//}
////-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
////{
////    if (tableView == tv) {
////        UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 35)];
////        view.backgroundColor = [UIColor colorWithRed:242/255.0 green:239/255.0 blue:234/255.0 alpha:1];
////        
////        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(20, 0, 200, 35) Font:17 Text:@"常见问题分类"];
////        label.textColor = [UIColor lightGrayColor];
////        [view addSubview:label];
////        return view;
////    }else{
////        return nil;
////    }
////    
////}
////-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
////{
////    if (tableView == tv) {
////        return 35.0f;
////    }else{
////        return 0;
////    }
////}
//-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == tv) {
//        return 44.0f;
//    }else{
//        self.str = [[self.dataArray[rowNum] objectAtIndex:indexPath.row] objectForKey:@"ans"];
//        CGSize size = [self.str sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(320-36, 200) lineBreakMode:1];
//        //35+10是起始y点，10是与下一段的间隔
//        return size.height+35+10+10;
//    }
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == tv) {
//        NSLog(@"点击了%d--%@", indexPath.row, self.array[indexPath.row]);
//        rowNum = indexPath.row;
//        isSecond = YES;
//        tv.hidden = YES;
//        tv2.hidden = NO;
//        [tv2 reloadData];
//    }else{
//        
//    }
//    
//}
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
