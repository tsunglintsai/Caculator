//
//  CalculatorGraphicViewController.h
//  Calculator
//
//  Created by Henry Tsai on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface CalculatorGraphicViewController : UIViewController
@property (weak, nonatomic) CalculatorBrain *brain;

@end
