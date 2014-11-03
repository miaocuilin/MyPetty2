//
//  PetRecommendViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetRecommendViewController.h"
#import "PetRecommendCell.h"
@implementation PetRecommendViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createTableView];
}

-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tv.dataSource = self;
    tv.delegate = self;
    tv.separatorStyle = 0;
    tv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tv];
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    tv.tableHeaderView = view;
}

#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    PetRecommendCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[PetRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    cell.selectionStyle = 0;
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.0f;
}
@end
