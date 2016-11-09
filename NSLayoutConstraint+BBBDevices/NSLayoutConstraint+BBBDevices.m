#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "NSLayoutConstraint+BBBDevices.h"
#import "DeviceOperations.h"
#import <objc/runtime.h>

@implementation NSLayoutConstraint(BBBDevices)

#pragma mark - Properties

- (void)setIPhone4Constants:(CGFloat)iPhone4Constants {
    objc_setAssociatedObject(self,   @selector(iPhone4Constants), @(iPhone4Constants), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([DeviceOperations deviceModel] == DeviceModelIPhone4) {
        self.constant = iPhone4Constants;
    }
}

- (void)setIPhone5Constants:(CGFloat)iPhone5Constants {
    objc_setAssociatedObject(self,   @selector(iPhone5Constants), @(iPhone5Constants), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([DeviceOperations deviceModel] == DeviceModelIPhone5) {
        self.constant = iPhone5Constants;
    }
}

- (void)setIPhone6Constants:(CGFloat)iPhone6Constants {
    objc_setAssociatedObject(self,   @selector(iPhone6Constants), @(iPhone6Constants), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([DeviceOperations deviceModel] == DeviceModelIPhone6) {
        self.constant = iPhone6Constants;
    }
}

- (void)setIPhone6PlusConstants:(CGFloat)iPhone6PlusConstants {
    objc_setAssociatedObject(self,   @selector(iPhone6PlusConstants), @(iPhone6PlusConstants), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([DeviceOperations deviceModel] == DeviceModelIPhone6plus) {
        self.constant = iPhone6PlusConstants;
    }
}

- (void)setIPadConstants:(CGFloat)iPadConstants {
    objc_setAssociatedObject(self,   @selector(iPadConstants), @(iPadConstants), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([DeviceOperations deviceModel] == DeviceModelIPad) {
        self.constant = iPadConstants;
    }
}

- (void)setIPadProConstants:(CGFloat)iPadProConstants {
    objc_setAssociatedObject(self,   @selector(iPadProConstants), @(iPadProConstants), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([DeviceOperations deviceModel] == DeviceModelIPadPro) {
        self.constant = iPadProConstants;
    }
}

- (CGFloat)iPhone4Constants {
    return [objc_getAssociatedObject(self, @selector(iPhone4Constants)) floatValue];
}

- (CGFloat)iPhone5Constants {
    return [objc_getAssociatedObject(self, @selector(iPhone5Constants)) floatValue];
}

- (CGFloat)iPhone6Constants {
    return [objc_getAssociatedObject(self, @selector(iPhone6Constants)) floatValue];
}

- (CGFloat)iPhone6PlusConstants {
    return [objc_getAssociatedObject(self, @selector(iPhone6PlusConstants)) floatValue];
}

- (CGFloat)iPadConstants {
    return [objc_getAssociatedObject(self, @selector(iPadConstants)) floatValue];
}

- (CGFloat)iPadProConstants {
    return [objc_getAssociatedObject(self, @selector(iPadProConstants)) floatValue];
}
@end
