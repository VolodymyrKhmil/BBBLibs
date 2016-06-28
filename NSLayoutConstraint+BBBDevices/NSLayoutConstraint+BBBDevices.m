#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "NSLayoutConstraint+BBBDevices.h"
#import "DeviceOperations.h"

@implementation NSLayoutConstraint(BBBDevices)

#pragma mark - Properties

- (void)setIPhone4Constants:(CGFloat)iPhone4Constants {
    if ([DeviceOperations deviceModel] == DeviceModelIPhone4) {
        self.constant = iPhone4Constants;
    }
}

- (void)setIPhone5Constants:(CGFloat)iPhone5Constants {
    if ([DeviceOperations deviceModel] == DeviceModelIPhone5) {
        self.constant = iPhone5Constants;
    }
}

- (void)setIPhone6Constants:(CGFloat)iPhone6Constants {
    if ([DeviceOperations deviceModel] == DeviceModelIPhone6) {
        self.constant = iPhone6Constants;
    }
}

- (void)setIPhone6PlusConstants:(CGFloat)iPhone6PlusConstants {
    if ([DeviceOperations deviceModel] == DeviceModelIPhone6plus) {
        self.constant = iPhone6PlusConstants;
    }
}

- (void)setIPadConstants:(CGFloat)iPadConstants {
    if ([DeviceOperations deviceModel] == DeviceModelIPad) {
        self.constant = iPadConstants;
    }
}

- (CGFloat)iPhone4Constants {
    return self.constant;
}

- (CGFloat)iPhone5Constants {
    return self.constant;
}

- (CGFloat)iPhone6Constants {
    return self.constant;
}

- (CGFloat)iPhone6PlusConstants {
    return self.constant;
}

- (CGFloat)iPadConstants {
    return self.constant;
}

@end
