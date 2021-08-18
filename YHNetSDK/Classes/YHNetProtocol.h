//
//  YHNetProtocol.h
//  YHNetSDK
//
//  Created by zxl on 2018/2/1.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 网络请求代理协议

@protocol YHNetProtocol <NSObject>

@optional

-(void)netByDP:(id)dataProvider doWhenSuccess:(id) obj;

-(void)netByDP:(id)dataProvider doWhenFailed:(id)obj;

-(void)netByDP:(id)dataProvider uploadProgress:(float) uploadProgress;

@end


/**
 当调用DP进行网络请求时候可以自定义加载视图，进行显示与隐藏操作
*/
@protocol YHLoadingViewProtocol <NSObject>

@optional

/**
 显示加载视图
 */
-(void)actionWhenShowLoadingViewWithDP:(id)dataProvider;

/**
 隐藏加载视图
 */
-(void)actionWhenDismissLoadingViewWithDP:(id)dataProvider;

@end
