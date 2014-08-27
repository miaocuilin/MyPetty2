//
//  HttpDownLoad.h
//
//  Created by ZhangCheng on 13-3-27.
//  Copyright (c) 2013年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
//协议
@class HttpDownLoad;
@protocol HttpDownloadDelegate <NSObject>
//第一个参数是传递本类的指针
//第二个参数是传递是否请求成功
-(void)httpRequestFinishorFail:(HttpDownLoad*)requset isFinish:(BOOL)isFinish;

@end

@interface HttpDownLoad : NSObject<NSURLConnectionDataDelegate>
//创建属性NSMuTableData  以及NSURLConnection
//保存发起的请求指针  为什么？需要在取消时候使用
@property(nonatomic,retain)NSURLConnection*connection;
//保存下载的数据
@property(nonatomic,retain)NSMutableData*data;
//设置协议的代理
@property(nonatomic,assign)id<HttpDownloadDelegate>delegate;

//保存缓存文件的路径，在数据下载完成后，按照这个路径进行写入
@property(nonatomic,copy)NSString*FileName;

//我们初始化这个类以后进行传递参数 参数是地址
-(id)initWithUrlStr:(NSString*)urlStr setDelegate:(id)target;


//解析结果保存
@property(nonatomic,retain)NSArray*dataArray;
@property(nonatomic,retain)NSDictionary*dataDict;
@property(nonatomic,retain)UIImage*dataImage;
@end
