//
//  ViewController.h
//  RPN Calculator
//
//  Created by Ryan Lake on 1/14/15.
//  Copyright (c) 2015 Ryan Lake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"



@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *enteredDisplay;
@property (weak, nonatomic) IBOutlet UILabel *programDescriptionDisplay;

//TODO: add another property (of type outlet) that displays the o/p from descriptionOfProgram

@end


@protocol ControllerDelagate
@property (nonatomic) id delegateController;
@end