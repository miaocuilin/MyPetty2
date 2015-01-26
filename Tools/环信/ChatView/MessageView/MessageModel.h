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

#import <Foundation/Foundation.h>
//#import "MessageBodyType.h"
//#import "MessageDeliveryState.h"
#import "EMChatVoice.h"
#import "IEMMessageBody.h"
#import "EMMessage.h"

#define KFIRETIME 20

@interface MessageModel : NSObject
{
    BOOL _isPlaying;
}

@property (nonatomic) MessageBodyType type;
@property (nonatomic) MessageDeliveryState status;
/*
 isSender的判断标准是说对于当前用户来说，该条信息是不是我发的,
 如果不是我发的isSender=NO,如果是我发的isSender=YES.
 */
@property (nonatomic) BOOL isSender;    //是否是发送者
@property (nonatomic) BOOL isRead;      //是否已读
@property (nonatomic) BOOL isChatGroup;  //是否是群聊

@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSURL *headImageURL;
@property (nonatomic, strong) NSString *nickName;
//@property (nonatomic, strong) NSString *tx;
//@property (nonatomic, strong) NSString *other_nickName;
//@property (nonatomic, strong) NSString *other_tx;
@property (nonatomic, strong) NSString *username;

//text
@property (nonatomic, strong) NSString *content;

//image
@property (nonatomic) CGSize size;
@property (nonatomic) CGSize thumbnailSize;
@property (nonatomic, strong) NSURL *imageRemoteURL;
@property (nonatomic, strong) NSURL *thumbnailRemoteURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *thumbnailImage;

//audio
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, strong) NSString *remotePath;
@property (nonatomic) NSInteger time;
@property (nonatomic, strong) EMChatVoice *chatVoice;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) BOOL isPlayed;

//location
@property (nonatomic, strong) NSString *address;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@property (nonatomic, strong)id<IEMMessageBody> messageBody;
@property (nonatomic, strong)EMMessage *message;

@end
