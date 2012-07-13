//
//  CalculatorGraphicView.m
//  Calculator
//
//  Created by Henry Tsai on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorGraphicView.h"
@interface CalculatorGraphicView()
@property(nonatomic) CGPoint graphicOrigin;
@property(nonatomic) CGFloat graphicScale;

@end
@implementation CalculatorGraphicView
@synthesize graphicOrigin = _graphicOrigin;
@synthesize graphicScale = _graphicScale;

- (void)setup 
{ 
    
}

- (void)awakeFromNib 
{
    [self setup]; 
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{

}


@end
