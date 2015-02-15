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
    headView.backgroundColor = [ControllerManager colorWithHexString:@"6f331f"];
    headView.alpha = 0.2;
    [bgView addSubview:headView];
    
    position = [MyControl createImageViewWithFrame:CGRectMake(5, 0, 140/2, 86/2.0) ImageName:@"position_0.png"];
    [bgView addSubview:position];
    
    positionLabel = [MyControl createLabelWithFrame:CGRectMake(0, 7, 70, 15) Font:13 Text:@"经纪人"];
    positionLabel.font = [UIFont boldSystemFontOfSize:13];
    positionLabel.textAlignment = NSTextAlignmentCenter;
    [position addSubview:positionLabel];
    
    self.contributionLabel = [MyControl createLabelWithFrame:CGRectMake(0, 20, 70, 15) Font:9 Text:@""];
    self.contributionLabel.textAlignment = NSTextAlignmentCenter;
    self.contributionLabel.textColor = [UIColor colorWithRed:252/255.0 green:196/255.0 blue:182/255.0 alpha:1];
    [position addSubview:self.contributionLabel];
    
    //邀请按钮
    inviteBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width-10-50, 5, 50, 28) ImageName:@"inviteBtn.png" Target:self Action:@selector(inviteBtnClick) Title:@"拉粉丝"];
    inviteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:inviteBtn];
    
    if([[USER objectForKey:@"confVersion"] isEqualToString:[USER objectForKey:@"versionKey"]]){
        inviteBtn.hidden = YES;
    }
    
    //f79879  50%
    UIView * headBgView = [MyControl createViewWithFrame:CGRectMake((bgView.frame.size.width-44)/2, 5, 44, 44)];
    headBgView.layer.cornerRadius = 22;
    headBgView.layer.masksToBounds = YES;
    headBgView.backgroundColor = [ControllerManager colorWithHexString:@"f79879"];
    headBgView.alpha = 0.5;
    [bgView addSubview:headBgView];
    
    headBtn = [MyControl createButtonWithFrame:CGRectMake(headBgView.frame.origin.x+2, headBgView.frame.origin.y+2, 40, 40) ImageName:@"defaultPetHead.png" Target:self Action:@selector(headBtnClick) Title:nil];
    headBtn.layer.cornerRadius = 20;
    headBtn.layer.masksToBounds = YES;
    [bgView addSubview:headBtn];
    
    //
    nameLabel = [MyControl createLabelWithFrame:CGRectMake(0, headBgView.frame.origin.y+44+5, bgView.frame.size.width, 15) Font:14 Text:nil];
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
    tf.layer.cornerRadius = 10;
    tf.layer.masksToBounds = YES;
    [bgView addSubview:tf];
    
    hyperBtn = [[HyperlinksButton alloc] initWithFrame:CGRectMake(200, 152/2, 50, 20)];
    [hyperBtn setTitle:@"修改" forState:UIControlStateNormal];
    [hyperBtn setTitle:@"确定" forState:UIControlStateSelected];
    [hyperBtn setColor:BGCOLOR];
    [hyperBtn setTitleColor:BGCOLOR forState:UIControlStateNormal];
    hyperBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [hyperBtn addTarget:self action:@selector(hyperBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    hyperBtn.showsTouchWhenHighlighted = YES;
    [bgView addSubview:hyperBtn];
    hyperBtn.hidden = YES;
    
    modifyBtn = [MyControl createButtonWithFrame:CGRectMake(hyperBtn.frame.origin.x, hyperBtn.frame.origin.y, 20, 20) ImageName:@"star_modify.png" Target:self Action:@selector(modifyBtnClick) Title:nil];
    [bgView addSubview:modifyBtn];
    modifyBtn.hidden = YES;
    //
    dataBgView = [MyControl createViewWithFrame:CGRectMake(0, 90, bgView.frame.size.width, 20)];
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
    
    lab1 = [MyControl createLabelWithFrame:CGRectMake(0, 0, size1.width, 20) Font:14 Text:str1];
    [dataBgView addSubview:lab1];
    
    lab4 = [MyControl createLabelWithFrame:CGRectMake(size1.width+5, 0, size4.width, 20) Font:17 Text:str4];
    lab4.textColor = BGCOLOR;
    [dataBgView addSubview:lab4];
    
    lab2 = [MyControl createLabelWithFrame:CGRectMake(lab4.frame.origin.x+size4.width+5, 0, size2.width, 20) Font:14 Text:str2];
    [dataBgView addSubview:lab2];
    
    lab5 = [MyControl createLabelWithFrame:CGRectMake(lab2.frame.origin.x+size2.width+5, 0, size5.width, 20) Font:17 Text:str5];
    lab5.textColor = BGCOLOR;
    [dataBgView addSubview:lab5];
    
    lab3 = [MyControl createLabelWithFrame:CGRectMake(lab5.frame.origin.x+size5.width+5, 0, size3.width, 20) Font:14 Text:str3];
    [dataBgView addSubview:lab3];
    
    dataBgView.frame = CGRectMake((bgView.frame.size.width-(lab3.frame.origin.x+size3.width))/2.0, 100, lab3.frame.origin.x+size3.width, 20);
    
    /*****************华丽分割线********************/
    //22  44
    float spe = (bgView.frame.size.width-44-44*4)/3;
    NSArray * array1 = @[@"star_food.png", @"star_shake.png", @"star_gift.png", @"star_touch.png"];
    NSArray * array2 = @[@"挣口粮", @"摇一摇", @"献爱心", @"萌印象"];
    NSArray * array3 = @[@"快来挣", @"还剩3次", @"送了0次", @"还没摸"];
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
        
        UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(label.frame.origin.x-10, label.frame.origin.y+15, 64, 12) Font:12 Text:array3[i]];
        label2.textColor = [UIColor lightGrayColor];
        label2.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label2];
//        label2.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        label2.tag = 300+i;
    }
    
    float spe2 = (bgView.frame.size.width-44-50*4)/3;
    for(int i=0; i<4; i++){
        UIImageView * image = [MyControl createImageViewWithFrame:CGRectMake(22+i*(50+spe2), 230, 50, 50) ImageName:@""];
        [bgView addSubview:image];
        image.tag = 500+i;
        
        UIButton * imageBtn = [MyControl createButtonWithFrame:CGRectMake(22+i*(50+spe2), 230, 50, 50) ImageName:@"" Target:self Action:@selector(imageBtnClick:) Title:nil];
        [bgView addSubview:imageBtn];
        imageBtn.tag = 400+i;
    }
}
-(void)inviteBtnClick
{
    NSLog(@"inviteClick");
    self.inviteClick();
}
-(void)headBtnClick
{
    NSLog(@"跳转宠物主页");
    self.headClick(self.aid);
    [tf resignFirstResponder];
}
-(void)actBtnClick:(UIButton *)btn
{
    self.actClickSend(self.model.aid, self.model.name, self.model.tx);
    NSLog(@"%d", btn.tag);
    self.actClick(btn.tag-100);
    [tf resignFirstResponder];
}
-(void)imageBtnClick:(UIButton *)btn
{
    NSLog(@"%d", btn.tag);
    self.imageClick([self.imageArray[btn.tag-400] objectForKey:@"img_id"]);
    [tf resignFirstResponder];
}
-(void)adjustCellHeight:(int)a
{
    if(!a){
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

-(void)modifyBtnClick
{
    if (isModify) {
        [self hyperBtnClick:hyperBtn];
    }else{
        NSLog(@"私信");
        self.msgClick();
    }
    
}
-(void)hyperBtnClick:(UIButton *)btn
{
    NSLog(@"hyper");
    tf.userInteractionEnabled = YES;
    [tf becomeFirstResponder];
    if(btn.selected == YES){
        hyperBtn.hidden = YES;
        modifyBtn.hidden = NO;
        [self textFieldShouldReturn:tf];
    }else{
        hyperBtn.hidden = NO;
        modifyBtn.hidden = YES;
        btn.selected = YES;
    }
    
}
-(void)configUI:(MyStarModel *)model
{
<<<<<<< HEAD
<<<<<<< HEAD
=======
    
>>>>>>> dev-miao
=======
    
>>>>>>> dev-miao
    if ([model.tb_version intValue] == 1) {
        UILabel * tempLabel = (UILabel *)[self viewWithTag:202];
        tempLabel.text = @"买周边";
        
        UIButton * button = (UIButton *)[self viewWithTag:102];
        [button setBackgroundImage:[UIImage imageNamed:@"star_zb.png"] forState:UIControlStateNormal];
        
        UILabel * tempLabel2 = (UILabel *)[self viewWithTag:302];
        tempLabel2.text = @"快来买";
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> dev-miao
    }else{
        UILabel * tempLabel = (UILabel *)[self viewWithTag:202];
        tempLabel.text = @"献爱心";
        
        UIButton * button = (UIButton *)[self viewWithTag:102];
        [button setBackgroundImage:[UIImage imageNamed:@"star_gift.png"] forState:UIControlStateNormal];
<<<<<<< HEAD
>>>>>>> dev-miao
=======
>>>>>>> dev-miao
    }
    
    
    tf.userInteractionEnabled = NO;
    hyperBtn.hidden = YES;
    modifyBtn.hidden = YES;
    
    UILabel * la = (UILabel *)[bgView viewWithTag:203];
    UILabel * la2 = (UILabel *)[bgView viewWithTag:303];
    UIButton * bt = (UIButton *)[bgView viewWithTag:103];
    if ([model.master_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
//        hyperBtn.hidden = NO;
        modifyBtn.hidden = NO;
        [modifyBtn setBackgroundImage:[UIImage imageNamed:@"star_modify.png"] forState:UIControlStateNormal];
        isModify = YES;
    }else{
        modifyBtn.hidden = NO;
        [modifyBtn setBackgroundImage:[UIImage imageNamed:@"pet_msg.png"] forState:UIControlStateNormal];
        CGRect rect = modifyBtn.frame;
        rect.size.width = 23;
        modifyBtn.frame = rect;
        isModify = NO;
    }
//
//        la.text = @"萌印象";
//        [bt setBackgroundImage:[UIImage imageNamed:@"star_shout.png"] forState:UIControlStateNormal];
//        if([[model.dict objectForKey:@"is_voiced"] isKindOfClass:[NSNull class]] || [model.is_voiced intValue] == 0){
//            la2.text = @"没叫过";
//        }else{
//            la2.text = @"叫过了";
//        }
//    }else{
        la.text = @"萌印象";
//        [bt setBackgroundImage:[UIImage imageNamed:@"star_touch.png"] forState:UIControlStateNormal];
        if([[model.dict objectForKey:@"is_touched"] isKindOfClass:[NSNull class]] || [model.is_touched intValue] == 0){
            la2.text = @"没摸过";
        }else{
            la2.text = @"摸过了";
        }
//    }
    
    
    
    for (int i=0; i<4; i++) {
        UIButton * btn = (UIButton *)[bgView viewWithTag:400+i];
        btn.hidden = YES;
        
        UIImageView * imageView = (UIImageView *)[bgView viewWithTag:500+i];
        imageView.hidden = YES;
    }
    
    self.aid = model.aid;
    self.model = model;
    
    if ([model.msg isKindOfClass:[NSString class]] && model.msg.length != 0) {
        tf.text = model.msg;
    }else{
        if([model.master_id isEqualToString:[USER objectForKey:@"usr_id"]]){
            tf.text = @"点击创建独一无二的萌宣言吧~";
        }else{
            tf.text = [NSString stringWithFormat:@"%@暂时沉默中~", model.name];
        }
        
    }
    self.tempTfString = tf.text;
    
    CGSize tfSize = [tf.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(250, 20) lineBreakMode:1];
    tf.frame = CGRectMake((bgView.frame.size.width-tfSize.width)/2, 152/2, tfSize.width, 20);
//    tf.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    CGRect hyRect = hyperBtn.frame;
    hyRect.origin.x = tf.frame.origin.x+tfSize.width-10;
    hyperBtn.frame = hyRect;
    //
    CGRect modRect = modifyBtn.frame;
    modRect.origin.x = hyRect.origin.x+15;
    modifyBtn.frame = modRect;
    
    position.image = [UIImage imageNamed:[NSString stringWithFormat:@"position_%@.png", model.rank]];
    positionLabel.text = [ControllerManager returnPositionWithRank:model.rank];
    self.contributionLabel.text = [NSString stringWithFormat:@"贡献度%@", model.t_contri];
    nameLabel.text = model.name;
    lab4.text = model.t_rq;
    lab5.text = [NSString stringWithFormat:@"%@%@", model.percent, @"%"];
    
    NSString * str1 = @"总人气";
    NSString * str2 = @"，击败了";
    NSString * str3 = @"的萌星";
    
    NSString * str4 = lab4.text;
    NSString * str5 = lab5.text;
    
//    NSLog(@"%@--%@", model.t_rq, model.percent);
    CGSize size1 = [str1 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    CGSize size2 = [str2 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    CGSize size3 = [str3 sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    
    CGSize size4 = [str4 sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    CGSize size5 = [str5 sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    
    lab4.frame = CGRectMake(size1.width+5, 0, size4.width, 20);
    lab2.frame = CGRectMake(lab4.frame.origin.x+size4.width+5, 0, size2.width, 20);
    lab5.frame = CGRectMake(lab2.frame.origin.x+size2.width+5, 0, size5.width, 20);
    lab3.frame = CGRectMake(lab5.frame.origin.x+size5.width+5, 0, size3.width, 20);
    dataBgView.frame = CGRectMake((bgView.frame.size.width-(lab3.frame.origin.x+size3.width))/2.0, 100, lab3.frame.origin.x+size3.width, 20);
    
    //
    UILabel * label1 = (UILabel *)[bgView viewWithTag:301];
    UILabel * label2 = (UILabel *)[bgView viewWithTag:302];
//    UILabel * label3 = (UILabel *)[bgView viewWithTag:302];
//    UILabel * label4 = (UILabel *)[bgView viewWithTag:303];
    if ([[model.dict objectForKey:@"shake_count"] isKindOfClass:[NSNull class]]) {
        label1.text = @"还剩3次";
    }else{
        label1.text = [NSString stringWithFormat:@"还剩%@次", model.shake_count];
    }
    //
    if ([[model.dict objectForKey:@"gift_count"] isKindOfClass:[NSNull class]]) {
        label2.text = @"送了0次";
    }else{
        label2.text = [NSString stringWithFormat:@"送了%@次", model.gift_count];
    }
    //
//    if ([[model.dict objectForKey:@"is_touched"] isKindOfClass:[NSNull class]]) {
//        label3.text = @"送了0次";
//    }else{
//        label3.text = [NSString stringWithFormat:@"送了%@次", model.gift_count];
//    }
    //
//    if ([[model.dict objectForKey:@"gift_count"] isKindOfClass:[NSNull class]]) {
//        label2.text = @"送了0次";
//    }else{
//        label2.text = [NSString stringWithFormat:@"送了%@次", model.gift_count];
//    }
    
//    return;
    [headBtn setBackgroundImage:[UIImage imageNamed:@"defaultPetHead.png"] forState:UIControlStateNormal];
    if (!([model.tx isKindOfClass:[NSNull class]] || [model.tx length]==0)) {
        [MyControl setImageForBtn:headBtn Tx:model.tx isPet:YES isRound:YES];
        
//        NSString * docDir = DOCDIR;
//        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
//        //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
//        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
//        if (image) {
//            [headBtn setBackgroundImage:image forState:UIControlStateNormal];
//            //            headImageView.image = image;
//        }else{
//            //下载头像
//            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, model.tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//                if (isFinish) {
//                    [headBtn setBackgroundImage:load.dataImage forState:UIControlStateNormal];
//                    //                    headImageView.image = load.dataImage;
//                    NSString * docDir = DOCDIR;
//                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
//                    [load.data writeToFile:txFilePath atomically:YES];
//                }else{
//                    NSLog(@"头像下载失败");
//                }
//            }];
//            [request release];
//        }
    }
    
    if (model.images.count) {
        self.imageArray = model.images;
        for (int i=0; i<model.images.count; i++) {
            UIButton * btn = (UIButton *)[bgView viewWithTag:400+i];
            btn.hidden = NO;
            
            UIImageView * imageView = (UIImageView *)[bgView viewWithTag:500+i];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.hidden = NO;
            
//            NSString * docDir = DOCDIR;
            NSString * imageUrl = [model.images[i] objectForKey:@"url"];
            
            [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, imageUrl]]];
            
//            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageUrl]];
//            //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
//            UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
//            if (image) {
////                [btn setBackgroundImage:image forState:UIControlStateNormal];
//                imageView.image = image;
//            }else{
//                //下载图片
//                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, imageUrl] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//                    if (isFinish) {
////                        [btn setBackgroundImage:load.dataImage forState:UIControlStateNormal];
//                        imageView.image = load.dataImage;
//                        NSString * docDir = DOCDIR;
//                        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageUrl]];
//                        [load.data writeToFile:txFilePath atomically:YES];
//                    }else{
//                        NSLog(@"图片下载失败");
//                    }
//                }];
//                [request release];
//            }
        }
    }
}

#pragma mark -
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //移动tableView到顶，以免textField被遮挡
    tf.backgroundColor = [UIColor colorWithRed:226/255.0 green:215/255.0 blue:215/255.0 alpha:1];
    CGRect rect = tf.frame;
    rect.size.width = 100;
    rect.origin.x = (bgView.frame.size.width-100)/2.0;
    tf.frame = rect;
    
    CGRect rect2 = hyperBtn.frame;
    rect2.origin.x = rect.origin.x+100;
    hyperBtn.frame = rect2;
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    tf.backgroundColor = [UIColor clearColor];
    tf.userInteractionEnabled = NO;
    hyperBtn.selected = NO;
    hyperBtn.hidden = YES;
    modifyBtn.hidden = NO;
    [textField resignFirstResponder];
    if (![tf.text isEqualToString:self.tempTfString] && tf.text.length>0) {
        [self postMsg];
        //API
//        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.aid]];
//        NSString * url = [NSString stringWithFormat:@"%@%@&msg=%@&sig=%@&SID=%@", MODIFYDECLAREAPI, self.aid, [tf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], sig, [ControllerManager getSID]];
//        NSLog(@"%@", url);
//        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//            if (isFinish) {
//                NSLog(@"%@", load.dataDict);
//                
//                CGSize tfSize = [tf.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(250, 20) lineBreakMode:1];
//                tf.frame = CGRectMake((bgView.frame.size.width-tfSize.width)/2, 152/2, tfSize.width, 20);
//                //    tf.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//                CGRect hyRect = hyperBtn.frame;
//                hyRect.origin.x = tf.frame.origin.x+tfSize.width-10;
//                hyperBtn.frame = hyRect;
//            }else{
//                
//            }
//        }];
//        [request release];
    }
    return YES;
}

-(void)postMsg
{
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.aid]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", MODIFYDECLAREAPI, self.aid, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 60.0;
    [_request setPostValue:tf.text forKey:@"msg"];
    _request.delegate = self;
    [_request startAsynchronous];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    ENDLOADING;
    NSLog(@"响应：%@", [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if([[dict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
        CGSize tfSize = [tf.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(250, 20) lineBreakMode:1];
        tf.frame = CGRectMake((bgView.frame.size.width-tfSize.width)/2, 152/2, tfSize.width, 20);
        CGRect hyRect = hyperBtn.frame;
        hyRect.origin.x = tf.frame.origin.x+tfSize.width-10;
        hyperBtn.frame = hyRect;
        
        //
        CGRect modRect = modifyBtn.frame;
        modRect.origin.x = hyRect.origin.x+15;
        modifyBtn.frame = modRect;
    }else{
        tf.text = self.tempTfString;
    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    tf.text = self.tempTfString;
    LOADFAILED;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
