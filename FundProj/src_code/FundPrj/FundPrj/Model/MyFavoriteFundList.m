//
//  MyFavoriteFundList.m
//  FundPrj
//
//  Created by Lee Justin on 14-1-6.
//  Copyright (c) 2014年 leesea. All rights reserved.
//

#import "MyFavoriteFundList.h"
#import "MyFundRequest.h"
#import "FundMyAddRequest.h"
#import "CommonMacros.h"
#import "MyFundData.h"

@interface MyFavoriteFundList ()
{
    MyFundRequest* myFundRequest;
    FundMyAddRequest* addFundRequest;
    BOOL _isFundDataReady;
    id _target;
    SEL _addSucceedSel;
    SEL _addFailedSel;
    SEL _removeSucceedSel;
    SEL _removeFailedSel;
    
    id _targetFundList;
    SEL _listSucceedSel;
    SEL _listFailedSel;
}
@property (strong,nonatomic) NSMutableArray* fundDatas;
@end

static MyFavoriteFundList* gInstance = nil;

@implementation MyFavoriteFundList

@synthesize fundDatas;

- (id)init
{
    self = [super init];
    if (self) {
        self.fundDatas = [NSMutableArray array];
        _isFundDataReady = NO;
        _target = nil;
        _addSucceedSel = nil;
        _addFailedSel = nil;
        _removeSucceedSel = nil;
        _removeFailedSel = nil;
        //[self requestMyFundData];
        //[self _readFundCodes];
    }
    return self;
}

- (void)dealloc
{
    self.fundDatas = nil;
}

- (NSString*)_getSavePath
{
    NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/myfavoriteFundCodes.plist"];
    return filePath;
}

- (void)_readFundCodes
{
    NSString* filePath = [self _getSavePath];
    NSMutableArray* funds = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (funds)
    {
        self.fundDatas = funds;
    }
}

- (void)_saveFundCodes
{
    NSString* filePath = [self _getSavePath];
    [self.fundDatas writeToFile:filePath atomically:YES];
}

+(MyFavoriteFundList*)sharedInstance
{
    if (gInstance == nil)
    {
        gInstance = [[MyFavoriteFundList alloc] init];
    }
    return gInstance;
}

- (BOOL)isFundDataReady
{
    return _isFundDataReady;
}

- (NSArray*)getFundDataArray
{
    return self.fundDatas;
}

- (void)addFundCode:(NSString*)fundSymbol target:(id)target succeedSel:(SEL)suc failedSel:(SEL)fail
{
    //fundSymbol = @"240017.cn";
    if (![self isExisted:fundSymbol])
    {
        _target = target;
        _addSucceedSel = suc;
        _addFailedSel = fail;
        [self _requestAddFund:fundSymbol isAdd:YES];
    }
}

- (void)removeFundCode:(NSString*)fundSymbol target:(id)target succeedSel:(SEL)suc failedSel:(SEL)fail
{
    if ([self isExisted:fundSymbol])
    {
        _target = target;
        _removeSucceedSel = suc;
        _removeFailedSel = fail;
        [self _requestAddFund:fundSymbol isAdd:NO];
    }
}

- (void)_requestAddFund:(NSString*)fundSymbol isAdd:(BOOL)add
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, PERSONAL_MYADD];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", ACTION, add ? @"1" : @"2"]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", SYMBOL, fundSymbol]];
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"security_type", @"1"]];
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    addFundRequest = [[FundMyAddRequest alloc]initWithUrl:url];
    
	addFundRequest.delegate = self;
    
    if (add)
    {
        addFundRequest.requestDidFinishSelector = @selector(getAddFundRequestSuccess:);
        addFundRequest.requestDidFailedSelector = @selector(getAddFundRequestFailed:);
    }
    else
    {
        addFundRequest.requestDidFinishSelector = @selector(getRemoveFundRequestSuccess:);
        addFundRequest.requestDidFailedSelector = @selector(getRemoveFundRequestFailed:);
    }
    
    
    [addFundRequest sendRequest];
}

- (void) getAddFundRequestSuccess:(FundMyAddRequest *)request
{
	BOOL isRequestSuccess = [addFundRequest isRequestSuccess];
    if (isRequestSuccess) {
        if (_target )
        {
            if (_addSucceedSel)
            {
                [_target performSelector:_addSucceedSel];
            }
        }
    }
    else {
        if (_target )
        {
            if (_addFailedSel)
            {
                [_target performSelector:_addFailedSel];
            }
        }
    }
    _target = nil;
    _addSucceedSel = nil;
    _addFailedSel = nil;
}

- (void) getAddFundRequestFailed:(FundMyAddRequest *)request
{
    if (_target )
    {
        if (_addFailedSel)
        {
            [_target performSelector:_addFailedSel];
        }
    }
    _target = nil;
    _addSucceedSel = nil;
    _addFailedSel = nil;
}

- (void) getRemoveFundRequestSuccess:(FundMyAddRequest *)request
{
	BOOL isRequestSuccess = [addFundRequest isRequestSuccess];
    if (isRequestSuccess) {
        if (_target )
        {
            if (_removeSucceedSel)
            {
                [_target performSelector:_removeSucceedSel];
            }
        }
    }
    else {
        if (_target )
        {
            if (_removeFailedSel)
            {
                [_target performSelector:_removeFailedSel];
            }
        }
    }
    _target = nil;
    _removeSucceedSel = nil;
    _removeFailedSel = nil;
}

- (void) getRemoveFundRequestFailed:(MyFundRequest *)request
{
    if (_target )
    {
        if (_removeFailedSel)
        {
            [_target performSelector:_removeFailedSel];
        }
    }
    _target = nil;
    _removeSucceedSel = nil;
    _removeFailedSel = nil;
}


- (BOOL)isExisted:(NSString*)fundSymbol
{
    for (MyFundData* data in self.fundDatas)
    {
        if ([data.symbol isEqualToString:fundSymbol])
        {
            return YES;
        }
    }
    return NO;
}

- (void) getMyFundRequestSuccess:(MyFundRequest *)request
{
	BOOL isRequestSuccess = [myFundRequest isRequestSuccess];
    if (isRequestSuccess) {
        _isFundDataReady = YES;
        fundDatas = [NSMutableArray arrayWithArray:[myFundRequest getDataArray]];
        if (_targetFundList && _listSucceedSel)
        {
            [_targetFundList performSelector:_listSucceedSel];
        }
    }
    else {
        if (_targetFundList && _listFailedSel)
        {
            [_targetFundList performSelector:_listFailedSel];
        }
    }
    _targetFundList = nil;
    _listSucceedSel = nil;
    _listFailedSel = nil;
}

- (void) getMyFundRequestFailed:(MyFundRequest *)request
{
    if (_targetFundList && _listFailedSel)
    {
        [_targetFundList performSelector:_listFailedSel];
    }
    _targetFundList = nil;
    _listSucceedSel = nil;
    _listFailedSel = nil;
}

- (void)requestMyFundData:(id)target succeedSel:(SEL)suc failedSel:(SEL)fail
{
    NSString * url = [NSString stringWithFormat:@"%@%@", HOST_NAME, PERSONAL_MYFUND];
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[NSString stringWithFormat:@"%@=%@", OPENID, OPENID_VALUE]];
    [array addObject:[NSString stringWithFormat:@"%@=%@", TYPE, DATA_FORMAT]];
    if (_UI.isLogin) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"user_name", _UI.userName]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", @"access_token", _UI.loginToken]];
    }
    [array addObject:[NSString stringWithFormat:@"%@=%@", @"security_type", @"1"]];
    NSString * md5Result = [_UI md5EncParam:array];
    url = [url stringByAppendingString:md5Result];
    url = [url URLEncodedString];
    myFundRequest = [[MyFundRequest alloc]initWithUrl:url];
    
	myFundRequest.delegate = self;
    myFundRequest.requestDidFinishSelector = @selector(getMyFundRequestSuccess:);
    myFundRequest.requestDidFailedSelector = @selector(getMyFundRequestFailed:);
    
    _targetFundList = target;
    _listSucceedSel = suc;
    _listFailedSel = fail;
    
    [myFundRequest sendRequest];
}

@end
