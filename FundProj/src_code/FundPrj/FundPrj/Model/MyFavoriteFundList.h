//
//  MyFavoriteFundList.h
//  FundPrj
//
//  Created by Lee Justin on 14-1-6.
//  Copyright (c) 2014年 leesea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFavoriteFundList : NSObject

+(MyFavoriteFundList*)sharedInstance;

- (BOOL)isFundDataReady;
- (NSArray*)getFundDataArray;
- (void)addFundCode:(NSString*)fundSymbol target:(id)target succeedSel:(SEL)suc failedSel:(SEL)fail;
- (void)removeFundCode:(NSString*)fundSymbol target:(id)target succeedSel:(SEL)suc failedSel:(SEL)fail;
- (BOOL)isExisted:(NSString*)fundSymbol;
- (void)requestMyFundData:(id)target succeedSel:(SEL)suc failedSel:(SEL)fail;

@end
