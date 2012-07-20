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
@property(nonatomic) dispatch_queue_t serialQueue;
@property(nonatomic,strong) NSOperationQueue *queue;
@end

@implementation CalculatorGraphicView
@synthesize scale = _scale;
@synthesize axesDrawer = _axesDrawer;
@synthesize previousScale = _previousScale;
@synthesize origin = _origin;
@synthesize datasource = _delegate;
@synthesize userDefaults = _userDefaults;
@synthesize serialQueue = _serialQueue;
@synthesize queue = _queue;
@synthesize drawMode = _drawMode;

NSString * const UserDefaultKeyStringScale = @"SCALE";
NSString * const UserDefaultKeyStringOriginX = @"ORIGIN.X";
NSString * const UserDefaultKeyStringOriginY = @"ORIGIN.Y";

- (NSOperationQueue*) queue{
    if(_queue == nil){
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
}
- (AxesDrawer*)axesDrawer
{
    if(_axesDrawer==nil){
        _axesDrawer = [[AxesDrawer alloc]init];
    }
    return _axesDrawer;
}

- (void)setup 
{ 
    self.serialQueue =  dispatch_queue_create("com.pyrogusto.serial", 0); 
}

- (UIImageView*)imageView{
    UIImageView* result;
    for (id object in self.subviews) {
        if([object isKindOfClass:[UIImageView class]]){
            result = object;
        }
    }
    return result;
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
    [self.userDefaults synchronize];
    [self setNeedsDisplay];
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
    [self.userDefaults synchronize];    
    [self setNeedsDisplay];
}

- (void)panGestureFired:(UIPanGestureRecognizer *)recognizer
{
    if ((recognizer.state == UIGestureRecognizerStateChanged) ||
        (recognizer.state == UIGestureRecognizerStateEnded)) 
    {
        CGPoint translation = [recognizer translationInView:self];
        //NSLog(@"%g,%g",translation.x,translation.y);
        float threadHoldValue = 0;
        if(performanceOptimizatiOn){
            threadHoldValue = 4;
        }
        if(abs(translation.x)>threadHoldValue || abs(translation.y) >threadHoldValue){
            self.origin = [NSValue valueWithCGPoint: CGPointMake(self.origin.CGPointValue.x+translation.x, self.origin.CGPointValue.y+translation.y)];
            [recognizer setTranslation:CGPointZero inView:self];
            self.imageView.center = CGPointMake( self.imageView.center.x +translation.x, self.imageView.center.y +translation.y);
        }
    }
}

- (void)pinchGestureFired:(UIPinchGestureRecognizer *)recognizer
{
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        self.previousScale = self.scale.floatValue;
        return;
    }
    self.scale = [NSNumber numberWithFloat:(self.previousScale * [recognizer scale])];
}

- (void)tapGestureFired:(UITapGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer locationInView:self];
    self.origin = [NSValue valueWithCGPoint: translation];
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



- (void)draw1{
    [[self.axesDrawer class]drawAxesInRect:self.bounds originAtPoint:self.origin.CGPointValue scale:self.scale.floatValue];    
    NSMutableArray *pointList = [[NSMutableArray alloc]init];
    for(CGFloat  i= 0; i < self.bounds.size.width ; i=i+1/self.contentScaleFactor){
        CGFloat x= (i - self.origin.CGPointValue.x)/self.scale.floatValue;
        CGFloat y = [self.datasource getYwithX:x];	
        CGPoint coordinatePostion = CGPointMake(i,self.origin.CGPointValue.y-y*self.scale.floatValue);
        [pointList addObject:[NSValue valueWithCGPoint: coordinatePostion]];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();    
    [self drawPath:context withPoints:pointList];        
}

- (void)draw2{
    CGSize boundSize = self.bounds.size;
    CGPoint orgin = self.origin.CGPointValue;
    CGFloat scale = self.scale.floatValue;
    CGFloat scaleFactor = self.contentScaleFactor;
    [[self.axesDrawer class]drawAxesInRect:self.bounds originAtPoint:self.origin.CGPointValue scale:self.scale.floatValue];                          
    [self.queue cancelAllOperations];
    [self.queue addOperationWithBlock:^{
        NSMutableArray *pointList = [[NSMutableArray alloc]init];
        for(CGFloat  i= 0; i < boundSize.width ; i=i+1/scaleFactor){
            CGFloat x= (i - orgin.x)/scale;
            CGFloat y = [self.datasource getYwithX:x];	
            CGPoint coordinatePostion = CGPointMake(i,orgin.y-y*scale);
            [pointList addObject:[NSValue valueWithCGPoint: coordinatePostion]];
        }
        //UIGraphicsBeginImageContext(boundSize);
        UIGraphicsBeginImageContextWithOptions(boundSize, 0, 0.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextBeginPath(ctx);
        [pointList enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            if([object isKindOfClass:[NSValue class]]){
                NSValue *pointValue = object;
                CGPoint currentPoint = [pointValue CGPointValue]; 
                if(idx==0){
                    CGContextMoveToPoint(ctx, currentPoint.x, currentPoint.y);            
                }else{
                    CGContextAddLineToPoint(ctx,currentPoint.x, currentPoint.y);
                }
            }
        }];
        [[UIColor blueColor]setStroke];
        CGContextDrawPath(ctx, kCGPathStroke);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();        
        UIGraphicsEndImageContext();       
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = nil;
            self.imageView.center = CGPointMake(self.imageView.bounds.size.width/2,self.imageView.bounds.size.height/2);
            self.imageView.image = image;
        });
    }];
}
-(void)draw3{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[self.axesDrawer class]drawAxesInRect:self.bounds originAtPoint:self.origin.CGPointValue scale:self.scale.floatValue];
    NSMutableArray *pointList = [[NSMutableArray alloc]initWithCapacity:self.bounds.size.width];    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0); 
    CGPoint originStruct = CGPointMake(self.origin.CGPointValue.x, self.origin.CGPointValue.y);
    CGFloat scale = self.scale.floatValue;
    for(int i = 0 ; i < self.bounds.size.width; i++){
        [pointList addObject:[NSValue valueWithCGPoint: CGPointMake(0,0)]];
    }
    dispatch_apply(self.bounds.size.width, concurrentQueue,  ^(size_t i){
        CGFloat x= (i - originStruct.x)/scale;
        CGFloat y = [self.datasource getYwithX:x];	
        CGPoint coordinatePostion = CGPointMake(i,originStruct.y-y*scale);
        // dictionary isn't thread using another serail queue to prevent concurrent access
        dispatch_async(self.serialQueue, ^{
            // Critical section
            int index = (int)i;
            [pointList replaceObjectAtIndex:index withObject:[NSValue valueWithCGPoint: coordinatePostion]];
        });
    });
    dispatch_sync(self.serialQueue, ^{}); // wait all task in serial queue to be done4
    [self drawPath:context withPoints:pointList];        
}



- (void)drawRect:(CGRect)rect
{
    
    if(self.drawMode==2){
        [self draw2];
    }else if(self.drawMode==3){
        [self draw3];
        self.imageView.image = nil;
    }else{
        [self draw1];        
        self.imageView.image = nil;
    }
    
}


@end
