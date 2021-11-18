//
//  YHCommonDP.h
//  YHCommonSDK
//
//  Created by zxl on 2018/7/20.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <YHNetSDK/YHNetSDK.h>
#import <YHModel/YHModel.h>

@class YHBaseReqModel;

@interface YHCommonDP : YHBaseLoadMoreDP

/**
 参数容器
 */
@property(nonatomic,strong,nonnull)YHBaseReqModel * reqModel;

/**
 * 初始化参数
 * 子类需重写该方法
 */
-(void)initData;

/**
 刷新动态参数
 */
-(void)refreshParam;


/**
 黑名单中参数将会从请求参数中过滤掉。

 @return 请求参数黑名单
 */
+ (nullable NSArray<NSString *> *)reqPropertyBlacklist;


/**
 忽略名单中参数将会在签名时从请求参数中过滤掉。
 
 @return 请求参数签名忽略名单
 */
+ (nullable NSArray<NSString *> *)reqSignIgnorePropertylist;

/**
 默认请求参数映射。
 当接口设计请求字段名和YHBaseReqModel定义的字段名不一致，请实现以下方法。
 
 eg：
 后端接口请求数据:
     {
         signType = "MD5",
         pageParam = {
             pageNum = "2",
             pageCount = "10",
         },
         encipheerType = "AES",
         encryptData = "4E9BA322ABF2DEB4A41C1EDF0015FFEC221E0ECD945FC3109E560FEA2E74BD2633635404E5DBDFF8FC232FE61B4C9AFF7C5A53A5B38608ED2375FE540EE5B2A0DBC1FF1B0F4EE9A7E7E814F16D0D62ED1662CF2C9EB0E0D6BD90D5652F16DE549AD574BD28D3BB2D12F061CCD7AC4823B6009EF78AC39270103BC82E78A182617A80DE4D0721852343172CFF81C58B172094CC9886F65AD5186BEC0743EEC272E3B8277C2B9D84F69EB644494CD962F1EBD18AF1EE36FF257C5B8D0CB2443288",
         version = "1.3.8",
         param = {
         },
         timestamp = "20181112102456135",
         transType = "app.merch.login",
         sign = "5D9F83CFE6BCABD1DC02D13925AF4C59"
     }
 
 @implementation YHCommonDP
 + (nullable NSDictionary<NSString *, NSString *> *)reqCustomPropertyMapper{
     return @{@"serviceId"  : @"transType",
              @"encryptType" : @"encipheerType",
              @"pageNo"  : @"pageNum",
              @"pageSize" : @"pageCount",};
 }
 @end

 @return 请求参数映射。
 */
+ (nullable NSDictionary<NSString *, NSString *> *)reqCustomPropertyMapper;

/**
 新增默认请求参数。
 
 @return 新增的请求参数。
 */
+ (nullable NSDictionary *)addDefaultProperty;

/**
 加密参数映射。
 请求参数中需要进行加密的参数与加密后参数的映射
 eg: @{@"param":@"encryptData"}，对参数param加密之后赋给encryptData
@return 加密参数映射。
*/
+ (nullable NSDictionary<NSString *, NSString *> *)reqCustomEncryptPropertyMapper;

/**
 解密参数映射。
 解密参数中需要进行加密的参数与加密后参数的映射
 eg: @{@"param":@"encryptData"}，对参数param加密之后赋给encryptData
 @return 加密参数映射。
 */
+ (nullable NSDictionary<NSString *, NSString *> *)reqCustomDecryptPropertyMapper;

@end
