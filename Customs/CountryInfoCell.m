//
//  CountryInfoCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-12.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "CountryInfoCell.h"

@implementation CountryInfoCell

- (void)awakeFromNib
{
    // Initialization code
    [self createUI];
}
-(void)createUI
{    
    self.headImageView.layer.cornerRadius = 56/2;
    self.headImageView.layer.masksToBounds = YES;
    
    self.expBgImageView.image = [[UIImage imageNamed:@"RQBg.png"] stretchableImageWithLeftCapWidth:37/2 topCapHeight:26/2];
    self.expBgImageView.layer.cornerRadius = 6;
    self.expBgImageView.layer.masksToBounds = YES;
    
    
//    int length = arc4random()%160;
//    int exp = length/160.0*100;
    
    self.expImageView = [MyControl createImageViewWithFrame:CGRectMake(1, 1, 11, 11) ImageName:@""];
    self.expImageView.image = [[UIImage imageNamed:@"RQImage.png"] stretchableImageWithLeftCapWidth:26/2 topCapHeight:30/2];
//    expImageView.layer.cornerRadius = 7;
//    expImageView.layer.masksToBounds = YES;
    [self.expBgImageView addSubview:self.expImageView];
    
    [self.contentView bringSubviewToFront:self.expLabel];
    self.expLabel.text = [NSString stringWithFormat:@"%d/100", 11];
    
    NSArray * array = @[@"人气", @"动态", @"成员"];
    for(int i=0;i<3;i++){
        UILabel * numLabel = [MyControl createLabelWithFrame:CGRectMake(90+i*60, 60, 50, 15) Font:12 Text:@"100"];
        numLabel.textColor = BGCOLOR;
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.tag = 100+i;
        [self.contentView addSubview:numLabel];
        
        UILabel * nameLabel = [MyControl createLabelWithFrame:CGRectMake(90+i*60, 75, 50, 15) Font:11 Text:array[i]];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:nameLabel];
    }
    
    crown = [MyControl createImageViewWithFrame:CGRectMake(55, 52, 20, 20) ImageName:@"crown.png"];
    [self.contentView addSubview:crown];
    
    UIView * line = [MyControl createViewWithFrame:CGRectMake(0, self.contentView.frame.size.height-1, self.contentView.frame.size.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
}
-(void)modify:(int)row isSelf:(BOOL)isSelf
{
    if (isSelf) {
        isMe = YES;
    }
}
//手势操作
- (IBAction)show:(id)sender {
    if (!isMe) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        CGRect cellFrame = self.frame;
        cellFrame.origin.x = -200;
        cellFrame.size.width = 320+200;
        [self setFrame:cellFrame];
//        cellFrame = self.frame;
        
//        CGRect frame = self.buttonBgView.frame;
//        frame.size.width = 200;
//        self.buttonBgView.frame = frame;
    }];
}
- (IBAction)hide:(id)sender {
    if (!isMe) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect cellFrame = self.frame;
        cellFrame.origin.x = 0;
        cellFrame.size.width = 320;
        [self setFrame:cellFrame];
//        cellFrame = self.frame;
        
//        CGRect frame = self.buttonBgView.frame;
//        frame.size.width = 0;
//        self.buttonBgView.frame = frame;
    }];
}

//button
- (IBAction)quitBtnClick:(id)sender {
    NSLog(@"quit");
    if ([self.delegate respondsToSelector:@selector(swipeTableViewCell:didClickButtonWithIndex:)]) {
        [self.delegate swipeTableViewCell:self didClickButtonWithIndex:1];
    }
}
- (IBAction)switchBtnClick:(id)sender {
    NSLog(@"switch");
    if ([self.delegate respondsToSelector:@selector(swipeTableViewCell:didClickButtonWithIndex:)]) {
        [self.delegate swipeTableViewCell:self didClickButtonWithIndex:2];
    }
}
#pragma mark -
-(void)configUI:(UserPetListModel *)model
{
    crown.hidden = YES;
    
    if ([model.aid isEqualToString:[USER objectForKey:@"aid"]]) {
        crown.hidden = NO;
    }
    
    if ([model.aid isEqualToString:[USER objectForKey:@"aid"]]) {
        self.switchLabel1.text = @"默 认";
        self.switchLabel2.text = @"宠 物";
    }else{
        self.switchLabel1.text = @"设 为";
        self.switchLabel2.text = @"默 认";
    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ — %@联萌", [ControllerManager returnPositionWithRank:model.rank], model.name];
    for(int i=0;i<3;i++){
        UILabel * numLabel = (UILabel *)[self.contentView viewWithTag:100+i];
        if (i == 0) {
            numLabel.text = model.d_rq;
        }else if(i == 1){
            numLabel.text = model.news_count;
        }else{
            numLabel.text = model.fans_count;
        }
    }
    //
    int nextContri = [ControllerManager returnContributionOfNeedWithContribution:model.t_contri];
    int length = [model.t_contri floatValue]/nextContri*160;
    self.expImageView.frame = CGRectMake(1, 1, length, 11);
    self.expImageView.image = [[UIImage imageNamed:@"RQImage.png"] stretchableImageWithLeftCapWidth:23/2 topCapHeight:30/2];
    self.expLabel.text = [NSString stringWithFormat:@"%@/%d", model.t_contri, nextContri];
    /**************************/
    if (!([model.tx isKindOfClass:[NSNull class]] || model.tx.length==0)) {
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
        //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
        if (image) {
            self.headImageView.image = image;
        }else{
            //下载头像
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, model.tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    self.headImageView.image = load.dataImage;
                    NSString * docDir = DOCDIR;
                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
                    [load.data writeToFile:txFilePath atomically:YES];
                }else{
                    NSLog(@"头像下载失败");
                }
            }];
            [request release];
        }
    }
    
    /**************************/
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headImageView release];
    [_nameLabel release];
    [_expBgImageView release];
    [_expLabel release];
    [_buttonBgView release];
    [_qiutBtn release];
    [_switchBtn release];
    [_switchLabel1 release];
    [_switchLabel2 release];
    [super dealloc];
}
@end
