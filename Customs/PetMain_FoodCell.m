//
//  PetMain_FoodCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PetMain_FoodCell.h"
#import "ChargeViewController.h"

@implementation PetMain_FoodCell

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
    float width = [UIScreen mainScreen].bounds.size.width;
    
    headImage = [MyControl createImageViewWithFrame:CGRectMake(16, 10, 86, 86) ImageName:@""];
    headImage.contentMode = UIViewContentModeScaleAspectFill;
    headImage.clipsToBounds = YES;
    [self addSubview:headImage];
    
    //距照片20，距右边15
    float originX = headImage.frame.origin.x+headImage.frame.size.width+20;
    foodNum = [MyControl createLabelWithFrame:CGRectMake(originX, 10, [UIScreen mainScreen].bounds.size.width-originX-15, 17) Font:16 Text:nil];
    foodNum.textColor = ORANGE;
    [self addSubview:foodNum];
    
    desLabel = [MyControl createLabelWithFrame:CGRectMake(originX, headImage.frame.origin.y+15, [UIScreen mainScreen].bounds.size.width-originX-15, headImage.frame.size.height-15) Font:12 Text:nil];
    desLabel.textColor = [UIColor blackColor];
    [self addSubview:desLabel];
    
    timeLabel = [MyControl createLabelWithFrame:CGRectMake(width-15-100, 10+headImage.frame.size.height-10, 100, 15) Font:11 Text:nil];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [self addSubview:timeLabel];
    
    line = [MyControl createViewWithFrame:CGRectMake(0, 104, width, 0.8)];
    line.backgroundColor = [ControllerManager colorWithHexString:@"b9b9b9"];
    [self addSubview:line];
    
//    [self createReward];
}
-(void)createReward
{
    if (rewardBg) {
        rewardBg.hidden = NO;
        selectView.hidden = YES;
        heartBtn.hidden = NO;
        return;
    }
//    [line removeFromSuperview];
    
    float width = [UIScreen mainScreen].bounds.size.width;
    //587  98
    rewardBg = [MyControl createImageViewWithFrame:CGRectMake((width-498/2)/2.0, 106, 498/2, 103/2) ImageName:@"food_rewardBg.png"];
    [self addSubview:rewardBg];
    
    //
    UIImageView * food = [MyControl createImageViewWithFrame:CGRectMake(30, (rewardBg.frame.size.height-25)/2.0, 25, 25) ImageName:@"exchange_whiteFood.png"];
    [rewardBg addSubview:food];
    
    rewardNum = [MyControl createLabelWithFrame:CGRectMake(75, 0, 47, rewardBg.frame.size.height) Font:17 Text:@"1"];
    rewardNum.font = [UIFont boldSystemFontOfSize:17];
    rewardNum.textAlignment = NSTextAlignmentCenter;
    [rewardBg addSubview:rewardNum];
    
    
    UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(125, (rewardBg.frame.size.height-31/2)/2.0, 18/2, 31/2) ImageName:@"rightArrow.png"];
    [rewardBg addSubview:arrow];
    
    
    
    //10 100 1000
    selectView = [MyControl createViewWithFrame:CGRectMake(rewardBg.frame.origin.x+45, rewardBg.frame.origin.y-105, 113, 105)];
    selectView.hidden = YES;
    [self addSubview:selectView];
    
    UIImageView * selectBg = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 113, 100) ImageName:@""];
    selectBg.image = [[UIImage imageNamed:@"food_selectBg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [selectView addSubview:selectBg];
    
    UIImageView * selectTri = [MyControl createImageViewWithFrame:CGRectMake((113-19/2.0)/2.0, 100, 19/2.0, 5) ImageName:@"food_selectBg_tri.png"];
    [selectView addSubview:selectTri];
    
    NSArray * numArray = @[@"1000", @"100", @"10", @"1"];
    for (int i=0; i<numArray.count; i++) {
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(0, 25*i, selectBg.frame.size.width, 25) Font:17 Text:[NSString stringWithFormat:@"   %@", numArray[i]]];
        label.tag = 200+i;
        [selectBg addSubview:label];
        
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(0, 25*i, selectBg.frame.size.width, 25) ImageName:@"" Target:self Action:@selector(numBtnClick:) Title:nil];
        [selectBg addSubview:button];
        button.tag = 100+i;
        if (i == 3) {
            label.backgroundColor = ORANGE;
        }
    }
    
    //
    UIButton * selectBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, rewardBg.frame.size.width/2.0, rewardBg.frame.size.height) ImageName:@"" Target:self Action:@selector(selectBtnClick:) Title:nil];
    selectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [rewardBg addSubview:selectBtn];

    
    heartBtn = [MyControl createButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-90, rewardBg.frame.origin.y-2, 126/2, 115/2) ImageName:@"food_heart.png" Target:self Action:@selector(rewardBtnClick:) Title:nil];

    [self addSubview:heartBtn];
}
-(void)rewardBtnClick:(UIButton *)btn
{
    self.rewardClick(rewardNum);

}
-(void)reward
{
//    int a = tv.contentOffset.y/self.view.frame.size.width;
    
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@&n=%@dog&cat", self.img_id, rewardNum.text]];
    NSString * url = [NSString stringWithFormat:@"%@%@&n=%@&sig=%@&SID=%@", REWARDFOODAPI, self.img_id, rewardNum.text, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    __block PetMain_FoodCell * blockSelf = self;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                if ([blockSelf->rewardNum.text intValue]>[[USER objectForKey:@"food"] intValue]) {
                    [USER setObject:@"0" forKey:@"food"];
                }else{
                    [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"food"] intValue]-[blockSelf->rewardNum.text intValue]] forKey:@"food"];
                }
                
                [USER setObject:[NSString stringWithFormat:@"%@", [[load.dataDict objectForKey:@"data"] objectForKey:@"gold"]] forKey:@"gold"];
//                BegFoodListModel * model = self.dataArray[a];
                
                blockSelf->foodNum.text = [NSString stringWithFormat:@"已挣得口粮：%@ 份", [NSString stringWithFormat:@"%@", [[load.dataDict objectForKey:@"data"] objectForKey:@"food"]]];
//                self.begModel.food = [[load.dataDict objectForKey:@"data"] objectForKey:@"food"];
                [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"打赏成功，感谢您的爱心！"];
                
            }
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}

#pragma mark -
-(void)numBtnClick:(UIButton *)btn
{
    [UIView animateWithDuration:0.2 animations:^{
        selectView.alpha = 0;
    } completion:^(BOOL finished) {
        selectView.hidden = YES;
    }];
    NSLog(@"%d", btn.tag);
    for (int i=0; i<4; i++) {
        UILabel * label = (UILabel *)[self viewWithTag:200+i];
        label.backgroundColor = [UIColor clearColor];
    }
    UILabel * label = (UILabel *)[self viewWithTag:100+btn.tag];
    label.backgroundColor = ORANGE;
    
    NSArray * numArray = @[@"1000", @"100", @"10", @"1"];
    rewardNum.text = numArray[btn.tag-100];
}
-(void)selectBtnClick:(UIButton *)btn
{
    if (selectView.hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            selectView.hidden = NO;
            selectView.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            selectView.alpha = 0;
        } completion:^(BOOL finished) {
            selectView.hidden = YES;
        }];
    }
    
}

-(void)configUI:(BegFoodListModel *)model
{
    rewardBg.hidden = YES;
    selectView.hidden = YES;
    heartBtn.hidden = YES;
    
    self.img_id = model.img_id;
    
    NSURL *url = [MyControl returnThumbImageURLwithName:model.url Width:headImage.frame.size.width*2 Height:headImage.frame.size.height*2];
    [headImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultPetPic.jpg"]];
    
    desLabel.text = model.cmt;
    timeLabel.text = [MyControl timeFromTimeStamp:model.create_time];
    foodNum.text = [NSString stringWithFormat:@"已挣得口粮：%@ 份", model.food];
    
    NSDate * date = [NSDate date];
    //当前时间戳
    int stamp = [[NSString stringWithFormat:@"%f", [date timeIntervalSince1970]] intValue];
    int timeStamp = [model.create_time intValue];
    if(stamp-timeStamp >= 24*60*60){
        CGRect rect = line.frame;
        rect.origin.y = 104.0;
        line.frame = rect;
    }else{
        [self createReward];
        
        CGRect rect = line.frame;
        rect.origin.y = 164.0;
        line.frame = rect;
    }
}



@end
