//
//  FirstViewController.m
//  MyPetty
//
//  Created by Aidi on 14-5-30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "FirstViewController.h"
#import "ControllerManager.h"
#import "ASIFormDataRequest.h"
#import "ChoseLoadViewController.h"
@interface FirstViewController () <UIAlertViewDelegate>
{
  ASIFormDataRequest * _request;
}
@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self downloadLaunchImageInfo];
    
    
    [UIApplication sharedApplication].statusBarHidden = YES;
}
-(void)downloadLaunchImageInfo
{
    NSString * url = [NSString stringWithFormat:@"%@%@", WELCOMEAPI, [ControllerManager getSID]];
    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            self.launchImageName = [[load.dataDict objectForKey:@"data"] objectForKey:@"url"];
            NSString * docDir = DOCDIR;
            NSString * FilePath = [docDir stringByAppendingPathComponent:self.launchImageName];
            UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:FilePath]];
            if (image) {
                self.launchImage = image;
                hadImage = YES;
//                [self login];
            }else{
                hadImage = NO;
//                [self login];
            }
            [self createUI];
        }else{
            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"图片信息加载失败"];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
//    NSLog(@"%f", self.view.frame.size.height);
    
    //全局变量，存储在本地，用于判断各种条件，以做出相应操作
    [USER setObject:@"0" forKey:@"MyHomeTimes"];
    /*关注是否有变化*/
    [USER setObject:@"0" forKey:@"AttentionOrFansChanged"];
    //设置favorite是否进入过
    [USER setObject:@"0" forKey:@"isFavoriteLoaded"];
    //isFromActivity归零
    [USER setObject:@"0" forKey:@"isFromActivity"];
    //favorite页是否需要刷新归零
    [USER setObject:@"0" forKey:@"favoriteRefresh"];
    //likersList页根据此判断来自哪，该dismiss还是pop
    [USER setObject:@"0" forKey:@"isFromAvtivity"];
    
    //看是否需要dismiss
    [USER setObject:@"0" forKey:@"isChooseInShouldDismiss"];
    
    //从本地读取种类数据，然后
//    NSString * path = [DOCDIR stringByAppendingPathComponent:@"CateNameList.plist"];
//    NSLog(@"CateNameList= %@",path);
//    NSMutableDictionary * data = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//    if (data) {
//        [USER setObject:data forKey:@"CateNameList"];
//        NSLog(@"读取CateNameList.plist文件成功！！");
//    }else{
//        NSLog(@"读取失败，本地没有CateNameList.plist文件");
//    }

}

-(void)createUI
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:bgImageView];
    
    if (hadImage) {
        float width = self.launchImage.size.width;
        float height = self.launchImage.size.height;
        if (width>320) {
            float w = 320/width;
            width *= w;
            height *= w;
        }
        if (height>568) {
            float h = 568/height;
            width *= h;
            height *= h;
        }
        bgImageView.image = self.launchImage;
        bgImageView.frame = CGRectMake(0, 0, width*0.9, height*0.9);
        bgImageView.center = self.view.center;
        [self setAnimation:bgImageView];
//        [self performSelector:@selector(jumpToRandom) withObject:nil afterDelay:2];
    }else{
        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", IMAGEURL, self.launchImageName] Block:^(BOOL isFinish, httpDownloadBlock * load) {
            if (isFinish) {
                bgImageView.image = load.dataImage;
                float width = load.dataImage.size.width;
                float height = load.dataImage.size.height;
                if (width>320) {
                    float w = 320/width;
                    width *= w;
                    height *= w;
                }
                if (height>568) {
                    float h = 568/height;
                    width *= h;
                    height *= h;
                }
                bgImageView.frame = CGRectMake(0, 0, width*0.9, height*0.9);
                bgImageView.center = self.view.center;
                NSString * docDir = DOCDIR;
                NSString * FilePath = [docDir stringByAppendingPathComponent:self.launchImageName];
                [load.data writeToFile:FilePath atomically:YES];
            }else{
                UIAlertView * alert = [MyControl createAlertViewWithTitle:@"图片加载失败"];
            }
            [self setAnimation:bgImageView];
//            [self performSelector:@selector(jumpToRandom) withObject:nil afterDelay:2];
        }];
    }
    
//    for(int i=0;i<3;i++){
//        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(40+i*(45+50), self.view.frame.size.height-260/2, 50, 50) ImageName:@"" Target:self Action:@selector(buttonClick:) Title:nil];
//        [bgImageView addSubview:button];
//        button.tag = 100+i;
//        button.layer.cornerRadius = 25;
//        button.layer.masksToBounds = YES;
//        button.showsTouchWhenHighlighted = YES;
//    }
}
//#pragma mark -登录
//-(void)login
//{
//    NSLog(@"loginAPI:%@", LOGINAPI);
//    [[httpDownloadBlock alloc] initWithUrlStr:LOGINAPI Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if(isFinish){
//            NSLog(@"%@", load.dataDict);
//            if ([[load.dataDict objectForKey:@"errorCode"] intValue]) {
//                UIAlertView * alert = [MyControl createAlertViewWithTitle:@"错误" Message:[load.dataDict objectForKey:@"errorMessage"] delegate:nil cancelTitle:nil otherTitles:@"确定"];
//                return;
//            }
//            NSLog(@"%@", load.dataDict);
//            [ControllerManager setIsSuccess:[[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]];
//            [ControllerManager setSID:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"]];
//            
//            //如果没有启动图片，搭建界面，下载图片
//            if (!hadImage) {
//                [self createUI];
//            }
//            
//            NSLog(@"isSuccess:%d,SID:%@", [ControllerManager getIsSuccess], [ControllerManager getSID]);
//            if ([ControllerManager getIsSuccess]) {
//                [self getUserData];
//            }
//            //设为1
//            isLogined = 1;
//            if (isAnimation) {
//                [self jumpToRandom];
//            }
////            [self performSelector:@selector(jumpToRandom) withObject:nil afterDelay:2];
//        }else{
//            UIAlertView * alert = [MyControl createAlertViewWithTitle:@"数据请求失败，是否重新请求？" Message:nil delegate:self cancelTitle:@"取消" otherTitles:@"确定"];
//        }
//    }];
//}
//#pragma mark -alert代理
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex) {
//        [self login];
//    }
//}

-(void)jumpToChoose
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    ChoseLoadViewController * vc = [[ChoseLoadViewController alloc] init];
//    vc.modalTransitionStyle = 2;
//    [self presentViewController:vc animated:NO completion:nil];
//    [vc release];
    
//    UINavigationController * nc = [ControllerManager shareManagerRandom];
//    JDSideMenu * sideMenu = [ControllerManager shareJDSideMenu];
////    [sideMenu setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"30-3" ofType:@"png"]]];
    vc.modalTransitionStyle = 2;
    [self presentViewController:vc animated:YES completion:nil];
}


//#pragma mark -获取用户数据
//-(void)getUserData
//{
//    NSString * url = [NSString stringWithFormat:@"%@%@", INFOAPI,[ControllerManager getSID]];
//    NSLog(@"%@", url);
//    [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            if ([[load.dataDict objectForKey:@"errorCode"] intValue] == 2) {
//                //SID过期,需要重新登录获取SID
//                [self login];
//                [self getUserData];
//                return;
//            }else{
//                //SID未过期，直接获取用户数据
//                NSLog(@"用户数据：%@", load.dataDict);
//                NSDictionary * dict = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
//                [USER setObject:[dict objectForKey:@"age"] forKey:@"age"];
//                [USER setObject:[dict objectForKey:@"code"] forKey:@"code"];
//                [USER setObject:[dict objectForKey:@"gender"] forKey:@"gender"];
//                [USER setObject:[dict objectForKey:@"name"] forKey:@"name"];
//                [USER setObject:[dict objectForKey:@"type"] forKey:@"type"];
//                if (![[dict objectForKey:@"tx"] isKindOfClass:[NSNull class]]) {
//                    [USER setObject:[dict objectForKey:@"tx"] forKey:@"tx"];
//                }
////                [USER setObject:[dict objectForKey:@"type"] forKey:@"type"];
//                
//                //                [self dismissViewControllerAnimated:YES completion:nil];
//            }
//        }
//    }];
//}

#pragma post
-(void)postImage
{
    //网络上传
    NSString * url = [NSString stringWithFormat:@"%@%@", PETIMAGEAPI, [ControllerManager getSID]];
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 20;
    
//    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/documents/myHeadImage.png"];
//    
//    NSLog(@"path:%@", path);
//    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
//    NSData * data = UIImagePNGRepresentation(image);
////    NSLog(@"data:%@", data);
//    if (data == nil) {
//        image = [UIImage imageNamed:@"1669988_d_wx.jpg"];
//        data = UIImageJPEGRepresentation(image, 1);
////        NSLog(@"data2:%@", data);
//    }
//
//    [_request setPostValue:@"This is a test333333333333!" forKey:@"comment"];
//    [_request setPostValue:data forKey:@"image"];
    UIImage * image = [UIImage imageNamed:@"1669988_d_wx.jpg"];
    NSData * data = UIImagePNGRepresentation(image);
    [_request setData:data withFileName:@"cat.png" andContentType:@"image/jpg" forKey:@"image"];

    _request.delegate = self;
    [_request startAsynchronous];
    
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"success");
    NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
}


-(void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {
//        NSLog(@"微信登录");
    }else if(button.tag == 101){
//        NSLog(@"微博登录");
    }else if (button.tag == 102) {
//        UINavigationController * nc = [ControllerManager shareManagerRandom];
//        [self presentViewController:nc animated:YES completion:nil];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setAnimation:(UIImageView *)nowView
{
//    isAnimation = 1;
//    if (isLogined) {
//        [self performSelector:@selector(jumpToRandom) withObject:nil afterDelay:2];
//    }
    [UIView animateWithDuration:2.0f delay:0.0f options:UIViewAnimationOptionCurveLinear                     animations:^
     {
         // 执行的动画code
         [bgImageView setFrame:CGRectMake(nowView.frame.origin.x- nowView.frame.size.width*0.1, nowView.frame.origin.y-nowView.frame.size.height*0.1, nowView.frame.size.width*1.2, nowView.frame.size.height*1.2)];
         
     }completion:^(BOOL finished) {
//         if (isLogined) {
             [self performSelector:@selector(jumpToChoose) withObject:nil];
//         }else{
//             isAnimation = 1;
//         }
     }];
}

@end
