//
//  YHBaseResp
//  YHRongYiTong
//
//  Created by jagtu on 2017/11/30.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "YHBaseRespModel.h"

@implementation YHBaseRespModel

-(BOOL)isAccess
{
    /**
     //需要强制验签的，可以在子类继承添加上
    if (!self.isCorrectSign) {
        return NO;
    }
    */
    return [self.respCode isEqualToString:@"000000"];
}


@end
