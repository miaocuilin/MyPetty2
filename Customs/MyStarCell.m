//
//  MyStarCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/6.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MyStarCell.h"

@implementation MyStarCell

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
//-(void)makeUIWithWidth:(float)width Height:(float)height
//{
//
//}
-(void)makeUI
{
//    NSLog(@"%f--%f--%f--%f", self.frame.size.width, self.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
    bgView = [MyControl createViewWithFrame:CGRectMake(10, 0, self.contentView.frame.size.width-20, self.contentView.frame.size.height)];
//    bgView.backgroundColor = [UIColor purpleColor];
    [self addSubview:bgView];
    
    bgAlphaView = [MyControl createViewWithFrame:CGRectMake(0, 130, bgView.frame.size.width, bgView.frame.size.height-130)];
    bgAlphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [bgView addSubview:bgAlphaView];
    
    headView = [MyControl createViewWithFrame:CGRectMake(0, 0, bgView.frame.size.width, 130)];
    headView.backgroundColor = [ControllerManager colorWithHexString:@"fc7b51"];
    headView.alpha = 0.2;
    [bgView addSubview:headView];
    
    UIImageView * position = [MyControl createImageViewWithFrame:CGRectMake(5, 0, 130/2, 75/2.0) ImageName:@"position_0.png"];
    [bgView addSubview:position];
    
    positionLabel = [MyControl createLabelWithFrame:CGRectMake(0, 7, 65, 15) Font:13 Text:@"经纪人"];
    positionLabel.font = [UIFont boldSystemFontOfSize:13];
    positionLabel.textAlignment = NSTextAlignmentCenter;
    [position addSubview:positionLabel];
    
    contributionLabel = [MyControl createLabelWithFrame:CGRectMake(0, 20, 65, 15) Font:9 Text:@"贡献度250"];
    contributionLabel.textAlignment = NSTextAlignmentCenter;
    contributionLabel.textColor = [UIColor colorWithRed:252/255.0 green:196/255.0 blue:182/255.0 alpha:1];
    [position addSubview:contributionLabel];
    
    //f79879  50%
    UIView * headBgView = [MyControl createViewWithFrame:CGRectMake((bgView.frame.size.width-44)/2, 5, 44, 44)];
    headBgView.layer.cornerRadius = 22;
    headBgView.layer.masksToBounds = YES;
    headBgView.backgroundColor = [ControllerManager colorWithHexString:@"f79879"];
    headBgView.alpha = 0.5;
    [bgView addSubview:headBgView];
    
    headBtn = [MyControl createButtonWithFrame:CGRectMake(headBgView.frame.origin.x+2, headBgView.frame.origin.y+2, 40, 40) ImageName:@"cat2.jpg" Target:self Action:@selector(headBtnClick) Title:nil];
    headBtn.layer.cornerRadius = 20;
    headBtn.layer.masksToBounds = YES;
    [bgView addSubview:headBtn];
    
    //
    nameLabel = [MyControl createLabelWithFrame:CGRectMake(0, headBgView.frame.origin.y+44+5, bgView.frame.size.width, 15) Font:14 Text:@"小熊维尼维尼联萌"];
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:nameLabel];
    
    //
    tf = [MyControl createTextFieldWithFrame:CGRectMake(70, 152/2, 160, 20) placeholder:@"萌星宣言" passWord:NO leftImageView:nil rightImageView:nil Font:12];
    tf.returnKeyType = UIReturnKeyDone;
    tf.delegate = self;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.backgroundColor = [UIColor clearColor];
    tf.textColor = [UIColor whiteColor];
    tf.borderStyle = 0;
    [bgView addSubview:tf];
    
    //
    UIView * dataBgView = [MyControl createViewWithFrame:CGRectMake(0, 90, bgView.frame.size.width, 20)];
    [bgView addSubview:dataBgView];
    
    NSString * str1 = @"总人气";
    NSString * str2 = @"，击败了";
    NSString * str3 = @"的萌星";
    
    NSString * str4 = @"1240";
    NSString * str5 = @"90%";
    
    CGSize size1 = [str1 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    CGSize size2 = [str2 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    CGSize size3 = [str3 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    
    CGSize size4 = [str4 sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    CGSize size5 = [str5 sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    
    UILabel * lab1 = [MyControl createLabelWithFrame:CGRectMake(0, 0, size1.width, 20) Font:14 Text:str1];
    [dataBgView addSubview:lab1];
    
    UILabel * lab4 = [MyControl createLabelWithFrame:CGRectMake(size1.width+5, 0, size4.width, 20) Font:17 Text:str4];
    lab4.textColor = BGCOLOR;
    [dataBgView addSubview:lab4];
    
    UILabel * lab2 = [MyControl createLabelWithFrame:CGRectMake(lab4.frame.origin.x+size4.width+5, 0, size2.width, 20) Font:14 Text:str2];
    [dataBgView addSubview:lab2];
    
    UILabel * lab5 = [MyControl createLabelWithFrame:CGRectMake(lab2.frame.origin.x+size2.width+5, 0, size5.width, 20) Font:17 Text:str5];
    lab5.textColor = BGCOLOR;
    [dataBgView addSubview:lab5];
    
    UILabel * lab3 = [MyControl createLabelWithFrame:CGRectMake(lab5.frame.origin.x+size5.width+5, 0, size3.width, 20) Font:14 Text:str3];
    [dataBgView addSubview:lab3];
    
    dataBgView.frame = CGRectMake((bgView.frame.size.width-(lab3.frame.origin.x+size3.width))/2.0, 100, lab3.frame.origin.x+size3.width, 20);
    
    /*****************华丽分割线********************/
    //22  44
    float spe = (bgView.frame.size.width-44-44*4)/3;
    NSArray * array1 = @[@"star_shake.png", @"star_gift.png", @"star_shout.png", @"star_play.png"];
    NSArray * array2 = @[@"摇一摇", @"送礼物", @"叫一叫", @"逗一逗"];
    NSArray * array3 = @[@"还剩3次", @"送了0次", @"叫过了", @"还没逗"];
    for (int i=0; i<4; i++) {
        UIButton * btn = [MyControl createButtonWithFrame:CGRectMake(22+i*(44+spe), 130+6, 44, 44) ImageName:array1[i] Target:self Action:@selector(actBtnClick:) Title:nil];
        [bgView addSubview:btn];
        btn.layer.cornerRadius = 22;
        btn.layer.masksToBounds = YES;
        btn.showsTouchWhenHighlighted = YES;
        btn.tag = 100+i;
        
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+44+5, 44, 15) Font:13 Text:array2[i]];
        label.textColor = BGCOLOR;
        label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label];
        label.tag = 200+i;
        
        UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y+15, 44, 12) Font:12 Text:array3[i]];
        label2.textColor = [UIColor lightGrayColor];
        label2.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label2];
        label2.tag = 300+i;
    }
    
    float spe2 = (bgView.frame.size.width-44-50*4)/3;
    for(int i=0; i<4; i++){
        UIButton * imageBtn = [MyControl createButtonWithFrame:CGRectMake(22+i*(50+spe2), 230, 50, 50) ImageName:@"cat2.jpg" Target:self Action:@selector(imageBtnClick:) Title:nil];
        [bgView addSubview:imageBtn];
        imageBtn.tag = 400+i;
    }
}
-(void)headBtnClick
{
    NSLog(@"跳转宠物主页");
    [tf resignFirstResponder];
}
-(void)actBtnClick:(UIButton *)btn
{
    NSLog(@"%d", btn.tag);
    self.actClick(btn.tag-100);
    [tf resignFirstResponder];
}
-(void)imageBtnClick:(UIButton *)btn
{
    NSLog(@"%d", btn.tag);
    [tf resignFirstResponder];
}
-(void)adjustCellHeight:(int)a
{
    if(a){
        bgView.frame = CGRectMake(10, 0, self.contentView.frame.size.width-20, 263.0);
        for (int i=0; i<4; i++) {
            UIButton * btn = (UIButton *)[bgView viewWithTag:400+i];
            btn.hidden = YES;
        }
    }else{
        bgView.frame = CGRectMake(10, 0, self.contentView.frame.size.width-20, 710.0/2);
        for (int i=0; i<4; i++) {
            UIButton * btn = (UIButton *)[bgView viewWithTag:400+i];
            btn.hidden = NO;
        }
    }
    bgAlphaView.frame = CGRectMake(0, 130, bgView.frame.size.width, bgView.frame.size.height-130-33);
//    headView.frame = CGRectMake(0, 0, bgView.frame.size.width, 130);
}

-(void)configUI
{
    
}

#pragma mark -
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //移动tableView到顶，以免textField被遮挡
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
