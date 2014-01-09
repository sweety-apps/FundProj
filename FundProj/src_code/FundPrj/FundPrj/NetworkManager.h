//
//  NetworkManager.h
//  FundPrj
//
//  Created by leesea on 13-10-22.
//  Copyright (c) 2013年 leesea. All rights reserved.
//
#import "Reachability.h"

@interface FPNetworkManager : NSObject
{
    Reachability * _reachability;
    
    NSMutableArray * _networkObservers;
}

- (void)addNetworkObserver:(id)observer;
- (void)removeNetworkObserver:(id)observer;

// 查询当前网络状态
- (NSInteger)getNetworkStatus;

@end


@protocol FPNetworkChangeDelegate <NSObject>

@optional
- (void)onNetworkChange:(NSInteger)nNetworkStatus descriptionDetail:(NSString*)descriptionDetail;

@end
