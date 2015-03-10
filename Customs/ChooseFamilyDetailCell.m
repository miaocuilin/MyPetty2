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
    
    UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(320-80, 5, 70, 15) Font:13 Text:@"经纪人名片"];
    label2.textAlignment = NSTextAlignmentRight;
    label2.textColor = [UIColor grayColor];
    [self.contentView addSubview:label2];
    
    for(int i=0;i<4;i++){
//        ClickImage * pic = [[ClickImage alloc] initWithFrame:CGRectMake(10+i%2*75, 25+i/2*45, 65, 40)];
//        UIImageView * pic = [MyControl createImageViewWithFrame:CGRectMake(10+i%2*75, 25+i/2*45, 65, 40) ImageName:@""];
        UIButton * btn = [MyControl createButtonWithFrame:CGRectMake(10+i%2*75, 25+i/2*45, 65, 40) ImageName:@"" Target:self Action:@selector(btnClick:) Title:nil];
//        if (i%2 == 0) {
//            [btn setImage:[UIImage imageNamed:@"cat1.jpg"] forState:UIControlStateNormal];
//        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"defaultPic.jpg"] forState:UIControlStateNormal];
//        }
        
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
    
    headImageView = [MyControl createImageViewWithFrame:CGRectMake(5, 5, 45, 45) ImageName:@"cat2.jpg"];
    headImageView.layer.cornerRadius = 45/2;
    headImageView.layer.masksToBounds = YES;
    [circleBgView addSubview:headImageView];
    
    sex = [MyControl createImageViewWithFrame:CGRectMake(180, 80, 26/2, 30/2) ImageName:@"woman.png"];
    [self.contentView addSubview:sex];
    
    name = [MyControl createLabelWithFrame:CGRectMake(190, 80, 90, 15) Font:12 Text:@"李雷和韩梅梅"];
    name.textColor = BGCOLOR;
    name.textAlignment = NSTextAlignmentCenter;
//    name.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.contentView addSubview:name];
    
    location = [MyControl createLabelWithFrame:CGRectMake(170, 95, 125, 15) Font:12 Text:@"北京市 | 朝阳区"];
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
//        isAdded = YES;
//        NSLog(@"===%@", self.imagesArray);
        for(int i=0;i<4;i++){
            UIButton * button = (UIButton *)[self.contentView viewWithTag:100+i];
            height[i] = 320/button.currentBackgroundImage.size.width*button.currentBackgroundImage.size.height;

            UIImageView * imageView = [MyControl createImageViewWithFrame:CGRectMake(320*i, ([UIScreen mainScreen].bounds.size.height-height[i])/2, 320, height[i]) ImageName:@""];
            
            imageView.image = button.currentBackgroundImage;
//            NSLog(@"%f--%f", imageView.frame.size.width, imageView.frame.size.height);
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

-(void)configUI:(NSDictionary *)dic
{
    //每次都除去4个照片，重新加载
    for(int i=0;i<4;i++){
        UIButton * btn = (UIButton *)[self.contentView viewWithTag:100+i];
        [btn removeFromSuperview];
    }
    //除去scrollView上的所有控件，重新加载
    for (UIView * view in sv.subviews) {
        [view removeFromSuperview];
    }
    
    self.imagesArray = [dic objectForKey:@"images"];
//    NSLog(@"***%@", self.imagesArray);
    NSDictionary * master = [dic objectForKey:@"master"];
    if ([[master objectForKey:@"gender"] intValue] == 1) {
        sex.image = [UIImage imageNamed:@"man.png"];
    }
    name.text = [master objectForKey:@"name"];
    location.text = [ControllerManager returnProvinceAndCityWithCityNum:[master objectForKey:@"city"]];
    
    CGSize size = [name.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(90, 15) lineBreakMode:1];
//  sex  180, 80, 26/2, 30/2
    CGRect rect = sex.frame;
    rect.origin.x = name.frame.origin.x+name.frame.size.width/2-size.width/2-rect.size.width-5;
    sex.frame = rect;
    
    /**************************/
    if (!([[master objectForKey:@"tx"] isKindOfClass:[NSNull class]] || [[master objectForKey:@"tx"] length]==0)) {
        [MyControl setImageForImageView:headImageView Tx:[master objectForKey:@"tx"] isPet:NO isRound:YES];
    }
    
    /**************************/
    sv.contentSize = CGSizeMake(320*4, [UIScreen mainScreen].bounds.size.height);
    
    for(int i=0;i<4;i++){
        UIButton * btn = [MyControl createButtonWithFrame:CGRectMake(10+i%2*75, 25+i/2*45, 65, 40) ImageName:@"defaultPic.jpg" Target:self Action:@selector(btnClick:) Title:nil];
        
        [self.contentView addSubview:btn];
        btn.tag = 100+i;
        if (i >= self.imagesArray.count) {
            continue;
        }
        /**************************/
        if (!([[self.imagesArray[i] objectForKey:@"url"] isKindOfClass:[NSNull class]] || [[self.imagesArray[i] objectForKey:@"url"] length]==0)) {
//            NSString * docDir = DOCDIR;
            NSString * txFilePath = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@_card.png", [self.imagesArray[i] objectForKey:@"url"]]];
            UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
            if (image) {
                [btn setBackgroundImage:image forState:UIControlStateNormal];
//                [btn setImage:image forState:UIControlStateNormal];
            }else{
                //下载图片
                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, [self.imagesArray[i] objectForKey:@"url"]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
                        //对图片进行缩放和截取
                        UIImage * image1 = load.dataImage;
                        float Width = image1.size.width;
                        float Height = image1.size.height;
                        
                        UIImage * image2 = nil;
                        
                        if (Width/Height>65/40.0) {
                            //偏宽，保证高度
                            float rate = 65/40.0;
                            image2 = [self imageFromImage:image1 inRect:CGRectMake((Width-Height*rate)/2, 0, Width*rate, Height)];

//                            Height = 40.0;
//                            Width = 40.0/Height*Width;
                        }else{
                            //偏高，保证宽度
                            float rate = 40.0/65;
                            
                            image2 = [self imageFromImage:image1 inRect:CGRectMake(0, (Height-Width*rate)/2, Width, Width*rate)];
//                            Width = 65.0;
//                            Height = 65.0/Width*Height;
                        }

                        [btn setBackgroundImage:image2 forState:UIControlStateNormal];
                        
                        NSString * docDir = DOCDIR;
                        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [self.imagesArray[i] objectForKey:@"url"]]];
                        [load.data writeToFile:txFilePath atomically:YES];
                        //
                        NSString * txFilePath2 = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@_card.png", [self.imagesArray[i] objectForKey:@"url"]]];
                        NSData * data = UIImageJPEGRepresentation(image2, 0.1);
                        [data writeToFile:txFilePath2 atomically:YES];
                    }else{
                        NSLog(@"头像下载失败");
                    }
                }];
                [request release];
            }
        }
        /**************************/
    }
}
#pragma mark -取图片的一部分
/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
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
