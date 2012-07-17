//
//  CalculatorGraphicView.h
//  Calculator
//
//  Created by Henry Tsai on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

#define performanceOptimizatiOn YES

@protocol CalculatorGraphicViewDelegate<SplitViewBarButtonItemPresenter>
- (CGFloat) getYwithX:(CGFloat)x;
@end

@interface CalculatorGraphicView : UIView
@property (weak,nonatomic) id<CalculatorGraphicViewDelegate> delegate;  
@property(nonatomic) NSValue *origin;
@property(nonatomic) NSNumber *scale;

@end
