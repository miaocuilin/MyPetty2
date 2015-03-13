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

//@synthesize photoView = _photoView;
//@synthesize titleLabel = _titleLabel;

- (void)dealloc {
//    [_photoView release], _photoView = nil;
//    [_titleLabel release], _titleLabel = nil;
    
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-35)];
//    [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-35) ImageName:@""];
//    [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-35)];
    _photoView.clipsToBounds = YES;
    [self addSubview:_photoView];
    [_photoView release];
    
    self.titleLabel = [MyControl createLabelWithFrame:CGRectMake(4, self.frame.size.height - 18, self.frame.size.width-8, 0) Font:12 Text:nil];
//    self.titleLabel.numberOfLines = 1;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
//    self.titleLabel.adjustsFontSizeToFitWidth = NO;
    
    [self addSubview:self.titleLabel];
}

-(void)configUI:(PhotoModel *)model
{
    cmtHeight = model.cmtHeight;
    cmtWidth = model.cmtWidth;
    
    NSURL * URL = [MyControl returnThumbImageURLwithName:model.url Width:[UIScreen mainScreen].bounds.size.width Height:0];

    [_photoView setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"water_white.png"]];
}


- (void)layoutSubviews {

    if (!cmtHeight) {
        self.photoView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-35);
        self.titleLabel.frame = CGRectMake(4, self.frame.size.height - 18, self.frame.size.width-8, 0);
    }else{
//        NSLog(@"%f--%f--%@", cmtHeight, cmtHeight-10-18, self.titleLabel.text);
        self.photoView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-cmtHeight);
        self.titleLabel.frame = CGRectMake(4, self.frame.size.height - cmtHeight + 10, self.frame.size.width-8, cmtHeight-10-18);
    }
//    self.titleLabel.frame = CGRectMake(kTMPhotoQuiltViewMargin+4, self.bounds.size.height - 30 - kTMPhotoQuiltViewMargin, self.frame.size.width-8, 7);
}

@end
