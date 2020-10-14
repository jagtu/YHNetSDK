//
//  YHBaseDP.h
//  YHNetSDK
//
//  Created by zxl on 2018/2/1.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHNetProtocol.h"

#define YHNetWeakifySelf \
__weak __typeof(&*self)yh_net_weak_self = self

#define YHNetStrongifySelf \
__strong __typeof(&*yh_net_weak_self)self = yh_net_weak_self

/**
 网络请求方法，post与get
 */
typedef NS_ENUM (NSInteger,YHRequestMethodType){
    YHRequestMethodPost = 0,//post
    YHRequestMethodGet = 1 //get
};

/**
 网络请求参数序列化参数类型
 */
typedef NS_ENUM (NSInteger,YHRequestSerializerType){
    YHRequestSerializerHttp = 0,//默认
    YHRequestSerializerJson = 1, //json
    YHRequestSerializerProperList = 2 //xml
};

/**
 网络请求回参序列化参数类型
 */
typedef NS_ENUM (NSInteger,YHResponeSerializerType){
    YHResponeSerializerHttp = 0,//默认
    YHResponeSerializerJson = 1, //json
    YHResponeSerializerProperList = 2 //xml
};

@class YHBaseDP;

typedef void(^YHNetResponeBlock)(YHBaseDP * _Nullable dp,id _Nullable obj,NSError * _Nullable error);

typedef void(^YHLoadingViewBlock)(YHBaseDP * _Nullable dp);

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
@property(nonatomic,copy)NSString * _Nullable host;

/**
 接口path
 */
@property(nonatomic,copy)NSString * _Nullable path;

/**
 dataprovider 标记用于区分不同的dp
 */
@property(nonatomic,assign)NSInteger tag;

/**
 delegate
 */
@property(nonatomic,weak)id<YHNetProtocol> _Nullable netHandle;

/**
网络请求时候，自定义加载视图，可自行处理，开放权限，不再限制于dp内控制。
*/
@property(nonatomic,weak)id<YHLoadingViewProtocol> _Nullable loadingViewHandle;

/**
 当主动取消网络请求时候，会回调到 fail,error.code = -999;
 该属性用于控制是否允许执行 AFN FailedBlock,详见baseDP.m文件,
 默认为 NO;
 */
@property(nonatomic,assign)BOOL enableFailedActionWhenCancelRequest;


/**
 网络请求列表
 */
@property(nonatomic,strong)NSArray * _Nullable tasks;


/**
 是否使用证书,转为为NO，即不使用证书
 */
@property(nonatomic,assign)BOOL isWithCer;


/**
 自定义HTTPS证书路径
 */
@property(nonatomic,copy)NSString * _Nullable cerFilePath;


/**
 是否触发显示loadingview,默认为NO，即显示
 */
@property(nonatomic,assign)BOOL hideLoadingview;

/**
 网络请求方式，默认为post类型
 */
@property(nonatomic,assign)YHRequestMethodType * _Nullable method;

/**
网络请求超时时间：默认为30秒
*/
@property(nonatomic,assign)NSTimeInterval * _Nullable timeout;

/**
 网络请求类型，默认为post
 */
@property(nonatomic,assign)YHRequestMethodType * _Nullable requestMethodType;

/**
网络请求参数序列化，默认为http，与AFN适配
*/
@property(nonatomic,assign)YHRequestSerializerType requestSerializerType;

/**
获取网络返回数据序列化，默认为http，与AFN适配
*/
@property(nonatomic,assign)YHResponeSerializerType responeSerializerType;

/**
成功回调block
*/
@property(nonatomic,copy)YHNetResponeBlock _Nullable succedBlock;

/**
失败回调block
*/
@property(nonatomic,copy)YHNetResponeBlock _Nullable failedBlock;

/**
显示弹窗block
*/
@property(nonatomic,copy)YHLoadingViewBlock _Nullable showBlock;

/**
移除弹窗block
*/
@property(nonatomic,copy)YHLoadingViewBlock _Nullable dissBlock;

/**
请求头设置
*/
@property(nonatomic,strong)NSMutableDictionary * _Nullable requestHeaders;

/**
进度
*/
@property(nonatomic,strong)NSProgress * _Nullable downloadProgress;

/**
 初始化函数

 @param netHandle delegate
 @return id
 */
-(id _Nullable )initWithHandle: (id<YHNetProtocol>_Nullable) netHandle;

/**
  初始化函数
 @param netHandle 网络代理
  @param loadingviewHandle  自定义加载视图代理
 */
-(id _Nullable )initWithHandle:(id<YHNetProtocol>_Nullable) netHandle
            withLoadViweHandle:(id<YHLoadingViewProtocol>_Nullable) loadingviewHandle;

-(id _Nullable )initWithSuccBlock:(YHNetResponeBlock _Nullable )succedBlock
                  withFailedBlock:(YHNetResponeBlock _Nullable )failedBlock
         withShowLoadingViewBlock:(YHLoadingViewBlock _Nullable )showBlock
         withDissLoadingViewBlock:(YHLoadingViewBlock _Nullable )dissBlock;

#pragma mark set param param 写以下方法是为了不暴露 reqModel

/**
 设置key/value对 _Nullable 象值

 @param anObject obj
 @param aKey key
 */
-(void)setObject:(id _Nullable )anObject forKey:(NSString *_Nullable)aKey;


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

#pragma mark 加载数据时候动作

/**
 获取完整的接口网址

 @return url
 */
-(NSString *_Nullable)getFullUrl;

/**
 设置参数，如果子类需要上传参数，必须重写
 */
-(void)setParam;

/**
 获取参数

 @return dic
 */
-(NSMutableDictionary *_Nullable)getParam;

/**
获取请求头参数，默认返回参数：requestHeaders

@return dic
*/
-(NSMutableDictionary *_Nullable)getHeaders;

#pragma mark requred 子类必须实现

/**
 对数据进行解密；
如果子类不重写，默认返回原始数据。
 @param responeObj 原始数据
 @return 解密完的数据
 */
-(NSMutableDictionary *_Nullable)decryptData:(NSMutableDictionary *_Nullable)responeObj;

/**
 解析接口返回的数据

 @param responeObj obj
 */
-(void)parseJsonData:(id _Nullable )responeObj;

#pragma mark option 可选

/**
 当接口请求成功后，处理逻辑
 */
-(void)actionAfterParseData;

/**
 数据接口请求失败后，处理逻辑
 */
-(void)actionAfterFailed:(NSError *_Nullable)error;

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
-(BOOL)isCancelled:(NSError *_Nullable)error;

/**
将执行start的前期动作抽出来，方便子类调用
*/
-(void)actionBeforeSendRequest;

/**
请求成功后操作，子类如果有重写必须执行调用父类方法，call super

@param obj 返回数据
*/
-(void)continueActionAfterRequestSuccessWithObj:(nullable id)obj;

/**
请求失败后操作，子类如果有重写必须执行调用父类方法，call super

@param error 错误码
*/
-(void)continueActionAfterRequestFailedWithError:(nullable NSError *)error;

/**
将post方法抽出来，方便子类调用
*/
-(void)requestForPost;

/**
将get方法抽出来，方便子类调用
*/
-(void)requestForGet;

@end
