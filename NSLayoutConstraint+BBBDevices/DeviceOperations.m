#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "DeviceOperations.h"

@implementation DeviceOperations

+ (BOOL)hasLaunchedOnce {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        return YES;
    }

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return NO;
}

+ (BOOL)isStagingEnvironmentUsing {
    return [SQORD_ACTIVESERVER isEqualToString:SQORD_STAGING];
}

+ (DeviceModel)deviceModel {
    static DeviceModel _deviceModel = -1;

    if (_deviceModel != (DeviceModel)-1) {
        return _deviceModel;
    }

    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;

    if (screenHeight == 414) {
        _deviceModel = DeviceModelIPhone6plus;
    } else if (screenHeight == 768) {
        _deviceModel = DeviceModelIPad;
    } else if (screenHeight == 320 && screenWidth == 480) {
        _deviceModel = DeviceModelIPhone4;
    } else if (screenHeight == 320) {
        _deviceModel = DeviceModelIPhone5;
    } else if ([DeviceOperations isIPadPro]) {
        //_deviceModel = DeviceModelIPadPro; // TODO: add support of iPad Pro
        _deviceModel = DeviceModelIPad;
    } else {
        _deviceModel = DeviceModelIPhone6;
    }

    return _deviceModel;
}

+ (BOOL)isIPadPro {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    return screenHeight == 1024 && screenWidth == 1366;
}

+ (BOOL)isIPad {
    return [@[@(DeviceModelIPad), @(DeviceModelIPadPro)] containsObject:@(DeviceOperations.deviceModel)];
}

+ (BOOL)isIPhone4 {
    return [@[@(DeviceModelIPhone4)] containsObject:@(DeviceOperations.deviceModel)];
}

@end
