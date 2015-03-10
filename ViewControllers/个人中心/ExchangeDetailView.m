//
//  ExchangeDetailView.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ExchangeDetailView.h"
#import "Alert_oneBtnView.h"
#import "Alert_2ButtonView2.h"
#import "Alert_HyperlinkView.h"

@implementation ExchangeDetailView

-(void)makeUI
{
    //黑 %60  白 %80
    UIButton * alphaBtn = [MyControl createButtonWithFrame:[UIScreen mainScreen].bounds ImageName:@"" Target:self Action:@selector(closeBtnClick) Title:nil];
//    UIView * alphaView = [MyControl createViewWithFrame:[UIScreen mainScreen].bounds];
    alphaBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:alphaBtn];
    
    float width = [UIScreen mainScreen].bounds.size.width-30;
    float height = width*770/590.0;
    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(15, ([UIScreen mainScreen].bounds.size.height-height)/2.0, width, height)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 2;
    bgView.layer.masksToBounds = YES;
    [self addSubview:bgView];
    
    UIImageView * headImage = [MyControl createImageViewWithFrame:CGRectMake(0, 0, bgView.frame.size.width, 135) ImageName:@""];
    [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@item/%@", IMAGEURL, self.model.img]]];
    [bgView addSubview:headImage];
    
    UIButton * closeBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width-40, 0, 40, 30) ImageName:@"exchange_detail_close.png" Target:self Action:@selector(closeBtnClick) Title:nil];
    [bgView addSubview:closeBtn];
    
    CGSize size = [self.model.name sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(bgView.frame.size.width-20, 100) lineBreakMode:1];
    UILabel * desLabel = [MyControl createLabelWithFrame:CGRectMake(10, headImage.frame.size.height+10, size.width, size.height) Font:15 Text:self.model.name];
    desLabel.textColor = [UIColor blackColor];
    [bgView addSubview:desLabel];
    
    UIImageView * food = [MyControl createImageViewWithFrame:CGRectMake(10, desLabel.frame.origin.y+desLabel.frame.size.height, 30, 30) ImageName:@"exchange_orangeFood.png"];
    [bgView addSubview:food];
    
    UILabel * price = [MyControl createLabelWithFrame:CGRectMake(food.frame.origin.x+food.frame.size.width+5, food.frame.origin.y, 200, food.frame.size.height) Font:17 Text:self.model.price];
    price.textColor = ORANGE;
    [bgView addSubview:price];
    
    
    //534  110
    UIButton * confirmBtn = [MyControl createButtonWithFrame:CGRectMake((bgView.frame.size.width-534/2)/2.0, bgView.frame.size.height-114/2, 534/2, 110/2) ImageName:@"public_longBtnBg.png" Target:self Action:@selector(confirmBtnClick) Title:@"确认兑换"];
    [bgView addSubview:confirmBtn];
    
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(5, food.frame.origin.y+food.frame.size.height, bgView.frame.size.width-10, confirmBtn.frame.origin.y-(food.frame.origin.y+food.frame.size.height))];
    sv.backgroundColor = [ControllerManager colorWithHexString:@"f2f2f2"];
    [bgView addSubview:sv];
    

    NSArray * array = [self.model.des componentsSeparatedByString:@"&"];
    float w = sv.frame.size.width-10;
    float totalHeight = 0;
    int a;
    for (int i=0; i<array.count; i++) {
        NSString * str = array[i];
        CGSize size1 = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(w, 100) lineBreakMode:1];
        if (i == 0) {
            a = 5;
        }else{
            a = 10;
        }
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(5, a+totalHeight, size1.width, size1.height) Font:12 Text:str];
        label.textColor = [ControllerManager colorWithHexString:@"414141"];
        [sv addSubview:label];
        totalHeight = label.frame.origin.y + size1.height;
    }
    
    sv.contentSize = CGSizeMake(bgView.frame.size.width-10, totalHeight+5);
    
//    NSString * nameStr = array[0];
//    NSString * rangeStr = array[1];
//    NSString * weightStr = array[2];
//    NSString * compStr = array[3];
    
//    @"产品描述：萌星专属明信片，宠物星球特别设计，一式九张哦~&特别说明：设计和印刷需要排期哦，最多需要大约两周~&&"
//    @"包装：自分装&规格：500g&适合：喵星人&特别说明：感恩新春，球长大酬宾~现在兑换，不但包邮，更有惊喜礼包哦~"
    
    
//    CGSize size1 = [nameStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(w, 100) lineBreakMode:1];
//    UILabel * name = [MyControl createLabelWithFrame:CGRectMake(5, 5, size1.width, size1.height) Font:12 Text:nameStr];
//    name.textColor = [ControllerManager colorWithHexString:@"414141"];
//    [sv addSubview:name];
//    
//    CGSize size2 = [rangeStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(w, 100) lineBreakMode:1];
//    UILabel * range = [MyControl createLabelWithFrame:CGRectMake(5, name.frame.origin.y+size1.height+10, size2.width, size2.height) Font:12 Text:rangeStr];
//    range.textColor = [ControllerManager colorWithHexString:@"414141"];
//    [sv addSubview:range];
//    
//    CGSize size3 = [weightStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(w, 100) lineBreakMode:1];
//    UILabel * weight = [MyControl createLabelWithFrame:CGRectMake(5, range.frame.origin.y+size2.height+10, size3.width, size3.height) Font:12 Text:weightStr];
//    weight.textColor = [ControllerManager colorWithHexString:@"414141"];
//    [sv addSubview:weight];
//    
//    CGSize size4 = [compStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(w, 100) lineBreakMode:1];
//    UILabel * comp = [MyControl createLabelWithFrame:CGRectMake(5, weight.frame.origin.y+size3.height+10, size4.width, size4.height) Font:12 Text:compStr];
//    comp.textColor = [ControllerManager colorWithHexString:@"414141"];
//    [sv addSubview:comp];
    
    
}

-(void)confirmBtnClick
{
    int num = [self.foodNum intValue];
    NSLog(@"%d", num);
    if (num<[self.model.price intValue]) {
        //提示口粮不足
        Alert_oneBtnView * alert = [[Alert_oneBtnView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alert.type = 1;
        [alert makeUI];
        [self addSubview:alert];
        [alert release];
    }else{
//        Alert_HyperlinkView * one = [[Alert_HyperlinkView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        one.type = 2;
//        one.jumpAddress = ^(){
//            self.jumpAddress();
//        };
//        [one makeUI];
//        [self addSubview:one];
//        [one release];
//        return;
        
        Alert_2ButtonView2 * alert = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alert.type = 3;
        alert.productName = self.model.name;
        alert.foodCost = self.model.price;
        alert.exchange = ^(){
            LOADING;
            NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&item_id=%@dog&cat", self.aid, self.model.item_id]];
            NSString * url = [NSString stringWithFormat:@"%@%@&item_id=%@&sig=%@&SID=%@", EXCHANGEAPI, self.aid, self.model.item_id, sig, [ControllerManager getSID]];
            NSLog(@"%@", url);
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    NSLog(@"%@", load.dataDict);
                    if([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]] && [[[load.dataDict objectForKey:@"data"] objectForKey:@"food"] isKindOfClass:[NSNumber class]] && [[[load.dataDict objectForKey:@"data"] objectForKey:@"food"] intValue] != [self.foodNum intValue]){
                        //兑换成功
                        self.foodNum = [NSString stringWithFormat:@"%@", [[load.dataDict objectForKey:@"data"] objectForKey:@"food"]];
                        self.refreshFoodNum(self.foodNum);
                        Alert_HyperlinkView * one = [[Alert_HyperlinkView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                        one.type = 2;
                        one.jumpAddress = ^(){
                            self.jumpAddress();
                        };
                        [one makeUI];
                        [self addSubview:one];
                        [one release];
                        
                    }else{
                        //兑换失败
                        [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"兑换失败"];
                    }
                    ENDLOADING;
                }else{
                    LOADFAILED;
                }
            }];
            [request release];
        };
        [alert makeUI];
        [self addSubview:alert];
        [alert release];
    }
}
-(void)closeBtnClick
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
