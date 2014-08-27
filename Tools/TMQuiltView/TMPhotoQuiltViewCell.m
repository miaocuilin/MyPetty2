//
//  TMQuiltView
//
//  Created by Bruno Virlet on 7/20/12.
//
//  Copyright (c) 2012 1000memories

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//


#import "TMPhotoQuiltViewCell.h"

const CGFloat kTMPhotoQuiltViewMargin = 0;

@implementation TMPhotoQuiltViewCell

@synthesize photoView = _photoView;
@synthesize titleLabel = _titleLabel;

- (void)dealloc {
    [_photoView release], _photoView = nil;
    [_titleLabel release], _titleLabel = nil;
    
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        [self addSubview:_photoView];
    }
    return _photoView;
}

//- (UILabel *)titleLabel {
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
//        _titleLabel.textColor = [UIColor whiteColor];
//        _titleLabel.layer.masksToBounds = YES;
//        _titleLabel.layer.cornerRadius = 5;
//        _titleLabel.textAlignment = NSTextAlignmentRight;
//        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
//        _titleLabel.userInteractionEnabled = YES;
//
//        [self addSubview:_titleLabel];
//        
//        self.heart = [MyControl createImageViewWithFrame:CGRectMake(5, 5, 20, 20) ImageName:@"11-1.png"];
//        [_titleLabel addSubview:self.heart];
//        
//        
//        self.heartButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 55, 26) ImageName:@"" Target:self Action:@selector(buttonClick:) Title:nil];
//        [_titleLabel addSubview:self.heartButton];
//    }
//    return _titleLabel;
//}
-(void)configUI:(PhotoModel *)model
{
    //解析点赞者字符串，与[USER objectForKey:@"usr_id"]对比
    if(![model.likers isKindOfClass:[NSNull class]]){
        self.likersArray = [model.likers componentsSeparatedByString:@","];
        
        for(NSString * str in self.likersArray){
            if ([str isEqualToString:[USER objectForKey:@"usr_id"]]) {
                isLike = YES;
                break;
            }
        }
    }
//    NSLog(@"%@--%@", model.likers, self.likersArray);
    
    if (isLike) {

        self.heart.image = [UIImage imageNamed:@"11-2.png"];
        self.heartButton.selected = YES;
        isLike = NO;
    }
}


-(void)buttonClick:(UIButton *)button
{
    button.selected = !button.selected;
//    button.userInteractionEnabled = NO;
    
//    NSString * code = [NSString stringWithFormat:@"img_id=%@dog&cat", self.img_id];
//    NSString * sig = [MyMD5 md5:code];
    
    if (button.selected) {
        self.heart.image = [UIImage imageNamed:@"11-2.png"];
        _titleLabel.text = [NSString stringWithFormat:@"%d", [_titleLabel.text intValue]+1];
        
        //赞
//        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", LIKEAPI, self.img_id, sig, [ControllerManager getSID]];
//        NSLog(@"likeURL:%@", url);
//        
//        [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//            if (isFinish) {
//                if (![[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
//                    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"点赞失败 = =."];
//                    heart.image = [UIImage imageNamed:@"11-1.png"];
//                    _titleLabel.text = [NSString stringWithFormat:@"%d", [_titleLabel.text intValue]-1];
//                }
//            }else{
//                NSLog(@"数据请求失败");
//            }
//            button.userInteractionEnabled = YES;
//        }];
    }else{
        self.heart.image = [UIImage imageNamed:@"11-1.png"];
        _titleLabel.text = [NSString stringWithFormat:@"%d", [_titleLabel.text intValue]-1];
        
        //取消赞
//        NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", UNLIKEAPI, self.img_id, sig, [ControllerManager getSID]];
//        NSLog(@"likeURL:%@", url);
//        
//        [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//            if (isFinish) {
//                if (![[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
//                    UIAlertView * alert = [MyControl createAlertViewWithTitle:@"取消赞失败 = =."];
//                    heart.image = [UIImage imageNamed:@"11-2.png"];
//                    _titleLabel.text = [NSString stringWithFormat:@"%d", [_titleLabel.text intValue]+1];
//                }
//            }else{
//                NSLog(@"数据请求失败");
//            }
//            button.userInteractionEnabled = YES;
//        }];
    }
}

- (void)layoutSubviews {
    self.photoView.frame = CGRectInset(self.bounds, kTMPhotoQuiltViewMargin, kTMPhotoQuiltViewMargin);
//    self.titleLabel.frame = CGRectMake(kTMPhotoQuiltViewMargin+10, self.bounds.size.height - 30 - kTMPhotoQuiltViewMargin,55, 26);
}

@end
