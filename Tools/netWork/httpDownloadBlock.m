
//
//  httpDownloadBlock.m
//
//  Created by ZhangCheng on 13-8-28.
//  Copyright (c) 2013年 zhangcheng. All rights reserved.
//

#import "httpDownloadBlock.h"
#import "MyMD5.h"
#import "NSFileManager+Mothod.h"
#import "MMProgressHUD.h"

@implementation httpDownloadBlock



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
    
//    NSFileManager*fileManager=[NSFileManager defaultManager];
    //fileExistsAtPath 判断是否有这个文件或文件夹
//    if ([fileManager fileExistsAtPath:self.FileName]&&[fileManager timeOutWithPath:self.FileName time:60*60]) {
//        //文件没有超时 原来保存的数据可用
//        //读取本地保存数据源
//        self.data=[NSData dataWithContentsOfFile:self.FileName];
//        
//        //解析 调用完成的方法
//
//        [self jsonFinishLoading];
//    }else{
    NSURL * url = [NSURL URLWithString:urlStr];
    [self addSkipBackupAttributeToItemAtURL:url];
//    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    
    self.connection=[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    
    if (timer == NULL) {
        timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(cancelConnection:) userInfo:nil repeats:NO];
        [timer retain];
    }
//    }
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
//    [MMProgressHUD showWithStatus:@"加载中..."];
    
}
-(void)cancelConnection:(NSTimer *)timerP
{
    [self.connection cancel];
    self.httpRequestBlock(NO,self);
    [timer invalidate];
}
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    
//    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    
    return success;
}
#pragma mark 4个代理方法
//接收到了服务器给出回应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{    
//    [self.alert setTitle:@"服务器已回应，正在下载数据"];
//    self.alert = [[UIAlertView alloc] initWithTitle:@"服务器已回应，正在下载数据" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [self.alert show];
    [self.data setLength:0];
    

}
//服务器返回数据 多次调用
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    [self.alert setTitle:[NSString stringWithFormat:@"接收服务器信息次数：%d", count++]];
    [self.data appendData:data];
}
//完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    [self.alert setTitle:@"数据下载完成"];
    [self jsonFinishLoading];
//    [MMProgressHUD dismissWithSuccess:@"加载完成" title:nil afterDelay:0.5];
    
}
-(void)jsonFinishLoading{
    [timer invalidate];
    
    //成功后进行解析 无论是否是图片，都进行解析
    //如果是图片，返回nil，即解析失败 这样写会略微影响效率
//    [self.alert setTitle:@"正在解析数据"];
    id result=[NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"result:%@",result);
    //判断解析后是数组，赋值给self.dataArray
    //判断解析后是字典，赋值给self.dataDict
    if ([result isKindOfClass:[NSArray class]]) {
        self.dataArray=result;
    }else{
        //如果不是数组
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.dataDict=result;
            
            //判断errorCode是否为1，为1弹窗提示
//            if([[self.dataDict objectForKey:@"errorCode"] intValue] == -1){
//                if ([[self.dataDict objectForKey:@"errorMessage"] isEqualToString:@"余额不足"]) {
//                    [ControllerManager HUDText:@"余额不足(⊙o⊙)哦~~" showView:[[UIApplication sharedApplication]keyWindow] yOffset:-50];
//                    [MyControl loadingFailedWithContent:@"购买失败" afterDelay:0.5f];
//                    return;
//                }
//                if ([[self.dataDict objectForKey:@"errorMessage"] isEqualToString:@"音频文件不存在"]) {
////                    StartLoading;
//                    
//                    self.httpRequestBlock(NO,self);
//                    return;
//                }
//                if ([[self.dataDict objectForKey:@"errorMessage"] length]>100) {
//                        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"错误" Message:@"网络错误" delegate:nil cancelTitle:nil otherTitles:@"确定"];
//                }else{
//                    if(![[self.dataDict objectForKey:@"errorMessage"] isEqualToString:@"你今天已经摸过啦！"]){
//                        UIAlertView * alert = [MyControl createAlertViewWithTitle:@"错误" Message:[self.dataDict objectForKey:@"errorMessage"] delegate:nil cancelTitle:nil otherTitles:@"确定"];
//                    }
//                }
//                
////                StartLoading;
////                [MyControl loadingFailedWithContent:@"网络错误" afterDelay:1.0f];
//                NSLog(@"%@", [self.dataDict objectForKey:@"errorMessage"]);
//                self.httpRequestBlock(NO,self);
//                return;
//            }
            
            NSString * msg = nil;
            
            
            if ([[self.dataDict objectForKey:@"state"] intValue] == 1) {
                //state=1时直接返回errorMessage
                msg = [self.dataDict objectForKey:@"errorMessage"];
                NSLog(@"%@", msg);
//                self.httpRequestBlock(NO,self);
//                return;
            }
            if ([[self.dataDict objectForKey:@"state"] intValue] == 2) {
                //SID过期 login
                msg = @"网络异常，请重新操作";
                [self login];
                self.httpRequestBlock(NO,self);
                return;
            }

            if ([[self.dataDict objectForKey:@"state"] intValue] == 3) {
                //未注册
                self.httpRequestBlock(NO,self);
                return;
            }
            /****************************/
            if ([[self.dataDict objectForKey:@"state"] intValue] == 1) {
                UIView * keyView = [UIApplication sharedApplication].keyWindow;
                [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:msg];
//                PopupView * pop = [[PopupView alloc] init];
//                [pop modifyUIWithSize:keyView.frame.size msg:msg];
//                [keyView addSubview:pop];
//                [pop release];
//                
//                [UIView animateWithDuration:0.2 animations:^{
//                    pop.bgView.alpha = 1;
//                } completion:^(BOOL finished) {
//                    [UIView animateKeyframesWithDuration:0.2 delay:2 options:0 animations:^{
//                        pop.bgView.alpha = 0;
//                    } completion:^(BOOL finished) {
//                        [pop removeFromSuperview];
//                    }];
//                }];
                
                self.httpRequestBlock(NO,self);
                return;
            }
            /****************************/
            if ([[self.dataDict objectForKey:@"version"] isKindOfClass:[NSString class]]) {
                [USER setObject:[self.dataDict objectForKey:@"version"] forKey:@"version"];
                [USER setObject:[self.dataDict objectForKey:@"confVersion"] forKey:@"confVersion"];
            }
            
//            NSLog(@"self.dataDict = %@",self.dataDict);
        }else{
            
            //如果不是字典，那就是图片
            self.dataImage=[UIImage imageWithData:self.data];
        }
        
    }
    //数据保存 下次请求时候判断可否在次使用
//    [self.data writeToFile:self.FileName atomically:YES];

    self.httpRequestBlock(YES,self);
}
//失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    [MMProgressHUD dismissWithError:@"加载失败" afterDelay:0.5];
//    [self.alert setTitle:@"服务器响应失败"];
    [self.connection cancel];
//    self.httpRequestBlock(NO,self);
    [timer invalidate];
    self.httpRequestBlock(NO,self);
}

-(id)initWithUrlStr:(NSString*)str Block:(void(^)(BOOL,httpDownloadBlock*))a{
    if (self=[super init]) {
        
        self.httpRequestBlock=a;
        [self httpRequest:str];
    }
    
    return self;
}

#pragma mark - login
-(void)login
{
    LOADING;
    NSString * code = [NSString stringWithFormat:@"uid=%@dog&cat", UDID];
    NSString * url = [NSString stringWithFormat:@"%@&uid=%@&sig=%@", LOGINAPI, UDID, [MyMD5 md5:code]];
    NSLog(@"login-url:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            NSLog(@"%@", load.dataDict);
            [ControllerManager setIsSuccess:[[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]];
            [ControllerManager setSID:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"]];
            [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] forKey:@"isSuccess"];
            [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"] forKey:@"SID"];
            ENDLOADING;
//            self.overDue();
            NSLog(@"============SID过期============");
            //检查更新
            [self checkUpdateOutVer:[load.dataDict objectForKey:@"version"] InsideVer:[[load.dataDict objectForKey:@"data"] objectForKey:@"version"]];
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}

-(void)checkUpdateOutVer:(NSString *)outVer InsideVer:(NSString *)insideVer
{
    /*
     本地保存version作为参考对象，如果login里的外层version与本地不同就是
     强制更新，如果是里层的不同就不强制，安排取消按钮，取消后不做任何操作。
     */
    int type1 = 0;
    int type2 = 0;
    if (![outVer isEqualToString:[USER objectForKey:@"version"]]) {
        //强制更新
        type1 = 1;
        isForce = YES;
    }
    if (![insideVer isEqualToString:[USER objectForKey:@"version"]]) {
        type2 = 1;
    }
    if (type1 == 1 || type2 == 1) {
        NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"version=%@dog&cat", [USER objectForKey:@"version"]]];
        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", UPDATEAPI, [USER objectForKey:@"version"], sig, [ControllerManager getSID]];
        NSLog(@"%@", url);
        httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                self.ios_url = [[load.dataDict objectForKey:@"data"] objectForKey:@"ios_url"];
                NSString * msg = [[load.dataDict objectForKey:@"data"] objectForKey:@"upgrade_content"];
                
                NSString * msg2 = [msg stringByReplacingOccurrencesOfString:@"&" withString:@"\n"];
                if(type1 == 1){
                    //强制
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:msg2 delegate:self cancelButtonTitle:nil otherButtonTitles:@"马上更新", nil];
                    [alert show];
                    [alert release];
                }else{
                    //非强制更新
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:msg2 delegate:self cancelButtonTitle:@"稍后更新" otherButtonTitles:@"马上更新", nil];
                    [alert show];
                    [alert release];
                }
            }else{
                StartLoading;
                LoadingFailed;
            }
        }];
        [request release];
    }
}
#pragma mark - delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d", buttonIndex);
    if(isForce){
        if (buttonIndex == 0) {
            //马上更新
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.ios_url]];
        }
    }else{
        if (buttonIndex == 0) {
            //稍后更新
            
        }else{
            //马上更新
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.ios_url]];
        }
    }
}
@end
