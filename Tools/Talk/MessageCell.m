//
//  MessageCell.m
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"
#import "MessageFrame.h"

@interface MessageCell ()
{
    UIButton * _timeBtn;
    UIButton * _iconView;
    UIButton * _contentBtn;
    UIButton * _arrowBtn;
}

@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
#pragma mark - warning 必须先设置为clearColor，否则tableView的背景会被遮住
        self.backgroundColor = [UIColor clearColor];
        
        // 1、创建时间按钮
        _timeBtn = [[UIButton alloc] init];
        [_timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = kTimeFont;
        _timeBtn.enabled = NO;
        _timeBtn.backgroundColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1];
        _timeBtn.layer.cornerRadius = 10;
        _timeBtn.layer.masksToBounds = YES;
//        [_timeBtn setBackgroundImage:[UIImage imageNamed:@"chat_timeline_bg.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_timeBtn];
        
        
        // 2、创建头像
//        _iconView = [[UIImageView alloc] init];
        _iconView = [MyControl createButtonWithFrame:CGRectZero ImageName:@"" Target:self Action:@selector(headBtnClick) Title:nil];
        [self.contentView addSubview:_iconView];

        
        // 3、创建内容
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //修改字体颜色
        [_contentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        _contentBtn.titleLabel.font = kContentFont;
        _contentBtn.titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_contentBtn];
        
        //4、创建箭头
        _arrowBtn = [MyControl createButtonWithFrame:CGRectMake(10, 10, 1, 1) ImageName:@"talkArrow.png" Target:self Action:@selector(arrowBtnClick) Title:nil];
        _arrowBtn.showsTouchWhenHighlighted = YES;
//        _arrowBtn.userInteractionEnabled = YES;
//        _arrowBtn.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_arrowBtn];
    }
    return self;
}

- (void)setMessageFrame:(MessageFrame *)messageFrame{
    
//    [_messageFrame setMessage:messageFrame.message];
    _messageFrame = messageFrame;
    [_messageFrame setMessage:messageFrame.message];
//    Message * message = _messageFrame.message;
    
    Message * message = _messageFrame.message;
//    Message * message = [[Message alloc] init];
//    message set
    
    // 1、设置时间
    
    [_timeBtn setTitle:message.time forState:UIControlStateNormal];
//    NSLog(@"===============================%@", message.time);
    _messageFrame.showTime = YES;
    _timeBtn.frame = _messageFrame.timeF;
//    [_timeBtn setBackgroundImage:[[UIImage imageNamed:@"chat_timeline_bg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:0] forState:UIControlStateNormal];
//    if (messageFrame.showTime) {
//        _timeBtn.hidden = NO;
//    }else
//    {
//        _timeBtn.hidden = YES;
//    }
    
    
    // 2、设置头像
//    _iconView.image = [UIImage imageNamed:message.icon];
    if ([message.icon isKindOfClass:[NSNull class]] || message.icon.length==0) {
        [_iconView setBackgroundImage:[UIImage imageNamed:@"defaultUserHead.png"] forState:UIControlStateNormal];
//        _iconView.image = [UIImage imageNamed:@"defaultUserHead.png"];
    }else{
        if ([message.icon intValue] == 1) {
            [_iconView setBackgroundImage:[UIImage imageNamed:@"wangwang.png"] forState:UIControlStateNormal];
//            _iconView.image = [UIImage imageNamed:@"wangwang.png"];
        }else if([message.icon intValue] == 2){
            [_iconView setBackgroundImage:[UIImage imageNamed:@"miaomiao.png"] forState:UIControlStateNormal];
//            _iconView.image = [UIImage imageNamed:@"miaomiao.png"];
        }else if([message.icon intValue] == 3){
            [_iconView setBackgroundImage:[UIImage imageNamed:@"xiaoge.png"] forState:UIControlStateNormal];
//            _iconView.image = [UIImage imageNamed:@"xiaoge.png"];
        }else{
            NSString * docDir = DOCDIR;
            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", message.icon]];
            UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
            if (image) {
                [_iconView setBackgroundImage:image forState:UIControlStateNormal];
            }else{
                //下载头像
                [_iconView setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL, message.icon]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultUserHead.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    if (image) {
                        [_iconView setBackgroundImage:[MyControl returnSquareImageWithImage:image] forState:UIControlStateNormal];
                    }
                }];
//                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, message.icon] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//                    if (isFinish) {
//                        [_iconView setBackgroundImage:load.dataImage forState:UIControlStateNormal];
//                        NSString * docDir = DOCDIR;
//                        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", message.icon]];
//                        [load.data writeToFile:txFilePath atomically:YES];
//                    }else{
//                        NSLog(@"头像下载失败");
//                    }
//                }];
//                [request release];
            }
        }
        
    }
    _iconView.frame = _messageFrame.iconF;
    //将头像削成圆形
    _iconView.layer.cornerRadius = _iconView.frame.size.width/2;
    _iconView.layer.masksToBounds = YES;
    
    // 3、设置内容
//    NSLog(@"%@", message.content);
    if ([message.content rangeOfString:@"[address]"].location != NSNotFound) {
        message.content = [[message.content componentsSeparatedByString:@"[address]"] objectAtIndex:1];
//        NSLog(@"%@", message.content);
        self.hasArrow = YES;
        self.hasAddress = YES;
    }else{
        self.hasAddress = NO;
    }
    [_contentBtn setTitle:message.content forState:UIControlStateNormal];
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
    _contentBtn.frame = _messageFrame.contentF;
    
    if (message.type == MessageTypeMe) {
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
    }
    
    UIImage * normal;
//    UIImage *normal , *focused;
    if (message.type == MessageTypeMe) {
    
        normal = [UIImage imageNamed:@"talkRight.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
//        focused = [UIImage imageNamed:@"chatto_bg_focused.png"];
//        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
    }else{
        
        normal = [UIImage imageNamed:@"talkLeft.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
//        focused = [UIImage imageNamed:@"chatfrom_bg_focused.png"];
//        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
        
    }
    [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
//    [_contentBtn setBackgroundImage:focused forState:UIControlStateHighlighted];
    
    //4.箭头
    if (!self.hasArrow) {
        _arrowBtn.hidden = YES;
    }else{
        _arrowBtn.hidden = NO;
        [_arrowBtn setFrame:CGRectMake(_contentBtn.frame.origin.x+_contentBtn.frame.size.width, _contentBtn.frame.origin.y+_contentBtn.frame.size.height/2-12, 24, 24)];
//        _arrowBtn.frame = CGRectMake(_contentBtn.frame.origin.x+_contentBtn.frame.size.width, _contentBtn.frame.origin.y+_contentBtn.frame.size.height/2-12, 24, 24);
    }
    
}

-(void)arrowBtnClick
{
    NSLog(@"jumpToDetail");
    if (self.hasAddress) {
        self.jumpToAddress();
    }else{
        self.jumpToPicDetail();
    }
    
}
-(void)headBtnClick
{
    NSLog(@"jumpToUser");
    self.jumpToUserInfo();
}
@end
