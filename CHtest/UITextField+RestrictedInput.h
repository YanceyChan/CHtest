//
//  UITextField+RestrictedInput.h
//  CHtest
//
//  Created by 陈 远山 on 15/6/2.
//  Copyright (c) 2015年 exmaple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (RestrictedInput)
- (BOOL)textField:(UITextField *)textField restrictedInputString:(NSString *)inputString Length:(NSInteger)length characterSet:(NSString *)charachterSet;
@end
