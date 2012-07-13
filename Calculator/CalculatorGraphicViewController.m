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


- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

@end
