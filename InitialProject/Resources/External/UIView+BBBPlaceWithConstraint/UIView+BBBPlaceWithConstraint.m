#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "UIView+BBBPlaceWithConstraint.h"

@implementation UIView(BBBPlaceWithConstraint)

+ (NSArray<NSLayoutConstraint *>*)placeView:(UIView*)view onOtherView:(UIView*)otherView {
    NSLayoutConstraint * (^topConstraint)(void) = ^NSLayoutConstraint *(void) {
        return [NSLayoutConstraint constraintWithItem:otherView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    };
    NSLayoutConstraint * (^bottomConstraint)(void) = ^NSLayoutConstraint *(void) {
        return [NSLayoutConstraint constraintWithItem:otherView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    };
    NSLayoutConstraint * (^leftConstraint)(void) = ^NSLayoutConstraint *(void) {
        return [NSLayoutConstraint constraintWithItem:otherView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    };
    NSLayoutConstraint * (^rightConstraint)(void) = ^NSLayoutConstraint *(void) {
        return [NSLayoutConstraint constraintWithItem:otherView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    };
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    return @[topConstraint(), bottomConstraint(), leftConstraint(), rightConstraint()];
}

@end
