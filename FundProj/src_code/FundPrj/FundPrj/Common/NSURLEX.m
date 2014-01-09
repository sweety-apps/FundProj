//
//  NSURLEX.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "NSURLEX.h"

@implementation NSURL (EX)


+ (id)URLWithStringAddingPercentEscapes:(NSString *)URLString
{
    NSString * validURLString = [URLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    validURLString = [validURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (validURLString.length == 0)
    {
        return nil;
    }
    
    return [self URLWithString:validURLString];
}

- (id)initWithStringAddingPercentEscapes:(NSString *)URLString
{
    NSString * validURLString = [URLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    validURLString = [validURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (validURLString.length == 0)
    {
        self = nil;
        return nil;
    }
    
    return [self initWithString:validURLString];
}


@end
