//
//  FundCompanyRequest.m
//  FundPrj
//
//  Created by leesea on 13-11-25.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundCompanyRequest.h"
#import "FundCompanyResult.h"

@implementation FundCompanyRequest

@synthesize result = _result;

- (id)initWithUrl:(NSString *)url{
    self = [super initWithUrl:url];
    
    if (self) {
        
    }
    
    return self;
}

- (BOOL)isRequestSuccess
{
    if (_result)
    {
		if (_result.retcode == 0) {
			return YES;
		}
		else {
			return NO;
		}
    }
    else
    {
        if (self.responseJSON) {
            _result = [[FundCompanyResult alloc] initWithJSONObject:self.responseJSON];
            
			if (_result.retcode == 0) {
				return YES;
			}
			else {
				return NO;
			}
        }
        
        return 0;
    }
}


- (NSMutableArray *)getDataArray
{
    if (_result)
    {
        return _result.itemList;
    }
    else
    {
        if (self.responseJSON) {
            _result = [[FundCompanyResult alloc] initWithJSONObject:self.responseJSON];
            
            return _result.itemList;
        }
        
        return 0;
    }
}

@end
