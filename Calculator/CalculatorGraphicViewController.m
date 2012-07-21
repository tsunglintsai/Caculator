//
//  CalculatorGraphicViewController.m
//  Calculator
//
//  Created by Henry Tsai on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorGraphicViewController.h"
#import "CalculatorGraphicView.h"
#import "CalculatorBrain.h"

@interface CalculatorGraphicViewController ()<CalculatorGraphicViewDataSource>
@property (strong, nonatomic) NSMutableDictionary *graphic; // my model.
@property (weak,nonatomic) IBOutlet CalculatorGraphicView *calculatorGraphicView;
@property (weak, nonatomic) IBOutlet UILabel *programDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *drawModeString;
@end

@implementation CalculatorGraphicViewController
@synthesize calculatorGraphicView = _calculatorGraphicView;
@synthesize graphic = _graphic;
@synthesize programDescriptionLabel = _programDescriptionLabel;
@synthesize toolBar = _toolBar;
@synthesize drawModeString = _drawModeString;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize program = _program;

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

- (void)setProgram:(id)program{
    _program = program;
    [self.calculatorGraphicView setNeedsDisplay];
    self.programDescriptionLabel.text = [NSString stringWithFormat:@"y=%@", [CalculatorBrain descriptionOfProgram:self.program]];    
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
            NSDictionary *variableMappings = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:x] forKey:@"x"];
            NSNumber *y = [NSNumber numberWithFloat:[CalculatorBrain runProgram:self.program usingVariableValues:variableMappings]];
            [self.graphic setValue:y forKey:xString];
        }
        if([[self.graphic objectForKey:xString] isKindOfClass:[NSNumber class]]){
            result = ((NSNumber*)[self.graphic objectForKey:xString]).floatValue;
        }
    }else{
        NSDictionary *variableMappings = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:x] forKey:@"x"];
        result = [CalculatorBrain runProgram:self.program usingVariableValues:variableMappings];
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
    self.calculatorGraphicView.datasource = self;
    self.programDescriptionLabel.text = [NSString stringWithFormat:@"y=%@", [CalculatorBrain descriptionOfProgram:self.program]];
    self.calculatorGraphicView.contentMode = UIViewContentModeRedraw; // make sure content redraw when orientation change, or it would just scale to new size
}

- (IBAction)setDrawModeButtonClicked:(UIButton*)sender {
    if([sender.currentTitle isEqualToString:@"1"]){
        self.calculatorGraphicView.drawMode = 1;
        self.drawModeString.text = @"1"; 
    }else if([sender.currentTitle isEqualToString:@"2"]){
        self.calculatorGraphicView.drawMode = 2;
        self.drawModeString.text = @"2"; 
    }else if([sender.currentTitle isEqualToString:@"3"]){
        self.calculatorGraphicView.drawMode = 3;
        self.drawModeString.text = @"3"; 
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidUnload 
{
    [self setProgramDescriptionLabel:nil];
    [self setToolBar:nil];
    [self setDrawModeString:nil];
    [super viewDidUnload];
}
@end
