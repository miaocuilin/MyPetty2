//
//  PicturePlayView.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/26.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "PicturePlayView.h"

@interface PicturePlayView () <UIScrollViewDelegate>

@property(nonatomic,strong)NSArray *urlArray;
//判断是否需要在图片上加其他view
@property(nonatomic)BOOL hasOtherView;
@property(nonatomic)NSInteger totalCount;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIScrollView *sv;
@end

@implementation PicturePlayView

-(void)dealloc
{
    [self.timer invalidate];
}
//涉及到的变量参数：view宽高，图片url组成的数组，每一个的点击事件block回调，轮播间隔，滑动速度。
//传进来的参数需要：view宽高，url组成的数组，block回调返回点击的index。
//另外判断是否需要在图片上加其他view。
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame UrlArray:(NSArray *)array OtherView:(BOOL)otherView isFromBanner:(BOOL)fromBanner
{
    self.isFromBanner = fromBanner;
    self.hasOtherView = otherView;
    self.urlArray = array;
    return [self initWithFrame:frame];
}
-(void)createUI
{
    //一张不轮播，2张及以上创建开始和结尾的假图片
    if (self.urlArray.count == 0) {
        return;
    }else if(self.urlArray.count == 1){
        self.totalCount = 1;
    }else{
        self.totalCount = self.urlArray.count+2;
    }
    
    [self createWithCount:self.totalCount];
}
-(void)createWithCount:(NSInteger)totalCount
{
    if(totalCount == 1){
        UIImageView *imageView = [MyControl createImageViewWithFrame:self.bounds ImageName:nil];
        NSURL * URL = nil;
        if (self.isFromBanner) {
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/banner/%@", IMAGEURL, self.urlArray[0]]];
        }else{
            URL = [MyControl returnThumbImageURLwithName:self.urlArray[0] Width:self.frame.size.width Height:self.frame.size.height];
        }
        [imageView setImageWithURL:URL];
        [self addSubview:imageView];
        
        if (self.hasOtherView) {
            UIView *view = [self createOtherViewAtIndex:0];
            [imageView addSubview:view];
        }
        
        //创建button
        UIButton *btn = [MyControl createButtonWithFrame:imageView.frame ImageName:nil Target:self Action:@selector(btnClick:) Title:nil];
        btn.tag = 10000;
        [self addSubview:btn];
    }else{
        _sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.sv.contentSize = CGSizeMake(self.sv.frame.size.width*totalCount, self.sv.frame.size.height);
        self.sv.contentOffset = CGPointMake(self.sv.frame.size.width, 0);
        self.sv.pagingEnabled = YES;
        self.sv.showsHorizontalScrollIndicator = NO;
        self.sv.delegate = self;
        
        [self addSubview:self.sv];
        
        for (NSInteger i=0; i<totalCount; i++) {
            UIImageView *imageView = [MyControl createImageViewWithFrame:CGRectMake(i*self.sv.frame.size.width, 0, self.sv.frame.size.width, self.sv.frame.size.height) ImageName:nil];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            NSInteger x;
            if (i == 0) {
                x = totalCount-2-1;
            }else if(i == totalCount-1){
                x = 0;
            }else{
                x = i-1;
            }
            NSURL * URL = nil;
            if (self.isFromBanner) {
                URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/banner/%@", IMAGEURL, self.urlArray[x]]];
            }else{
                URL = [MyControl returnThumbImageURLwithName:self.urlArray[x] Width:self.frame.size.width Height:self.frame.size.height];
            }
            
            [imageView setImageWithURL:URL];
            [self.sv addSubview:imageView];
            
            if (self.hasOtherView) {
                UIView *view = [self createOtherViewAtIndex:i];
                [imageView addSubview:view];
            }
            
            //创建button
            UIButton *btn = [MyControl createButtonWithFrame:imageView.frame ImageName:nil Target:self Action:@selector(btnClick:) Title:nil];
            btn.tag = 10000+i;
            [self.sv addSubview:btn];
        }
        _pageControl = [[UIPageControl alloc] init];
        CGSize size = [self.pageControl sizeForNumberOfPages:totalCount-2];
        self.pageControl.frame = CGRectMake((self.frame.size.width-size.width)/2.0, self.frame.size.height-15, size.width, 15);
        self.pageControl.numberOfPages = totalCount-2;
        self.pageControl.userInteractionEnabled = NO;
        [self addSubview:self.pageControl];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(Pictureplay) userInfo:nil repeats:YES];
    }
}
-(void)Pictureplay
{
    int b = self.sv.contentOffset.x/self.sv.frame.size.width;
//    int b = a;
//    NSLog(@"%d", b);
    [UIView animateWithDuration:0.5 animations:^{
        self.sv.contentOffset = CGPointMake((b+1)*self.sv.frame.size.width, 0);
    }];
}
#pragma mark -
-(UIView *)createOtherViewAtIndex:(NSInteger)index
{
    UIView *view = [MyControl createViewWithFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50)];
    UIView *alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [view addSubview:alphaView];
    
    UILabel *timeLabel = [MyControl createLabelWithFrame:CGRectMake(10, 5, view.frame.size.width-10, 15) Font:13 Text:nil];
    [view addSubview:timeLabel];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.M.d HH:mm"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    timeLabel.text = [NSString stringWithFormat:@"截至%@", str];
    
    UILabel *titleLabel = [MyControl createLabelWithFrame:CGRectMake(5, timeLabel.frame.origin.y+timeLabel.frame.size.height, view.frame.size.width-5, 20) Font:15 Text:@"《宠物星球·萌物志》第一期萌星海选进行中"];
    titleLabel.numberOfLines = 1;
    [view addSubview:titleLabel];
    return view;
}

-(void)btnClick:(UIButton *)sender
{
    NSInteger x;
    if (self.totalCount == 1) {
        x = 0;
    }else{
        if (sender.tag == 10000) {
            x = self.totalCount-2;
        }else if(sender.tag-10000 == self.totalCount-1){
            x = 0;
        }else{
            x = sender.tag-10000-1;
        }
    }
    if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
        [self.delegate selectedIndex:x];
    }
}

#pragma mark - delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float a = scrollView.contentOffset.x/scrollView.frame.size.width;
    if (a == self.totalCount-1) {
        //            NSLog(@"到达最后一张");
        [self performSelector:@selector(backToFirst) withObject:nil afterDelay:0.5];
        
        
        self.pageControl.currentPage = 0;
    }else if(a == 0){
        //            NSLog(@"到达第一张");
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width*(self.totalCount-2), 0);
        self.pageControl.currentPage = self.totalCount-2;
    }else{
        self.pageControl.currentPage = a-1;
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(Pictureplay) userInfo:nil repeats:YES];
}
-(void)backToFirst
{
    self.sv.contentOffset = CGPointMake(self.sv.frame.size.width, 0);
}
@end
