//
//  RecordViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-9-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "RecordViewController.h"
#define GRAYBLUECOLOR [UIColor colorWithRed:127/255.0 green:151/255.0 blue:179/255.0 alpha:1]
#define LIGHTORANGECOLOR [UIColor colorWithRed:252/255.0 green:123/255.0 blue:81/255.0 alpha:1]
@interface RecordViewController ()
{
    UIImageView *floating1;
    UIImageView *floating2;
    UIImageView *floating3;
    BOOL _hasCAFFile;
    UILabel *timerLabel;
    UILabel *timerLabel2;
    UILabel *timerLabel3;
    MBRoundProgressView *recordProgress;
    MBRoundProgressView *playProgress;
    MBRoundProgressView *uploadProgress;
    UIButton *rerecordingButton;
    UIButton *recordUploadingButton;
    UIButton *playButton;
    NSString *playDuration;
    ASIFormDataRequest * _request;
    NSURL* recordedFile;
}
@property (nonatomic,strong)UIScrollView *upScrollView;
//@property (nonatomic,strong)NSURL* recordedFile;
@property (nonatomic,strong)AVAudioRecorder* recorder;
@property (nonatomic,strong)AVAudioPlayer* player;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)NSTimer *timer2;
@property (nonatomic)CGFloat distance;
@property (nonatomic)BOOL isBack1;
@property (nonatomic)BOOL isBack2;
@property (nonatomic)BOOL isBack3;
@end

@implementation RecordViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MobClick event:@"shout_button"];
    
    [self backgroundView];
    [self createUI];
    [self loadIsRecorderData];
}

#pragma mark - 是否已经上传录音
- (void)loadIsRecorderData
{
    LOADING;
//    NSLog(@"%@", self.pet_aid);
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.pet_aid]];
    
    NSString *isTouchString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", ISRECORDERAPI, self.pet_aid, sig,[ControllerManager getSID]];
    NSLog(@"isTouchString:%@",isTouchString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:isTouchString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            NSLog(@"isVoiced:%@",load.dataDict);
            if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"is_voiced"] intValue]) {
                self.upScrollView.contentOffset = CGPointMake(self.upScrollView.frame.size.width*4, 0);
                [self floatingFrame:4];
                //已经录过了，从本地找看是否有录音
                NSFileManager * manager = [[NSFileManager alloc] init];
                NSString * filePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", self.pet_aid]];
                if ([manager fileExistsAtPath:filePath]) {
                    //存在录音，播放
//                    [self playRecord2];
                    [manager release];
                }else{
                    //不存在，去下载
                    [self loadRecordStringData];
                    [manager release];
                    
//                    NSString * sig2 = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.pet_aid]];
//                    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", RECORDDOWNLOADAPI, self.pet_aid, sig2, [ControllerManager getSID]];
//                    httpDownloadBlock * request2 = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//                        if (isFinish) {
//                            BOOL isSuccess = [load.data writeToFile:filePath atomically:YES];
//                            NSLog(@"%d", isSuccess);
////                            [self playRecord2];
//                        }else{
//                            StartLoading;
//                            LoadingFailed;
//                        }
//                    }];
//                    [request2 release];
                }
            }
            ENDLOADING;
        }else{
            LOADFAILED;
        }
        
        
    }];
    [request release];
}
#pragma mark - 下载声音
- (void)loadRecordStringData
{
    StartLoading;
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.pet_aid]];
    NSString *downloadRecord = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", RECORDDOWNLOADAPI, self.pet_aid, sig,[ControllerManager getSID]];
    NSLog(@"下载API:%@",downloadRecord);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:downloadRecord Block:^(BOOL isFinsh, httpDownloadBlock *load) {
        if (isFinsh) {
            NSLog(@"isFinsh:%d,load.dataDict:%@",isFinsh,load.dataDict);
//            self.haveRecord = YES;
            self.recordURL = [NSString stringWithFormat:@"http://pet4voices.oss-cn-beijing.aliyuncs.com/%@",[[load.dataDict objectForKey:@"data"] objectForKey:@"url"]];
            [self loadRecordData];
        }else{
//            [self createAlertView];
            [MyControl loadingFailedWithContent:@"音频文件不存在" afterDelay:0.7];
        }
    }];
    [request release];
}
- (void)loadRecordData
{
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:self.recordURL Block:^(BOOL isFinish, httpDownloadBlock *load) {
        //        NSLog(@"load.data音频二进制数据:%@",load.data);
//        NSDate *  senddate=[NSDate date];
//        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//        [dateformatter setDateFormat:@"YYYYMMdd"];
//        NSString *  locationString=[dateformatter stringFromDate:senddate];
        [load.data writeToFile:[DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", self.pet_aid]] atomically:YES];
//        [dateformatter release];
//        _player = [[AVAudioPlayer alloc] initWithData:load.data error:nil];
//        [self createAlertView];
        LoadingSuccess;
    }];
    [request release];
}
-(void)playRecord5Click
{
    //已经录过了，从本地找看是否有录音
    NSFileManager * manager = [[NSFileManager alloc] init];
    NSString * filePath = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@.mp3", @"Mp3File"]];
    if ([manager fileExistsAtPath:filePath]) {
        //存在录音，播放
        [self playRecord2];
    }
    [manager release];
//    else{
//        //不存在，去下载
//        NSString * sig2 = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.pet_aid]];
//        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", RECORDDOWNLOADAPI, self.pet_aid, sig2, [ControllerManager getSID]];
//        NSLog(@"%@", url);
//        httpDownloadBlock * request2 = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//            if (isFinish) {
//                [load.data writeToFile:filePath atomically:YES];
//                [self playRecord2];
//            }else{
//                StartLoading;
//                [MyControl loadingFailedWithContent:@"音频文件不存在" afterDelay:0.7];
//            }
//        }];
//        [request2 release];
//    }
}
-(void)playRecord2
{
    NSString * filePath = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@.mp3", @"Mp3File"]];
    if (_player == nil)
    {
        NSError *playerError;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&playerError];
        _player.meteringEnabled = YES;
        
        _player.delegate = self;
        if (_player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
//        else{
//            [self.player release];
//        }
    }
    
    [_player play];
}
#pragma mark - 上传录音
- (void)uploadRecordData
{
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.pet_aid]];
    NSString *uploadRecordString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",RECORDUPLOADAPI, self.pet_aid, sig,[ControllerManager getSID]];
    //网络上传
    NSLog(@"postUrl:%@", uploadRecordString);
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:uploadRecordString]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 30;
    NSString *mp3FileName = @"Mp3File.mp3";
//    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [NSTemporaryDirectory() stringByAppendingString:mp3FileName];
    NSData *data = [NSData dataWithContentsOfFile:mp3FilePath];
    [_request setData:data forKey:@"voice"];
    [_request setUploadProgressDelegate:self];
    _request.queue = self;
    [_request startAsynchronous];
    
}
-(void)setProgress:(float)newProgress
{
    NSLog(@"上传进度:%f",newProgress);
    [UIView animateWithDuration:0.3 animations:^{
        uploadProgress.progress = newProgress;
        
    }];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"上传录音结束");
    [MobClick event:@"shout_suc"];
    
    self.upScrollView.contentOffset = CGPointMake(self.upScrollView.frame.size.width*3, 0);
    [self floatingFrame:3];
    int exp = [[USER objectForKey:@"exp"] intValue];
    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    int newexp = [[[dict objectForKey:@"data"] objectForKey:@"exp"] intValue];
    [USER setObject:[[dict objectForKey:@"data"] objectForKey:@"exp"] forKey:@"exp"];
    if (exp != newexp && (newexp - exp)>0) {
        int index = newexp - exp;
        [ControllerManager HUDImageIcon:@"Star" showView:self.view yOffset:0 Number:index];
    }
    
    if (self.isFromStar) {
        self.recordBack();
    }
    
    //    NSLog(@"响应：%@", [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
    
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"上传录音失败");
//    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"上传失败"];
}
#pragma mark - 创建界面
- (void)createUI
{
    totalView = [MyControl createViewWithFrame:CGRectMake(self.view.frame.size.width/2-150,self.view.frame.size.height/2-425/2.0, 300, 425)];
    totalView.layer.cornerRadius = 10;
    totalView.layer.masksToBounds = YES;
    [self.view addSubview:totalView];
    
    UIImageView *titleView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 300, 40) ImageName:@"title_bg.png"];
    [totalView addSubview:titleView];
    UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:17 Text:@"萌叫叫"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:titleLabel];
    
    UIImageView *closeImageView = [MyControl createImageViewWithFrame:CGRectMake(260, 10, 20, 20) ImageName:@"30-1.png"];
    [totalView addSubview:closeImageView];
    UIButton *closeButton = [MyControl createButtonWithFrame:CGRectMake(252.5, 2.5, 35, 35) ImageName:nil Target:self Action:@selector(colseGiftAction) Title:nil];
    closeButton.showsTouchWhenHighlighted = YES;
    [totalView addSubview:closeButton];
    
    UIView *bodyView = [MyControl createViewWithFrame:CGRectMake(0, 40, 300, 385)];
    bodyView.backgroundColor = [UIColor whiteColor];
    [totalView addSubview:bodyView];
    [self.view addSubview:totalView];
    
    //上方视图
    _upScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, bodyView.frame.size.width, bodyView.frame.size.height-70)];
    _upScrollView.scrollEnabled = NO;
    
    [bodyView addSubview:self.upScrollView];
    _upScrollView.contentSize = CGSizeMake(self.upScrollView.frame.size.width*5, self.upScrollView.frame.size.height);
    _upScrollView.pagingEnabled = YES;
//    self.upScrollView.scrollEnabled = NO;
    
    CGFloat upViewWidth= self.upScrollView.frame.size.width;
    self.distance = 0;
    
    UIImageView *cloudBg1 = [MyControl createImageViewWithFrame:CGRectMake(0, 110, upViewWidth, 200) ImageName:@"bluecloudbg.png"];
    [_upScrollView addSubview:cloudBg1];
    UIImageView *cloudBg2 = [MyControl createImageViewWithFrame:CGRectMake(upViewWidth, 110, upViewWidth, 200) ImageName:@"bluecloudbg.png"];
    [_upScrollView addSubview:cloudBg2];
    UIImageView *cloudBg3 = [MyControl createImageViewWithFrame:CGRectMake(upViewWidth*2, 110, upViewWidth, 200) ImageName:@"bluecloudbg.png"];
    [_upScrollView addSubview:cloudBg3];
    
    floating1 = [MyControl createImageViewWithFrame:CGRectMake(230, 40, 70, 25) ImageName:@"yellowcloud.png"];
    floating1.tag = 30;
    [_upScrollView addSubview:floating1];
    
    floating2 = [MyControl createImageViewWithFrame:CGRectMake(23, 90, 70, 25) ImageName:@"yellowcloud.png"];
    floating2.tag = 31;
    [_upScrollView addSubview:floating2];
    
    floating3 = [MyControl createImageViewWithFrame:CGRectMake(180, 180, 70, 25) ImageName:@"yellowcloud.png"];
    floating3.tag = 32;
    [_upScrollView addSubview:floating3];
    self.timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(floatingAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
#pragma mark - one
    //1
    UILabel *recordDescLabel1 = [MyControl createLabelWithFrame:CGRectMake(upViewWidth/2 - 115, 10, 230, 20) Font:16 Text:@"为萌萌的TA记录每天的欢乐吧~"];
    recordDescLabel1.textAlignment = NSTextAlignmentCenter;
    recordDescLabel1.textColor = GRAYBLUECOLOR;
    [self.upScrollView addSubview:recordDescLabel1];
    
    recordProgress = [[MBRoundProgressView alloc] initWithFrame:CGRectMake(upViewWidth/2 - 80, 61, 160, 160)];
    recordProgress.annular = YES;
    recordProgress.lineWidth = 16.0f;
    recordProgress.backgroundTintColor =[ControllerManager colorWithHexString:@"#efcec3"];
    recordProgress.progressTintColor = [ControllerManager colorWithHexString:@"#fc7b51"];
//    recordProgress.progress = 0.5;
    [self.upScrollView addSubview:recordProgress];
    UIButton *recordButton = [MyControl createButtonWithFrame:CGRectMake(upViewWidth/2 - 67.5, 75, 135, 135) ImageName:@"recordstart.png" Target:self Action:@selector(recordButtonTouchUp:) Title:nil];
    recordButton.adjustsImageWhenHighlighted = NO;
    [recordButton addTarget:self action:@selector(recordButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [recordButton addTarget:self action:@selector(recordButtonTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.upScrollView addSubview:recordButton];
    timerLabel = [MyControl createLabelWithFrame:CGRectMake(self.upScrollView.frame.size.width/2-25, 30, 50, 20) Font:18 Text:nil];
    timerLabel.textAlignment = NSTextAlignmentCenter;
    timerLabel.textColor = LIGHTORANGECOLOR;
    [self.upScrollView addSubview:timerLabel];
    //2
#pragma mark - two
    UILabel *recordDescLabel2 = [MyControl createLabelWithFrame:CGRectMake(upViewWidth/2+upViewWidth - 115, 10, 230, 20) Font:16 Text:@"为萌萌的TA记录每天的叫声吧~"];
    recordDescLabel2.textAlignment = NSTextAlignmentCenter;
    recordDescLabel2.textColor = GRAYBLUECOLOR;
    [self.upScrollView addSubview:recordDescLabel2];
    
    playProgress = [[MBRoundProgressView alloc] initWithFrame:CGRectMake(upViewWidth/2+upViewWidth - 80, 61, 160, 160)];
    playProgress.annular = YES;
    playProgress.lineWidth = 16.0f;
    playProgress.backgroundTintColor =[ControllerManager colorWithHexString:@"#efcec3"];
    playProgress.progressTintColor = [ControllerManager colorWithHexString:@"#fc7b51"];
    //    recordProgress.progress = 0.5;
    [self.upScrollView addSubview:playProgress];
    playButton = [MyControl createButtonWithFrame:CGRectMake(upViewWidth/2 - 67.5+upViewWidth, 75, 135, 135) ImageName:@"playrecord.png" Target:self Action:@selector(playRecord:) Title:nil];
    [playButton setBackgroundImage:[UIImage imageNamed:@"pauserecord.png"] forState:UIControlStateSelected];
    playButton.adjustsImageWhenHighlighted = NO;
    [self.upScrollView addSubview:playButton];
    
    //重录动作
    rerecordingButton = [MyControl createButtonWithFrame:CGRectMake(35+upViewWidth, 240, 40, 40) ImageName:@"rerecord.png" Target:self Action:@selector(RerecordAction) Title:nil];
    [self.upScrollView addSubview:rerecordingButton];
    //录音上传动作
    recordUploadingButton = [MyControl createButtonWithFrame:CGRectMake(220+upViewWidth, 240, 40, 40) ImageName:@"uploadrecord.png" Target:self Action:@selector(recordUploadingAction) Title:nil];
    [self.upScrollView addSubview:recordUploadingButton];
    
    timerLabel2 = [MyControl createLabelWithFrame:CGRectMake(upViewWidth/2-40+upViewWidth, 30, 80, 30) Font:18 Text:@""];
    timerLabel2.textAlignment = NSTextAlignmentCenter;
    timerLabel2.textColor = LIGHTORANGECOLOR;
    [self.upScrollView addSubview:timerLabel2];
    //3
#pragma mark - three
    UILabel *recordDescLabel3 = [MyControl createLabelWithFrame:CGRectMake(upViewWidth/2+upViewWidth*2 - 115, 10, 230, 20) Font:16 Text:@"为萌萌的TA记录每天的叫声吧~"];
    recordDescLabel3.textAlignment = NSTextAlignmentCenter;
    recordDescLabel3.textColor = GRAYBLUECOLOR;
    [self.upScrollView addSubview:recordDescLabel3];
    
    uploadProgress = [[MBRoundProgressView alloc] initWithFrame:CGRectMake(upViewWidth/2+upViewWidth*2 - 80, 61, 160, 160)];
    uploadProgress.annular = YES;
    uploadProgress.lineWidth = 16.0f;
    uploadProgress.backgroundTintColor =[ControllerManager colorWithHexString:@"#efcec3"];
    uploadProgress.progressTintColor = [ControllerManager colorWithHexString:@"#fc7b51"];
    //    recordProgress.progress = 0.5;
    [self.upScrollView addSubview:uploadProgress];
    UIButton *uploadButton = [MyControl createButtonWithFrame:CGRectMake(upViewWidth/2 - 67.5+upViewWidth*2, 75, 135, 135) ImageName:@"uploadingrecord.png" Target:self Action:nil Title:nil];
    uploadButton.adjustsImageWhenHighlighted = NO;
    [self.upScrollView addSubview:uploadButton];
    
    timerLabel3 = [MyControl createLabelWithFrame:CGRectMake(upViewWidth/2-40+upViewWidth*2, 30, 80, 30) Font:18 Text:nil];
    timerLabel3.textAlignment = NSTextAlignmentCenter;
    timerLabel3.textColor = LIGHTORANGECOLOR;
    [self.upScrollView addSubview:timerLabel3];
#pragma mark - four
    //4
    UILabel *recordDescLabel4 = [MyControl createLabelWithFrame:CGRectMake(upViewWidth/2+upViewWidth*3 - 115, 10, 230, 20) Font:16 Text:@"上传成功，期待明天的萌叫叫哦~"];
    recordDescLabel4.textAlignment = NSTextAlignmentCenter;
    recordDescLabel4.textColor = GRAYBLUECOLOR;
    [self.upScrollView addSubview:recordDescLabel4];
    
    UIButton * playRecord4 = [MyControl createButtonWithFrame:CGRectMake(upViewWidth*3 + (upViewWidth-45)/2, 70, 45, 45) ImageName:@"play.png" Target:self Action:@selector(playRecord5Click) Title:nil];
    [self.upScrollView addSubview:playRecord4];
    
    UIImageView *recordBg4 = [MyControl createImageViewWithFrame:CGRectMake(upViewWidth*3, 140, upViewWidth, 120) ImageName:@"grassbg.png"];
    [self.upScrollView addSubview:recordBg4];
    UIImageView *recordImageView = [MyControl createImageViewWithFrame:CGRectMake(upViewWidth/2 - 65, 0, 130, 113) ImageName:@"record_upload.png"];
    [recordBg4 addSubview:recordImageView];
    
    
    UIImageView *share = [MyControl createImageViewWithFrame:CGRectMake(upViewWidth*3, 265, upViewWidth, 40) ImageName:@"threeshare.png"];
    [self.upScrollView addSubview:share];
    
    UIView *shareView = [MyControl createViewWithFrame:CGRectMake(upViewWidth/2-195/2.0+upViewWidth*3, 250, 195, 50)];
    [self.upScrollView addSubview:shareView];
    for (int i = 0; i<3; i++) {
        UIButton *shareButton = [MyControl createButtonWithFrame:CGRectMake(0+shareView.frame.size.width/3 * i +(i*12), 15, 40, 40) ImageName:nil Target:self Action:@selector(shareAction:) Title:nil];
        shareButton.tag = 77+i;
//        shareButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//        [shareButton setShowsTouchWhenHighlighted:YES];
        [shareView addSubview:shareButton];
    }
    //5
#pragma mark - five
    UILabel *recordDescLabel5 = [MyControl createLabelWithFrame:CGRectMake(upViewWidth/2+upViewWidth*4 - 115, 10, 230, 50) Font:16 Text:[NSString stringWithFormat:@"今天 %@ 的萌叫叫录过了呢，\n去看看其他萌星吧", self.pet_name]];
    recordDescLabel5.textAlignment = NSTextAlignmentCenter;
    recordDescLabel5.textColor = GRAYBLUECOLOR;
    [self.upScrollView addSubview:recordDescLabel5];
    
    UIButton * playRecord5 = [MyControl createButtonWithFrame:CGRectMake(upViewWidth*4 + (upViewWidth-45)/2, 70, 45, 45) ImageName:@"play.png" Target:self Action:@selector(playRecord5Click) Title:nil];
    [self.upScrollView addSubview:playRecord5];
    
    UIImageView *recordBg5 = [MyControl createImageViewWithFrame:CGRectMake(upViewWidth*4, 140, upViewWidth, 120) ImageName:@"grassbg.png"];
    [self.upScrollView addSubview:recordBg5];
    UIImageView *recordImageView2 = [MyControl createImageViewWithFrame:CGRectMake(upViewWidth/2 - 65, 0, 130, 113) ImageName:@"record_upload.png"];
    [recordBg5 addSubview:recordImageView2];
    
    UIImageView *share2 = [MyControl createImageViewWithFrame:CGRectMake(upViewWidth*4, 265, upViewWidth, 40) ImageName:@"threeshare.png"];
    [self.upScrollView addSubview:share2];
    UIView *shareView2 = [MyControl createViewWithFrame:CGRectMake(upViewWidth/2-195/2.0+upViewWidth*4, 250, 195, 50)];
    [self.upScrollView addSubview:shareView2];
    for (int i = 0; i<3; i++) {
        UIButton *shareButton = [MyControl createButtonWithFrame:CGRectMake(0+shareView2.frame.size.width/3 * i +(i*12), 15, 40, 40) ImageName:nil Target:self Action:@selector(shareAction:) Title:nil];
        shareButton.tag = 77+i;
        //        shareButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        //        [shareButton setShowsTouchWhenHighlighted:YES];
        [shareView2 addSubview:shareButton];
    }
#pragma mark - bottom
    //下方视图
    UIView *downView = [MyControl createViewWithFrame:CGRectMake(0, bodyView.frame.size.height-70, bodyView.frame.size.width, 70)];
    [bodyView addSubview:downView];
    
    UIImageView *headImageView = [MyControl createImageViewWithFrame:CGRectMake(10, 0, 56, 56) ImageName:@"defaultPetHead.png"];
    if (!([self.pet_tx isKindOfClass:[NSNull class]] || [self.pet_tx length]== 0)) {
        NSString *pngFilePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.pet_tx]];
        UIImage * image = [UIImage imageWithContentsOfFile:pngFilePath];
        if (image) {
            headImageView.image = image;
        }else{
            httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@",PETTXURL, self.pet_tx] Block:^(BOOL isFinsh, httpDownloadBlock *load) {
                if (isFinsh) {
                    headImageView.image = load.dataImage;
                    [load.data writeToFile:pngFilePath atomically:YES];
                }
            }];
            [request release];
        }
    }
    headImageView.layer.cornerRadius = 28;
    headImageView.layer.masksToBounds = YES;
    [downView addSubview:headImageView];
    
    UIImageView *cricleHeadImageView = [MyControl createImageViewWithFrame:CGRectMake(8, -2, 60, 60) ImageName:@"head_cricle1.png"];
    [downView addSubview:cricleHeadImageView];
    UILabel *helpPetLabel = [MyControl createLabelWithFrame:CGRectMake(70, 5, 200, 20) Font:12 Text:nil];
    NSAttributedString *helpPetString = [self firstString:@"听萌萌叫" formatString: self.pet_name insertAtIndex:1];
    helpPetLabel.attributedText = helpPetString;
//    [helpPetString release];
    [downView addSubview:helpPetLabel];
    
    //播放按钮
//    UIButton * playRecordBtn = [MyControl createButtonWithFrame:CGRectMake(125, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>) ImageName:<#(NSString *)#> Target:<#(id)#> Action:<#(SEL)#> Title:<#(NSString *)#>];
}
//录音代理方法
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"recordFinish");
}
- (void) toMp3
{
    NSString *cafFilePath =[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"];
    
    NSString *mp3FileName = @"Mp3File.mp3";
//    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [NSTemporaryDirectory() stringByAppendingString:mp3FileName];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        //        [self performSelectorOnMainThread:@selector(convertMp3Finish)
        //                               withObject:nil
        //                            waitUntilDone:YES];
        NSLog(@"mp3格式转换完成");
        
    }
}
#pragma mark - button点击事件
- (void)recordButtonTouchUp:(UIButton *)sender
{
    NSLog(@"录音结束");
    recordProgress.progress = 0.00;
    [sender setBackgroundImage:[UIImage imageNamed:@"recordstart.png"] forState:UIControlStateNormal];
    timerLabel.text = @"";
    //停止，发送
    if ((int)self.recorder.currentTime >=2 ) {
        self.distance = self.upScrollView.frame.size.width;
        [self.recorder stop];
        [self toMp3];
        self.upScrollView.contentOffset = CGPointMake(self.upScrollView.frame.size.width, 0);
        [self floatingFrame:1];
    }
    if (self.timer2) {
        [self.timer2 invalidate];
        self.timer2 = nil;
    }
//    _recording = NO;
//    [self.recorder stop];
//    [self.recorder release];
    self.recorder = nil;
    
}
- (void)recordButtonTouchDown:(UIButton *)sender
{
    NSLog(@"录音");
    [sender setBackgroundImage:[UIImage imageNamed:@"recording.png"] forState:UIControlStateNormal];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100],                  AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatLinearPCM],                   AVFormatIDKey,
                              [NSNumber numberWithInt: 2],                              AVNumberOfChannelsKey,[NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                              [NSNumber numberWithInt: AVAudioQualityMin],                       AVEncoderAudioQualityKey,
                              nil];
//    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
//    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    //    _recordedFile = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%@.aac", cfuuidString]]] retain];
    NSFileManager *manager = [[NSFileManager alloc] init];
    if ([manager fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]]) {
        [manager removeItemAtPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"] error:nil];
    }
    [manager release];
//    recordedFile = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]]retain];
    recordedFile = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]]retain];
    
    NSLog(@"_recordedFile :%@",recordedFile);
    NSError* error;
    _recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:settings error:&error];
    _recorder.delegate = self;
    NSLog(@"%@", [error description]);
    if (error)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"your device doesn't support your setting"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    [_recorder prepareToRecord];
    _recorder.meteringEnabled = YES;
    [_recorder record];
    _hasCAFFile = YES;
//    self.recorder = YES;
    if (!_timer2) {
        self.timer2 = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    }
}
- (void)playRecord:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        rerecordingButton.enabled = NO;
        recordUploadingButton.enabled = NO;
        if (_hasCAFFile)
        {
            if (_player == nil)
            {
                NSError *playerError;
                _player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedFile error:&playerError];
                _player.meteringEnabled = YES;
                if (_player == nil)
                {
                    NSLog(@"ERror creating player: %@", [playerError description]);
                }
                self.player.delegate = self;
            }
            
            [self.player play];
            if (!_timer2) {
                self.timer2 = [NSTimer scheduledTimerWithTimeInterval:.1
                                                               target:self
                                                             selector:@selector(timerUpdate)
                                                             userInfo:nil
                                                              repeats:YES];
            }
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"Please Record a File First"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];                   }
        
    }else{
        if (_timer2) {
            [self.timer2 invalidate];
            self.timer2 = nil;
        }
        rerecordingButton.enabled = YES;
        recordUploadingButton.enabled = YES;
        [self.player pause];
    }
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"播放完毕");
//    [self.player stop];
    if (_timer2) {
        [self.timer2 invalidate];
        self.timer2 = nil;
    }
    rerecordingButton.enabled = YES;
    recordUploadingButton.enabled = YES;
    playProgress.progress = 0.0;
    playButton.selected = !playButton.selected;
    timerLabel2.text = @"";
}
- (void)RerecordAction
{
    self.upScrollView.contentOffset = CGPointMake(0, 0);
    [self floatingFrame:0];
    timerLabel2.text = @"";
    playProgress.progress = 0.0;
    if (_player) {
        [_player release];
        _player = nil;
    }
    recordedFile = nil;
}
- (void)recordUploadingAction
{
    self.upScrollView.contentOffset = CGPointMake(self.upScrollView.frame.size.width*2, 0);
    [self floatingFrame:2];
//    timerLabel3.text = [NSString stringWithFormat:@"00:%@",playDuration];
    [self uploadRecordData];
}
- (void)shareAction:(UIButton *)sender
{
    //截图
    UIImage * image = [MyControl imageWithView:totalView];
    
    /**************/
    if(sender.tag == 77){
        NSLog(@"微信");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                StartLoading;
                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                StartLoading;
                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
            
        }];
    }else if(sender.tag == 78){
        NSLog(@"朋友圈");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                StartLoading;
                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                StartLoading;
                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
            
        }];
    }else if(sender.tag == 79){
        NSLog(@"微博");
        NSString * str = [NSString stringWithFormat:@"我家萌宠%@今天乖巧的冲我撒娇，来听听吧。http://home4pet.imengstar.com/（分享自@宠物星球社交应用）", self.pet_name];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                StartLoading;
                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
            }else{
                NSLog(@"失败原因：%@", response);
                StartLoading;
                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
            }
            
        }];
    }
}
#pragma mark - 浮云
//更新
- (void) timerUpdate
{
    NSLog(@".........");
    if ((int)self.recorder.currentTime == 30) {
//        _recording = NO;
        [self.timer2 invalidate];
        self.timer2 = nil;
        //停止，发送
        [self.recorder stop];
        [_recorder release];
        self.recorder = nil;
        self.upScrollView.contentOffset = CGPointMake(self.upScrollView.frame.size.width, 0);
        [self toMp3];
        [self floatingFrame:1];
        playDuration = @"30";
        return;
    }
    if ([self.recorder isRecording])
    {
        int m = self.recorder.currentTime / 60;
        int s = ((int) self.recorder.currentTime) % 60;
        NSLog(@"录音的当前时间：%f",self.recorder.currentTime);
        timerLabel.text = [NSString stringWithFormat:@"%.2d:%.2d", m, s];
        recordProgress.progress = 1/30.0*_recorder.currentTime;
        playDuration = [NSString stringWithFormat:@"%d",(int)self.recorder.currentTime];
    }
    if ([self.player isPlaying])
    {
        //         _player.currentTime=fabsf(_player.currentTime);
        NSLog(@"播放的当前时间：%f",self.player.currentTime);
        playProgress.progress = self.player.currentTime/self.player.duration;
        timerLabel2.text =[NSString stringWithFormat:@"00:%0.2d",(int)self.player.currentTime%60];
    }
}
- (void)floatingFrame:(NSInteger)num
{
    floating1.frame = CGRectMake(230+self.upScrollView.frame.size.width*num, 40, 70, 25);
    floating2.frame = CGRectMake(23+self.upScrollView.frame.size.width*num, 90, 70, 25);
    floating3.frame = CGRectMake(180+self.upScrollView.frame.size.width*num, 180, 70, 25);
    self.distance = self.upScrollView.frame.size.width*num;
}
- (void)floatingAnimation
{
    UIImageView *floatinga = (UIImageView *)[self.view viewWithTag:30];
    if (!self.isBack1) {
        floatinga.frame = CGRectMake(floatinga.frame.origin.x-1, 40, 70, 25);
        if (floatinga.frame.origin.x<=0+self.distance) {
            self.isBack1 = YES;
        }
    }else{
        floatinga.frame = CGRectMake(floatinga.frame.origin.x+1, 40, 70, 25);
        if (floatinga.frame.origin.x > 230+self.distance) {
            self.isBack1 = NO;
        }
    }
    UIImageView *floatingb = (UIImageView *)[self.view viewWithTag:31];
    if (self.isBack2) {
        floatingb.frame =CGRectMake(floatingb.frame.origin.x+0.5, 90, 70, 25);
        if (floatingb.frame.origin.x >230+self.distance) {
            self.isBack2 = NO;
        }
    }else{
        floatingb.frame =CGRectMake(floatingb.frame.origin.x-0.5, 90, 70, 25);
        if (floatingb.frame.origin.x <0+self.distance) {
            self.isBack2 = YES;
        }
    }
    
    UIImageView *floatingc = (UIImageView *)[self.view viewWithTag:32];
    if (self.isBack3) {
        floatingc.frame =CGRectMake(floatingc.frame.origin.x-0.75, 180, 70, 25);
        if (floatingc.frame.origin.x <0+self.distance) {
            self.isBack3 = NO;
        }
    }else{
        floatingc.frame =CGRectMake(floatingc.frame.origin.x+0.75, 180, 70, 25);
        if (floatingc.frame.origin.x >230+self.distance) {
            self.isBack3 = YES;
        }
    }
}
//一句话两种颜色
- (NSAttributedString *)firstString:(NSString *)string1 formatString:(NSString *)string2 insertAtIndex:(NSInteger)number
{
    NSMutableAttributedString *attributeString2 = [[NSMutableAttributedString alloc] initWithString:string2];
    
    [attributeString2 addAttribute:NSForegroundColorAttributeName value:LIGHTORANGECOLOR range:NSMakeRange(0, attributeString2.length)];
    NSMutableAttributedString *attributeString1 = [[NSMutableAttributedString alloc] initWithString:string1];
    [attributeString1 addAttribute:NSForegroundColorAttributeName value:GRAYBLUECOLOR range:NSMakeRange(0, attributeString1.length)];
    [attributeString1 insertAttributedString:attributeString2 atIndex:number];
    [attributeString2 release];
    return [attributeString1 autorelease];
}
- (void)backgroundView
{
    UIView *bgView = [MyControl createViewWithFrame:self.view.frame];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
}
- (void)colseGiftAction
{
    [self.player stop];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (self.timer2) {
        [self.timer2 invalidate];
        self.timer2 = nil;
    }
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
