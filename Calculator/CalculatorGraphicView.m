//
//  CalculatorGraphicView.m
//  Calculator
//
//  Created by Henry Tsai on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorGraphicView.h"
#import "AxesDrawer.h"

@interface CalculatorGraphicView()
@property(nonatomic) CGPoint graphicOrigin;
@property(nonatomic) CGFloat graphicScale;
@property(nonatomic,strong) AxesDrawer *axesDrawer;
@end
@implementation CalculatorGraphicView
@synthesize graphicOrigin = _graphicOrigin;
@synthesize graphicScale = _graphicScale;
@synthesize axesDrawer = _axesDrawer;

- (AxesDrawer*)axesDrawer{
    if(_axesDrawer==nil){
        _axesDrawer = [[AxesDrawer alloc]init];
    }
    return _axesDrawer;
}


- (void)setup 
{ 
    
}

- (CGFloat) getYwithX:(int)x{
    CGFloat result = 0.0;
    
    
    
    return result;
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
    CGPoint centerOfView = CGPointMake(self.bounds.origin.x+self.bounds.size.width/2, self.bounds.origin.y+self.bounds.size.height/2);
    [[self.axesDrawer class]drawAxesInRect:self.bounds originAtPoint:centerOfView scale:1.0];
}


@end
