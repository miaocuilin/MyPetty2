//
//  BlackListCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/4.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "BlackListCell.h"

@implementation BlackListCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    headImage = [MyControl createImageViewWithFrame:CGRectMake(15, 11, 50, 50) ImageName:@"defaultUserHead.png"];
    headImage.layer.cornerRadius = 25;
    headImage.layer.masksToBounds = YES;
    [self addSubview:headImage];
    
    name = [MyControl createLabelWithFrame:CGRectMake(166/2, 52/2, 170, 20) Font:17 Text:nil];
    name.textColor = BGCOLOR;
    [self addSubview:name];
    
//    126/2  30
    cancelBtn = [MyControl createButtonWithFrame:CGRectMake(self.frame.size.width-148/2, 21, 126/2, 30) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:@"取消"];
    cancelBtn.backgroundColor = BGCOLOR5;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.masksToBounds = YES;
    [self addSubview:cancelBtn];
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 71, self.frame.size.width, 1)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
}
-(void)cancelBtnClick
{
    StartLoading;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"usr_id=%@dog&cat", self.usr_id]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", UNBOLCKTALKAPI, self.usr_id, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            [MyControl loadingSuccessWithContent:@"去黑成功" afterDelay:0.5];
            self.deleteBlack();
        }else{
            LoadingFailed;
        }
    }];
    [request release];
}
-(void)configUIWithModel:(InfoModel *)model
{
    name.text = model.name;
    self.usr_id = model.usr_id;
    
    if (!([model.tx isKindOfClass:[NSNull class]] || [model.tx length]==0)) {
        NSString * docDir = DOCDIR;
        NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
        //        NSLog(@"--%@--%@", txFilePath, self.headImageURL);
        UIImage * image = [UIImage imageWithContentsOfFile:txFilePath];
        if (image) {
            //            [button setBackgroundImage:image forState:UIControlStateNormal];
            headImage.image = image;
        }else{
            //下载头像
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", USERTXURL, model.tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if (isFinish) {
                    //                    [button setBackgroundImage:load.dataImage forState:UIControlStateNormal];
                    headImage.image = load.dataImage;
                    NSString * docDir = DOCDIR;
//                    NSString * txFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
                    [load.data writeToFile:txFilePath atomically:YES];
                }else{
                    NSLog(@"头像下载失败");
                }
            }];
            [request release];
        }
    }
}
@end
