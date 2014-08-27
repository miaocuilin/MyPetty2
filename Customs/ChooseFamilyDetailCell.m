//
//  ChooseFamilyDetailCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-7.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ChooseFamilyDetailCell.h"
//#import "ClickImage.h"
@implementation ChooseFamilyDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    UIImageView * bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, 125) ImageName:@""];
    bgImageView.image = [[UIImage imageNamed:@"cardBg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [self.contentView addSubview:bgImageView];
    
    UIImageView * bgTriangle = [MyControl createImageViewWithFrame:CGRectMake(320/2-31/2, 0, 31/2, 28/2) ImageName:@"cardBgTriangle.png"];
    [self.contentView addSubview:bgTriangle];
    
    UILabel * label1 = [MyControl createLabelWithFrame:CGRectMake(10, 5, 100, 15) Font:13 Text:@"精彩照片"];
    label1.textColor = [UIColor grayColor];
    [self.contentView addSubview:label1];
    
    UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(320-80, 5, 70, 15) Font:13 Text:@"主人名片"];
    label2.textAlignment = NSTextAlignmentRight;
    label2.textColor = [UIColor grayColor];
    [self.contentView addSubview:label2];
    
    for(int i=0;i<4;i++){
//        ClickImage * pic = [[ClickImage alloc] initWithFrame:CGRectMake(10+i%2*75, 25+i/2*45, 65, 40)];
//        UIImageView * pic = [MyControl createImageViewWithFrame:CGRectMake(10+i%2*75, 25+i/2*45, 65, 40) ImageName:@""];
        UIButton * btn = [MyControl createButtonWithFrame:CGRectMake(10+i%2*75, 25+i/2*45, 65, 40) ImageName:@"" Target:self Action:@selector(btnClick:) Title:nil];
        if (i%2 == 0) {
            [btn setImage:[UIImage imageNamed:@"cat1.jpg"] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"cat2.jpg"] forState:UIControlStateNormal];
        }
        
        [self.contentView addSubview:btn];
        btn.tag = 100+i;
//        pic.canClick = YES;
    }
    
//    UIView * bgView1 = [MyControl createViewWithFrame:CGRectMake(200, 20, 70, 70)];
//    bgView1.layer.cornerRadius = 35;
//    bgView1.layer.masksToBounds = YES;
////    bgView1.backgroundColor = [ControllerManager colorWithHexString:@"f8d7bd"];
//    [self.contentView addSubview:bgView1];
//    
//    UIView * bgView2 = [MyControl createViewWithFrame:CGRectMake(205, 25, 60, 60)];
//    bgView2.layer.cornerRadius = 30;
//    bgView2.layer.masksToBounds = YES;
//    bgView2.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:bgView2];
    UIImageView * circleBgView = [MyControl createImageViewWithFrame:CGRectMake(410/2, 20, 55, 55) ImageName:@"circleBg.png"];
    [self.contentView addSubview:circleBgView];
    
    UIImageView * headImageView = [MyControl createImageViewWithFrame:CGRectMake(5, 5, 45, 45) ImageName:@"cat2.jpg"];
    headImageView.layer.cornerRadius = 45/2;
    headImageView.layer.masksToBounds = YES;
    [circleBgView addSubview:headImageView];
    
    UIImageView * sex = [MyControl createImageViewWithFrame:CGRectMake(180, 80, 26/2, 30/2) ImageName:@"woman.png"];
    [self.contentView addSubview:sex];
    
    UILabel * name = [MyControl createLabelWithFrame:CGRectMake(195, 80, 90, 15) Font:12 Text:@"李雷和韩梅梅"];
    name.textColor = BGCOLOR;
    name.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:name];
    
    UILabel * location = [MyControl createLabelWithFrame:CGRectMake(170, 95, 125, 15) Font:12 Text:@"北京市|朝阳区|麦子店"];
    location.textColor = [UIColor grayColor];
    location.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:location];
    
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    sv.backgroundColor = [UIColor blackColor];
    sv.contentSize = CGSizeMake(320*4, [UIScreen mainScreen].bounds.size.height);
    sv.alpha = 0;
    sv.hidden = YES;
    sv.pagingEnabled = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:sv];
    [sv autorelease];
}
-(void)btnClick:(UIButton *)btn
{
    
    if (!isAdded) {
        for(int i=0;i<4;i++){
            UIButton * button = (UIButton *)[self.contentView viewWithTag:100+i];
            height[i] = 320/button.imageView.image.size.width*button.imageView.image.size.height;

            UIImageView * imageView = [MyControl createImageViewWithFrame:CGRectMake(320*i, ([UIScreen mainScreen].bounds.size.height-height[i])/2, 320, height[i]) ImageName:@""];
            imageView.image = button.imageView.image;
            [sv addSubview:imageView];
        }
        UIButton * maskBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320*4, [UIScreen mainScreen].bounds.size.height) ImageName:@"" Target:self Action:@selector(maskBtnClick) Title:nil];
        [sv addSubview:maskBtn];
    }
    int a = btn.tag-100;
    oriRect = btn.frame;
    sv.hidden = NO;
    sv.contentOffset = CGPointMake(320*a, 0);
    [UIView animateWithDuration:0.3 animations:^{
        sv.alpha = 1;
    }];
}
-(void)maskBtnClick
{
    [UIView animateWithDuration:0.3 animations:^{
        sv.alpha = 0;
    } completion:^(BOOL finished) {
        sv.hidden = YES;
    }];
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
