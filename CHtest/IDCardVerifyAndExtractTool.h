//
//  IDCardVerifyAndExtractTool.h
//  CHtest
//
//  Created by 陈 远山 on 15/6/1.
//  Copyright (c) 2015年 exmaple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCardVerifyAndExtractTool : NSObject
/**
 *  验证身份证不为空
 *
 *  @param idCardNumber 身份证号码
 *
 *  @return YES--不为空  NO--空
 */
+ (BOOL)verifyIsNotEmpty:(NSString *)idCardNumber;
+ (BOOL) isBlankString:(NSString *)string;
/**
 *  校验18位身份证中的数字是否在规定范围里
 *
 *  @param idCardNumber 18位身份证号码
 *
 *  @return YES--正确 NO--错误
 */
+ (BOOL)verifyIDCardNumberInTheRange:(NSString *)idCardNumber;

/**
 *  校验18位身份证中的校验位是否正确（第18位为校验位）
 *
 *  @param idCardNumber 18位身份证号码
 *
 *  @return YES--正确 NO--错误
 */
+ (BOOL)verifyIDCardParityBitIsCorrect:(NSString *)idCardNumber;

/**
 *  获取身份证中的生日日期
 *
 *  @param card 18位身份证号 这个方法中不做身份证校验，请确保传入的是正确身份证
 *
 *  @return 出生日期 格式（YYYYMMdd）
 */
+ (NSString *)getIDCardBirthday:(NSString *)idCardNumber;

/**
 *  获取身份证中的性别
 *
 *  @param idCardNumber 18位身份证号  这个方法中不做身份证校验，请确保传入的是正确身份证
 *
 *  @return YES--男 NO--女
 */
+ (BOOL)getIDCardSex:(NSString *)idCardNumber;

/**
 *  获取身份证对应岁数(YYYYMMDD)
 *
 *  @param birthday 身份证中8位出生日期
 *
 *  @return 岁数
 */
+ (NSString *)getIDCardAge:(NSString *)birthday;

/**
 *  比较出生日期（YYYYMMDD）是否超过输入岁数
 *
 *  @param birthday 出生日期 （8位YYYYMMDD）
 *  @param age      岁数
 *
 *  @return YES--大于或等于该岁数   NO--小于岁数
 */
+ (BOOL)getBirthday:(NSString *)birthday compareAge:(NSInteger)age;

/**
 *  获取身份证对应省份
 *
 *  @param idCardNumber 身份证号码
 *
 *  @return 省份
 */
+ (NSString *)getIDCardProvince:(NSString *)idCardNumber;


@end
