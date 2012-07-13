//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Henry Tsai on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *thingsSendToBrainLabel;
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (nonatomic) BOOL userIsIntTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userIsIntTheMiddleOfEnteringAVariable;
@property (weak, nonatomic) IBOutlet UILabel *variablesLabel;
@property (strong, nonatomic) CalculatorBrain *brain;
@property (strong, nonatomic) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController

@synthesize thingsSendToBrainLabel = _thingsSendToBrainLabel;
@synthesize display = _display;
@synthesize userIsIntTheMiddleOfEnteringANumber = _userIsIntTheMiddleOfEnteringANumber;
@synthesize userIsIntTheMiddleOfEnteringAVariable = _userIsIntTheMiddleOfEnteringAVariable;
@synthesize variablesLabel = _variablesLabel;
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
    self.variablesLabel.text = @"";
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

- (IBAction)testButtonClicked:(UIButton *)sender {
    if([sender.currentTitle isEqualToString:@"Test 1"]){
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:1], @"a", 
                                   [NSNumber numberWithInt:2], @"b",
                                   [NSNumber numberWithInt:3], @"x",
                                   nil];
    }else if([sender.currentTitle isEqualToString:@"Test 2"]){
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithDouble:1.2], @"a", 
                                   [NSNumber numberWithDouble:2.2], @"b",
                                   [NSNumber numberWithInt:0], @"x",
                                   nil];
    }else if([sender.currentTitle isEqualToString:@"Test 3"]){
        self.testVariableValues = nil;
    }
    self.display.text = [NSString stringWithFormat:@"%g",[CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues]];
    [self updateVariablesLabel];
}

- (void) updateVariablesLabel{
    self.variablesLabel.text = @"";
    if(self.testVariableValues==nil || [CalculatorBrain variablesUsedInProgram:self.brain.program] == nil){
        self.variablesLabel.text = @"";
    }else{
        for (id object in [CalculatorBrain variablesUsedInProgram:self.brain.program]) {
            NSString *key = object;
            NSString *value = [[self.testVariableValues valueForKey:key] description];
            self.variablesLabel.text = [self.variablesLabel.text stringByAppendingString:[NSString stringWithFormat:@"%@=%@ ",key,value]];
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
    [self updateVariablesLabel];
}

- (void)viewDidUnload {
    [self setThingsSendToBrainLabel:nil];
    [self setVariablesLabel:nil];
    [super viewDidUnload];
}


@end
