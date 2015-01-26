//
//  FoodCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "FoodCell.h"

@implementation FoodCell
-(void)dealloc
{
    [super dealloc];
    [timer invalidate];
    [timer release];
    bigImageView.image = nil;
    bigImageView = nil,[bigImageView release];
    
}
- (void)awakeFromNib {
    // Initialization code
}
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
    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-50-20-98/2-70)];
    [self addSubview:bgView];
    //
    whiteView = [MyControl createViewWithFrame:CGRectMake(13, 0, bgView.frame.size.width-26, bgView.frame.size.height)];
    whiteView.layer.borderColor = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1].CGColor;
    whiteView.layer.borderWidth = 0.8;
    whiteView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:whiteView];
    
    //从下往上搭
    //描述
    //    NSLog(@"%f--%f--%f", size.width, size.height, whiteView.frame.size.width-30);
    desLabel = [MyControl createLabelWithFrame:CGRectZero Font:14 Text:nil];
    desLabel.textColor = [ControllerManager colorWithHexString:@"777777"];
    [whiteView addSubview:desLabel];
    
    line = [MyControl createViewWithFrame:CGRectMake(5, desLabel.frame.origin.y-10, whiteView.frame.size.width-10, 1)];
    line.backgroundColor = LineGray;
    [whiteView addSubview:line];
    
    
    foodNum = [MyControl createLabelWithFrame:CGRectMake(5, line.frame.origin.y-25, 200, 20) Font:15 Text:nil];
    foodNum.textColor = ORANGE;
    [whiteView addSubview:foodNum];
    
    
    //剩余时间
    leftTime = [MyControl createLabelWithFrame:CGRectMake(whiteView.frame.size.width-220, foodNum.frame.origin.y, 210, 20) Font:13 Text:nil];
    leftTime.textAlignment = NSTextAlignmentRight;
    leftTime.textColor = [UIColor grayColor];
    [whiteView addSubview:leftTime];
    
    bigImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 100, 100) ImageName:@""];
    [whiteView addSubview:bigImageView];
    
//    addLabel = [MyControl createLabelWithFrame:CGRectZero Font:15 Text:nil];
//    addLabel.textColor = ORANGE;
//    addLabel.textAlignment = NSTextAlignmentCenter;
//    [whiteView addSubview:addLabel];
    bigBtn = [MyControl createButtonWithFrame:whiteView.frame ImageName:@"" Target:self Action:@selector(bigBtnClick) Title:nil];
//    bigBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:bigBtn];
}
-(void)bigBtnClick
{
    self.bigClick();
}
-(void)minTime
{
    //1417692151
    NSString * str = [MyControl leftTimeFromStamp:self.timeStamp];
    leftTime.text = [NSString stringWithFormat:@"倒计时：%@", str];
}
-(void)modifyUI:(BegFoodListModel *)model
{
    leftTime.text = nil;
    self.timeStamp = model.create_time;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(minTime) userInfo:nil repeats:YES];
    
    //
    desLabel.text = model.cmt;
    CGSize size = [model.cmt sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(whiteView.frame.size.width-30, 100) lineBreakMode:1];
    desLabel.frame = CGRectMake(15, whiteView.frame.size.height-size.height-30, whiteView.frame.size.width-30, size.height);
    //
    line.frame = CGRectMake(5, desLabel.frame.origin.y-10, whiteView.frame.size.width-10, 1);
    //
    NSString * str2 = [NSString stringWithFormat:@"已挣得%@份口粮", model.food];
    NSMutableAttributedString * mutableStr = [[NSMutableAttributedString alloc] initWithString:str2];
    [mutableStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} range:NSMakeRange(3, model.food.length)];
    foodNum.attributedText = mutableStr;
    foodNum.frame = CGRectMake(5, line.frame.origin.y-25, 200, 20);
    [mutableStr release];
    
    //
//    addLabel.frame = CGRectMake(foodNum.frame.origin.x, foodNum.frame.origin.y-15, foodNum.frame.size.width, 20);
//    addLabel.alpha = 0;
    
    //
    leftTime.frame = CGRectMake(whiteView.frame.size.width-220, foodNum.frame.origin.y, 210, 20);
    
    //517_1417699704@50512@_640&853.png
    [bigImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]] placeholderImage:[UIImage imageNamed:@"water_white.png"] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
//        NSLog(@"%d--%lld--%.2lld", receivedSize, expectedSize, receivedSize/expectedSize);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
//            bigImageView.image = nil;
//            bigImageView.image = [UIImage imageWithData:[MyControl compressImage:image]];
            float w = whiteView.frame.size.width;
            float h = leftTime.frame.origin.y;
            
            float imageW = image.size.width;
            float imageH = image.size.height;
            
            int margin = 5;
            if (imageW/imageH > w/h) {
                //过宽
                float realHeight = (w-margin*2)*imageH/imageW;
                bigImageView.frame = CGRectMake(margin, (h-realHeight)/2.0, w-margin*2, realHeight);
            }else{
                //过高
                float realWidth = (h-margin*2)*imageW/imageH;
                bigImageView.frame = CGRectMake((w-realWidth)/2.0, margin, realWidth, h-margin*2);
            }
            
        }
    }];
//    [bigImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        if (image) {
//            
//            float w = whiteView.frame.size.width;
//            float h = leftTime.frame.origin.y;
//            
//            float imageW = image.size.width;
//            float imageH = image.size.height;
//            
//            int margin = 5;
//            if (imageW/imageH > w/h) {
//                //过宽
//                float realHeight = (w-margin*2)*imageH/imageW;
//                bigImageView.frame = CGRectMake(margin, (h-realHeight)/2.0, w-margin*2, realHeight);
//            }else{
//                //过高
//                float realWidth = (h-margin*2)*imageW/imageH;
//                 bigImageView.frame = CGRectMake((w-realWidth)/2.0, margin, realWidth, h-margin*2);
//            }
//        }
//    }];
    
}
//-(void)addAnimation:(int)num
//{
//    NSLog(@"add:%d", num);
//    addLabel.text = [NSString stringWithFormat:@"+%d", num];
//    addLabel.alpha = 1;
//    [UIView animateWithDuration:0.8 animations:^{
//        addLabel.alpha = 0;
//        CGRect rect = addLabel.frame;
//        rect.origin.y -= 15;
//        addLabel.frame = rect;
//    }completion:^(BOOL finished) {
//        addLabel.frame = CGRectMake(foodNum.frame.origin.x, foodNum.frame.origin.y-15, foodNum.frame.size.width, 20);
//    }];
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
