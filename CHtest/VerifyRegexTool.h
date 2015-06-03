//
//  VerifyRegexTool.h
//  amway
//
//  Created by 陈 远山 on 15/4/24.
//  Copyright (c) 2015年 dangyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VerifyRegexTool : NSObject

+ (BOOL)verifyHour: (NSString *)hourStr scopeFromZeroToTwentyfour: (BOOL)isZeroToTwentyfour;//2位小时hh 00-24 校验是否格式正确


/**
 *  取得有效日期
 *
 *  @param applydate 当前日期 YYYYMMDD
 *
 *  @return 有效日期 当前月12个月后最后一天  20150504  --》 20150430
 */
+ (NSString *)getViliditydateFromApplydate: (NSString *)applydate;


@end
