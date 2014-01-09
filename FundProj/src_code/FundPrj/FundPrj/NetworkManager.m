//
//  NetworkManager.m
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//

#import "NetworkManager.h"


@interface FPNetworkManager ()

// 网络状态变化的通知
- (void)handleNetworkChange:(NSNotification *)notice;

@end


#pragma mark - FPNetworkManager

@implementation FPNetworkManager

- (id)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector: @selector(handleNetworkChange:)
                                                     name: kReachabilityChangedNotification
                                                   object: nil];

        _reachability = [Reachability reachabilityForInternetConnection];
        [_reachability startNotifier];
        
        _networkObservers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    _reachability = nil;
    _networkObservers = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
}

// 网络状态变化的通知
- (void)handleNetworkChange:(NSNotification *)notice
{
    // 收到网络变化通知后，立即查询当前网络状态
    NetworkStatus status = [_reachability currentReachabilityStatus]; 
    NSInteger nNetworkStatus = status;
    
    // 将网络变化信息通知到各observer
    for (int i = 0; i < _networkObservers.count; ++i)
    {
        id<FPNetworkChangeDelegate> observer = [_networkObservers objectAtIndex:i];
        if ([observer respondsToSelector:@selector(onNetworkChange:descriptionDetail:)]) {
            [observer onNetworkChange:nNetworkStatus descriptionDetail:nil];
        }
    }
}

// 查询当前网络状态
- (NSInteger)getNetworkStatus
{
    NetworkStatus status = [_reachability currentReachabilityStatus]; 
    NSInteger nNetworkStatus = status;
    return nNetworkStatus;
}

- (void)addNetworkObserver:(id)observer
{
    NSUInteger index = [_networkObservers indexOfObject:observer];
    if (index == NSNotFound) {
        [_networkObservers addObject:observer];
    }
}

- (void)removeNetworkObserver:(id)observer
{
    [_networkObservers removeObject:observer];
}


@end
