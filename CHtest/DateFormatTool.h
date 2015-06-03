//
//  DateFormatVerifyTool.h
//  CHtest
//
//  Created by 陈 远山 on 15/6/2.
//  Copyright (c) 2015年 exmaple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatTool : NSObject
/**
 *  验证8位日期格式 YYYYMMdd
 *
 *  @param date 日期
 *
 *  @return YES--正确 NO--错误
 */
+ (BOOL)verifyEightFigureDate:(NSString *)date;

/**
 *  校验24小时制小时格式
 *
 *  @param hourStr            时间
 *  @param isZeroToTwentyfour YES--校验格式为00-24   NO--校验格式为01-24
 *
 *  @return YES--正确  NO--错误
 */
+ (BOOL)verifyHour: (NSString *)hourStr scopeFromZeroToTwentyfour: (BOOL)isZeroToTwentyfour;

/**
 *  取得有效日期
 *
 *  @param applydate 当前日期 YYYYMMDD
 *
 *  @return 有效日期 当前月12个月后最后一天  20150504  --》 20150430
 */
+ (NSString *)getViliditydateFromApplydate: (NSString *)applydate;
@end
