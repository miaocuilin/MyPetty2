//
//  NSFileManager+Mothod.h
//
//  Created by ZhangCheng on 13-3-28.
//  Copyright (c) 2013年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Mothod)
//处理文件缓存 缓存需要有时间限制
//设置一个时间，判断是否超过这个时间的限制
//用于判断文件是否在设置的时间范围内

//第一个参数是文件的路径 第二个参数是文件失效的时间 60*60  1小时
-(BOOL)timeOutWithPath:(NSString*)Path time:(NSTimeInterval)time;

//清空缓存
-(void)clearCache;

//计算文件大小  如果遍历计算 可以获得总体缓存大小
-(long long)getMyCacheFileSize;






@end






