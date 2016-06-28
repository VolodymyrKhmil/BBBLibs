
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeviceModel) {
    DeviceModelIPhone4 = 0,
    DeviceModelIPhone5,
    DeviceModelIPhone6,
    DeviceModelIPhone6plus,
    DeviceModelIPad,
    DeviceModelIPadPro
};

@interface DeviceOperations : NSObject

+ (BOOL)hasLaunchedOnce;
+ (BOOL)isStagingEnvironmentUsing;
+ (DeviceModel)deviceModel;
+ (BOOL)isIPadPro;
+ (BOOL)isIPad;
+ (BOOL)isIPhone4;

@end
