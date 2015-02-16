//
//  ViewController.h
//  RPN Calculator
//
//  Created by Ryan Lake on 1/14/15.
//  Copyright (c) 2015 Ryan Lake. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ControllerDelegate
@property (nonatomic) id delegateController;
@end
@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *enteredDisplay;
//@property (nonatomic) id delegateController;




@property (nonatomic) id<ControllerDelegate> popoverDelegate;
@end
