//
//  ViewController.m
//  RPN Calculator
//
//  Created by Ryan Lake on 1/14/15.
//  Copyright (c) 2015 Ryan Lake. All rights reserved.
//


#import "CalculatorViewController.h"
#import "GraphViewController.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userInMiddleOfEnteringNumber;
@property (nonatomic, strong) NSDictionary *variableValue;
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize brain = _brain;

@synthesize userInMiddleOfEnteringNumber;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return self.splitViewController ?
    YES : UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}


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

- (NSDictionary *)variableValues {
    
    
    // create a dictionary which holds the value of variable. Can be easily extended to keep more than one variable.
    
    return _variableValue;
}


-(void)updateView {
    
    // Find the result by running the program passing in the test variable values
    id result = [CalculatorBrain runProgram:self.brain.program
                        usingVariableValues:self.variableValue];
    
    // update display property based on the type of the result. If string, display as is. if number, convert to string format.
    
    // update the label with description of program
    
    
    
    // And the user isn't in the middle of entering a number
    //self.userInMiddleOfEnteringNumber = NO;
}


- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    
    if (self.userInMiddleOfEnteringNumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userInMiddleOfEnteringNumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userInMiddleOfEnteringNumber) {
        [self enterPressed];
    }
    
    // don't perform the operation; instead, push it onto the stack and updateView.
    
    [self.brain pushOperation:[sender currentTitle]];
    [self updateView];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self updateView];
}


- (IBAction)variablePressed:(UIButton *)sender {
    
    // push variable and updateView
    
    [self.brain pushVariable:sender.currentTitle];
    [self updateView];
}


- (IBAction)drawGraphPressed {
    
    if ([self graphViewController]) {
        [[self graphViewController] setProgram:self.brain.program];
        [[self graphViewController] refreshView ];
    } else {
        [self performSegueWithIdentifier:@"DisplayGraphView" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setProgram:self.brain.program];
}


- (void)viewDidAppear:(BOOL)animated {
    [self updateView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end


/*
#import "ViewController.h"
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
*/
- (IBAction)variablePressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    [self.brain pushVariable:[sender currentTitle]];
    self.display.text = [sender currentTitle];
    [self enterPressed];
}
/*
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
    self.enteredDisplay.text = [NSString stringWithFormat:@"%@%s%@", previousDisplay, " ", self.display.text];
    
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userEnteredADecimal = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g",result];
    if ([operation  isEqual: @"Clear"]){
        self.enteredDisplay.text = [NSString stringWithFormat:@"Entered: "];
    } else {
        NSString *previousDisplay = self.enteredDisplay.text;
        self.enteredDisplay.text = [NSString stringWithFormat:@"%@%s%@",previousDisplay, " ", operation];
    }
}

@end
 */
