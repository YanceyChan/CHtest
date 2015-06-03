//
//  ViewController.m
//  CHtest
//
//  Created by 陈 远山 on 15/6/1.
//  Copyright (c) 2015年 exmaple. All rights reserved.
//

#import "ViewController.h"
#import "IDCardVerifyAndExtractTool.h"
#import "DateFormatTool.h"
#import "NSString+Restricted.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UIButton    *myButton;
@property (weak, nonatomic) IBOutlet UIView      *myView;
@property (weak, nonatomic) IBOutlet UILabel     *mySexLabel;
@property (weak, nonatomic) IBOutlet UILabel     *myBirthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel     *myAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel     *myProvinceLabel;
@property (weak, nonatomic) IBOutlet UILabel     *myViliditydateLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myView.backgroundColor = [UIColor redColor];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)didTapMyButton:(id)sender {
    if ([IDCardVerifyAndExtractTool verifyIDCardNumberInTheRange:self.myTextField.text]) {
        if ([IDCardVerifyAndExtractTool verifyIDCardParityBitIsCorrect:self.myTextField.text]) {
            
            self.myView.backgroundColor = [UIColor greenColor];
            
            self.mySexLabel.text = [IDCardVerifyAndExtractTool getIDCardSex:self.myTextField.text]?@"男":@"女";
            self.myBirthdayLabel.text = [IDCardVerifyAndExtractTool getIDCardBirthday:self.myTextField.text];
            self.myAgeLabel.text = [IDCardVerifyAndExtractTool getIDCardAge:self.myBirthdayLabel.text];
            self.myProvinceLabel.text = [IDCardVerifyAndExtractTool getIDCardProvince:self.myTextField.text];
            return;
        }
        else{
            [self clearData];
            
            NSLog(@"校验位不正确");
        }
    }
    else{
        [self clearData];
        NSLog(@"范围不正确");
    }
    
    if ([DateFormatTool verifyEightFigureDate:self.myTextField.text]) {
        self.myViliditydateLabel.text = [DateFormatTool getViliditydateFromApplydate:self.myTextField.text];
        self.myView.backgroundColor = [UIColor greenColor];
        
    }
    else{
        [self clearData];
        NSLog(@"8位日期格式（YYYYMMdd）不正确");
    }
    
}

- (void)clearData{
    self.myView.backgroundColor   = [UIColor redColor];
    self.mySexLabel.text          = @"";
    self.myBirthdayLabel.text     = @"";
    self.myAgeLabel.text          = @"";
    self.myProvinceLabel.text     = @"";
    self.myViliditydateLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return [toBeString onlyHasDigitLength:6 plusAndMinusSign:NO];
    
}

@end
