#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "BBBAnimatingTableView.h"
#import "PRTween.h"

@interface BBBAnimatingTableView()
@property (nonatomic, strong) PRTweenOperation *activeTweenOperation;
@end

@implementation BBBAnimatingTableView

#pragma mark - Override

- (void) doAnimatedScrollTo:(CGPoint)destinationOffset duration:(CGFloat)duration {
    CGPoint offset = [self contentOffset];
    
    self.activeTweenOperation = [PRTweenCGPointLerp lerp:self property:@"contentOffset" from:offset to:destinationOffset duration:duration];
}

@end
