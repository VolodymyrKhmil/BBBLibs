#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "BBBCheckPointsInsideView.h"

@implementation BBBCheckPointsInsideView

#pragma mark - Override

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL isInside = NO;
    for (UIView *view in self.subviews) {
        CGPoint transformedPoint = CGPointMake(point.x - view.frame.origin.x, point.y - view.frame.origin.y);
        isInside |= [view pointInside:transformedPoint withEvent:event];
    }
    
    return isInside;
}

@end
