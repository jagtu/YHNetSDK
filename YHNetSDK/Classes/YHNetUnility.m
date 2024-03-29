//
//  YHNetUnility.m
//  YHNetSDK
//
//  Created by zxl on 2018/2/1.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHNetUnility.h"
#import "YHUploadFileModel.h"
#import <AFNetworking/AFNetworking.h>

NSString * const YHNetUserAgent = @"YHNetUserAgent";
NSTimeInterval YHNetTimeoutInterval = 60.0;

static AFHTTPSessionManager *sharedInstance = nil;

@implementation YHNetUnility

+(NSURLSessionDataTask *)getRequestWithUrl:(NSString *)url
                         withRequestHeaders:(NSDictionary<NSString *,NSString *> *)headers withRequestSerializerType:(YHRequestSerializerType)requestType withResponeSerializerType:(YHResponeSerializerType)responeType withProgress:(YHDownloadProgress)progress withSuccessed:(YHSuccessed)successed withFailed:(YHFailed)failed{
    
    AFHTTPSessionManager *manager = [self getNetManagerwithRequestSerializerType:requestType
                                                       withResponeSerializerType:responeType];
    
    NSAssert([manager respondsToSelector:@selector(GET:parameters:headers:progress:success:failure:)], @"请升级AFNetworking至4.0以上版本，或者使用低版本YHNetSDK(1.0)");
    
    NSURLSessionDataTask * task;
    
    task = [manager GET:url parameters:nil headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        successed ? successed(responseObject) : NULL;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        if (failed) {
            failed(error);
        }
    }];
    return task;
}

+(NSArray *)postRequestWithUrl:(NSString *)url
        withRequestHeaders:(NSDictionary<NSString*,NSString*> *) headers
           withParameters:(NSDictionary *)parameters
withRequestSerializerType:(YHRequestSerializerType)requestType
withResponeSerializerType:(YHResponeSerializerType)responeType
             withProgress:(YHDownloadProgress)progress
            withSuccessed:(YHSuccessed)successed
               withFailed:(YHFailed)failed
{
    AFHTTPSessionManager *manager = [self getNetManagerwithRequestSerializerType:requestType
                                                       withResponeSerializerType:responeType];
    
    [self postWithManager:manager
                  withUrl:url
           withParameters:parameters
       withRequestHeaders:headers
            withSuccessed:successed
               withFailed:failed
                 progress:progress];
    return manager.tasks;
}

+(NSArray *)postRequestWithUrl:(NSString *)url
            withRequestHeaders:(NSDictionary<NSString*,NSString*> *) headers
                withParameters:(NSDictionary *)parameters
     withRequestSerializerType:(YHRequestSerializerType)requestType
     withResponeSerializerType:(YHResponeSerializerType)responeType
                       withCer:(BOOL)withCer
               withCerFilePath:(NSString *)cerFilePath
           withTimeoutInterval:(NSTimeInterval)timeoutInterval
                  withProgress:(YHDownloadProgress)progress
                 withSuccessed:(YHSuccessed)successed
                    withFailed:(YHFailed)failed
{
    AFHTTPSessionManager *manager = [self getNetManagerWithCer:withCer withCerFilePath:cerFilePath withUrlString:url withTimeoutInterval:timeoutInterval withRequestSerializerType:requestType withResponeSerializerType:responeType];
    
    [self postWithManager:manager
                  withUrl:url
           withParameters:parameters
       withRequestHeaders:headers
            withSuccessed:successed
               withFailed:failed
                 progress:progress];
    
    return manager.tasks;
}

+(NSArray *)postHTTPRequestWithUrl:(NSString *)url
                withRequestHeaders:(NSDictionary<NSString*,NSString*> *)headers
                    withParameters:(NSDictionary *)parameters
                     withSuccessed:(YHSuccessed)successed
                        withFailed:(YHFailed)failed{
    NSURL *baseURL = nil;
    if ([[url uppercaseString] hasPrefix:@"HTTPS://"]) {
        NSString * baseURLString = url;
        if ([[url substringFromIndex:8] rangeOfString:@"/"].location!=NSNotFound) {
            baseURLString = [url substringToIndex:8+[[url substringFromIndex:8] rangeOfString:@"/"].location];
        }
        baseURL = [NSURL URLWithString:baseURLString];
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    manager.securityPolicy =  [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = YHNetTimeoutInterval;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [self postWithManager:manager
                  withUrl:url
           withParameters:parameters
       withRequestHeaders:headers
            withSuccessed:successed
               withFailed:failed
                 progress:nil];
    return manager.tasks;
}


+(NSArray *)postWithManager:(AFHTTPSessionManager *)manager
                    withUrl:(NSString *)url
             withParameters:(NSDictionary *)parameters
         withRequestHeaders:(NSDictionary<NSString*,NSString*> *)headers
              withSuccessed:(YHSuccessed)successed
                 withFailed:(YHFailed)failed
                   progress:(nullable void (^)(NSProgress *uploadProgress))progressHander
{
    NSAssert([manager respondsToSelector:@selector(POST:parameters:headers:progress:success:failure:)], @"请升级AFNetworking至4.0以上版本，或者使用低版本YHNetSDK(1.0)");
    
    [manager POST:url parameters:parameters headers:headers progress:^(NSProgress * _Nonnull uploadProgress){
        
        if (progressHander) {
            progressHander(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successed) {
            successed(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failed) {
            failed(error);
        }
    }];
    
    return manager.tasks;
}

+(NSArray *)postUploadRequestWithUrl:(NSString *)url
                  withRequestHeaders:(NSDictionary<NSString*,NSString*> *)headers
                      withParameters:(NSDictionary *)parameters
           withRequestSerializerType:(YHRequestSerializerType)requestType
           withResponeSerializerType:(YHResponeSerializerType)responeType
                           withFiles:(NSArray *)files
                      uploadProgress:(YHUploadProgress)progressB
                       withSuccessed:(YHSuccessed)successed
                          withFailed:(YHFailed)failed{
    AFHTTPSessionManager *manager = [self getNetManagerwithRequestSerializerType:requestType
    withResponeSerializerType:responeType];
    
    NSAssert([manager respondsToSelector:@selector(POST:parameters:headers:constructingBodyWithBlock:progress:success:failure:)], @"请升级AFNetworking至4.0以上版本，或者使用低版本YHNetSDK(1.0)");

    [manager POST:url
       parameters:parameters
          headers:headers
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (id file in files) {
            NSAssert(([file isKindOfClass:[YHUploadFileModel class]] || [file isKindOfClass:[NSURL class]]), @"file type error. NSURL or YHUploadFileModel");
            if ([file isKindOfClass:[YHUploadFileModel class]]) {
                
                YHUploadFileModel *fmodel = (YHUploadFileModel *)file;
                if (fmodel.fileData) {
                    [formData appendPartWithFileData:fmodel.fileData name:fmodel.name fileName:fmodel.fileName mimeType:fmodel.mimeType];
                }else if(fmodel.fileURL){
                    NSError * error = nil;
                    BOOL append = NO;
                    if (fmodel.mimeType) {
                        append = [formData appendPartWithFileURL:fmodel.fileURL name:fmodel.name fileName:fmodel.fileName mimeType:fmodel.mimeType error:&error];
                    }else{
                        append = [formData appendPartWithFileURL:fmodel.fileURL name:fmodel.name error:&error];
                    }
                    if (!append) {
                        if (failed) {
                            failed(error);
                        }
                    }
                }
                
            }else if([file isKindOfClass:[NSURL class]]){
                
                NSError * error = nil;
                BOOL append = [formData appendPartWithFileURL:file name:@"files" error:&error];
                if (!append) {
                    if (failed) {
                        failed(error);
                    }
                }
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progressB) {
//            float progress = uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
            progressB(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (successed) {
            successed(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failed) {
            failed(error);
        }
    }];
    
    return manager.uploadTasks;
}

+(void)setUserAgent:(NSString *)userAgentValue{
    if (userAgentValue == nil || [@"" isEqualToString:userAgentValue]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults]setObject:userAgentValue forKey:YHNetUserAgent];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSString *)getUserAgent{
    NSString *userAgent = [[NSUserDefaults standardUserDefaults] objectForKey:YHNetUserAgent];
    return userAgent;
}

+(AFHTTPSessionManager *)getNetManagerwithRequestSerializerType:(YHRequestSerializerType)requestType withResponeSerializerType:(YHResponeSerializerType)responeType{
    return [self getNetManagerWithCer:NO
                      withCerFilePath:nil
                        withUrlString:nil
                  withTimeoutInterval:YHNetTimeoutInterval
            withRequestSerializerType:requestType
            withResponeSerializerType:responeType];
}

+(AFHTTPSessionManager *)getNetManagerWithCer:(BOOL)withCer
                              withCerFilePath:(NSString *)cerFilePath
                                withUrlString:(NSString *)urlStr
                          withTimeoutInterval:(NSTimeInterval)timeoutInterval
                    withRequestSerializerType:(YHRequestSerializerType)requestType
                    withResponeSerializerType:(YHResponeSerializerType)responeType
{
    
    AFHTTPSessionManager *manager;
    if (withCer) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    }else{
        manager = [AFHTTPSessionManager manager];
    }
    
    [YHNetUnility setHttpSessionManager:manager
              withRequestSerializerType:requestType
              withResponeSerializerType:responeType];
    
    NSString *userAgent = [self getUserAgent];
    if (userAgent != nil) {
        [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/javascript", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain",@"multipart/form-data",@"application/x-www-form-urlencoded", nil];
    
    manager.requestSerializer.timeoutInterval = timeoutInterval > 1 ? timeoutInterval : YHNetTimeoutInterval;//默认超时:YHNetTimeoutInterval
    //判断是否要求证书
    if (withCer && ![self isNilOrEmpty:cerFilePath]) {
        
        NSData *cerData = [NSData dataWithContentsOfFile:cerFilePath];
        NSSet *set = [[NSSet alloc] initWithObjects:cerData, nil];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:set];
        
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = YES;
        
        manager.securityPolicy =  securityPolicy;
        
    }else{
        manager.securityPolicy =  [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    }
    
    return manager;
}

+(BOOL)isNilOrEmpty:(NSString *)str{
    if (str == nil || [@"" isEqualToString:str]) {
        return YES;
    }
    return NO;
}

+(void)setHttpSessionManager:(AFHTTPSessionManager *)manager
     withRequestSerializerType:(YHRequestSerializerType)requestType
     withResponeSerializerType:(YHResponeSerializerType)responeType{
    switch (requestType) {
        case YHRequestSerializerHttp:
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        case YHRequestSerializerJson:
            manager.requestSerializer=[AFJSONRequestSerializer serializer];
            break;
        
        case YHRequestSerializerProperList:
            manager.requestSerializer=[AFPropertyListRequestSerializer serializer];
            break;
            
        default:
            break;
    }
    
    switch (responeType) {
        case YHResponeSerializerHttp:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case YHResponeSerializerJson:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        
        case YHResponeSerializerProperList:
            manager.responseSerializer = [AFPropertyListResponseSerializer serializer];
            break;
            
        default:
            break;
    }
}

//+ (NSString *)getAppUA
//{
//    //    UA：app 名称/app 版本号（系统名称；设备名称；设备系统版本号；手机分辨率；网络环境）
//
//    NSString *userAgent = [NSString stringWithFormat:@"%@/%@;(%@;%@;%@;%@;%@)",
//                           @"ios_rongyitong",//app 名称
//                           [YHDeviceHelper getAppVersion],//app 版本号
//                           @"ios",//系统名称
//                           [YHDeviceHelper getDeviceName],// 设备名称
//                           [YHDeviceHelper getDeviceSystemVersionString],// 系统版本号
//                           [YHDeviceHelper getDeviceScreenResolution],//手机分辨率
//                           @""];
//    return userAgent;
//}

/**
 取消所有网络请求
 */
+(void)cancelAllRequest
{
    [[AFHTTPSessionManager manager].dataTasks makeObjectsPerformSelector:@selector(cancel)];
}

@end

