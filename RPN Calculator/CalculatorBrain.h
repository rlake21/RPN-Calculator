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
- (double)performOperation:(NSString *)operation;

@end
