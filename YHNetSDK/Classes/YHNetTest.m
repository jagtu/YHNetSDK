//
//  YHNetTest.m
//  YHNetSDK
//
//  Created by zxl on 2018/1/30.
//  Copyright © 2018年 YH. All rights reserved.
//

#import "YHNetTest.h"

#import <AFNetworking/AFNetworking.h>
//#import <Reachability/Reachability.h>

@implementation YHNetTest

//+(void)reachabilityManager
//{
//    YHNetTest *reach = [[YHNetTest alloc]init];
//    [reach observeNetWorking];
//    
//}
//
//-(void)observeNetWorking
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name: kReachabilityChangedNotification
//                                               object: nil];
//    Reachability *hostReach = [Reachability reachabilityForInternetConnection];
//    [hostReach startNotifier];  //开始监听,会启动一个run loop
//    [self updateInterfaceWithReachability: hostReach];
//}
//
//// 连接改变
//- (void) reachabilityChanged: (NSNotification* )note
//{
//    Reachability* curReach = [note object];
//    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
//    [self updateInterfaceWithReachability: curReach];
//}
//
////处理连接改变后的情况
//- (void)updateInterfaceWithReachability: (Reachability*) curReach
//{
//    //对连接改变做出响应的处理动作。
//    NetworkStatus status = [curReach currentReachabilityStatus];
//    switch (status) {
//        case ReachableViaWiFi:
//            //            ShowMsg(@"当前为wifi网络环境");
//            break;
//        case ReachableViaWWAN:
//            //            ShowMsg(@"当前为移动网络环境");
//            break;
//        case NotReachable:
////            ShowMsg(@"网络不给力~");
//            break;
//        default:
//            break;
//    }
//}

+(void)testAfn
{
    NSLog(@"THIS IS A SDK");
}

@end
