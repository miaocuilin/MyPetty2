//
//  TipsView.m
//  MyPetty
//
//  Created by zhangjr on 14-9-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "TipsView.h"
typedef enum SIDE{
    LEFT = 0,
    RIGHT = 1,
    UP=2
}SIDE;

@implementation TipsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self createUI:REGISTER];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame tipsName:(TIPSNAME)tipsName
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createUI:tipsName];
    }
    return self;
}
- (void)createUI:(TIPSNAME)tipsName
{
    [self blackBackGround];
    
    tipsImageView = [MyControl createImageViewWithFrame:CGRectMake(self.bounds.size.width/2-120,160, 240, 110) ImageName:@"bubble.png"];
    tipsImageView.alpha = 0.0;
    [self addSubview:tipsImageView];
    
    UILabel *descLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 240, 110) Font:12 Text:nil];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = BGCOLOR;
    descLabel.text = [self TipsDescription:tipsName];
    [tipsImageView addSubview:descLabel];
    
    UIImageView *catImageView = [MyControl createImageViewWithFrame:CGRectMake(-70, self.bounds.size.height/2-28, 70, 56) ImageName:@"tipscat.png"];
    [self addSubview:catImageView];
    UIImageView *dogImageView = [MyControl createImageViewWithFrame:CGRectMake(self.bounds.size.width+62, self.bounds.size.height/2-28, 62, 56) ImageName:@"tipsdog.png"];
    [self addSubview:dogImageView];

    [self animationImageView:dogImageView side:RIGHT];
    [self animationImageView:catImageView side:LEFT];
    
}
- (NSString *)TipsDescription:(TIPSNAME)tipsName
{
    NSString *string = nil;
    switch (tipsName) {
        case REGISTER:
            string = @"地球人，您还木有注册呢~\n飞船马上起飞\n办理手续走起啊~";
            break;
        case JOINCOUNTRY:
            string = @"你是否愿意无论是顺境或逆境，\n富裕或贫穷，健康或疾病，快乐或忧愁，\n你都将毫无保留地爱Ta，对Ta忠诚\n直到永远么？";
            break;
        case EXITCOUNTRY:
            string = @"亲爱的，真的忍心退出国家么？\n你舍得放弃你的一切么？\n感觉不会再爱了~";
            break;
        case ATTENTION:
            string = @"\n\n";
            break;
        case EXITATTENTION:
            string = @"亲爱的，真的忍心取消关注我么？\n这是真的么~\n是么~";
            break;
    }
    return string;
}
- (void)blackBackGround
{
    UIView *alpaView = [MyControl createViewWithFrame:self.frame];
    alpaView.backgroundColor = [UIColor blackColor];
    alpaView.alpha = 0.6;
    [self addSubview:alpaView];
}
- (void)animationImageView:(UIImageView *)imageView side:(SIDE)side
{
    
    [UIView beginAnimations:@"Slide Around" context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(viewAnimationDone:)];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    CGPoint center = [imageView center];
    if (side == LEFT) {
        center.x = self.bounds.size.width/2-35;
    }else if (side == RIGHT){
        center.x = self.bounds.size.width/2+32;
    }else if (side == UP){
        imageView.alpha = 1.0;
    }
    [imageView setCenter:center];
    [UIView commitAnimations];
}
- (void)viewAnimationDone:(NSString *)name
{
    NSLog(@"name:%@",name);
    [UIView animateWithDuration:1.0 animations:^{
        tipsImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        nil;
    }];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
