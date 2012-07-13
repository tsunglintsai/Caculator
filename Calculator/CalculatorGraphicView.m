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
@property(nonatomic) CGFloat scale;
@property(nonatomic,strong) AxesDrawer *axesDrawer;
@property(nonatomic) CGFloat previousRotation;
@property(nonatomic) CGFloat previousScale;
@property(nonatomic) CGPoint origin;

@end
@implementation CalculatorGraphicView
@synthesize scale = _scale;
@synthesize axesDrawer = _axesDrawer;
@synthesize previousRotation = _previousRotation;
@synthesize previousScale = _previousScale;
@synthesize origin = _origin;

- (AxesDrawer*)axesDrawer{
    if(_axesDrawer==nil){
        _axesDrawer = [[AxesDrawer alloc]init];
    }
    return _axesDrawer;
}

- (void)setup 
{ 
    self.origin = CGPointMake(self.bounds.origin.x+self.bounds.size.width/2, self.bounds.origin.y+self.bounds.size.height/2);
    self.scale = 1.0;
    self.previousScale = 1.0;
}

- (void)panGestureFired:(UIPanGestureRecognizer *)recognizer
{
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded)) 
    {
        CGPoint translation = [recognizer translationInView:self];
        self.origin = CGPointMake(self.origin.x+translation.x, self.origin.y+translation.y);
        [recognizer setTranslation:CGPointZero inView:self];
        [self setNeedsDisplay];

    }
}

- (void)pinchGestureFired:(UIPinchGestureRecognizer *)recognizer
{
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        self.previousScale = self.scale;
        return;
    }
    self.scale = (self.previousScale * [recognizer scale]);
    [self setNeedsDisplay];
}

- (void)tapGestureFired:(UITapGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer locationInView:self];
    self.origin = translation;
    [self setNeedsDisplay];
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
    [[self.axesDrawer class]drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
}


@end
