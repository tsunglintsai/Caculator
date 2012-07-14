//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Henry Tsai on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "CalculatorGraphicViewController.h"

@interface CalculatorViewController ()<CalculatorGraphicViewDelegateDelegate>
@property (weak, nonatomic) IBOutlet UILabel *thingsSendToBrainLabel;
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (nonatomic) BOOL userIsIntTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userIsIntTheMiddleOfEnteringAVariable;
@property (strong, nonatomic) CalculatorBrain *brain;
@property (strong, nonatomic) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController

@synthesize thingsSendToBrainLabel = _thingsSendToBrainLabel;
@synthesize display = _display;
@synthesize userIsIntTheMiddleOfEnteringANumber = _userIsIntTheMiddleOfEnteringANumber;
@synthesize userIsIntTheMiddleOfEnteringAVariable = _userIsIntTheMiddleOfEnteringAVariable;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (CalculatorBrain*)brain{
    if(!_brain){
        _brain = [[CalculatorBrain alloc]init];
    }
    return _brain;
}

- (IBAction)dotPressed:(UIButton *)sender {
    if(self.userIsIntTheMiddleOfEnteringANumber){
        if(!([self.display.text rangeOfString:@"."].length>0)){ // check if more than one dot
            [self digitPressed:sender]; 
        }
    }else{// if .5 case
        self.display.text = @"0.";
        self.userIsIntTheMiddleOfEnteringANumber = YES;        
    }
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if(self.userIsIntTheMiddleOfEnteringAVariable){
        [self enterPressed:sender];
    }
    if(self.userIsIntTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];
        self.userIsIntTheMiddleOfEnteringAVariable = NO;
    }else{
        self.display.text = digit;
        self.userIsIntTheMiddleOfEnteringANumber = YES;
        self.userIsIntTheMiddleOfEnteringAVariable = NO;
    }
    self.thingsSendToBrainLabel.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)clearEverthingButtonClicked:(id)sender {
    self.thingsSendToBrainLabel.text = @"";
    self.display.text = @"0";
    [self.brain clearStack];
    self.testVariableValues = nil; 
    self.userIsIntTheMiddleOfEnteringANumber = NO;    
}

- (IBAction)variableButtonClicked:(UIButton *)sender {
    NSString *variable = [sender currentTitle];
    if(self.userIsIntTheMiddleOfEnteringANumber || self.userIsIntTheMiddleOfEnteringAVariable){
        [self enterPressed:sender];
        self.display.text = variable;
        self.userIsIntTheMiddleOfEnteringANumber = NO;
        self.userIsIntTheMiddleOfEnteringAVariable = YES;
    }else{
        self.display.text = variable;
        self.userIsIntTheMiddleOfEnteringANumber = NO;
        self.userIsIntTheMiddleOfEnteringAVariable = YES;
    }
    self.thingsSendToBrainLabel.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)enterPressed:(id)sender {
    if([self.display.text doubleValue]){
        [self.brain pushOperand:[self.display.text doubleValue]];
    }else{
        [self.brain pushVariable:self.display.text];        
    }
    // for item 4. shows everything added to brain    
    self.userIsIntTheMiddleOfEnteringANumber = NO;
    self.userIsIntTheMiddleOfEnteringAVariable = NO;    
    self.thingsSendToBrainLabel.text = [CalculatorBrain descriptionOfProgram:self.brain.program];        
}

- (IBAction)undoButtonClicked:(id)sender {
    if([self.display.text length]>0){
        self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
        if([self.display.text length]==0){
            self.userIsIntTheMiddleOfEnteringANumber = NO;
            self.userIsIntTheMiddleOfEnteringAVariable = NO;      
            self.display.text = [NSString stringWithFormat:@"%g",[[self.brain class] runProgram:self.brain.program]];
        }
    }
}


- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsIntTheMiddleOfEnteringANumber || self.userIsIntTheMiddleOfEnteringAVariable) {
        [self enterPressed:sender];
    };
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g",result];
    self.display.text = resultString;
    self.thingsSendToBrainLabel.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"graphicView4Segues"]) {
        CalculatorGraphicViewController *graphicViewController = segue.destinationViewController;
        graphicViewController.delegate = self;
        graphicViewController.programString = [CalculatorBrain descriptionOfProgram:self.brain.program];
        NSLog(@"%@",graphicViewController.programString);
    }
}

- (CGFloat) getYwithX:(CGFloat)x{
    NSDictionary *variableMappings = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:x] forKey:@"x"];
    double result = [[self.brain class] runProgram:self.brain.program usingVariableValues:variableMappings];
    return result;
}

- (void)viewDidUnload {
    [self setThingsSendToBrainLabel:nil];
    [super viewDidUnload];
}

@end
