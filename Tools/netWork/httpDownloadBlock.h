//
//  httpDownloadBlock.h
//
//  Created by ZhangCheng on 13-8-28.
//  Copyright (c) 2013年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface httpDownloadBlock : NSObject<NSURLConnectionDataDelegate>
{
    int count;
}
//创建属性NSMuTableData  以及NSURLConnection
//保存发起的请求指针  为什么？需要在取消时候使用
@property(nonatomic,retain)NSURLConnection*connection;
//保存下载的数据
@property(nonatomic,retain)NSMutableData*data;
//保存缓存文件的路径，在数据下载完成后，按照这个路径进行写入
@property(nonatomic,copy)NSString*FileName;


//解析结果保存
@property(nonatomic,retain)NSArray*dataArray;
@property(nonatomic,retain)NSDictionary*dataDict;
@property(nonatomic,retain)UIImage*dataImage;

//block调用 不需要协议 不需要代理 copy
@property(nonatomic,copy)void(^httpRequestBlock)(BOOL,httpDownloadBlock*);
-(id)initWithUrlStr:(NSString*)str Block:(void(^)(BOOL,httpDownloadBlock*))a;

@end
