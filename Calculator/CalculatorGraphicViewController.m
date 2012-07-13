//
//  CalculatorGraphicViewController.m
//  Calculator
//
//  Created by Henry Tsai on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorGraphicViewController.h"

@interface CalculatorGraphicViewController ()

@end

@implementation CalculatorGraphicViewController
@synthesize brain = _brain;

- (void)viewDidLoad
{
    [super viewDidLoad];
#pragma mark - ╭━━━━━━━━━━━━━━━━━━━━━━━━━━━╮
#pragma mark - ┃ Gesture Recognizer     {  ┃
#pragma mark - ╰━━━━━━━━━━━━━━━━━━━━━━━━━━━╯
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.view action:@selector(panGestureFired:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:panGesture];   
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self.view action:@selector(pinchGestureFired:)];
    [self.view addGestureRecognizer:pinchGesture];  
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(tapGestureFired:)];    
    [tapGesture setNumberOfTapsRequired:3];
    [tapGesture setNumberOfTouchesRequired:1];  
    [self.view addGestureRecognizer:tapGesture];
    
#pragma mark - ╭━━━━━━━━━━━━━━━━━━━━━━━━━━━╮
#pragma mark - ┃ Gesture Recognizer     {  ┃
#pragma mark - ╰━━━━━━━━━━━━━━━━━━━━━━━━━━━╯

    
}
@end
