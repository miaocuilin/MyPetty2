
//
//  NSFileManager+Mothod.m
//
//  Created by ZhangCheng on 13-3-28.
//  Copyright (c) 2013年 zhangcheng. All rights reserved.
//

#import "NSFileManager+Mothod.h"

@implementation NSFileManager (Mothod)
-(BOOL)timeOutWithPath:(NSString *)Path time:(NSTimeInterval)time
{
    //获得文件详细信息
    NSDictionary*info=[[NSFileManager defaultManager] attributesOfItemAtPath:Path error:nil];

    //获取文件创建时间
    NSDate*createDate=[info objectForKey:NSFileCreationDate];
    
    //获取当前时间
    NSDate*date=[NSDate date];
    
    //获得时间差 2个时间进行对比
    NSTimeInterval temp=[date timeIntervalSinceDate:createDate];
    //time是失效的范围~60*60
    if (temp>time) {
        //超过时效
        return NO;
    }else{
        return YES;
    }

}

//清空缓存
-(void)clearCache{
    NSFileManager*manager=[NSFileManager defaultManager];
    
    //获得文件夹下的所有文件
    NSError*error;
   NSArray*array= [manager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/documents",NSHomeDirectory()] error:&error];
    NSLog(@"获得的文件名~~%@",array);
    
    
    //1直接遍历
//    for (NSString*str in array) {
//        [manager removeItemAtPath:[NSString stringWithFormat:@"%@/documents/%@",NSHomeDirectory(),str] error:nil];
//    }
    
    
    //2获得枚举
    //数组转换成枚举
    NSEnumerator*enumerator=[array objectEnumerator];
    NSString*fileName;
    while (fileName=[enumerator nextObject]) {
        
        NSLog(@"%@",fileName);
        
        //每一次while循环时候都会被重新赋值
        //拼接前缀地址后进行删除
        [manager removeItemAtPath:[NSString stringWithFormat:@"%@/documents/%@",NSHomeDirectory(),fileName] error:nil];
        
    }

}






@end
