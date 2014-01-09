//
//  LoginRequest.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "LoginRequest.h"
#import "LoginResult.h"

@implementation LoginRequest

@synthesize data = _data;

- (id)initWithUrl:(NSString *)url{
    self = [super initWithUrl:url];
    
    if (self) {
        
    }
    
    return self;
}

- (BOOL)isLoginSuccess
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
            _data = [[LoginResult alloc] initWithJSONObject:self.responseJSON];
            
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


- (NSString *)getAccess_token
{
    if (_data)
    {
        return _data.access_token;
    }
    else
    {
        if (self.responseJSON) {
            _data = [[LoginResult alloc] initWithJSONObject:self.responseJSON];
            
            return _data.access_token;
        }
        
        return 0;
    }
}


- (NSString *)getMsg
{
    if (_data)
    {
        return _data.msg;
    }
    else
    {
        if (self.responseJSON) {
            _data = [[LoginResult alloc] initWithJSONObject:self.responseJSON];
            
            return _data.msg;
        }
        
        return 0;
    }
}

@end
