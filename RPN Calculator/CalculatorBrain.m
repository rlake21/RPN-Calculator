//
//  CalculatorBrain.m
//  RPN Calculator
//
//  Created by Ryan Lake on 1/14/15.
//  Copyright (c) 2015 Ryan Lake. All rights reserved.
//

#import "CalculatorBrain.h"


@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack{
    if (!_programStack){
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    // TODO: write however you would like to display the sequence of operands, variables, operations on stack
    return @"Implement this in Homework #2";
}


- (void)pushOperation:(NSString *) operation {
    [self.programStack addObject:operation];
}
-(void)pushOperand:(double)operand{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}
-(void)pushVariable:(NSString*)variable{
    [self.programStack addObject:variable];
}

- (id)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (id)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [[self popOperandOffProgramStack:stack] doubleValue] +
            [[self popOperandOffProgramStack:stack] doubleValue];
        } else if ([@"*" isEqualToString:operation]) {
            result = [[self popOperandOffProgramStack:stack] doubleValue] *
            [[self popOperandOffProgramStack:stack] doubleValue];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [[self popOperandOffProgramStack:stack] doubleValue];
            result = [[self popOperandOffProgramStack:stack] doubleValue] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [[self popOperandOffProgramStack:stack] doubleValue];
            if (divisor) result = [[self popOperandOffProgramStack:stack] doubleValue] / divisor;
        } else if ([operation isEqualToString:@"sin()"]){
            result = sin([[self popOperandOffProgramStack:stack] doubleValue]);
        } else if ([operation isEqualToString:@"cos()"]){
            result = cos([[self popOperandOffProgramStack:stack] doubleValue]);
        } else if ([operation isEqualToString:@"sqrt()"]){
            double number = [[self popOperandOffProgramStack:stack] doubleValue];
            if (number > 0) result = sqrt(number);
        } else if ([operation isEqualToString:@"π"]){
            result = 3.141592;
        } else if ([operation isEqualToString:@"Clear"]){
            if(topOfStack)
                while (topOfStack){
                    [stack removeLastObject];
                    topOfStack = [stack lastObject];
                }
        }
    }
    
    return [NSNumber numberWithDouble:result];
}

+ (BOOL)isOperation:(NSString *)operation {
    
    if ([operation isEqualToString:@"+"]) return YES;
    if ([operation isEqualToString:@"-"]) return YES;
    if ([operation isEqualToString:@"/"]) return YES;
    if ([operation isEqualToString:@"*"]) return YES;
    if ([operation isEqualToString:@"sin()"]) return YES;
    if ([operation isEqualToString:@"cos()"]) return YES;
    if ([operation isEqualToString:@"sqrt()"]) return YES;
    
    else return NO;
}

+ (id)runProgram:(id)program
usingVariableValues:(NSDictionary *)variableValues {
    
    
    NSMutableArray *stack= [program mutableCopy];
    
    // For each item in the program
    for (int i=0; i < [stack count]; i++) {
        id obj = [stack objectAtIndex:i];
        
        // See whether we think the item is a variable
        if ([obj isKindOfClass:[NSString class]] && ![self isOperation:obj]) {
            id value = [variableValues objectForKey:obj];
            // If value is not an instance of NSNumber, set it to zero
            if (![value isKindOfClass:[NSNumber class]]) {
                value = [NSNumber numberWithInt:0];
            }
            // Replace program variable with value.
            [stack replaceObjectAtIndex:i withObject:value];
        }		
    }	
    // Starting popping off the stack
    return [self popOperandOffProgramStack:stack];	
}

+ (id)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}


@end

/*
- (double)popOperand {
    NSNumber *operandObject = [self.programStack lastObject];
    if (operandObject) [self.programStack removeLastObject];
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation{
    
    double result = 0;
    
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([@"*" isEqualToString:operation]){
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"-"]){
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([operation isEqualToString:@"/"]){
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    } else if ([operation isEqualToString:@"sin()"]){
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos()"]){
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"sqrt()"]){
        double number = [self popOperand];
        if (number > 0) result = sqrt(number);
    } else if ([operation isEqualToString:@"π"]){
        result = 3.141592;
    } else if ([operation isEqualToString:@"Clear"]){
        NSNumber *operandObject = [self.programStack lastObject];
        while (operandObject){
           [self.programStack removeLastObject];
            operandObject = [self.programStack lastObject];
        }
    }
    
    [self pushOperand:result];
    
    return result;
}
*/


/*
 
 @interface CalculatorBrain()
 @property (nonatomic, strong) NSMutableArray *programStack;
 @end
 
 @implementation CalculatorBrain
 
 @synthesize programStack = _programStack;
 
 - (NSMutableArray *)programStack
 {
 if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
 return _programStack;
 }
 
 - (id)program
 {
 return [self.programStack copy];
 }
 
 + (NSString *)descriptionOfProgram:(id)program
 {
 return @"Implement this in Homework #2";
 }
 
 - (void)pushOperand:(double)operand
 {
 [self.programStack addObject:[NSNumber numberWithDouble:operand]];
 }
 
 - (double)performOperation:(NSString *)operation
 {
 [self.programStack addObject:operation];
 return [[self class] runProgram:self.program];
 }
 
 + (double)popOperandOffProgramStack:(NSMutableArray *)stack
 {
 double result = 0;
 
 id topOfStack = [stack lastObject];
 if (topOfStack) [stack removeLastObject];
 
 if ([topOfStack isKindOfClass:[NSNumber class]])
 {
 result = [topOfStack doubleValue];
 }
 else if ([topOfStack isKindOfClass:[NSString class]])
 {
 NSString *operation = topOfStack;
 if ([operation isEqualToString:@"+"]) {
 result = [self popOperandOffProgramStack:stack] +
 [self popOperandOffProgramStack:stack];
 } else if ([@"*" isEqualToString:operation]) {
 result = [self popOperandOffProgramStack:stack] *
 [self popOperandOffProgramStack:stack];
 } else if ([operation isEqualToString:@"-"]) {
 double subtrahend = [self popOperandOffProgramStack:stack];
 result = [self popOperandOffProgramStack:stack] - subtrahend;
 } else if ([operation isEqualToString:@"/"]) {
 double divisor = [self popOperandOffProgramStack:stack];
 if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
 }
 }
 
 return result;
 }
 
 + (double)runProgram:(id)program
 {
 NSMutableArray *stack;
 if ([program isKindOfClass:[NSArray class]]) {
 stack = [program mutableCopy];
 }
 return [self popOperandOffProgramStack:stack];
 }
 
 @end
 */
