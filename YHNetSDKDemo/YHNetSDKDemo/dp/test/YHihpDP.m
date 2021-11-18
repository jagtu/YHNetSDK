//
//  YHihpDP.m
//  互联网医院测试请求
//
//  Created by ljt on 2021/11/21.
//  Copyright © 2021年 YH. All rights reserved.
//

#import "YHihpDP.h"

@implementation YHihpDP

#pragma mark start

-(void)initData
{
    self.host = @"http://decs.pcl.ac.cn:4913/ihp-gateway";
    self.path = @"";

    self.reqModel.appId = @"T2019101003592700001";
    self.reqModel.appSecret = @"OCAR6L396771RX0B";
    self.reqModel.encryptType = @"plain";
    self.reqModel.signType = @"plain";
    self.reqModel.isEncrypt = @"0";
    self.reqModel.version = @"1.0.0";//接口版本号
    self.reqModel.termType = @"ios";
    self.reqModel.isSign = YES;
    self.reqModel.appVersion = @"1";//app版本号
    self.reqModel.timestamp = [NSString stringWithFormat:@"%.0f",[NSDate date].timeIntervalSinceNow];
    self.reqModel.deviceId = @"------";
    
    ///
    
    
    //发送验证码
//    self.path = @"/api/cms/sendCode";
//    [self setObject:@"17720867342" forKey:@"phone"];
//    [self setObject:@"LOGIN" forKey:@"codeType"];
    
    //登录
    self.path = @"/api/account/login";
    [self setObject:@"17720867342" forKey:@"phone"];
    [self setObject:@"70d88ee15131a474650dcb13fd717e547b9db5e6" forKey:@"deviceId"];
    [self setObject:@"02" forKey:@"deviceType"];
    [self setObject:@"PASSWORD" forKey:@"loginType"];
    [self setObject:@"qwe123123" forKey:@"password"];
}

-(void)setParam
{
    [super setParam];
}

-(void)refreshParam
{
}

-(NSString *)getFullUrl;
{
    return [NSString stringWithFormat:@"%@%@",self.host,self.path];
}


-(NSMutableDictionary *)getParam
{
    [self refreshParam];
    return [self.reqModel reqParam];
}

-(void)parseJsonData:(NSMutableDictionary *)responeObj
{
    NSLog(@"%@ \nparam:\n%@\nrespone:\n%@",[self getFullUrl],[self.reqModel reqParam] ,responeObj);
    [super parseJsonData:responeObj];
}

-(void)actionAfterFailed:(NSError *)error
{
    NSLog(@"[actionAfterFailed]，Err:\n%@",error);
}

+ (nullable NSArray<NSString *> *)reqPropertyBlacklist
{
    return nil;
}

+ (nullable NSDictionary<NSString *, NSString *> *)reqCustomPropertyMapper
{
    return @{@"appId":@"platId"};
}

+ (nullable NSDictionary *)addDefaultProperty
{
    return nil;
}


@end
