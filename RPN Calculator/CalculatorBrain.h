//
//  CalculatorBrain.h
//  RPN Calculator
//
//  Created by Ryan Lake on 1/14/15.
//  Copyright (c) 2015 Ryan Lake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)pushOperation:(NSString *) operation;
- (id)performOperation:(NSString *)operation;
- (void)pushVariable:(NSString*)variable;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;

+ (id)runProgram:(id)program;
+ (id)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValue;

@end
