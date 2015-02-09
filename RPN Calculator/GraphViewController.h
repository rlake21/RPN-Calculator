//
//  UIViewController.h
//  RPN Calculator
//
//  Created by Ryan Lake on 2/1/15.
//  Copyright (c) 2015 Ryan Lake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) id program;

- (void)refreshView;

@end