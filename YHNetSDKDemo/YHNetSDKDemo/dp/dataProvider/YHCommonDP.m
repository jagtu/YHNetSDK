//
//  YHCommonDP.m
//  YHCommonSDK
//
//  Created by zxl on 2018/7/20.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHCommonDP.h"
#import "YHBaseReqModel.h"

//由于没有抽出用户SDK,所以该宏定义必须与 主项目里面的sessionid key一样，否则有问题。
#define YHCommonSESSIONID [NSString stringWithFormat:@"%@.%@.sessionid",[[NSBundle mainBundle] bundleIdentifier],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]

@implementation YHCommonDP

#pragma mark start

-(id)init
{
    self = [super init];
    if (self) {
        [self initData];
        
        if ([[self class] respondsToSelector:NSSelectorFromString(@"reqPropertyBlacklist")]) {
            self.reqModel.reqBlacklist = [[self class] reqPropertyBlacklist];
        }
        
        if ([[self class] respondsToSelector:NSSelectorFromString(@"reqSignIgnorePropertylist")]) {
            self.reqModel.signBlackList = [[self class] reqSignIgnorePropertylist];
        }
        
        if ([[self class] respondsToSelector:NSSelectorFromString(@"addDefaultProperty")]) {
            self.reqModel.addDefaultPropertyDic = [[self class] addDefaultProperty];
        }
        
        if ([[self class] respondsToSelector:NSSelectorFromString(@"reqCustomPropertyMapper")]) {
            self.reqModel.customPropertyMapper = [[self class] reqCustomPropertyMapper];
        }
        
        if ([[self class] respondsToSelector:NSSelectorFromString(@"reqCustomEncryptPropertyMapper")]) {
            self.reqModel.customEncryptPropertyMapper = [[self class] reqCustomEncryptPropertyMapper];
        }
        
        if ([[self class] respondsToSelector:NSSelectorFromString(@"reqCustomDecryptPropertyMapper")]) {
            self.reqModel.customDecryptPropertyMapper = [[self class] reqCustomDecryptPropertyMapper];
        }
    }
    return self;
}

/**
 * 子类需重写该方法，设置参数
 */
-(void)initData
{
    self.host = @"";
    self.path = @"";
    
//    self.reqModel.appId = YHDefaultAppId;
//    self.reqModel.appSecret = YHDefaultAppSecret;
//    self.reqModel.encryptType = YHDefaultEncryptType;
//    self.reqModel.signType = YHDefaultSignType;
//    self.reqModel.isEncrypt = YHDefaultIsEncrypt;
//    self.reqModel.version = YHDefaultInterfaceVersion;//edit by ljt 此参数是接口版本号，不是app的版本号
//    self.reqModel.appVersion = [YHDeviceHelper getBundleVersion];//e.g:2894
//    self.reqModel.timestamp = [NSDate getTimeStampString];
//    self.reqModel.deviceId = [YHCommonHelper getDeviceId];
}

-(void)setParam
{
    //每次都刷新 sessionid,避免初始化时候获取到过期sessionid不再更新
    [self refreshParam];
}

/**
 新组件需要重写以下方法
 解决多组件多域名问题
 @return url
 */
-(NSString *)getFullUrl;
{
    return [NSString stringWithFormat:@"%@%@",self.host,self.path];
}

-(NSMutableDictionary *)getParam
{
    return [self.reqModel reqParam];
}

-(NSMutableDictionary *)decryptData:(NSMutableDictionary *)responeObj
{
    return responeObj;
}

#pragma mark lazy loading
-(YHBaseReqModel *)reqModel
{
    if (!_reqModel) {
        _reqModel = [[YHBaseReqModel alloc] init];
    }
    return _reqModel;
}

#pragma mark method acton order
- (void)setObject:(id)anObject forKey:(NSString *)aKey
{
    if (anObject == nil || aKey == nil) {
        return;
    }
    [self.reqModel.param setObject:anObject forKey:aKey];
}

-(void)actionAfterFailed:(NSError *)error
{
}

-(void)refreshParam
{
}

+ (nullable NSArray<NSString *> *)reqPropertyBlacklist
{
    return nil;
}

+ (nullable NSDictionary<NSString *, NSString *> *)reqCustomPropertyMapper
{
    return nil;
}

+ (nullable NSDictionary *)addDefaultProperty
{
    return nil;
}

+ (nullable NSArray<NSString *> *)reqSignIgnorePropertylist
{
    return @[@"sign", @"encryptData", @"externalMap", @"pageParam"];
}

+ (nullable NSDictionary<NSString *, NSString *> *)reqCustomEncryptPropertyMapper
{
    return @{@"param":@"encryptData"};
}

+ (nullable NSDictionary<NSString *, NSString *> *)reqCustomDecryptPropertyMapper
{
    return @{@"encryptData":@"param"};
}

@end
