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
    
    [self actionBeforeStart];
    
    [self setLoadingView];
    
    [self setParam];
    
    [self setDPStatusBeforeRequest];
    
    self.tasks = [YHNetUnility postRequestWithUrl:[self getFullUrl] withParameters:[self getParam] withFiles:[self getFiles] uploadProgress:^(float uploadProgress) {
        
        self.progress = uploadProgress;
        if (self.netHandle && [self.netHandle respondsToSelector:@selector(netByDP:uploadProgress:)]) {
            [self.netHandle netByDP:self uploadProgress:self.progress];
        }
        
    } withSuccessed:^(id obj) {
        
        [self setLoadStatus];
        [self removeLoadingView];
        [self setDPStatusWhenSuccessed];
        [self parseJsonData:[self decryptData:obj]];
        [self actionAfterParseData];
        if (self.netHandle && [self.netHandle respondsToSelector:@selector(netByDP:doWhenSuccess:)]) {
            [self.netHandle netByDP:self doWhenSuccess:obj];
        }
    } withFailed:^(NSError *error) {
        
        [self removeLoadingView];
        [self setDPStatusWhenFailed];
        [self actionAfterFailed:error];
        
        if (self.netHandle && [self.netHandle respondsToSelector:@selector(netByDP:doWhenFailed:)]) {
            [self.netHandle netByDP:self doWhenFailed:error];
        }
    }];

}

@end
