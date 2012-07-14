//
//  CalculatorGraphicView.h
//  Calculator
//
//  Created by Henry Tsai on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalculatorGraphicViewDelegate
- (CGFloat) getYwithX:(CGFloat)x;
@end

@interface CalculatorGraphicView : UIView
@property (weak,nonatomic) id delegate;  

@end
