//
//  ArticleViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/23.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "ArticleViewController.h"
#import "ArticleCell.h"
#import "ArtivleDetailViewController.h"
#import "ArticleModel.h"
#import "ArticleWebViewController.h"

@interface ArticleViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger page;
    BOOL isSelfCreated;
}
@property(nonatomic,strong)UITableView *tv;
@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)NSMutableArray *articlesArray;
@property(nonatomic,strong)NSMutableArray *bannersArray;
@property(nonatomic,strong)UILabel *titleLabel;
@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.articlesArray = [NSMutableArray arrayWithCapacity:0];
    self.bannersArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createTableView];
    [self.tv registerClass:[ArticleCell class] forCellReuseIdentifier:@"ArticleCell"];
    [self loadArticlesData];
    
    isSelfCreated = YES;
}

-(void)loadArticlesData
{
    if (!isSelfCreated) {
        LOADING;
    }
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:ARTICLESAPI Block:^(BOOL isFinish, httpDownloadBlock *load) {
        [self.tv headerEndRefreshing];
        if (isFinish) {
            NSDictionary *dict = [load.dataDict objectForKey:@"data"];
            if ([[dict objectForKey:@"articles"] isKindOfClass:[NSArray class]] && [[dict objectForKey:@"articles"] count]) {
                page = 1;
                
                [self.articlesArray removeAllObjects];
                NSArray *array = [dict objectForKey:@"articles"];
                for (NSDictionary *dic in array) {
                    ArticleModel *model = [[ArticleModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    model.des = [dic objectForKey:@"description"];
                    [self.articlesArray addObject:model];
                }
            }
            
            if([[dict objectForKey:@"banner"] isKindOfClass:[NSDictionary class]]){
                [self.bannersArray removeAllObjects];
                
                NSDictionary *dic = [dict objectForKey:@"banner"];
                ArticleModel *model = [[ArticleModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                model.des = [dic objectForKey:@"description"];
                [self.bannersArray addObject:model];
                
                [self.headerImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"water_white.png"]];
                self.titleLabel.text = model.title;
            }
            
            
            [self.tv reloadData];
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
}
-(void)loadMoreArticles
{
//    LOADING;
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"page=%ddog&cat", page]];
    NSString *url = [NSString stringWithFormat:@"%@&page=%d&sig=%@", ARTICLESAPI, page, sig];
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        [self.tv footerEndRefreshing];
        if (isFinish) {
            NSDictionary *dict = [load.dataDict objectForKey:@"data"];
            if ([[dict objectForKey:@"articles"] isKindOfClass:[NSArray class]] && [[dict objectForKey:@"articles"] count]) {
                page++;
                
                NSArray *array = [dict objectForKey:@"articles"];
                for (NSDictionary *dic in array) {
                    ArticleModel *model = [[ArticleModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    model.des = [dic objectForKey:@"description"];
                    [self.articlesArray addObject:model];
                }
            }
            
            if([[dict objectForKey:@"banner"] isKindOfClass:[NSDictionary class]]){
                [self.bannersArray removeAllObjects];
                
                NSDictionary *dic = [dict objectForKey:@"banner"];
                ArticleModel *model = [[ArticleModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                model.des = [dic objectForKey:@"description"];
                [self.bannersArray addObject:model];
                
                [self.headerImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"water_white.png"]];
                self.titleLabel.text = model.title;
            }
            
            
            [self.tv reloadData];
//            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
}

-(UIView *)createHeaderView
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width-30;
    CGFloat h = w/3*2;
    UIView *headerView = [MyControl createViewWithFrame:CGRectMake(0, 0, w+30, h+20)];
//    headerView.backgroundColor = [UIColor purpleColor];
    
    _headerImageView = [MyControl createImageViewWithFrame:CGRectMake(15, 20, w, h) ImageName:@""];
    [headerView addSubview:self.headerImageView];
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.backgroundColor = [UIColor whiteColor];
    
    CGFloat p = 60/330.0;
    CGFloat alphaH = h*p;
    UIView *alphaBg = [MyControl createViewWithFrame:CGRectMake(0, h-alphaH, w, alphaH)];
    alphaBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.headerImageView addSubview:alphaBg];
    
    self.titleLabel = [MyControl createLabelWithFrame:alphaBg.frame Font:20 Text:nil];
//    titleLabel.text = @"【星球日报·第一期】因为你是我的眼";
    self.titleLabel.numberOfLines = 1;
    [self.headerImageView addSubview:self.titleLabel];
    
    UIButton *headerBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height) ImageName:@"" Target:self Action:@selector(headerBtnClick) Title:nil];
    [headerView addSubview:headerBtn];
    
    return headerView;
}
-(void)headerBtnClick
{
    //跳转详细页面，webView
    ArticleWebViewController *article = [[ArticleWebViewController alloc] init];
    article.model = self.bannersArray[0];
    [self presentViewController:article animated:YES completion:nil];
}

#pragma mark -
-(void)createTableView
{
    CGFloat spe = 64.0f;
    _tv = [[UITableView alloc] initWithFrame:CGRectMake(0, spe, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-spe-25) style:UITableViewStylePlain];
    self.tv.delegate = self;
    self.tv.dataSource = self;
//    self.tv.separatorStyle = 0;
//    self.tv.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.tv];
    
    
    self.tv.tableHeaderView = [self createHeaderView];
    
    //禁止带导航的界面里滑动控件自动缩进
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tv addHeaderWithTarget:self action:@selector(loadArticlesData)];
    [self.tv addFooterWithTarget:self action:@selector(loadMoreArticles)];
}

#pragma mark -delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articlesArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ArticleCell";
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    ArticleModel *model = self.articlesArray[indexPath.row];
    [cell modifyUI:model];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转详细页
//    ArtivleDetailViewController *detail = [[ArtivleDetailViewController alloc] init];
    ArticleWebViewController *article = [[ArticleWebViewController alloc] init];
    article.model = self.articlesArray[indexPath.row];
    [self presentViewController:article animated:YES completion:nil];
//    [self.navigationController pushViewController:detail animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0f;
}
@end
