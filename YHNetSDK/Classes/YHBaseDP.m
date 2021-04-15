//
//  YHBaseDP.m
//  YHNetSDK
//  base data provider
//  Created by zxl on 2018/2/1.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseDP.h"
#import "YHNetUnility.h"

@interface YHBaseDP()

@end

@implementation YHBaseDP

-(id)initWithHandle: (id<YHNetProtocol>) netHandle
{
    self = [self init];
    if (self) {
        self.netHandle = netHandle;
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.firstLoad = YES;
    }
    return self;
}

- (void)setObject:(id)anObject forKey:(NSString *)aKey
{
    if (anObject == nil || aKey == nil) {
        return;
    }
}

-(BOOL)isEmpty
{
    return YES;
}

-(BOOL)hasNextPage
{
    return YES;
}

-(void)setLoadingView
{
}

-(void)removeLoadingView
{
}


/**
 设置接口请求网址
 */
-(NSString *)getFullUrl;
{
    self.host = @"";
    self.path = @"";
    return [NSString stringWithFormat:@"%@/%@",self.host,self.path];
}

#pragma mark 设置接口服务名称及业务参数

-(NSMutableDictionary *)getParam
{
    return [NSMutableDictionary new];
}

-(void)setParam
{
}

#pragma mark 加载数据时候动作
-(BOOL)shouldStart
{
    //防止重复请求
    if (self.isLoading) {
        return NO;
    }
    return YES;
}

-(void)actionBeforeStart
{
    
}

#pragma mark requred 子类必须实现
-(void)parseJsonData:(NSMutableDictionary *)responeObj
{
    
}

-(NSMutableDictionary *)decryptData:(NSMutableDictionary *)responeObj
{
    return responeObj;
}

#pragma mark option 可选
-(void)actionAfterParseData
{
    
}

-(void)actionAfterFailed:(NSError *)error
{
    
}

#pragma mark start

-(void)start
{
    if (![self shouldStart]) {
        return;
    }
    [self actionBeforeStart];
    
    if (!self.hideLoadingview) {
        [self setLoadingView];
    }
    
    [self setParam];
    
    [self setDPStatusBeforeRequest];
    
    self.tasks = [YHNetUnility postRequestWithUrl:[self getFullUrl] withParameters:[self getParam] withSuccessed:^(id obj) {
        
        if (!self.hideLoadingview) {
            [self removeLoadingView];
        }
        
        [self setLoadStatus];
        [self parseJsonData:[self decryptData:obj]];
        [self setDPStatusWhenSuccessed];
        [self actionAfterParseData];
        if (self.netHandle && [self.netHandle respondsToSelector:@selector(netByDP:doWhenSuccess:)]) {
            [self.netHandle netByDP:self doWhenSuccess:obj];
        }
        
    } withFailed:^(NSError * error) {
        
        [self removeLoadingView];
        [self setDPStatusWhenFailed];
        
        //当网络状态为主动时候取消，转为为不执行action.
        
        BOOL enableFailedAction = YES;
        if ([self isCancelled:error]) {
            enableFailedAction = NO;
        }
        
        if (self.enableFailedActionWhenCancelRequest) {
            //默认为NO
            enableFailedAction = YES;
        }
        
        if (enableFailedAction) {
            
            [self actionAfterFailed:error];
            if (self.netHandle && [self.netHandle respondsToSelector:@selector(netByDP:doWhenFailed:)]) {
                [self.netHandle netByDP:self doWhenFailed:error];
            }
        }
        
    } withCer:self.isWithCer withCerFilePath:self.cerFilePath];
}


-(void)setDPStatusBeforeRequest
{
    self.isLoading = YES;
}

-(void)setLoadStatus
{
    //只有请求成功过，就变成No,此后不再变
    self.firstLoad = NO;
    self.isLoading = NO;
}

-(void)setDPStatusWhenSuccessed
{
    
}

-(void)setDPStatusWhenFailed
{
    self.isLoading = NO;
}

-(void)cancelDP
{
    [self cancelAllDP];
}

-(void)cancelAllDP
{
    [self setDPStatusWhenFailed];
    if (self.tasks.count > 0) {
        [self.tasks makeObjectsPerformSelector:@selector(cancel)];
    }
}

/**
 error.code = -999
 状态为主动取消网络请求
 */

-(BOOL)isCancelled:(NSError *)error
{
    return error.code == NSURLErrorCancelled;
}

-(void)restart
{
    [self cancelDP];
    [self start];
}

@end
