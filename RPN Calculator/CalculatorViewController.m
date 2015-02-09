//
//  ViewController.m
//  RPN Calculator
//
//  Created by Ryan Lake on 1/14/15.
//  Copyright (c) 2015 Ryan Lake. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface ViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userEnteredADecimal;
@property (nonatomic, strong) CalculatorBrain *brain;
@end




@implementation ViewController

@synthesize display;
@synthesize enteredDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize userEnteredADecimal;
@synthesize brain = _brain;

- (CalculatorBrain *)brain{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *digit = [sender currentTitle];
    
    if (self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else{
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}

- (IBAction)variablePressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    [self.brain pushVariable:[sender currentTitle]];
    self.display.text = [sender currentTitle];
    [self enterPressed];
}

- (IBAction)decimalPressed:(id)sender {
    NSString *digit = [sender currentTitle];
    if (!self.userEnteredADecimal){
        if (self.userIsInTheMiddleOfEnteringANumber){
            self.display.text = [self.display.text stringByAppendingString:digit];
        } else{
            self.display.text = digit;
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
        self.userEnteredADecimal = YES;
    }
}

- (IBAction)enterPressed {
    NSString *previousDisplay = self.enteredDisplay.text;
    self.enteredDisplay.text = [NSString stringWithFormat:@"%@%s%@%s", previousDisplay, " ", self.display.text, " ="];
    
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userEnteredADecimal = NO;
}


- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    
    [self.brain pushOperation:operation];
    
    double result = [[self.brain performOperation:operation] doubleValue];
    self.display.text = [NSString stringWithFormat:@"%g",result];
    if ([operation  isEqual: @"Clear"]){
        self.enteredDisplay.text = [NSString stringWithFormat:@"Entered: "];
    } else {
        NSString *previousDisplay = self.enteredDisplay.text;
        self.enteredDisplay.text = [NSString stringWithFormat:@"%@%s%@",previousDisplay, " ", operation];
    }
}

@end
