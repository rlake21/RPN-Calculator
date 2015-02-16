//
//  UIVIew.h
//  RPN Calculator
//
//  Created by Ryan Lake on 2/1/15.
//  Copyright (c) 2015 Ryan Lake. All rights reserved.
//


#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource
- (float)YValueForXValue:(float)xValue inGraphView:(GraphView *)sender;
- (void)storeScale:(float)scale ForGraphView: (GraphView *)sender;
- (void)storeAxisOriginX:(float)x andAxisOriginY:(float)y ForGraphView: (GraphView *)sender;

@end

@interface GraphView : UIView

@property(nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@property(nonatomic) CGFloat scale;
@property(nonatomic) CGPoint axisOrigin;


@end

