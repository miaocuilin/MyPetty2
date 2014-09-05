//
//  HttpRequest.h
//  MyPetty
//
//  Created by zhangjr on 14-9-5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject

+(id)upload:(NSString *)url widthParams:(NSDictionary *)params;

@end

@interface FileDetail : NSObject

@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSData *data;
+(FileDetail *)fileWithName:(NSString *)name data:(NSData *)data;
@end
