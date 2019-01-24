//
//  YHUploadFileModel.h
//  YHNetSDK
//
//  Created by Jagtu on 2018/6/7.
//  Copyright © 2018年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHUploadFileModel : NSObject

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *fileName;

@property(nonatomic,copy)NSString *mimeType;

@property(nonatomic,strong)NSData *fileData;

@property(nonatomic,strong)NSURL *fileURL;

@end
