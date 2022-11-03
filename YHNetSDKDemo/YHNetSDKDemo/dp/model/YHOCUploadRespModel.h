//
//  YHOCUploadRespModel.h
//  YHJiYiYiTong
//
//  Created by Jagtu on 2018/6/7.
//  Copyright © 2018年 yh. All rights reserved.
//

#import "YHBaseRespModel.h"

@class YHOCUploadModel;

@interface YHOCUploadRespModel : YHBaseRespModel

@property(nonatomic,strong)YHOCUploadModel *param;

@end

@interface YHOCUploadModel : NSObject

@property(nonatomic,copy)NSString *url;//图片文件url

@end
