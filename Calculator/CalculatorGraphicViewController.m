//
//  CalculatorGraphicViewController.m
//  Calculator
//
//  Created by Henry Tsai on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorGraphicViewController.h"
#import "CalculatorGraphicView.h"

@interface CalculatorGraphicViewController ()<CalculatorGraphicViewDelegate>
@property (strong, nonatomic) NSMutableDictionary *graphic; // my model.
@property (weak,nonatomic) IBOutlet CalculatorGraphicView *calculatorGraphicView;
@property (weak, nonatomic) IBOutlet UILabel *programDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation CalculatorGraphicViewController
@synthesize calculatorGraphicView = _calculatorGraphicView;
@synthesize graphic = _graphic;
@synthesize delegate = _delegate;
@synthesize programDescriptionLabel = _programDescriptionLabel;
@synthesize toolBar = _toolBar;
@synthesize programString = _programString;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolBar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (void) setProgramString:(NSString *)programString
{
    _programString = programString;
    self.programDescriptionLabel.text = _programString;
    [self.graphic removeAllObjects];
    [self.calculatorGraphicView setNeedsDisplay];
}

- (NSDictionary*) graphic
{
    if(_graphic == nil){
        _graphic = [[NSMutableDictionary alloc]init];
    }
    return _graphic;
}

- (CGFloat) getYwithX:(CGFloat)x
{
    
    CGFloat result = 0;
    if(performanceOptimizatiOn){
        NSString *xString = [NSString stringWithFormat:@"%g",x];
        if([self.graphic objectForKey:xString]==nil){
            NSNumber *y = [NSNumber numberWithFloat:[self.delegate getYwithX:x]];
            [self.graphic setValue:y forKey:xString];
        }
        if([[self.graphic objectForKey:xString] isKindOfClass:[NSNumber class]]){
            result = ((NSNumber*)[self.graphic objectForKey:xString]).floatValue;
        }
    }else{
        result = [self.delegate getYwithX:x];
    }
    return result;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    #pragma mark - ╭━━━━━━━━━━━━━━━━━━━━━━━━━━━╮
    #pragma mark - ┃ Gesture Recognizer     {  ┃
    #pragma mark - ╰━━━━━━━━━━━━━━━━━━━━━━━━━━━╯
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calculatorGraphicView action:@selector(panGestureFired:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    [self.calculatorGraphicView addGestureRecognizer:panGesture];   
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self.calculatorGraphicView action:@selector(pinchGestureFired:)];
    [self.calculatorGraphicView addGestureRecognizer:pinchGesture];  
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.calculatorGraphicView action:@selector(tapGestureFired:)];    
    [tapGesture setNumberOfTapsRequired:3];
    [tapGesture setNumberOfTouchesRequired:1];  
    [self.calculatorGraphicView addGestureRecognizer:tapGesture];
    
    #pragma mark - ╭━━━━━━━━━━━━━━━━━━━━━━━━━━━╮
    #pragma mark - ┃ Gesture Recognizer     {  ┃
    #pragma mark - ╰━━━━━━━━━━━━━━━━━━━━━━━━━━━╯
    self.calculatorGraphicView.delegate = self;
    self.programDescriptionLabel.text = self.programString;
    self.calculatorGraphicView.contentMode = UIViewContentModeRedraw; // make sure content redraw when orientation change, or it would just scale to new size
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidUnload 
{
    [self setProgramDescriptionLabel:nil];
    [self setToolBar:nil];
    [super viewDidUnload];
}
@end
