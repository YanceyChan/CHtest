//
//  VerifyRegexTool.m
//  amway
//
//  Created by 陈 远山 on 15/4/24.
//  Copyright (c) 2015年 dangyangyang. All rights reserved.
//

#import "VerifyRegexTool.h"

@implementation VerifyRegexTool


//验证是否不为空
+ (BOOL)verifyIsNotEmpty:(NSString *)str
{
    if (!str) return NO;
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![str isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

//正则验证
//+ (BOOL)verifyText:(NSString *)text withRegex:(NSString *)regex
//{
//    return [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isMatchedByRegex:regex];
//}

//验证身份证
//必须满足以下规则
//1. 长度必须是18位，前17位必须是数字，第十八位可以是数字或X
//2. 前两位必须是以下情形中的一种：11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91
//3. 第7到第14位出生年月日。第7到第10位为出生年份；11到12位表示月份，范围为01-12；13到14位为合法的日期
//4. 第17位表示性别，双数表示女，单数表示男


//5. 第18位为前17位的校验位
//算法如下：
//（1）校验和 = (n1 + n11) * 7 + (n2 + n12) * 9 + (n3 + n13) * 10 + (n4 + n14) * 5 + (n5 + n15) * 8 + (n6 + n16) * 4 + (n7 + n17) * 2 + n8 + n9 * 6 + n10 * 3，其中n数值，表示第几位的数字
//（2）余数 ＝ 校验和 % 11
//（3）如果余数为0，校验位应为1，余数为1到10校验位应为字符串“0X98765432”(不包括分号)的第余数位的值（比如余数等于3，校验位应为9）
//6. 出生年份的前两位必须是19或20
+ (BOOL)verifyIDCardBirthday:(NSString *)value{
    //出生日期
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd         = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd     = @"0229";
    NSString *year         = @"(19|20)[0-9]{2}";
    NSString *leapYear     = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd     = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd     = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area         = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex        = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    return YES;
}

+ (BOOL)verifyIDCardNumber:(NSString *)value
{
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] == 18) {
        //第18位校验
        int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
        + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
        + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
        + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
        + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
        + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
        + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
        + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
        + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
        NSInteger remainder = summary % 11;
        NSString *checkBit = @"";
        NSString *checkString = @"10X98765432";
        checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
        return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
    }
    return NO;
    
}



+ (NSUInteger)lengthUsingChineseCharacterCountByTwo:(NSString *)string{
    NSUInteger count = 0;
    for (NSUInteger i = 0; i< string.length; ++i) {
        if ([string characterAtIndex:i] < 256) {
            count++;
        } else {
            count += 2;
        }
    }
    return count;
}


//得到身份证的生日****这个方法中不做身份证校验，请确保传入的是正确身份证
+ (NSString *)getIDCardBirthday:(NSString *)card {
    card = [card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([card length] != 18) {
        return nil;
    }
    NSString *birthady = [NSString stringWithFormat:@"%@%@%@",[card substringWithRange:NSMakeRange(6,4)], [card substringWithRange:NSMakeRange(10,2)], [card substringWithRange:NSMakeRange(12,2)]];
    return birthady;
}

//得到身份证的性别（1男0女）****这个方法中不做身份证校验，请确保传入的是正确身份证
+ (NSInteger)getIDCardSex:(NSString *)card {
    card = [card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger defaultValue = 0;
    if ([card length] != 18) {
        return defaultValue;
    }
    NSInteger number = [[card substringWithRange:NSMakeRange(16,1)] integerValue];
    if (number % 2 == 0) {  //偶数为女
        return 0;
    } else {
        return 1;
    }
}

//验证出生日期是否正确
+ (BOOL)verifyBirthday: (NSString *)birthday{
    //出生日期
    birthday = [birthday stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([birthday length] != 8) {
        return NO;
    }
    NSString *mmdd         = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd     = @"0229";
    NSString *year         = @"(19|20)[0-9]{2}";
    NSString *leapYear     = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd     = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd     = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *regex        = [NSString stringWithFormat:@"%@", yyyyMmdd];

    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:birthday]) {
        return NO;
    }
    return YES;
}

//出生日期且大于18岁   ？22岁
+ (BOOL)verifyAdult:(NSString *)birthday andyear:(NSInteger)age{
    NSInteger birthDay   = [[birthday substringWithRange: NSMakeRange(6, 2)] integerValue];
    NSInteger birthMonth = [[birthday substringWithRange:NSMakeRange(4, 2)] integerValue];
    NSInteger birthYear  = [[birthday substringWithRange:NSMakeRange(0, 4)] integerValue];
    NSDateComponents * components = [[NSCalendar currentCalendar]components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components year];
    NSInteger currentDateMonth = [components month];
    NSInteger currentDateDay   = [components day];
    
    //判断
    NSInteger iAge = currentDateYear - birthYear;
    if (currentDateMonth <= birthMonth) {
        if (currentDateMonth == birthMonth) {
            if (currentDateDay < birthDay) {
                iAge--;
            }
        }else{
            iAge--;
        }
    }
    if (iAge < age) {
        return NO;
    }
    
    return YES;
}

+ (NSString *)getViliditydateFromApplydate: (NSString *)applydate{
    NSString *applyYear  = [applydate substringWithRange:NSMakeRange(0, 4)];
    NSString *applyMonth = [applydate substringWithRange:NSMakeRange(4, 2)];
    //    NSString *applyDay = [applydate substringWithRange:NSMakeRange(5, 2)];
    NSInteger validityYearInt  = 0;
    NSInteger validityMonthInt = 0;
    NSInteger validityDayInt   = 0;
    if ([applyMonth isEqualToString:@"01"]){
        validityYearInt  = [applyYear integerValue];
        validityMonthInt = 12;
        validityDayInt   = 31;
    }else{
        validityYearInt  = [applyYear integerValue] + 1;
        validityMonthInt = [applyMonth integerValue] - 1;
    }
    
    switch (validityMonthInt) {
        case 1:;
        case 3:;
        case 5:;
        case 7:;
        case 8:;
        case 10:;
        case 12:
            validityDayInt = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            validityDayInt = 30;
            break;
        default:
            validityDayInt = 28;
            break;
    }
    
    if ((validityYearInt % 400) == 0){
        if(validityMonthInt == 02){
            validityDayInt = 29;
        }
        
    }else if (((validityYearInt % 100) != 0) && (validityDayInt % 4) == 0){
        if(validityMonthInt == 02){
            validityDayInt = 29;
        }
    }
    NSString * validityDate = [NSString stringWithFormat:@"%ld", (long)validityYearInt];
    validityDate = [validityDate stringByAppendingString:[NSString stringWithFormat:@"0%ld", (long)validityMonthInt]];
    validityDate = [validityDate stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)validityDayInt]];
    return validityDate;
}

+ (BOOL)verifyHour: (NSString *)hourStr scopeFromZeroToTwentyfour: (BOOL)isZeroToTwentyfour{
    hourStr = [hourStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([hourStr length] != 2) {
        return NO;
    }
    NSString *hour;
    if (isZeroToTwentyfour) {
        hour = @"((0[0-9])|(1[0-9])|(2[0-4]))";
    }else{
        hour = @"((0[1-9])|(1[0-9])|(2[0-4]))";
    }
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", hour];
    if (![regexTest evaluateWithObject:hourStr]) {
        return NO;
    }
    return YES;
}

@end
