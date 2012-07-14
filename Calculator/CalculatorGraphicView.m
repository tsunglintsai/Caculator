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
@synthesize delegate = _delegate;

- (AxesDrawer*)axesDrawer{
    if(_axesDrawer==nil){
        _axesDrawer = [[AxesDrawer alloc]init];
    }
    return _axesDrawer;
}

- (void)setup 
{ 
    self.origin = CGPointMake(self.bounds.origin.x+self.bounds.size.width/2, self.bounds.origin.y+self.bounds.size.height/2);
    self.scale = 1;
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

-(void) drawPath:(CGContextRef)ctxt
        fromPoint:(CGPoint)startPoint
          toPoint:(CGPoint)endPOint{
    UIGraphicsPushContext(ctxt);
    CGContextBeginPath(ctxt);
    CGContextMoveToPoint(ctxt, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(ctxt,endPOint.x, endPOint.y);
    CGContextClosePath(ctxt);
    [[UIColor redColor]setStroke];
    CGContextDrawPath(ctxt, kCGPathEOFillStroke);
    UIGraphicsPopContext();    
}

-(void) drawPath:(CGContextRef)ctxt
      withPoints:(NSArray*)pointArray{
    UIGraphicsPushContext(ctxt);
    CGContextBeginPath(ctxt);
    [pointArray enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        if([object isKindOfClass:[NSValue class]]){
            NSValue *pointValue = object;
            CGPoint currentPoint = [pointValue CGPointValue]; 
            if(idx==0){
                CGContextMoveToPoint(ctxt, currentPoint.x, currentPoint.y);            
            }else{
                CGContextAddLineToPoint(ctxt,currentPoint.x, currentPoint.y);
            }
        }
    }];
    [[UIColor blueColor]setStroke];
    CGContextDrawPath(ctxt, kCGPathStroke);
    UIGraphicsPopContext();    
}



- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[self.axesDrawer class]drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
    NSMutableArray *pointList = [[NSMutableArray alloc]init];
    for(CGFloat  i= 0; i < self.bounds.size.width ; i=i+1){
        CGFloat x= (i - self.origin.x)/self.scale;
        CGFloat y = [self.delegate getYwithX:x];		
        CGPoint coordinatePostion = CGPointMake(i,self.origin.y-y*self.scale);
        [pointList addObject:[NSValue valueWithCGPoint: coordinatePostion]];
    }
    [self drawPath:context withPoints:pointList];
}


@end
