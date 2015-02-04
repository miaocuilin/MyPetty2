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

#import "ChatSendHelper.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "IChatImageOptions.h"
#import "EMCommandMessageBody.h"
#import "EMChatText.h"
#import "EMTextMessageBody.h"
#import "EMChatImage.h"
#import "EMImageMessageBody.h"
#import "EMVoiceMessageBody.h"
#import "EMVideoMessageBody.h"
#import "EMLocationMessageBody.h"
#import "EMChatLocation.h"
#import "EaseMob.h"

@interface ChatImageOptions : NSObject<IChatImageOptions>

@property (assign, nonatomic) CGFloat compressionQuality;

@end

@implementation ChatImageOptions

@end

@implementation ChatSendHelper

+(EMMessage *)sendTextMessageWithString:(NSString *)str
                             toUsername:(NSString *)username
                            isChatGroup:(BOOL)isChatGroup
                      requireEncryption:(BOOL)requireEncryption nickName:(NSString *)nickName tx:(NSString *)tx other_nickName:(NSString *)other_nickName other_tx:(NSString *)other_tx
{
    // 表情映射。
    NSString *willSendText = [ConvertToCommonEmoticonsHelper convertToCommonEmoticons:str];
    EMChatText *text = [[EMChatText alloc] initWithText:willSendText];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption nickName:nickName tx:tx other_nickName:other_nickName other_tx:other_tx];
}

+(EMMessage *)sendImageMessageWithImage:(UIImage *)image
                             toUsername:(NSString *)username
                            isChatGroup:(BOOL)isChatGroup
                      requireEncryption:(BOOL)requireEncryption nickName:(NSString *)nickName tx:(NSString *)tx other_nickName:(NSString *)other_nickName other_tx:(NSString *)other_tx
{
    EMChatImage *chatImage = [[EMChatImage alloc] initWithUIImage:image displayName:@"image.jpg"];
    id <IChatImageOptions> options = [[ChatImageOptions alloc] init];
    [options setCompressionQuality:0.6];
    [chatImage setImageOptions:options];
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithImage:chatImage thumbnailImage:nil];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption nickName:nickName tx:tx other_nickName:other_nickName other_tx:other_tx];
}

+(EMMessage *)sendVoice:(EMChatVoice *)voice
             toUsername:(NSString *)username
            isChatGroup:(BOOL)isChatGroup
      requireEncryption:(BOOL)requireEncryption nickName:(NSString *)nickName tx:(NSString *)tx other_nickName:(NSString *)other_nickName other_tx:(NSString *)other_tx
{
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption nickName:nickName tx:tx other_nickName:other_nickName other_tx:other_tx];
}

+(EMMessage *)sendVideo:(EMChatVideo *)video
             toUsername:(NSString *)username
            isChatGroup:(BOOL)isChatGroup
      requireEncryption:(BOOL)requireEncryption nickName:(NSString *)nickName tx:(NSString *)tx other_nickName:(NSString *)other_nickName other_tx:(NSString *)other_tx
{
    EMVideoMessageBody *body = [[EMVideoMessageBody alloc] initWithChatObject:video];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption nickName:nickName tx:tx other_nickName:other_nickName other_tx:other_tx];
}

+(EMMessage *)sendLocationLatitude:(double)latitude
                         longitude:(double)longitude
                           address:(NSString *)address
                        toUsername:(NSString *)username
                       isChatGroup:(BOOL)isChatGroup
                 requireEncryption:(BOOL)requireEncryption nickName:(NSString *)nickName tx:(NSString *)tx other_nickName:(NSString *)other_nickName other_tx:(NSString *)other_tx
{
    EMChatLocation *chatLocation = [[EMChatLocation alloc] initWithLatitude:latitude longitude:longitude address:address];
    EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithChatObject:chatLocation];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption nickName:nickName tx:tx other_nickName:other_nickName other_tx:other_tx];
}

// 发送消息
+(EMMessage *)sendMessage:(NSString *)username
              messageBody:(id<IEMMessageBody>)body
              isChatGroup:(BOOL)isChatGroup
        requireEncryption:(BOOL)requireEncryption nickName:(NSString *)nickName tx:(NSString *)tx other_nickName:(NSString *)other_nickName other_tx:(NSString *)other_tx
{
    EMMessage *returnMsg = [[EMMessage alloc] initWithReceiver:username bodies:[NSArray arrayWithObject:body]];
    returnMsg.requireEncryption = requireEncryption;
    returnMsg.isGroup = isChatGroup;
//    NSLog(@"%@--%@--%@--%@--%@", nickName, tx, other_nickName, other_tx, [USER objectForKey:@"usr_id"]);
    if (![other_tx isKindOfClass:[NSString class]]) {
        other_tx = @"";
    }
    if (![tx isKindOfClass:[NSString class]]) {
        tx = @"";
    }
    returnMsg.ext = @{@"nickname":nickName, @"tx":tx, @"other_nickname":other_nickName, @"other_tx":other_tx, @"id":[USER objectForKey:@"usr_id"]};
    
    [MobClick event:@"message"];
//    , @"type":@"3", @"img_id":@"3475", @"nickname":@"毛大师"
//    , @"type":@"2", @"img_id":@"3350"
//    NSLog(@"%@", retureMsg.ext);
    EMMessage *message = [[EaseMob sharedInstance].chatManager asyncSendMessage:returnMsg progress:nil];
    
//    EMChatText *text = [[EMChatText alloc] initWithText:@"1111111"];
//    EMTextMessageBody *textbody = [[EMTextMessageBody alloc] initWithChatObject:text];
//    EMMessage *message = [[EMMessage alloc] initWithReceiver:@"zxcvbn" bodies:[NSArray arrayWithObject:textbody]];
//    NSMutableDictionary *extDic = [NSMutableDictionary dictionary];
//    [extDic setObject:@"header" forKey:@"xieyajie header"];
//    
//    message.ext = extDic;
//    message.requireEncryption = NO;
//    message.isGroup = NO;
//    message.messageId = @"xieyajie";
//    message.timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
//    message.from = @"asdfgh";
//    message.deliveryState = eMessageDeliveryState_Delivered;
//    BOOL ret = [[EaseMob sharedInstance].chatManager insertMessageToDB:message append2Chat:YES];
    
//    EMChatCommand *cmd = [[EMChatCommand alloc] init];
//    EMCommandMessageBody *mbody = [[EMCommandMessageBody alloc] initWithChatObject:cmd];
//    EMMessage *msg = [[EMMessage alloc] initWithReceiver:username bodies:@[mbody]];
//    EMMessage *message = [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:nil];
    
    return message;
}

@end
