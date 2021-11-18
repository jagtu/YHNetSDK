//
//  YHBaseReq
//  YHRongYiTong
//
//  Created by jagtu on 2017/11/30.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "YHBaseReqModel.h"
#import <YHModel/YHModel.h>

@implementation YHBaseReqModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

-(void)initData
{
    self.isSign = YES;
    self.isEncrypt = @"1";
}

/**
 *  返回最终请求参数
 */
-(NSMutableDictionary *)reqParam
{
    //edit by ljt
    if (self.appId) {[self.paramBody setObject:self.appId forKey:@"appId"];}
    if (self.serviceId) {[self.paramBody setObject:self.serviceId forKey:@"serviceId"];}
    if (self.isEncrypt) {[self.paramBody setObject:self.isEncrypt forKey:@"isEncrypt"];}
    if (self.signType) {[self.paramBody setObject:self.signType forKey:@"signType"];}
    if (self.encryptType) {[self.paramBody setObject:self.encryptType forKey:@"encryptType"];}
    if (self.timestamp) {[self.paramBody setObject:self.timestamp forKey:@"timestamp"];}
    if (self.version) {[self.paramBody setObject:self.version forKey:@"version"];}
    if (self.deviceId) {[self.paramBody setObject:self.deviceId forKey:@"deviceId"];}
    if (self.termType) {[self.paramBody setObject:self.termType forKey:@"termType"];}
    if (self.appVersion) {[self.paramBody setObject:self.appVersion forKey:@"appVersion"];}
    if (self.reqId) {[self.paramBody setObject:self.reqId forKey:@"reqId"];}
    
    //重新获取sesseion id
    if (self.sessionId.length > 0) {
        [self.paramBody setObject:self.sessionId forKey:@"sessionId"];
    }
    
    [self.paramBody setObject:self.param forKey:@"param"];
    
    if (!self.isUseCustomPageParam) {
        NSMutableDictionary * pageParam;
        pageParam = [[self.pageParam yh_modelToJSONObject] mutableCopy];
        if (pageParam && pageParam.count > 0) {
            [self.paramBody setObject:pageParam forKey:@"pageParam"];
        }
    }
    
    [self addNewDefaultProperty];
    [self handleCustomPropertyMapper];
    [self filterPropertyWithBlackList];
    
    return self.paramBody;
}

-(void)handleCustomPropertyMapper
{
    if (!self.customPropertyMapper || self.customPropertyMapper.count <= 0) {return;}
    
    for (NSString *oriKey in self.customPropertyMapper) {
        
        NSString *mapKey = self.customPropertyMapper[oriKey];
        
        if ([self.paramBody objectForKey:oriKey]) {
            [self.paramBody setObject:self.paramBody[oriKey] forKey:mapKey];
            [self.paramBody removeObjectForKey:oriKey];
            continue;
        }
        
        NSMutableDictionary *pageParam = self.paramBody[@"pageParam"];
        
        if ([pageParam objectForKey:oriKey]) {
            //处理分页参数
            [pageParam setObject:pageParam[oriKey] forKey:mapKey];
            [pageParam removeObjectForKey:oriKey];
            continue;
        }
    }
}

-(void)filterPropertyWithBlackList
{
    if (!self.reqBlacklist || self.reqBlacklist.count <= 0) {return;}
    
    for (NSString *blackProperty in self.reqBlacklist) {
        if (self.customPropertyMapper[blackProperty]) {//处理映射参数
            [self.paramBody removeObjectForKey:self.customPropertyMapper[blackProperty]];
        }else{
            [self.paramBody removeObjectForKey:blackProperty];
        }
    }
}

-(void)addNewDefaultProperty
{
    if (!self.addDefaultPropertyDic || self.addDefaultPropertyDic.count <= 0) {return;}
    [self.paramBody addEntriesFromDictionary:self.addDefaultPropertyDic];
}

#pragma mark loading

-(NSMutableDictionary *)paramBody
{
    if (!_paramBody) {
        _paramBody = [NSMutableDictionary new];
    }
    return _paramBody;
}

-(NSMutableDictionary *)param
{
    if(!_param){
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}

-(YHPageParamReqModel *)pageParam
{
    if (!_pageParam) {
        _pageParam = [[YHPageParamReqModel alloc]init];
    }
    return _pageParam;
}

@end


@implementation YHPageParamReqModel

-(BOOL)isFirstPage
{
    return [self.pageNo isEqualToString:@"1"];
}

-(void)setNextPage
{
    NSInteger nextPageNo = [self.pageNo integerValue] + 1;
    self.pageNo = [NSString stringWithFormat:@"%ld",(long)nextPageNo];
}

@end
