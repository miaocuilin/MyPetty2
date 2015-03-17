//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface NIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize delegate;

-(void)setDefaultCellType
{
    [self setCellTextColor:[UIColor whiteColor] Font:[UIFont boldSystemFontOfSize:14] BgColor:[UIColor colorWithRed:246/255.0 green:168/255.0 blue:146/255.0 alpha:0.6] lineColor:[UIColor whiteColor]];
}

-(void)setCellTextColor:(UIColor *)color Font:(UIFont *)font BgColor:(UIColor *)bgColor lineColor:(UIColor *)LineColor
{
    cellTextColor = color;
    cellTextFont = font;
    cellBgColor = bgColor;
    lineColor = LineColor;
}

- (id)showDropDown:(UIButton *)b:(CGFloat *)height:(NSArray *)arr {
    btnSender = b;
    self = [super init];
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
        self.list = [NSArray arrayWithArray:arr];
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(-5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
//        table.backgroundColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        table.backgroundColor = [UIColor clearColor];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorStyle = 0;
//        table.separatorColor = [UIColor whiteColor];
        //去掉垂直方向滚轴
//        table.showsVerticalScrollIndicator = NO;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
        table.frame = CGRectMake(0, 0, btn.size.width, *height);

        [UIView commitAnimations];
        
        [b.superview addSubview:self];
        [self addSubview:table];
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}   


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text =[list objectAtIndex:indexPath.row];
    cell.textLabel.textColor = cellTextColor;
    cell.textLabel.font = cellTextFont;
    cell.backgroundColor = cellBgColor;
//    cell.alpha = 0.5;
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
    UIView * line = [MyControl createViewWithFrame:CGRectMake(0, 39, tableView.frame.size.width, 1)];
    line.backgroundColor = lineColor;
    [cell addSubview:line];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender];
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    [btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    [self myDelegateWithLine:indexPath.row Words:c.textLabel.text];
    //
//    NSLog(@"点击了下拉菜单第%d行", indexPath.row);
//    if ([self.delegate respondsToSelector:@selector(didSelectedLine:Words:)]) {
//        <#statements#>
//    }

    
}

- (void) myDelegateWithLine:(int)Line Words:(NSString *)Words {
    [self.delegate didSelected:self Line:Line Words:Words];
    [self.delegate niDropDownDelegateMethod:self];   
}

-(void)dealloc {
    [super dealloc];
    [table release];
//    [self release];
}

@end
