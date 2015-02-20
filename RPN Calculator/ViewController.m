//
//  ViewController.m
//  RPN Calculator
//
//  Created by Ryan Lake on 1/14/15.
//  Copyright (c) 2015 Ryan Lake. All rights reserved.
//

#import "ViewController.h"
#import "GraphViewController.h"
#import "CalculatorBrain.h"

@interface ViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) NSDictionary *variableValue;
@property (nonatomic) BOOL userEnteredADecimal;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) id<ControllerDelagate> popoverDelegate;
@end




@implementation ViewController

@synthesize display;
@synthesize enteredDisplay;
@synthesize programDescriptionDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize userEnteredADecimal;
@synthesize brain = _brain;


- (GraphViewController *)graphViewController {
    // TODO: declare the delegate protocol in viewcontroller.h to be able to use this functionality
    return self.popoverDelegate ?
    self.popoverDelegate :[self.splitViewController.viewControllers lastObject];
}


- (CalculatorBrain *)brain {
    // TODO: Ditto from above. Declare the delegate protocol in viewcontroller.h to be able to use this functionality
    if (self.popoverDelegate) _brain = [[self.popoverDelegate delegateController] brain];
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}


- (void)setBrain:(CalculatorBrain *)brain {
    _brain = brain;
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
    NSString *title = [sender currentTitle];
    [self.brain pushVariable:title];
    self.display.text = [sender currentTitle];
}


- (NSDictionary *)variableValues {
    
    
    // create a dictionary which holds the value of variable. Can be easily extended to keep more than one variable.
    if (!_variableValue) {
        _variableValue =  [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:4], @"x",nil];
    }
    
    return _variableValue;
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
    
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self updateView];
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    NSString *operation = [sender currentTitle];
    NSString *previousDisplay = self.enteredDisplay.text;
    
    if ([operation  isEqualToString: @"Clear"]){
        self.enteredDisplay.text = [NSString stringWithFormat:@"Entered: "];
        self.display.text = @"0";
    }else{
        self.enteredDisplay.text = [NSString stringWithFormat:@"%@%s%@",previousDisplay, " ", operation];
    }
    [self.brain pushOperation:[sender currentTitle]];
    [self updateView];
    
    
}
- (IBAction)graphItPressed:(id)sender {
    NSString *programDescription = [CalculatorBrain descriptionOfProgram:self.brain.program];
    self.programDescriptionDisplay.text = [NSString stringWithFormat:@"%s%@","Graphing: ",programDescription];
}

-(void)updateView {
    
    // Find the result by running the program passing in the test variable values
    id result = [CalculatorBrain runProgram:self.brain.program
                        usingVariableValues:self.variableValue];
    
    // update display property based on the type of the result. If string, display as is. if number, convert to string format.
    NSString *previousDisplay = self.enteredDisplay.text;
    if(result != nil){
        self.enteredDisplay.text = [NSString stringWithFormat:@"%@%s%@", previousDisplay, " ", result];
        self.display.text = [NSString stringWithFormat:@"%@",result];
    } else {
        self.enteredDisplay.text = [NSString stringWithFormat:@"Entered: "];
        self.display.text = @"0";
        self.programDescriptionDisplay.text = [NSString stringWithFormat:@" "];
        [self.brain.program removeAllObjects];
    }
    
    // update the label with description of program
    
    
    
    // And the user isn't in the middle of entering a number
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userEnteredADecimal = NO;
}

@end
