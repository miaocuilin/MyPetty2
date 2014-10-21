//
//  popularityListModel.h
//  MyPetty
//
//  Created by zhangjr on 14-9-9.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface popularityListModel : NSObject
@property (nonatomic,copy)NSString *aid;
@property (nonatomic,copy)NSString *t_rq;
@property (nonatomic,copy)NSString *d_rq;
@property (nonatomic,copy)NSString *w_rq;
@property (nonatomic,copy)NSString *m_rq;
@property (nonatomic,copy)NSString *type;

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *tx;
@property (nonatomic,assign)NSInteger vary;

@property (nonatomic,copy)NSString *usr_id;
@property (nonatomic,copy)NSString *t_contri;
@property (nonatomic,copy)NSString *d_contri;
@property (nonatomic,copy)NSString *w_contri;
@property (nonatomic,copy)NSString *m_contri;


@end
