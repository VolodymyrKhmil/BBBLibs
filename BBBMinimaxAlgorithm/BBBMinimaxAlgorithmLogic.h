
#import <Foundation/Foundation.h>

#import <Availability.h>
#undef weak_ref
#if __has_feature(objc_arc) && __has_feature(objc_arc_weak)
#define weak_ref weak
#else
#define weak_ref unsafe_unretained
#endif

@class BBBMinimaxAlgorithmLogic;

@protocol BBBMinimaxAlgorithmLogicDataSource <NSObject>

@required
- (NSInteger)evaluateForAlgorithm:(nonnull BBBMinimaxAlgorithmLogic*)algorithm onAITurn:(BOOL)aiTurn;
- (BOOL)checkStopConditionForAlgorithm:(nonnull BBBMinimaxAlgorithmLogic*)algorithm onAITurn:(BOOL)aiTurn;
- (nonnull NSArray*)possibleNextStatesForAlgorithm:(nonnull BBBMinimaxAlgorithmLogic*)algorithm onAITurn:(BOOL)aiTurn;

@end

@protocol BBBMinimaxAlgorithmLogicDelegate <NSObject>

- (void)performActionForAlgorithm:(nonnull BBBMinimaxAlgorithmLogic*)algorithm andState:(nonnull id)state onAITurn:(BOOL)aiTurn;
- (void)undoActionForAlgorithm:(nonnull BBBMinimaxAlgorithmLogic*)algorithm andState:(nonnull id)state onAITurn:(BOOL)aiTurn;

@end

@interface BBBMinimaxAlgorithmLogic : NSObject

@property(weak_ref, nonatomic) id<BBBMinimaxAlgorithmLogicDataSource> datasource;
@property(weak_ref, nonatomic) id<BBBMinimaxAlgorithmLogicDelegate> delegate;
@property(nonatomic) NSUInteger searchingDeapth;
@property(strong, nonatomic) id assignedData;
@property(nonatomic, readonly) NSUInteger currentCheckingDepth;

- (NSUInteger)startAlgorithmWithAITurn:(BOOL)aiTurn;

@end
