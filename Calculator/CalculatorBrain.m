
#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
+ (BOOL)shouldAddParentheses:(NSString*)program;
@end

@implementation CalculatorBrain

static NSSet *_operationStringSet;

@synthesize programStack = _programStack;


- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void) clearStack{
    [self.programStack removeAllObjects];
}

- (id)program
{
    return [self.programStack copy];
}

+(NSSet*) operationStringSet
{
    if (_operationStringSet == nil)
    {
        _operationStringSet = [NSSet setWithObjects:@"+",@"-",@"*",@"/",@"π",@"sin",@"cos",@"sqrt", nil];         
    }
    return _operationStringSet;
}

+ (BOOL)isOpertion:(id)token{
    BOOL result = false;
    if ([token isKindOfClass:[NSNumber class]])
    {
        result = false;
    }
    else if ([token isKindOfClass:[NSString class]])
    {
        if([[CalculatorBrain operationStringSet] containsObject:token]){
            result = true;
        }
    }
    return result;
}

+ (BOOL)shouldAddParentheses:(NSString*)program{
    BOOL result = false;
    if([program length]>1 && ([program rangeOfString:@"+"].location != NSNotFound || [program rangeOfString:@"-"].location != NSNotFound)){
        result = true;
    }
    return result;
}

+ (NSString*)popDescriptionOffStack:(NSMutableArray *)stack
{
    NSString *result = @"";    
    id descriptionOfTopOfStack = [stack lastObject];
    if (descriptionOfTopOfStack) [stack removeLastObject];
    if ([descriptionOfTopOfStack isKindOfClass:[NSNumber class]]){
        result = [descriptionOfTopOfStack description];
    }else if([descriptionOfTopOfStack isKindOfClass:[NSString class]] && ![self isOpertion:descriptionOfTopOfStack]){
        result = [descriptionOfTopOfStack description];        
    }else if ([descriptionOfTopOfStack isKindOfClass:[NSString class]]){
        NSString *operation = descriptionOfTopOfStack;
        if ([operation isEqualToString:@"+"]) {
            NSString *fristPop = [self popDescriptionOffStack:stack];
            NSString *secPop = [self popDescriptionOffStack:stack];
            result = [NSString stringWithFormat:@"%@+%@",secPop,fristPop];
        } else if ([@"*" isEqualToString:operation]) {
            NSString *fristPop = [self popDescriptionOffStack:stack];
            NSString *secPop = [self popDescriptionOffStack:stack];
            // add ( ) if needed
            if([[self class]shouldAddParentheses:fristPop]){ 
                fristPop = [NSString stringWithFormat:@"(%@)",fristPop];
            }
            if([[self class]shouldAddParentheses:secPop]){ 
                secPop = [NSString stringWithFormat:@"(%@)",secPop];
            }
            result = [NSString stringWithFormat:@"%@*%@",secPop,fristPop];                
        } else if ([operation isEqualToString:@"-"]) {
            NSString *fristPop = [self popDescriptionOffStack:stack];
            NSString *secPop = [self popDescriptionOffStack:stack];
            result = [NSString stringWithFormat:@"%@-%@",secPop,fristPop];
        } else if ([operation isEqualToString:@"/"]) {
            NSString *fristPop = [self popDescriptionOffStack:stack];
            NSString *secPop = [self popDescriptionOffStack:stack];
            // add ( ) if needed            
            if([[self class]shouldAddParentheses:fristPop]){
                fristPop = [NSString stringWithFormat:@"(%@)",fristPop];
            }
            if([[self class]shouldAddParentheses:secPop]){ 
                secPop = [NSString stringWithFormat:@"(%@)",secPop];
            }            
            result = [NSString stringWithFormat:@"%@/%@",secPop,fristPop];
        } else if([@"π" isEqualToString:operation]){
            NSString *fristPop = [self popDescriptionOffStack:stack];
            result = [NSString stringWithFormat:@"%@π",fristPop]; 
        } else if([@"sin" isEqualToString:operation]){
            NSString *fristPop = [self popDescriptionOffStack:stack];
            result = [NSString stringWithFormat:@"sin(%@)",fristPop]; 
        } else if([@"cos" isEqualToString:operation]){
            NSString *fristPop = [self popDescriptionOffStack:stack];
            result = [NSString stringWithFormat:@"cos(%@)",fristPop];      
        } else if([@"sqrt" isEqualToString:operation]){
            NSString *fristPop = [self popDescriptionOffStack:stack];
            result = [NSString stringWithFormat:@"sqrt(%@)",fristPop]; 
        }
    }
    return result;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSString *result = @"";
    if([program isKindOfClass:[NSArray class]]){
        NSMutableArray *mutableProgram = [program mutableCopy];
        while([mutableProgram count]>0){
            result = [result stringByAppendingString:[self popDescriptionOffStack:mutableProgram]];
            result = [result stringByAppendingString:@", "];
        }
        if([result hasSuffix:@", "]){
            result = [result substringToIndex:[result length]-2];
        }
    }
    return result;
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
    //NSLog(@"%@",[self.program description]);    
}

- (void)pushVariable:(NSString*)variable
{
    [self.programStack addObject:variable];
    //NSLog(@"%@",[self.program description]);    
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    //NSLog(@"%@",[self.program description]);    
    return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if([@"π" isEqualToString:operation]){
            result = M_PI*[self popOperandOffProgramStack:stack];   
        } else if([@"sin" isEqualToString:operation]){
            result = sin([self popOperandOffProgramStack:stack]);
        } else if([@"cos" isEqualToString:operation]){
            result = cos([self popOperandOffProgramStack:stack]);      
        } else if([@"sqrt" isEqualToString:operation]){
            result = sqrt([self popOperandOffProgramStack:stack]);   
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program  
 usingVariableValues:(NSDictionary *)variableValues{
    double result = 0;
    if([program isKindOfClass:[NSArray class]]){
        NSMutableArray *programArray = [program mutableCopy];
        // replace varaible with values
        for (id key in variableValues) {
            id value = [variableValues objectForKey:key];
            NSUInteger variableIndexInProgramArray = [programArray indexOfObject:key];
            while(variableIndexInProgramArray != NSNotFound){ // keep replace all variable 
                [programArray replaceObjectAtIndex:variableIndexInProgramArray withObject:value];
                variableIndexInProgramArray = [programArray indexOfObject:key];
            }
        }
        // then run program
        //NSLog(@"running program:%@",[programArray description]);    
        
        result = [self runProgram:programArray];
    }
    return result;
}

+ (NSSet *)variablesUsedInProgram:(id)program{
    NSMutableSet *result;
    if([program isKindOfClass:[NSArray class]]){
        NSArray *programArray = [program copy];
        for (id token in programArray) {
            if([token isKindOfClass:[NSString class]] && ![self isOpertion:token]){
                if(result==nil){
                    result = [[NSMutableSet alloc]init];
                }
                [result addObject:token];
            }
        }
    }    
    return result;
}

@end
