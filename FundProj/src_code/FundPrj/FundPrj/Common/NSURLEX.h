//
//  NSURLEX.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (EX)

+ (id)URLWithStringAddingPercentEscapes:(NSString *)URLString;

- (id)initWithStringAddingPercentEscapes:(NSString *)URLString;

@end
