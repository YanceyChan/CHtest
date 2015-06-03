//
//  NSString+Restricted.h
//  CHtest
//
//  Created by 陈 远山 on 15/6/2.
//  Copyright (c) 2015年 exmaple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Restricted)
/**
 *  根据正则表达式限制string
 *
 *  @param regex 正则表达式
 *
 *  @return YES--符合  NO--不符合
 */
- (BOOL)restrictStringFollowRegex:(NSString *)regex;

/**
 *  限制只包含数字0-9
 *
 *  @return YES--符合  NO--不符合
 */
- (BOOL)onlyHasDigit;

/**
 *  限制只包含数字0-9 规定长度
 *
 *  @param length 字符串长度
 *
 *  @return YES--符合  NO--不符合
 */
- (BOOL)onlyHasDigitLength:(NSInteger)length;


/**
 *  限制只包含数字0-9和小数点
 *
 *  @param length             小数点前数字长度
 *  @param decimalPointLength 小数点后数字长度
 *
 *  @return YES--符合  NO--不符合
 */
- (BOOL)onlyHasDigitLength:(NSInteger)length decimalPointLength:(NSInteger) decimalPointLength;

/**
 *  限制只包含数字0-9和正负号
 *
 *  @param length      数字长度
 *  @param plusOrMinus YES--正号  NO--负号
 *
 *  @return YES--符合  NO--不符合
 */
- (BOOL)onlyHasDigitLength:(NSInteger)length plusAndMinusSign:(BOOL)plusOrMinus;


@end
