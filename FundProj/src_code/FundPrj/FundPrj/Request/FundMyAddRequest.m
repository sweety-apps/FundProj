//
//  FundMyAddRequest.m
//  FundPrj
//
//  Created by Lee Justin on 14-1-6.
//  Copyright (c) 2014年 leesea. All rights reserved.
//

#import "FundMyAddRequest.h"

@implementation FundMyAddRequest

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
            _result = [[FundMyAddResult alloc] initWithJSONObject:self.responseJSON];
            
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

- (void) sendRequest
{
    [super sendRequestWithMethod:@"POST"];
}

@end
