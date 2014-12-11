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
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
      self = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeCollectionViewCell" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}

-(void)configUI:(ExchangeItemModel *)model
{
    self.nameLabel.text = model.name;
    self.weightLabel.text = model.spec;
    self.priceLabel.text = model.price;
    [self.goodImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@item/%@", IMAGEURL, model.icon]]];
}
- (IBAction)exBtnClick:(id)sender {
    NSLog(@"exChange");
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
