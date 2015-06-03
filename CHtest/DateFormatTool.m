//
//  DateFormatVerifyTool.m
//  CHtest
//
//  Created by 陈 远山 on 15/6/2.
//  Copyright (c) 2015年 exmaple. All rights reserved.
//

#import "DateFormatTool.h"

@implementation DateFormatTool
+ (BOOL)verifyEightFigureDate:(NSString *)date{
    date = [date stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([date length] != 8) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *regex = [NSString stringWithFormat:@"%@", yyyyMmdd];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:date]) {
        return NO;
    }
    return YES;
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

+ (NSString *)getViliditydateFromApplydate: (NSString *)applydate{
    NSString *applyYear = [applydate substringWithRange:NSMakeRange(0, 4)];
    NSString *applyMonth = [applydate substringWithRange:NSMakeRange(4, 2)];
    //    NSString *applyDay = [applydate substringWithRange:NSMakeRange(5, 2)];
    NSInteger validityYearInt = 0;
    NSInteger validityMonthInt = 0;
    NSInteger validityDayInt = 0;
    if ([applyMonth isEqualToString:@"01"]){
        validityYearInt = [applyYear integerValue];
        validityMonthInt = 12;
        validityDayInt = 31;
    }else{
        validityYearInt = [applyYear integerValue] + 1;
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
@end
