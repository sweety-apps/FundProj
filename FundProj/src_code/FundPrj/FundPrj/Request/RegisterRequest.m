//
//  RegisterRequest.m
//  FundPrj
//
//  Created by leesea on 13-11-18.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "RegisterRequest.h"
#import "RegisterResult.h"

@implementation RegisterRequest

@synthesize data = _data;

- (id)initWithUrl:(NSString *)url{
    self = [super initWithUrl:url];
    
    if (self) {
        
    }
    
    return self;
}

- (BOOL)isRegisterSuccess
{
    if (_data)
    {
		if (_data.retcode == 0) {
			return YES;
		}
		else {
			return NO;
		}
    }
    else
    {
        if (self.responseJSON) {
            _data = [[RegisterResult alloc] initWithJSONObject:self.responseJSON];
            
			if (_data.retcode == 0) {
				return YES;
			}
			else {
				return NO;
			}
        }
        
        return 0;
    }
}

@end
