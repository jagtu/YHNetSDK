//
//  YHTestDP.m
//  YHNetSDKDemo
//
//  Created by zxl on 2018/11/19.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHTestDP.h"

@implementation YHTestDP


-(void)setParam
{
//    self.isWithCer = YES;
    
}

-(NSString *)getFullUrl;
{
    return @"https://jyt.jdyy.cn:8060/ehc-portal-app/app/unifyapi";
//    return @"https://child.youku.com/?spm=..m_26658.5~1~3!2~8~A";
    
//    return @"http://192.168.44.92:10030/portal-anxi/app/unifyapi";
    return @"https://apps2.1zhe.com/ios/index_bak.php?m=other&op=collection&ac=init&app_version=2.4.9&v=2.4.7";
}

-(void)parseJsonData:(NSMutableDictionary *)responeObj
{
    NSLog(@"parseJsonData:{");
    for (NSString *key in responeObj.allKeys) {
        NSLog(@"%@:%@,",key,responeObj[key]);
    }
    NSLog(@"}");
}

-(void)actionAfterFailed:(NSError *)error
{
    
    NSLog(@"error: %@",error.description);
}
@end
