#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "UIView+BBBCutHole.h"

@implementation UIView(BBBCutHole)

    - (void)BBB_cutHoleForPath:(UIBezierPath*)path {
        CAShapeLayer *maskLayer = [CAShapeLayer new];
        maskLayer.frame = self.bounds;
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect: self.bounds];
        maskLayer.fillRule = kCAFillRuleEvenOdd;
        [maskPath appendPath:path];
        maskLayer.path = maskPath.CGPath;
        
        self.layer.mask = maskLayer;
    }
    
@end
