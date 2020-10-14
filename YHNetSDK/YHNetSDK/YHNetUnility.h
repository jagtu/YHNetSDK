//
//  YHNetUnility.h
//  YHNetSDK
//
//  Created by zxl on 2018/2/1.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHBaseDP.h"

FOUNDATION_EXPORT NSString * const YHNetUserAgent;//USERAGENT Flag
FOUNDATION_EXPORT NSTimeInterval YHNetTimeoutInterval;

typedef void(^YHSuccessed)(id obj);

typedef void(^YHFailed)(NSError *error);

typedef void(^YHUploadProgress)(NSProgress *uploadProgress);

typedef void(^YHDownloadProgress)(NSProgress *downloadProgress);

@interface YHNetUnility : NSObject

/**
 getRequest

 @param url url
 @param successed success
 @param failed failed
 */
+(NSURLSessionDataTask *)getRequestWithUrl:(NSString *)url
                         withRequestHeaders:(NSDictionary<NSString*,NSString*> *)headers
                 withRequestSerializerType:(YHRequestSerializerType)requestType
                 withResponeSerializerType:(YHResponeSerializerType)responeType withProgress:(YHDownloadProgress)progress
                             withSuccessed:(YHSuccessed)successed
                                withFailed:(YHFailed)failed;

/**
 postRequest

 @param url url
 @param parameters 参数
 @param successed successed
 @param failed failed
 */
+(NSArray *)postRequestWithUrl:(NSString *)url
             withRequestHeaders:(NSDictionary<NSString*,NSString*> *)headers
                withParameters:(NSDictionary *)parameters
     withRequestSerializerType:(YHRequestSerializerType)requestType
     withResponeSerializerType:(YHResponeSerializerType)responeType
                  withProgress:(YHDownloadProgress)progress
                 withSuccessed:(YHSuccessed)successed
                    withFailed:(YHFailed)failed;

/**
 posRequest withCer
 
 @param url url
 @param parameters 参数
 @param successed successed
 @param failed failed
 @param withCer boo
 @param cerFilePath 证书路径
 @return array
 */
+(NSArray *)postRequestWithUrl:(NSString *)url
             withRequestHeaders:(NSDictionary<NSString*,NSString*> *)headers
                withParameters:(NSDictionary *)parameters
     withRequestSerializerType:(YHRequestSerializerType)requestType
     withResponeSerializerType:(YHResponeSerializerType)responeType
                  withProgress:(YHDownloadProgress)progress
                 withSuccessed:(YHSuccessed)successed
                    withFailed:(YHFailed)failed
                       withCer:(BOOL)withCer
               withCerFilePath:(NSString *)cerFilePath;

/**
 postRequest(AFHTTPRequestSerializer)
 
 @param url url
 @param parameters 参数
 @param successed successed
 @param failed failed
 */
+(NSArray *)postHTTPRequestWithUrl:(NSString *)url
                withRequestHeaders:(NSDictionary<NSString*,NSString*> *)headers
                    withParameters:(NSDictionary *)parameters
                     withSuccessed:(YHSuccessed)successed
                        withFailed:(YHFailed)failed;

/**
 postRequestWithUploadFile
 
 @param url url
 @param parameters 参数
 @param files 文件，数组里为：NSURL对象或YHUploadFileModel对象
 @param progress 进度回调
 @param successed 成功回调
 @param failed 失败回调
 */
+(NSArray *)postUploadRequestWithUrl:(NSString *)url
                  withRequestHeaders:(NSDictionary<NSString*,NSString*> *)headers
                      withParameters:(NSDictionary *)parameters
           withRequestSerializerType:(YHRequestSerializerType)requestType
           withResponeSerializerType:(YHResponeSerializerType)responeType
                           withFiles:(NSArray *)files
                      uploadProgress:(YHUploadProgress)progress
                       withSuccessed:(YHSuccessed)successed
                          withFailed:(YHFailed)failed;

/**
 设置UA

 @param userAgentValue str
 */
+(void)setUserAgent:(NSString *)userAgentValue;

@end
