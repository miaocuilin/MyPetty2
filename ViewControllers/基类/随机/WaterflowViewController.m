//
//  WaterflowViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/2/27.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "WaterflowViewController.h"
#import "BrickView.h"
#import "PhotoModel.h"

@interface DemoBrickViewCell : BrickViewCell

@property(nonatomic)float cmtHeight;
@property(nonatomic)UILabel * desLabel;
@property(nonatomic)UIImageView * bigImageView;
@end

@implementation DemoBrickViewCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:12];
        _desLabel.numberOfLines = 0;
        [self addSubview:_desLabel];
        
        _bigImageView = [[UIImageView alloc] init];
        self.bigImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bigImageView];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.cmtHeight) {
        self.bigImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-35);
        self.desLabel.frame = CGRectMake(4, self.frame.size.height - 18, self.frame.size.width-8, 0);
    }else{
        self.bigImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-self.cmtHeight);
        self.desLabel.frame = CGRectMake(4, self.frame.size.height - self.cmtHeight + 10, self.frame.size.width-8, self.cmtHeight-10-18);
    }
//    self.bigImageView.frame = self.bounds;
//    self.desLabel.frame = CGRectMake(0, CGRectGetMaxY(self.bigImageView.frame)+5, CGRectGetWidth(self.frame), 15);
}

@end

@interface WaterflowViewController () <BrickViewDataSource,BrickViewDelegate>
{
    float Height[2000];
    BOOL isConf;
}
@property(nonatomic,strong)BrickView * brickView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * bannerDataArray;
@property(nonatomic,strong)NSString * lastImg_id;

@end

@implementation WaterflowViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.bannerDataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.brickView = [[BrickView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-25)];
    self.brickView.padding = 4.0;
    self.brickView.clipsToBounds = YES;
    self.brickView.dataSource = self;
    self.brickView.delegate = self;
    
    [self.view addSubview:self.brickView];
    [self.brickView addHeaderWithTarget:self action:@selector(loadData)];
    [self.brickView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    
    
    [self loadData];
    [self loadBannerData];
}
-(void)loadData
{
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@", RECOMMENDAPI, [ControllerManager getSID]]);
    __block WaterflowViewController * blockSelf = self;
    
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", RECOMMENDAPI, [ControllerManager getSID]] Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            //只包含img_id和图片的url
            //            NSLog(@"宇宙广场数据:%@", load.dataDict);
            for (int i=0; i<blockSelf.dataArray.count; i++) {
                blockSelf->Height[i] = 0;
            }
            [blockSelf.dataArray removeAllObjects];
            
            
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [blockSelf.dataArray addObject:model];
                
                if ([model.cmt isKindOfClass:[NSString class]] && model.cmt.length) {
                    CGSize size = [model.cmt sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.view.frame.size.width/2-4*2, 100) lineBreakMode:1];
                    model.cmtWidth = size.width;
                    model.cmtHeight = size.height+10+18;
                    //                    NSLog(@"%f--%f--%@--%.1f--%.1f", self.view.frame.size.width/2, size.width, model.cmt, size.height, model.cmtHeight);
                }else{
                    model.cmtHeight = 0;
                }
                
//                [model release];
            }
            
            if (blockSelf.dataArray.count) {
                blockSelf.lastImg_id = [blockSelf.dataArray[blockSelf.dataArray.count-1] img_id];
            }
            
            [blockSelf.brickView reloadData];
            [blockSelf.brickView headerEndRefreshing];
        }else{
            LOADFAILED;
            [blockSelf.brickView headerEndRefreshing];
            NSLog(@"数据加载失败");
        }
    }];

}
-(void)loadMoreData
{
    if (self.dataArray.count % 10 != 0) {
        [self.brickView footerEndRefreshing];
        return;
    }
    
    NSString * str = [NSString stringWithFormat:@"img_id=%@dog&cat", self.lastImg_id];
    NSString * sig = [MyMD5 md5:str];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", RECOMMENDAPI2, self.lastImg_id, sig, [ControllerManager getSID]];
    NSLog(@"next-url:%@", url);
    __block WaterflowViewController * blockSelf = self;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                PhotoModel * model = [[PhotoModel alloc] init];
                [model setValuesForKeysWithDictionary: dict];
                [blockSelf.dataArray addObject:model];
                
                if ([model.cmt isKindOfClass:[NSString class]] && model.cmt.length) {
                    CGSize size = [model.cmt sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(blockSelf.view.frame.size.width/2-4*2, 100) lineBreakMode:1];
                    model.cmtWidth = size.width;
                    model.cmtHeight = size.height+10+18;
                }else{
                    model.cmtHeight = 0;
                }
                
            }
            blockSelf.lastImg_id = [blockSelf.dataArray[blockSelf.dataArray.count-1] img_id];
            [blockSelf.brickView reloadData];
            [blockSelf.brickView footerEndRefreshing];
        }else{
            LOADFAILED;
            [blockSelf.brickView footerEndRefreshing];
            NSLog(@"数据加载失败");
        }
    }];

}

#pragma mark - Banner
-(void)loadBannerData
{
    NSString * url = [NSString stringWithFormat:@"%@%@", BANNERAPI, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            [self.bannerDataArray removeAllObjects];
            
            if ([[load.dataDict objectForKey:@"confVersion"] isEqualToString:[USER objectForKey:@"versionKey"]]) {
                isConf = YES;
            }
            BOOL dataCorrect = [[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]] && [[[load.dataDict objectForKey:@"data"] objectAtIndex:0] isKindOfClass:[NSArray class]] && [[[load.dataDict objectForKey:@"data"] objectAtIndex:0] count];
            if (dataCorrect) {
                NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                self.bannerDataArray = [NSMutableArray arrayWithArray:array];
            }
        }else{
            LOADFAILED;
        }
    }];
}
#pragma mark - accessor
-(CGFloat)brickView:(BrickView *)brickView heightForCellAtIndex:(NSInteger)index
{
//    return 100.0f;
    
    PhotoModel * model = self.dataArray[index];
    if (Height[index] == 0) {
        if ([model.url rangeOfString:@"&"].location != NSNotFound) {
            //有尺寸的照片
            //解析照片名字，得到尺寸
            NSArray * arr1 = [model.url componentsSeparatedByString:@"_"];
            NSString * str1 = [[arr1[arr1.count-1] componentsSeparatedByString:@"."] objectAtIndex:0];
            NSArray * arr2 = [str1 componentsSeparatedByString:@"&"];
            float tempWidth = [arr2[0] floatValue];
            float tempHeight = [arr2[1] floatValue];
            model.width = self.view.frame.size.width/2-4-2;
            model.height = (model.width/tempWidth)*tempHeight;
            //            NSLog(@"%@--%f--%f--%d--%d", str1, tempWidth, tempHeight, model.width, model.height);
            if (model.cmtHeight) {
                Height[index] = model.height+model.cmtHeight;
            }else{
                Height[index] = model.height+35;
            }
            
        }else{
            //无尺寸的旧照片，查看本地是否有其照片，有取出来拿尺寸，没有就随机
            /*为了获取图片高度，如果本地有缓存图片，拿到其高度，并
             赋值，如果没有图片*/
            NSURL * URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]];
            [MyControl addSkipBackupAttributeToItemAtURL:URL];
            NSString * key = [[SDWebImageManager sharedManager] cacheKeyForURL:URL];
            SDImageCache * cache = [SDImageCache sharedImageCache];
            UIImage * image = [cache imageFromDiskCacheForKey:key];
            if (image) {
                //            Height[index] = image.size.height;
                model.width = self.view.frame.size.width/2-4-2;
                model.height = (model.width/image.size.width)*image.size.height;
                //            Height[index] = model.height;
                if(model.cmtHeight){
                    Height[index] = model.height+model.cmtHeight;
                }else{
                    Height[index] = model.height+35;
                }
                //                return Height[index];
            }else{
                if(model.cmtHeight) {
                    Height[index] = arc4random()%50+100 +model.cmtHeight+10+18;
                }else{
                    Height[index] = arc4random()%50+100 +35;
                }
            }
        }
        
        
        return Height[index];
    }else{
        return Height[index];
    }
}

-(NSInteger)numberOfColumnsInBrickView:(BrickView *)brickView
{
    return 2;
}
-(NSInteger)numberOfCellsInBrickView:(BrickView *)brickView
{
    return self.dataArray.count;
}
-(BrickViewCell *)brickView:(BrickView *)brickView cellAtIndex:(NSInteger)index
{
    static NSString * cellID = @"brick";
    DemoBrickViewCell * cell = [brickView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        NSLog(@"new alloc at index: %d", index);
        cell = [[DemoBrickViewCell alloc] initWithReuseIdentifier:cellID];
    }else{
        NSLog(@"use old at index: %d", index);
    }
    
    PhotoModel * model = self.dataArray[index];
    
    cell.cmtHeight = model.cmtHeight;
    cell.desLabel.text = model.cmt;
//     placeholderImage:[UIImage imageNamed:@"whiteBg.png"]
    cell.bigImageView.image = nil;
    
    [cell.bigImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, model.url]]];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark -
-(void)brickView:(BrickView *)brickView didSelectCell:(BrickViewCell *)cell AtIndex:(NSInteger)index
{
    NSLog(@"did select index : %d", index);
}

@end
