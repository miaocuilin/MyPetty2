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
    UIButton     *_timeBtn;
    UIImageView *_iconView;
    UIButton    *_contentBtn;
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
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];

        
        // 3、创建内容
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //修改字体颜色
        [_contentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        _contentBtn.titleLabel.font = kContentFont;
        _contentBtn.titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_contentBtn];
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
//    _messageFrame.showTime = YES;
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
        _iconView.image = [UIImage imageNamed:@"defaultUserHead.png"];
    }else{
        if ([message.icon intValue] == 1) {
            _iconView.image = [UIImage imageNamed:@"wangwang.png"];
        }else if([message.icon intValue] == 2){
            _iconView.image = [UIImage imageNamed:@"miaomiao.png"];
        }else if([message.icon intValue] == 3){
            _iconView.image = [UIImage imageNamed:@"xiaoge.png"];
        }else{
            NSString * docDir = DOCDIR;
            NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", message.icon]];
            UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
            if (image) {
                _iconView.image = image;
            }else{
                //下载头像
                httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", PETTXURL, message.icon] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                    if (isFinish) {
                        _iconView.image = load.dataImage;
                        NSString * docDir = DOCDIR;
                        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", message.icon]];
                        [load.data writeToFile:txFilePath atomically:YES];
                    }else{
                        NSLog(@"头像下载失败");
                    }
                }];
                [request release];
            }
        }
        
    }
    _iconView.frame = _messageFrame.iconF;
    //将头像削成圆形
    _iconView.layer.cornerRadius = _iconView.frame.size.width/2;
    _iconView.layer.masksToBounds = YES;
    
    // 3、设置内容
    [_contentBtn setTitle:message.content forState:UIControlStateNormal];
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
    _contentBtn.frame = _messageFrame.contentF;
    
    if (message.type == MessageTypeMe) {
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
    }
    
    UIImage *normal , *focused;
    if (message.type == MessageTypeMe) {
    
        normal = [UIImage imageNamed:@"talkRight.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatto_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
    }else{
        
        normal = [UIImage imageNamed:@"talkLeft.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatfrom_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
        
    }
    [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [_contentBtn setBackgroundImage:focused forState:UIControlStateHighlighted];
    
}

@end
