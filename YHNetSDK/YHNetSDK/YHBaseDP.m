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

-(id)initWithHandle: (id<YHNetProtocol>) netHandle{
    return [self initWithHandle:netHandle withLoadViweHandle:nil];
}

-(id)initWithHandle:(id<YHNetProtocol>)netHandle withLoadViweHandle:(id<YHLoadingViewProtocol>)loadingviewHandle{
    self = [self init];
    if (self) {
        self.netHandle = netHandle;
        self.loadingViewHandle = loadingviewHandle;
    }
    return self;
}

-(id _Nullable )initWithSuccBlock:(YHNetResponeBlock _Nullable )succedBlock
                  withFailedBlock:(YHNetResponeBlock _Nullable )failedBlock
         withShowLoadingViewBlock:(YHLoadingViewBlock _Nullable )showBlock
         withDissLoadingViewBlock:(YHLoadingViewBlock _Nullable )dissBlock{
    
    self = [self init];
    if (self) {
        self.succedBlock = succedBlock;
        self.failedBlock = failedBlock;
        self.showBlock = showBlock;
        self.dissBlock = dissBlock;
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        self.firstLoad = YES;
        self.requestSerializerType = YHRequestSerializerJson;
        self.responeSerializerType = YHResponeSerializerJson;
    }
    return self;
}

- (void)setObject:(id)anObject forKey:(NSString *)aKey{
    if (anObject == nil || aKey == nil) {
        return;
    }
}

-(BOOL)isEmpty{
    return YES;
}

-(BOOL)hasNextPage{
    return YES;
}

-(void)setLoadingView{
}

-(void)removeLoadingView{
}

/**
 设置接口请求网址
 */
-(NSString *)getFullUrl{
    self.host = @"";
    self.path = @"";
    return [NSString stringWithFormat:@"%@/%@",self.host,self.path];
}

#pragma mark 设置接口服务名称及业务参数

-(NSMutableDictionary *)getParam{
    return [NSMutableDictionary new];
}

-(NSMutableDictionary *)getHeaders{
    return self.requestHeaders;
}

-(void)setParam{
}

#pragma mark 加载数据时候动作
-(BOOL)shouldStart{
    //防止重复请求
    if (self.isLoading) {
        return NO;
    }
    return YES;
}

-(void)actionBeforeStart{
    
}

#pragma mark requred 子类必须实现
-(void)parseJsonData:(NSMutableDictionary *)responeObj{
    
}

-(NSMutableDictionary *)decryptData:(NSMutableDictionary *)responeObj{
    return responeObj;
}

#pragma mark option 可选
-(void)actionAfterParseData{
    
}

-(void)actionAfterFailed:(NSError *)error{
    
}

#pragma mark start

-(void)start{
    if (![self shouldStart]) {
        return;
    }
    
    [self actionBeforeSendRequest];
    
    if (self.requestMethodType == YHRequestMethodPost) {
        
        [self requestForPost];
    }else{
        [self requestForGet];
    }
}

-(void)setDPStatusBeforeRequest{
    @synchronized (self) {
        self.isLoading = YES;
    }
}

-(void)setLoadStatus{
    //只有请求成功过，就变成No,此后不再变
    @synchronized (self) {
        self.firstLoad = NO;
        self.isLoading = NO;
    }
}

-(void)setDPStatusWhenSuccessed{

}

-(void)setDPStatusWhenFailed{
    @synchronized (self) {
        self.isLoading = NO;
    }
}

-(void)cancelDP{
    [self cancelAllDP];
}

-(void)cancelAllDP{
    [self setDPStatusWhenFailed];
    if (self.tasks.count > 0) {
        [self.tasks makeObjectsPerformSelector:@selector(cancel)];
    }
}

/**
 error.code = -999
 状态为主动取消网络请求
 */

-(BOOL)isCancelled:(NSError *)error{
    return error.code == NSURLErrorCancelled;
}

-(void)restart{
    [self cancelDP];
    [self start];
}

#pragma mark - lazy loading

-(NSMutableDictionary *)requestHeaders{
    if (!_requestHeaders) {
        _requestHeaders = [[NSMutableDictionary alloc] init];
    }
    return _requestHeaders;
}

#pragma mark - acton

/// 显示loadView
-(void)showLoadingView{
    
    if (!self.hideLoadingview) {
        if (self.loadingViewHandle && [self.loadingViewHandle respondsToSelector:@selector(actionWhenShowLoadingViewWithDP:)]) {
            [self.loadingViewHandle actionWhenShowLoadingViewWithDP:self];
        }else{
            [self setLoadingView];
        }
        if (self.showBlock) {
            self.showBlock(self);
        }
    }
}

/// 移除loadingView
-(void)dismissLoadingView{
    
    if (self.loadingViewHandle && [self.loadingViewHandle respondsToSelector:@selector(actionWhenDismissLoadingViewWithDP:)]) {
        [self.loadingViewHandle actionWhenDismissLoadingViewWithDP:self];
    }else{
        [self removeLoadingView];
    }
    
    if (self.dissBlock) {
        self.dissBlock(self);
    }
}

-(void)actionBeforeSendRequest{
    
    [self actionBeforeStart];
    
    [self showLoadingView];
    
    [self setParam];
    
    [self setDPStatusBeforeRequest];
}

-(void)continueActionAfterRequestSuccessWithObj:(id)obj{
    
    [self dismissLoadingView];
    [self setLoadStatus];
    [self parseJsonData:[self decryptData:obj]];
    [self setDPStatusWhenSuccessed];
    [self actionAfterParseData];
    if (self.netHandle && [self.netHandle respondsToSelector:@selector(netByDP:doWhenSuccess:)]) {
        [self.netHandle netByDP:self doWhenSuccess:obj];
    }
    
    if (self.succedBlock) {
        self.succedBlock(self, obj, nil);
    }
}

-(void)continueActionAfterRequestFailedWithError:(NSError *)error{
    [self dismissLoadingView];
    
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
        
        if (self.failedBlock) {
            self.failedBlock(self, nil, error);
        }
    }
}

-(void)requestForPost{
    YHNetWeakifySelf;
    self.tasks = [YHNetUnility postRequestWithUrl:[self getFullUrl]
                               withRequestHeaders:[self getHeaders]
                                   withParameters:[self getParam]
                        withRequestSerializerType:self.requestSerializerType
                        withResponeSerializerType:self.responeSerializerType
                                     withProgress:^(NSProgress *downloadProgress) {
        YHNetStrongifySelf;
        self.downloadProgress = downloadProgress;
    } withSuccessed:^(id obj) {
        YHNetStrongifySelf;
        [self continueActionAfterRequestSuccessWithObj:obj];
    } withFailed:^(NSError *error) {
        YHNetStrongifySelf;
        [self continueActionAfterRequestFailedWithError:error];
    }];
}

-(void)requestForGet{
    YHNetWeakifySelf;
    NSURLSessionDataTask *task = [YHNetUnility getRequestWithUrl:[self getFullUrl]
                                              withRequestHeaders:[self getParam]
                                       withRequestSerializerType:self.requestSerializerType
                                       withResponeSerializerType:self.responeSerializerType
                                                    withProgress:^(NSProgress *downloadProgress) {
        YHNetStrongifySelf;
        self.downloadProgress = downloadProgress;
    } withSuccessed:^(id obj) {
        YHNetStrongifySelf;
        [self continueActionAfterRequestSuccessWithObj:obj];
    } withFailed:^(NSError *error) {
        YHNetStrongifySelf;
        [self continueActionAfterRequestFailedWithError:error];
    }];
    
    self.tasks = [[NSArray alloc] initWithObjects:task, nil];
}

@end
