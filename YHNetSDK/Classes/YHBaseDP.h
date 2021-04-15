//
//  YHBaseDP.h
//  YHNetSDK
//
//  Created by zxl on 2018/2/1.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHNetProtocol.h"

@interface YHBaseDP : NSObject

/**
 是否正在加载
 */
@property(nonatomic,assign)BOOL isLoading;

/**
 是否为第1次加载,默认为YES,只有加载成功后，才会变成NO.
 */
@property(nonatomic,assign)BOOL firstLoad;

/**
 域名
 */
@property(nonatomic,copy)NSString *host;

/**
 接口path
 */
@property(nonatomic,copy)NSString *path;

/**
 dataprovider 标记用于区分不同的dp
 */
@property(nonatomic,assign)NSInteger tag;

/**
 delegate
 */
@property(nonatomic,weak)id<YHNetProtocol> netHandle;

/**
 当主动取消网络请求时候，会回调到 fail,error.code = -999;
 该属性用于控制是否允许执行 AFN FailedBlock,详见baseDP.m文件,
 默认为 NO;
 */
@property(nonatomic,assign)BOOL enableFailedActionWhenCancelRequest;


/**
 网络请求列表
 */
@property(nonatomic,copy)NSArray *tasks;


/**
 是否使用证书,转为为NO，即不使用证书
 */
@property(nonatomic,assign)BOOL isWithCer;


/**
 自定义HTTPS证书路径
 */
@property(nonatomic,copy)NSString *cerFilePath;


/**
 是否触发显示loadingview,默认为NO，即显示
 */
@property(nonatomic,assign)BOOL *hideLoadingview;
/**
 初始化函数

 @param netHandle delegate
 @return id
 */
-(id)initWithHandle: (id<YHNetProtocol>) netHandle;

#pragma mark set param param 写以下方法是为了不暴露 reqModel

/**
 设置key/value对象值

 @param anObject obj
 @param aKey key
 */
-(void)setObject:(id)anObject forKey:(NSString *)aKey;


/**
 判断数据是否为空

 @return true
 */
-(BOOL)isEmpty; //数据是否为空

#pragma mark 请求数据之前

/**
 是否可以加载

 @return true
 */
-(BOOL)shouldStart;

/**
 请求接口前处理逻辑
 */
-(void)actionBeforeStart;


/**
 显示加载弹窗
 */
-(void)setLoadingView;


/**
 移除加载弹窗
 */
-(void)removeLoadingView;

-(void)setLoadStatus;

#pragma mark 加载数据时候动作

/**
 获取完整的接口网址

 @return url
 */
-(NSString *)getFullUrl;

/**
 设置参数，如果子类需要上传参数，必须重写
 */
-(void)setParam;


/**
 获取参数

 @return dic
 */
-(NSMutableDictionary *)getParam;

#pragma mark requred 子类必须实现


/**
 对数据进行解密；
如果子类不重写，默认返回原始数据。
 @param responeObj 原始数据
 @return 解密完的数据
 */
-(NSMutableDictionary *)decryptData:(NSMutableDictionary *)responeObj;

/**
 解析接口返回的数据

 @param responeObj obj
 */
-(void)parseJsonData:(id)responeObj;

#pragma mark option 可选

/**
 当接口请求成功后，处理逻辑
 */
-(void)actionAfterParseData;


/**
 数据接口请求失败后，处理逻辑
 */
-(void)actionAfterFailed:(NSError *)error;

#pragma mark start

/**
 开始请求接口
 */
-(void)start;

/**
 取消当前DP请求，并重新请求
 */
-(void)restart;


/**
 设置DP请求接口前后的状态
 */
-(void)setDPStatusBeforeRequest;

-(void)setDPStatusWhenSuccessed;

-(void)setDPStatusWhenFailed;

/**
 取消指定当前网络请求
 由于我们项目目前接口只有一个请求网址，因此不好区分不同DP，
 暂时将取消当前DP与取消所有DP写成同一个方法
 */
-(void)cancelDP;


/**
 取消所有网络请求
 */
-(void)cancelAllDP;

/**
 是否为主动取消状态

 @param error -999
 @return bool value
 */
-(BOOL)isCancelled:(NSError *)error;


@end
