//
//  NSString+Restricted.m
//  CHtest
//
//  Created by 陈 远山 on 15/6/2.
//  Copyright (c) 2015年 exmaple. All rights reserved.
//

#import "NSString+Restricted.h"

@implementation NSString (Restricted)
- (BOOL)restrictStringFollowRegex:(NSString *)regex{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self] || [self isEqualToString:@""];

}

- (BOOL)onlyHasDigit{
    return [self restrictStringFollowRegex:@"^\\d*$"];
}

- (BOOL)onlyHasDigitLength:(NSInteger)length{
    NSString *regex = [NSString stringWithFormat:@"^\\d{0,%ld}$", length];
    return [self restrictStringFollowRegex:regex];
}

- (BOOL)onlyHasDigitLength:(NSInteger)length decimalPointLength:(NSInteger) decimalPointLength{
    NSString *regex = [NSString stringWithFormat:@"^[1-9]\\d{0,%ld}([\\.]\\d{0,%ld})?$", length - 1, decimalPointLength];
    return [self restrictStringFollowRegex:regex];
}

- (BOOL)onlyHasDigitLength:(NSInteger)length plusAndMinusSign:(BOOL)plusOrMinus{
    if (plusOrMinus) {
        NSString *regex = [NSString stringWithFormat:@"^[+]?[0-9]{0,%ld}$", length];
        return [self restrictStringFollowRegex:regex];
    }
    else{
        NSString *regex = [NSString stringWithFormat:@"^[-]?[0-9]{0,%ld}$", length];
        return [self restrictStringFollowRegex:regex];
    }
}

- (BOOL)hasDigitAndXLength:(NSInteger)length{
    NSString *regex = [NSString stringWithFormat:@"^[0-9Xx]{0,%ld}$", length];
    return [self restrictStringFollowRegex:regex];
}

- (BOOL)anyCharacterLength:(NSInteger)length{
    NSString *regex = [NSString stringWithFormat:@"^\\S{0,%ld}$", length];
    return [self restrictStringFollowRegex:regex];
}

- (BOOL)onlyHasDigitAndAlphabet{
    return [self restrictStringFollowRegex:@"^[a-zA-Z0-9_]*$"];
}

- (BOOL)onlyHasDigitAndAlphabetLength:(NSInteger)length {
    return [self restrictStringFollowRegex:[NSString stringWithFormat:@"^[a-zA-Z0-9_]{0,%ld}$", length]];
}

- (NSString *)checkDotInAmount {
    NSString *string = nil;
    if (![self containsString:@"."]) {
        string = [self stringByAppendingString:@".00"];
    } else {
        if ([[self componentsSeparatedByString:@"."][1] length] == 1) {
            string = [self stringByAppendingString:@"0"];
        } else {
            string = self;
        }
    }
    return string;
}

@end
