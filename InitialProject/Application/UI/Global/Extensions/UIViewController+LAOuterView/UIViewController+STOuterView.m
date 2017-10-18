#import "UIViewController+STOuterView.h"
#import <objc/runtime.h>
#import "UIView+BBBPlaceWithConstraint.h"

@implementation UIViewController(LAOuterView)

@dynamic LA_outerView;

- (void)setLA_outerView:(UIView*)LA_outerView {
    [self.LA_outerView removeFromSuperview];
    [self.view insertSubview:LA_outerView atIndex:0];
    [self.view addConstraints:[UIView placeView:LA_outerView onOtherView:self.view]];
    objc_setAssociatedObject(self, @selector(LA_outerView), LA_outerView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView*)LA_outerView {
    return objc_getAssociatedObject(self, @selector(LA_outerView));
}


@end
