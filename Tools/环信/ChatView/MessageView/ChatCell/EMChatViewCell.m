/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "EMChatViewCell.h"
#import "EMChatVideoBubbleView.h"
#import "UIResponder+Router.h"

NSString *const kResendButtonTapEventName = @"kResendButtonTapEventName";
NSString *const kShouldResendCell = @"kShouldResendCell";

@implementation EMChatViewCell

- (id)initWithMessageModel:(MessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithMessageModel:model reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageView.clipsToBounds = YES;
        self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width/2.0;
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bubbleFrame = _bubbleView.frame;
    bubbleFrame.origin.y = self.headImageView.frame.origin.y;
//    [self.headImageView setImageWithURL:self.messageModel.imageRemoteURL];
    if (self.messageModel.isSender) {
        bubbleFrame.origin.y = self.headImageView.frame.origin.y;
        // 菊花状态 （因不确定菊花具体位置，要在子类中实现位置的修改）
        switch (self.messageModel.status) {
            case eMessageDeliveryState_Delivering:
            {
                [_activityView setHidden:NO];
                [_retryButton setHidden:YES];
                [_activtiy setHidden:NO];
                [_activtiy startAnimating];
            }
                break;
            case eMessageDeliveryState_Delivered:
            {
                [_activtiy stopAnimating];
                [_activityView setHidden:YES];
                
            }
                break;
            case eMessageDeliveryState_Failure:
            {
                [_activityView setHidden:NO];
                [_activtiy stopAnimating];
                [_activtiy setHidden:YES];
                [_retryButton setHidden:NO];
            }
                break;
            default:
                break;
        }
        
        bubbleFrame.origin.x = self.headImageView.frame.origin.x - bubbleFrame.size.width - HEAD_PADDING;
        _bubbleView.frame = bubbleFrame;
        
        CGRect frame = self.activityView.frame;
        frame.origin.x = bubbleFrame.origin.x - frame.size.width - ACTIVTIYVIEW_BUBBLE_PADDING;
        frame.origin.y = _bubbleView.center.y - frame.size.height / 2;
        self.activityView.frame = frame;
    }
    else{
        bubbleFrame.origin.x = HEAD_PADDING * 2 + HEAD_SIZE;
        _bubbleView.frame = bubbleFrame;
        //
        CGRect rect = jumpBtn.frame;
        rect.origin.x = _bubbleView.frame.origin.x+_bubbleView.frame.size.width+5;
        rect.origin.y = _bubbleView.frame.origin.y+5;
        rect.size.width = 28;
        rect.size.height = 28;
        jumpBtn.frame = rect;
    }
}

- (void)setMessageModel:(MessageModel *)model
{
    [super setMessageModel:model];
//    NSLog(@"%@--%@", model.nickName, model.message.ext);
    /*
     isSender的判断标准是说对于当前用户来说，该条信息是不是我发的,
     如果不是我发的isSender=NO,如果是我发的isSender=YES.
     */
//    if (model.isSender) {
//        [self.headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL, [model.message.ext objectForKey:@"tx"]]] placeholderImage:[UIImage]];
//        [MyControl setImageForImageView:self.headImageView Tx:[model.message.ext objectForKey:@"tx"] isPet:NO];
//    }else{
    
    if([model.username isEqualToString:@"1"]){
        self.headImageView.image = [UIImage imageNamed:@"miaomiao.png"];
    }else if([model.username isEqualToString:@"2"]){
        self.headImageView.image = [UIImage imageNamed:@"wangwang.png"];
    }else if([model.username isEqualToString:@"3"]){
        self.headImageView.image = [UIImage imageNamed:@"xiaoge.png"];
    }else if ([[model.message.ext objectForKey:@"tx"] isKindOfClass:[NSString class]] && [[model.message.ext objectForKey:@"tx"] length]) {
        [MyControl setImageForImageView:self.headImageView Tx:[model.message.ext objectForKey:@"tx"] isPet:NO];
    }
    
//    }
//    [self.headImageView setImageWithURL:model.imageRemoteURL placeholderImage:[UIImage imageNamed:@"defaultUserHead.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
////        if (!image) {
////            self.headImageView.image = [UIImage imageNamed:@"defaultUserHead.png"];
////        }
//    }];
    
    if (model.isChatGroup) {
        _nameLabel.text = model.username;
        _nameLabel.hidden = model.isSender;
    }
    
    _bubbleView.model = self.messageModel;
    [_bubbleView sizeToFit];
    
//    NSLog(@"%f--%f--%f", _bubbleView.frame.origin.x, _bubbleView.frame.size.width, _bubbleView.frame.size.width);
//    CGRect rect = jumpBtn.frame;
////    +self.headImageView.frame.size.width+HEAD_PADDING
//    rect.origin.x = _bubbleView.frame.origin.x+_bubbleView.frame.size.width+5;
////    +CELLPADDING
//    rect.origin.y = _bubbleView.frame.origin.y+5;
//    rect.size.width = 28;
//    rect.size.height = 28;
//    jumpBtn.frame = rect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - action

// 重发按钮事件
-(void)retryButtonPressed:(UIButton *)sender
{
    [self routerEventWithName:kResendButtonTapEventName
                     userInfo:@{kShouldResendCell:self}];
}

#pragma mark - private

- (void)setupSubviewsForMessageModel:(MessageModel *)messageModel
{
    [super setupSubviewsForMessageModel:messageModel];
    
    
    if (messageModel.isSender) {
        // 发送进度显示view
        _activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        [_activityView setHidden:YES];
        [self.contentView addSubview:_activityView];
        
        // 重发按钮
        _retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _retryButton.frame = CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE);
        [_retryButton addTarget:self action:@selector(retryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [_retryButton setImage:[UIImage imageNamed:@"messageSendFail.png"] forState:UIControlStateNormal];
        [_retryButton setBackgroundImage:[UIImage imageNamed:@"messageSendFail.png"] forState:UIControlStateNormal];
        //[_retryButton setBackgroundColor:[UIColor redColor]];
        [_activityView addSubview:_retryButton];
        
        // 菊花
        _activtiy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activtiy.backgroundColor = [UIColor clearColor];
        [_activityView addSubview:_activtiy];
    }
    
    _bubbleView = [self bubbleViewForMessageModel:messageModel];
    [self.contentView addSubview:_bubbleView];
    
    type = [[messageModel.message.ext objectForKey:@"type"] intValue];
    if (!messageModel.isSender && type != 0) {
        jumpBtn = [MyControl createButtonWithFrame:CGRectMake(_bubbleView.frame.origin.x+_bubbleView.frame.size.width+5, _bubbleView.frame.origin.y, 38, 38) ImageName:@"talkArrow.png" Target:self Action:@selector(arrowClick) Title:nil];
        [self.contentView addSubview:jumpBtn];
    }
}
-(void)arrowClick
{
    NSLog(@"arrow");
    self.jumpClick(type);
}
- (EMChatBaseBubbleView *)bubbleViewForMessageModel:(MessageModel *)messageModel
{
    switch (messageModel.type) {
        case eMessageBodyType_Text:
        {
            return [[EMChatTextBubbleView alloc] init];
        }
            break;
        case eMessageBodyType_Image:
        {
            return [[EMChatImageBubbleView alloc] init];
        }
            break;
        case eMessageBodyType_Voice:
        {
            return [[EMChatAudioBubbleView alloc] init];
        }
            break;
        case eMessageBodyType_Location:
        {
            return [[EMChatLocationBubbleView alloc] init];
        }
            break;
        case eMessageBodyType_Video:
        {
            return [[EMChatVideoBubbleView alloc] init];
        }
            break;
        default:
            break;
    }
    
    return nil;
}

+ (CGFloat)bubbleViewHeightForMessageModel:(MessageModel *)messageModel
{
    switch (messageModel.type) {
        case eMessageBodyType_Text:
        {
            return [EMChatTextBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Image:
        {
            return [EMChatImageBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Voice:
        {
            return [EMChatAudioBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Location:
        {
            return [EMChatLocationBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Video:
        {
            return [EMChatVideoBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        default:
            break;
    }
    
    return HEAD_SIZE;
}

#pragma mark - public

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model
{
    NSInteger bubbleHeight = [self bubbleViewHeightForMessageModel:model];
    NSInteger headHeight = HEAD_PADDING * 2 + HEAD_SIZE;
    if (model.isChatGroup && !model.isSender) {
        headHeight += NAME_LABEL_HEIGHT;
    }
    return MAX(headHeight, bubbleHeight) + CELLPADDING;
}


@end
