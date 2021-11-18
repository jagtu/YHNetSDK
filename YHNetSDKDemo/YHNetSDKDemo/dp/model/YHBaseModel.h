//
//  YHBaseModel.h
//  YHRongYiTong
//
//  Created by zxl on 2017/11/13.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHBaseModel : NSObject

@property(nonatomic,copy)NSString *leftTitle;

@property(nonatomic,copy)NSString *leftImage;

@property(nonatomic,copy)NSString *rightTitle;

@property(nonatomic,copy)NSString *rightImage;

@property(nonatomic,assign)BOOL hiddenRightArrow;

@property(nonatomic,assign)BOOL hiddenBottomLine;

@property(nonatomic,assign)BOOL showTopCorner;

@property(nonatomic,assign)BOOL showBottomCorner;

@end
