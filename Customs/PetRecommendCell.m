//
//  PetRecommendCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetRecommendCell.h"
#import "UIImage+Reflection.h"

@implementation PetRecommendCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    imageCount = 7;
    
    UIView * headBg = [MyControl createViewWithFrame:CGRectMake(0, 0, self.frame.size.width, 55)];
    headBg.backgroundColor = [UIColor whiteColor];
    headBg.alpha = 0.8;
    [self addSubview:headBg];
    
    //
    headBtn = [MyControl createButtonWithFrame:CGRectMake(20, (55-76/2)/2, 76/2, 76/2) ImageName:@"defaultPetHead.png" Target:self Action:@selector(headBtnClick) Title:nil];
    headBtn.layer.cornerRadius = 76.0/4;
    headBtn.layer.masksToBounds = YES;
    [self addSubview:headBtn];
    
    //
    sex = [MyControl createImageViewWithFrame:CGRectMake(64, 6, 15, 15) ImageName:@"man.png"];
    [self addSubview:sex];
    
    //
    nameLabel = [MyControl createLabelWithFrame:CGRectMake(64+15+3, 6, 180, 15) Font:14 Text:@"小熊维尼维尼"];
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.textColor = [UIColor blackColor];
    [self addSubview:nameLabel];
    //
    jumpPetBtn = [MyControl createButtonWithFrame:CGRectMake(64, 0, 15+3+170, 20) ImageName:@"" Target:self Action:@selector(headBtnClick) Title:nil];
//    jumpPetBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self addSubview:jumpPetBtn];
    
    //
    NSString * str = @"经纪人—我就是喜欢喵星人";
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:1];
    ownerLabel = [MyControl createLabelWithFrame:CGRectMake(64, 56/2, size.width, size.height) Font:12 Text:@"经纪人—我就是喜欢喵星人"];
    ownerLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:ownerLabel];
    
    //
    ownerHead = [MyControl createImageViewWithFrame:CGRectMake(64+size.width, 22, 24, 24) ImageName:@"defaultUserHead.png"];
    ownerHead.layer.cornerRadius = 12;
    ownerHead.layer.masksToBounds = YES;
    [self addSubview:ownerHead];
    //
    jumpUserBtn = [MyControl createButtonWithFrame:CGRectMake(64, 22, ownerHead.frame.origin.x-64+24, 24) ImageName:@"" Target:self Action:@selector(jumpToUser) Title:nil];
//    jumpUserBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self addSubview:jumpUserBtn];
    
    //
    self.pBtn = [MyControl createButtonWithFrame:CGRectMake(self.frame.size.width-50-10, (55-25)/2, 50, 25) ImageName:@"recom_p.png" Target:self Action:@selector(pBtnClick:) Title:nil];
    [self.pBtn setBackgroundImage:[UIImage imageNamed:@"recom_p_ing.png"] forState:UIControlStateSelected];
    [self addSubview:self.pBtn];
    
    //
    UIView * view1 = [MyControl createViewWithFrame:CGRectMake(10, 492/2, 504/2, 58/2)];
    view1.layer.borderColor = [UIColor whiteColor].CGColor;
    view1.layer.borderWidth = 1;
    view1.layer.cornerRadius = 5;
    view1.layer.masksToBounds = YES;
    [self addSubview:view1];
    
    UILabel * label1 = [MyControl createLabelWithFrame:CGRectMake(10, 4.5, 30, 20) Font:14 Text:@"成员"];
    [view1 addSubview:label1];
    
    UIView * view2 = [MyControl createViewWithFrame:CGRectMake(170/2, 4.5, 1, 20)];
    view2.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:view2];
    
    UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(view2.frame.origin.x+10, 4.5, 80, 20) Font:14 Text:@"人气击败了"];
    [view1 addSubview:label2];
    
    UILabel * label3 = [MyControl createLabelWithFrame:CGRectMake(200, 4.5, 50, 20) Font:14 Text:@"的萌星"];
    [view1 addSubview:label3];
    
    /****************/
    UILabel * memberNum = [MyControl createLabelWithFrame:CGRectMake(label1.frame.origin.x+25, 4.5, 45, 20) Font:16 Text:@"371"];
//    memberNum.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    memberNum.textAlignment = NSTextAlignmentCenter;
    memberNum.textColor = BGCOLOR;
    [view1 addSubview:memberNum];
    
    UILabel * percent = [MyControl createLabelWithFrame:CGRectMake(label2.frame.origin.x+70, 4.5, 72/2, 20) Font:16 Text:@"99%"];
//    percent.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    percent.textAlignment = NSTextAlignmentCenter;
    percent.textColor = BGCOLOR;
    [view1 addSubview:percent];
    
    carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 166/2, self.contentView.frame.size.width, 130)];
    carousel.delegate = self;
    carousel.dataSource = self;
//    carousel.contentOffset = CGSizeMake(130*2, 0);
    carousel.type = iCarouselTypeCoverFlow;
    [self.contentView addSubview:carousel];
    [carousel release];
}
-(void)headBtnClick
{
    NSLog(@"jumpToPet");
}
-(void)jumpToUser
{
    NSLog(@"jumpToUser");
}
-(void)pBtnClick:(UIButton *)btn
{
//    btn.selected = !btn.selected;
    self.pBtnClick(btn.selected);
}

#pragma mark -
-(NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return imageCount;
}
-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, 130, 130)];
    view.clipsToBounds = YES;
    UIImageView * view1 = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 130, 130) ImageName:@"cat2.jpg"];
    [view addSubview:view1];
    
//    UIImageView * refView = [MyControl createImageViewWithFrame:CGRectMake(0, 135, 130, 130) ImageName:@"cat2.jpg"];
//    [refView setImage:[[UIImage imageNamed:@"cat2.jpg"] reflectionWithAlpha:0.5]];
//    [view addSubview:refView];
    
    return view;
}
//-(NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
//{
//    return 0;
//}
//-(NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
//{
//    return 30;
//}
-(CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 130.0f;
}
-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---%d", index);
    self.imageClick(index);
}
- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
}
@end
