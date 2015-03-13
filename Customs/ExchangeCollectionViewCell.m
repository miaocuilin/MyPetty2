//
//  ExchangeCollectionViewCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/6.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ExchangeCollectionViewCell.h"

@implementation ExchangeCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
//    [self modifyUI];
}

-(void)configUI:(ExchangeItemModel *)model
{
    self.nameLabel.text = model.name;
    self.weightLabel.text = model.spec;
    self.priceLabel.text = model.price;
    [self.goodImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@item/%@", IMAGEURL, model.icon]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            float h = 71.0;
            float w = h*image.size.width/image.size.height;
            CGRect rect = self.goodImageView.frame;
            rect.size.width = w;
            rect.origin.x = (self.frame.size.width-w)/2.0;
            self.goodImageView.frame = rect;
        }
    }];
}
- (IBAction)exBtnClick:(id)sender {
    NSLog(@"exChange");
    self.exchange();
}

- (void)dealloc {
    [_nameLabel release];
    [_weightLabel release];
    [_exChange release];
    [_goodImageView release];
    [_priceLabel release];
    [super dealloc];
}
@end
