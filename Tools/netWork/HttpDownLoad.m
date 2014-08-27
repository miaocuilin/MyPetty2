//
//  HttpDownLoad.m
//
//  Created by ZhangCheng on 13-3-27.
//  Copyright (c) 2013年 zhangcheng. All rights reserved.
//

#import "HttpDownLoad.h"
#import "NSFileManager+Mothod.h"
#import "MyMD5.h"
@implementation HttpDownLoad
-(id)initWithUrlStr:(NSString*)urlStr setDelegate:(id)target
{   //进行初始化
    
    if (self=[super init]) {
        self.delegate=target;
        [self httpRequest:urlStr];
    }
    return self;
}


-(void)httpRequest:(NSString*)urlStr{
    self.data=[NSMutableData dataWithCapacity:0];
    
    //需要判断文件存在、失效
    //程序里面文件保存，文件名需要进行加密处理
    //登录注册 在PC时代默认是MD5加密
    //其他加密方式 sha-1   sha-4   RCS4
    /********/
    //交通局加密方式 sha-4+RCS4+MD5 动态加密
    //百度的推送加密方式  使用的是http请求连接+appkey 整体进行MD5加密
    /********/
    
    //urlStr 字符串，对字符串进行加密处理，把机密后的字符串作为文件名
    
    self.FileName=[NSString stringWithFormat:@"%@/documents/%@",NSHomeDirectory(),[MyMD5 md5:urlStr]];
    NSLog(@"filePath:%@", self.FileName);
    NSFileManager*fileManager=[NSFileManager defaultManager];
    //fileExistsAtPath 判断是否有这个文件或文件夹
    if ([fileManager fileExistsAtPath:self.FileName]&&[fileManager timeOutWithPath:self.FileName time:60*60]) {
        //文件没有超时 原来保存的数据可用
        //读取本地保存数据源
        self.data=[NSData dataWithContentsOfFile:self.FileName];
        //解析 调用完成的方法
       // [self connectionDidFinishLoading:nil];
        [self jsonFinishLoading];
    }else{
        self.connection=[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] delegate:self];
    }
    
    
    
    

}
#pragma mark 4个代理方法
//接收到了服务器给出回应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //2种方式都可以
    //self.data=[NSMutableData dataWithCapacity:0];
    [self.data setLength:0];
    
}
//服务器返回数据 多次调用
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}
//完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self jsonFinishLoading];
    
}
-(void)jsonFinishLoading{
    //成功后进行解析 无论是否是图片，都进行解析
    //如果是图片，返回nil，即解析失败 这样写会略微影响效率
    id result=[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
    //判断解析后是数组，赋值给self.dataArray
    //判断解析后是字典，赋值给self.dataDict
    if ([result isKindOfClass:[NSArray class]]) {
        self.dataArray=result;
    }else{
        //如果不是数组
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.dataDict=result;
        }else{
            
            //如果不是字典，那就是图片
            self.dataImage=[UIImage imageWithData:self.data];
        }
        
    }
    
    //数据保存 下次请求时候判断可否在次使用
    [self.data writeToFile:self.FileName atomically:YES];
    
    //如果不是这2种类型，直接忽略
    if ([self.delegate respondsToSelector:@selector(httpRequestFinishorFail:isFinish:)]) {
        [self.delegate httpRequestFinishorFail:self isFinish:YES];
    }

}
//失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(httpRequestFinishorFail:isFinish:)]) {
        [self.delegate httpRequestFinishorFail:self isFinish:NO];
    }
}








@end
