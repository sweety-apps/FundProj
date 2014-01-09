//
//  SiftRequest.m
//  FundPrj
//
//  Created by leesea on 13-11-21.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "SiftRequest.h"
#import "SiftResult.h"

@implementation SiftRequest

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
            _result = [[SiftResult alloc] initWithJSONObject:self.responseJSON];
            
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
            _result = [[SiftResult alloc] initWithJSONObject:self.responseJSON];
            
            return _result.itemList;
        }
        
        return 0;
    }
}

@end
