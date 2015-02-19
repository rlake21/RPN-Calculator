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

+ (NSString *)descriptionOfProgram:(id)program {
    NSString *yEquals = @"y = ";
    
    NSMutableArray *stackCopy = [program mutableCopy];
    //NSMutableArray *operandArray;
    //NSMutableArray *operationArray;
    
    id topOfStack = [stackCopy lastObject];/*
    while (topOfStack){
        /*
        if ([topOfStack isKindOfClass:[NSNumber class]]){
            [operandArray addObject:topOfStack];
        } else {//if ([CalculatorBrain isOperation: topOfStack]){
            [operationArray addObject:topOfStack];
        }
        yEquals = [yEquals stringByAppendingString:topOfStack];
        [stackCopy removeLastObject];//this line breaks at runtime
        topOfStack = [stackCopy lastObject];
    }*/
    return yEquals;
}


- (void)pushOperation:(NSString *) operation {
    [self.programStack addObject:operation];
}
-(void)pushOperand:(double)operand{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
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
            result = M_PI;
        } else if ([operation isEqualToString:@"Clear"]){
            [stack removeAllObjects];
            return nil;
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
    if ([operation isEqualToString:@"π"]) return YES;
    if ([operation isEqualToString:@"sqrt()"]) return YES;
    if ([operation isEqualToString:@"Clear"]) return YES;
    
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
