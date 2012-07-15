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
@property(nonatomic,strong) AxesDrawer *axesDrawer;
@property(nonatomic) CGFloat previousScale;
@property(nonatomic,strong) NSUserDefaults *userDefaults;

@end

@implementation CalculatorGraphicView
@synthesize scale = _scale;
@synthesize axesDrawer = _axesDrawer;
@synthesize previousScale = _previousScale;
@synthesize origin = _origin;
@synthesize delegate = _delegate;
@synthesize userDefaults = _userDefaults;

NSString * const UserDefaultKeyStringScale = @"SCALE";
NSString * const UserDefaultKeyStringOriginX = @"ORIGIN.X";
NSString * const UserDefaultKeyStringOriginY = @"ORIGIN.Y";


- (AxesDrawer*)axesDrawer
{
    if(_axesDrawer==nil){
        _axesDrawer = [[AxesDrawer alloc]init];
    }
    return _axesDrawer;
}

- (void)setup 
{ 
    
}

- (NSUserDefaults*) userDefaults{
    if(_userDefaults == nil){
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (NSNumber*)scale{
    if(_scale==nil){
        _scale = [self.userDefaults objectForKey:UserDefaultKeyStringScale];
        if(_scale == nil){
            _scale = [NSNumber numberWithFloat:1.0];            
        }
        self.previousScale = _scale.floatValue;
    }
    return _scale;
}

- (void) setScale:(NSNumber *)scale{
    _scale = scale;
    [self.userDefaults setValue:_scale forKey:UserDefaultKeyStringScale];
    //[self.userDefaults synchronize];
}

- (NSValue*)origin{
    if(_origin==nil){
        NSNumber *originalXinUserDefault = [self.userDefaults objectForKey:UserDefaultKeyStringOriginX];
        NSNumber *originalYinUserDefault = [self.userDefaults objectForKey:UserDefaultKeyStringOriginY];
        if(originalXinUserDefault != nil && originalYinUserDefault != nil){
            _origin = [NSValue valueWithCGPoint:CGPointMake(originalXinUserDefault.floatValue, originalYinUserDefault.floatValue)];
        }
        if(_origin == nil){
            _origin = 
            [NSValue valueWithCGPoint:CGPointMake(self.bounds.origin.x+self.bounds.size.width/2, self.bounds.origin.y+self.bounds.size.height/2)];    
        }
    }
    return _origin;
}

- (void) setOrigin:(NSValue *)origin{
    _origin = origin;
    [self.userDefaults setValue:[NSNumber numberWithFloat:_origin.CGPointValue.x] forKey:UserDefaultKeyStringOriginX];
    [self.userDefaults setValue:[NSNumber numberWithFloat:_origin.CGPointValue.y] forKey:UserDefaultKeyStringOriginY];    
    //[self.userDefaults synchronize];    
}

- (void)panGestureFired:(UIPanGestureRecognizer *)recognizer
{
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded)) 
    {
        CGPoint translation = [recognizer translationInView:self];
        self.origin = [NSValue valueWithCGPoint: CGPointMake(self.origin.CGPointValue.x+translation.x, self.origin.CGPointValue.y+translation.y)];
        [recognizer setTranslation:CGPointZero inView:self];
        [self setNeedsDisplay];

    }
}

- (void)pinchGestureFired:(UIPinchGestureRecognizer *)recognizer
{
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        self.previousScale = self.scale.floatValue;
        return;
    }
    self.scale = [NSNumber numberWithFloat:(self.previousScale * [recognizer scale])];
    [self setNeedsDisplay];
}

- (void)tapGestureFired:(UITapGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer locationInView:self];
    self.origin = [NSValue valueWithCGPoint: translation];
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

- (void) drawPath:(CGContextRef)ctxt
       withPoints:(NSArray*)pointArray
{
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
    [[self.axesDrawer class]drawAxesInRect:self.bounds originAtPoint:self.origin.CGPointValue scale:self.scale.floatValue];
    
    NSMutableArray *pointList = [[NSMutableArray alloc]init];
    for(CGFloat  i= 0; i < self.bounds.size.width ; i=i+1){
        CGFloat x= (i - self.origin.CGPointValue.x)/self.scale.floatValue;
        CGFloat y = [self.delegate getYwithX:x];	
        CGPoint coordinatePostion = CGPointMake(i,self.origin.CGPointValue.y-y*self.scale.floatValue);
        [pointList addObject:[NSValue valueWithCGPoint: coordinatePostion]];
    }     
    [self drawPath:context withPoints:pointList];
    
}



@end
