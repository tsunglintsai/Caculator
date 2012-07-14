//
//  CalculatorGraphicViewController.h
//  Calculator
//
//  Created by Henry Tsai on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"
#import "CalculatorGraphicView.h"

@protocol CalculatorGraphicViewDelegateDelegate
- (CGFloat) getYwithX:(CGFloat)x;
@end

@interface CalculatorGraphicViewController : UIViewController
@property (strong, nonatomic) NSString *programString;
@property (weak,nonatomic) id delegate;

@end
