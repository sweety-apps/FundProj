//
//  FundDetailInfoRequst.m
//  FundPrj
//
//  Created by leesea on 13-12-2.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "FundDetailInfoRequst.h"
#import "FundDetailInfoResult.h"

@implementation FundDetailInfoRequst

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
            _result = [[FundDetailInfoResult alloc] initWithJSONObject:self.responseJSON];
            
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


- (FundDetailInfoData *)getData
{
    if (_result)
    {
        return _result.objData;
    }
    else
    {
        if (self.responseJSON) {
            _result = [[FundDetailInfoResult alloc] initWithJSONObject:self.responseJSON];
            
            return _result.objData;
        }
        
        return 0;
    }
}

@end
