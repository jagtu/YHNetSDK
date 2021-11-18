//
//  YHModel.h
//  YHModel
//  参考 YHModel <https://github.com/ibireme/YHModel>
//
//  Created by Jagtu on 2020/2/28.
//  Copyright © 2020 yh. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<YHModel/YHModel.h>)

//! Project version number for YHModel.
FOUNDATION_EXPORT double YHModelVersionNumber;

//! Project version string for YHModel.
FOUNDATION_EXPORT const unsigned char YHModelVersionString[];

#import <YHModel/NSObject+YHModel.h>
#import <YHModel/YHClassInfo.h>
#else
#import "NSObject+YHModel.h"
#import "YHClassInfo.h"
#endif
