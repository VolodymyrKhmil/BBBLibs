
#import "BBBMinimaxAlgorithmLogic.h"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

@interface BBBMinimaxAlgorithmLogic()

@property(nonatomic) NSUInteger currentCheckingDepth;

@end

@implementation BBBMinimaxAlgorithmLogic

#pragma mark - Initializers

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        _searchingDeapth = -1;
        _currentCheckingDepth = 0;
    }
    
    return self;
}

#pragma mark - Public

- (NSUInteger)startAlgorithmWithAITurn:(BOOL)aiTurn; {
    return [self alphabetaAlgorithm:_searchingDeapth alpha:NSIntegerMin beta:NSIntegerMax maximizing:aiTurn];
}

#pragma mark - Private

- (NSInteger)alphabetaAlgorithm:(NSInteger)depth alpha:(NSInteger)alpha beta:(NSInteger)beta maximizing:(BOOL)maximizing {
    
    self.currentCheckingDepth = _searchingDeapth - depth;
    
    if (self.datasource == nil || self.delegate == nil) {
        return 0;
    }
    
    if (depth == 0 || [self.datasource checkStopConditionForAlgorithm:self onAITurn:maximizing]) {
        return [self.datasource evaluateForAlgorithm:self onAITurn:maximizing];
    }
    
    NSArray *nextStates = [self.datasource possibleNextStatesForAlgorithm:self onAITurn:maximizing];
    
    for (id state in nextStates) {
        
        [self.delegate performActionForAlgorithm:self andState:state onAITurn:maximizing];
        
        if (maximizing) {
            alpha = MAX(alpha, [self alphabetaAlgorithm:depth - 1 alpha:alpha beta:beta maximizing:NO]);
        } else {
            beta = MIN(beta, [self alphabetaAlgorithm:depth - 1 alpha:alpha beta:beta maximizing:YES]);
        }
        
        [self.delegate undoActionForAlgorithm:self andState:state onAITurn:maximizing];
        
        if (beta <= alpha) {
            break;
        }
    }
    
    return (maximizing ? alpha : beta);
}

@end
