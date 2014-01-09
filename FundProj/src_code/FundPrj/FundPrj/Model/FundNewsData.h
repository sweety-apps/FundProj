//
//  FundNewsData.h
//  FundPrj
//
//  Created by leesea on 13-11-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FundNewsData : NSObject

@property (nonatomic, copy) NSString * pubtime;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * origin;
@property (nonatomic, copy) NSString * author;
@property (nonatomic, copy) NSString * context;
@property (nonatomic, assign) NSInteger channel;

@end
