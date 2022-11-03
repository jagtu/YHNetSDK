//
//  YHOCUploadDP.h
//  YHJiYiYiTong
//
//  Created by Jagtu on 2018/6/7.
//  Copyright © 2018年 yh. All rights reserved.
//

#import <YHNetSDK/YHNetSDK.h>
#import "YHOCUploadRespModel.h"

@interface YHOCUploadDP : YHBaseUploadDP


@property(nonatomic,assign)BOOL isIMUpload;

@property(nonatomic,strong)YHOCUploadRespModel *model;

/**
 参数容器
 */
@property(nonatomic,strong)NSMutableDictionary *reqParam;

@property(nonatomic,strong)NSMutableArray *files;

-(void)appendPartWithFileModel:(YHUploadFileModel *)model;
-(void)appendImage:(UIImage *)image withName:(NSString *)name;
-(void)clearFiles;

@end
