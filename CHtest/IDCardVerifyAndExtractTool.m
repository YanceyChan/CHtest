//
//  IDCardVerifyAndExtractTool.m
//  CHtest
//
//  Created by 陈 远山 on 15/6/1.
//  Copyright (c) 2015年 exmaple. All rights reserved.
//

#import "IDCardVerifyAndExtractTool.h"

@implementation IDCardVerifyAndExtractTool

+ (BOOL)verifyIsNotEmpty:(NSString *)idCardNumber{
    if (!idCardNumber) return NO;
    
    idCardNumber = [idCardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![idCardNumber isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//验证身份证
//必须满足以下规则
//1. 长度必须是18位，前17位必须是数字，第十八位可以是数字或X
//2. 前两位必须是以下情形中的一种：代表省份，11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91
//   第3-6位代表具体的地区---市---县（区）
//3. 第7到第14位出生年月日。第7到第10位为出生年份；11到12位表示月份，范围为01-12；13到14位为合法的日期
//   第15-17位位顺序码表示在同一地址码所标识的区域范围内，对同年、同月、同日出生的人编定的顺序号，顺序码的奇数分配给男性，偶数分配给女性。
//4. 第17位表示性别，双数表示女，单数表示男
//6. 出生年份的前两位必须是19或20
+ (BOOL)verifyIDCardNumberInTheRange:(NSString *)idCardNumber{
    idCardNumber = [idCardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([idCardNumber length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:idCardNumber]) {
        return NO;
    }
    return YES;
}

//5. 第18位为前17位的校验位
//算法如下：
//（1）校验和 = (n1 + n11) * 7 + (n2 + n12) * 9 + (n3 + n13) * 10 + (n4 + n14) * 5 + (n5 + n15) * 8 + (n6 + n16) * 4 + (n7 + n17) * 2 + n8 + n9 * 6 + n10 * 3，其中n数值，表示第几位的数字
//（2）余数 ＝ 校验和 % 11
//（3）如果余数为0，校验位应为1，余数为1到10校验位应为字符串“0X98765432”(不包括分号)的第余数位的值（比如余数等于3，校验位应为9）
+ (BOOL)verifyIDCardParityBitIsCorrect:(NSString *)idCardNumber{
    idCardNumber = [idCardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([idCardNumber length] == 18) {
        //第18位校验
        int summary = ([idCardNumber substringWithRange:NSMakeRange(0,1)].intValue + [idCardNumber substringWithRange:NSMakeRange(10,1)].intValue) *7
        + ([idCardNumber substringWithRange:NSMakeRange(1,1)].intValue + [idCardNumber substringWithRange:NSMakeRange(11,1)].intValue) *9
        + ([idCardNumber substringWithRange:NSMakeRange(2,1)].intValue + [idCardNumber substringWithRange:NSMakeRange(12,1)].intValue) *10
        + ([idCardNumber substringWithRange:NSMakeRange(3,1)].intValue + [idCardNumber substringWithRange:NSMakeRange(13,1)].intValue) *5
        + ([idCardNumber substringWithRange:NSMakeRange(4,1)].intValue + [idCardNumber substringWithRange:NSMakeRange(14,1)].intValue) *8
        + ([idCardNumber substringWithRange:NSMakeRange(5,1)].intValue + [idCardNumber substringWithRange:NSMakeRange(15,1)].intValue) *4
        + ([idCardNumber substringWithRange:NSMakeRange(6,1)].intValue + [idCardNumber substringWithRange:NSMakeRange(16,1)].intValue) *2
        + [idCardNumber substringWithRange:NSMakeRange(7,1)].intValue *1 + [idCardNumber substringWithRange:NSMakeRange(8,1)].intValue *6
        + [idCardNumber substringWithRange:NSMakeRange(9,1)].intValue *3;
        NSInteger remainder = summary % 11;
        NSString *checkBit = @"";
        NSString *checkString = @"10X98765432";
        checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
        return [checkBit isEqualToString:[[idCardNumber substringWithRange:NSMakeRange(17,1)] uppercaseString]];
    }
    return NO;
}

+ (NSString *)getIDCardBirthday:(NSString *)idCardNumber{
    idCardNumber = [idCardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([idCardNumber length] != 18) {
        return nil;
    }
    NSString *birthady = [NSString stringWithFormat:@"%@%@%@",[idCardNumber substringWithRange:NSMakeRange(6,4)], [idCardNumber substringWithRange:NSMakeRange(10,2)], [idCardNumber substringWithRange:NSMakeRange(12,2)]];
    return birthady;
}

+ (BOOL)getIDCardSex:(NSString *)idCardNumber{
    idCardNumber = [idCardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger defaultValue = 0;
    if ([idCardNumber length] != 18) {
        return defaultValue;
    }
    NSInteger number = [[idCardNumber substringWithRange:NSMakeRange(16,1)] integerValue];
    if (number % 2 == 0) {  //偶数为女
        return 0;
    } else {
        return 1;
    }
}

+ (NSString *)getIDCardAge:(NSString *)birthday{
    NSInteger birthDay = [[birthday substringWithRange: NSMakeRange(6, 2)] integerValue];
    NSInteger birthMonth = [[birthday substringWithRange:NSMakeRange(4, 2)] integerValue];
    NSInteger birthYear = [[birthday substringWithRange:NSMakeRange(0, 4)] integerValue];
    NSDateComponents * components = [[NSCalendar currentCalendar]components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear = [components year];
    NSInteger currentDateMonth = [components month];
    NSInteger currentDateDay = [components day];
    
    //判断
    NSInteger myAge = currentDateYear - birthYear;
    if (currentDateMonth <= birthMonth) {
        if (currentDateMonth == birthMonth) {
            if (currentDateDay < birthDay) {
                myAge--;
            }
        }else{
            myAge--;
        }
    }
    
    NSString * myAgeStr = [NSString stringWithFormat:@"%ld",(long)myAge];
    
    return myAgeStr;

}

+ (BOOL)getBirthday:(NSString *)birthday compareAge:(NSInteger)age{
    NSString *date = [self getIDCardAge:birthday];
    if ([date integerValue] < age) {
        return NO;
    }
    return YES;
}

+ (NSString *)getIDCardProvince:(NSString *)idCardNumber{
    NSString *provinceListPath = [[NSBundle mainBundle] pathForResource:@"idCardProvinceList" ofType:@"plist"];
    NSDictionary *provinceDic = [[NSDictionary alloc]initWithContentsOfFile:provinceListPath];
    NSString *provinceStr = [idCardNumber substringWithRange:NSMakeRange(0, 2)];
    NSString *pronvince = [provinceDic objectForKey:provinceStr];
    
    
    return pronvince;
}


@end
