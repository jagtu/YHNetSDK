//
//  YHBaseUploadDP.m
//  YHNetSDK
//
//  Created by Jagtu on 2018/6/7.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHBaseUploadDP.h"
#import "YHNetUnility.h"

@implementation YHBaseUploadDP

-(NSArray *)getFiles
{
    return [NSArray new];
}

#pragma mark start

-(void)start
{
    if (![self shouldStart]) {
        return;
    }
    
    [self actionBeforeSendRequest];
    
    YHNetWeakifySelf;
    self.tasks = [YHNetUnility postUploadRequestWithUrl:[self getFullUrl] withRequestHeaders:[self getHeaders] withParameters:[self getParam] withRequestSerializerType:self.requestSerializerType withResponeSerializerType:self.responeSerializerType withFiles:[self getFiles] uploadProgress:^(NSProgress *uploadProgress) {
        YHNetStrongifySelf;
        self.progress = uploadProgress.fractionCompleted;
        if (self.netHandle && [self.netHandle respondsToSelector:@selector(netByDP:uploadProgress:)]) {
            [self.netHandle netByDP:self uploadProgress:self.progress];
        }
    } withSuccessed:^(id obj) {
        YHNetStrongifySelf;
        [self continueActionAfterRequestSuccessWithObj:obj];
        
    } withFailed:^(NSError *error) {
        YHNetStrongifySelf;
        [self continueActionAfterRequestFailedWithError:error];
    }];
}

@end
