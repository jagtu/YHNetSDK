//
//  YHOCUploadDP.m
//  YHJiYiYiTong
//
//  Created by Jagtu on 2018/6/7.
//  Copyright © 2018年 yh. All rights reserved.
//

#import "YHOCUploadDP.h"

@implementation YHOCUploadDP

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.reqParam setObject:@"T2022092612052300001" forKey:@"platId"];
        [self.reqParam setObject:@"0" forKey:@"isEncrypt"];
        [self.reqParam setObject:@"" forKey:@"signType"];
        [self.reqParam setObject:@"" forKey:@"encryptType"];
        [self.reqParam setObject:@"20221103132641159" forKey:@"timestamp"];
        [self.reqParam setObject:@"1.0.0" forKey:@"version"];
        [self.reqParam setObject:@"29fcbdab5ed78ea1b15199d3d28273281a625005" forKey:@"deviceId"];
        [self.reqParam setObject:@"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cGRhdGVfdGltZSI6IjIwMjIxMTAxMTM1NTA3IiwiYXV0aF9sZXZlbCI6MCwidXNlcl9uYW1lIjoiMTU2OTk0MjQ3OTMwMDQ2NDcxNSIsInNjb3BlIjpbImFsbCJdLCJleHAiOjE2Njk5NzcxNjAsInRlcm1fdHlwZSI6IldYIiwianRpIjoiODNhZWMwODMtYzc0Yy00MmUzLWE2OTMtOTA0YTRjNGE4NzA5IiwiY2xpZW50X2lkIjoiZnJvbnRlbmQifQ.F4SXCoGwqm9y8HfIw6bihFHnjL_ltzLbnnX1ra7prJ4" forKey:@"sessionId"];
    
        self.host = @"https://mmqmjk.cn";
        self.path = @"/api/ihp-gateway/api";
    }
    return self;
}


#pragma mark start

-(NSString *)getFullUrl;
{
    return [NSString stringWithFormat:@"%@%@/file/upload",self.host,self.path];
}

-(NSArray *)getFiles
{
    return self.files;
}

-(NSMutableDictionary *)getParam
{
    return self.reqParam;
}

-(void)parseJsonData:(id)responeObj
{
    [super parseJsonData:responeObj];
    NSLog(@"%@ \nparam:\n%@\nrespone:\n%@",[self getFullUrl],[self reqParam] ,responeObj);
}

-(void)start{
    [super start];
    NSLog(@"开始请求接口 %@ \nparam:\n%@\n",[self getFullUrl],[self reqParam]);
}


#pragma mark lazy loading
-(NSMutableDictionary *)reqParam
{
    if (!_reqParam) {
        _reqParam = [[NSMutableDictionary alloc] init];
    }
    return _reqParam;
}

#pragma mark method acton order
- (void)setObject:(id)anObject forKey:(NSString *)aKey
{
    if (anObject == nil || aKey == nil) {
        return;
    }
    [self.reqParam setObject:anObject forKey:aKey];
}

-(void)appendPartWithFileModel:(YHUploadFileModel *)model
{
    [self.files addObject:model];
}

-(void)appendImage:(UIImage *)image withName:(NSString *)name
{
    YHUploadFileModel * model = [[YHUploadFileModel alloc] init];
    model.name = name;
    model.fileName = @"20221103132641159.png";
    model.mimeType = @"image/jpg/png/jpeg";
    model.fileData  = UIImageJPEGRepresentation(image, 1);
    /*压缩图片*/
    double scaleNum = (double)100*1024/model.fileData.length;
    if(scaleNum < 1 && scaleNum > 0.1){
        model.fileData = UIImageJPEGRepresentation(image, scaleNum);
    }else if(scaleNum <= 0.1){
        model.fileData = UIImageJPEGRepresentation(image, 0.1);
    }
    
    [self.files addObject:model];
}

-(void)clearFiles
{
    [self.files removeAllObjects];
}


-(NSMutableArray *)files
{
    if (!_files) {
        _files = [NSMutableArray array];
    }
    return _files;
}

@end
