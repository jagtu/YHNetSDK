//
//  YHBaseResp.h
//  YHRongYiTong
//
//  Created by jagtu on 2017/11/30.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHBaseRespModel : NSObject

@property(nonatomic,copy)NSString *respCode;//请求返回的代码
@property(nonatomic,copy)NSString *respMsg;//请求返回提示消息

//子类需返回的处理业务参数
//@property(nonatomic,copy)id param;//解密数据

@property(nonatomic,copy)NSString *encryptType;//加密算法
@property(nonatomic,copy)NSString *signType;//签名算法
@property(nonatomic,copy)NSString *sign;    //签名
@property(nonatomic,copy)NSString *timestamp;//服务端时间戳

//是否验签成功
@property(nonatomic,assign)BOOL isCorrectSign;

/**
 * 返回正常数据
 */
-(BOOL)isAccess;

@end
